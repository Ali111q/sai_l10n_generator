import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/utils/l10n/app_translations.dart'; // Import the generated localization file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use the GetX translations and specify the initial locale
      translations: AppTranslation
          .instance(), // The translation maps from app_translations.dart
      locale: Locale(
          'en', 'US'), // Default locale (can be set to any supported language)

      fallbackLocale: Locale(
          'en', 'US'), // Fallback to English if the locale is not supported

      // Add the localization delegates for Material, Widgets, and Cupertino

      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hello'.tr), // Using GetX to translate 'hello'
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              // Switch between English and Arabic
              Locale currentLocale = Get.locale!;
              if (currentLocale.languageCode == 'en') {
                Get.updateLocale(Locale('ar', 'AR')); // Switch to Arabic
              } else {
                Get.updateLocale(Locale('en', 'US')); // Switch to English
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('welcomeMessage'.tr), // GetX translation for 'welcomeMessage'
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for button press
              },
              child: Text('clickMe'.tr), // GetX translation for 'clickMe'
            ),
          ],
        ),
      ),
    );
  }
}
