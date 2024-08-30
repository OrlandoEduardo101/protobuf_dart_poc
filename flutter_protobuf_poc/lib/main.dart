import 'dart:convert';
import 'dart:developer';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:http_plus/http_plus.dart' as http;

import 'pages/gzip_page.dart';
import 'pages/proto_page.dart';
import 'pages/rest_page.dart';
import 'proto/response.pb.dart';

String urlBase = 'https://dart.sovis.com.br/';
// String urlBase = 'http://192.168.0.19:3002';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protobuf vs REST',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PerformanceTestPage(),
    );
  }
}

class PerformanceTestPage extends StatefulWidget {
  const PerformanceTestPage({super.key});

  @override
  _PerformanceTestPageState createState() => _PerformanceTestPageState();
}

class _PerformanceTestPageState extends State<PerformanceTestPage> {
  String restTime = 'Awaiting test...';
  String restItemLength = '';
  String restRequestTime = '';
  String restDecodeTime = '';
  String protobufTime = 'Awaiting test...';
  String protobufItemLength = '';
  String protoRequestbufTime = '';
  String protoDecodeTime = '';
  String gzipbufTime = 'Awaiting test...';
  String gzipbufItemLength = '';
  String gzipRequestbufTime = '';
  String gzipDecodeTime = '';
  bool isRunning = false;
  late final http.HttpPlusClient client;

  @override
  void initState() {
    super.initState();
    client = http.HttpPlusClient(connectionTimeout: const Duration(seconds: 500));
  }

  /// Testa o endpoint REST
  Future<void> _testRestEndpoint() async {
    setState(() {
      restTime = 'Runnining...';
    });

    /// Inicia o cronometro

    final stopwatch = Stopwatch()..start();

    final response = await client.get(Uri.parse('$urlBase/rest'));
    final requestTime = stopwatch.elapsedMilliseconds;
    restRequestTime = '${(requestTime * 0.001).toStringAsFixed(3)} s';

    if (response.statusCode == 200) {
      final responseData = response.body;
      final decodedData = responseData.length; // Simulando o processamento
      final jsonDecoded = jsonDecode(responseData);
      restItemLength = jsonDecoded['data'].length.toStringAsExponential();
      stopwatch.stop();
      setState(() {
        restTime = '${(stopwatch.elapsedMilliseconds * 0.001).toStringAsFixed(3)} s';
        restDecodeTime = '${((stopwatch.elapsedMilliseconds - requestTime) * 0.001).toStringAsFixed(3)} s';
      });
    }
  }

  /// Testa o endpoint protobuf
  Future<void> _testProtobufEndpoint() async {
    setState(() {
      protobufTime = 'Runnining...';
    });

    /// Inicia o cronometro
    final stopwatch = Stopwatch()..start();
    try {
      final response = await client.get(Uri.parse('$urlBase/protobuf'));
      final requestTime = stopwatch.elapsedMilliseconds;
      setState(() {
        protoRequestbufTime = '${(requestTime * 0.001).toStringAsFixed(3)} s';
      });
      if (response.statusCode == 200) {
        final responseBytes = response.bodyBytes;
        final responseMapProto = ResponseMap.fromBuffer(responseBytes);

        final decodedData = responseMapProto.data.length.toStringAsExponential(); // Simulando o processamento
        protobufItemLength = decodedData.toString();
        stopwatch.stop();
        setState(() {
          protobufTime = '${(stopwatch.elapsedMilliseconds * 0.001).toStringAsFixed(3)} s';
          protoDecodeTime = '${((stopwatch.elapsedMilliseconds - requestTime) * 0.001).toStringAsFixed(3)} s';
        });
      }
    } catch (e) {
      setState(() {
        protobufTime = 'Erro: $e';
      });
      log(e.toString());
    }
  }

  Future<void> _testGzipEndpoint() async {
    final stopwatch = Stopwatch()..start();
    setState(() {
      gzipbufTime = 'Running...';
    });

    try {
      // Faz a requisição ao endpoint Gzip
      final response = await client.get(Uri.parse('$urlBase/json-gzip'));
      final requestTime = stopwatch.elapsedMilliseconds;
      setState(() {
        gzipRequestbufTime = '${(requestTime * 0.001).toStringAsFixed(3)} s';
      });

      if (response.statusCode == 200) {
        // Descomprime os dados recebidos
        final decodedBytes = GZipDecoder().decodeBytes(response.bodyBytes);

        // Decodifica os bytes descomprimidos em uma String JSON
        final jsonString = utf8.decode(decodedBytes);

        // Converte a String JSON de volta para um objeto Dart
        final jsonDataMap = jsonDecode(jsonString);

        gzipbufItemLength = jsonDataMap['data'].length.toStringAsExponential();
        // Simulando o processamento
        stopwatch.stop();

        setState(() {
          gzipbufTime = '${(stopwatch.elapsedMilliseconds * 0.001).toStringAsFixed(3)} s';
          gzipDecodeTime = '${((stopwatch.elapsedMilliseconds - requestTime) * 0.001).toStringAsFixed(3)} s';
        });
      } else {
        setState(() {
          gzipbufTime = 'Erro: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        gzipbufTime = 'Erro: $e';
      });
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protobuf vs REST Performance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ElevatedButton(
            //   onPressed: _testRestEndpoint,
            //   child: Text('Test REST Endpoint'),
            // ),
            const SizedBox(height: 10),
            Text('REST Request Time: $restRequestTime'),
            Text('JsonDecode to Dart: $restDecodeTime'),
            Text('REST Total Time: $restTime'),
            Text('REST Items: $restItemLength'),
            const SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: _testProtobufEndpoint,
            //   child: Text('Test Protobuf Endpoint'),
            // ),
            const SizedBox(height: 10),
            Text('Protobuf Request Time: $protoRequestbufTime'),
            Text('Protobuf to Dart decode: $protoDecodeTime'),
            Text('Protobuf Total Time: $protobufTime'),
            Text('Protobuf Items: $protobufItemLength'),
            const SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: _testGzipEndpoint,
            //   child: Text('Test Gzip Endpoint'),
            // ),
            const SizedBox(height: 10),
            Text('Gzip Request Time: $gzipRequestbufTime'),
            Text('Gzip to Dart decode: $gzipDecodeTime'),
            Text('Gzip Total Time: $gzipbufTime'),
            Text('Gzip Items: $gzipbufItemLength'),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isRunning
                  ? null
                  : () {
                      setState(() {
                        isRunning = true;
                      });
                      _testRestEndpoint().whenComplete(
                          () => _testProtobufEndpoint().whenComplete(() => _testGzipEndpoint().whenComplete(() {
                                setState(() {
                                  isRunning = false;
                                });
                              })));
                    },
              child: const Text('Run tests'),
            ),
            ElevatedButton(
              onPressed: isRunning
                  ? null
                  : () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RestPage()));
                    },
              child: const Text('Go to REST Test Page'),
            ),
            ElevatedButton(
              onPressed: isRunning
                  ? null
                  : () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProtoPage()));
                    },
              child: const Text('Go to PROTOBUF Test Page'),
            ),
            ElevatedButton(
              onPressed: isRunning
                  ? null
                  : () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const GzipPage()));
                    },
              child: const Text('Go to GZIP Test Page'),
            ),
          ],
        ),
      ),
    );
  }
}
