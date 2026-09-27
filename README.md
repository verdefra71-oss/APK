# Prezzo Artigiano

App Flutter per il calcolo del costo reale e del prezzo consigliato dei prodotti artigianali.

## GitHub Actions

Il workflow `.github/workflows/build.yml` esegue **simultaneamente** due job indipendenti:

- **Android APK** → `prezzo-artigiano-android-apk`
- **Windows** → `prezzo-artigiano-windows`

Parte automaticamente a ogni `push` su `main` o `master`, oppure manualmente da **GitHub → Actions → Build Android APK + Windows → Run workflow**.

I due job sono paralleli: se uno dei due fallisce, l'altro può comunque completare la propria build.

## Come caricarlo su GitHub

1. Crea un nuovo repository GitHub.
2. Estrai questo progetto.
3. Carica tutti i file nel repository.
4. Fai `push` sul branch `main` oppure `master`.
5. Apri **Actions**.
6. Attendi il completamento dei due job.
7. Scarica gli Artifact `prezzo-artigiano-android-apk` e `prezzo-artigiano-windows`.
