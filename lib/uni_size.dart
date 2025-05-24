/*
 * UniSize - Universal Sizing Package for Flutter
 * 
 * A comprehensive responsive design package that provides consistent
 * sizing across all platforms with density-independent pixels (dp)
 * and scalable pixels (sp) for fonts.
 */

library;

import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

part 'src/device.dart';
part 'src/extensions.dart';
part 'src/uni_size_widget.dart';
part 'src/constants.dart';

/// Initialize UniSize - Call this before using any sizing extensions
void initUniSize(
  BuildContext context, {
  double? designWidth,
  double? designHeight,
  double? minTextScaleFactor,
  double? maxTextScaleFactor,
}) {
  UniSizeDevice.init(
    context,
    designWidth: designWidth ?? UniSizeConstants.defaultDesignWidth,
    designHeight: designHeight ?? UniSizeConstants.defaultDesignHeight,
    minTextScaleFactor: minTextScaleFactor ?? UniSizeConstants.minTextScale,
    maxTextScaleFactor: maxTextScaleFactor ?? UniSizeConstants.maxTextScale,
  );
}
