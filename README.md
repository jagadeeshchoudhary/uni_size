# UniSize

A comprehensive Flutter package for responsive UI design with universal sizing units that work consistently across all platforms. UniSize provides `.dp` for sizes and `.sp` for fonts with automatic scaling based on screen density and text scale factors.

## Features

✅ **Universal Sizing**: `.dp` for all sizes, `.sp` for fonts  
✅ **Cross-Platform**: Works consistently on Android, iOS, Web, Windows, macOS, and Linux  
✅ **Responsive Design**: Automatic scaling based on screen size and density  
✅ **Text Scaling**: Respects system text scale while maintaining readability  
✅ **Screen Type Detection**: Mobile, tablet, and desktop detection  
✅ **Orientation Support**: Portrait and landscape orientation handling  
✅ **Easy Integration**: Simple setup with minimal configuration  

## Installation

Add `uni_size` to your `pubspec.yaml`:

```yaml
dependencies:
  uni_size: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Wrap your app with UniSizeWidget

```dart
import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return UniSizeWidget(
      designWidth: 375,  // Your design width (optional, default: 375)
      designHeight: 812, // Your design height (optional, default: 812)
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'UniSize Demo',
          home: MyHomePage(),
        );
      },
    );
  }
}
```

### 2. Use .dp for sizes and .sp for fonts

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UniSize Demo',
          style: TextStyle(fontSize: 18.sp), // Use .sp for fonts
        ),
      ),
      body: Container(
        width: 200.dp,        // Use .dp for sizes
        height: 100.dp,       // Use .dp for sizes
        padding: EdgeInsets.all(16.dp), // Use .dp for padding
        margin: EdgeInsets.symmetric(
          horizontal: 20.dp,  // Use .dp for margins
          vertical: 10.dp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.dp), // Use .dp for radius
        ),
        child: Text(
          'Hello UniSize!',
          style: TextStyle(
            fontSize: 16.sp,    // Use .sp for font size
            height: 1.5,        // Line height can remain unitless
          ),
        ),
      ),
    );
  }
}
```

## Advanced Usage

### Manual Initialization (Alternative)

If you prefer not to use `UniSizeWidget`, you can manually initialize:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          // Initialize UniSize
          initUniSize(context, designWidth: 375, designHeight: 812);
          
          return MyHomePage();
        },
      ),
    );
  }
}
```

### Responsive Design

Create different layouts for different screen types:

```dart
Widget build(BuildContext context) {
  return ResponsiveBuilder(
    mobile: MobileLayout(),
    tablet: TabletLayout(),
    desktop: DesktopLayout(),
  );
}
```

Or use responsive values:

```dart
final padding = EdgeInsets.all(
  16.responsive(
    mobile: 12.dp,
    tablet: 16.dp,
    desktop: 20.dp,
  ),
);
```

### Orientation Handling

```dart
Widget build(BuildContext context) {
  return OrientationResponsive(
    portrait: PortraitLayout(),
    landscape: LandscapeLayout(),
  );
}
```

### Device Information

Access device information anywhere in your app:

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      if (context.isMobile) Text('Mobile Device'),
      if (context.isTablet) Text('Tablet Device'),
      if (context.isDesktop) Text('Desktop Device'),
      if (context.isPortrait) Text('Portrait Mode'),
      if (context.isLandscape) Text('Landscape Mode'),
    ],
  );
}
```

### Conditional Widgets

Show or hide widgets based on screen type:

```dart
ConditionalWidget(
  condition: context.isMobile,
  child: MobileOnlyWidget(),
  fallback: DesktopWidget(),
)
```

## API Reference