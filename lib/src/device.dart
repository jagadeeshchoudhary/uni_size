part of '../uni_size.dart';

/// Device types supported by UniSize
enum UniSizeDeviceType { android, ios, fuchsia, web, windows, macos, linux }

/// Screen types based on size
enum UniSizeScreenType { mobile, tablet, desktop }

/// Device information and sizing calculations
class UniSizeDevice {
  UniSizeDevice._();

  /// Device's Orientation
  static late Orientation _orientation;

  /// Type of Device
  static late UniSizeDeviceType _deviceType;

  /// Type of Screen
  static late UniSizeScreenType _screenType;

  /// Physical device width
  static late double _physicalWidth;

  /// Physical device height
  static late double _physicalHeight;

  /// Logical device width
  static late double _logicalWidth;

  /// Logical device height
  static late double _logicalHeight;

  /// Device's pixel ratio
  static late double _pixelRatio;

  /// Text scale factor
  static late double _textScaleFactor;

  /// Design dimensions
  static late double _designWidth;
  static late double _designHeight;

  /// Text scale constraints
  static late double _minTextScaleFactor;
  static late double _maxTextScaleFactor;

  /// Platform-specific scale factor
  static late double _platformScaleFactor;

  /// Initialization flag
  static bool _isInitialized = false;

  /// Initialize the device information
  static void init(
    BuildContext context, {
    required double designWidth,
    required double designHeight,
    required double minTextScaleFactor,
    required double maxTextScaleFactor,
  }) {
    _designWidth = designWidth;
    _designHeight = designHeight;
    _minTextScaleFactor = minTextScaleFactor;
    _maxTextScaleFactor = maxTextScaleFactor;

    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    _logicalWidth = size.width;
    _logicalHeight = size.height;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _textScaleFactor = textScale.clamp(minTextScaleFactor, maxTextScaleFactor);

    _physicalWidth = _logicalWidth * _pixelRatio;
    _physicalHeight = _logicalHeight * _pixelRatio;
    _orientation = mediaQuery.orientation;

    // Set device type
    _setDeviceType();

    // Set screen type
    _setScreenType();

    // Set platform scale factor
    _setPlatformScaleFactor();

    _isInitialized = true;
  }

  /// Update device information (call when orientation changes)
  static void update(BuildContext context) {
    if (!_isInitialized) {
      throw Exception('UniSize not initialized. Call initUniSize() first.');
    }

    init(
      context,
      designWidth: _designWidth,
      designHeight: _designHeight,
      minTextScaleFactor: _minTextScaleFactor,
      maxTextScaleFactor: _maxTextScaleFactor,
    );
  }

  /// Set device type based on platform
  static void _setDeviceType() {
    if (kIsWeb) {
      _deviceType = UniSizeDeviceType.web;
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _deviceType = UniSizeDeviceType.android;
          break;
        case TargetPlatform.iOS:
          _deviceType = UniSizeDeviceType.ios;
          break;
        case TargetPlatform.windows:
          _deviceType = UniSizeDeviceType.windows;
          break;
        case TargetPlatform.macOS:
          _deviceType = UniSizeDeviceType.macos;
          break;
        case TargetPlatform.linux:
          _deviceType = UniSizeDeviceType.linux;
          break;
        case TargetPlatform.fuchsia:
          _deviceType = UniSizeDeviceType.fuchsia;
          break;
      }
    }
  }

  /// Set screen type based on size
  static void _setScreenType() {
    final shortestSide = min(_logicalWidth, _logicalHeight);

    if (shortestSide < UniSizeConstants.mobileBreakpoint) {
      _screenType = UniSizeScreenType.mobile;
    } else if (shortestSide < UniSizeConstants.tabletBreakpoint) {
      _screenType = UniSizeScreenType.tablet;
    } else {
      _screenType = UniSizeScreenType.desktop;
    }
  }

  /// Set platform-specific scale factor
  static void _setPlatformScaleFactor() {
    final platformKey = _deviceType.name;
    _platformScaleFactor =
        UniSizeConstants.platformScaleFactors[platformKey] ?? 1.0;
  }

  /// Check if UniSize is initialized
  static void _checkInitialization() {
    if (!_isInitialized) {
      throw Exception('UniSize not initialized. Call initUniSize() first.');
    }
  }

  // Getters
  static Orientation get orientation {
    _checkInitialization();
    return _orientation;
  }

  static UniSizeDeviceType get deviceType {
    _checkInitialization();
    return _deviceType;
  }

  static UniSizeScreenType get screenType {
    _checkInitialization();
    return _screenType;
  }

  static double get logicalWidth {
    _checkInitialization();
    return _logicalWidth;
  }

  static double get logicalHeight {
    _checkInitialization();
    return _logicalHeight;
  }

  static double get physicalWidth {
    _checkInitialization();
    return _physicalWidth;
  }

  static double get physicalHeight {
    _checkInitialization();
    return _physicalHeight;
  }

  static double get pixelRatio {
    _checkInitialization();
    return _pixelRatio;
  }

  static double get textScaleFactor {
    _checkInitialization();
    return _textScaleFactor;
  }

  static double get designWidth {
    _checkInitialization();
    return _designWidth;
  }

  static double get designHeight {
    _checkInitialization();
    return _designHeight;
  }

  static double get platformScaleFactor {
    _checkInitialization();
    return _platformScaleFactor;
  }

  /// Calculate density-independent pixels (dp)
  static double calculateDp(num value) {
    _checkInitialization();

    // Base scale factor from design width
    final scaleWidth = _logicalWidth / _designWidth;
    final scaleHeight = _logicalHeight / _designHeight;
    final scale = (scaleWidth + scaleHeight) / 2;

    // Apply platform-specific scaling
    final platformAdjustedScale = scale * _platformScaleFactor;

    // Calculate dp with density consideration
    final dpValue = value * platformAdjustedScale;

    return dpValue;
  }

  /// Calculate scalable pixels (sp) for fonts
  static double calculateSp(num value) {
    _checkInitialization();

    // Start with dp calculation
    double spValue = calculateDp(value);

    // Apply text scale factor with constraints
    final constrainedTextScale = _textScaleFactor.clamp(
      _minTextScaleFactor,
      _maxTextScaleFactor,
    );

    // Apply text scaling
    spValue *= constrainedTextScale;

    // Additional scaling for different screen types
    switch (_screenType) {
      case UniSizeScreenType.mobile:
        // No additional scaling for mobile
        break;
      case UniSizeScreenType.tablet:
        // Slightly reduce font size on tablets for better readability
        spValue *= 0.95;
        break;
      case UniSizeScreenType.desktop:
        // Reduce font size on desktop for better density
        spValue *= 0.9;
        break;
    }

    return spValue;
  }

  /// Get responsive value based on screen type
  static T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    _checkInitialization();

    switch (_screenType) {
      case UniSizeScreenType.mobile:
        return mobile;
      case UniSizeScreenType.tablet:
        return tablet ?? mobile;
      case UniSizeScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Check if device is mobile
  static bool get isMobile {
    _checkInitialization();
    return _screenType == UniSizeScreenType.mobile;
  }

  /// Check if device is tablet
  static bool get isTablet {
    _checkInitialization();
    return _screenType == UniSizeScreenType.tablet;
  }

  /// Check if device is desktop
  static bool get isDesktop {
    _checkInitialization();
    return _screenType == UniSizeScreenType.desktop;
  }

  /// Check if device is in portrait mode
  static bool get isPortrait {
    _checkInitialization();
    return _orientation == Orientation.portrait;
  }

  /// Check if device is in landscape mode
  static bool get isLandscape {
    _checkInitialization();
    return _orientation == Orientation.landscape;
  }
}
