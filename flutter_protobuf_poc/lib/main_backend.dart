import 'dart:convert';
import 'dart:io';

import 'proto/response.pb.dart';

/// This file contains the main backend logic for the Flutter Protobuf POC project.
/// It is responsible for handling the backend operations and communication with the server.
/// 
/// The server is responsible for handling two types of requests:
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

  /// Armazena os dados de resposta em um objeto protobuf na memoria
  responseMap['data']?.forEach((item) {
    responseMapProto.data.add(ResponseItem()
      ..name = item['name']
      ..age = item['age']
      ..email = item['email']);
  });

  /// Inicia o servidor HTTP
  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    8080,
  );

  print('Listening on localhost:${server.port}');

  /// Aguarda por requisições
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
/// Manipula a resposta REST
void _handleRestResponse(HttpRequest request) {
  request.response
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(responseMap))
    ..close();
}
/// Manipula a resposta protobuf
void _handleProtobufResponse(HttpRequest request) {
  final bodyBytes = responseMapProto.writeToBuffer();

  request.response
    ..headers.contentType = ContentType('application', 'octet-stream')
    ..add(bodyBytes)
    ..close();
}
