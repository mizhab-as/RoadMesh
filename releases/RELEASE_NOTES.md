# RoadMesh Release Notes

---

## v1.1.0 — Brand Identity & Asset Pipeline (September 2026)

**Binary**: `roadmesh-v1.1.0.apk`  
**Size**: 11.2 MB (tree-shaken, obfuscated release build)  
**Platform**: Android arm64  
**Checksum (SHA-256)**: See `roadmesh-v1.1.0.apk.sha256`

### What's New in v1.1.0

#### 🎨 Full Automotive Brand Identity
- **Native Android Launcher Icon**: Custom RoadMesh radar mesh mark with adaptive foreground (transparent)/background (white gradient) layers — correct on all Android 8+ launchers, Google Pixel, Samsung One UI.
- **Android 12+ Native Splash Screen**: System-level API 31 animated splash using `splash-icon.png` on `#FFFFFF` light / `#0F172A` obsidian dark based on system theme.
- **Android Legacy Splash** (API 21–30): `splash-icon.png` generated across all DPI buckets (mdpi → xxxhdpi).
- **iOS App Icon**: 1024×1024 `app-icon.png` scaled to all required iPhone & iPad icon slots.
- **In-App Animated Splash Screen**: 60fps/120fps `CustomPainter` radar beacon with three staggered red alert pulse rings expanding from a blue ego-vehicle center node, fading into the app gracefully after 2.2s.

#### 🚀 Screen Flow
1. OS Native Splash → 2. In-App Animated Splash → 3. Onboarding (first run) or Home Console

#### 🖼️ Onboarding & Home Visual Upgrade
- **Onboarding**: Official horizontal logo in top bar; first slide uses standalone radar mark emblem inside illuminated orb.
- **Home Header**: Replaced generic cell-tower icon with official `logo-mark-standalone.png` in a pulsing emerald beacon orb with ROAD/MESH two-tone typography.

#### 🛠️ master.sh Enhancements
- `--icons` / `--brand`: Regenerate launcher icons + native splash screens with one command.
- `--release-apk [VER]`: Build & package obfuscated release APK into `releases/` with SHA-256 checksum.
- `--all` now auto-runs brand asset regeneration before building and deploying.
- Smart build invalidation: any change to `assets/`, `lib/`, or `pubspec.yaml` triggers an APK rebuild.
- New interactive menu options [8] Regenerate Brand Assets and [9] Package Release APK.

#### 📦 pubspec.yaml
- Added `flutter_launcher_icons: ^0.13.1` and `flutter_native_splash: ^2.4.1` as dev dependencies.
- Added `assets/splash/` and `assets/logo/` asset directories.

---

### Installation

```bash
# Sideload via ADB:
adb install -r -d releases/roadmesh-v1.1.0.apk
adb shell am start -n com.example.roadmesh_app/.MainActivity
```

---

## v1.0.0 — Production Release (September 2026)

**Binary**: `roadmesh-v1.0.0.apk`  
**Size**: ~24.0 MB  
**Checksum (SHA-256)**: See `roadmesh-v1.0.0.apk.sha256`

### What's New in v1.0.0

#### 1. Zero-Hardware Smartphone V2X Core
- Real-time GPS and compass telemetry streaming over low-latency WebSockets.
- Dynamic Time-to-Closest-Approach (TCA) collision prediction engine computing relative velocity vectors up to 10 seconds ahead.
- Spatial Geohash indexing (Precision 6) querying 9 neighboring cells with sub-millisecond response times.

#### 2. Streamlined Vehicle Speedometer HUD
- Removed road speed limit classifications, speed limiter sensors, and false overspeeding alarms.
- Floating circular HUD showing actual GPS driving speed in `km/h`.
- Adaptive day/night visual themes.

#### 3. Tactical Geospatial Operations Console
- High-contrast tactical Leaflet.js map tracking all active vehicles.
- Real-time device inspector table with speeds, bearings, and risk ratings.

#### 4. Robust Samsung Galaxy (One UI) ADB Support
- Upgraded `./master.sh` with automatic `-t -d` test package flags and `--no-streaming` fallback for reliable USB installs across Samsung devices.

---

### Installation (v1.0.0)

```bash
adb install -r -d releases/roadmesh-v1.0.0.apk
adb shell am start -n com.example.roadmesh_app/.MainActivity
```
