# Smart Link Sentinel

Open source project for testing deeplinks.

📀 https://www.youtube.com/watch?v=Km6JevQ-Xg0

<div align="center">
<img src="demo/s1.png" width="45%" />
<img src="demo/s2.png" width="45%" />
</div>
<div align="center">
<img src="demo/s3.png" width="45%" />
<img src="demo/s4.png" width="45%" />
</div>


## Resources
- [🎨 Theme Builder](https://material-foundation.github.io/material-theme-builder/)

## Environment Variables
- `GEMINI_MODEL`: The model to use for the chatbot.
- `YOUR_GEMINI_KEY`: The API key for the model. How to get it? 👉 https://aistudio.google.com/


## Project Structure
This repo uses the standard Flutter layout at the root, with a layered architecture inside `lib/`:

- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`: platform-specific app targets
- `assets/`: app assets (fonts, icons, prompt markdown, etc.)
- `demo/`: images used for README previews
- `lib/`: main application code (layered)
- `script/`: helper scripts used during development
- `test/`: widget/unit tests

Layered architecture inside `lib/`:

- `lib/main.dart`: app entry point and high-level setup
- `lib/core/`: shared building blocks (base classes, constants, utilities)
- `lib/di/`: dependency injection wiring (powered by `injectable` + `get_it`)
- `lib/domain/`: domain layer (use-cases + repository contracts + core domain models)
- `lib/data/`: data layer (data sources, repository implementations, mappers, DTO/models)
- `lib/presentation/`: UI + state management (screens like `journey/`, cubits, themes, reusable widgets)
- `lib/extensions/`: convenience extension methods used across the app
- `lib/gen/`: generated code for assets/fonts and other `flutter_gen` outputs

### Directory Tree
```text
.
├── android/
├── ios/
├── macos/
├── linux/
├── web/
├── windows/
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── prompts/
├── demo/
├── lib/
│   ├── core/
│   │   ├── base/
│   │   ├── constant/
│   │   └── utils/
│   ├── di/
│   ├── domain/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── data/
│   │   ├── data_sources/
│   │   ├── mapper/
│   │   ├── models/
│   │   └── repositories/
│   ├── extensions/
│   ├── gen/ (generated)
│   └── presentation/
│       ├── journey/
│       ├── shared_cubit/
│       ├── theme/
│       └── widget/
├── script/
├── test/
├── build/ (generated)
├── pubspec.yaml
├── analysis_options.yaml
├── pubspec.lock
├── flutter_launcher_icons.yaml
├── l10n.yaml
├── LICENSE
└── README.md
```

## What this project helps a new learner learn
If you’re new to Flutter, this repo is a practical playground to learn how to:

- Structure an app into layers (`presentation` / `domain` / `data`) and keep responsibilities separated
- Use Bloc-style state management with `flutter_bloc`
- Configure routing with `go_router`
- Set up DI and generated wiring via `injectable`
- Persist local data with `drift` (SQLite) instead of ad-hoc storage
- Model immutable data and serialization with `freezed` + `json_serializable`
- Work with code generation (`build_runner`) and `flutter_gen`
- Integrate real device features like QR scanning (`mobile_scanner`) and launching URLs (`url_launcher`)
- Wire an AI feature using `google_generative_ai` (controlled via the provided env vars)

## Tech Stack
- Framework: `Flutter` / `Dart`
- State management: `flutter_bloc`
- Routing: `go_router`
- Dependency injection: `injectable` + `get_it`
- Immutable models + JSON: `freezed` + `json_serializable` (+ `json_annotation`)
- Local database: `drift` + `drift_flutter` (+ `sqlite3_flutter_libs`)
- Deeplink / URL launching: `url_launcher`
- QR scanning / display: `mobile_scanner` + `pretty_qr_code`
- Theming: `adaptive_theme`
- Extras used in the UI: `shimmer`, `flutter_slidable`
- AI integration: `google_generative_ai`

## Build project

```bash
dart run build_runner build --delete-conflicting-outputs
```

```bash
flutter run --dart-define=GEMINI_MODEL=gemini-3-flash-preview --dart-define=GEMINI_KEY=YOUR_GEMINI_KEY
```

```bash
dart run flutter_launcher_icons
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

👨‍💻 https://github.com/kzjn10