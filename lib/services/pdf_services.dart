import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/config.dart';
import '../config/tamil_text.dart';

// class TamilLabel {
//   final Uint8List pngBytes;
//   final double width;
//   final double height;
//
//   const TamilLabel({
//     required this.pngBytes,
//     required this.width,
//     required this.height,
//   });
// }

class PdfServices {
  /// One pre-rendered Tamil line, produced by TamilTextImage.render()
  /// BEFORE calling qrPdf(). Carrying width/height alongside the PNG bytes
  /// lets qrPdf() size the pw.Image correctly without re-decoding it.

  Future<void> qrPdf({
    required String ward,
    required String bed,
    required String mobileNumber,
    required String foodOrderUrl,
    required String feedbackUrl,
    required TamilImageResult wifiTamilLabel,
    required TamilImageResult foodTamilLabel,
    required TamilImageResult feedbackTamilLabel,
    required int isWifi,
  }) async {
    final pdf = pw.Document();


    Future<pw.Font> loadFont(String assetPath) async {
      final data = await rootBundle.load(assetPath);
      return pw.Font.ttf(data);
    }

    final baseRegular = await loadFont('assets/fonts/NotoSans-Regular.ttf');
    final baseBold = await loadFont('assets/fonts/NotoSans-Bold.ttf');

    Future<Uint8List> generateQr(String data) async {
      final qrImage = await QrPainter(
        data: data,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        gapless: true,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
      ).toImageData(1000);
      return qrImage!.buffer.asUint8List();
    }

    final foodQrBytes = await generateQr(foodOrderUrl);
    final feedbackQrBytes = await generateQr(feedbackUrl);

    final borderColor = PdfColor.fromHex('#2B2B2B');
    final pinkColor = PdfColor.fromHex('#F3DCD3');
    final yellowColor = PdfColor.fromHex('#F0C24B');
    final greenColor = PdfColor.fromHex('#C7D9B7');
    final darkText = PdfColor.fromHex('#1F1F1F');

    pw.Widget qrCard({
      required int step,
      Uint8List? qrBytes,
      bool placeholder = false,
      required PdfColor accent,
    }) {
      return pw.Stack(
        children: [
          pw.Container(
            width: 150,
            height: 150,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(
                color: placeholder ? PdfColors.grey400 : borderColor,
                width: placeholder ? 1.4 : 1,
              ),
            ),
            child: placeholder
                ? pw.Center(
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          'STICK',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey500,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Wi-Fi QR\nSticker\nHere',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  )
                : pw.Image(pw.MemoryImage(qrBytes!)),
          ),
        ],
      );
    }

    // --- Tamil caption rendered as a sized image, matching the point size
    // it was rendered at (see TamilTextImage.render's maxWidth/fontSize). ---
    pw.Widget tamilCaption(TamilImageResult label) {
      return pw.Image(
        pw.MemoryImage(label.pngBytes),
        width: label.width,
        height: label.height,
        fit: pw.BoxFit.contain,
      );
    }

    pw.Widget sectionRow({
      required int step,
      required PdfColor bgColor,
      required String titleEn,
      required TamilImageResult titleTa,
      String? titleSuffix,
      Uint8List? qrBytes,
      bool emptyQrBox = false,
    }) {
      return pw.Expanded(
        child: pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          decoration: pw.BoxDecoration(
            color: bgColor,
            border: pw.Border(
              bottom: pw.BorderSide(color: borderColor, width: 1),
            ),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              qrCard(
                step: step,
                qrBytes: qrBytes,
                placeholder: emptyQrBox,
                accent: bgColor,
              ),
              pw.SizedBox(width: 26),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Wrap(
                      crossAxisAlignment: pw.WrapCrossAlignment.end,
                      children: [
                        pw.Text(
                          titleEn,
                          style: pw.TextStyle(
                            fontSize: 28,
                            fontWeight: pw.FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                        if (titleSuffix != null)
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 8),
                            child: pw.Text(
                              titleSuffix,
                              style: pw.TextStyle(
                                fontSize: 13,
                                color: darkText,
                              ),
                            ),
                          ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    tamilCaption(titleTa),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final pageFormat = PdfPageFormat.a4;
    const margin = 18.0;
    final contentWidth = pageFormat.width - margin * 2;
    final contentHeight = pageFormat.height - margin * 2;

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(margin),
        theme: pw.ThemeData.withFont(base: baseRegular, bold: baseBold),
        build: (context) {
          return pw.SizedBox(
            width: contentWidth,
            height: contentHeight,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: borderColor, width: 1.4),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.ClipRRect(
                horizontalRadius: 6,
                verticalRadius: 6,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    // Title band
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 22),
                      decoration: pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(color: borderColor, width: 1),
                        ),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'SCAN AND CONNECT',
                          style: pw.TextStyle(
                            fontSize: 34,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    // Ward / Room + phone band
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 16),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey100,
                        border: pw.Border(
                          bottom: pw.BorderSide(color: borderColor, width: 1),
                        ),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            '$ward - $bed',
                            style: pw.TextStyle(font: baseBold, fontSize: 22),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: pw.BoxDecoration(
                              color: PdfColors.white,
                              borderRadius: pw.BorderRadius.circular(20),
                              border: pw.Border.all(
                                color: borderColor,
                                width: 0.8,
                              ),
                            ),
                            child: pw.Text(
                              'Phone Assistance: $mobileNumber',
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isWifi == 1) ...[
                      // WiFi — left blank for a printed WiFi QR sticker
                      sectionRow(
                        step: 1,
                        bgColor: pinkColor,
                        emptyQrBox: true,
                        titleEn: 'Scan for Free Wi-Fi',
                        titleSuffix: '(2GB / Day)',
                        titleTa: wifiTamilLabel,
                      ),
                    ],
                    sectionRow(
                      step: 2,
                      bgColor: greenColor,
                      qrBytes: feedbackQrBytes,
                      titleEn: 'Scan for Any Assistance (or) Feedback',
                      titleTa: feedbackTamilLabel,
                    ),
                    // Attendant food ordering QR
                    sectionRow(
                      step: 3,
                      bgColor: yellowColor,
                      qrBytes: foodQrBytes,
                      titleEn: 'Scan for Attendant Food',
                      titleTa: foodTamilLabel,
                    ),
                    // Assistance / feedback QR
                    if (isWifi == 0) ...[
                      // WiFi — left blank for a printed WiFi QR sticker
                      pw.Container(
                          height: 180,color: pinkColor
                      )
                    ],
                    // Footer
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 10,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey100,
                        border: pw.Border(
                          top: pw.BorderSide(color: borderColor, width: 1),
                        ),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Point your phone camera at the QR to scan',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            'Printed: ${_formatDate(DateTime.now())}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Future<void> qrPdf({
  //   required String ward,
  //   required String bed,
  //   required String mobileNumber,
  //   required String foodOrderUrl,
  //   required String feedbackUrl,
  // }) async {
  //   final pdf = pw.Document();
  //
  //   // --- Fonts loaded from bundled assets instead of PdfGoogleFonts, so
  //   // PDF generation no longer needs network access at all. Add these to
  //   // pubspec.yaml:
  //   //
  //   //   flutter:
  //   //     assets:
  //   //       - assets/fonts/NotoSans-Regular.ttf
  //   //       - assets/fonts/NotoSans-Bold.ttf
  //   //       - assets/fonts/NotoSansTamil-Regular.ttf
  //   //       - assets/fonts/NotoSansTamil-Bold.ttf
  //   //
  //   // (Download them from fonts.google.com/noto/specimen/Noto+Sans and
  //   // fonts.google.com/noto/specimen/Noto+Sans+Tamil — same families
  //   // PdfGoogleFonts was fetching, just bundled locally now.)
  //   Future<pw.Font> loadFont(String assetPath) async {
  //     final data = await rootBundle.load(assetPath);
  //     return pw.Font.ttf(data);
  //   }
  //
  //   final baseRegular = await loadFont('assets/fonts/NotoSans-Regular.ttf');
  //   final baseBold = await loadFont('assets/fonts/NotoSans-Bold.ttf');
  //   final tamilRegular = await loadFont('assets/fonts/NotoSansTamil-Regular.ttf');
  //   final tamilBold = await loadFont('assets/fonts/NotoSansTamil-Bold.ttf');
  //
  //   Future<Uint8List> generateQr(String data) async {
  //     final qrImage = await QrPainter(
  //       data: data,
  //       version: QrVersions.auto,
  //       errorCorrectionLevel: QrErrorCorrectLevel.H,
  //       gapless: true,
  //       color: const Color(0xFF000000),
  //       emptyColor: const Color(0xFFFFFFFF),
  //     ).toImageData(1000);
  //     return qrImage!.buffer.asUint8List();
  //   }
  //
  //   final foodQrBytes = await generateQr(foodOrderUrl);
  //   final feedbackQrBytes = await generateQr(feedbackUrl);
  //
  //   final borderColor = PdfColor.fromHex('#2B2B2B');
  //   final pinkColor = PdfColor.fromHex('#F3DCD3');
  //   final yellowColor = PdfColor.fromHex('#F0C24B');
  //   final greenColor = PdfColor.fromHex('#C7D9B7');
  //   final darkText = PdfColor.fromHex('#1F1F1F');
  //
  //   pw.Widget qrCard({
  //     required int step,
  //     Uint8List? qrBytes,
  //     bool placeholder = false,
  //     required PdfColor accent,
  //   }) {
  //     return pw.Stack(
  //       children: [
  //         pw.Container(
  //           width: 150,
  //           height: 150,
  //           padding: const pw.EdgeInsets.all(10),
  //           decoration: pw.BoxDecoration(
  //             color: PdfColors.white,
  //             borderRadius: pw.BorderRadius.circular(10),
  //             border: pw.Border.all(
  //               color: placeholder ? PdfColors.grey400 : borderColor,
  //               width: placeholder ? 1.4 : 1,
  //             ),
  //           ),
  //           child: placeholder
  //               ? pw.Center(
  //             child: pw.Column(
  //               mainAxisAlignment: pw.MainAxisAlignment.center,
  //               children: [
  //                 pw.Text(
  //                   'STICK',
  //                   style: pw.TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: pw.FontWeight.bold,
  //                     color: PdfColors.grey500,
  //                   ),
  //                 ),
  //                 pw.SizedBox(height: 4),
  //                 pw.Text(
  //                   'Wi-Fi QR\nSticker\nHere',
  //                   textAlign: pw.TextAlign.center,
  //                   style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
  //                 ),
  //               ],
  //             ),
  //           )
  //               : pw.Image(pw.MemoryImage(qrBytes!)),
  //         ),
  //       ],
  //     );
  //   }
  //
  //   pw.Widget sectionRow({
  //     required int step,
  //     required PdfColor bgColor,
  //     required String titleEn,
  //     required String titleTa,
  //     String? titleSuffix,
  //     Uint8List? qrBytes,
  //     bool emptyQrBox = false,
  //   }) {
  //     return pw.Expanded(
  //       child: pw.Container(
  //         width: double.infinity,
  //         padding: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 14),
  //         decoration: pw.BoxDecoration(
  //           color: bgColor,
  //           border: pw.Border(bottom: pw.BorderSide(color: borderColor, width: 1)),
  //         ),
  //         child: pw.Row(
  //           crossAxisAlignment: pw.CrossAxisAlignment.center,
  //           children: [
  //             qrCard(
  //               step: step,
  //               qrBytes: qrBytes,
  //               placeholder: emptyQrBox,
  //               accent: bgColor,
  //             ),
  //             pw.SizedBox(width: 26),
  //             pw.Expanded(
  //               child: pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 mainAxisAlignment: pw.MainAxisAlignment.center,
  //                 children: [
  //                   pw.Wrap(
  //                     crossAxisAlignment: pw.WrapCrossAlignment.end,
  //                     children: [
  //                       pw.Text(
  //                         titleEn,
  //                         style: pw.TextStyle(
  //                           fontSize: 30,
  //                           fontWeight: pw.FontWeight.bold,
  //                           color: darkText,
  //                         ),
  //                       ),
  //                       if (titleSuffix != null)
  //                         pw.Padding(
  //                           padding: const pw.EdgeInsets.only(left: 8),
  //                           child: pw.Text(
  //                             titleSuffix,
  //                             style: pw.TextStyle(fontSize: 13, color: darkText),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                   pw.SizedBox(height: 8),
  //                   pw.Text(
  //                     titleTa,
  //                     style: pw.TextStyle(font: tamilRegular, fontSize: 15, color: darkText),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //
  //   final pageFormat = PdfPageFormat.a4;
  //   const margin = 18.0;
  //   final contentWidth = pageFormat.width - margin * 2;
  //   final contentHeight = pageFormat.height - margin * 2;
  //
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: pageFormat,
  //       margin: const pw.EdgeInsets.all(margin),
  //       theme: pw.ThemeData.withFont(
  //         base: baseRegular,
  //         bold: baseBold,
  //         fontFallback: [tamilRegular, tamilBold],
  //       ),
  //       build: (context) {
  //         return pw.SizedBox(
  //           width: contentWidth,
  //           height: contentHeight,
  //           child: pw.Container(
  //             decoration: pw.BoxDecoration(
  //               border: pw.Border.all(color: borderColor, width: 1.4),
  //               borderRadius: pw.BorderRadius.circular(6),
  //             ),
  //             child: pw.ClipRRect(
  //               horizontalRadius: 6,
  //               verticalRadius: 6,
  //               child: pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.stretch,
  //                 children: [
  //                   // Title band
  //                   pw.Container(
  //                     padding: const pw.EdgeInsets.symmetric(vertical: 22),
  //                     decoration: pw.BoxDecoration(
  //                       border: pw.Border(
  //                           bottom: pw.BorderSide(color: borderColor, width: 1)),
  //                     ),
  //                     child: pw.Center(
  //                       child: pw.Text(
  //                         'SCAN AND CONNECT',
  //                         style: pw.TextStyle(
  //                           fontSize: 34,
  //                           fontWeight: pw.FontWeight.bold,
  //                           letterSpacing: 3,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   // Ward / Room + phone band
  //                   pw.Container(
  //                     padding: const pw.EdgeInsets.symmetric(vertical: 16),
  //                     decoration: pw.BoxDecoration(
  //                       color: PdfColors.grey100,
  //                       border: pw.Border(
  //                           bottom: pw.BorderSide(color: borderColor, width: 1)),
  //                     ),
  //                     child: pw.Column(
  //                       children: [
  //                         pw.Text(
  //                           '$ward - $bed',
  //                           style: pw.TextStyle(font: tamilBold, fontSize: 22),
  //                         ),
  //                         pw.SizedBox(height: 8),
  //                         pw.Container(
  //                           padding: const pw.EdgeInsets.symmetric(
  //                               horizontal: 14, vertical: 6),
  //                           decoration: pw.BoxDecoration(
  //                             color: PdfColors.white,
  //                             borderRadius: pw.BorderRadius.circular(20),
  //                             border: pw.Border.all(color: borderColor, width: 0.8),
  //                           ),
  //                           child: pw.Text(
  //                             'Phone Assistance: $mobileNumber',
  //                             style: pw.TextStyle(
  //                                 fontSize: 15, fontWeight: pw.FontWeight.bold),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   // Attendant food ordering QR
  //                   sectionRow(
  //                     step: 1,
  //                     bgColor: yellowColor,
  //                     qrBytes: foodQrBytes,
  //                     titleEn: 'Scan for Attendant Food',
  //                     titleTa: 'நோயாளிகளுடன் இருப்பவர்களின் உணவுக்கு ஸ்கேன் செய்யவும்',
  //                   ),
  //                   // Assistance / feedback QR
  //                   sectionRow(
  //                     step: 2,
  //                     bgColor: greenColor,
  //                     qrBytes: feedbackQrBytes,
  //                     titleEn: 'Scan for Any Assistance (or) Feedback',
  //                     titleTa: 'உதவிக்கு மற்றும் கருத்துக்கள் பகிர\nஸ்கேன் செய்யவும்',
  //                   ),
  //                   sectionRow(
  //                     step: 3,
  //                     bgColor: pinkColor,
  //                     emptyQrBox: true,
  //                     titleEn: 'Scan for Free Wi-Fi',
  //                     titleSuffix: '(2GB / Day)',
  //                     titleTa: 'இலவச WiFi சேவைக்கு ஸ்கேன்\nசெய்யவும் (2 GB / தினமும்)',
  //                   ),
  //                   // Footer
  //                   pw.Container(
  //                     padding: const pw.EdgeInsets.symmetric(
  //                         horizontal: 26, vertical: 10),
  //                     decoration: pw.BoxDecoration(
  //                       color: PdfColors.grey100,
  //                       border: pw.Border(
  //                           top: pw.BorderSide(color: borderColor, width: 1)),
  //                     ),
  //                     child: pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text(
  //                           'Point your phone camera at the QR to scan',
  //                           style: pw.TextStyle(
  //                               fontSize: 10, color: PdfColors.grey700),
  //                         ),
  //                         pw.Text(
  //                           'Printed: ${_formatDate(DateTime.now())}',
  //                           style: pw.TextStyle(
  //                               fontSize: 10, color: PdfColors.grey700),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  // }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  // Future<void> qrPdf({
  //   required String ward,
  //   required String bed,
  //   required String mobileNumber,
  //   required String foodOrderUrl,
  //   required String feedbackUrl,
  // }) async {
  //   final pdf = pw.Document();
  //   final baseRegular = await PdfGoogleFonts.notoSansRegular();
  //   final baseBold = await PdfGoogleFonts.notoSansBold();
  //   final tamilRegular = await PdfGoogleFonts.notoSansTamilRegular();
  //   final tamilBold = await PdfGoogleFonts.notoSansTamilBold();
  //   Future<Uint8List> generateQr(String data) async {
  //     final qrImage = await QrPainter(
  //       data: data,
  //       version: QrVersions.auto,
  //       errorCorrectionLevel: QrErrorCorrectLevel.H,
  //       gapless: true,
  //       color: const Color(0xFF000000),
  //       emptyColor: const Color(0xFFFFFFFF),
  //     ).toImageData(1000);
  //     return qrImage!.buffer.asUint8List();
  //   }
  //
  //   final foodQrBytes = await generateQr(foodOrderUrl);
  //   final feedbackQrBytes = await generateQr(feedbackUrl);
  //
  //   final borderColor = PdfColor.fromHex('#2B2B2B');
  //   final pinkColor = PdfColor.fromHex('#F3DCD3');
  //   final yellowColor = PdfColor.fromHex('#F0C24B');
  //   final greenColor = PdfColor.fromHex('#C7D9B7');
  //   final darkText = PdfColor.fromHex('#1F1F1F');
  //
  //   pw.Widget qrCard({
  //     required int step,
  //     Uint8List? qrBytes,
  //     bool placeholder = false,
  //     required PdfColor accent,
  //   }) {
  //     return pw.Stack(
  //       children: [
  //         pw.Container(
  //           width: 150,
  //           height: 150,
  //           padding: const pw.EdgeInsets.all(10),
  //           decoration: pw.BoxDecoration(
  //             color: PdfColors.white,
  //             borderRadius: pw.BorderRadius.circular(10),
  //             border: pw.Border.all(
  //               color: placeholder ? PdfColors.grey400 : borderColor,
  //               width: placeholder ? 1.4 : 1,
  //               // style: placeholder ? pw.PaintingStyle.stroke : pw.PaintingStyle.stroke,
  //             ),
  //           ),
  //           child: placeholder
  //               ? pw.Center(
  //             child: pw.Column(
  //               mainAxisAlignment: pw.MainAxisAlignment.center,
  //               children: [
  //                 pw.Text(
  //                   'STICK',
  //                   style: pw.TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: pw.FontWeight.bold,
  //                     color: PdfColors.grey500,
  //                   ),
  //                 ),
  //                 pw.SizedBox(height: 4),
  //                 pw.Text(
  //                   'Wi-Fi QR\nSticker\nHere',
  //                   textAlign: pw.TextAlign.center,
  //                   style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
  //                 ),
  //               ],
  //             ),
  //           )
  //               : pw.Image(pw.MemoryImage(qrBytes!)),
  //         ),
  //         // pw.Positioned(
  //         //   top: -8,
  //         //   left: -8,
  //         //   child: pw.Container(
  //         //     width: 26,
  //         //     height: 26,
  //         //     alignment: pw.Alignment.center,
  //         //     decoration: pw.BoxDecoration(
  //         //       color: accent,
  //         //       shape: pw.BoxShape.circle,
  //         //       border: pw.Border.all(color: borderColor, width: 1),
  //         //     ),
  //         //     child: pw.Text(
  //         //       '$step',
  //         //       style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     );
  //   }
  //
  //   pw.Widget sectionRow({
  //     required int step,
  //     required PdfColor bgColor,
  //     required String titleEn,
  //     required String titleTa,
  //     String? titleSuffix,
  //     Uint8List? qrBytes,
  //     bool emptyQrBox = false,
  //   }) {
  //     return pw.Expanded(
  //       child: pw.Container(
  //         width: double.infinity,
  //         padding: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 14),
  //         decoration: pw.BoxDecoration(
  //           color: bgColor,
  //           border: pw.Border(bottom: pw.BorderSide(color: borderColor, width: 1)),
  //         ),
  //         child: pw.Row(
  //           crossAxisAlignment: pw.CrossAxisAlignment.center,
  //           children: [
  //             qrCard(
  //               step: step,
  //               qrBytes: qrBytes,
  //               placeholder: emptyQrBox,
  //               accent: bgColor,
  //             ),
  //             pw.SizedBox(width: 26),
  //             pw.Expanded(
  //               child: pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 mainAxisAlignment: pw.MainAxisAlignment.center,
  //                 children: [
  //                   pw.Wrap(
  //                     crossAxisAlignment: pw.WrapCrossAlignment.end,
  //                     children: [
  //                       pw.Text(
  //                         titleEn,
  //                         style: pw.TextStyle(
  //                           fontSize: 30,
  //                           fontWeight: pw.FontWeight.bold,
  //                           color: darkText,
  //                         ),
  //                       ),
  //                       if (titleSuffix != null)
  //                         pw.Padding(
  //                           padding: const pw.EdgeInsets.only(left: 8),
  //                           child: pw.Text(
  //                             titleSuffix,
  //                             style: pw.TextStyle(fontSize: 13, color: darkText),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                   pw.SizedBox(height: 8),
  //                   pw.Text(
  //                     titleTa,
  //                     style: pw.TextStyle(font: tamilRegular, fontSize: 15, color: darkText),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //
  //   final pageFormat = PdfPageFormat.a4;
  //   const margin = 18.0;
  //   final contentWidth = pageFormat.width - margin * 2;
  //   final contentHeight = pageFormat.height - margin * 2;
  //
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: pageFormat,
  //       margin: const pw.EdgeInsets.all(margin),
  //       theme: pw.ThemeData.withFont(
  //         base: baseRegular,
  //         bold: baseBold,
  //         fontFallback: [tamilRegular, tamilBold],
  //       ),
  //       build: (context) {
  //         // SizedBox pins the card to the full printable area so the
  //         // Expanded sections below actually share out the whole sheet.
  //         return pw.SizedBox(
  //           width: contentWidth,
  //           height: contentHeight,
  //           child: pw.Container(
  //             decoration: pw.BoxDecoration(
  //               border: pw.Border.all(color: borderColor, width: 1.4),
  //               borderRadius: pw.BorderRadius.circular(6),
  //             ),
  //             child: pw.ClipRRect(
  //               horizontalRadius: 6,
  //               verticalRadius: 6,
  //               child: pw.Column(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.stretch,
  //                 children: [
  //                   // Title band
  //                   pw.Container(
  //                     padding: const pw.EdgeInsets.symmetric(vertical: 22),
  //                     decoration: pw.BoxDecoration(
  //                       border: pw.Border(
  //                           bottom: pw.BorderSide(color: borderColor, width: 1)),
  //                     ),
  //                     child: pw.Center(
  //                       child: pw.Text(
  //                         'SCAN AND CONNECT',
  //                         style: pw.TextStyle(
  //                           fontSize: 34,
  //                           fontWeight: pw.FontWeight.bold,
  //                           letterSpacing: 3,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   // Ward / Room + phone band
  //                   pw.Container(
  //                     padding: const pw.EdgeInsets.symmetric(vertical: 16),
  //                     decoration: pw.BoxDecoration(
  //                       color: PdfColors.grey100,
  //                       border: pw.Border(
  //                           bottom: pw.BorderSide(color: borderColor, width: 1)),
  //                     ),
  //                     child: pw.Column(
  //                       children: [
  //                         pw.Text(
  //                           '$ward - $bed',
  //                           style: pw.TextStyle(font: tamilBold, fontSize: 22),
  //                         ),
  //                         pw.SizedBox(height: 8),
  //                         pw.Container(
  //                           padding: const pw.EdgeInsets.symmetric(
  //                               horizontal: 14, vertical: 6),
  //                           decoration: pw.BoxDecoration(
  //                             color: PdfColors.white,
  //                             borderRadius: pw.BorderRadius.circular(20),
  //                             border: pw.Border.all(color: borderColor, width: 0.8),
  //                           ),
  //                           child: pw.Text(
  //                             'Phone Assistance: $mobileNumber',
  //                             style: pw.TextStyle(
  //                                 fontSize: 15, fontWeight: pw.FontWeight.bold),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   // Attendant food ordering QR
  //                   sectionRow(
  //                     step: 1,
  //                     bgColor: yellowColor,
  //                     qrBytes: foodQrBytes,
  //                     titleEn: 'Scan for Attendant Food',
  //                     titleTa: 'நோயாளிகளுடன் இருப்பவர்களின் உணவுக்கு ஸ்கேன் செய்யவும்',
  //                   ),
  //                   // Assistance / feedback QR
  //                   sectionRow(
  //                     step: 2,
  //                     bgColor: greenColor,
  //                     qrBytes: feedbackQrBytes,
  //                     titleEn: 'Scan for Any Assistance (or) Feedback',
  //                     titleTa: 'உதவிக்கு மற்றும் கருத்துக்கள் பகிர\nஸ்கேன் செய்யவும்',
  //                   ),
  //                   sectionRow(
  //                     step: 3,
  //                     bgColor: pinkColor,
  //                     emptyQrBox: true,
  //                     titleEn: 'Scan for Free Wi-Fi',
  //                     titleSuffix: '(2GB / Day)',
  //                     titleTa: 'இலவச WiFi சேவைக்கு ஸ்கேன்\nசெய்யவும் (2 GB / தினமும்)',
  //                   ),
  //                   // Footer
  //                   pw.Container(
  //                     padding: const pw.EdgeInsets.symmetric(
  //                         horizontal: 26, vertical: 10),
  //                     decoration: pw.BoxDecoration(
  //                       color: PdfColors.grey100,
  //                       border: pw.Border(
  //                           top: pw.BorderSide(color: borderColor, width: 1)),
  //                     ),
  //                     child: pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Text(
  //                           'Point your phone camera at the QR to scan',
  //                           style: pw.TextStyle(
  //                               fontSize: 10, color: PdfColors.grey700),
  //                         ),
  //                         pw.Text(
  //                           'Printed: ${_formatDate(DateTime.now())}',
  //                           style: pw.TextStyle(
  //                               fontSize: 10, color: PdfColors.grey700),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  // }

  // String _formatDate(DateTime d) {
  //   final dd = d.day.toString().padLeft(2, '0');
  //   final mm = d.month.toString().padLeft(2, '0');
  //   return '$dd/$mm/${d.year}';
  // }
  // Future<void> qrPdf({
  //   required String ward,
  //   required String bed,
  //   required String feedbackUrl,
  // }) async {
  //   final pdf = pw.Document();
  //   final qrImage = await QrPainter(
  //     data: feedbackUrl,
  //     version: QrVersions.auto,
  //     gapless: true,
  //   ).toImageData(500);
  //
  //   final qrBytes = qrImage!.buffer.asUint8List();
  //
  //   pdf.addPage(
  //     pw.Page(
  //       build: (context) {
  //         return pw.Center(
  //           child: pw.Column(
  //             mainAxisSize: pw.MainAxisSize.min,
  //             children: [
  //               pw.Text(
  //                 "$ward",
  //                 style: pw.TextStyle(
  //                   fontSize: 25,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //               pw.SizedBox(height: 10),
  //               pw.Text(
  //                 bed,
  //                 style: pw.TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: pw.FontWeight.bold,
  //                 ),
  //               ),
  //               pw.SizedBox(height: 20),
  //               pw.Image(pw.MemoryImage(qrBytes), width: 350, height: 350),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  // }

  Future<void> attenderQrPdf({
    required String title,
    required String url,
  }) async {
    final pdf = pw.Document();

    final qrImage = await QrPainter(
      data: "${Config.siteUrl}$url",
      version: QrVersions.auto,
      gapless: true,
    ).toImageData(250);

    final qrBytes = qrImage!.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Image(pw.MemoryImage(qrBytes), width: 350, height: 350),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
