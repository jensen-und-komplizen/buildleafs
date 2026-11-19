# 1. Build-Status zuerst im Terminal, Licht danach

Datum: 2026-11-19

## Status

Akzeptiert

## Kontext

Buildleafs soll den CircleCI-Status eines Kurs-Repos an Nanoleaf-Dreiecken zeigen.
Das erste Backlog war inside-out geschnitten: erst `BuildStatus`, dann `Signal`, dann
das Nanoleaf-Format `animData`, dann die Hardware – und erst danach der echte Status
von CircleCI. Begründung war, das größte technische Risiko (das noch nicht an echter
Hardware geprüfte `animData`-Format) früh anzugehen.

Gegen INVEST geprüft, brachten die ersten Stories dem Trainer keinen Mehrwert: Nach
keiner von ihnen konnte er einen echten Build-Status ablesen. Der Status ist die
Intention des Trainers, das Licht nur eine mögliche Lösung.

## Entscheidung

Die erste Story zeigt den **echten** Build-Status von CircleCI im **Terminal**.
Das Licht folgt in eigenen Stories: erst statische Farbe, dann Pulsieren.

Geschnitten nach *Interface Variations* (einfachste Ausgabe zuerst) und
*Simple/Complex* (Happy Path zuerst, Fehlerfälle und Sonderfälle später).
Die technischen Themen der alten Stories wandern in die Lernziele.

## Verworfene Alternativen

- **Hardware zuerst** (altes Backlog): früh Feedback zum Format, aber lange kein Nutzen.
- **Status gemockt, Ausgabe im Terminal:** schneller Durchstich, aber der Trainer
  erfährt nichts, was er nicht selbst hineingesteckt hat.

## Konsequenzen

- Nach Story 1 kann der Trainer den Status eines echten Repos ablesen.
- Die Auswertungsregeln der CircleCI-API werden früh an echten Daten geprüft.
- Das Hardware-Risiko wird später geklärt (Story 2). Abmilderung: Story 2 folgt direkt
  auf Story 1, vor Fehlerfällen und Sonderfällen.
- Die Terminal-Ausgabe bleibt voraussichtlich als Diagnosewerkzeug erhalten.
