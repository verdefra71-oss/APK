# Calcio Live

App Flutter per Android e Windows che raccoglie collegamenti a piattaforme ufficiali di streaming e contenuti sportivi.

## Funzioni incluse
- Elenco iniziale di servizi ufficiali.
- Apertura dei collegamenti nel browser/app esterna.
- Ricerca per nome, categoria e descrizione.
- Preferiti salvati sul dispositivo.
- Interfaccia scura adattabile a smartphone e desktop.

## Requisiti
- Flutter stable
- Android SDK per compilare Android
- Windows 10/11 e Visual Studio con workload **Desktop development with C++** per compilare Windows

## Avvio locale
Dalla cartella del progetto:

```bash
flutter create --platforms=android,windows --project-name calcio_live .
flutter pub get
flutter run
```

Per Android:
```bash
flutter build apk --release
```

Per Windows:
```bash
flutter build windows --release
```

## Personalizzare i servizi
Modifica `lib/services/site_service.dart`. Ogni voce contiene nome, descrizione, URL, categoria e icona. Inserisci solo collegamenti a servizi legittimi e autorizzati.

## GitHub
Crea un repository vuoto chiamato `calcio-live`, estrai il contenuto di questo ZIP e carica tutti i file. Il workflow in `.github/workflows/build.yml` genera gli artefatti Android e Windows nella scheda **Actions**.

## Nota
I diritti di trasmissione e la disponibilità delle partite cambiano in base a competizione, stagione, territorio e abbonamento. La presenza di un collegamento nell'app non garantisce che un servizio trasmetta una specifica partita.
