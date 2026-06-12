import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// WhatsApp green color
const kWhatsAppGreen = Color(0xFF25D366);

/// Platform-specific Christmas themes
class ChristmasThemes {
  // === ANDROID THEME (Material Design) ===
  static ThemeData androidTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Christmas color palette
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFC62828), // Deep red
      brightness: Brightness.light,
      primary: const Color(0xFFC62828),   // Christmas red
      secondary: const Color(0xFF2E7D32), // Christmas green
      surface: const Color(0xFFFFF8F0),   // Warm white (snow)
      error: const Color(0xFFB71C1C),
    ),

    // AppBar styling
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    // Card styling
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),

    // Button styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // Dialog styling
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: Color(0xFFC62828)),
  );

  // === iO S THEME (Cupertino-inspired) ===
  static ThemeData iosTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Christmas color palette - softer, more pastel for iOS
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD32F2F), // Softer red
      brightness: Brightness.light,
      primary: const Color(0xFFD32F2F),   // iOS red
      secondary: const Color(0xFF388E3C), // iOS green
      surface: const Color(0xFFFDFBF7),   // Very warm white
    ),

    // AppBar styling - iOS style
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    // Card styling - more rounded for iOS
    cardTheme: CardTheme(
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
    ),

    // Button styling - iOS style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    // Input decoration - iOS style
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),

    // Dialog styling - iOS style
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      elevation: 10,
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: Color(0xFFD32F2F)),
  );

  /// Get the correct theme based on platform
  static ThemeData getTheme() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosTheme;
    }
    return androidTheme;
  }
}

/// Helper to create WhatsApp button style
Widget whatsappButton({
  required VoidCallback onPressed,
  double size = 28,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kWhatsAppGreen.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.chat,
        color: kWhatsAppGreen,
        size: size,
      ),
    ),
  );
}
