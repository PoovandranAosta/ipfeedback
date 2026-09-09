import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle, FontLoader;

class TamilTextImage {
  static bool _fontLoaded = false;
  static const _fontFamily = 'PdfTamilRender';


  static Future<void> _ensureFontLoaded() async {
    if (_fontLoaded) return;
    final fontData = await rootBundle.load(
      'assets/fonts/Nirmala-Bold.ttf',
    );
    final loader = FontLoader(_fontFamily)..addFont(Future.value(fontData));
    await loader.load();
    _fontLoaded = true;
  }

  static Future<TamilImageResult> render(
      String text, {
        double fontSize = 16,
        double maxWidth = 330,
        double lineHeight = 1.35,
        int color = 0xFF1F1F1F,
        double scale = 3,
      }) async {
    await _ensureFontLoaded();

    final paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontFamily: _fontFamily,
        fontSize: fontSize,
        height: lineHeight,
      ),
    )
      ..pushStyle(ui.TextStyle(color: ui.Color(color)))
      ..addText(text);

    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: maxWidth));

    final logicalWidth = paragraph.longestLine.ceilToDouble();
    final logicalHeight = paragraph.height.ceilToDouble();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      ui.Rect.fromLTWH(0, 0, logicalWidth * scale, logicalHeight * scale),
    );
    canvas.scale(scale);
    canvas.drawParagraph(paragraph, ui.Offset.zero);
    final picture = recorder.endRecording();

    final image = await picture.toImage(
      (logicalWidth * scale).ceil(),
      (logicalHeight * scale).ceil(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return TamilImageResult(
      pngBytes: byteData!.buffer.asUint8List(),
      width: logicalWidth,
      height: logicalHeight,
    );
  }
}

class TamilImageResult {
  final Uint8List pngBytes;
  final double width;
  final double height;

  TamilImageResult({
    required this.pngBytes,
    required this.width,
    required this.height,
  });
}