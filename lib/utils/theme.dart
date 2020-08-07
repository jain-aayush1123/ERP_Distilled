import 'package:erp_distilled/utils/colors.dart';
import 'package:flutter/material.dart';

final ThemeData THEME_DATA = _buildAppTheme();

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: MColors.accentColor,
    primaryColor: MColors.primaryColor,
    primaryColorDark: MColors.primaryDarkColor,
  );
}
