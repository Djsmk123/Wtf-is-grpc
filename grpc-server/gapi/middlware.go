package gapi

import (
	"context"
	"strings"

	"github.com/djsmk123/server/token"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

const (
	authorizationHeader = "authorization"
	authorizationBearer = "bearer"
	payloadHeader       = "payload"
)

func (server *Server) UnaryAuthInterceptor(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
	ctx, err := server.AuthInterceptor(info.FullMethod, ctx)
	if err != nil {
		return nil, err
	}
	return handler(ctx, req)
}
func (server *Server) AuthInterceptor(method string, ctx context.Context) (context.Context, error) {
	if methodRequiresAuthentication(method) {
		// Extract the metadata from the context.
		md, ok := metadata.FromIncomingContext(ctx)

		if !ok {
			return nil, status.Errorf(codes.InvalidArgument, "metadata not found")
		}

		// Get the authorization token from metadata if present.
		authTokens := md[authorizationHeader]
		if len(authTokens) == 0 {
			// No token found, but it's optional, so return the unmodified context.
			return ctx, nil
		}

		authHeader := authTokens[0] // Assuming a single token is sent in the header.
		fields := strings.Fields(authHeader)

		if len(fields) < 2 {
			return nil, status.Errorf(codes.Unauthenticated, "invalid auth header format: %v", fields)
		}

		authType := strings.ToLower(fields[0])
		if authType != authorizationBearer {
			return nil, status.Errorf(codes.Unauthenticated, "invalid authorization type: %v", authType)
		}
		accessToken := fields[1]

		payload, err := server.tokenMaker.VerifyToken(accessToken)

		if err != nil {
			if err == token.ErrInvalidToken {
				return nil, status.Errorf(codes.Unauthenticated, "invalid token %v", authType)
			}

			if err == token.ErrExpiredToken {
				return nil, status.Errorf(codes.Unauthenticated, "token %v expired", authType)
			}
		}
		ctx = context.WithValue(ctx, payloadHeader, payload)
	}
	return ctx, nil
}

type customServerStream struct {
	grpc.ServerStream
	ctx context.Context
}

func (css *customServerStream) Context() context.Context {
	return css.ctx
}
func (server *Server) StreamAuthInterceptor(srv interface{}, stream grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
	ctx := stream.Context()
	ctx, err := server.AuthInterceptor(info.FullMethod, ctx)
	if err != nil {
		return err
	}
	newStream := &customServerStream{
		ServerStream: stream,
		ctx:          ctx,
	}
	return handler(srv, newStream)
}
