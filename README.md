# Prezzo Artigiano

Flutter app for artisans: product costing, working hours, fixed costs, artistic value (0-5) and professional quotes.

## GitHub Actions

The workflow in `.github/workflows/build.yml` runs the Android and Windows builds **in parallel**.

It deliberately generates the missing Flutter platform folders on the GitHub runner before building:

- Android: `flutter create --platforms=android --no-pub .`
- Windows: `flutter create --platforms=windows --no-pub .`

This prevents errors such as `android/app/build.gradle not found` when the repository does not contain generated platform folders.

### Artifacts

After the workflow finishes, GitHub Actions publishes:

- `prezzo-artigiano-android-apk`
- `prezzo-artigiano-windows`
