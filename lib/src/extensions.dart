part of '../uni_size.dart';

/// Extension on num to provide sizing utilities
extension UniSizeExtension on num {
  /// Convert to density-independent pixels (dp)
  ///
  /// Use this for all size-related properties like width, height,
  /// padding, margin, border radius, etc.
  ///
  /// Example:
  /// ```dart
  /// Container(
  ///   width: 100.dp,
  ///   height: 50.dp,
  ///   padding: EdgeInsets.all(16.dp),
  /// )
  /// ```
  double get dp => UniSizeDevice.calculateDp(this);

  /// Convert to scalable pixels (sp) for fonts
  ///
  /// Use this specifically for font sizes. It considers the device's
  /// text scale factor and provides consistent text sizing across platforms.
  ///
  /// Example:
  /// ```dart
  /// Text(
  ///   'Hello World',
  ///   style: TextStyle(fontSize: 16.sp),
  /// )
  /// ```
  double get sp => UniSizeDevice.calculateSp(this);

  /// Get responsive value based on screen type
  ///
  /// Provides different values for mobile, tablet, and desktop screens.
  ///
  /// Example:
  /// ```dart
  /// final fontSize = 16.responsive(
  ///   mobile: 14.sp,
  ///   tablet: 16.sp,
  ///   desktop: 18.sp,
  /// );
  /// ```
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    return UniSizeDevice.responsive<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  // Additional utility getters for legacy support and convenience

  /// Alias for dp - density-independent pixels
  double get dip => dp;

  /// Convert to percentage of screen width
  double get w => (this / 100) * UniSizeDevice.logicalWidth;

  /// Convert to percentage of screen height
  double get h => (this / 100) * UniSizeDevice.logicalHeight;

  /// Convert to percentage of smaller screen dimension
  double get smin =>
      (this / 100) *
      min(UniSizeDevice.logicalWidth, UniSizeDevice.logicalHeight);

  /// Convert to percentage of larger screen dimension
  double get smax =>
      (this / 100) *
      max(UniSizeDevice.logicalWidth, UniSizeDevice.logicalHeight);

  /// Convert to pixels (1:1 mapping)
  double get px => toDouble();

  /// Convert to viewport width percentage (CSS vw equivalent)
  double get vw => (this / 100) * UniSizeDevice.logicalWidth;

  /// Convert to viewport height percentage (CSS vh equivalent)
  double get vh => (this / 100) * UniSizeDevice.logicalHeight;

  /// Convert to viewport minimum percentage (CSS vmin equivalent)
  double get vmin =>
      (this / 100) *
      min(UniSizeDevice.logicalWidth, UniSizeDevice.logicalHeight);

  /// Convert to viewport maximum percentage (CSS vmax equivalent)
  double get vmax =>
      (this / 100) *
      max(UniSizeDevice.logicalWidth, UniSizeDevice.logicalHeight);
}

/// Extension on BuildContext for UniSize utilities
extension UniSizeContextExtension on BuildContext {
  /// Initialize or update UniSize with current context
  void initUniSize({
    double? designWidth,
    double? designHeight,
    double? minTextScaleFactor,
    double? maxTextScaleFactor,
  }) {
    UniSizeDevice.init(
      this,
      designWidth: designWidth ?? UniSizeConstants.defaultDesignWidth,
      designHeight: designHeight ?? UniSizeConstants.defaultDesignHeight,
      minTextScaleFactor: minTextScaleFactor ?? UniSizeConstants.minTextScale,
      maxTextScaleFactor: maxTextScaleFactor ?? UniSizeConstants.maxTextScale,
    );
  }

  /// Update UniSize with current context (useful for orientation changes)
  void updateUniSize() {
    UniSizeDevice.update(this);
  }

  /// Get device information
  UniSizeDeviceType get deviceType => UniSizeDevice.deviceType;

  /// Get screen type
  UniSizeScreenType get screenType => UniSizeDevice.screenType;

  /// Check if mobile device
  bool get isMobile => UniSizeDevice.isMobile;

  /// Check if tablet device
  bool get isTablet => UniSizeDevice.isTablet;

  /// Check if desktop device
  bool get isDesktop => UniSizeDevice.isDesktop;

  /// Check if portrait orientation
  bool get isPortrait => UniSizeDevice.isPortrait;

  /// Check if landscape orientation
  bool get isLandscape => UniSizeDevice.isLandscape;
}
