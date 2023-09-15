// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             v4.24.1
// source: rpc_services.proto

package pb

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// GrpcServerServiceClient is the client API for GrpcServerService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type GrpcServerServiceClient interface {
	SignUp(ctx context.Context, in *SignupRequestMessage, opts ...grpc.CallOption) (*SignupResponseMessage, error)
	Login(ctx context.Context, in *LoginRequestMessage, opts ...grpc.CallOption) (*LoginResponseMessage, error)
	GetUser(ctx context.Context, in *EmptyRequest, opts ...grpc.CallOption) (*GetUserResponse, error)
	GetUsers(ctx context.Context, in *UsersListRequest, opts ...grpc.CallOption) (*ListUserMessage, error)
	GetNotifications(ctx context.Context, in *EmptyRequest, opts ...grpc.CallOption) (GrpcServerService_GetNotificationsClient, error)
	SendMessage(ctx context.Context, opts ...grpc.CallOption) (GrpcServerService_SendMessageClient, error)
	GetAllMessage(ctx context.Context, in *GetAllMessagesRequest, opts ...grpc.CallOption) (*GetAllMessagesResponse, error)
}

type grpcServerServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewGrpcServerServiceClient(cc grpc.ClientConnInterface) GrpcServerServiceClient {
	return &grpcServerServiceClient{cc}
}

func (c *grpcServerServiceClient) SignUp(ctx context.Context, in *SignupRequestMessage, opts ...grpc.CallOption) (*SignupResponseMessage, error) {
	out := new(SignupResponseMessage)
	err := c.cc.Invoke(ctx, "/pb.GrpcServerService/SignUp", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *grpcServerServiceClient) Login(ctx context.Context, in *LoginRequestMessage, opts ...grpc.CallOption) (*LoginResponseMessage, error) {
	out := new(LoginResponseMessage)
	err := c.cc.Invoke(ctx, "/pb.GrpcServerService/login", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *grpcServerServiceClient) GetUser(ctx context.Context, in *EmptyRequest, opts ...grpc.CallOption) (*GetUserResponse, error) {
	out := new(GetUserResponse)
	err := c.cc.Invoke(ctx, "/pb.GrpcServerService/GetUser", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *grpcServerServiceClient) GetUsers(ctx context.Context, in *UsersListRequest, opts ...grpc.CallOption) (*ListUserMessage, error) {
	out := new(ListUserMessage)
	err := c.cc.Invoke(ctx, "/pb.GrpcServerService/GetUsers", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *grpcServerServiceClient) GetNotifications(ctx context.Context, in *EmptyRequest, opts ...grpc.CallOption) (GrpcServerService_GetNotificationsClient, error) {
	stream, err := c.cc.NewStream(ctx, &GrpcServerService_ServiceDesc.Streams[0], "/pb.GrpcServerService/GetNotifications", opts...)
	if err != nil {
		return nil, err
	}
	x := &grpcServerServiceGetNotificationsClient{stream}
	if err := x.ClientStream.SendMsg(in); err != nil {
		return nil, err
	}
	if err := x.ClientStream.CloseSend(); err != nil {
		return nil, err
	}
	return x, nil
}

type GrpcServerService_GetNotificationsClient interface {
	Recv() (*NotificationMessage, error)
	grpc.ClientStream
}

type grpcServerServiceGetNotificationsClient struct {
	grpc.ClientStream
}

func (x *grpcServerServiceGetNotificationsClient) Recv() (*NotificationMessage, error) {
	m := new(NotificationMessage)
	if err := x.ClientStream.RecvMsg(m); err != nil {
		return nil, err
	}
	return m, nil
}

func (c *grpcServerServiceClient) SendMessage(ctx context.Context, opts ...grpc.CallOption) (GrpcServerService_SendMessageClient, error) {
	stream, err := c.cc.NewStream(ctx, &GrpcServerService_ServiceDesc.Streams[1], "/pb.GrpcServerService/SendMessage", opts...)
	if err != nil {
		return nil, err
	}
	x := &grpcServerServiceSendMessageClient{stream}
	return x, nil
}

type GrpcServerService_SendMessageClient interface {
	Send(*SendMessageRequest) error
	Recv() (*Message, error)
	grpc.ClientStream
}

type grpcServerServiceSendMessageClient struct {
	grpc.ClientStream
}

func (x *grpcServerServiceSendMessageClient) Send(m *SendMessageRequest) error {
	return x.ClientStream.SendMsg(m)
}

func (x *grpcServerServiceSendMessageClient) Recv() (*Message, error) {
	m := new(Message)
	if err := x.ClientStream.RecvMsg(m); err != nil {
		return nil, err
	}
	return m, nil
}

func (c *grpcServerServiceClient) GetAllMessage(ctx context.Context, in *GetAllMessagesRequest, opts ...grpc.CallOption) (*GetAllMessagesResponse, error) {
	out := new(GetAllMessagesResponse)
	err := c.cc.Invoke(ctx, "/pb.GrpcServerService/GetAllMessage", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// GrpcServerServiceServer is the server API for GrpcServerService service.
// All implementations must embed UnimplementedGrpcServerServiceServer
// for forward compatibility
type GrpcServerServiceServer interface {
	SignUp(context.Context, *SignupRequestMessage) (*SignupResponseMessage, error)
	Login(context.Context, *LoginRequestMessage) (*LoginResponseMessage, error)
	GetUser(context.Context, *EmptyRequest) (*GetUserResponse, error)
	GetUsers(context.Context, *UsersListRequest) (*ListUserMessage, error)
	GetNotifications(*EmptyRequest, GrpcServerService_GetNotificationsServer) error
	SendMessage(GrpcServerService_SendMessageServer) error
	GetAllMessage(context.Context, *GetAllMessagesRequest) (*GetAllMessagesResponse, error)
	mustEmbedUnimplementedGrpcServerServiceServer()
}

// UnimplementedGrpcServerServiceServer must be embedded to have forward compatible implementations.
type UnimplementedGrpcServerServiceServer struct {
}

func (UnimplementedGrpcServerServiceServer) SignUp(context.Context, *SignupRequestMessage) (*SignupResponseMessage, error) {
	return nil, status.Errorf(codes.Unimplemented, "method SignUp not implemented")
}
func (UnimplementedGrpcServerServiceServer) Login(context.Context, *LoginRequestMessage) (*LoginResponseMessage, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Login not implemented")
}
func (UnimplementedGrpcServerServiceServer) GetUser(context.Context, *EmptyRequest) (*GetUserResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetUser not implemented")
}
func (UnimplementedGrpcServerServiceServer) GetUsers(context.Context, *UsersListRequest) (*ListUserMessage, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetUsers not implemented")
}
func (UnimplementedGrpcServerServiceServer) GetNotifications(*EmptyRequest, GrpcServerService_GetNotificationsServer) error {
	return status.Errorf(codes.Unimplemented, "method GetNotifications not implemented")
}
func (UnimplementedGrpcServerServiceServer) SendMessage(GrpcServerService_SendMessageServer) error {
	return status.Errorf(codes.Unimplemented, "method SendMessage not implemented")
}
func (UnimplementedGrpcServerServiceServer) GetAllMessage(context.Context, *GetAllMessagesRequest) (*GetAllMessagesResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method GetAllMessage not implemented")
}
func (UnimplementedGrpcServerServiceServer) mustEmbedUnimplementedGrpcServerServiceServer() {}

// UnsafeGrpcServerServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to GrpcServerServiceServer will
// result in compilation errors.
type UnsafeGrpcServerServiceServer interface {
	mustEmbedUnimplementedGrpcServerServiceServer()
}

func RegisterGrpcServerServiceServer(s grpc.ServiceRegistrar, srv GrpcServerServiceServer) {
	s.RegisterService(&GrpcServerService_ServiceDesc, srv)
}

func _GrpcServerService_SignUp_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(SignupRequestMessage)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(GrpcServerServiceServer).SignUp(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/pb.GrpcServerService/SignUp",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(GrpcServerServiceServer).SignUp(ctx, req.(*SignupRequestMessage))
	}
	return interceptor(ctx, in, info, handler)
}

func _GrpcServerService_Login_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(LoginRequestMessage)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(GrpcServerServiceServer).Login(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/pb.GrpcServerService/login",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(GrpcServerServiceServer).Login(ctx, req.(*LoginRequestMessage))
	}
	return interceptor(ctx, in, info, handler)
}

func _GrpcServerService_GetUser_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(EmptyRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(GrpcServerServiceServer).GetUser(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/pb.GrpcServerService/GetUser",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(GrpcServerServiceServer).GetUser(ctx, req.(*EmptyRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _GrpcServerService_GetUsers_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(UsersListRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(GrpcServerServiceServer).GetUsers(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/pb.GrpcServerService/GetUsers",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(GrpcServerServiceServer).GetUsers(ctx, req.(*UsersListRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _GrpcServerService_GetNotifications_Handler(srv interface{}, stream grpc.ServerStream) error {
	m := new(EmptyRequest)
	if err := stream.RecvMsg(m); err != nil {
		return err
	}
	return srv.(GrpcServerServiceServer).GetNotifications(m, &grpcServerServiceGetNotificationsServer{stream})
}

type GrpcServerService_GetNotificationsServer interface {
	Send(*NotificationMessage) error
	grpc.ServerStream
}

type grpcServerServiceGetNotificationsServer struct {
	grpc.ServerStream
}

func (x *grpcServerServiceGetNotificationsServer) Send(m *NotificationMessage) error {
	return x.ServerStream.SendMsg(m)
}

func _GrpcServerService_SendMessage_Handler(srv interface{}, stream grpc.ServerStream) error {
	return srv.(GrpcServerServiceServer).SendMessage(&grpcServerServiceSendMessageServer{stream})
}

type GrpcServerService_SendMessageServer interface {
	Send(*Message) error
	Recv() (*SendMessageRequest, error)
	grpc.ServerStream
}

type grpcServerServiceSendMessageServer struct {
	grpc.ServerStream
}

func (x *grpcServerServiceSendMessageServer) Send(m *Message) error {
	return x.ServerStream.SendMsg(m)
}

func (x *grpcServerServiceSendMessageServer) Recv() (*SendMessageRequest, error) {
	m := new(SendMessageRequest)
	if err := x.ServerStream.RecvMsg(m); err != nil {
		return nil, err
	}
	return m, nil
}

func _GrpcServerService_GetAllMessage_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(GetAllMessagesRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(GrpcServerServiceServer).GetAllMessage(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/pb.GrpcServerService/GetAllMessage",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(GrpcServerServiceServer).GetAllMessage(ctx, req.(*GetAllMessagesRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// GrpcServerService_ServiceDesc is the grpc.ServiceDesc for GrpcServerService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var GrpcServerService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "pb.GrpcServerService",
	HandlerType: (*GrpcServerServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "SignUp",
			Handler:    _GrpcServerService_SignUp_Handler,
		},
		{
			MethodName: "login",
			Handler:    _GrpcServerService_Login_Handler,
		},
		{
			MethodName: "GetUser",
			Handler:    _GrpcServerService_GetUser_Handler,
		},
		{
			MethodName: "GetUsers",
			Handler:    _GrpcServerService_GetUsers_Handler,
		},
		{
			MethodName: "GetAllMessage",
			Handler:    _GrpcServerService_GetAllMessage_Handler,
		},
	},
	Streams: []grpc.StreamDesc{
		{
			StreamName:    "GetNotifications",
			Handler:       _GrpcServerService_GetNotifications_Handler,
			ServerStreams: true,
		},
		{
			StreamName:    "SendMessage",
			Handler:       _GrpcServerService_SendMessage_Handler,
			ServerStreams: true,
			ClientStreams: true,
		},
	},
	Metadata: "rpc_services.proto",
}
