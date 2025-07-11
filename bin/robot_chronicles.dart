import "package:shelf/shelf.dart";
import "package:shelf/shelf_io.dart" as io;
import "package:shelf_router/shelf_router.dart";
import "package:shelf_static/shelf_static.dart";

import "package:robot_chronicles/robot_chronicles.dart";

void main() async {
  final app = Router();
  app.get("/", (_) => Response.found("/TheRobotChronicles.swf"));
  app.post("/undefined/ExecuteAwardgiver", handleAwards);
  app.get("/api/login", loginHandler);

  final staticHandler = createStaticHandler("static");
  final cascade = Cascade()
    .add(staticHandler)
    .add(app.call);
  final pipeline = const Pipeline()
    .addMiddleware(logRequests())
    .addMiddleware(sessionMiddleware)
    .addHandler(cascade.handler);

  final server = await io.serve(pipeline, "localhost", 7000);
  print("Serving on http://localhost:${server.port}");
}
