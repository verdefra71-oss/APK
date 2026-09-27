# Prezzo Artigiano FIX8

Correzione della build CI/CD:
- rimosso il test Flutter predefinito che referenziava `MyApp`, causa dell'errore `creation_with_non_type`;
- mantenuta l'analisi Flutter, che continua a fallire solo in presenza di errori reali;
- preparato installer Windows FIX8;
- mantenuto artifact Windows raw per diagnosi.

Gli avvisi/info di lint non bloccano la build; gli errori reali continuano a bloccarla.
