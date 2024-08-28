import 'dart:convert';
import 'dart:developer';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'proto/response.pb.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Protobuf vs REST',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PerformanceTestPage(),
    );
  }
}

class PerformanceTestPage extends StatefulWidget {
  @override
  _PerformanceTestPageState createState() => _PerformanceTestPageState();
}

class _PerformanceTestPageState extends State<PerformanceTestPage> {
  String restTime = 'Awaiting test...';
  String restItemLength = '';
  String restRequestTime = '';
  String protobufTime = 'Awaiting test...';
  String protobufItemLength = '';
  String protoRequestbufTime = '';
  String gzipbufTime = 'Awaiting test...';
  String gzipbufItemLength = '';
  String gzipRequestbufTime = '';
  bool isRunning = false;

  /// Testa o endpoint REST
  Future<void> _testRestEndpoint() async {
    setState(() {
      restTime = 'Runnining...';
    });

    /// Inicia o cronometro

    final stopwatch = Stopwatch()..start();

    final response = await http.get(Uri.parse('http://127.0.0.1:8080/rest'));
    restRequestTime = '${stopwatch.elapsedMilliseconds} ms';

    if (response.statusCode == 200) {
      final responseData = response.body;
      final decodedData = responseData.length; // Simulando o processamento
      final jsonDecoded = jsonDecode(responseData);
      restItemLength = jsonDecoded['data'].length.toString();
      stopwatch.stop();
      setState(() {
        restTime = '${stopwatch.elapsedMilliseconds} ms';
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
      final response = await http.get(Uri.parse('http://127.0.0.1:8080/protobuf'));
      setState(() {
        protoRequestbufTime = '${stopwatch.elapsedMilliseconds} ms';
      });
      if (response.statusCode == 200) {
        final responseBytes = response.bodyBytes;
        final responseMapProto = ResponseMap.fromBuffer(responseBytes);
        final decodedData = responseMapProto.data.length; // Simulando o processamento
        protobufItemLength = decodedData.toString();
        stopwatch.stop();
        setState(() {
          protobufTime = '${stopwatch.elapsedMilliseconds} ms';
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
      final response = await http.get(Uri.parse('http://127.0.0.1:8080/json-gzip'));
      setState(() {
        gzipRequestbufTime = '${stopwatch.elapsedMilliseconds} ms';
      });

      if (response.statusCode == 200) {
        // Descomprime os dados recebidos
        final decodedBytes = GZipDecoder().decodeBytes(response.bodyBytes);

        // Decodifica os bytes descomprimidos em uma String JSON
        final jsonString = utf8.decode(decodedBytes);

        // Converte a String JSON de volta para um objeto Dart
        final jsonDataMap = jsonDecode(jsonString);

        gzipbufItemLength = jsonDataMap['data'].length.toString();
        // Simulando o processamento
        stopwatch.stop();

        setState(() {
          gzipbufTime = '${stopwatch.elapsedMilliseconds} ms';
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
        title: Text('Protobuf vs REST Performance'),
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
            SizedBox(height: 10),
            Text('REST Request Time: $restRequestTime'),
            Text('REST Total Time: $restTime'),
            Text('REST Items: $restItemLength'),
            SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: _testProtobufEndpoint,
            //   child: Text('Test Protobuf Endpoint'),
            // ),
            SizedBox(height: 10),
            Text('Protobuf Request Time: $protoRequestbufTime'),
            Text('Protobuf Total Time: $protobufTime'),
            Text('Protobuf Items: $protobufItemLength'),
            SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: _testGzipEndpoint,
            //   child: Text('Test Gzip Endpoint'),
            // ),
            SizedBox(height: 10),
            Text('Gzip Request Time: $gzipRequestbufTime'),
            Text('Gzip Total Time: $gzipbufTime'),
            Text('Gzip Items: $gzipbufItemLength'),

            SizedBox(height: 30),
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
              child: Text('Run tests'),
            ),
          ],
        ),
      ),
    );
  }
}
