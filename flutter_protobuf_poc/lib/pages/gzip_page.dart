import 'dart:convert';
import 'dart:developer';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:http_plus/http_plus.dart' as http;

import '../main.dart';
import '../model/user_model.dart';

class GzipPage extends StatefulWidget {
  const GzipPage({super.key});

  @override
  State<GzipPage> createState() => _GzipPageState();
}

class _GzipPageState extends State<GzipPage> {
  bool isLoading = false;
  List<UserModel> users = [];
  String gzipbufTime = 'Awaiting test...';
  String gzipbufItemLength = '';
  String gzipRequestbufTime = '';
  String gzipDecodeTime = '';
  late final http.HttpPlusClient client;

  @override
  void initState() {
    super.initState();
    client = http.HttpPlusClient(connectionTimeout: const Duration(seconds: 500));
    _testGzipEndpoint();
  }

  Future<void> _testGzipEndpoint() async {
    final stopwatch = Stopwatch()..start();
    setState(() {
      gzipbufTime = 'Running...';
      isLoading = true;
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
        users = jsonDataMap['data'].map<UserModel>((e) => UserModel.fromMap(e)).toList();
        // Simulando o processamento
        stopwatch.stop();

        setState(() {
          gzipbufTime = '${(stopwatch.elapsedMilliseconds * 0.001).toStringAsFixed(3)} s';
          gzipDecodeTime = '${((stopwatch.elapsedMilliseconds - requestTime) * 0.001).toStringAsFixed(3)} s';
          isLoading = false;
        });
      } else {
        setState(() {
          gzipbufTime = 'Erro: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        gzipbufTime = 'Erro: $e';
        isLoading = false;
      });
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gzip Test'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // ElevatedButton(
                //   onPressed: _testGzipEndpoint,
                //   child: const Text('Test GZIP Endpoint'),
                // ),
                // const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Time: $gzipbufTime ',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Request Time: $gzipRequestbufTime',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Decode Time: $gzipDecodeTime',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        trailing: Text(user.age.toString()),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
