//
//  Generated code. Do not modify.
//  source: rpc_services.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'empty_request.pb.dart' as $2;
import 'rpc_get_user.pb.dart' as $3;
import 'rpc_login.pb.dart' as $1;
import 'rpc_notifications.pb.dart' as $5;
import 'rpc_signup.pb.dart' as $0;
import 'rpc_users.pb.dart' as $4;

export 'rpc_services.pb.dart';

@$pb.GrpcServiceName('pb.GrpcServerService')
class GrpcServerServiceClient extends $grpc.Client {
  static final _$signUp = $grpc.ClientMethod<$0.SignupRequestMessage, $0.SignupResponseMessage>(
      '/pb.GrpcServerService/SignUp',
      ($0.SignupRequestMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SignupResponseMessage.fromBuffer(value));
  static final _$login = $grpc.ClientMethod<$1.LoginRequestMessage, $1.LoginResponseMessage>(
      '/pb.GrpcServerService/login',
      ($1.LoginRequestMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.LoginResponseMessage.fromBuffer(value));
  static final _$getUser = $grpc.ClientMethod<$2.EmptyRequest, $3.GetUserResponse>(
      '/pb.GrpcServerService/GetUser',
      ($2.EmptyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.GetUserResponse.fromBuffer(value));
  static final _$getUsers = $grpc.ClientMethod<$4.UsersListRequest, $4.ListUserMessage>(
      '/pb.GrpcServerService/GetUsers',
      ($4.UsersListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.ListUserMessage.fromBuffer(value));
  static final _$getNotifications = $grpc.ClientMethod<$2.EmptyRequest, $5.NotificationMessage>(
      '/pb.GrpcServerService/GetNotifications',
      ($2.EmptyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.NotificationMessage.fromBuffer(value));

  GrpcServerServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.SignupResponseMessage> signUp($0.SignupRequestMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$signUp, request, options: options);
  }

  $grpc.ResponseFuture<$1.LoginResponseMessage> login($1.LoginRequestMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$3.GetUserResponse> getUser($2.EmptyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getUser, request, options: options);
  }

  $grpc.ResponseFuture<$4.ListUserMessage> getUsers($4.UsersListRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getUsers, request, options: options);
  }

  $grpc.ResponseStream<$5.NotificationMessage> getNotifications($2.EmptyRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$getNotifications, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('pb.GrpcServerService')
abstract class GrpcServerServiceBase extends $grpc.Service {
  $core.String get $name => 'pb.GrpcServerService';

  GrpcServerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SignupRequestMessage, $0.SignupResponseMessage>(
        'SignUp',
        signUp_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignupRequestMessage.fromBuffer(value),
        ($0.SignupResponseMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.LoginRequestMessage, $1.LoginResponseMessage>(
        'login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.LoginRequestMessage.fromBuffer(value),
        ($1.LoginResponseMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.EmptyRequest, $3.GetUserResponse>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.EmptyRequest.fromBuffer(value),
        ($3.GetUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.UsersListRequest, $4.ListUserMessage>(
        'GetUsers',
        getUsers_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.UsersListRequest.fromBuffer(value),
        ($4.ListUserMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.EmptyRequest, $5.NotificationMessage>(
        'GetNotifications',
        getNotifications_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $2.EmptyRequest.fromBuffer(value),
        ($5.NotificationMessage value) => value.writeToBuffer()));
  }

  $async.Future<$0.SignupResponseMessage> signUp_Pre($grpc.ServiceCall call, $async.Future<$0.SignupRequestMessage> request) async {
    return signUp(call, await request);
  }

  $async.Future<$1.LoginResponseMessage> login_Pre($grpc.ServiceCall call, $async.Future<$1.LoginRequestMessage> request) async {
    return login(call, await request);
  }

  $async.Future<$3.GetUserResponse> getUser_Pre($grpc.ServiceCall call, $async.Future<$2.EmptyRequest> request) async {
    return getUser(call, await request);
  }

  $async.Future<$4.ListUserMessage> getUsers_Pre($grpc.ServiceCall call, $async.Future<$4.UsersListRequest> request) async {
    return getUsers(call, await request);
  }

  $async.Stream<$5.NotificationMessage> getNotifications_Pre($grpc.ServiceCall call, $async.Future<$2.EmptyRequest> request) async* {
    yield* getNotifications(call, await request);
  }

  $async.Future<$0.SignupResponseMessage> signUp($grpc.ServiceCall call, $0.SignupRequestMessage request);
  $async.Future<$1.LoginResponseMessage> login($grpc.ServiceCall call, $1.LoginRequestMessage request);
  $async.Future<$3.GetUserResponse> getUser($grpc.ServiceCall call, $2.EmptyRequest request);
  $async.Future<$4.ListUserMessage> getUsers($grpc.ServiceCall call, $4.UsersListRequest request);
  $async.Stream<$5.NotificationMessage> getNotifications($grpc.ServiceCall call, $2.EmptyRequest request);
}
