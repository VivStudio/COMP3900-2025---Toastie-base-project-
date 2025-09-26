import 'package:flutter/services.dart';

/** Utility functions used across the app. */

String capitalizeFirstCharacter(String input) {
  if (input.length == 0) return '';
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[\w+.-]+(\.[\w+.-]+)*@[\w-]+(\.[\w-]+)+$',
  );
  return emailRegex.hasMatch(email);
}

bool isStrongPassword(String password) {
  final RegExp strongPassword =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$');
  return strongPassword.hasMatch(password);
}

List<TextInputFormatter> allowDoublesOnly() {
  return [
    FilteringTextInputFormatter.allow(
      RegExp(r'^\d+\.?\d{0,2}'),
    ),
  ];
}

String stripTrailingNewlines(String input) {
  return input.replaceAll(RegExp(r'[\r\n]+$'), '');
}

// TODO: deprecate this, you can do this by using enum.name instead.
String getEnumName(String enumString) {
  return capitalizeFirstCharacter(enumString.split('.').last);
}
