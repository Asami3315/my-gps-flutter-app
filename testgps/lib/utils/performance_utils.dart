import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Performance optimization utilities for the app
class PerformanceUtils {
  /// Initialize performance optimizations
  static void initialize() {
    // Set preferred orientations for better performance
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Set system UI overlay style for better performance
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
  
  /// Optimize image loading
  static Widget optimizedImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      // Performance optimizations
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      isAntiAlias: false, // Disable for better performance on low-end devices
    );
  }
  
  /// Create optimized container with minimal overhead
  static Widget optimizedContainer({
    required Widget child,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      color: color,
      padding: padding,
      margin: margin,
      child: child,
    );
  }
  
  /// Memory-efficient text widget
  static Widget optimizedText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
  
  /// Dispose resources properly
  static void disposeControllers(List<dynamic> controllers) {
    for (final controller in controllers) {
      if (controller is ChangeNotifier) {
        controller.dispose();
      }
    }
  }
  
  /// Check if device is low-end for performance adjustments
  static bool isLowEndDevice(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final pixelRatio = mediaQuery.devicePixelRatio;
    
    // Simple heuristic for low-end devices
    return screenSize.width < 400 || pixelRatio < 2.0;
  }
  
  /// Get optimized animation duration based on device performance
  static Duration getOptimizedDuration(BuildContext context, {
    Duration fast = const Duration(milliseconds: 200),
    Duration normal = const Duration(milliseconds: 300),
    Duration slow = const Duration(milliseconds: 500),
  }) {
    return isLowEndDevice(context) ? fast : normal;
  }
}
