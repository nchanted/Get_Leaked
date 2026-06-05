# Get Leaked! — Android build

A native Android wrapper around the **Get Leaked!** DLP game. The entire game is a
single self-contained web page (`app/src/main/assets/index.html`) shown in a
full-screen `WebView`. No game logic lives in the Android code — the wrapper just
hosts the page, handles the back button, and keeps state across rotation.

## Build the APK on GitHub (no local setup needed)

> **Most common failure:** the Gradle project must sit at the **repository root**.
> After unzipping, push the *files inside* `get-leaked-android/` so that
> `settings.gradle` is at the top of the repo — **not** a `get-leaked-android/`
> folder containing them. (The workflow now also auto-detects a nested project,
> but a clean root layout is best.) To verify on GitHub, your repo's file list
> should show `settings.gradle`, `build.gradle`, `app/`, and `.github/` directly.

1. Create a new GitHub repository and push the **contents of this folder** to it
   (so `settings.gradle` and the `.github/` folder sit at the repo root).

   ```bash
   cd get-leaked-android        # enter the unzipped folder first
   git init
   git add .
   git commit -m "Get Leaked! Android"
   git branch -M main
   git remote add origin https://github.com/<you>/<repo>.git
   git push -u origin main
   ```

2. The workflow in `.github/workflows/android.yml` runs automatically on every
   push. Open the repo's **Actions** tab, click the latest **Build APK** run,
   and download the **`get-leaked-debug-apk`** artifact at the bottom. Inside is
   `app-debug.apk`.

   You can also trigger it manually from the Actions tab via **Run workflow**.

3. Copy `app-debug.apk` to your phone and install it (enable
   *Install unknown apps* for your file manager / browser when prompted).

The debug APK is signed with Android's standard debug key, so it installs
directly — no extra signing required for personal use.

## Build locally (optional)

You need JDK 17 and the Android SDK (platform 35 + build-tools 35.0.0). Then:

```bash
gradle assembleDebug          # or ./gradlew assembleDebug if you add the wrapper
```

Output: `app/build/outputs/apk/debug/app-debug.apk`.

> This project intentionally omits the Gradle wrapper jar (a binary) so it stays
> text-only and clean in git. The CI installs Gradle for you. To work in Android
> Studio locally, open the folder and let it generate the wrapper, or run
> `gradle wrapper`.

## Updating the game

Replace `app/src/main/assets/index.html` with a new version of the game and push.
Bump `versionCode` / `versionName` in `app/build.gradle` for each release.

## Shipping a real (release) build

The `release` build type here is **unsigned**. To publish or share a release APK,
generate a keystore and configure signing:

```bash
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias clearance
```

Then add a `signingConfigs` block in `app/build.gradle` referencing that keystore
(store the password as a GitHub Actions secret, not in git) and run
`gradle assembleRelease`.

## Notes

- `minSdk 21` (Android 5.0), `targetSdk 34` (Android 14), `compileSdk 35`. Built with AGP 8.7.2 / Gradle 8.9.
- The game uses Google Fonts over the network; with no connection it falls back
  to the device's monospace/serif fonts and remains fully playable.
- Application id: `com.meridian.clearance`.
