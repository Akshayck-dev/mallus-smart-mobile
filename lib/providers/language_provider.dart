import 'package:flutter/material.dart';

enum AppLanguage { english, malayalam }

class LanguageProvider with ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english;
  AppLanguage get currentLanguage => _currentLanguage;

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == AppLanguage.english 
        ? AppLanguage.malayalam 
        : AppLanguage.english;
    notifyListeners();
  }

  String translate(String key) {
    if (_currentLanguage == AppLanguage.malayalam) {
      return _malayalamTranslations[key] ?? key;
    }
    return _englishTranslations[key] ?? key;
  }

  static const Map<String, String> _englishTranslations = {
    'explore': 'EXPLORE',
    'curated_collections': 'Curated\nCollections',
    'search_hint': 'Search the collection...',
    'favorites': 'FAVORITES',
    'my_orders': 'MY ORDERS',
    'settings': 'SETTINGS',
    'dark_mode': 'DARK MODE',
    'language': 'LANGUAGE',
    'welcome': 'Welcome back,',
    'user_name': 'Mallu Guest',
    'add_to_cart': 'ADD TO CART',
    'my_selection': 'MY SELECTION',
  };

  static const Map<String, String> _malayalamTranslations = {
    'explore': 'അന്വേഷിക്കുക',
    'curated_collections': 'തിരഞ്ഞെടുത്ത\nശേഖരങ്ങൾ',
    'search_hint': 'ശേഖരത്തിൽ തിരയുക...',
    'favorites': 'ഇഷ്ടപ്പെട്ടവ',
    'my_orders': 'എന്റെ ഓർഡറുകൾ',
    'settings': 'ക്രമീകരണങ്ങൾ',
    'dark_mode': 'ഡാർക്ക് മോഡ്',
    'language': 'ഭാഷ',
    'welcome': 'വീണ്ടും സ്വാഗതം,',
    'user_name': 'മല്ലു ഗസ്റ്റ്',
    'add_to_cart': 'കാർട്ടിലേക്ക് ചേർക്കുക',
    'my_selection': 'എന്റെ സെലക്ഷൻ',
  };
}
