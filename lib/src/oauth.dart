import "dart:convert";

import "package:uuid/v4.dart";
import "package:http/http.dart";

import "mln.dart";

// Not checked into the repo
// Must contain: `String apiToken`
import "secrets.dart";
export "secrets.dart";

extension type SessionID(String value) { }
extension type AccessToken(String value) { }

class OAuth {
  // This is a public, non-secret identifier for the OAuth login page.
  // Be sure to include `secrets.dart` for the secret API token.
  static const clientID = "8203164e-4cd0-48ce-833d-2a9cefe3f8b8";

  static const oauthUrl = "${Mln.baseUrl}/oauth";
  static const tokenUrl = "${Mln.baseUrl}/oauth/token";
  static const robotChroniclesBase = "http://localhost:7000";
  static const loginUrl = "$robotChroniclesBase/api/login";

  static SessionID getSessionID() => SessionID(const UuidV4().generate());

  static Uri getLoginUri(SessionID sessionID) {
    final uri = Uri.parse(oauthUrl);
    return uri.replace(queryParameters: {
      "client_id": clientID,
      "session_id": sessionID.value,
      "redirect_url": loginUrl,
    });
  }

  static Map<SessionID, AccessToken> sessionToTokens = {};

  static Future<AccessToken?> login(SessionID sessionID, String authCode) async {
    final body = {
      "api_token": apiToken,
      "auth_code": authCode,
    };
    final response = await post(
      Uri.parse(tokenUrl),
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      // Error logs
      // ignore: avoid_print
      print("Error: ${response.statusCode}, ${response.body}");
      return null;
    }
    final data = jsonDecode(response.body);
    final accessToken = data["access_token"];
    sessionToTokens[sessionID] = accessToken;
    return accessToken;
  }
}
