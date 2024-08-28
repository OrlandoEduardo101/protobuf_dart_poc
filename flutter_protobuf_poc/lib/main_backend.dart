import 'dart:convert';
import 'dart:io';

import 'proto/response.pb.dart';

final responseMap = {
  'data': List<Map<String, dynamic>>.generate(
      1000000,
      (index) => {
            'name': 'Zeze Perrela $index',
            'age': index,
            'email': 'zeze_$index@perrela.com',
          })
};
final responseMapProto = ResponseMap();

Future<void> main() async {
  responseMap['data']?.forEach((item) {
    responseMapProto.data.add(ResponseItem()
      ..name = item['name']
      ..age = item['age']
      ..email = item['email']);
  });

  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    8080,
  );

  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    if (request.uri.path == '/rest') {
      _handleRestResponse(request);
    } else if (request.uri.path == '/protobuf') {
      _handleProtobufResponse(request);
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found')
        ..close();
    }
  }
}

void _handleRestResponse(HttpRequest request) {
  request.response
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(responseMap))
    ..close();
}

void _handleProtobufResponse(HttpRequest request) {
  final bodyBytes = responseMapProto.writeToBuffer();

  request.response
    ..headers.contentType = ContentType('application', 'octet-stream')
    ..add(bodyBytes)
    ..close();
}
