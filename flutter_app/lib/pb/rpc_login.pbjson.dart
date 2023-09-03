//
//  Generated code. Do not modify.
//  source: rpc_login.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use loginRequestMessageDescriptor instead')
const LoginRequestMessage$json = {
  '1': 'LoginRequestMessage',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequestMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestMessageDescriptor = $convert.base64Decode(
    'ChNMb2dpblJlcXVlc3RNZXNzYWdlEhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIaCghwYX'
    'Nzd29yZBgCIAEoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use loginResponseMessageDescriptor instead')
const LoginResponseMessage$json = {
  '1': 'LoginResponseMessage',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.pb.User', '10': 'user'},
    {'1': 'access_token', '3': 2, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `LoginResponseMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseMessageDescriptor = $convert.base64Decode(
    'ChRMb2dpblJlc3BvbnNlTWVzc2FnZRIcCgR1c2VyGAEgASgLMggucGIuVXNlclIEdXNlchIhCg'
    'xhY2Nlc3NfdG9rZW4YAiABKAlSC2FjY2Vzc1Rva2Vu');

