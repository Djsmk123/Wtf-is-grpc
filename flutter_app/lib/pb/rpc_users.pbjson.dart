//
//  Generated code. Do not modify.
//  source: rpc_users.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use usersListRequestDescriptor instead')
const UsersListRequest$json = {
  '1': 'UsersListRequest',
  '2': [
    {'1': 'page_number', '3': 1, '4': 1, '5': 5, '10': 'pageNumber'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
  ],
  '8': [
    {'1': '_name'},
  ],
};

/// Descriptor for `UsersListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List usersListRequestDescriptor = $convert.base64Decode(
    'ChBVc2Vyc0xpc3RSZXF1ZXN0Eh8KC3BhZ2VfbnVtYmVyGAEgASgFUgpwYWdlTnVtYmVyEhsKCX'
    'BhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSFwoEbmFtZRgDIAEoCUgAUgRuYW1liAEBQgcKBV9u'
    'YW1l');

@$core.Deprecated('Use listUserMessageDescriptor instead')
const ListUserMessage$json = {
  '1': 'ListUserMessage',
  '2': [
    {'1': 'total_count', '3': 1, '4': 1, '5': 5, '10': 'totalCount'},
    {'1': 'users', '3': 2, '4': 3, '5': 11, '6': '.pb.User', '10': 'users'},
  ],
};

/// Descriptor for `ListUserMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserMessageDescriptor = $convert.base64Decode(
    'Cg9MaXN0VXNlck1lc3NhZ2USHwoLdG90YWxfY291bnQYASABKAVSCnRvdGFsQ291bnQSHgoFdX'
    'NlcnMYAiADKAsyCC5wYi5Vc2VyUgV1c2Vycw==');

