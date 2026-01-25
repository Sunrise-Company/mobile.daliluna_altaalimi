import 'package:flutter/material.dart';

/// Manager for cart animation keys across different screens
class CartAnimationKeys {
  // Keys for each screen's basket widget
  static final Map<String, GlobalKey> _screenKeys = {};

  /// Get or create a key for a specific screen
  static GlobalKey getKeyForScreen(String screenName) {
    if (!_screenKeys.containsKey(screenName)) {
      _screenKeys[screenName] = GlobalKey(debugLabel: 'cart_$screenName');
    }
    return _screenKeys[screenName]!;
  }

  /// Clear all keys (useful for testing or cleanup)
  static void clearKeys() {
    _screenKeys.clear();
  }

  // Common screen keys
  static GlobalKey get unitsSubject => getKeyForScreen('unitssubject');
  static GlobalKey get sectionSelected => getKeyForScreen('sectionselected');
  static GlobalKey get sectionsSubject => getKeyForScreen('sectionssubject');
  static GlobalKey get lessons => getKeyForScreen('lessons');

  static GlobalKey get ourCourses => getKeyForScreen('ourcourses');
}
