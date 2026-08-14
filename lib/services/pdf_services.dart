import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/config.dart';

class PdfServices {
  Future<void> departmentQrPdf({
    required String deptName,
    required String deptId,
  }) async {
    final pdf = pw.Document();
    // String decryptWardId =SecureEncryptionHelper.decrypt(wardId);

    final qrImage = await QrPainter(
      data: "${Config.scanUrl}$deptId",
      version: QrVersions.auto,
      gapless: true,
    ).toImageData(500);

    final qrBytes = qrImage!.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  deptName,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                // pw.SizedBox(height: 10),
                // pw.Text("Ward ID: $wardId"),
                pw.SizedBox(height: 20),
                pw.Image(pw.MemoryImage(qrBytes), width: 350,height: 350),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
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
                pw.Image(pw.MemoryImage(qrBytes), width: 350,height: 350),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
