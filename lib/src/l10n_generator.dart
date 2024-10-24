import 'dart:async';
import 'dart:io';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

/// A generator that scans the entire project for .tr strings and generates a Dart file for localization.
class L10nGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    // Define the Dart file path for localization
    final localizationDartFile =
        File('lib/core/utils/l10n/app_translations.g.dart');

    // Check if the file exists, if not, create it
    if (!await localizationDartFile.exists()) {
      print('app_translations.dart not found, creating...');
      await localizationDartFile.create(recursive: true);
    }

    // Regular expression to match strings with both ' and " followed by .tr
    final trRegex = RegExp(r'''['\"](.*?)['\"]\s*\.tr''');

    // Set to store new keys
    final newKeys = <String>{};

    // Process all Dart files in the lib/ directory
    await for (var input in buildStep.findAssets(Glob('lib/**/*.dart'))) {
      final fileContent = await buildStep.readAsString(input);

      // Find all matches of .tr strings in the file
      final matches = trRegex.allMatches(fileContent);
      for (final match in matches) {
        final key = match.group(1);

        if (key != null && key.isNotEmpty) {
          newKeys.add(key); // Add key to set
        }
      }
    }
    await for (var input in buildStep.findAssets(Glob('lib/**/**/*.dart'))) {
      final fileContent = await buildStep.readAsString(input);

      // Find all matches of .tr strings in the file
      final matches = trRegex.allMatches(fileContent);
      for (final match in matches) {
        final key = match.group(1);

        if (key != null && key.isNotEmpty) {
          newKeys.add(key); // Add key to set
        }
      }
    }
    await for (var input in buildStep.findAssets(Glob('lib/*.dart'))) {
      final fileContent = await buildStep.readAsString(input);

      // Find all matches of .tr strings in the file
      final matches = trRegex.allMatches(fileContent);
      for (final match in matches) {
        final key = match.group(1);

        if (key != null && key.isNotEmpty) {
          newKeys.add(key); // Add key to set
        }
      }
    }

    // If the file exists, parse existing keys from the generated Dart file
    final existingKeys = await _getExistingKeysFromFile(localizationDartFile);

    // Combine new keys with existing keys
    final allKeys = {...existingKeys, ...newKeys};

    // If there are keys, generate the Dart localization file
    if (allKeys.isNotEmpty) {
      await _writeToDartFile(localizationDartFile, allKeys);
      print('Added ${newKeys.length} new keys to Dart localization file.');
    } else {
      print('No new .tr strings found.');
    }

    return null;
  }

  // Helper method to write the localization keys to the Dart file
  Future<void> _writeToDartFile(File file, Set<String> keys) async {
    final arabicTranslations = <String, String>{};
    final englishTranslations = <String, String>{};

    for (var key in keys) {
      arabicTranslations[key] =
          ''; // Initialize with empty translations in Arabic
      englishTranslations[key] =
          ''; // Initialize with empty translations in English
    }

    // Generate Dart file content with GetX localization pattern
    final content = StringBuffer()
      ..writeln("part of 'app_translations.dart';")
      ..writeln()
      ..writeln('class _AppTranslation implements AppTranslation {')
      ..writeln('@override')
      ..writeln('  Map<String, Map<String, String>> get keys => {')
      ..writeln('    \'ar\': Locales.ar,')
      ..writeln('    \'en\': Locales.en,')
      ..writeln('  };')
      ..writeln('}')
      ..writeln()
      ..writeln('class Locales {')
      ..writeln('  static const ar = {');

    for (var entry in arabicTranslations.entries) {
      content.writeln('    \"${entry.key}\": \"${entry.value}\",');
    }

    content
      ..writeln('  };')
      ..writeln('  static const en = {');

    for (var entry in englishTranslations.entries) {
      content.writeln('    \'${entry.key}\': \'${entry.value}\',');
    }

    content.writeln('  };');
    content.writeln('}');

    // Write content to the Dart file
    await file.writeAsString(content.toString());
  }

  // Helper method to get existing keys from the generated Dart file
  Future<Set<String>> _getExistingKeysFromFile(File file) async {
    final existingKeys = <String>{};

    if (!await file.exists()) {
      return existingKeys; // If the file doesn't exist, return an empty set
    }

    final content = await file.readAsString();

    // Regular expression to match existing translation keys in the file
    final keyRegex = RegExp(r'\"(.*?)\":');

    // Find all matches of existing keys in the file content
    final matches = keyRegex.allMatches(content);
    for (final match in matches) {
      final key = match.group(1);
      if (key != null && key.isNotEmpty) {
        existingKeys.add(key);
      }
    }

    return existingKeys;
  }
}
