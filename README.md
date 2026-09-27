# Prezzo Artigiano FIX9

FIX9 parte dalla sorgente pulita FIX6. Non modifica automaticamente il codice
Dart con regex.

Correzione principale:
- rimosso il test Flutter predefinito `widget_test.dart` che referenziava `MyApp`;
- mantenuto il codice `lib/main.dart` originale della FIX6;
- build Android e Windows separate;
- analisi Flutter prima della compilazione;
- installer Windows FIX9;
- launcher diagnostico disponibile nell'installazione.

Artifact Windows:
- `prezzo-artigiano-windows-setup-fix9`
- `prezzo-artigiano-windows-raw-fix9`
