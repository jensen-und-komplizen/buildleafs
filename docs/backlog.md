# Backlog

Reihenfolge = Priorität. Jede Story erfüllt INVEST (Bill Wake,
[INVEST in Good Stories, and SMART Tasks](https://xp123.com/articles/invest-in-good-stories-and-smart-tasks/))
und bringt dem Trainer einen sichtbaren Mehrwert – geschnitten als vertikale Scheibe,
nicht als technische Schicht. Erst ein dünner Durchstich vom echten Build-Status bis zu
den Dreiecken, dann verbreitern.

*Geschnitten nach* nennt das Schnittmuster. Quellen:
- **SPIDR** (Spikes, Paths, Interfaces, Data, Rules) – Mike Cohn,
  [SPIDR: Five Simple but Powerful Ways to Split User Stories](https://www.mountaingoatsoftware.com/blog/five-simple-but-powerful-ways-to-split-user-stories)
- **Simple/Complex, Business Rule Variations, Operations** – Richard Lawrence, Peter Green,
  [The Humanizing Work Guide to Splitting User Stories](https://www.humanizingwork.com/the-humanizing-work-guide-to-splitting-user-stories/)

*Lernziele* helfen dem Mentor, Schwerpunkte zu setzen.

## Vorbereitung

- [ ] **0. Projekt aufsetzen** *(technische Voraussetzung, keine Nutzer-Story)*
  `.ruby-version`, Gemfile, Rakefile (Tests + Standard), `test/test_helper.rb`. Erster
  Test bewusst **rot** sehen, dann grün machen – damit ist bewiesen, dass die
  Test-Infrastruktur wirklich Fehler meldet. Danach `.circleci/config.yml`: CircleCI führt
  bei jedem Push `bundle exec rake` aus (dogfooding – später zeigt die Ampel ihren eigenen
  Build).
  *Lernziele:* Bundler, Minitest, Rake, Standard, Continuous Integration, der TDD-Zyklus
  im Kleinen.

## Phase 1 – Durchstich (Tracer Bullet)

*Tracer Bullet:* ein dünner, aber echter Weg durch alle Teile des Systems, der bleibt und
verbreitert wird (David Thomas, Andrew Hunt: *The Pragmatic Programmer*, 20th Anniversary
Edition, Topic 12 „Tracer Bullets“).

- [ ] **1. Trainer sieht den Build-Status im Terminal**
  Um zu wissen, ob `main` grün ist, ohne CircleCI im Browser zu öffnen, möchte der
  Trainer mit einem Befehl den aktuellen Build-Status seines Kurs-Repos sehen.
  - `bin/buildleafs` zeigt für die neueste Pipeline auf dem Branch *erfolgreich*,
    *läuft* oder *fehlgeschlagen* und den Link zur Pipeline.
  - Repo, Branch und CircleCI-Token kommen aus Umgebungsvariablen.

  *Geschnitten nach:* SPIDR **Interfaces** (Terminal statt Licht), SPIDR **Paths**
  (Happy Path zuerst).
  *Lernziele:* Value Object `BuildStatus`, Gleichheit in Ruby (`==`, `eql?`, `hash`),
  Net::HTTP, JSON, Fake-Server mit Rack.

- [ ] **2. Trainer sieht den Build-Status als Farbe an den Dreiecken** 🎉
  Um den Build-Status im Kursraum auf einen Blick zu sehen, möchte der Trainer, dass die
  Dreiecke grün, blau oder rot leuchten.
  - erfolgreich → grün, läuft → blau, fehlgeschlagen → rot – zunächst statisch.
  - Nanoleaf-IP und Auth-Token kommen aus Umgebungsvariablen; ein kleines Hilfsskript
    koppelt einmalig und gibt den Token aus.

  *Geschnitten nach:* Simple/Complex (statische Farbe vor Pulsieren).
  *Lernziele:* Übersetzung Fachmodell → Fremdmodell (`animData`), Panel-IDs lesen,
  Fake-Nanoleaf-Server, erster Test an echter Hardware.

- [ ] **3. Trainer erkennt am Pulsieren, ob ein Build läuft oder fehlschlägt**
  Um einen fehlgeschlagenen Build auch aus dem Augenwinkel nicht zu übersehen, möchte der
  Trainer, dass Rot deutlich schneller und kräftiger pulsiert als Blau.
  - läuft → blau, langsam pulsierend; fehlgeschlagen → rot, schnell und kräftig pulsierend.
  - Als Test formuliert: Rot pulsiert schneller und mit mehr Kontrast als Blau.

  *Lernziele:* fachliche Regeln als Tests, reine Objekte ohne Seiteneffekte (`Signal`).

## Phase 2 – Verlässlich im Kursalltag

*Ab hier hat jede Story mindestens ein Cucumber-Szenario als Abnahmekriterium.*

- [ ] **4. Trainer sieht, warum kein Status kommt**
  Um eine falsche Konfiguration schnell zu beheben, möchte der Trainer sehen, warum kein
  Build-Status angezeigt wird.
  - Token abgelehnt (401) oder Repo nicht gefunden (404) → *unbekannt* (gedimmtes
    Orange), Ursache wird im Terminal genannt, Exit-Code ≠ 0.

  *Geschnitten nach:* SPIDR **Paths** (Fehlerfälle nach dem Happy Path).
  *Lernziele:* Fehlerbehandlung an Adaptergrenzen, Exit-Codes, erstes Cucumber-Feature
  (Wechsel zu outside-in).

- [ ] **5. Trainer wird von abgebrochenen oder kaputten Pipelines nicht in die Irre geführt**
  Um sich auf die Ampel verlassen zu können, möchte der Trainer, dass sie auch in
  Sonderfällen den richtigen Status zeigt.
  - `failing` → sofort rot; Pipeline `errored` → rot.
  - Abgebrochene Pipelines und Pipelines ohne Workflows → die nächstältere zählt.

  *Geschnitten nach:* Business Rule Variations.
  *Lernziele:* Edge Cases als Tests, Auswertungsregeln im Domain-Kern (siehe domain-notes).

- [ ] **6. Ampel aktualisiert sich von selbst**
  Um nicht ständig selbst nachsehen zu müssen, möchte der Trainer, dass die Ampel den
  Status regelmäßig abfragt und bei Änderung umschaltet.
  - Abfrage im einstellbaren Intervall.
  - Licht wird nur bei Änderung neu gesetzt (Pulsieren startet nicht ständig neu).

  *Lernziele:* Use Case, Ports (`StatusSource`, `Light`, `Clock`), Fake vs. Mock, Threads,
  Mutex, deterministische Tests.

- [ ] **7. Ampel zeigt nach dem Beenden keinen veralteten Status**
  Um nicht von einem stehengebliebenen Grün getäuscht zu werden, möchte der Trainer, dass
  die Dreiecke beim Beenden ausgehen.
  - Strg+C / SIGTERM → Panels aus (einstellbar: aus / orange / so lassen).

  *Lernziele:* `at_exit`, Signale, Aufräumen.

## Phase 3 – Weboberfläche

- [ ] **8. Trainer sieht die Details zum Status im Browser**
  Um bei Rot schnell zum schuldigen Commit zu kommen, möchte der Trainer im Browser
  Status, Pipeline, Commit und Zeitpunkt der letzten Prüfung sehen.

  *Lernziele:* Sinatra, ERB, Rack::Test.

- [ ] **9. Trainer konfiguriert das Repo im Browser**
  Um die Ampel vor jedem Kurs ohne Terminal auf ein neues Repo umzustellen, möchte der
  Trainer Repo, Branch, Intervall und Token im Browser eintragen.
  - GitHub-URLs werden normalisiert; gespeichert in `data/config.yml` (Rechte 0600).

  *Lernziele:* Formulare, Persistenz als Adapter, Validierung, Secrets sicher speichern.

- [ ] **10. Trainer koppelt die Dreiecke per Knopf**
  Um im Seminarraum ohne Terminal mit dem Nanoleaf zu koppeln, möchte der Trainer die
  Kopplung im Browser per Knopf auslösen.

  *Geschnitten nach:* Operations (Konfiguration und Kopplung getrennt).

- [ ] **11. Trainer testet die Ampel vor Kursbeginn**
  Um vor Kursbeginn sicher zu sein, dass alle Farben funktionieren, möchte der Trainer
  jedes Signal per Knopf 10 s lang anzeigen lassen; danach kehrt die Ampel zum echten
  Zustand zurück.

## Phase 4 – Sofort reagieren (Webhooks)

- [ ] **12. Ampel zeigt das Build-Ergebnis sofort**
  Um das Ergebnis eines Builds sofort und nicht erst nach dem nächsten Intervall zu
  sehen, möchte der Trainer, dass die Ampel auf die CircleCI-Meldung „Workflow
  abgeschlossen“ reagiert – empfangen über smee.io.
  - Nur für den erwarteten Commit (ältere Meldungen ignorieren).

  *Lernziele:* Webhooks, HMAC-Signaturen, Server-Sent Events, Zustandsmaschine
  (siehe domain-notes „Stolpersteine“).

- [ ] **13. Push macht die Ampel sofort blau**
  Um zu sehen, dass ein Push angekommen ist, möchte der Trainer, dass die Ampel bei
  einem Push auf den beobachteten Branch sofort blau wird.
  - Andere Branches, andere Repos und `[skip ci]` werden ignoriert.

  *Lernziele:* Zustandsmaschine erweitern.

- [ ] **14. Ampel bleibt bei Verbindungsabbrüchen erreichbar**
  Um im wackeligen Seminar-WLAN nicht ohne Updates dazustehen, möchte der Trainer, dass
  sich die Ampel nach einem Abbruch selbst wieder mit smee.io verbindet.

  *Geschnitten nach:* Simple/Complex (Robustheit nach dem Grundfall).
  *Lernziele:* Wiederverbinden mit Backoff, Robustheit.

- [ ] **15. Abfrage als Absicherung**
  Um auch bei verlorenen Webhooks den richtigen Status zu sehen, möchte der Trainer, dass
  die regelmäßige Abfrage weiterläuft, ohne neuere Webhook-Ergebnisse zu überschreiben.

## Später / Ideen

- Deployment auf dem Raspberry Pi (systemd)
- Mehrere Repos auf Gruppen von Dreiecken verteilen
