# Fachwissen zu den externen Systemen

Gesammelt bei einer ersten Prototyp-Implementierung. Dient als Wissensquelle und für
Akzeptanzkriterien – nicht als Bauplan. Der Mentor bringt die Punkte ein, wenn die
passende Story dran ist.

## Nanoleaf OpenAPI (nur lokal!)

- Nur im lokalen Netz erreichbar: `http://<ip>:16021/api/v1/…`, unverschlüsseltes HTTP.
  Keine öffentliche Cloud-API → die App muss im selben Netz wie die Panels laufen.
- **Koppeln:** Ein/Aus-Knopf am Controller 5–7 s halten, bis die LEDs blinken; dann
  innerhalb von 30 s `POST /api/v1/new` → `{ "auth_token": "…" }`. Sonst HTTP 403.
- Alle weiteren Aufrufe: `/api/v1/<token>/…`; falscher Token → 401.
- **Layout:** `GET /panelLayout/layout` → `positionData: [{ panelId, x, y, o, shapeType }]`.
  Shape-Typen ohne LEDs herausfiltern (laut Doku u. a. 1 = Rhythm, 12 = Shapes-Controller,
  16/19/20 = Verbinder/Kappen/Stromanschluss). Triangles = 8, Mini-Triangles = 9.
- **Ein/Aus:** `PUT /state` mit `{ "on": { "value": true } }`.
- **Effekt schreiben:** `PUT /effects` mit
  `{ "write": { "command": "display", "animType": "static" | "custom", "animData": "…", "loop": true|false, "palette": [] } }`
- **animData-Format** (Leerzeichen-getrennt):
  `<Anzahl Panels> { <panelId> <Anzahl Frames> { R G B W T } … } …`
  T = Übergangszeit in Zehntelsekunden, W = 0.
  - statisch: 1 Frame je Panel, `animType: static`
  - Pulsieren: 2 Frames je Panel (hell, dunkel), `animType: custom`, `loop: true` –
    der Controller pulsiert dann selbstständig, die App muss nichts nachsenden.
  - Beispiel rot pulsierend, 2 Panels: `2 5 2 255 0 0 0 4 12 0 0 0 4 6 2 255 0 0 0 4 12 0 0 0 4`
- Bewährte Werte im Prototyp: grün `0 255 40`; blau hell `0 90 255` / dunkel `0 22 70`,
  T = 15; rot hell `255 0 0` / dunkel `12 0 0`, T = 4; unbekannt `70 28 0`.
- ⚠️ Noch nicht an echter Hardware geprüft – Story 2 klärt das.

## CircleCI-API v2

- Basis `https://circleci.com/api/v2`, Header `Circle-Token: <token>`.
- Projekt-Slug für die API: `gh/<org>/<repo>` (GitHub-URLs entsprechend umwandeln).
- `GET /project/<slug>/pipeline?branch=main` → `items` (neueste zuerst), mit
  `id`, `number`, `state`, `created_at`, `vcs.revision`, `vcs.branch`, `vcs.commit.subject`.
- `GET /pipeline/<id>/workflow` → `items` mit `name`, `status`.
- **Auswertung:**
  - irgendein Workflow `failed`, `error`, `failing`, `unauthorized` → fehlgeschlagen
    (`failing` = ein Job ist rot, andere laufen noch → früh rot zeigen)
  - sonst irgendeiner `running` oder `on_hold` → läuft
  - sonst → erfolgreich
  - Pipeline-`state` = `errored` (z. B. kaputte config.yml) → fehlgeschlagen
  - alle Workflows `canceled` oder Pipeline ohne Workflows (älter als ein paar Minuten)
    → überspringen, nächstältere Pipeline nehmen
- Fehler: 401 = Token fehlt/ungültig, 404 = Projekt nicht gefunden oder kein Zugriff.
- Link für Menschen: `https://app.circleci.com/pipelines/github/<org>/<repo>/<number>`

## Webhooks

### GitHub (Start-Signal → blau)

- Header `X-GitHub-Event: push` (beim Einrichten erst `ping`).
- Signatur: `X-Hub-Signature-256: sha256=<hex HMAC-SHA256(secret, rohe Body-Bytes)>`.
- Content type im Webhook auf `application/json` stellen (sonst Form-encoded mit `payload=`).
- Felder: `ref` (`refs/heads/main`), `after` (Commit-SHA), `deleted`,
  `repository.full_name`, `head_commit.message`.

### CircleCI (Ende → grün/rot)

- Es gibt nur `workflow-completed` und `job-completed` – **kein Start-Ereignis**.
- Header `circleci-event-type`, Signatur `circleci-signature: v1=<hex HMAC-SHA256>`
  (kann mehrere kommagetrennte Versionen enthalten; v1 prüfen).
- Nur HTTPS-Ziel-URLs erlaubt; Einrichten braucht Org-Admin-Rechte.
- Felder: `workflow.status` (`success`, `failed`, `error`, `canceled`, `unauthorized`),
  `workflow.name`, `workflow.url`, `pipeline.number`, `pipeline.vcs.revision`,
  `pipeline.vcs.branch`, `pipeline.vcs.commit.subject`, `project.slug`.
- Slug im Webhook ist `github/<org>/<repo>` (nicht `gh/…`). Bei GitHub-App-Projekten
  `circleci/<uuid>/<uuid>` – dann über `pipeline.vcs.*_repository_url` bzw.
  `pipeline.trigger_parameters.git.repo_url` zuordnen.

### smee.io (Webhooks ohne offenen Port)

- GitHub und CircleCI schicken an `https://smee.io/<kanal>`; die App liest denselben
  Kanal per GET mit **genau** `Accept: text/event-stream` (Server-Sent Events).
- Ereignisse: `ready` beim Verbinden, `ping` alle 30 s; Nachrichten ohne Ereignisname
  enthalten in `data` ein JSON mit den Original-Headern (kleingeschrieben) plus `body`
  (bereits geparst), `query`, `timestamp`.
- Einen Kanal kann man sich ausdenken (zufälliger Name genügt).
- Signatur: smee liefert keine rohen Bytes → Body kompakt neu serialisieren
  (`JSON.generate`), so wie das offizielle smee-client-Tool. Klappt das nicht, Secret leer
  lassen. Kanal-URL nicht teilen (im Browser mitlesbar).

## Stolpersteine (gute Testfälle!)

- **Ältere Ergebnisse dürfen Blau nicht beenden:** Push A, Push B, dann kommt das Ergebnis
  von A → weiter blau, bis B fertig ist. Also den erwarteten SHA merken.
- **API hinkt hinterher:** Direkt nach einem Push kennt die API die neue Pipeline evtl.
  noch nicht und meldet das alte Ergebnis → ignorieren, solange auf einen anderen SHA
  gewartet wird.
- **Nachprüfung nach Webhook:** Kurz nach `workflow-completed` per API nachsehen (es
  könnte weitere Workflows geben) – aber nie auf eine ältere Pipeline-Nummer
  zurückfallen und einen abgeschlossenen Commit nicht wieder auf „läuft“ setzen.
- **Push ohne Build** (`[skip ci]`, kein CircleCI): nach ~20 min Wartezeit wieder der API glauben.
- `canceled` sagt nichts über Erfolg → API fragen.
- Gelöschte Branches (`deleted: true`) und andere Branches ignorieren.
- Laptop schläft / Prozess wird hart beendet → Licht bleibt stehen; dagegen hilft nur
  das Ausschalten beim regulären Beenden.
- Kursraum-WLAN: Client-Isolation verhindert oft den Zugriff aufs Nanoleaf
  → eigener Reiserouter.
