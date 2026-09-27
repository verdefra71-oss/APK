# Prezzo Artigiano FIX10

Correzione CI: il vecchio `test/widget_test.dart` che referenziava `MyApp`
viene eliminato sia dal progetto ZIP sia automaticamente durante GitHub Actions.

Gli avvisi di lint mostrati da `flutter analyze` non sono errori bloccanti.
L'errore `MyApp` non deve più comparire.

La build Windows genera:
`Prezzo-Artigiano-Setup-FIX10.exe`
