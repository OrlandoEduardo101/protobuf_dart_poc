import 'dart:convert';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'encrypt/i_encrypt.dart';

class DatabaseService {
  late final Database _db;
  final IEncryption encryption;

  DatabaseService(this.encryption);

  /// Initializes the database and creates the users table if it doesn't exist.
  void initialize() {
    final dbPath = p.join('user_cache.db');
    _db = sqlite3.open(dbPath);

    _db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        proto TEXT
      )
    ''');
  }

  /// Saves a UserProto object to the database.
  void saveUser(Uint8List userProtoBuffer, String id) {
    final stmt = _db.prepare('INSERT OR REPLACE INTO users (id, proto) VALUES (?, ?)');
    
    // Encrypt the userProtoBuffer before saving it to the database
    final encry = encryption.encrypt(jsonEncode(userProtoBuffer));
    stmt.execute([id, encry]);
    stmt.dispose();
  }

  /// Retrieves a UserProto object from the database by ID.
  Uint8List? getUser(String id) {
    final stmt = _db.prepare('SELECT proto FROM users WHERE id = ?');
    final result = stmt.select([id]);
    if (result.isNotEmpty) {
      final encry = result.first['proto'] as String;

      /// Decrypt the userProtoBuffer before returning it
      final decry = encryption.decrypt(encry);
      final intList = List<int>.from(jsonDecode(decry));
      final protoBuffer = Uint8List.fromList(intList);
      return protoBuffer;
    } else {
      return null; // Returns null if the user is not found
    }
  }

  /// Closes the database connection.
  void close() {
    _db.dispose();
  }
}
