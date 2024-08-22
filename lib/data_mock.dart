import 'dart:convert';
import 'dart:typed_data';

String _mockJson = '''
[
  {"id": "1", "name": "John Doe 1", "email": "john.doe@example.com"},
  {"id": "2", "name": "Jane Doe 2", "email": "jane.doe@example.com"}
]
''';

List<Map<String, dynamic>> _getMockData() {
  return List<Map<String, dynamic>>.from(jsonDecode(_mockJson));
}

Map<String, dynamic>? findUserById(String id) {
  final user = _getMockData().firstWhere((user) => user['id'] == id, orElse: () => {});

  return convertJsonKeys(user);
}

/// This file contains the data mock for the protobuf_dart_poc project.
/// It is used to simulate data for testing and development purposes.
///
/// To convert the data to protobuf JSON format, you can use the `protobuf` library.
/// Here's an example of how to do it:
///

class DataMock {
  // Your data mock implementation goes here
}

///
Map<String, dynamic> convertJsonKeys(Map<String, dynamic> json) {
  Map<String, String> keyMapping = {
    'id': '1',
    'name': '2',
    'email': '3',
    // Adicione mais mapeamentos conforme necessário
  };

  return json.map((key, value) {
    return MapEntry(keyMapping[key] ?? key, value);
  });
}

Uint8List? findUserByIdBuffer(String id) {
  final user = _getMockData().firstWhere((user) => user['id'] == id, orElse: () => {});

  return convertJsonToBuffer(user);
}

/// Convert JSON to a buffer (Uint8List) without involving UserProto directly
Uint8List convertJsonToBuffer(Map<String, dynamic> userJson) {
  // Convert the JSON object with protobuf field numbers into a JSON string
  final jsonString = jsonEncode(userJson);

  // Convert the JSON string into a list of bytes (buffer)
  return utf8.encode(jsonString);
}
