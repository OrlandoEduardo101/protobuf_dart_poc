import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http_plus/http_plus.dart' as http;

import '../main.dart';
import '../proto/response.pb.dart';

class ProtoPage extends StatefulWidget {
  const ProtoPage({super.key});

  @override
  State<ProtoPage> createState() => _ProtoPageState();
}

class _ProtoPageState extends State<ProtoPage> {
  bool isLoading = false;
  List<ResponseItem> users = [];
  String protobufTime = 'Awaiting test...';
  String protobufItemLength = '';
  String protoRequestbufTime = '';
  String protoDecodeTime = '';
  late final http.HttpPlusClient client;

  @override
  void initState() {
    super.initState();
    client = http.HttpPlusClient(connectionTimeout: const Duration(seconds: 500));
    _testProtobufEndpoint();
  }

  /// Testa o endpoint protobuf
  Future<void> _testProtobufEndpoint() async {
    setState(() {
      protobufTime = 'Runnining...';
      isLoading = true;
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
        users = responseMapProto.data;
        protobufItemLength = decodedData.toString();
        stopwatch.stop();
        setState(() {
          protobufTime = '${(stopwatch.elapsedMilliseconds * 0.001).toStringAsFixed(3)} s';
          protoDecodeTime = '${((stopwatch.elapsedMilliseconds - requestTime) * 0.001).toStringAsFixed(3)} s';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        protobufTime = 'Erro: $e';
        isLoading = false;
      });
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROTO Test'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // ElevatedButton(
                //   onPressed: _testProtobufEndpoint,
                //   child: const Text('Test PROTOBUF Endpoint'),
                // ),
                // const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Time: $protobufTime ',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Request Time: $protoRequestbufTime',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Decode Time: $protoDecodeTime',
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
