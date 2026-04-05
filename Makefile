.PHONY: setup
setup:
	flutter clean
	flutter pub get

.PHONY: watch
watch:
	flutter pub run build_runner watch --delete-conflicting-outputs