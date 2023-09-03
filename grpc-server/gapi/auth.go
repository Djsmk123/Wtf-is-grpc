package gapi

import (
	"context"

	"github.com/djsmk123/server/auth"
	pb "github.com/djsmk123/server/pb"
	"github.com/djsmk123/server/token"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/emptypb"
)

func (server *Server) Login(ctx context.Context, req *pb.LoginRequestMessage) (*pb.LoginResponseMessage, error) {
	user, err := auth.LoginUser(req.GetUsername(), req.GetPassword(), server.dbCollection.Users, context.TODO())
	if err != nil {
		if err == auth.ErrUserNotFound {
			return nil, status.Errorf(codes.NotFound, err.Error())
		}
		if err == auth.ErrInvalidCredentials {
			return nil, status.Errorf(codes.Unauthenticated, err.Error())
		}
		return nil, status.Errorf(codes.Internal, err.Error())
	}
	//

	resp := auth.ConvertUserObjectToUser(user)

	token, err := auth.CreateToken(server.tokenMaker, resp.Username, int64(resp.Id), server.config.AccessTokenDuration)
	if err != nil {
		return nil, status.Errorf(codes.Internal, err.Error())
	}

	return &pb.LoginResponseMessage{
		User:        resp,
		AccessToken: token,
	}, nil
}

func (server *Server) SignUp(ctx context.Context, req *pb.SignupRequestMessage) (*pb.SignupResponseMessage, error) {

	user, err := auth.RegisterUser(req.GetUsername(), req.GetPassword(), req.GetName(), server.dbCollection.Users, context.TODO())
	if err != nil {
		if err == auth.ErrUserAlreadyRegistered {
			return nil, status.Errorf(codes.AlreadyExists, err.Error())
		}
		return nil, status.Errorf(codes.Internal, err.Error())
	}
	resp := auth.ConvertUserObjectToUser(user)

	return &pb.SignupResponseMessage{
		User: resp,
	}, nil
}
func (server *Server) GetUser(ctx context.Context, req *emptypb.Empty) (*pb.GetUserResponse, error) {
	payload, ok := ctx.Value(payloadHeader).(*token.Payload)
	if !ok {

		return nil, status.Errorf(codes.Internal, "missing required token")
	}

	user, err := auth.GetUser(server.dbCollection.Users, context.TODO(), payload.Username)

	if err != nil {
		if err == auth.ErrUserNotFound {
			return nil, status.Errorf(codes.NotFound, err.Error())
		}
		return nil, status.Errorf(codes.Internal, err.Error())
	}
	return &pb.GetUserResponse{
		User: auth.ConvertUserObjectToUser(user),
	}, nil

}
