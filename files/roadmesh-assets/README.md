# RoadMesh — Brand & App Asset Package (v2, matched to the live app)

Re-themed against your actual screenshots/screen recording: a light,
white-card, Maps-style UI where **green** is the active/positive accent,
**blue** marks the ego vehicle, and **red** is reserved for the collision
pulse halo. The mark now uses those exact roles instead of a generic dark
sci-fi palette:

| Element in the mark          | Color              | Mirrors this in your app                          |
|-------------------------------|---------------------|-----------------------------------------------------|
| Outer 3 nodes (mesh)           | Green `#22C55E`     | Route line, "Share geoposition" link, active buttons |
| Center node (ego vehicle)      | Blue `#2563EB`      | The blue car marker on the map                       |
| Pulse rings                    | Red `#EF4444`       | The pulsing halo around the car in a collision alert  |
| Mesh edges (structure)         | Slate `#334155`     | Bold black route/label text                           |
| Background                     | White → light gray  | The white cards over the light gray map               |

Same mesh/velocity/radar concept as before — just recolored and re-staged
on the theme your app already ships.

## What's in each folder

```
roadmesh-assets/
├── icons/
│   ├── app-icon.png / .svg                      1024×1024 — iOS icon, web, generic
│   ├── adaptive-icon-background.png / .svg       432×432  — Android adaptive bg layer
│   └── adaptive-icon-foreground.png / .svg       432×432  — Android adaptive fg layer (mark only, transparent)
├── splash/
│   ├── splash-icon.png / .svg                    512×512  — centered mark for native splash
│   └── splash-preview.png / .svg                 phone-sized mockup, for reference only
├── logo/
│   ├── logo-horizontal-light-bg.png / .svg        primary lockup, for white/light surfaces
│   ├── logo-horizontal-dark-bg.png / .svg         lockup for the app's dark-mode map
│   └── logo-mark-standalone.png / .svg            mark only, for favicons/socials
├── lib_snippets/
│   ├── app_colors.dart                            palette matched to the live app
│   └── splash_screen.dart                         animated in-app splash (live red pulse, light theme)
├── flutter_launcher_icons.yaml
└── flutter_native_splash.yaml
```

## 1. Drop the assets in

```
roadmesh-app/assets/icons/
roadmesh-app/assets/splash/
```

```yaml
flutter:
  assets:
    - assets/icons/
    - assets/splash/
```

## 2. Generate the real app icons & splash screens

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.4.1
```

Paste in the two config files above, then:

```bash
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

`flutter_native_splash` is set up with both a light (`color`/`image`) and
dark (`color_dark`/`image_dark`) variant, since your app already has a
dark-mode map toggle — the splash will follow the system theme.

## 3. Wire up the in-app splash

Copy `lib_snippets/splash_screen.dart` to `lib/screens/splash_screen.dart`
and `lib_snippets/app_colors.dart` to `lib/theme/app_colors.dart` (merge
values into your existing file if you already have one — the palette is
additive and won't collide with route/UI colors already in use). Show it
as your first route:

```dart
MaterialApp(
  home: SplashScreen(
    onDone: () => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    ),
  ),
)
```

## 4. Use the logo elsewhere

- App bar / light-mode UI: `logo-horizontal-light-bg.svg`
- Dark-mode map screens: `logo-horizontal-dark-bg.svg`
- Favicon, social avatar, watermark: `logo-mark-standalone.svg`

## A note on red

Red is used in the mark exactly the way it's used in your app: as an alert
state, not decoration. If you ever want a "calm" variant of the icon (e.g.
for a settings or about screen) swap the pulse-ring color to the green used
for the mesh nodes — the SVGs are simple enough to hand-edit, just change
the `stroke="#EF4444"` values in `app-icon.svg`.
