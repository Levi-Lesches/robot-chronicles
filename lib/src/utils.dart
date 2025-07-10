import "dart:convert";
import "package:xor_encryption/xor_encryption.dart";

final key = "13bv9cyruhnflksjhtf+p1q";
final cipher = XorCipher();

String decrypt(String source) {
  final decoded = String.fromCharCodes(base64.decode(source));
  final decrypted = cipher.encryptData(decoded, key);
  return decrypted;
}
