import 'package:protobuf_dart_poc/generated/lib/proto/user.pb.dart';

import 'admin_user.dart';
import 'user_map.dart';

class AdminUserMapper extends UserMapper {
  static AdminUser fromProto(AdminUserProto proto) {
    return AdminUser(
      id: proto.id,
      name: proto.name,
      email: proto.email,
      role: proto.role,
    );
  }

  static AdminUserProto toProto(AdminUser user) {
    return AdminUserProto()
      ..id = user.id
      ..name = user.name
      ..email = user.email
      ..role = user.role;
  }
}
