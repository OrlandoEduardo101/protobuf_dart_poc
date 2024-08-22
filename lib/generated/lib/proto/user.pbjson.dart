//
//  Generated code. Do not modify.
//  source: lib/proto/user.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userProtoDescriptor instead')
const UserProto$json = {
  '1': 'UserProto',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `UserProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userProtoDescriptor = $convert.base64Decode(
    'CglVc2VyUHJvdG8SDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSFAoFZW1haW'
    'wYAyABKAlSBWVtYWls');

@$core.Deprecated('Use adminUserProtoDescriptor instead')
const AdminUserProto$json = {
  '1': 'AdminUserProto',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'role', '3': 4, '4': 1, '5': 9, '10': 'role'},
  ],
};

/// Descriptor for `AdminUserProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminUserProtoDescriptor = $convert.base64Decode(
    'Cg5BZG1pblVzZXJQcm90bxIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIUCg'
    'VlbWFpbBgDIAEoCVIFZW1haWwSEgoEcm9sZRgEIAEoCVIEcm9sZQ==');

