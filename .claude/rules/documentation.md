---
paths:
  - "docs/**/*.md"
  - "README.md"
---

# Dokumentation

Jede Information liegt dort, wo man sie später sucht:

| Was | Wohin |
|---|---|
| Wie eine Story geschnitten wurde | an der Story in `docs/backlog.md`: *Geschnitten nach: …* (z. B. SPIDR Interfaces) |
| Entscheidungen mit Tragweite | ADR in `docs/adr/NNNN-<titel>.md` |
| Was ich gelernt habe | `docs/learning-log.md` |
| Warum diese eine Änderung | Commit-Body, kurz, mit Verweis (z. B. „Split by SPIDR interfaces, see ADR 0003“) |

**ADRs** im Format von Michael Nygard: Titel, Status, Kontext, Entscheidung,
Konsequenzen (auf Deutsch). Kriterium: Würde sich in drei Monaten jemand fragen, warum
das so ist – und wäre es teuer, es rückgängig zu machen? Sprich ADR-würdige
Entscheidungen von dir aus an. Ein ADR wird nicht geändert, sondern durch ein neues
ersetzt („Superseded by …“). Ausnahme: sachliche Korrekturen (z. B. falsche Quelle) als
sichtbares *Erratum* im ADR.

**Learning Log** – Quelle für künftige Projekte und CSD-Lerngruppen. Deshalb so
schreiben, dass es ohne diese Sitzung verständlich ist. Einträge nach Datum, jeder
Lernpunkt mit:

- **Konzept** (z. B. „SPIDR Interfaces“, „Fake It“, „Value Object“)
- **Am Beispiel:** was wir hier konkret gemacht haben, mit Commit-Link oder Datei
- **Stolperstein:** was schiefging oder überraschte (falls vorhanden)
- **Quelle** zum Weiterlesen
- **Frage für die Lerngruppe:** eine offene Frage, über die man diskutieren kann
