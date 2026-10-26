import 'package:flutter/material.dart';

/// Institutional palette extracted from the CWTS Sétif prototype.
/// Zero hardcoded colors allowed in widgets — always reference these tokens.
abstract final class AppColors {
  static const background = Color(0xFFF4F6FB);
  static const card = Color(0xFFFFFFFF);
  static const primary = Color(0xFF2557A7);
  static const primaryDark = Color(0xFF1D3B73);
  static const primaryDeep = Color(0xFF12264E);
  static const sidebarActive = Color(0xFF2E6FD8);
  static const primaryForeground = Color(0xFFFFFFFF);
  static const blood = Color(0xFFD92638);
  static const bloodSoft = Color(0xFFFDECEE);
  static const success = Color(0xFF1F9D55);
  static const warning = Color(0xFFD9822B);
  static const destructive = Color(0xFFDC2626);
  static const border = Color(0xFFE2E8F0);
  static const muted = Color(0xFFF1F5F9);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);

  /// Header banner gradient (120deg in prototype).
  static const headerGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xFFF4F7FC), Color(0xFFE4ECF7)],
  );

  /// Deep navy sidebar gradient.
  static const sidebarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primaryDeep],
  );

  /// Color per eligibility status key ('due' | 'soon' | 'wait' | 'none').
  static Color statusColor(String status) => switch (status) {
    'due' => success,
    'soon' => warning,
    'wait' => textSecondary,
    _ => textSecondary,
  };
}
