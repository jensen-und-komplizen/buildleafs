---
paths:
  - "**/*.rb"
  - "Gemfile"
  - "Rakefile"
---

# Ruby

## Konventionen

Nur Entscheidungen, die kein Linter treffen kann:

- **Namespace:** Alles liegt unter `module Buildleafs`.
- **Eine Klasse pro Datei**, Pfad folgt dem Namen:
  `Buildleafs::BuildStatus` → `lib/buildleafs/build_status.rb`,
  Test dazu → `test/buildleafs/build_status_test.rb`.
- **Laden mit `require_relative`** – kein Autoloader (Zeitwerk), solange es ohne geht.
- **Tests als `Minitest::Test`-Klassen** mit `test_…`-Methoden, nicht die Spec-DSL.
- **Value Objects:** noch offen (eigene Klasse oder `Data.define`) – wird in Story 1
  entschieden, wenn wir Gleichheit (`==`, `eql?`, `hash`) selbst verstanden haben.

## Design im Kleinen

- **Single Level of Abstraction (SLA):** Eine Methode arbeitet auf genau einer
  Abstraktionsebene – sie erzählt *was* passiert und delegiert das *Wie* an gut benannte
  Methoden. Wechselt eine Methode zwischen Fachsprache („Status auswerten“) und Details
  (HTTP-Header, JSON-Schlüssel, Farbwerte), ist das ein Hinweis auf *Extract Method*.
  Prüfe das in jedem Review und zeig es am konkreten Code.
  Herkunft: Kent Beck, *Smalltalk Best Practice Patterns* („Composed Method“);
  Robert C. Martin, *Clean Code*, Kap. 3 („One Level of Abstraction per Function“).
- **Design Patterns – in Ruby gedacht:** Muster entstehen beim Refactoring, wenn der
  Code danach verlangt (Simple Design), nicht vorab. Taucht eines auf (z. B. Adapter für
  CircleCI/Nanoleaf, State für den `BuildTracker`, Strategy, Observer, Null Object),
  benenne es, zeig die **idiomatische Ruby-Form** (Blöcke/Procs statt
  Strategy-Klassenhierarchie, Duck Typing statt Interfaces, Module statt abstrakter
  Basisklassen) und vergleiche sie mit der klassischen Form der Gang of Four.
  Herkunft: Russ Olsen, *Design Patterns in Ruby*; Joshua Kerievsky, *Refactoring to
  Patterns*.
