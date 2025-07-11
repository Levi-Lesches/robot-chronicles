import "package:shelf/shelf.dart";
import "package:xml/xml.dart";

import "oauth.dart";
import "utils.dart";

const validAwards = {1, 2, 3, 4, 5};

Future<int> parseAwardID(Request request) async {
  final body = await request.readAsString();
  final queryString = Uri.decodeFull(body);
  final query = Uri.splitQueryString(queryString);
  final encryptedCode = query["awardCode"];
  if (encryptedCode == null) throw const FormatException("Missing awardCode");
  final awardCode = decrypt(encryptedCode);
  if (awardCode.isEmpty) throw const FormatException("Missing awardCode");
  final awardID = int.tryParse(awardCode.split("").last);
  if (awardID == null || !validAwards.contains(awardID)) {
    throw FormatException("Invalid awardCode: $awardID");
  }
  return awardID;
}

final items = ["stud", "stud"];

String getLoginXml(SessionID sessionID) {
  final builder = XmlBuilder();
  final loginUrl = OAuth.getLoginUri(sessionID);
  builder.element("result", attributes: {"status": "200"}, nest: () {
    builder.element("message", attributes: {
      "title": "Sign into My Lego Network",
      "text": "We have revived MLN! Please sign in here first",
      "link": loginUrl.toString(),
      "buttonText": "Sign in",
    });
    builder.element("items", nest: () {
      for (final item in items) {
        builder.element("item", attributes: {"thumbnail": item});
      }
    });
  });
  return builder.buildDocument().toXmlString();
}
