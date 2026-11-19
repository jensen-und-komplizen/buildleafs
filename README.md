# buildleafs Project

Eine Build-Ampel („Extreme Feedback Device“) für [Nanoleaf](https://nanoleaf.me) Shapes:
Die Dreiecke zeigen den [CircleCI](https://circleci.com/)-Status eines GitHub-Repos an.
Eingesetzt wird sie in unseren CSD-Kursen auf dem Laptop des Trainers, als Erstes für
[`csd_adventure_javascript`](https://github.com/jensen-und-komplizen/csd_adventure_javascript).

| Build-Zustand  | Licht                                   |
|----------------|-----------------------------------------|
| erfolgreich    | grün, ruhig                             |
| läuft          | blau, langsam pulsierend                |
| fehlgeschlagen | rot, schnell und kräftig pulsierend     |
| unbekannt      | gedimmtes Orange                        |

🚧 Work in progress – die App entsteht Schritt für Schritt testgetrieben, im Pair
Programming mit [Claude Code](https://claude.com/claude-code) als Mentor
(Arbeitsweise und Regeln in [`CLAUDE.md`](CLAUDE.md)). Was als Nächstes kommt, steht
im [Backlog](docs/backlog.md).

## Lernen mit diesem Repo

Das Repo ist öffentlich, damit CSD-Lerngruppen nachvollziehen können, wie es entsteht:

- [Backlog](docs/backlog.md): Stories nach INVEST, mit dem jeweils genutzten Schnittmuster
- [Architecture Decision Records](docs/adr/): wichtige Entscheidungen mit Kontext und
  verworfenen Alternativen
- Git-History: kleine Commits nach [Conventional Commits](https://www.conventionalcommits.org/)

## On your machine
### prerequisites
Du brauchst [Ruby](https://www.ruby-lang.org/) in Version 3.3 oder neuer (inkl. `bundler`). Prüfe deine Version mit:
```shell script
ruby -v
```

### clone
```shell script
git clone https://github.com/jensen-und-komplizen/buildleafs.git
cd buildleafs
```

### install dependencies
```shell script
bundle install
```

### run tests
Alle Tests ([Minitest](https://github.com/minitest/minitest), unter `test/`) und der
Linter ([Standard](https://github.com/standardrb/standard)):
```shell script
bundle exec rake
```

Eine einzelne Testdatei:
```shell script
bundle exec ruby -Itest test/<name>_test.rb
```

## Project structure

```
CLAUDE.md           Arbeitsweise, TDD-Regeln und Konventionen
docs/
  backlog.md        Stories in der Reihenfolge, in der sie gebaut werden
  domain-notes.md   Fachwissen zu Nanoleaf, CircleCI, GitHub und smee.io
  adr/              Architecture Decision Records
```
