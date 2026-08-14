import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../config/config.dart';

class ApiService {
  /* Return List From API */
  Future<List<T>> apiCall<T>({
    required String url,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${Config.baseUrl}$url"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint("API ERROR CODE => ${response.statusCode}");
        return [];
      }

      final rawData = response.body.trim();

      /// 🔹 Step 1: XML (.asmx) response
      if (rawData.startsWith('<')) {
        final document = xml.XmlDocument.parse(rawData);

        final stringNode = document.findAllElements('string');
        if (stringNode.isEmpty) return [];

        final jsonText = stringNode.first.text.trim();
        final decoded = jsonDecode(jsonText);

        if (decoded is List && decoded.isNotEmpty) {
          return decoded
              .map((e) => fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      }

      /// 🔹 Step 2: JSON response
      final decoded = jsonDecode(rawData);

      /// Case: List directly
      if (decoded is List) {
        return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }

      /// Case: Map with 'd'
      if (decoded is Map<String, dynamic>) {
        final d = decoded['d'];
        if (d is String) {
          final list = jsonDecode(d);
          if (list is List) {
            return list
                .map((e) => fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
      }

      return [];
    } catch (e) {
      debugPrint("HTTP API ERROR => $e");
      return [];
    }
  }

  /* Return String Directly */
  Future<String> apiCallString({
    required String url,
    required Map<String, dynamic>? body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${Config.baseUrl}$url"),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body?.map((k, v) => MapEntry(k, v.toString())),
      );

      if (response.statusCode != 200) {
        throw Exception("Server error : ${response.statusCode}");
      }

      final rawData = response.body.trim();

      /// 🔹 Case 1: .asmx XML response
      if (rawData.startsWith('<')) {
        final document = xml.XmlDocument.parse(rawData);

        final nodes = document.findAllElements('string');
        if (nodes.isEmpty) return '';

        final jsonText = nodes.first.text.trim();
        final decoded = jsonDecode(jsonText);



        if (decoded is List &&
            decoded.isNotEmpty &&
            decoded.first is Map &&
            decoded.first.containsKey('status')) {
          return decoded.first['status'].toString();
        }

        if (decoded is List &&
            decoded.isNotEmpty &&
            decoded.first is Map &&
            decoded.first.containsKey('otp')) {
          return decoded.first['otp'].toString();
        }

        if (decoded is List &&
            decoded.isNotEmpty &&
            decoded.first is Map &&
            decoded.first.containsKey('stat')) {
          return decoded.first['stat'].toString();
        }

        return jsonText;
      }

      /// 🔹 Case 2: JSON response
      final decoded = jsonDecode(rawData);

      if (decoded is Map && decoded.containsKey('d')) {
        final dString = decoded['d'];

        if (dString is String) {
          final inner = jsonDecode(dString);

          if (inner is List &&
              inner.isNotEmpty &&
              inner.first is Map &&
              inner.first.containsKey('status')) {
            return inner.first['status'].toString();
          }

          if (inner is List &&
              inner.isNotEmpty &&
              inner.first is Map &&
              inner.first.containsKey('otp')) {
            return inner.first['otp'].toString();
          }

          if (inner is List &&
              inner.isNotEmpty &&
              inner.first is Map &&
              inner.first.containsKey('stat')) {
            return inner.first['stat'].toString();
          }


          return dString;
        }
      }

      return rawData;
    } catch (e) {
      throw Exception("HTTP error: $e");
    }
  }

  Future<String> apiCallString2({
    required String url,
    required Map<String, dynamic>? body,
  }) async {
    try {
      // print("${Config.baseUrl2}$url");
      final response = await http.post(
        Uri.parse("${Config.baseUrl2}$url"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception("Server error : ${response.statusCode}");
      }

      final rawData = response.body.trim();

      /// 🔹 Case 1: .asmx XML response
      if (rawData.startsWith('<')) {
        final document = xml.XmlDocument.parse(rawData);

        final nodes = document.findAllElements('string');
        if (nodes.isEmpty) return '';

        final jsonText = nodes.first.text.trim();
        final decoded = jsonDecode(jsonText);



        if (decoded is List &&
            decoded.isNotEmpty &&
            decoded.first is Map &&
            decoded.first.containsKey('status')) {
          return decoded.first['status'].toString();
        }

        if (decoded is List &&
            decoded.isNotEmpty &&
            decoded.first is Map &&
            decoded.first.containsKey('otp')) {
          return decoded.first['otp'].toString();
        }

        if (decoded is List &&
            decoded.isNotEmpty &&
            decoded.first is Map &&
            decoded.first.containsKey('stat')) {
          return decoded.first['stat'].toString();
        }

        return jsonText;
      }

      /// 🔹 Case 2: JSON response
      final decoded = jsonDecode(rawData);

      if (decoded is Map && decoded.containsKey('d')) {
        final dString = decoded['d'];

        if (dString is String) {
          final inner = jsonDecode(dString);

          if (inner is List &&
              inner.isNotEmpty &&
              inner.first is Map &&
              inner.first.containsKey('status')) {
            return inner.first['status'].toString();
          }

          if (inner is List &&
              inner.isNotEmpty &&
              inner.first is Map &&
              inner.first.containsKey('otp')) {
            return inner.first['otp'].toString();
          }

          if (inner is List &&
              inner.isNotEmpty &&
              inner.first is Map &&
              inner.first.containsKey('stat')) {
            return inner.first['stat'].toString();
          }


          return dString;
        }
      }

      return rawData;
    } catch (e) {
      throw Exception("HTTP error: $e");
    }
  }


}
