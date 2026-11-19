# Backlog

Reihenfolge = Priorität. Jede Story ist so geschnitten, dass am Ende etwas Sichtbares
oder Testbares entsteht. Früh echte Hardware anfassen (Feedback!), dann ausbauen.
Lernziele helfen dem Mentor, Schwerpunkte zu setzen.

## Phase 1 – Walking Skeleton

- [ ] **0. Projekt aufsetzen**
  `.ruby-version`, Gemfile, Rakefile (Tests + Standard), `test/test_helper.rb`. Erster Test bewusst **rot** sehen, dann grün
  machen – damit ist bewiesen, dass die Test-Infrastruktur wirklich Fehler meldet.
  *Lernziele:* Bundler, Minitest, Rake, Aufbau eines Ruby-Projekts, der TDD-Zyklus im Kleinen.

- [ ] **1. Build-Status als Wert**
  Es gibt die Zustände erfolgreich, läuft, fehlgeschlagen, unbekannt. Ungültige Zustände
  werden abgelehnt. Zwei gleiche Zustände sind gleich.
  *Lernziele:* Value Object, Gleichheit in Ruby (`==`, `eql?`, `hash`), Immutability, Primitive Obsession vermeiden.

- [ ] **2. Vom Status zum Lichtsignal**
  Jeder Status hat ein Lichtsignal: Farbe(n), statisch oder pulsierend, Tempo.
  Rot pulsiert schneller und mit mehr Kontrast als Blau (als Test formulieren!).
  *Lernziele:* reine Funktionen/Objekte ohne Seiteneffekte, Tests für fachliche Regeln.

- [ ] **3. Signal in Nanoleaf-Animationsdaten übersetzen**
  Aus Signal + Panel-IDs entsteht das `animData`-Format (siehe domain-notes).
  *Lernziele:* Übersetzung zwischen Fach- und Fremdmodell, String-Formate testen.

- [ ] **4. Mit dem Nanoleaf koppeln und grün leuchten** 🎉
  Ein kleines Skript koppelt mit dem Controller, liest die Panel-IDs und lässt alle
  Dreiecke grün leuchten – dann blau pulsierend, dann rot pulsierend.
  *Lernziele:* Net::HTTP, Fake-Server mit Rack für Tests, Fehlerbehandlung bei Netzwerkfehlern.
  *Wichtig:* Hier zum ersten Mal an echter Hardware prüfen, ob das Format passt.

## Phase 2 – Status von CircleCI holen

- [ ] **5. Aktuellen Build-Status über die CircleCI-API lesen**
  Neueste Pipeline auf `main` → Workflows → Status. Regeln siehe domain-notes.
  *Lernziele:* API-Client als Adapter, JSON, Test mit Fake-Server, Fehlerfälle (401, 404).

- [ ] **6. Nur bei Änderung umschalten**
  Ein Durchlauf fragt den Status ab und schaltet das Licht nur um, wenn er sich geändert hat.
  *Lernziele:* Use Case, Ports (Light, StatusSource), Test Doubles (Fake vs. Mock), Dependency Injection.

- [ ] **7. Regelmäßig abfragen**
  Hintergrund-Thread fragt im Intervall ab; Zeit ist im Test steuerbar.
  *Lernziele:* Threads, Mutex, Uhr als Abhängigkeit (Clock), deterministische Tests.

- [ ] **8. Panels beim Beenden ausschalten**
  Strg+C / SIGTERM → Panels aus (einstellbar: aus / orange / so lassen).
  *Lernziele:* `at_exit`, Signale, Aufräumen.

## Phase 3 – Weboberfläche

- [ ] **9. Statusseite**
  Sinatra zeigt aktuellen Zustand, Pipeline, Commit, letzte Prüfung.
  *Lernziele:* Sinatra, ERB, Rack::Test, Adapter für die Auslieferung.

- [ ] **10. Konfiguration über die Oberfläche**
  Repo (GitHub-URL wird normalisiert), Branch, Intervall, Nanoleaf-IP, CircleCI-Token;
  gespeichert in `data/config.yml` (Rechte 0600). Kopplung per Knopf.
  *Lernziele:* Formulare, Persistenz als Adapter, Validierung, Geheimnisse sicher speichern.

- [ ] **11. Vorschau-Knöpfe**
  „Grün/Blau/Rot testen“ zeigt das Signal 10 s lang, danach wieder den echten Zustand.

## Phase 4 – Webhooks statt nur Abfragen

- [ ] **12. GitHub-Push macht blau**
  Push auf den beobachteten Branch → läuft. Andere Branches, Repos, `[skip ci]` ignorieren.
  *Lernziele:* Webhooks, HMAC-Signaturen, Zustandsmaschine im Domain-Kern.

- [ ] **13. CircleCI meldet das Ergebnis**
  `workflow-completed` → grün/rot; nur für den erwarteten Commit (ältere ignorieren).
  *Lernziele:* Zustandsmaschine erweitern, Edge Cases als Tests (siehe domain-notes „Stolpersteine“).

- [ ] **14. Webhooks über smee.io empfangen**
  Ausgehende SSE-Verbindung zu einem smee-Kanal, Wiederverbinden mit Backoff.
  *Lernziele:* Streams, Server-Sent Events, Robustheit.

- [ ] **15. Abfrage als Absicherung**
  API-Abfrage bleibt als Fallback; sie darf neuere Webhook-Ergebnisse nicht überschreiben.

## Später / Ideen

- Linter (standardrb), CI für dieses Repo auf CircleCI (dogfooding!)
- README auf Englisch, Deployment auf dem Raspberry Pi (systemd)
- Mehrere Repos auf Gruppen von Dreiecken verteilen
