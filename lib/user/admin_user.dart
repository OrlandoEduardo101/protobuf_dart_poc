import 'user.dart';

class AdminUser extends User {
  final String role;

  AdminUser({
    required super.id,
    required super.name,
    required super.email,
    required this.role,
  });
}
