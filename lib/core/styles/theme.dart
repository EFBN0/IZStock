import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFD97706);
  static const danger = Color(0xFFDC2626);
}

class AppRadius {
  AppRadius._();

  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 20.0;
}

class _Palette {
  const _Palette({
    required this.brightness,
    required this.primary,
    required this.background,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.border,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
    required this.onError,
  });

  final Brightness brightness;
  final Color primary;
  final Color background;
  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color border;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;
  final Color onError;
}

const _light = _Palette(
  brightness: Brightness.light,
  primary: Color(0xFF4F46E5),
  background: Color(0xFFF6F7FB),
  surface: Colors.white,
  surfaceContainer: Color(0xFFF0F1F6),
  surfaceContainerHigh: Color(0xFFEBEDF3),
  surfaceContainerHighest: Color(0xFFE4E6EE),
  border: Color(0xFFE6E8EF),
  outline: Color(0xFFCBD0DC),
  textPrimary: Color(0xFF111827),
  textSecondary: Color(0xFF6B7280),
  error: AppColors.danger,
  onError: Colors.white,
);

const _dark = _Palette(
  brightness: Brightness.dark,
  primary: Color(0xFF6366F1),
  background: Color(0xFF0F1115),
  surface: Color(0xFF181B21),
  surfaceContainer: Color(0xFF1F232A),
  surfaceContainerHigh: Color(0xFF262A32),
  surfaceContainerHighest: Color(0xFF2E333C),
  border: Color(0xFF2A2E36),
  outline: Color(0xFF4B5160),
  textPrimary: Color(0xFFF3F4F6),
  textSecondary: Color(0xFF9CA3AF),
  error: Color(0xFFF87171),
  onError: Color(0xFF450A0A),
);

final ThemeData lightTheme = _buildTheme(_light);
final ThemeData darkTheme = _buildTheme(_dark);

ThemeData _buildTheme(_Palette p) {
  final scheme = ColorScheme.fromSeed(
    seedColor: p.primary,
    brightness: p.brightness,
  ).copyWith(
    primary: p.primary,
    onPrimary: Colors.white,
    surface: p.surface,
    onSurface: p.textPrimary,
    onSurfaceVariant: p.textSecondary,
    surfaceContainerLowest: p.surface,
    surfaceContainerLow: p.background,
    surfaceContainer: p.surfaceContainer,
    surfaceContainerHigh: p.surfaceContainerHigh,
    surfaceContainerHighest: p.surfaceContainerHighest,
    outline: p.outline,
    outlineVariant: p.border,
    error: p.error,
    onError: p.onError,
  );

  final baseTextTheme = p.brightness == Brightness.dark
      ? ThemeData(brightness: Brightness.dark).textTheme
      : ThemeData(brightness: Brightness.light).textTheme;

  final textTheme = GoogleFonts.interTextTheme(baseTextTheme).apply(
    bodyColor: p.textPrimary,
    displayColor: p.textPrimary,
  );

  final roundedMd = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
  );

  return ThemeData(
    brightness: p.brightness,
  colorScheme: scheme,
  textTheme: textTheme,
  scaffoldBackgroundColor: p.background,
  splashFactory: InkSparkle.splashFactory,

  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    backgroundColor: p.background,
    surfaceTintColor: Colors.transparent,
    foregroundColor: p.textPrimary,
    titleTextStyle: textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 22,
      letterSpacing: -0.3,
    ),
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    margin: EdgeInsets.zero,
    color: p.surface,
    surfaceTintColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      side: BorderSide(color: p.border),
    ),
  ),

  navigationBarTheme: NavigationBarThemeData(
    height: 68,
    elevation: 0,
    backgroundColor: p.surface,
    surfaceTintColor: Colors.transparent,
    indicatorColor: p.primary.withValues(alpha: 0.12),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => IconThemeData(
        size: 24,
        color: states.contains(WidgetState.selected)
            ? p.primary
            : p.textSecondary,
      ),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => textTheme.labelSmall!.copyWith(
        fontSize: 11,
        fontWeight: states.contains(WidgetState.selected)
            ? FontWeight.w600
            : FontWeight.w500,
        color: states.contains(WidgetState.selected)
            ? p.primary
            : p.textSecondary,
      ),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, 52),
      shape: roundedMd,
      textStyle: textTheme.labelLarge!.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: p.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size(0, 52),
      shape: roundedMd,
      textStyle: textTheme.labelLarge!.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(0, 52),
      foregroundColor: p.textPrimary,
      side: BorderSide(color: p.border),
      shape: roundedMd,
      textStyle: textTheme.labelLarge!.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: p.primary,
      shape: roundedMd,
      textStyle: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: p.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: TextStyle(color: p.textSecondary),
    labelStyle: TextStyle(color: p.textSecondary),
    prefixIconColor: p.textSecondary,
    suffixIconColor: p.textSecondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: p.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: p.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: p.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: scheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: scheme.error, width: 1.5),
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: p.primary,
    foregroundColor: Colors.white,
    elevation: 2,
    highlightElevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    extendedTextStyle: textTheme.labelLarge!.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  ),

  chipTheme: ChipThemeData(
    backgroundColor: p.surface,
    selectedColor: p.primary,
    side: BorderSide(color: p.border),
    showCheckmark: false,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    labelStyle: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),
    secondaryLabelStyle: textTheme.labelLarge!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  ),

  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: p.surface,
    surfaceTintColor: Colors.transparent,
    showDragHandle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: p.surface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    titleTextStyle: textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
  ),

  datePickerTheme: DatePickerThemeData(
    backgroundColor: p.surface,
    surfaceTintColor: Colors.transparent,
    headerForegroundColor: p.textPrimary,
    rangePickerBackgroundColor: p.surface,
    rangePickerSurfaceTintColor: Colors.transparent,
    rangeSelectionBackgroundColor: p.primary.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
  ),

  segmentedButtonTheme: SegmentedButtonThemeData(
    style: SegmentedButton.styleFrom(
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      iconSize: 18,
      backgroundColor: p.surface,
      foregroundColor: p.textSecondary,
      selectedBackgroundColor: p.primary.withValues(alpha: 0.12),
      selectedForegroundColor: p.primary,
      side: BorderSide(color: p.border),
      textStyle: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    ),
  ),

  popupMenuTheme: PopupMenuThemeData(
    color: p.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: p.brightness == Brightness.dark
        ? p.surfaceContainerHighest
        : p.textPrimary,
    contentTextStyle: textTheme.bodyMedium!.copyWith(
      color: p.brightness == Brightness.dark ? p.textPrimary : Colors.white,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
  ),

  tabBarTheme: TabBarThemeData(
    labelColor: p.primary,
    unselectedLabelColor: p.textSecondary,
    indicatorColor: p.primary,
    indicatorSize: TabBarIndicatorSize.label,
    dividerColor: p.border,
    labelStyle: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
    unselectedLabelStyle: textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.w500,
    ),
  ),

  dividerTheme: DividerThemeData(
    color: p.border,
    thickness: 1,
    space: 1,
  ),

  listTileTheme: ListTileThemeData(
    iconColor: p.textSecondary,
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
  ),
);
}
