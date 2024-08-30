import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart'; // Dependência para compressão Gzip

import 'proto/response.pb.dart';

final responseMap = {
  'data': List<Map<String, dynamic>>.generate(
      100000,
      (index) => {
            'name': 'Zeze Perrela $index',
            'age': index,
            'email': 'zeze_$index@perrela.com',
          })
};

final responseMapProto = ResponseMap();
List<int> gzipResponse = [];

Future<void> main() async {
  // Armazena os dados de resposta em um objeto protobuf na memória
  compressProto();

  gzipResponse = compressGzip();

  // Inicia o servidor HTTP
  final server = await HttpServer.bind(
    '0.0.0.0',
    3002,
  );

  print('Listening on localhost:${server.port}');

  // Aguarda por requisições
  await for (HttpRequest request in server) {
    if (request.uri.path == '/rest') {
      _handleRestResponse(request);
    } else if (request.uri.path == '/protobuf') {
      _handleProtobufResponse(request);
    } else if (request.uri.path == '/json-gzip') {
      _handleJsonGzipResponse(request); // Novo endpoint para resposta com Gzip
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found')
        ..close();
    }
  }
}

void compressProto() {
  responseMap['data']?.forEach((item) {
    responseMapProto.data.add(ResponseItem()
      ..name = item['name']
      ..age = item['age']
      ..email = item['email']);
  });
}

// Manipula a resposta REST
void _handleRestResponse(HttpRequest request) {
  request.response
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(responseMap))
    ..close();
}

// Manipula a resposta Protobuf
void _handleProtobufResponse(HttpRequest request) {
  final bodyBytes = responseMapProto.writeToBuffer();

  request.response
    ..headers.contentType = ContentType('application', 'octet-stream')
    ..add(bodyBytes)
    ..close();
}

// Manipula a resposta Protobuf com Gzip
void _handleJsonGzipResponse(HttpRequest request) {
  // 4. Retorna os dados GZip no endpoint GET
  request.response
    ..headers.contentType = ContentType('application', 'octet-stream')
    // ..headers.set('Content-Encoding', 'gzip') // Indica que o conteúdo está comprimido
    ..add(gzipResponse)
    ..close();
}

List<int> compressGzip() {
  // 1. Serializa o JSON em uma String
  final jsonString = jsonEncode(responseMap);

  // 2. Codifica a String JSON em UTF-8
  final jsonBytes = utf8.encode(jsonString);

  // 3. Comprime os bytes codificados usando GZip
  final gzipBytes = GZipEncoder().encode(jsonBytes)!;

  return gzipBytes;
}
