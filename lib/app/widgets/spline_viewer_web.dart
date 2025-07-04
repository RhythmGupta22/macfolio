// 📁 lib/widgets/spline_viewer_web.dart
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui;
import 'dart:html' as html;
import 'package:flutter/material.dart';

class SplineViewer extends StatelessWidget {
  final String url;
  final double scale;

  const SplineViewer({
    super.key,
    required this.url,
    this.scale = 1.5, // 👈 Default zoom level (adjust as needed)
  });

  @override
  Widget build(BuildContext context) {
    // Register the view
    ui.platformViewRegistry.registerViewFactory(
      'spline-viewer-html',
          (int viewId) {
        final iframe = html.IFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.transform = 'scale($scale)'
          ..style.transformOrigin = 'center center'
          ..style.position = 'absolute';

        return iframe;
      },
    );

    return const HtmlElementView(viewType: 'spline-viewer-html');
  }
}