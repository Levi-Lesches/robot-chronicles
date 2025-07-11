import "dart:convert";

import "package:http/http.dart";

import "oauth.dart";

class Mln {
  static const baseUrl = "http://localhost:8000";
  static const rewardUrl = "$baseUrl/api/robot-chronicles/reward";

  static Future<void> grantReward(AccessToken accessToken, int rewardID) async {
    final body = {
      "api_token": apiToken,
      "access_token": accessToken.value,
      "reward": rewardID,
    };
    final response = await post(
      Uri.parse(rewardUrl),
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      print("Something went wrong: ${response.statusCode} ${response.body}");
    }
  }
}
