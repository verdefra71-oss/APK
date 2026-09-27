# Prezzo Artigiano FIX11

FIX11 risolve il caso in cui Windows installa correttamente l'app ma l'EXE
non parte perché nel PC manca il runtime Microsoft Visual C++ richiesto
dall'applicazione Windows.

La GitHub Action scarica il Visual C++ Redistributable x64 ufficiale Microsoft
e lo inserisce nel Setup. L'installer lo installa prima di avviare Prezzo Artigiano.

Artifact:
- `prezzo-artigiano-windows-setup-fix11`
- `prezzo-artigiano-windows-raw-fix11`

È inoltre presente il launcher `Avvia-Prezzo-Artigiano-Diagnostica.bat`.
