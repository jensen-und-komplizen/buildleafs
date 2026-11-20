# Learning Log

Was beim Bauen von Buildleafs gelernt wurde – als Quelle für künftige Projekte und
CSD-Lerngruppen. Jeder Eintrag: Konzept, Beispiel aus diesem Repo, Stolperstein, Quelle
und eine Frage zum Diskutieren.

## 2026-11-19 – Rahmen setzen und Backlog schneiden

### Stories als vertikale Scheiben (INVEST, „Valuable“)

- **Am Beispiel:** Das erste Backlog begann mit `BuildStatus`, `Signal`, `animData` –
  nach keiner dieser Stories konnte der Trainer einen echten Build-Status ablesen. Neu
  geschnitten, beginnt es mit „Trainer sieht den Build-Status im Terminal“
  ([bc38645](https://github.com/jensen-und-komplizen/buildleafs/commit/bc38645)).
  Schlüsselsatz: *Der Status ist die Intention, das Licht nur eine Lösung.*
- **Stolperstein:** Erste Antwort auf „Was ist die kleinste wertvolle Story?“ war
  „Build-Status als Wert“ – ein Baustein im Code, aber nichts, was ein Nutzer sieht.
- **Quelle:** Bill Wake, *INVEST in Good Stories, and SMART Tasks*
  (https://xp123.com/articles/invest-in-good-stories-and-smart-tasks/)
- **Frage für die Lerngruppe:** Woran erkennt ihr in eurem Backlog eine Story, die in
  Wahrheit eine technische Schicht ist? Wie würdet ihr sie umformulieren?

### Story-Schnittmuster: Interfaces und Paths (SPIDR)

- **Am Beispiel:** Statt Status *und* Licht auf einmal: erst der echte Status mit der
  einfachsten Ausgabe (Terminal), das Licht als eigene Story (*Interfaces*). Fehlerfälle
  (401/404) als eigene Story nach dem Happy Path (*Paths*), weil die erste Story sonst
  nicht *Small* war. Ein Ende darf gefakt werden – aber nicht die Intention: Gemockter
  Status *und* Terminal-Ausgabe hätten dem Trainer nichts Neues gezeigt.
- **Stolperstein:** Das Muster wurde zuerst als „Interface Variations“ aus dem
  Humanizing-Work-Guide zitiert – dort gibt es es nicht. Beim Nachprüfen der Quelle fiel
  das auf. Lehre: Quellen beim ersten Zitieren prüfen, nicht aus dem Gedächtnis.
- **Quelle:** Mike Cohn, *SPIDR: Five Simple but Powerful Ways to Split User Stories*
  (https://www.mountaingoatsoftware.com/blog/five-simple-but-powerful-ways-to-split-user-stories);
  weitere Muster (Simple/Complex, Business Rule Variations, Operations): Richard Lawrence,
  Peter Green, *The Humanizing Work Guide to Splitting User Stories*
  (https://www.humanizingwork.com/the-humanizing-work-guide-to-splitting-user-stories/)
- **Frage für die Lerngruppe:** Welches Ende eurer aktuellen Story ist die Intention,
  welches die Lösung – und welches dürftet ihr deshalb vorläufig vereinfachen?

### Entscheidungen dokumentieren: ADRs und der richtige Ort für Wissen

- **Am Beispiel:** Die Entscheidung „Terminal vor Licht“ steht als
  [ADR 0001](adr/0001-build-status-zuerst-im-terminal.md)
  ([4bcf65a](https://github.com/jensen-und-komplizen/buildleafs/commit/4bcf65a)) – mit
  Kontext, verworfenen Alternativen und Konsequenzen. Jede Information liegt dort, wo man
  sie sucht: Schnittmuster an der Story, Entscheidungen im ADR, Lernen hier, kurze
  Verweise im Commit-Body.
- **Quelle:** Michael Nygard, *Documenting Architecture Decisions*
  (https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- **Frage für die Lerngruppe:** Welche Entscheidung in eurem Projekt wird in drei Monaten
  jemand hinterfragen – und wo würde er heute die Begründung finden?

### Conventional Commits und eine öffentliche History

- **Am Beispiel:** Von `chore: add .gitignore …`
  ([3792ef1](https://github.com/jensen-und-komplizen/buildleafs/commit/3792ef1)) zu
  `docs(claude): …` mit Scope
  ([e8cc15e](https://github.com/jensen-und-komplizen/buildleafs/commit/e8cc15e)).
  Weil das Repo öffentlich ist und Commits verlinkt werden, wird gepushte Historie nie
  umgeschrieben – die ersten Commits ohne Scope bleiben, wie sie sind.
- **Stolperstein:** Ein Commit enthielt mehr, als die Message sagt
  ([bc38645](https://github.com/jensen-und-komplizen/buildleafs/commit/bc38645) ändert
  auch `CLAUDE.md`). Deshalb vor jedem Vorschlag `git status` und `git log` prüfen und
  nur beschreiben, was wirklich im Diff steckt.
- **Quelle:** https://www.conventionalcommits.org/
- **Frage für die Lerngruppe:** Wann ist es in Ordnung, Historie umzuschreiben – und
  wann nicht mehr?

### Bundler: Gemfile vs. Gemfile.lock

- **Am Beispiel:** `rake` und `minitest` werden mit Ruby installiert (*bundled gems*),
  stehen aber trotzdem im `Gemfile`: Unter `bundle exec` ist nur sichtbar, was im
  Gemfile steht. Das Gemfile sagt „damit ist mein Code verträglich“ (`~> 13.4`), das
  `Gemfile.lock` „genau das ist installiert“ – inklusive aller indirekten Abhängigkeiten.
  Für die Reproduzierbarkeit sorgt das Lockfile, deshalb wird es bei einer Anwendung
  committet.
- **Stolperstein:** Die Annahme „Rake gehört zu Rails“ – Rake kommt mit Ruby, Rails hängt
  nur davon ab. Und: Bundler hat `minitest ~> 6.1` aufgelöst, eine neue Hauptversion
  gegenüber dem mit Ruby 3.3 ausgelieferten Minitest 5.
- **Quelle:** Bundler-Dokumentation, *Rationale* (https://bundler.io/guides/rationale.html)
- **Frage für die Lerngruppe:** Was genau passiert, wenn jemand `Gemfile.lock` nicht
  committet – und wann merkt man es?

## 2026-11-20 – Der erste TDD-Zyklus

### Rot hat Stufen – erst ein `F` prüft Verhalten

- **Am Beispiel:** Vor dem ersten Test meldete `bundle exec rake` „0 runs“ mit
  Exit-Code 0 – grün, ohne irgendetwas zu beweisen. Der erste Test für `BuildStatus`
  ([65af8e8](https://github.com/jensen-und-komplizen/buildleafs/commit/65af8e8)) war
  dann in Stufen rot: `LoadError` (Datei fehlt) → `E` (`ArgumentError`, weil
  `new(:success)` keinen passenden Initializer fand) → `F` (die Assertion schlägt fehl).
  Erst beim `F` lief der Test bis zur eigentlichen Prüfung. Vor jedem Lauf die Meldung
  vorherzusagen, machte jede Stufe zum Lernmoment.
- **Stolperstein:** Die Vorhersage „das sollte klappen“ stimmte nicht. Und das erste
  `F` lag am Test selbst (`"successsful"`). Auch Tests können falsch sein – die Meldung
  lesen, statt reflexhaft den Produktionscode zu ändern.
- **Quelle:** Kent Beck, *Test-Driven Development: By Example*
- **Frage für die Lerngruppe:** Woran erkennt ihr, dass ein Test aus dem *richtigen*
  Grund rot ist?

### Fake It – grün auf dem kürzesten Weg

- **Am Beispiel:** `BuildStatus#to_s` gibt die Konstante `"successful"` zurück, der
  Parameter `state` bleibt ungenutzt. Ehrlich wird der Code erst, wenn ein zweiter Test
  (ein laufender Build) eine echte Implementierung erzwingt – *Triangulation*.
- **Stolperstein:** Zuerst sollte `to_s` `""` liefern. Fake It heißt aber: genau den
  erwarteten Wert als Konstante zurückgeben. Und Fake It ist eine Grün-Strategie –
  erst der rote Test, dann der Fake.
- **Quelle:** Kent Beck, *Test-Driven Development: By Example*, Teil III, „Green Bar
  Patterns“ (Fake It, Triangulate, Obvious Implementation)
- **Frage für die Lerngruppe:** Fake It fühlt sich an wie Schummeln. Was gewinnt man,
  wenn man es trotzdem tut?

### Tests vor dem Linter – und nur grüne Commits

- **Am Beispiel:** `task default: %i[test standard]`
  ([9b6f699](https://github.com/jensen-und-komplizen/buildleafs/commit/9b6f699)):
  Rake bricht beim ersten Fehler ab, im Rot stören also keine Stilmeldungen. Standard
  meldete sich erst bei Grün (Leerzeile, einfache Anführungszeichen, eingerückter
  Magic Comment) – passend zur Refactor-Phase. Rote Zwischenstände werden nicht
  committet: Jeder Commit soll grün sein (CI, `git bisect`, gepushte Historie wird nie
  umgeschrieben). Den TDD-Rhythmus erzählt stattdessen der Commit-Body
  ([65af8e8](https://github.com/jensen-und-komplizen/buildleafs/commit/65af8e8)).
- **Stolperstein:** Die naheliegende Idee, den roten Test als eigenen Commit
  festzuhalten.
- **Quelle:** Chris Beams, *How to Write a Git Commit Message*, Regel 7 „Use the body
  to explain what and why vs. how“ (https://cbea.ms/git-commit/)
- **Frage für die Lerngruppe:** Gibt es Situationen, in denen ein roter Commit doch
  sinnvoll ist – etwa auf einem eigenen Branch?
