# sai_l10n_generator

`sai_l10n_generator` is a custom Dart code generator for Flutter projects that automatically scans your Dart files for `.tr` strings and generates a Dart file (`app_translations.g.dart`) for managing localized strings with GetX. It ensures that existing keys in the generated file are preserved, and new keys are added as they are found.

## Features

- Automatically scans all Dart files in the `lib/` directory for `.tr` strings.
- Generates or updates a Dart file for localization in the structure required by GetX.
- Ensures that existing localization keys are not removed, only new keys are added.

## Installation

### 1. Add the Dependency

In your `pubspec.yaml` file, add `sai_l10n_generator` as a dependency in the `dev_dependencies` section:

```yaml
dev_dependencies:
sai_l10n_generator:
path: ../sai_l10n_generator # Or add the hosted package if available
build_runner: ^2.1.7
source_gen: ^1.1.1
```

### 2. Configure `build.yaml`

Ensure that your package or project includes a `build.yaml` file with the following configuration:

```yaml
targets:
$default:
builders:
sai\*l10n_generator|l10n_builder:
enabled: true
generate_for: - lib/\*\*/\_.dart

builders:
sai_l10n_generator|l10n_builder:
import: "package:sai_l10n_generator/src/l10n_builder.dart"
builder_factories: ["l10nBuilder"]
build_extensions: {".dart": [".g.dart"]}
auto_apply: root_package
build_to: source
applies_builders: ["source_gen|combining_builder"]
```

This configuration tells the `build_runner` to process all Dart files in the `lib/` folder for `.tr` strings and generate the appropriate localization file.

## Usage

### 1. Mark Strings for Localization

In your Dart files, use `.tr` to mark strings that need localization. Example:

```dart
Text('helloWorld'.tr),
Text('welcomeMessage'.tr),
```

The `.tr` extension indicates that this string should be added to the localization files.

### 2. Run the Generator

To generate or update your localization Dart file, run the following command in your terminal:

```bash
flutter pub run build_runner build
```

This will scan all Dart files in the `lib/` folder and generate or update the `lib/core/utils/l10n/app_translations.g.dart` file with your localization keys.

### 3. Generated Localization File

The generated Dart file will follow the pattern used by GetX for localization. Here’s an example of what the `app_translations.g.dart` file might look like:

```dart
part of 'app_translations.dart';

class \_AppTranslation implements AppTranslation {
@override
Map<String, Map<String, String>> get keys => {
'ar': Locales.ar,
'en': Locales.en,
};
}

class Locales {
static const ar = {
"hello": "",
"welcomeMessage": "",
"clickMe": "",
};
static const en = {
'hello': '',
'welcomeMessage': '',
'clickMe': '',
};
}
```

You can manually populate the translations for both `ar` (Arabic) and `en` (English) in the generated file.

### 4. Retaining Existing Keys

The generator checks for any existing keys in the `app_translations.g.dart` file. If the file already contains keys, those keys will **not** be removed. The generator only adds new keys it discovers in the project. This ensures that your manually populated translations remain intact.

## Customization

By default, the package generates a localization file for Arabic (`ar`) and English (`en`). If you need to support additional languages, you can extend the generator to include more localization maps.

## Cleaning Build Artifacts

If you need to clean the generated build artifacts, run:

```bash
flutter pub run build_runner clean
```

This will remove all build caches and force a clean rebuild on the next `build_runner` command.

## Contributing

Feel free to open issues or submit pull requests if you encounter any bugs or have suggestions for improvements!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
