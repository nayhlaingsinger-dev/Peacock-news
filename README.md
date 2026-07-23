# RedPeacock News App - Setup Guide

This repository contains the source code for the RedPeacock News App (Flutter) and its Admin Panel (Laravel).

## 1. Laravel Admin Panel Setup

### Prerequisites
- PHP >= 8.1
- MySQL Database
- Web Server (Apache/Nginx)
- Composer

### Installation Steps
1.  **Upload Files:** Upload the contents of the `laravel_admin` folder to your server.
2.  **Database:** Create a new MySQL database.
3.  **Configuration:**
    -   Rename `.env.example` to `.env`.
    -   Update `DB_DATABASE`, `DB_USERNAME`, and `DB_PASSWORD` with your database credentials.
    -   Set `APP_URL` to your domain (e.g., `https://yourdomain.com`).
4.  **Dependencies:** Run `composer install` in the terminal.
5.  **Database Migration:** Import the SQL file provided in the `database` folder or run `php artisan migrate`.
6.  **Admin Login:** Access the admin panel at `yourdomain.com/login`. Default credentials should be in the documentation or check the `users` table.

---

## 2. Flutter App Setup

### Prerequisites
- Flutter SDK installed on your machine.
- Android Studio or VS Code.

### Configuration Steps
1.  **API Link:**
    -   Open `lib/utils/constant.dart`.
    -   Update `baseUrl` to your Laravel Admin API URL (e.g., `https://yourdomain.com/api/`).
2.  **Firebase (Push Notifications):**
    -   Go to [Firebase Console](https://console.firebase.google.com/).
    -   Create a new project.
    -   Add an Android app with package name `com.redpeacock.news`.
    -   Download `google-services.json` and place it in `android/app/`.
    -   Add an iOS app and place `GoogleService-Info.plist` in `ios/Runner/`.
3.  **App Name & Logo:**
    -   The app name is already set to **RedPeacock**.
    -   The logo and icons have been updated.
4.  **Build the App:**
    -   Run `flutter pub get` to install dependencies.
    -   To generate APK: `flutter build apk --release`
    -   To generate AAB: `flutter build appbundle --release`

---

## 3. Rewarded Video Ads
-   In the Laravel Admin Panel, go to **Ads Settings**.
-   Enter your **Google AdMob Rewarded Ad Unit ID**.
-   The app is already configured to show an ad before playing news videos.

---

## Important Note
The Laravel SQL error in `ApiController.php` (`location_id = 0`) has been fixed in this version.

**Developed with Manus AI**
