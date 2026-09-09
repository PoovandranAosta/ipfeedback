// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../config/config.dart';
// import '../config/tamil_text.dart';
//
// // class TamilLabel {
// //   final Uint8List pngBytes;
// //   final double width;
// //   final double height;
// //
// //   const TamilLabel({
// //     required this.pngBytes,
// //     required this.width,
// //     required this.height,
// //   });
// // }
//
// class PdfServices {
//   /// One pre-rendered Tamil line, produced by TamilTextImage.render()
//   /// BEFORE calling qrPdf(). Carrying width/height alongside the PNG bytes
//   /// lets qrPdf() size the pw.Image correctly without re-decoding it.
//
//   Future<void> qrPdf({
//     required String ward,
//     required String bed,
//     required String mobileNumber,
//     required String foodOrderUrl,
//     required String feedbackUrl,
//     required TamilImageResult wifiTamilLabel,
//     required TamilImageResult foodTamilLabel,
//     required TamilImageResult feedbackTamilLabel,
//     required int isWifi,
//   }) async {
//     final pdf = pw.Document();
//
//     Future<pw.Font> loadFont(String assetPath) async {
//       final data = await rootBundle.load(assetPath);
//       return pw.Font.ttf(data);
//     }
//
//     // final baseRegular = await loadFont('assets/fonts/NotoSans-Regular.ttf');
//     // final baseBold = await loadFont('assets/fonts/NotoSans-Bold.ttf');
//
//     final engraversMT = await loadFont('assets/fonts/EngraversMt.ttf');
//     final dejavuSerif = await loadFont('assets/fonts/DejaVuSerif.ttf');
//     final bahnSchrift = await loadFont('assets/fonts/Bahnschrift.ttf');
//
//     Future<Uint8List> generateQr(String data,Color bgColor) async {
//       final qrImage = await QrPainter(
//         data: data,
//         version: QrVersions.auto,
//         errorCorrectionLevel: QrErrorCorrectLevel.H,
//         gapless: true,
//         color: const Color(0xFF000000),
//         emptyColor: bgColor,
//       ).toImageData(1000);
//       return qrImage!.buffer.asUint8List();
//     }
//
//     final borderColor = PdfColor.fromHex('#2B2B2B');
//     final pinkColor = PdfColor.fromHex('#F3DCD3');
//     final yellowColor = PdfColor.fromHex('#F0C24B');
//     final greenColor = PdfColor.fromHex('#C7D9B7');
//     final darkText = PdfColor.fromHex('#1F1F1F');
//
//     final bgYellow = const Color(0xFFF0C24B);
//     final bgGreen = const Color(0xFFC7D9B7);
//     final bgPink = const Color(0xFFF3DCD3);
//
//
//     final goldLight = PdfColor.fromHex('#fae7b5');
//
//     final foodQrBytes = await generateQr(foodOrderUrl,bgYellow);
//     final feedbackQrBytes = await generateQr(feedbackUrl,bgGreen);
//
//
//
//     pw.Widget qrCard({
//       required int step,
//       Uint8List? qrBytes,
//       bool placeholder = false,
//       required PdfColor accent,
//     }) {
//       return pw.Stack(
//         children: [
//           pw.Container(
//             width: 150,
//             height: 150,
//             // padding: const pw.EdgeInsets.all(10),
//             decoration: pw.BoxDecoration(
//               // color: PdfColors.white,
//               // borderRadius: pw.BorderRadius.circular(10),
//               // border: pw.Border.all(
//               //   color: placeholder ? PdfColors.grey400 : borderColor,
//               //   width: placeholder ? 1.4 : 1,
//               // ),
//             ),
//             child: placeholder
//                 ? pw.Center(
//                     child: pw.Column(
//                       mainAxisAlignment: pw.MainAxisAlignment.center,
//                       children: [
//                         pw.Text(
//                           'STICK',
//                           style: pw.TextStyle(
//                             fontSize: 12,
//                             fontWeight: pw.FontWeight.bold,
//                             color: PdfColors.grey500,
//                           ),
//                         ),
//                         pw.SizedBox(height: 4),
//                         pw.Text(
//                           'Wi-Fi QR\nSticker\nHere',
//                           textAlign: pw.TextAlign.center,
//                           style: pw.TextStyle(
//                             fontSize: 10,
//                             color: PdfColors.grey500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : pw.Image(pw.MemoryImage(qrBytes!)),
//           ),
//         ],
//       );
//     }
//
//
//     pw.Widget tamilCaption(TamilImageResult label) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(left: 70),
//         child: pw.Image(
//           pw.MemoryImage(label.pngBytes),
//           width: label.width,
//           height: label.height,
//           fit: pw.BoxFit.contain,
//         )
//       );
//
//
//     }
//
//     pw.Widget sectionRow({
//       required int step,
//       required PdfColor bgColor,
//       required String titleEn,
//       required TamilImageResult titleTa,
//       String? titleSuffix,
//       Uint8List? qrBytes,
//       bool emptyQrBox = false,
//     }) {
//       return pw.Expanded(
//         child: pw.Container(
//           width: double.infinity,
//           padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//           decoration: pw.BoxDecoration(
//             color: bgColor,
//             border: pw.Border(
//               bottom: pw.BorderSide(color: borderColor, width: 1),
//             ),
//           ),
//           child: pw.Row(
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             children: [
//               qrCard(
//                 step: step,
//                 qrBytes: qrBytes,
//                 placeholder: emptyQrBox,
//                 accent: bgColor,
//               ),
//               pw.SizedBox(width: 26),
//               pw.Expanded(
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
//                   children: [
//                     pw.SizedBox(width: 26),
//                     pw.Wrap(
//                       crossAxisAlignment: pw.WrapCrossAlignment.end,
//                       children: [
//
//                         pw.FittedBox(
//                           fit: pw.BoxFit.scaleDown,
//                           alignment: pw.Alignment.centerLeft,
//                           child:pw.Text(
//                             titleEn,
//                             maxLines: 1,
//                             style: pw.TextStyle(
//                               fontSize: 24,
//                               font: bahnSchrift,
//                               // fontWeight: pw.FontWeight.bold,
//                               color: darkText,
//                             ),
//                           ),
//                         ),
//
//
//                         if (titleSuffix != null)
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.only(left: 8),
//                             child: pw.Text(
//                               titleSuffix,
//                               style: pw.TextStyle(
//                                 fontSize: 24,
//                                 font: bahnSchrift,
//                                 color: darkText,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     tamilCaption(titleTa),
//                     pw.SizedBox(width: 26),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     final pageFormat = PdfPageFormat.a4;
//     const margin = 6.0;
//     final contentWidth = pageFormat.width - margin * 2;
//     final contentHeight = pageFormat.height - margin * 2;
//
//     pdf.addPage(
//       pw.Page(
//         pageFormat: pageFormat,
//         margin: const pw.EdgeInsets.all(margin),
//         // theme: pw.ThemeData.withFont(base: baseRegular, bold: baseBold),
//         build: (context) {
//           return pw.SizedBox(
//             width: contentWidth,
//             height: contentHeight,
//             child: pw.Container(
//               decoration: pw.BoxDecoration(
//                 border: pw.Border.all(color: borderColor, width: 1.4),
//                 // borderRadius: pw.BorderRadius.circular(6),
//               ),
//               child: pw.ClipRRect(
//                 horizontalRadius: 6,
//                 verticalRadius: 6,
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.stretch,
//                   children: [
//                     // Title band
//                     pw.Container(
//                       padding: const pw.EdgeInsets.symmetric(vertical: 22),
//                       color: goldLight,
//                       // decoration: pw.BoxDecoration(
//                       //   border: pw.Border(
//                       //     bottom: pw.BorderSide(color: borderColor, width: 1),
//                       //   ),
//                       // ),
//                       child: pw.Center(
//                         child: pw.Text(
//                           'SCAN AND CONNECT',
//                           style: pw.TextStyle(
//                             fontSize: 25,
//                             fontWeight: pw.FontWeight.bold,
//                             font: engraversMT,
//                             // letterSpacing: 3,
//                           ),
//                         ),
//                       ),
//                     ),
//                     pw.Divider(
//                       color: PdfColor.fromHex('#000000'),
//                       thickness: 1,
//                       height: 0,
//                     ),
//                     // Ward / Room + phone band
//                     pw.Container(
//                       padding: const pw.EdgeInsets.symmetric(vertical: 12),
//                       decoration: pw.BoxDecoration(
//                         color: goldLight,
//                         // border: pw.Border(
//                         //   bottom: pw.BorderSide(color: borderColor, width: 1),
//                         // ),
//                       ),
//                       child: pw.Column(
//                         children: [
//                           pw.Text(
//                             '$ward - $bed',
//                             style: pw.TextStyle(
//                               font: dejavuSerif,
//                               fontSize: 20,
//                               // fontWeight: pw.FontWeight.bold,
//                             ),
//                           ),
//                           pw.SizedBox(height: 8),
//                           pw.Divider(
//                             color: PdfColor.fromHex('#000000'),
//                             thickness: 0,
//                             height: 0,
//                           ),
//                           pw.SizedBox(height: 8),
//                           pw.Container(
//                             padding: const pw.EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 6,
//                             ),
//                             decoration: pw.BoxDecoration(
//                               color: goldLight,
//                               // borderRadius: pw.BorderRadius.circular(20),
//                               // border: pw.Border.all(
//                               //   color: borderColor,
//                               //   width: 0.8,
//                               // ),
//                             ),
//                             child: pw.Text(
//                               'Phone Assistance: $mobileNumber',
//                               style: pw.TextStyle(
//                                 fontSize: 20,
//                                 font: dejavuSerif,
//                                 // fontWeight: pw.FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           // pw.SizedBox(height: 8),
//                           // pw.Divider(
//                           //   color: PdfColor.fromHex('#000000'),
//                           //   thickness: 1,
//                           //   height: 0,
//                           // ),
//                         ],
//                       ),
//                     ),
//                     pw.Divider(
//                       color: PdfColor.fromHex('#000000'),
//                       thickness: 1,
//                       height: 0,
//                     ),
//                     if (isWifi == 1) ...[
//                       // WiFi — left blank for a printed WiFi QR sticker
//                       sectionRow(
//                         step: 1,
//                         bgColor: pinkColor,
//                         emptyQrBox: true,
//                         titleEn: 'SCAN FOR FREE WI-FI',
//                         titleSuffix: '(2GB / DAY)',
//                         titleTa: wifiTamilLabel,
//                       ),
//                     ],
//                     // Attendant food ordering QR
//                     sectionRow(
//                       step: 2,
//                       bgColor: yellowColor,
//                       qrBytes: foodQrBytes,
//                       titleEn: 'SCAN FOR ATTENDANT FOOD',
//                       titleTa: foodTamilLabel,
//                     ),
//                     sectionRow(
//                       step: 3,
//                       bgColor: greenColor,
//                       qrBytes: feedbackQrBytes,
//                       titleEn: 'SCAN FOR ANY ASSISTANCE (OR) FEEDBACK',
//                       titleTa: feedbackTamilLabel,
//                     ),
//                     // Assistance / feedback QR
//                     if (isWifi == 0) ...[
//                       // WiFi — left blank for WiFi Not Available Bed
//                       pw.Container(height: 180, color: pinkColor),
//                     ],
//                     // Footer
//                     // pw.Container(
//                     //   padding: const pw.EdgeInsets.symmetric(
//                     //     horizontal: 26,
//                     //     vertical: 10,
//                     //   ),
//                     //   decoration: pw.BoxDecoration(
//                     //     color: PdfColors.grey100,
//                     //     border: pw.Border(
//                     //       top: pw.BorderSide(color: borderColor, width: 1),
//                     //     ),
//                     //   ),
//                     //   child: pw.Row(
//                     //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     //     children: [
//                     //       pw.Text(
//                     //         'Point your phone camera at the QR to scan',
//                     //         style: pw.TextStyle(
//                     //           fontSize: 10,
//                     //           color: PdfColors.grey700,
//                     //         ),
//                     //       ),
//                     //       pw.Text(
//                     //         'Printed: ${_formatDate(DateTime.now())}',
//                     //         style: pw.TextStyle(
//                     //           fontSize: 10,
//                     //           color: PdfColors.grey700,
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//
//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }
//
//   // Future<void> qrPdf({
//   //   required String ward,
//   //   required String bed,
//   //   required String mobileNumber,
//   //   required String foodOrderUrl,
//   //   required String feedbackUrl,
//   // }) async {
//   //   final pdf = pw.Document();
//   //
//   //   // --- Fonts loaded from bundled assets instead of PdfGoogleFonts, so
//   //   // PDF generation no longer needs network access at all. Add these to
//   //   // pubspec.yaml:
//   //   //
//   //   //   flutter:
//   //   //     assets:
//   //   //       - assets/fonts/NotoSans-Regular.ttf
//   //   //       - assets/fonts/NotoSans-Bold.ttf
//   //   //       - assets/fonts/NotoSansTamil-Regular.ttf
//   //   //       - assets/fonts/NotoSansTamil-Bold.ttf
//   //   //
//   //   // (Download them from fonts.google.com/noto/specimen/Noto+Sans and
//   //   // fonts.google.com/noto/specimen/Noto+Sans+Tamil — same families
//   //   // PdfGoogleFonts was fetching, just bundled locally now.)
//   //   Future<pw.Font> loadFont(String assetPath) async {
//   //     final data = await rootBundle.load(assetPath);
//   //     return pw.Font.ttf(data);
//   //   }
//   //
//   //   final baseRegular = await loadFont('assets/fonts/NotoSans-Regular.ttf');
//   //   final baseBold = await loadFont('assets/fonts/NotoSans-Bold.ttf');
//   //   final tamilRegular = await loadFont('assets/fonts/NotoSansTamil-Regular.ttf');
//   //   final tamilBold = await loadFont('assets/fonts/NotoSansTamil-Bold.ttf');
//   //
//   //   Future<Uint8List> generateQr(String data) async {
//   //     final qrImage = await QrPainter(
//   //       data: data,
//   //       version: QrVersions.auto,
//   //       errorCorrectionLevel: QrErrorCorrectLevel.H,
//   //       gapless: true,
//   //       color: const Color(0xFF000000),
//   //       emptyColor: const Color(0xFFFFFFFF),
//   //     ).toImageData(1000);
//   //     return qrImage!.buffer.asUint8List();
//   //   }
//   //
//   //   final foodQrBytes = await generateQr(foodOrderUrl);
//   //   final feedbackQrBytes = await generateQr(feedbackUrl);
//   //
//   //   final borderColor = PdfColor.fromHex('#2B2B2B');
//   //   final pinkColor = PdfColor.fromHex('#F3DCD3');
//   //   final yellowColor = PdfColor.fromHex('#F0C24B');
//   //   final greenColor = PdfColor.fromHex('#C7D9B7');
//   //   final darkText = PdfColor.fromHex('#1F1F1F');
//   //
//   //   pw.Widget qrCard({
//   //     required int step,
//   //     Uint8List? qrBytes,
//   //     bool placeholder = false,
//   //     required PdfColor accent,
//   //   }) {
//   //     return pw.Stack(
//   //       children: [
//   //         pw.Container(
//   //           width: 150,
//   //           height: 150,
//   //           padding: const pw.EdgeInsets.all(10),
//   //           decoration: pw.BoxDecoration(
//   //             color: PdfColors.white,
//   //             borderRadius: pw.BorderRadius.circular(10),
//   //             border: pw.Border.all(
//   //               color: placeholder ? PdfColors.grey400 : borderColor,
//   //               width: placeholder ? 1.4 : 1,
//   //             ),
//   //           ),
//   //           child: placeholder
//   //               ? pw.Center(
//   //             child: pw.Column(
//   //               mainAxisAlignment: pw.MainAxisAlignment.center,
//   //               children: [
//   //                 pw.Text(
//   //                   'STICK',
//   //                   style: pw.TextStyle(
//   //                     fontSize: 12,
//   //                     fontWeight: pw.FontWeight.bold,
//   //                     color: PdfColors.grey500,
//   //                   ),
//   //                 ),
//   //                 pw.SizedBox(height: 4),
//   //                 pw.Text(
//   //                   'Wi-Fi QR\nSticker\nHere',
//   //                   textAlign: pw.TextAlign.center,
//   //                   style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
//   //                 ),
//   //               ],
//   //             ),
//   //           )
//   //               : pw.Image(pw.MemoryImage(qrBytes!)),
//   //         ),
//   //       ],
//   //     );
//   //   }
//   //
//   //   pw.Widget sectionRow({
//   //     required int step,
//   //     required PdfColor bgColor,
//   //     required String titleEn,
//   //     required String titleTa,
//   //     String? titleSuffix,
//   //     Uint8List? qrBytes,
//   //     bool emptyQrBox = false,
//   //   }) {
//   //     return pw.Expanded(
//   //       child: pw.Container(
//   //         width: double.infinity,
//   //         padding: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 14),
//   //         decoration: pw.BoxDecoration(
//   //           color: bgColor,
//   //           border: pw.Border(bottom: pw.BorderSide(color: borderColor, width: 1)),
//   //         ),
//   //         child: pw.Row(
//   //           crossAxisAlignment: pw.CrossAxisAlignment.center,
//   //           children: [
//   //             qrCard(
//   //               step: step,
//   //               qrBytes: qrBytes,
//   //               placeholder: emptyQrBox,
//   //               accent: bgColor,
//   //             ),
//   //             pw.SizedBox(width: 26),
//   //             pw.Expanded(
//   //               child: pw.Column(
//   //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//   //                 mainAxisAlignment: pw.MainAxisAlignment.center,
//   //                 children: [
//   //                   pw.Wrap(
//   //                     crossAxisAlignment: pw.WrapCrossAlignment.end,
//   //                     children: [
//   //                       pw.Text(
//   //                         titleEn,
//   //                         style: pw.TextStyle(
//   //                           fontSize: 30,
//   //                           fontWeight: pw.FontWeight.bold,
//   //                           color: darkText,
//   //                         ),
//   //                       ),
//   //                       if (titleSuffix != null)
//   //                         pw.Padding(
//   //                           padding: const pw.EdgeInsets.only(left: 8),
//   //                           child: pw.Text(
//   //                             titleSuffix,
//   //                             style: pw.TextStyle(fontSize: 13, color: darkText),
//   //                           ),
//   //                         ),
//   //                     ],
//   //                   ),
//   //                   pw.SizedBox(height: 8),
//   //                   pw.Text(
//   //                     titleTa,
//   //                     style: pw.TextStyle(font: tamilRegular, fontSize: 15, color: darkText),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     );
//   //   }
//   //
//   //   final pageFormat = PdfPageFormat.a4;
//   //   const margin = 18.0;
//   //   final contentWidth = pageFormat.width - margin * 2;
//   //   final contentHeight = pageFormat.height - margin * 2;
//   //
//   //   pdf.addPage(
//   //     pw.Page(
//   //       pageFormat: pageFormat,
//   //       margin: const pw.EdgeInsets.all(margin),
//   //       theme: pw.ThemeData.withFont(
//   //         base: baseRegular,
//   //         bold: baseBold,
//   //         fontFallback: [tamilRegular, tamilBold],
//   //       ),
//   //       build: (context) {
//   //         return pw.SizedBox(
//   //           width: contentWidth,
//   //           height: contentHeight,
//   //           child: pw.Container(
//   //             decoration: pw.BoxDecoration(
//   //               border: pw.Border.all(color: borderColor, width: 1.4),
//   //               borderRadius: pw.BorderRadius.circular(6),
//   //             ),
//   //             child: pw.ClipRRect(
//   //               horizontalRadius: 6,
//   //               verticalRadius: 6,
//   //               child: pw.Column(
//   //                 crossAxisAlignment: pw.CrossAxisAlignment.stretch,
//   //                 children: [
//   //                   // Title band
//   //                   pw.Container(
//   //                     padding: const pw.EdgeInsets.symmetric(vertical: 22),
//   //                     decoration: pw.BoxDecoration(
//   //                       border: pw.Border(
//   //                           bottom: pw.BorderSide(color: borderColor, width: 1)),
//   //                     ),
//   //                     child: pw.Center(
//   //                       child: pw.Text(
//   //                         'SCAN AND CONNECT',
//   //                         style: pw.TextStyle(
//   //                           fontSize: 34,
//   //                           fontWeight: pw.FontWeight.bold,
//   //                           letterSpacing: 3,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   // Ward / Room + phone band
//   //                   pw.Container(
//   //                     padding: const pw.EdgeInsets.symmetric(vertical: 16),
//   //                     decoration: pw.BoxDecoration(
//   //                       color: PdfColors.grey100,
//   //                       border: pw.Border(
//   //                           bottom: pw.BorderSide(color: borderColor, width: 1)),
//   //                     ),
//   //                     child: pw.Column(
//   //                       children: [
//   //                         pw.Text(
//   //                           '$ward - $bed',
//   //                           style: pw.TextStyle(font: tamilBold, fontSize: 22),
//   //                         ),
//   //                         pw.SizedBox(height: 8),
//   //                         pw.Container(
//   //                           padding: const pw.EdgeInsets.symmetric(
//   //                               horizontal: 14, vertical: 6),
//   //                           decoration: pw.BoxDecoration(
//   //                             color: PdfColors.white,
//   //                             borderRadius: pw.BorderRadius.circular(20),
//   //                             border: pw.Border.all(color: borderColor, width: 0.8),
//   //                           ),
//   //                           child: pw.Text(
//   //                             'Phone Assistance: $mobileNumber',
//   //                             style: pw.TextStyle(
//   //                                 fontSize: 15, fontWeight: pw.FontWeight.bold),
//   //                           ),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                   // Attendant food ordering QR
//   //                   sectionRow(
//   //                     step: 1,
//   //                     bgColor: yellowColor,
//   //                     qrBytes: foodQrBytes,
//   //                     titleEn: 'Scan for Attendant Food',
//   //                     titleTa: 'நோயாளிகளுடன் இருப்பவர்களின் உணவுக்கு ஸ்கேன் செய்யவும்',
//   //                   ),
//   //                   // Assistance / feedback QR
//   //                   sectionRow(
//   //                     step: 2,
//   //                     bgColor: greenColor,
//   //                     qrBytes: feedbackQrBytes,
//   //                     titleEn: 'Scan for Any Assistance (or) Feedback',
//   //                     titleTa: 'உதவிக்கு மற்றும் கருத்துக்கள் பகிர\nஸ்கேன் செய்யவும்',
//   //                   ),
//   //                   sectionRow(
//   //                     step: 3,
//   //                     bgColor: pinkColor,
//   //                     emptyQrBox: true,
//   //                     titleEn: 'Scan for Free Wi-Fi',
//   //                     titleSuffix: '(2GB / Day)',
//   //                     titleTa: 'இலவச WiFi சேவைக்கு ஸ்கேன்\nசெய்யவும் (2 GB / தினமும்)',
//   //                   ),
//   //                   // Footer
//   //                   pw.Container(
//   //                     padding: const pw.EdgeInsets.symmetric(
//   //                         horizontal: 26, vertical: 10),
//   //                     decoration: pw.BoxDecoration(
//   //                       color: PdfColors.grey100,
//   //                       border: pw.Border(
//   //                           top: pw.BorderSide(color: borderColor, width: 1)),
//   //                     ),
//   //                     child: pw.Row(
//   //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         pw.Text(
//   //                           'Point your phone camera at the QR to scan',
//   //                           style: pw.TextStyle(
//   //                               fontSize: 10, color: PdfColors.grey700),
//   //                         ),
//   //                         pw.Text(
//   //                           'Printed: ${_formatDate(DateTime.now())}',
//   //                           style: pw.TextStyle(
//   //                               fontSize: 10, color: PdfColors.grey700),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   //
//   //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   // }
//
//   String _formatDate(DateTime d) {
//     final dd = d.day.toString().padLeft(2, '0');
//     final mm = d.month.toString().padLeft(2, '0');
//     return '$dd/$mm/${d.year}';
//   }
//
//   // Future<void> qrPdf({
//   //   required String ward,
//   //   required String bed,
//   //   required String mobileNumber,
//   //   required String foodOrderUrl,
//   //   required String feedbackUrl,
//   // }) async {
//   //   final pdf = pw.Document();
//   //   final baseRegular = await PdfGoogleFonts.notoSansRegular();
//   //   final baseBold = await PdfGoogleFonts.notoSansBold();
//   //   final tamilRegular = await PdfGoogleFonts.notoSansTamilRegular();
//   //   final tamilBold = await PdfGoogleFonts.notoSansTamilBold();
//   //   Future<Uint8List> generateQr(String data) async {
//   //     final qrImage = await QrPainter(
//   //       data: data,
//   //       version: QrVersions.auto,
//   //       errorCorrectionLevel: QrErrorCorrectLevel.H,
//   //       gapless: true,
//   //       color: const Color(0xFF000000),
//   //       emptyColor: const Color(0xFFFFFFFF),
//   //     ).toImageData(1000);
//   //     return qrImage!.buffer.asUint8List();
//   //   }
//   //
//   //   final foodQrBytes = await generateQr(foodOrderUrl);
//   //   final feedbackQrBytes = await generateQr(feedbackUrl);
//   //
//   //   final borderColor = PdfColor.fromHex('#2B2B2B');
//   //   final pinkColor = PdfColor.fromHex('#F3DCD3');
//   //   final yellowColor = PdfColor.fromHex('#F0C24B');
//   //   final greenColor = PdfColor.fromHex('#C7D9B7');
//   //   final darkText = PdfColor.fromHex('#1F1F1F');
//   //
//   //   pw.Widget qrCard({
//   //     required int step,
//   //     Uint8List? qrBytes,
//   //     bool placeholder = false,
//   //     required PdfColor accent,
//   //   }) {
//   //     return pw.Stack(
//   //       children: [
//   //         pw.Container(
//   //           width: 150,
//   //           height: 150,
//   //           padding: const pw.EdgeInsets.all(10),
//   //           decoration: pw.BoxDecoration(
//   //             color: PdfColors.white,
//   //             borderRadius: pw.BorderRadius.circular(10),
//   //             border: pw.Border.all(
//   //               color: placeholder ? PdfColors.grey400 : borderColor,
//   //               width: placeholder ? 1.4 : 1,
//   //               // style: placeholder ? pw.PaintingStyle.stroke : pw.PaintingStyle.stroke,
//   //             ),
//   //           ),
//   //           child: placeholder
//   //               ? pw.Center(
//   //             child: pw.Column(
//   //               mainAxisAlignment: pw.MainAxisAlignment.center,
//   //               children: [
//   //                 pw.Text(
//   //                   'STICK',
//   //                   style: pw.TextStyle(
//   //                     fontSize: 12,
//   //                     fontWeight: pw.FontWeight.bold,
//   //                     color: PdfColors.grey500,
//   //                   ),
//   //                 ),
//   //                 pw.SizedBox(height: 4),
//   //                 pw.Text(
//   //                   'Wi-Fi QR\nSticker\nHere',
//   //                   textAlign: pw.TextAlign.center,
//   //                   style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
//   //                 ),
//   //               ],
//   //             ),
//   //           )
//   //               : pw.Image(pw.MemoryImage(qrBytes!)),
//   //         ),
//   //         // pw.Positioned(
//   //         //   top: -8,
//   //         //   left: -8,
//   //         //   child: pw.Container(
//   //         //     width: 26,
//   //         //     height: 26,
//   //         //     alignment: pw.Alignment.center,
//   //         //     decoration: pw.BoxDecoration(
//   //         //       color: accent,
//   //         //       shape: pw.BoxShape.circle,
//   //         //       border: pw.Border.all(color: borderColor, width: 1),
//   //         //     ),
//   //         //     child: pw.Text(
//   //         //       '$step',
//   //         //       style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
//   //         //     ),
//   //         //   ),
//   //         // ),
//   //       ],
//   //     );
//   //   }
//   //
//   //   pw.Widget sectionRow({
//   //     required int step,
//   //     required PdfColor bgColor,
//   //     required String titleEn,
//   //     required String titleTa,
//   //     String? titleSuffix,
//   //     Uint8List? qrBytes,
//   //     bool emptyQrBox = false,
//   //   }) {
//   //     return pw.Expanded(
//   //       child: pw.Container(
//   //         width: double.infinity,
//   //         padding: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 14),
//   //         decoration: pw.BoxDecoration(
//   //           color: bgColor,
//   //           border: pw.Border(bottom: pw.BorderSide(color: borderColor, width: 1)),
//   //         ),
//   //         child: pw.Row(
//   //           crossAxisAlignment: pw.CrossAxisAlignment.center,
//   //           children: [
//   //             qrCard(
//   //               step: step,
//   //               qrBytes: qrBytes,
//   //               placeholder: emptyQrBox,
//   //               accent: bgColor,
//   //             ),
//   //             pw.SizedBox(width: 26),
//   //             pw.Expanded(
//   //               child: pw.Column(
//   //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//   //                 mainAxisAlignment: pw.MainAxisAlignment.center,
//   //                 children: [
//   //                   pw.Wrap(
//   //                     crossAxisAlignment: pw.WrapCrossAlignment.end,
//   //                     children: [
//   //                       pw.Text(
//   //                         titleEn,
//   //                         style: pw.TextStyle(
//   //                           fontSize: 30,
//   //                           fontWeight: pw.FontWeight.bold,
//   //                           color: darkText,
//   //                         ),
//   //                       ),
//   //                       if (titleSuffix != null)
//   //                         pw.Padding(
//   //                           padding: const pw.EdgeInsets.only(left: 8),
//   //                           child: pw.Text(
//   //                             titleSuffix,
//   //                             style: pw.TextStyle(fontSize: 13, color: darkText),
//   //                           ),
//   //                         ),
//   //                     ],
//   //                   ),
//   //                   pw.SizedBox(height: 8),
//   //                   pw.Text(
//   //                     titleTa,
//   //                     style: pw.TextStyle(font: tamilRegular, fontSize: 15, color: darkText),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     );
//   //   }
//   //
//   //   final pageFormat = PdfPageFormat.a4;
//   //   const margin = 18.0;
//   //   final contentWidth = pageFormat.width - margin * 2;
//   //   final contentHeight = pageFormat.height - margin * 2;
//   //
//   //   pdf.addPage(
//   //     pw.Page(
//   //       pageFormat: pageFormat,
//   //       margin: const pw.EdgeInsets.all(margin),
//   //       theme: pw.ThemeData.withFont(
//   //         base: baseRegular,
//   //         bold: baseBold,
//   //         fontFallback: [tamilRegular, tamilBold],
//   //       ),
//   //       build: (context) {
//   //         // SizedBox pins the card to the full printable area so the
//   //         // Expanded sections below actually share out the whole sheet.
//   //         return pw.SizedBox(
//   //           width: contentWidth,
//   //           height: contentHeight,
//   //           child: pw.Container(
//   //             decoration: pw.BoxDecoration(
//   //               border: pw.Border.all(color: borderColor, width: 1.4),
//   //               borderRadius: pw.BorderRadius.circular(6),
//   //             ),
//   //             child: pw.ClipRRect(
//   //               horizontalRadius: 6,
//   //               verticalRadius: 6,
//   //               child: pw.Column(
//   //                 crossAxisAlignment: pw.CrossAxisAlignment.stretch,
//   //                 children: [
//   //                   // Title band
//   //                   pw.Container(
//   //                     padding: const pw.EdgeInsets.symmetric(vertical: 22),
//   //                     decoration: pw.BoxDecoration(
//   //                       border: pw.Border(
//   //                           bottom: pw.BorderSide(color: borderColor, width: 1)),
//   //                     ),
//   //                     child: pw.Center(
//   //                       child: pw.Text(
//   //                         'SCAN AND CONNECT',
//   //                         style: pw.TextStyle(
//   //                           fontSize: 34,
//   //                           fontWeight: pw.FontWeight.bold,
//   //                           letterSpacing: 3,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   // Ward / Room + phone band
//   //                   pw.Container(
//   //                     padding: const pw.EdgeInsets.symmetric(vertical: 16),
//   //                     decoration: pw.BoxDecoration(
//   //                       color: PdfColors.grey100,
//   //                       border: pw.Border(
//   //                           bottom: pw.BorderSide(color: borderColor, width: 1)),
//   //                     ),
//   //                     child: pw.Column(
//   //                       children: [
//   //                         pw.Text(
//   //                           '$ward - $bed',
//   //                           style: pw.TextStyle(font: tamilBold, fontSize: 22),
//   //                         ),
//   //                         pw.SizedBox(height: 8),
//   //                         pw.Container(
//   //                           padding: const pw.EdgeInsets.symmetric(
//   //                               horizontal: 14, vertical: 6),
//   //                           decoration: pw.BoxDecoration(
//   //                             color: PdfColors.white,
//   //                             borderRadius: pw.BorderRadius.circular(20),
//   //                             border: pw.Border.all(color: borderColor, width: 0.8),
//   //                           ),
//   //                           child: pw.Text(
//   //                             'Phone Assistance: $mobileNumber',
//   //                             style: pw.TextStyle(
//   //                                 fontSize: 15, fontWeight: pw.FontWeight.bold),
//   //                           ),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                   // Attendant food ordering QR
//   //                   sectionRow(
//   //                     step: 1,
//   //                     bgColor: yellowColor,
//   //                     qrBytes: foodQrBytes,
//   //                     titleEn: 'Scan for Attendant Food',
//   //                     titleTa: 'நோயாளிகளுடன் இருப்பவர்களின் உணவுக்கு ஸ்கேன் செய்யவும்',
//   //                   ),
//   //                   // Assistance / feedback QR
//   //                   sectionRow(
//   //                     step: 2,
//   //                     bgColor: greenColor,
//   //                     qrBytes: feedbackQrBytes,
//   //                     titleEn: 'Scan for Any Assistance (or) Feedback',
//   //                     titleTa: 'உதவிக்கு மற்றும் கருத்துக்கள் பகிர\nஸ்கேன் செய்யவும்',
//   //                   ),
//   //                   sectionRow(
//   //                     step: 3,
//   //                     bgColor: pinkColor,
//   //                     emptyQrBox: true,
//   //                     titleEn: 'Scan for Free Wi-Fi',
//   //                     titleSuffix: '(2GB / Day)',
//   //                     titleTa: 'இலவச WiFi சேவைக்கு ஸ்கேன்\nசெய்யவும் (2 GB / தினமும்)',
//   //                   ),
//   //                   // Footer
//   //                   pw.Container(
//   //                     padding: const pw.EdgeInsets.symmetric(
//   //                         horizontal: 26, vertical: 10),
//   //                     decoration: pw.BoxDecoration(
//   //                       color: PdfColors.grey100,
//   //                       border: pw.Border(
//   //                           top: pw.BorderSide(color: borderColor, width: 1)),
//   //                     ),
//   //                     child: pw.Row(
//   //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         pw.Text(
//   //                           'Point your phone camera at the QR to scan',
//   //                           style: pw.TextStyle(
//   //                               fontSize: 10, color: PdfColors.grey700),
//   //                         ),
//   //                         pw.Text(
//   //                           'Printed: ${_formatDate(DateTime.now())}',
//   //                           style: pw.TextStyle(
//   //                               fontSize: 10, color: PdfColors.grey700),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   //
//   //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   // }
//
//   // String _formatDate(DateTime d) {
//   //   final dd = d.day.toString().padLeft(2, '0');
//   //   final mm = d.month.toString().padLeft(2, '0');
//   //   return '$dd/$mm/${d.year}';
//   // }
//   // Future<void> qrPdf({
//   //   required String ward,
//   //   required String bed,
//   //   required String feedbackUrl,
//   // }) async {
//   //   final pdf = pw.Document();
//   //   final qrImage = await QrPainter(
//   //     data: feedbackUrl,
//   //     version: QrVersions.auto,
//   //     gapless: true,
//   //   ).toImageData(500);
//   //
//   //   final qrBytes = qrImage!.buffer.asUint8List();
//   //
//   //   pdf.addPage(
//   //     pw.Page(
//   //       build: (context) {
//   //         return pw.Center(
//   //           child: pw.Column(
//   //             mainAxisSize: pw.MainAxisSize.min,
//   //             children: [
//   //               pw.Text(
//   //                 "$ward",
//   //                 style: pw.TextStyle(
//   //                   fontSize: 25,
//   //                   fontWeight: pw.FontWeight.bold,
//   //                 ),
//   //               ),
//   //               pw.SizedBox(height: 10),
//   //               pw.Text(
//   //                 bed,
//   //                 style: pw.TextStyle(
//   //                   fontSize: 20,
//   //                   fontWeight: pw.FontWeight.bold,
//   //                 ),
//   //               ),
//   //               pw.SizedBox(height: 20),
//   //               pw.Image(pw.MemoryImage(qrBytes), width: 350, height: 350),
//   //             ],
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   //
//   //   await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   // }
//
//   Future<void> attenderQrPdf({
//     required String title,
//     required String url,
//   }) async {
//     final pdf = pw.Document();
//
//     final qrImage = await QrPainter(
//       data: "${Config.siteUrl}$url",
//       version: QrVersions.auto,
//       gapless: true,
//     ).toImageData(250);
//
//     final qrBytes = qrImage!.buffer.asUint8List();
//
//     pdf.addPage(
//       pw.Page(
//         build: (context) {
//           return pw.Center(
//             child: pw.Column(
//               mainAxisSize: pw.MainAxisSize.min,
//               children: [
//                 pw.Text(
//                   title,
//                   style: pw.TextStyle(
//                     fontSize: 20,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Image(pw.MemoryImage(qrBytes), width: 350, height: 350),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//
//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }
// }

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/config.dart';
import '../config/tamil_text.dart';

/// Generates the "Scan and Connect" bedside QR card as a PDF, matching the
/// printed reference design: a title band, ward/room + phone band, and one
/// coloured row per QR (Wi-Fi / Food / Assistance-Feedback).
class PdfServices {
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
    // NEW: pass real Wi-Fi QR payload (e.g. a WIFI: connection string or a
    // captive-portal URL) to print an actual scannable QR in the Wi-Fi row,
    // exactly like the reference photo. Leave null to keep the old
    // "STICK Wi-Fi QR Sticker Here" placeholder behaviour.
    String? wifiQrData,
  }) async {
    final pdf = pw.Document();

    Future<pw.Font> loadFont(String assetPath) async {
      final data = await rootBundle.load(assetPath);
      return pw.Font.ttf(data);
    }

    final engraversMT = await loadFont('assets/fonts/EngraversMt.ttf');
    final dejavuSerif = await loadFont('assets/fonts/dejavu-serif.condensed-bold.ttf');
    final bahnSchrift = await loadFont('assets/fonts/Bahnschrift-Condensed.otf');

    Future<Uint8List> generateQr(String data, Color bgColor) async {
      final qrImage = await QrPainter(
        data: data,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        gapless: true,
        color: const Color(0xFF000000),
        emptyColor: bgColor,
      ).toImageData(1000);
      return qrImage!.buffer.asUint8List();
    }

    // final borderColor = PdfColor.fromHex('#2B2B2B');
    final borderColor = PdfColor.fromHex('#000000');
    final pinkColor = PdfColor.fromHex('#F3DCD3');
    final yellowColor = PdfColor.fromHex('#F0C24B');
    final greenColor = PdfColor.fromHex('#C7D9B7');
    final darkText = PdfColor.fromHex('#1F1F1F');

    final bgYellow = const Color(0xFFF0C24B);
    final bgGreen = const Color(0xFFC7D9B7);
    final bgPink = const Color(0xFFF3DCD3);

    final goldLight = PdfColor.fromHex('#fae7b5');

    final foodQrBytes = await generateQr(foodOrderUrl, bgYellow);
    final feedbackQrBytes = await generateQr(feedbackUrl, bgGreen);
    final wifiQrBytes = wifiQrData != null
        ? await generateQr(wifiQrData, bgPink)
        : null;

    pw.Widget qrCard({Uint8List? qrBytes, bool placeholder = false}) {
      return pw.Container(
        width: 125,
        height: 125,
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
      );
    }

    // Tamil caption now shares the same left edge as the English heading
    // above it (both live inside the same Expanded/Column), instead of the
    // old extra 70pt offset that pushed it out of alignment with the
    // reference design.
    // pw.Widget tamilCaption(TamilImageResult label) {
    //   return pw.Image(
    //     pw.MemoryImage(label.pngBytes),
    //     width: label.width,
    //     height: label.height,
    //     fit: pw.BoxFit.contain,
    //   );
    // }

    pw.Widget tamilCaption(TamilImageResult label) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(left: 70),
        child: pw.Image(
          pw.MemoryImage(label.pngBytes),
          width: label.width,
          height: label.height,
          fit: pw.BoxFit.contain,
        ),
      );
    }

    pw.Widget sectionRow({
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
          padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: pw.BoxDecoration(
            color: bgColor,
            border: pw.Border(top: pw.BorderSide(color: borderColor, width: 1)),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              qrCard(qrBytes: qrBytes, placeholder: emptyQrBox),
              pw.SizedBox(width: 26),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Wrap(
                      crossAxisAlignment: pw.WrapCrossAlignment.end,
                      children: [
                        pw.Text(
                          titleEn,
                          maxLines: 2,
                          style: pw.TextStyle(
                            fontSize: 24,
                            font: bahnSchrift,
                            color: darkText,
                          ),
                        ),
                        // pw.FittedBox(
                        //   fit: pw.BoxFit.scaleDown,
                        //   alignment: pw.Alignment.centerLeft,
                        //   child:
                        //   pw.Text(
                        //     titleEn,
                        //     maxLines: 1,
                        //     style: pw.TextStyle(
                        //       fontSize: 24,
                        //       font: bahnSchrift,
                        //       color: darkText,
                        //     ),
                        //   ),
                        // ),
                        if (titleSuffix != null)
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 8),
                            child: pw.Text(
                              titleSuffix,
                              style: pw.TextStyle(
                                fontSize: 24,
                                font: bahnSchrift,
                                color: darkText,
                              ),
                            ),
                          ),
                      ],
                    ),
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
    const margin = 6.0;
    const marginTopBottom = 70.0;
    final contentWidth = pageFormat.width - margin * 2;
    final contentHeight = pageFormat.height - marginTopBottom * 2;

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.only(
          left: margin,
          right: margin,
          top: marginTopBottom,
          bottom: marginTopBottom,
        ),
        build: (context) {
          return pw.SizedBox(
            width: contentWidth,
            height: contentHeight,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: borderColor, width: 1.4),
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
                      color: goldLight,
                      child: pw.Center(
                        child: pw.Text(
                          'SCAN AND CONNECT',
                          style: pw.TextStyle(
                            fontSize: 25,
                            fontWeight: pw.FontWeight.bold,
                            font: engraversMT,
                          ),
                        ),
                      ),
                    ),
                    pw.Divider(color: borderColor, thickness: 1, height: 1),
                    // Ward / Room + phone band
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 12),
                      decoration: pw.BoxDecoration(
                        color: goldLight,
                        border: pw.Border(
                          top: pw.BorderSide(color: borderColor),
                        ),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text(
                            '$ward - $bed',
                            style: pw.TextStyle(
                              font: dejavuSerif,
                              fontSize: 20,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Divider(
                            color: borderColor,
                            thickness: 1,
                            // height: 0.5,
                          ),
                          pw.SizedBox(height: 8),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: pw.BoxDecoration(color: goldLight),
                            child: pw.Text(
                              'Phone Assistance: $mobileNumber',
                              style: pw.TextStyle(
                                fontSize: 20,
                                font: dejavuSerif,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Divider(color: borderColor, thickness: 1, height: 1),
                    if (isWifi == 1) ...[
                      // Wi-Fi row: real QR if wifiQrData was supplied,
                      // otherwise the "stick a sticker here" placeholder.
                      sectionRow(
                        bgColor: pinkColor,
                        emptyQrBox: wifiQrBytes == null,
                        qrBytes: wifiQrBytes,
                        titleEn: 'SCAN FOR FREE WI-FI',
                        titleSuffix: '(2 GB/PER DAY)',
                        titleTa: wifiTamilLabel,
                      ),
                    ],
                    // Attendant food ordering QR
                    sectionRow(
                      bgColor: yellowColor,
                      qrBytes: foodQrBytes,
                      titleEn: 'SCAN FOR ATTENDANT FOOD',
                      titleTa: foodTamilLabel,
                    ),
                    // Assistance / feedback QR
                    sectionRow(
                      bgColor: greenColor,
                      qrBytes: feedbackQrBytes,
                      titleEn: 'SCAN FOR ANY ASSISTANCE (OR) FEEDBACK',
                      titleTa: feedbackTamilLabel,
                    ),
                    if (isWifi == 0) ...[
                      // No Wi-Fi available for this bed: leave a blank
                      // pink band instead of a QR row.
                      pw.Container(
                        height: 180,
                        color: pinkColor,
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                            top: pw.BorderSide(color: borderColor),
                          ),
                        ),
                      ),
                    ],
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

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

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
