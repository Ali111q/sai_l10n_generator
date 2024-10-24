import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'l10n_generator.dart';

Builder l10nBuilder(BuilderOptions options) => LibraryBuilder(
      L10nGenerator(),
      generatedExtension: '.arb',
    );
