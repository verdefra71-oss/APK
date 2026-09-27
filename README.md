# Prezzo Artigiano

Progetto Flutter per Android e Windows.

## Windows

GitHub Actions compila l'app Windows e crea automaticamente:

`Prezzo-Artigiano-Setup.exe`

L'installer:
- installa l'app nella cartella Programmi;
- crea il collegamento nel menu Start;
- crea il collegamento sul desktop;
- permette la disinstallazione da Windows;
- avvia l'app al termine dell'installazione.

Non è necessario estrarre manualmente DLL o cartelle Flutter.

## GitHub Actions

Dopo la build, scaricare l'artifact:

`prezzo-artigiano-windows-setup`

All'interno si trova:

`Prezzo-Artigiano-Setup.exe`
