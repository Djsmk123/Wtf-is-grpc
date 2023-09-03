//
//  Generated code. Do not modify.
//  source: rpc_signup.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use signupRequestMessageDescriptor instead')
const SignupRequestMessage$json = {
  '1': 'SignupRequestMessage',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `SignupRequestMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signupRequestMessageDescriptor = $convert.base64Decode(
    'ChRTaWdudXBSZXF1ZXN0TWVzc2FnZRIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWUSGgoIcG'
    'Fzc3dvcmQYAiABKAlSCHBhc3N3b3JkEhIKBG5hbWUYAyABKAlSBG5hbWU=');

@$core.Deprecated('Use signupResponseMessageDescriptor instead')
const SignupResponseMessage$json = {
  '1': 'SignupResponseMessage',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.pb.User', '10': 'user'},
  ],
};

/// Descriptor for `SignupResponseMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signupResponseMessageDescriptor = $convert.base64Decode(
    'ChVTaWdudXBSZXNwb25zZU1lc3NhZ2USHAoEdXNlchgBIAEoCzIILnBiLlVzZXJSBHVzZXI=');

