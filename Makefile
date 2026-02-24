.PHONY: help clean get build_runner gen watch analyze format test run ios android init rename deploy_android deploy_ios

help:
	@echo "Available commands:"
	@echo ""
	@echo "  Development:"
	@echo "    make get          - Get dependencies"
	@echo "    make clean        - Clean project"
	@echo "    make gen          - Run build_runner once"
	@echo "    make watch        - Run build_runner watch"
	@echo "    make analyze      - Analyze code"
	@echo "    make format       - Format code"
	@echo "    make test         - Run tests"
	@echo ""
	@echo "  Running:"
	@echo "    make run          - Run app"
	@echo "    make ios          - Run on iOS"
	@echo "    make android      - Run on Android"
	@echo ""
	@echo "  Building:"
	@echo "    make build_apk    - Build APK"
	@echo "    make build_ios    - Build iOS"
	@echo "    make build_appbundle - Build App Bundle"
	@echo ""
	@echo "  Setup:"
	@echo "    make setup        - Full project setup"
	@echo "    make all          - Clean, get deps and generate"
	@echo ""
	@echo "  New Project:"
	@echo "    make rename name=qr_ems - Rename package to com.kullhi.<name>"
	@echo "    make init APP_NAME=\"My App\" PACKAGE_NAME=\"com.example.myapp\" - Initialize with args"
	@echo ""
	@echo "  Deployment:"
	@echo "    make deploy_android - Run Fastlane Android beta lane"
	@echo "    make deploy_ios     - Run Fastlane iOS beta lane"

get:
	flutter pub get

clean:
	flutter clean
	rm -rf .dart_tool
	rm -rf build
	rm -rf .flutter-plugins
	rm -rf .flutter-plugins-dependencies

gen:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

gen_assets:
	dart run build_runner build --delete-conflicting-outputs

gen_locale:
	@echo "Locale files are in assets/translations/"

analyze:
	flutter analyze

format:
	dart format lib/

test:
	flutter test

run:
	flutter run

ios:
	flutter run -d ios

android:
	flutter run -d android

build_apk:
	flutter build apk --release

build_ios:
	flutter build ios --release

build_appbundle:
	flutter build appbundle --release

all: clean get gen
	@echo "Project setup complete!"

setup:
	flutter pub get
	dart run build_runner build --delete-conflicting-outputs
	@echo "Setup complete!"

init:
ifdef APP_NAME
ifdef PACKAGE_NAME
	@chmod +x scripts/init_app.sh
	@./scripts/init_app.sh "$(APP_NAME)" "$(PACKAGE_NAME)" "$(BUNDLE_ID)"
else
	@echo "Missing PACKAGE_NAME. Usage: make init APP_NAME=\"My App\" PACKAGE_NAME=\"com.example.myapp\""
endif
else
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║           Initialize New App from Base Project               ║"
	@echo "╚══════════════════════════════════════════════════════════════╝"
	@echo ""
	@read -p "Enter App Name (e.g., My App): " app_name; \
	read -p "Enter Package Name (e.g., com.example.myapp): " package_name; \
	read -p "Enter Bundle ID (press Enter to use package name): " bundle_id; \
	bundle_id=$${bundle_id:-$$package_name}; \
	chmod +x scripts/init_app.sh; \
	./scripts/init_app.sh "$$app_name" "$$package_name" "$$bundle_id"
endif

rename:
	dart run change_app_package_name:main com.kullhi.$(name)

deploy_android:
	cd android && bundle exec fastlane beta

deploy_ios:
	cd ios && bundle exec fastlane beta
