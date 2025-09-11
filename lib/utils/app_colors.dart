import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  // --- Primary Colors ---
  // Blue shades for reliability and stability
  static const Color primaryBlueLight =
      Color(0xFF87CEEB); // Light Blue / Sky Blue
  static const Color primaryBlueMedium =
      Color(0xFF007BFF); // Medium Blue / Cerulean
  static const Color primaryBluePastel = Color(0xFFA7D9FF); // Pastel Blue

  // Green shades for growth, harmony, and safety
  static const Color primaryGreenMint = Color(0xFFB6EDC8); // Mint Green
  static const Color primary = Color(0xFF7FBC8A); // Soft Green / Sage Green
  static const Color primaryGreenForest = Color(0xFF228B22); // Forest Green

  // Purple shades for creativity and unique friendliness
  static const Color primaryPurpleLavender =
      Color(0xFFD2B4DE); // Lavender Purple
  static const Color primaryPurpleLightViolet =
      Color(0xFFA98ED1); // Light Violet
  static const Color primaryPurplePlum = Color(0xFF8E44AD); // Plum

  // --- Button Colors ---
  // Primary action buttons (e.g., "Lock App", "Save Settings")
  // These are often a darker shade of the chosen primary color or a strong accent.
  static const Color buttonPrimaryBlueDark =
      Color(0xFF0056B3); // Darker Blue for primary actions
  static const Color buttonPrimaryGreenDark =
      Color(0xFF28A745); // Darker Green for primary actions
  static const Color buttonPrimaryPurpleDark =
      Color(0xFF6A0DAD); // Darker Purple for primary actions

  // Accent colors for primary buttons (can be used regardless of primary theme)
  static const Color buttonAccentOrange =
      Color(0xFFFFA500); // Bright Orange for strong emphasis
  static const Color buttonAccentYellow =
      Color(0xFFFFD700); // Bright Yellow for attention
  static const Color buttonAccentPink =
      Color(0xFFFF69B4); // Hot Pink for a friendly, unique touch

  // Secondary/Cancel buttons (e.g., "Cancel", "Back")
  // Neutral tones for less emphasis.
  static const Color buttonSecondaryLightGray = Color(0xFFE0E0E0); // Light Gray
  static const Color buttonSecondaryMediumGray =
      Color(0xFFB0B0B0); // Medium Gray

  // Warning/Danger buttons (e.g., "Delete Data", "Uninstall")
  // Soft reds or orange-reds for caution.
  static const Color buttonDangerSoftRed =
      Color(0xFFDC3545); // Soft Red (common UI danger color)
  static const Color buttonDangerOrangeRed = Color(0xFFFF6347); // Orange-Red

  // --- Text Colors ---
  // Main text colors for readability on light backgrounds.
  static const Color textPrimaryDark =
      Color(0xFF212121); // Very dark gray/almost black
  static const Color textSecondaryDark = Color(0xFF333333); // Dark gray
  static const Color textHintGray =
      Color(0xFF757575); // Medium gray for hints/sub-text

  // Text color for elements on colored backgrounds (e.g., buttons, colored headers)
  static const Color textOnColoredBackground = Color(0xFFFFFFFF); // Pure White

  // --- Background Colors ---
  // Clean and modern background options.
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure White
  static const Color backgroundLightGray =
      Color(0xFFF8F8F8); // Off-white / very light gray
  static const Color backgroundFaintGray =
      Color(0xFFF0F0F0); // Slightly darker off-white

  // base colors
  static const white = Colors.white;
  static const greyCACACA = Color(0xFFCACACA);
  static const grey969696 = Color(0xFF969696);
  static const grey999999 = Color(0xFF999999);
  static const black393939 = Color(0xFF393939);
  static const black1 = Color(0xFF111111);
  static const blueAFE1F2 = Color(0xFFAFE1F2);
  static const greenC6F0B7 = Color(0xFFC6F0B7);
  static const orangeEFD19B = Color(0xFFEFD19B);
  static const Color lineColor4 = Color(0xFFE6EAE8);
  static const Color melonColor = Color(0xFFFA5075);



  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
