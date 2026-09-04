import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double chip = 12;
  static const double input = 12;
  static const double card = 16;
  static const double sheet = 24;
  static const double modal = 24;

  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get chipRadius => BorderRadius.circular(chip);
  static BorderRadius get sheetRadius =>
      const BorderRadius.vertical(top: Radius.circular(sheet));
  static BorderRadius get sheetRadiusAll => BorderRadius.circular(sheet);
}
