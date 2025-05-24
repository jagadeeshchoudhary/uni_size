part of '../uni_size.dart';

/// Callback function type for responsive builder
typedef UniSizeBuilder =
    Widget Function(
      BuildContext context,
      Orientation orientation,
      UniSizeScreenType screenType,
    );

/// A widget that automatically initializes and manages UniSize
///
/// Wrap your MaterialApp or main app widget with this to automatically
/// handle UniSize initialization and updates on orientation changes.
///
/// Example:
/// ```dart
/// UniSizeWidget(
///   designWidth: 375,
///   designHeight: 812,
///   builder: (context, orientation, screenType) {
///     return MaterialApp(
///       home: MyHomePage(),
///     );
///   },
/// )
/// ```
class UniSizeWidget extends StatelessWidget {
  const UniSizeWidget({
    super.key,
    required this.builder,
    this.designWidth = UniSizeConstants.defaultDesignWidth,
    this.designHeight = UniSizeConstants.defaultDesignHeight,
    this.minTextScaleFactor = UniSizeConstants.minTextScale,
    this.maxTextScaleFactor = UniSizeConstants.maxTextScale,
  });

  /// Builder function that receives context, orientation, and screen type
  final UniSizeBuilder builder;

  /// Design width used for scaling calculations (default: 375)
  final double designWidth;

  /// Design height used for scaling calculations (default: 812)
  final double designHeight;

  /// Minimum text scale factor to prevent text from becoming too small
  final double minTextScaleFactor;

  /// Maximum text scale factor to prevent text from becoming too large
  final double maxTextScaleFactor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            // Initialize UniSize with current context and settings
            UniSizeDevice.init(
              context,
              designWidth: designWidth,
              designHeight: designHeight,
              minTextScaleFactor: minTextScaleFactor,
              maxTextScaleFactor: maxTextScaleFactor,
            );

            // Don't render if constraints are invalid
            if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
              return const SizedBox.shrink();
            }

            return builder(context, orientation, UniSizeDevice.screenType);
          },
        );
      },
    );
  }
}

/// A builder widget for responsive designs
///
/// Provides different widgets based on screen type (mobile, tablet, desktop).
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   mobile: MobileLayout(),
///   tablet: TabletLayout(),
///   desktop: DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Widget to show on mobile devices
  final Widget mobile;

  /// Widget to show on tablet devices (falls back to mobile if null)
  final Widget? tablet;

  /// Widget to show on desktop devices (falls back to tablet or mobile if null)
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return UniSizeDevice.responsive<Widget>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

/// A widget that rebuilds when orientation changes
///
/// Useful for layouts that need to adapt to orientation changes.
///
/// Example:
/// ```dart
/// OrientationResponsive(
///   portrait: PortraitLayout(),
///   landscape: LandscapeLayout(),
/// )
/// ```
class OrientationResponsive extends StatelessWidget {
  const OrientationResponsive({
    super.key,
    required this.portrait,
    this.landscape,
  });

  /// Widget to show in portrait orientation
  final Widget portrait;

  /// Widget to show in landscape orientation (falls back to portrait if null)
  final Widget? landscape;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        context.updateUniSize();

        if (orientation == Orientation.landscape && landscape != null) {
          return landscape!;
        }
        return portrait;
      },
    );
  }
}

/// A conditional widget based on screen type
///
/// Shows different widgets or hides content based on screen type.
///
/// Example:
/// ```dart
/// ConditionalWidget(
///   condition: context.isMobile,
///   child: MobileOnlyWidget(),
///   fallback: OtherWidget(),
/// )
/// ```
class ConditionalWidget extends StatelessWidget {
  const ConditionalWidget({
    super.key,
    required this.condition,
    required this.child,
    this.fallback,
  });

  /// Condition to evaluate
  final bool condition;

  /// Widget to show when condition is true
  final Widget child;

  /// Widget to show when condition is false (can be null for no fallback)
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return child;
    } else if (fallback != null) {
      return fallback!;
    } else {
      return const SizedBox.shrink();
    }
  }
}
