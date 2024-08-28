//
//  Generated code. Do not modify.
//  source: proto/response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ResponseItem extends $pb.GeneratedMessage {
  factory ResponseItem({
    $core.String? name,
    $core.int? age,
    $core.String? email,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (age != null) {
      $result.age = age;
    }
    if (email != null) {
      $result.email = email;
    }
    return $result;
  }
  ResponseItem._() : super();
  factory ResponseItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResponseItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResponseItem', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'age', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResponseItem clone() => ResponseItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResponseItem copyWith(void Function(ResponseItem) updates) => super.copyWith((message) => updates(message as ResponseItem)) as ResponseItem;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseItem create() => ResponseItem._();
  ResponseItem createEmptyInstance() => create();
  static $pb.PbList<ResponseItem> createRepeated() => $pb.PbList<ResponseItem>();
  @$core.pragma('dart2js:noInline')
  static ResponseItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResponseItem>(create);
  static ResponseItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get age => $_getIZ(1);
  @$pb.TagNumber(2)
  set age($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAge() => $_has(1);
  @$pb.TagNumber(2)
  void clearAge() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => clearField(3);
}

class ResponseMap extends $pb.GeneratedMessage {
  factory ResponseMap({
    $core.Iterable<ResponseItem>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  ResponseMap._() : super();
  factory ResponseMap.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResponseMap.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResponseMap', createEmptyInstance: create)
    ..pc<ResponseItem>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: ResponseItem.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResponseMap clone() => ResponseMap()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResponseMap copyWith(void Function(ResponseMap) updates) => super.copyWith((message) => updates(message as ResponseMap)) as ResponseMap;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseMap create() => ResponseMap._();
  ResponseMap createEmptyInstance() => create();
  static $pb.PbList<ResponseMap> createRepeated() => $pb.PbList<ResponseMap>();
  @$core.pragma('dart2js:noInline')
  static ResponseMap getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResponseMap>(create);
  static ResponseMap? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ResponseItem> get data => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
