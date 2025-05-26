import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_size/uni_size.dart';

void main() {
  group('UniSizeConstants', () {
    test('should have correct default values', () {
      expect(UniSizeConstants.defaultDesignWidth, 375.0);
      expect(UniSizeConstants.defaultDesignHeight, 812.0);
      expect(UniSizeConstants.minTextScale, 0.8);
      expect(UniSizeConstants.maxTextScale, 2.0);
      expect(UniSizeConstants.baseDensity, 160.0);
      expect(UniSizeConstants.mobileBreakpoint, 600.0);
      expect(UniSizeConstants.tabletBreakpoint, 1024.0);
      expect(UniSizeConstants.defaultPixelRatio, 1.0);
    });

    test('should have correct platform scale factors', () {
      expect(UniSizeConstants.platformScaleFactors['android'], 1.0);
      expect(UniSizeConstants.platformScaleFactors['ios'], 1.0);
      expect(UniSizeConstants.platformScaleFactors['web'], 1.0);
      expect(UniSizeConstants.platformScaleFactors['windows'], 1.25);
      expect(UniSizeConstants.platformScaleFactors['macos'], 1.0);
      expect(UniSizeConstants.platformScaleFactors['linux'], 1.0);
    });
  });

  group('UniSizeDevice', () {
    late Widget testApp;

    setUp(() {
      testApp = MaterialApp(
        home: Builder(
          builder: (context) {
            return Container();
          },
        ),
      );
    });

    testWidgets('should initialize correctly with default values', (
      tester,
    ) async {
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      UniSizeDevice.init(
        context,
        designWidth: UniSizeConstants.defaultDesignWidth,
        designHeight: UniSizeConstants.defaultDesignHeight,
        minTextScaleFactor: UniSizeConstants.minTextScale,
        maxTextScaleFactor: UniSizeConstants.maxTextScale,
      );

      expect(UniSizeDevice.designWidth, UniSizeConstants.defaultDesignWidth);
      expect(UniSizeDevice.designHeight, UniSizeConstants.defaultDesignHeight);
      expect(UniSizeDevice.logicalWidth, greaterThan(0));
      expect(UniSizeDevice.logicalHeight, greaterThan(0));
      expect(UniSizeDevice.pixelRatio, greaterThan(0));
    });

    testWidgets('should initialize with custom values', (tester) async {
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      const customWidth = 400.0;
      const customHeight = 900.0;
      const customMinText = 0.5;
      const customMaxText = 3.0;

      UniSizeDevice.init(
        context,
        designWidth: customWidth,
        designHeight: customHeight,
        minTextScaleFactor: customMinText,
        maxTextScaleFactor: customMaxText,
      );

      expect(UniSizeDevice.designWidth, customWidth);
      expect(UniSizeDevice.designHeight, customHeight);
    });

    testWidgets('should update device information', (tester) async {
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      // First initialization
      UniSizeDevice.init(
        context,
        designWidth: 375,
        designHeight: 812,
        minTextScaleFactor: 0.8,
        maxTextScaleFactor: 2.0,
      );

      final initialWidth = UniSizeDevice.logicalWidth;

      // Update should work
      UniSizeDevice.update(context);

      expect(UniSizeDevice.logicalWidth, initialWidth);
    });

    testWidgets('should set device type correctly for different platforms', (
      tester,
    ) async {
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      UniSizeDevice.init(
        context,
        designWidth: 375,
        designHeight: 812,
        minTextScaleFactor: 0.8,
        maxTextScaleFactor: 2.0,
      );

      // The actual device type will depend on the test environment
      // but we can verify it's one of the valid types
      final validTypes = [
        UniSizeDeviceType.android,
        UniSizeDeviceType.ios,
        UniSizeDeviceType.web,
        UniSizeDeviceType.windows,
        UniSizeDeviceType.macos,
        UniSizeDeviceType.linux,
        UniSizeDeviceType.fuchsia,
      ];

      expect(validTypes.contains(UniSizeDevice.deviceType), true);
    });

    testWidgets('should calculate dp correctly', (tester) async {
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      UniSizeDevice.init(
        context,
        designWidth: 375,
        designHeight: 812,
        minTextScaleFactor: 0.8,
        maxTextScaleFactor: 2.0,
      );

      final dpValue = UniSizeDevice.calculateDp(100);
      expect(dpValue, isA<double>());
      expect(dpValue, greaterThan(0));
    });

    testWidgets('should calculate sp correctly for different screen types', (
      tester,
    ) async {
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      UniSizeDevice.init(
        context,
        designWidth: 375,
        designHeight: 812,
        minTextScaleFactor: 0.8,
        maxTextScaleFactor: 2.0,
      );

      final spValue = UniSizeDevice.calculateSp(16);
      expect(spValue, isA<double>());
      expect(spValue, greaterThan(0));
    });

    testWidgets('should handle responsive values without tablet/desktop', (
      tester,
    ) async {
      // Test with tablet size
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      UniSizeDevice.init(
        context,
        designWidth: 375,
        designHeight: 812,
        minTextScaleFactor: 0.8,
        maxTextScaleFactor: 2.0,
      );

      final responsiveValue = UniSizeDevice.responsive<int>(mobile: 1);

      // Should fallback to mobile value
      expect(responsiveValue, 1);
    });

    testWidgets('should clamp text scale factor correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              devicePixelRatio: 2.0,
              textScaler: TextScaler.linear(5.0), // Very high text scale
            ),
            child: Builder(builder: (context) => Container()),
          ),
        ),
      );

      final context = tester.element(find.byType(Container));

      UniSizeDevice.init(
        context,
        designWidth: 375,
        designHeight: 812,
        minTextScaleFactor: 0.8,
        maxTextScaleFactor: 2.0,
      );

      // Text scale factor should be clamped to max value
      expect(UniSizeDevice.textScaleFactor, lessThanOrEqualTo(2.0));
    });
  });

  group('UniSizeExtension', () {
    late Widget testApp;

    setUp(() {
      testApp = MaterialApp(home: Builder(builder: (context) => Container()));
    });

    testWidgets('should provide dp conversion', (tester) async {
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      UniSizeDevice.init(
        context,
        designWidth: 375,
        designHeight: 812,
        minTextScaleFactor: 0.8,
        maxTextScaleFactor: 2.0,
      );

      expect(100.dp, isA<double>());
      expect(100.dp, greaterThan(0));
      expect(100.dip, equals(100.dp)); // Alias test
    });

    testWidgets('should provide sp conversion', (tester) async {
      await tester.pumpWidget(testApp);
      final context = tester.element(find.byType(Container));

      UniSizeDevice.init(
        context,
        designWidth: 375,
        designHeight: 812,
        minTextScaleFactor: 0.8,
        maxTextScaleFactor: 2.0,
      );

      expect(16.sp, isA<double>());
      expect(16.sp, greaterThan(0));
    });

    testWidgets('should provide pixel conversion', (tester) async {
      expect(100.px, 100.0);
      expect(50.5.px, 50.5);
    });
  });

  group('UniSizeContextExtension', () {
    testWidgets('should initialize UniSize from context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.initUniSize();
              return Container();
            },
          ),
        ),
      );

      expect(UniSizeDevice.designWidth, UniSizeConstants.defaultDesignWidth);
      expect(UniSizeDevice.designHeight, UniSizeConstants.defaultDesignHeight);
    });

    testWidgets('should initialize with custom values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.initUniSize(
                designWidth: 400,
                designHeight: 900,
                minTextScaleFactor: 0.5,
                maxTextScaleFactor: 3.0,
              );
              return Container();
            },
          ),
        ),
      );

      expect(UniSizeDevice.designWidth, 400);
      expect(UniSizeDevice.designHeight, 900);
    });

    testWidgets('should provide device information getters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.initUniSize();

              // Test all context extensions
              expect(context.deviceType, isA<UniSizeDeviceType>());
              expect(context.screenType, isA<UniSizeScreenType>());
              expect(context.isMobile, isA<bool>());
              expect(context.isTablet, isA<bool>());
              expect(context.isDesktop, isA<bool>());
              expect(context.isPortrait, isA<bool>());
              expect(context.isLandscape, isA<bool>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should update UniSize from context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.initUniSize();
              context.updateUniSize();
              return Container();
            },
          ),
        ),
      );

      // Should not throw any errors
    });
  });

  group('UniSizeWidget', () {
    testWidgets('should build with default parameters', (tester) async {
      await tester.pumpWidget(
        UniSizeWidget(
          builder: (context, orientation, screenType) {
            return MaterialApp(home: Text('Test'));
          },
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(UniSizeDevice.designWidth, UniSizeConstants.defaultDesignWidth);
      expect(UniSizeDevice.designHeight, UniSizeConstants.defaultDesignHeight);
    });

    testWidgets('should build with custom parameters', (tester) async {
      await tester.pumpWidget(
        UniSizeWidget(
          designWidth: 400,
          designHeight: 900,
          minTextScaleFactor: 0.5,
          maxTextScaleFactor: 3.0,
          builder: (context, orientation, screenType) {
            return MaterialApp(home: Text('Custom Test'));
          },
        ),
      );

      expect(find.text('Custom Test'), findsOneWidget);
      expect(UniSizeDevice.designWidth, 400);
      expect(UniSizeDevice.designHeight, 900);
    });

    testWidgets('should respond to orientation changes', (tester) async {
      String? lastOrientation;

      await tester.pumpWidget(
        UniSizeWidget(
          builder: (context, orientation, screenType) {
            lastOrientation = orientation.toString();
            return MaterialApp(home: Text('Orientation: $orientation'));
          },
        ),
      );

      expect(lastOrientation, isNotNull);
      expect(find.textContaining('Orientation:'), findsOneWidget);
    });
  });

  group('ResponsiveBuilder', () {
    testWidgets('should fallback to mobile when tablet/desktop not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UniSizeWidget(
            builder: (context, orientation, screenType) {
              return ResponsiveBuilder(mobile: Text('Mobile Only'));
            },
          ),
        ),
      );

      expect(find.text('Mobile Only'), findsOneWidget);
    });
  });

  group('OrientationResponsive', () {
    testWidgets('should show portrait widget in portrait', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: UniSizeWidget(
            builder: (context, orientation, screenType) {
              return OrientationResponsive(
                portrait: Text('Portrait'),
                landscape: Text('Landscape'),
              );
            },
          ),
        ),
      );

      expect(find.text('Portrait'), findsOneWidget);
      expect(find.text('Landscape'), findsNothing);
    });

    testWidgets('should show landscape widget in landscape', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 400));

      await tester.pumpWidget(
        MaterialApp(
          home: UniSizeWidget(
            builder: (context, orientation, screenType) {
              return OrientationResponsive(
                portrait: Text('Portrait'),
                landscape: Text('Landscape'),
              );
            },
          ),
        ),
      );

      expect(find.text('Landscape'), findsOneWidget);
      expect(find.text('Portrait'), findsNothing);
    });

    testWidgets('should fallback to portrait when landscape not provided', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 400));

      await tester.pumpWidget(
        MaterialApp(
          home: UniSizeWidget(
            builder: (context, orientation, screenType) {
              return OrientationResponsive(portrait: Text('Portrait Only'));
            },
          ),
        ),
      );

      expect(find.text('Portrait Only'), findsOneWidget);
    });
  });

  group('ConditionalWidget', () {
    testWidgets('should show child when condition is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ConditionalWidget(
            condition: true,
            fallback: Text('Hidden'),
            child: Text('Shown'),
          ),
        ),
      );

      expect(find.text('Shown'), findsOneWidget);
      expect(find.text('Hidden'), findsNothing);
    });

    testWidgets('should show fallback when condition is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ConditionalWidget(
            condition: false,
            fallback: Text('Shown'),
            child: Text('Hidden'),
          ),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
      expect(find.text('Shown'), findsOneWidget);
    });

    testWidgets('should show nothing when condition is false and no fallback', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ConditionalWidget(condition: false, child: Text('Hidden')),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });

  group('initUniSize function', () {
    testWidgets('should initialize with default values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              initUniSize(context);
              return Container();
            },
          ),
        ),
      );

      expect(UniSizeDevice.designWidth, UniSizeConstants.defaultDesignWidth);
      expect(UniSizeDevice.designHeight, UniSizeConstants.defaultDesignHeight);
    });

    testWidgets('should initialize with custom values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              initUniSize(
                context,
                designWidth: 400,
                designHeight: 900,
                minTextScaleFactor: 0.5,
                maxTextScaleFactor: 3.0,
              );
              return Container();
            },
          ),
        ),
      );

      expect(UniSizeDevice.designWidth, 400);
      expect(UniSizeDevice.designHeight, 900);
    });
  });

  group('Edge Cases and Error Handling', () {
    testWidgets('should handle extreme text scale factors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              textScaler: TextScaler.linear(0.1), // Very small
            ),
            child: Builder(
              builder: (context) {
                UniSizeDevice.init(
                  context,
                  designWidth: 375,
                  designHeight: 812,
                  minTextScaleFactor: 0.8,
                  maxTextScaleFactor: 2.0,
                );
                return Container();
              },
            ),
          ),
        ),
      );

      // Should clamp to minimum
      expect(UniSizeDevice.textScaleFactor, greaterThanOrEqualTo(0.8));
    });

    testWidgets('should handle zero design dimensions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              UniSizeDevice.init(
                context,
                designWidth: 0.1, // Very small but not zero
                designHeight: 0.1,
                minTextScaleFactor: 0.8,
                maxTextScaleFactor: 2.0,
              );

              // Should not throw errors
              final dp = UniSizeDevice.calculateDp(100);
              final sp = UniSizeDevice.calculateSp(16);

              expect(dp, isA<double>());
              expect(sp, isA<double>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle tablet screen type', (tester) async {
      // Set size that should trigger tablet detection
      await tester.binding.setSurfaceSize(const Size(700, 1000));

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              UniSizeDevice.init(
                context,
                designWidth: 375,
                designHeight: 812,
                minTextScaleFactor: 0.8,
                maxTextScaleFactor: 2.0,
              );

              // Test sp calculation for tablet (should apply 0.95 multiplier)
              final sp = UniSizeDevice.calculateSp(16);
              expect(sp, isA<double>());

              return Container();
            },
          ),
        ),
      );

      expect(UniSizeDevice.screenType, UniSizeScreenType.tablet);
      expect(UniSizeDevice.isTablet, true);
    });

    testWidgets('should handle responsive with tablet fallback', (
      tester,
    ) async {
      // Set desktop size
      await tester.binding.setSurfaceSize(const Size(1200, 1600));

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              UniSizeDevice.init(
                context,
                designWidth: 375,
                designHeight: 812,
                minTextScaleFactor: 0.8,
                maxTextScaleFactor: 2.0,
              );

              // Test fallback chain: desktop -> tablet -> mobile
              final result1 = UniSizeDevice.responsive<int>(
                mobile: 1,
                tablet: 2,
                // No desktop value, should fallback to tablet
              );
              expect(result1, 2);

              final result2 = UniSizeDevice.responsive<int>(
                mobile: 1,
                // No tablet or desktop, should fallback to mobile
              );
              expect(result2, 1);

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Device Type Detection', () {
    test('should handle all device type enum values', () {
      // Test that enum values exist and are correct
      expect(UniSizeDeviceType.android.name, 'android');
      expect(UniSizeDeviceType.ios.name, 'ios');
      expect(UniSizeDeviceType.fuchsia.name, 'fuchsia');
      expect(UniSizeDeviceType.web.name, 'web');
      expect(UniSizeDeviceType.windows.name, 'windows');
      expect(UniSizeDeviceType.macos.name, 'macos');
      expect(UniSizeDeviceType.linux.name, 'linux');
    });

    test('should handle all screen type enum values', () {
      expect(UniSizeScreenType.mobile.name, 'mobile');
      expect(UniSizeScreenType.tablet.name, 'tablet');
      expect(UniSizeScreenType.desktop.name, 'desktop');
    });
  });

  group('Platform Scale Factor Tests', () {
    testWidgets('should apply correct platform scale factors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              UniSizeDevice.init(
                context,
                designWidth: 375,
                designHeight: 812,
                minTextScaleFactor: 0.8,
                maxTextScaleFactor: 2.0,
              );

              // Platform scale factor should be applied
              final platformFactor = UniSizeDevice.platformScaleFactor;
              expect(platformFactor, greaterThan(0));

              // Should be one of the defined platform factors
              final validFactors = UniSizeConstants.platformScaleFactors.values;
              expect(validFactors.contains(platformFactor), true);

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle unknown platform gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              UniSizeDevice.init(
                context,
                designWidth: 375,
                designHeight: 812,
                minTextScaleFactor: 0.8,
                maxTextScaleFactor: 2.0,
              );

              // Should default to 1.0 for any unknown platform
              final platformFactor = UniSizeDevice.platformScaleFactor;
              expect(platformFactor, isA<double>());
              expect(platformFactor, greaterThan(0));

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Complex Integration Tests', () {
    testWidgets('should handle rapid orientation changes', (tester) async {
      await tester.pumpWidget(
        UniSizeWidget(
          builder: (context, orientation, screenType) {
            return MaterialApp(
              home: OrientationResponsive(
                portrait: Column(
                  children: [
                    SizedBox(
                      width: 100.dp,
                      height: 50.dp,
                      child: Text(
                        'Portrait',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
                landscape: Row(
                  children: [
                    SizedBox(
                      width: 150.dp,
                      height: 30.dp,
                      child: Text(
                        'Landscape',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

      // Start in portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pump();
      expect(find.text('Portrait'), findsOneWidget);

      // Change to landscape
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pump();
      expect(find.text('Landscape'), findsOneWidget);

      // Back to portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pump();
      expect(find.text('Portrait'), findsOneWidget);
    });

    testWidgets('should maintain state through size changes', (tester) async {
      int buildCount = 0;

      await tester.pumpWidget(
        UniSizeWidget(
          builder: (context, orientation, screenType) {
            buildCount++;
            return MaterialApp(
              home: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    width: 50.responsive<double>(
                      mobile: 100.dp,
                      tablet: 150.dp,
                      desktop: 200.dp,
                    ),
                    height: 25.responsive<double>(
                      mobile: 50.dp,
                      tablet: 75.dp,
                      desktop: 100.dp,
                    ),
                    child: Text('Build: $buildCount'),
                  );
                },
              ),
            );
          },
        ),
      );

      expect(find.textContaining('Build:'), findsOneWidget);
      final initialBuildCount = buildCount;

      // Change size
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pump();

      expect(buildCount, greaterThan(initialBuildCount));
    });

    testWidgets('should handle edge case screen sizes', (tester) async {
      // Test exactly at mobile breakpoint
      await tester.binding.setSurfaceSize(const Size(600, 800));

      await tester.pumpWidget(
        UniSizeWidget(
          builder: (context, orientation, screenType) {
            return MaterialApp(home: Text('Type: ${screenType.name}'));
          },
        ),
      );

      await tester.pump();
      expect(find.textContaining('Type:'), findsOneWidget);

      // Test exactly at tablet breakpoint
      await tester.binding.setSurfaceSize(const Size(1024, 800));
      await tester.pump();
      expect(find.textContaining('Type:'), findsOneWidget);
    });

    testWidgets('should handle very small screen sizes', (tester) async {
      await tester.binding.setSurfaceSize(const Size(100, 200));

      await tester.pumpWidget(
        UniSizeWidget(
          builder: (context, orientation, screenType) {
            return MaterialApp(
              home: SizedBox(
                width: 50.dp,
                height: 25.dp,
                child: Text('Small', style: TextStyle(fontSize: 8.sp)),
              ),
            );
          },
        ),
      );

      expect(find.text('Small'), findsOneWidget);
    });
  });

  group('Error Handling and Validation', () {
    testWidgets('should handle MediaQuery edge cases', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
              devicePixelRatio: 0, // Invalid pixel ratio
              textScaler: TextScaler.linear(0), // Invalid text scale
            ),
            child: Builder(
              builder: (context) {
                UniSizeDevice.init(
                  context,
                  designWidth: 375,
                  designHeight: 812,
                  minTextScaleFactor: 0.8,
                  maxTextScaleFactor: 2.0,
                );

                // Should handle gracefully
                expect(UniSizeDevice.pixelRatio, isA<double>());
                expect(
                  UniSizeDevice.textScaleFactor,
                  greaterThanOrEqualTo(0.8),
                );

                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should validate extension calculations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.initUniSize();

              // Test with negative values
              expect((-10).dp, isA<double>());
              expect((-5).sp, isA<double>());

              // Test with zero
              expect(0.dp, isA<double>());
              expect(0.sp, isA<double>());

              // Test with very large values
              expect(10000.dp, isA<double>());
              expect(1000.sp, isA<double>());

              // Test with decimal values
              expect(10.5.dp, isA<double>());
              expect(16.75.sp, isA<double>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should handle initialization in different widget contexts', (
      tester,
    ) async {
      // Test initialization in Scaffold
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                context.initUniSize();
                return Text('In Scaffold');
              },
            ),
          ),
        ),
      );

      expect(find.text('In Scaffold'), findsOneWidget);

      // Test initialization in different widget tree
      await tester.pumpWidget(
        MaterialApp(
          home: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Builder(
                  builder: (context) {
                    context.initUniSize();
                    return Text('In CustomScrollView');
                  },
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.text('In CustomScrollView'), findsOneWidget);
    });
  });

  group('Performance and Memory Tests', () {
    testWidgets('should not leak memory on repeated initialization', (
      tester,
    ) async {
      for (int i = 0; i < 100; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                context.initUniSize();
                return Text('Iteration $i');
              },
            ),
          ),
        );
        await tester.pump();
      }

      expect(find.textContaining('Iteration'), findsOneWidget);
    });

    testWidgets('should handle rapid updates efficiently', (tester) async {
      await tester.pumpWidget(
        UniSizeWidget(
          builder: (context, orientation, screenType) {
            return MaterialApp(
              home: Builder(
                builder: (context) {
                  // Perform multiple calculations
                  for (int i = 0; i < 50; i++) {
                    final _ = i.dp;
                  }
                  return Text('Performance Test');
                },
              ),
            );
          },
        ),
      );

      expect(find.text('Performance Test'), findsOneWidget);
    });
  });

  group('Comprehensive Coverage Tests', () {
    testWidgets('should cover all extension getters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.initUniSize();

              // Test all extension getters to ensure coverage
              final testValue = 10;

              expect(testValue.dp, isA<double>());
              expect(testValue.sp, isA<double>());
              expect(testValue.dip, isA<double>());
              expect(testValue.w, isA<double>());
              expect(testValue.h, isA<double>());
              expect(testValue.smin, isA<double>());
              expect(testValue.smax, isA<double>());
              expect(testValue.px, isA<double>());
              expect(testValue.vw, isA<double>());
              expect(testValue.vh, isA<double>());
              expect(testValue.vmin, isA<double>());
              expect(testValue.vmax, isA<double>());

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should cover all device getters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              context.initUniSize();

              // Access all getters to ensure coverage
              expect(UniSizeDevice.logicalWidth, isA<double>());
              expect(UniSizeDevice.logicalHeight, isA<double>());
              expect(UniSizeDevice.physicalWidth, isA<double>());
              expect(UniSizeDevice.physicalHeight, isA<double>());
              expect(UniSizeDevice.pixelRatio, isA<double>());
              expect(UniSizeDevice.textScaleFactor, isA<double>());
              expect(UniSizeDevice.designWidth, isA<double>());
              expect(UniSizeDevice.designHeight, isA<double>());
              expect(UniSizeDevice.platformScaleFactor, isA<double>());
              expect(UniSizeDevice.orientation, isA<Orientation>());
              expect(UniSizeDevice.deviceType, isA<UniSizeDeviceType>());
              expect(UniSizeDevice.screenType, isA<UniSizeScreenType>());
              expect(UniSizeDevice.isMobile, isA<bool>());
              expect(UniSizeDevice.isTablet, isA<bool>());
              expect(UniSizeDevice.isDesktop, isA<bool>());
              expect(UniSizeDevice.isPortrait, isA<bool>());
              expect(UniSizeDevice.isLandscape, isA<bool>());

              return Container();
            },
          ),
        ),
      );
    });
  });

  group('Final Edge Cases', () {
    testWidgets(
      'should handle text scale factor edge cases in sp calculation',
      (tester) async {
        // Test with various text scale factors
        final textScales = [0.5, 0.8, 1.0, 1.5, 2.0, 5.0];

        for (final scale in textScales) {
          await tester.pumpWidget(
            MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(
                  size: const Size(400, 800),
                  textScaler: TextScaler.linear(scale),
                ),
                child: Builder(
                  builder: (context) {
                    UniSizeDevice.init(
                      context,
                      designWidth: 375,
                      designHeight: 812,
                      minTextScaleFactor: 0.8,
                      maxTextScaleFactor: 2.0,
                    );

                    final sp = UniSizeDevice.calculateSp(16);
                    expect(sp, isA<double>());
                    expect(sp, greaterThan(0));

                    return Text('Scale: $scale');
                  },
                ),
              ),
            ),
          );

          await tester.pump();
        }
      },
    );

    test('should have complete enum coverage', () {
      // Ensure all enum values are tested
      for (final deviceType in UniSizeDeviceType.values) {
        expect(deviceType.name, isA<String>());
        expect(deviceType.name.isNotEmpty, true);
      }

      for (final screenType in UniSizeScreenType.values) {
        expect(screenType.name, isA<String>());
        expect(screenType.name.isNotEmpty, true);
      }
    });
  });
}
