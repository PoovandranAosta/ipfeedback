import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'dart:math';

class SecureEncryptionHelper {

  /// 32 char secret key (KEEP SAME ALWAYS)
  static final Key _key =
  Key.fromUtf8('12345678901234567890123456789012');

  static const _chars =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  /// Generate Random IV (Very Important Security)
  static IV _randomIV() {
    final rand = Random.secure();
    return IV(Uint8List.fromList(
        List.generate(16, (_) => rand.nextInt(256))));
  }

  /// Base62 Encode (AlphaNumeric Only)
  static String _base62Encode(Uint8List bytes) {
    BigInt value = BigInt.parse(
        bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join(),
        radix: 16);

    String result = '';
    while (value > BigInt.zero) {
      result = _chars[(value % BigInt.from(62)).toInt()] + result;
      value = value ~/ BigInt.from(62);
    }
    return result;
  }

  /// Base62 Decode
  static Uint8List _base62Decode(String input) {
    BigInt value = BigInt.zero;

    for (int i = 0; i < input.length; i++) {
      value = value * BigInt.from(62) +
          BigInt.from(_chars.indexOf(input[i]));
    }

    String hex = value.toRadixString(16);
    if (hex.length % 2 != 0) hex = '0$hex';

    return Uint8List.fromList(
      List<int>.generate(
        hex.length ~/ 2,
            (i) => int.parse(
            hex.substring(i * 2, i * 2 + 2),
            radix: 16),
      ),
    );
  }

  /// Encrypt (Returns AlphaNumeric String)
  // static String encrypt(String plainText) {
  //
  //   final iv = _randomIV();
  //
  //   final encrypter =
  //   Encrypter(AES(_key, mode: AESMode.cbc));
  //
  //   final encrypted =
  //   encrypter.encrypt(plainText, iv: iv);
  //
  //   /// combine IV + Cipher
  //   final combined = Uint8List.fromList(
  //       iv.bytes + encrypted.bytes);
  //
  //   return _base62Encode(combined);
  // }
  static String encrypt(String plainText) {
    if (plainText.isEmpty) {
      // Decide what makes sense for your app — return as-is, or encrypt a placeholder.
      return '';
    }

    final iv = _randomIV();
    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    final combined = Uint8List.fromList(iv.bytes + encrypted.bytes);
    return _base62Encode(combined);
  }
  /// Decrypt
  // static String decrypt(String encryptedText) {
  //
  //   final combined = _base62Decode(encryptedText);
  //
  //   /// Split IV and Cipher
  //   final iv = IV(combined.sublist(0, 16));
  //   final cipher = combined.sublist(16);
  //
  //   final encrypter =
  //   Encrypter(AES(_key, mode: AESMode.cbc));
  //
  //   return encrypter.decrypt(
  //       Encrypted(cipher), iv: iv);
  // }

  static String decrypt(String encryptedText) {
    if (encryptedText.isEmpty) return '';

    final combined = _base62Decode(encryptedText);
    final iv = IV(combined.sublist(0, 16));
    final cipher = combined.sublist(16);

    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    return encrypter.decrypt(Encrypted(cipher), iv: iv);
  }
}