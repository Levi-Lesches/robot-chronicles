import "dart:convert";
import "package:xor_encryption/xor_encryption.dart";

final key = "13bv9cyruhnflksjhtf+p1q";

void main() {
  final source = "ckENBUpR";
  final decoded = String.fromCharCodes(base64.decode(source));
  final decrypted = XorCipher().encryptData(decoded, key);
  print(decrypted);
}
