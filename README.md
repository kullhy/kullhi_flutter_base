# Kullhi Flutter Base

Flutter base project với Clean Architecture.

## Tech Stack

- **State Management**: GetX
- **Localization**: easy_localization
- **HTTP Client**: Dio với Pretty Dio Logger
- **Code Generation**: flutter_gen, json_serializable, build_runner

## Cấu trúc thư mục

```
lib/
├── app/
│   ├── core/
│   │   ├── constants/        # App & API constants
│   │   ├── controllers/      # Base controller, Theme controller
│   │   ├── di/               # Dependency injection
│   │   ├── extensions/       # Dart extensions
│   │   ├── network/          # Dio client & exceptions
│   │   ├── routes/           # App routes & pages
│   │   └── theme/            # Colors, Text styles, Theme
│   ├── data/
│   │   └── models/           # Data models
│   ├── modules/
│   │   └── home/             # Home module
│   │       ├── bindings/
│   │       ├── controllers/
│   │       └── views/
│   └── shared/
│       └── widgets/          # Common widgets
├── generated/                # Generated code (flutter_gen, locale_keys)
└── main.dart
```

## Makefile Commands

```bash
# Get dependencies
make get

# Clean project
make clean

# Generate code
make gen

# Watch for changes
make watch

# Generate assets
make gen_assets

# Analyze code
make analyze

# Format code
make format

# Run tests
make test

# Run app
make run

# Build APK
make build_apk

# Build iOS
make build_ios

# Full setup
make setup
```

## Quick Start

1. Clone project
2. Chạy `make setup` để cài đặt dependencies và generate code
3. Chạy `make run` để chạy app

## Widgets có sẵn

- `AppButton` - Button với nhiều variants (primary, secondary, outlined, text, danger)
- `AppAppBar` - Custom AppBar với theme support
- `AppDialog` - Dialog với nhiều types (info, success, warning, error, confirm, loading)
- `AppSnackBar` - Snackbar với nhiều types

## Theme

Hỗ trợ Light/Dark mode với toggle button trên Home screen.

## Localization

- Hỗ trợ English và Vietnamese
- Sử dụng `LocaleKeys` để truy cập translation keys
- File translations nằm trong `assets/translations/`

## Lưu ý

- Fonts Roboto cần được download từ Google Fonts và đặt vào `assets/fonts/`
- Thay thế placeholder icon và images bằng assets thực tế
