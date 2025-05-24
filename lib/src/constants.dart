part of '../uni_size.dart';

/// Constants used throughout the UniSize package
class UniSizeConstants {
  UniSizeConstants._();

  /// Default design width (based on common mobile design standards)
  static const double defaultDesignWidth = 375.0;

  /// Default design height (based on common mobile design standards)
  static const double defaultDesignHeight = 812.0;

  /// Minimum text scale factor to prevent text from becoming too small
  static const double minTextScale = 0.8;

  /// Maximum text scale factor to prevent text from becoming too large
  static const double maxTextScale = 2.0;

  /// Base density for Android (160 DPI)
  static const double baseDensity = 160.0;

  /// Breakpoint for mobile devices (in dp)
  static const double mobileBreakpoint = 600.0;

  /// Breakpoint for tablet devices (in dp)
  static const double tabletBreakpoint = 1024.0;

  /// Default pixel ratio for calculations
  static const double defaultPixelRatio = 1.0;

  /// Platform specific scaling factors
  static const Map<String, double> platformScaleFactors = {
    'android': 1.0,
    'ios': 1.0,
    'web': 1.0,
    'windows': 1.25,
    'macos': 1.0,
    'linux': 1.0,
  };
}