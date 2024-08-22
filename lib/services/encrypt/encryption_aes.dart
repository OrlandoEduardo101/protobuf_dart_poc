import 'dart:developer';

import 'package:encrypt/encrypt.dart';

import 'i_encrypt.dart';
/// Encrypts and decrypts data using the AES encryption algorithm.
class EncryptionAes implements IEncryption {
  final Key key;
  final IV iv;
  late final Encrypter encrypter;

  EncryptionAes({
    required this.key,
    required this.iv,
  }) {
    encrypter = Encrypter(AES(key));
  }
  /// Decrypts the given value using AES encryption.
  @override
  String decrypt(String value) {
    final encrypted = Encrypted.fromBase64(value);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    log('DECRYPTED');
    return decrypted;
  }

  /// Encrypts the given value using AES encryption.
  @override
  String encrypt(String value) {
    final encrypted = encrypter.encrypt(value, iv: iv);
    log('ENCRYPTED');
    return encrypted.base64;
  }
}
