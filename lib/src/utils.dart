import "dart:io";

import "package:collection/collection.dart";
import "package:shelf/shelf.dart";
import "package:xor_dart/xor_dart.dart";

import "oauth.dart";

const key = "13bv9cyruhnflksjhtf+p1q";

String decrypt(String source) => CipherXor.xorFromBase64(source, key);
String encrypt(String source) => CipherXor.xorToBase64(source, key);

typedef Json = Map<String, dynamic>;

extension RequestUtils on Request {
  List<Cookie> get cookies {
    final header = headers[HttpHeaders.cookieHeader];
    if (header == null) return [];
    final result = <Cookie>[];
    for (final rawCookie in header.split("; ")) {
      final [name, value] = rawCookie.split("=");
      final cookie = Cookie(name, value);
      result.add(cookie);
    }
    return result;
  }

  SessionID? get sessionID {
    final result = cookies.firstWhereOrNull((cookie) => cookie.name == "sessionid")?.value;
    if (result == null) return null;
    return SessionID(result);
  }
}

extension ResponseUtils on Response {
  Response setCookie(Cookie cookie) => change(
    headers: {HttpHeaders.setCookieHeader: cookie.toString()},
  );
}

Future<T?> safelyAsync<T>(Future<T> Function() func) async {
  try {
    return await func();
  // Need to catch all possible errors here
  // ignore: avoid_catches_without_on_clauses
  } catch (error) {
    return null;
  }
}
