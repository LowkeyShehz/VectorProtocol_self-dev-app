# How to Build for Android (APK)

Currently, your environment is missing the **Android SDK**, which is required to build Android apps.

## 1. Install Android SDK
The easiest way is to install **Android Studio**:
1.  Download it from: [https://developer.android.com/studio](https://developer.android.com/studio)
2.  Extract the downloaded `.tar.gz` file.
3.  Run the setup script: `android-studio/bin/studio.sh`
4.  Follow the setup wizard to install the **Android SDK** and **Command-line Tools**.

## 2. Configure Flutter
Once installed, tell Flutter where the SDK is (if it doesn't find it automatically):
```bash
flutter config --android-sdk /path/to/android/sdk
```

## 3. Accept Licenses
You must accept the licenses to build:
```bash
flutter doctor --android-licenses
```
(Press `y` to accept all).

## 4. Build the APK
Once `flutter doctor` shows all green checks for Android, run:

```bash
flutter build apk --release
```

**Output Location:**
The APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## Alternative: Release App Bundle (Play Store)
If you plan to publish to the Play Store, build an App Bundle instead:
```bash
flutter build appbundle
```
