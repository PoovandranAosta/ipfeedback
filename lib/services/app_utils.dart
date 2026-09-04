
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/tamil_text.dart';
import '../routes/app_routes.dart';
import 'api_services.dart';

class AppUtils {
  final ApiService _service = ApiService();

  /// Splash Screen
  static Future<void> splashScreen() async {
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed(AppRoutes.dashboard);
    });
  }

  static Future<void> saveDId(String savedDeptId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deptId', savedDeptId);
  }

  static Future<String> loadDId() async {
    final prefs = await SharedPreferences.getInstance();
   return prefs.getString('deptId')??'';
  }

  /// Return the Data form the API Directly to the Model and Print the Payload
  Future<List<T>> fetchModelData<T>({
    required String url,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    // print("Url : $url");
    // print("Body : $body");
    // print("formJson : $fromJson");
    return _service.apiCall<T>(url: url, body: body, fromJson: fromJson);
  }

  /// Return the Direct String form the API and Print the Payload
  Future<String> fetchString({
    required String url,
    required Map<String, dynamic> body,
  }) {
    // print("Url : $url");
    // print("Body : $body");
    return _service.apiCallString(url: url, body: body);
  }

  Future<String> fetchString2({
    required String url,
    required Map<String, dynamic> body,
  }) {
    // print("Url : $url");
    // print("Body : $body");
    return _service.apiCallString2(url: url, body: body);
  }

  /// Encrypt and Decrypt Values form the Url
  static String encrypt(String plainText, String passphrase) {
    final plainBytes = utf8.encode(plainText);
    final keyBytes = utf8.encode(passphrase);

    final encrypted = List<int>.generate(
      plainBytes.length,
      (i) => plainBytes[i] ^ keyBytes[i % keyBytes.length],
    );

    // Return Base64 string for storage/transmission
    return base64Encode(encrypted);
  }

  static String decrypt(String encryptedBase64, String passphrase) {
    final encryptedBytes = base64Decode(encryptedBase64);
    final keyBytes = utf8.encode(passphrase);

    final decrypted = List<int>.generate(
      encryptedBytes.length,
      (i) => encryptedBytes[i] ^ keyBytes[i % keyBytes.length],
    );

    return utf8.decode(decrypted);
  }

  /// Extract last Value form the Url
  static String? extractUrlValue([String? url]) {
    try {
      final String targetUrl = (url != null && url.trim().isNotEmpty)
          ? url.trim()
          : Uri.base.toString();
      final Uri uri = Uri.parse(targetUrl);
      String path = uri.fragment.isNotEmpty ? uri.fragment : uri.path;
      if (path.startsWith('/')) {
        path = path.substring(1);
      }
      final List<String> segments = path
          .split('/')
          .where((segment) => segment.trim().isNotEmpty)
          .toList();
      if (segments.isEmpty) return null;
      final String value = Uri.decodeComponent(segments.last);
      // debugPrint('Current URL: $targetUrl');
      // debugPrint('Extracted Value: $value');
      return value;
    } catch (e) {
      // debugPrint('Error extracting URL value: $e');
      return null;
    }
  }


  /// Return Only The Message form The String with Key
  static String responseMsg(String rawData, String key) {
    try {
      dynamic decoded = jsonDecode(rawData);

      if (decoded is String) {
        decoded = jsonDecode(decoded);
      }

      if (decoded is List && decoded.isNotEmpty) {
        final first = decoded.first;

        if (first is Map<String, dynamic>) {
          return first[key]?.toString() ?? '';
        }
      }

      if (decoded is Map<String, dynamic>) {
        return decoded[key]?.toString() ?? '';
      }

      return '';
    } catch (e) {
      print("Error: $e");
      return '';
    }
  }

  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

}
