# Boccie Soccer

App Android nativa in Kotlin + Jetpack Compose.

## Funzioni attuali
- Interfaccia Android con marchio **Boccie Soccer**.
- Apertura dell'app Proton VPN installata; se manca, apre la relativa pagina Play Store.
- Opzione per aprire Proton VPN all'avvio. Per collegarsi, l'utente deve premere Connect nell'app Proton e approvare gli eventuali dialoghi Android.
- Collegamenti al calendario ufficiale della Lega Serie A, alla programmazione Digi Sport e alla pagina Digi Sport Live.

## Limiti
- Prototipo iniziale: il calendario non viene ancora scaricato automaticamente nell'app; viene aperta la fonte ufficiale nel browser.
- Non contiene flussi video, playlist IPTV o link a stream non autorizzati.
- Non crea account Digi, non accetta condizioni e non effettua pagamenti.
- Non controlla la connessione Proton, non sceglie il server Romania e non verifica l'indirizzo IP.
- Proton VPN Free non consente di scegliere manualmente un server Romania.
- Una VPN non sostituisce un abbonamento o i requisiti territoriali del servizio streaming.

## Requisiti
- Android Studio recente, JDK 17, Android SDK 36.
- Gradle 8.11.1 o compatibile con Android Gradle Plugin 8.9.2.

## Aprire e compilare
1. Scarica o clona questa repository.
2. Apri la cartella `Boccie-Soccer` in Android Studio.
3. Configura Gradle 8.11.1 e JDK 17 se richiesto.
4. Attendi la sincronizzazione.
5. Seleziona **Build → Build Bundle(s) / APK(s) → Build APK(s)**.
6. APK debug: `app/build/outputs/apk/debug/app-debug.apk`.

Il workflow GitHub Actions individua il binario `sdkmanager` cercandolo sotto `/usr/local/lib/android/sdk/cmdline-tools`, imposta `ANDROID_HOME` e `ANDROID_SDK_ROOT`, installa Android SDK 36 e Build Tools 36.0.0, configura JDK 17 e Gradle 8.11.1, quindi esegue `gradle --no-daemon assembleDebug`. Al termine pubblica l'APK come artifact `boccie-soccer-debug-apk` nella pagina del run. Il progetto non include il Gradle Wrapper (`gradlew`).

## Identificativi
- Application ID: `it.naif.bocciesoccer`
- Versione: `1.2` (versionCode 3)
- Min SDK: 26 (Android 8.0)
- Target SDK: 35

## Collegamenti ufficiali
- [Lega Serie A – Calendario e risultati](https://www.legaseriea.it/it/serie-a/calendario-e-risultati)
- [Digi Sport – Programmazione TV](https://www.digisport.ro/program-tv)
- [Digi Sport – Live](https://www.digisport.ro/live/online)
- [Proton VPN – Android](https://play.google.com/store/apps/details?id=ch.protonvpn.android)

## Contribuire
Apri una issue descrivendo il problema, il dispositivo Android e i passaggi per riprodurlo. Non pubblicare password, token o dati personali.
