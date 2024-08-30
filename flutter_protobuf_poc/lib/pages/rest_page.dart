import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_plus/http_plus.dart' as http;

import '../main.dart';
import '../model/user_model.dart';

class RestPage extends StatefulWidget {
  const RestPage({super.key});

  @override
  State<RestPage> createState() => _RestPageState();
}

class _RestPageState extends State<RestPage> {
  bool isLoading = false;
  List<UserModel> users = [];
  String restTime = 'Awaiting test...';
  String restItemLength = '';
  String restRequestTime = '';
  String restDecodeTime = '';
  late final http.HttpPlusClient client;

  @override
  void initState() {
    super.initState();
    client = http.HttpPlusClient(connectionTimeout: const Duration(seconds: 500));
    _testRestEndpoint();
  }

  Future<void> _testRestEndpoint() async {
    setState(() {
      isLoading = true;
    });

    /// Inicia o cronometro

    final stopwatch = Stopwatch()..start();

    final response = await client.get(Uri.parse('$urlBase/rest'));
    final requestTime = stopwatch.elapsedMilliseconds;
    restRequestTime = '${(requestTime * 0.001).toStringAsFixed(3)} s';

    if (response.statusCode == 200) {
      final responseData = response.body;
      final jsonDecoded = jsonDecode(responseData);
      restItemLength = jsonDecoded['data'].length.toStringAsExponential();
      users = jsonDecoded['data'].map<UserModel>((e) => UserModel.fromMap(e)).toList();
      stopwatch.stop();
      setState(() {
        restTime = '${(stopwatch.elapsedMilliseconds * 0.001).toStringAsFixed(3)} s';
        restDecodeTime = '${((stopwatch.elapsedMilliseconds - requestTime) * 0.001).toStringAsFixed(3)} s';
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST Test'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // ElevatedButton(
                //   onPressed: _testRestEndpoint,
                //   child: const Text('Test REST Endpoint'),
                // ),
                // const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Time: $restTime ',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Request Time: $restRequestTime',
                      style: const TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Decode Time: $restDecodeTime',
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
