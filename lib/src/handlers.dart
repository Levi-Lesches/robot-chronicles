import "dart:io";

import "package:shelf/shelf.dart";

import "award.dart";
import "mln.dart";
import "oauth.dart";
import "utils.dart";

final Map<SessionID, int> pendingRankAwards = {};

Future<Response> loginHandler(Request request) async {
  final query = request.url.queryParameters;
  final sessionID = query["session_id"] as SessionID?;
  final authCode = query["auth_code"];
  if (sessionID == null || authCode == null) {
    return Response.badRequest(body: "Missing session_id or auth_code, please try again");
  }
  final accessToken = await OAuth.login(sessionID, authCode);
  print("Signed user in with access token: $accessToken");
  if (accessToken == null) {
    return Response.internalServerError(body: "Could not sign in");
  }
  final pendingReward = pendingRankAwards[sessionID];
  print("Found pending reward: $pendingReward");
  if (pendingReward != null) await Mln.grantReward(accessToken, pendingReward);
  return Response.found("/");
}

Future<Response> handleAwards(Request request) async {
  final sessionID = request.sessionID;
  if (sessionID == null) return Response.badRequest(body: "Missing session ID");
  final accessToken = OAuth.sessionToTokens[sessionID];
  final int awardID;
  try {
    awardID = await parseAwardID(request);
  } on FormatException catch (error) {
    return Response.badRequest(body: error.message);
  }
  if (accessToken == null) {
    pendingRankAwards[sessionID] = awardID;
    final loginXml = getLoginXml(sessionID);
    final encrypted = encrypt(loginXml);
    return Response.ok(encrypted);
  } else {
    await Mln.grantReward(accessToken, awardID);
    return Response.ok(null);
  }
}

Handler sessionMiddleware(Handler innerHandler) => (request) async {
  final response = await innerHandler(request);
  if (request.sessionID == null) {
    final cookie = Cookie("sessionid", OAuth.getSessionID().value);
    return response.setCookie(cookie);
  }
  return response;
};
