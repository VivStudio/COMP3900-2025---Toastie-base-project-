import 'package:flutter/material.dart';
import 'package:toastie/themes/colors.dart';
import 'package:toastie/themes/text/text_utils.dart';
import 'package:toastie/utils/device_utils.dart';

final FontWeight fontWeightNormal = FontWeight.normal;
final FontWeight fontWeightMedium = FontWeight.w500;

/// All definitions for the branding of Toastie belongs in this theme class.
class ToastieTheme {
  static final ThemeData defaultTheme = _buildTheme();

  static ThemeData _buildTheme() {
    final List<FontFeature> disableLigatures = [
      FontFeature.disable('liga'),
    ];

    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: primary,
      colorScheme: ColorScheme(
        primary: primary,
        brightness: Brightness.light,
        error: warning,
        onError: Colors.white,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSecondary: Colors.white,
        onSurface: primary,
        secondary: accentPink,
      ),
      // dialogTheme: DialogTheme(surfaceTintColor: primary),

      // Define the default font family.
      fontFamily: toastieFontFamilyMap[ToastieFontFamily.ttNorms],

      textTheme: TextTheme(
        /** Display */
        // The toastie logo text
        displayLarge: TextStyle(
          color: Colors.white,
          fontFamily: toastieFontFamilyMap[ToastieFontFamily.kollektif],
          fontSize: getDeviceType() == DeviceType.Phone ? 60.0 : 72.0,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(3.0, 3.0),
              blurRadius: 0,
              color: toastBrown,
            ),
          ],
        ),
        // Home page 'hi'
        // New pages title screen - but bolded
        displayMedium: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 28.0 : 36.0,
          fontWeight: fontWeightNormal,
        ),
        displaySmall: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 22.0 : 28.0,
          fontWeight: fontWeightNormal,
        ),

        /** Headline */
        // Day carousel number
        // Page titles
        headlineLarge: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 24.0 : 28.0,
          fontWeight: fontWeightMedium,
        ),
        // Used for title of each page
        headlineMedium: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 18.0 : 24.0,
          fontWeight: fontWeightMedium,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 16.0 : 20.0,
          fontWeight: fontWeightMedium, // text medium
        ),

        /** Title */
        // Used for day carousel but on regular font
        // Summary section titles
        // Gradient buttons
        // Authentication buttons
        titleLarge: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 20.0 : 24.0,
          fontWeight: fontWeightMedium,
        ),
        // Magic tracker 'track your day'
        // Summary card titles
        // Textfield
        // Time editor colon
        // Toggle buttons
        // Donation card title
        titleMedium: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 16.0 : 20.0,
          fontWeight: fontWeightMedium, // text regular
        ),
        // Meal card name
        // Meal image title
        // Note card
        titleSmall: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 14.0 : 20.0,
          fontWeight: fontWeightMedium,
        ),

        /** Body */
        bodyLarge: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 16.0 : 20.0,
          fontWeight: fontWeightNormal, // text regular
        ),
        // Summary card body text
        // Donation card body text
        bodyMedium: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 15.0 : 20.0,
          fontWeight: fontWeightNormal, // text regular
        ),
        bodySmall: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: getDeviceType() == DeviceType.Phone ? 12.0 : 16.0,
          fontWeight: fontWeightNormal, // text regular
        ),

        /** Label */
        // Text button
        labelLarge: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: 14.0,
          fontWeight: fontWeightMedium, // text medium
        ),
        // Card severity
        labelMedium: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: 12.0,
          fontWeight: fontWeightMedium, // text medium
        ),
        // Account details - but unsure why it doesn't bold
        labelSmall: TextStyle(
          color: Colors.black,
          fontFeatures: disableLigatures,
          fontSize: 11.0,
          fontWeight: FontWeight.w600, // text medium
        ),
      ),
    );
  }

  static TextTheme getTextTheme(BuildContext context) {
    final baseTextTheme = defaultTheme.textTheme;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return TextTheme(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize:
            (baseTextTheme.displayLarge?.fontSize ?? 60.0) * textScaleFactor,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize:
            (baseTextTheme.displayMedium?.fontSize ?? 28.0) * textScaleFactor,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize:
            (baseTextTheme.displaySmall?.fontSize ?? 22.0) * textScaleFactor,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontSize:
            (baseTextTheme.headlineLarge?.fontSize ?? 24.0) * textScaleFactor,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize:
            (baseTextTheme.headlineMedium?.fontSize ?? 18.0) * textScaleFactor,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize:
            (baseTextTheme.headlineSmall?.fontSize ?? 16.0) * textScaleFactor,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize:
            (baseTextTheme.titleLarge?.fontSize ?? 20.0) * textScaleFactor,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize:
            (baseTextTheme.titleMedium?.fontSize ?? 16.0) * textScaleFactor,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize:
            (baseTextTheme.titleSmall?.fontSize ?? 14.0) * textScaleFactor,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: (baseTextTheme.bodyLarge?.fontSize ?? 16.0) * textScaleFactor,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize:
            (baseTextTheme.bodyMedium?.fontSize ?? 15.0) * textScaleFactor,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: (baseTextTheme.bodySmall?.fontSize ?? 12.0) * textScaleFactor,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize:
            (baseTextTheme.labelLarge?.fontSize ?? 14.0) * textScaleFactor,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize:
            (baseTextTheme.labelMedium?.fontSize ?? 12.0) * textScaleFactor,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize:
            (baseTextTheme.labelSmall?.fontSize ?? 11.0) * textScaleFactor,
      ),
    );
  }
}
