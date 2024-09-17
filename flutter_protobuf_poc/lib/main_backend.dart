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
    } else if (request.uri.path == '/send_location') {
      _handleLocationPost(request);
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

void _handleLocationPost(HttpRequest request) async {
  // 1. Ler o corpo da requisição
  var requestBody = await utf8.decodeStream(request);
  Map<String, dynamic> data = jsonDecode(requestBody);

  // 2. Extrair os dados
  double? latitude = double.tryParse(data['latitude'].toString());
  double? longitude = double.tryParse(data['longitude'].toString());
  DateTime? timestamp = DateTime.tryParse(data['timestamp']);
  addLogToFile(data);

  // 3. Validar os dados (implementar validações mais robustas)
  if (latitude == null || longitude == null) {
    // Retornar um erro 400 (Bad Request)
    request.response
      ..statusCode = HttpStatus.badRequest
      ..close();
    return;
  }

  // 4. Processar os dados (exemplo: salvar em um banco de dados)
  print('Latitude: $latitude, Longitude: $longitude, Timestamp: $timestamp');

  // 5. Retornar uma resposta (exemplo: 200 OK)
  request.response
    ..statusCode = HttpStatus.ok
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

Future<void> addLogToFile(Map<String, dynamic> novoRegistro) async {
  try {
    // Obtém o caminho absoluto do arquivo atual (main.dart)
    // Constrói o caminho para um arquivo ao lado de main.dart

    String path = '';

    final directoryRootPath = Directory.current.path;

    var pathRoot = Platform.isWindows ? '$directoryRootPath\\logs' : '$directoryRootPath/logs';
    final directoryLog = Directory(pathRoot);

    if (!directoryLog.existsSync()) {
      directoryLog.createSync();
    }

    path = Platform.isWindows ? '${directoryLog.path}\\logs_locale.json' : '${directoryLog.path}/logs_locale.json';

    // Verifica se o arquivo existe
    bool arquivoExiste = await File(path).exists();

    // Lê o arquivo existente ou cria um novo com uma lista vazia
    List<Map<String, dynamic>> dados = [];
    if (arquivoExiste) {
      String conteudoJson = await File(path).readAsString();
      dados = List<Map<String, dynamic>>.from(jsonDecode(conteudoJson));
    }

    // Adiciona o novo registro à lista
    dados.add(novoRegistro);

    // Converte a lista de volta para JSON e sobrescreve o arquivo
    String novoJson = jsonEncode(dados); // Adiciona indentação para melhor legibilidade
    await File(path).writeAsString(novoJson);
  } catch (e) {
    print('Erro ao adicionar registro: $e');
  }
}
