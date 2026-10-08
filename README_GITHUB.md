# Dimensionamento Audio Chiese

App Flutter per il dimensionamento preliminare di impianti audio 100 V in chiese.

Repository destinazione: `verdefra71-oss/APK`

## Build automatica

Il workflow `.github/workflows/build-apk.yml` compila automaticamente l'APK release a ogni push su `main` o `master`, oppure manualmente da GitHub Actions.

L'APK viene pubblicato come Artifact con nome `dimensionamento-chiese-audio-apk`.

## Modelli inclusi

- DAP CS-330: prese 100 V 10 W / 20 W
- Colonna 50 W: prese 100 V 12,5 W / 25 W / 50 W

## Nota
Il risultato è un dimensionamento preliminare. La progettazione definitiva deve verificare direttività, riverbero, SPL, rumore di fondo e caratteristiche reali del diffusore.
