//
//  Generated code. Do not modify.
//  source: proto/response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use responseItemDescriptor instead')
const ResponseItem$json = {
  '1': 'ResponseItem',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'age', '3': 2, '4': 1, '5': 5, '10': 'age'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `ResponseItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseItemDescriptor = $convert.base64Decode(
    'CgxSZXNwb25zZUl0ZW0SEgoEbmFtZRgBIAEoCVIEbmFtZRIQCgNhZ2UYAiABKAVSA2FnZRIUCg'
    'VlbWFpbBgDIAEoCVIFZW1haWw=');

@$core.Deprecated('Use responseMapDescriptor instead')
const ResponseMap$json = {
  '1': 'ResponseMap',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.ResponseItem', '10': 'data'},
  ],
};

/// Descriptor for `ResponseMap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseMapDescriptor = $convert.base64Decode(
    'CgtSZXNwb25zZU1hcBIhCgRkYXRhGAEgAygLMg0uUmVzcG9uc2VJdGVtUgRkYXRh');

