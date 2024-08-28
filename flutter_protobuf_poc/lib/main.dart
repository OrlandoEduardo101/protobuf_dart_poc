import 'dart:convert';

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
  String protobufTime = 'Awaiting test...';
  String protobufItemLength = '';
  String protoRequestbufTime = '';
  String restRequestTime = '';

  Future<void> _testRestEndpoint() async {
    setState(() {
      restTime = 'Runnining...';
    });
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

  Future<void> _testProtobufEndpoint() async {
    setState(() {
      protobufTime = 'Runnining...';
    });
    final stopwatch = Stopwatch()..start();

    final response = await http.get(Uri.parse('http://127.0.0.1:8080/protobuf'));
    protoRequestbufTime = '${stopwatch.elapsedMilliseconds} ms';

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

            ElevatedButton(
              onPressed: () {
                _testRestEndpoint().then((value) => _testProtobufEndpoint());
              },
              child: Text('Run tests'),
            ),
          ],
        ),
      ),
    );
  }
}
