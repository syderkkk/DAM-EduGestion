import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════
//  CLEAN BLUE — Professional Light Design System
//  Palette: White · Light Blue · Navy · Slate
// ══════════════════════════════════════════════════════════════

abstract class AppColors {
  // Backgrounds
  static const bg         = Color(0xFFF0F5FF);   // azul muy tenue
  static const white      = Color(0xFFFFFFFF);
  static const surface    = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFEFF4FF);   // levemente azul

  // Azul primario — navy
  static const primary    = Color(0xFF1E3A8A);   // azul marino
  static const primaryMid = Color(0xFF2563EB);   // azul medio
  static const primaryLight = Color(0xFF3B82F6); // azul claro
  static const primaryFaint = Color(0xFFEFF6FF); // azul muy suave

  // Texto
  static const textDark   = Color(0xFF0F172A);   // casi negro
  static const textMid    = Color(0xFF475569);   // gris azulado
  static const textLight  = Color(0xFF94A3B8);   // gris claro

  // Bordes
  static const border     = Color(0xFFE2E8F0);
  static const borderFocus= Color(0xFF3B82F6);

  // Estado
  static const success    = Color(0xFF10B981);
  static const error      = Color(0xFFEF4444);
  static const warning    = Color(0xFFF59E0B);
}

abstract class AppTextStyles {
  static TextStyle display({Color color = AppColors.textDark}) => TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    height: 1.15,
    color: color,
  );

  static TextStyle heading({Color color = AppColors.textDark}) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: color,
  );

  static TextStyle title({Color color = AppColors.textDark}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: color,
  );

  static TextStyle body({Color color = AppColors.textMid}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
    color: color,
  );

  static TextStyle label({Color color = AppColors.textLight}) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: color,
  );

  static TextStyle caption({Color color = AppColors.textLight}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
  );
}

// ── Decoraciones compartidas ──────────────────────────────────

BoxDecoration cardDecoration({
  Color bg = AppColors.white,
  double radius = 14,
  bool shadow = true,
}) =>
    BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.border),
      boxShadow: shadow
          ? [
              BoxShadow(
                color: const Color(0xFF1E3A8A).withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    );

InputDecoration appInputDecoration({
  required String label,
  required IconData icon,
  bool focused = false,
  Widget? suffix,
}) =>
    InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.body(
        color: focused ? AppColors.primaryMid : AppColors.textLight,
      ),
      prefixIcon: Icon(icon,
          color: focused ? AppColors.primaryMid : AppColors.textLight,
          size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: focused ? AppColors.primaryFaint : AppColors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColors.primaryMid, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      errorStyle:
          AppTextStyles.caption(color: AppColors.error),
    );
