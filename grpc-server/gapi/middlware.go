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

func (server *Server) AuthInterceptor(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
	// Check if the service name is in a list of services that require authentication.
	// Replace "Service1" and "Service2" with the actual service names you want to authenticate.
	//requiredServices := []string{"pb.GrpcServerService"}

	//serviceName := info.FullMethod

	if methodRequiresAuthentication(info.FullMethod) {
		// Extract the metadata from the context.
		md, ok := metadata.FromIncomingContext(ctx)

		if !ok {
			return nil, status.Errorf(codes.InvalidArgument, "metadata not found")
		}

		// Get the authorization token from metadata.
		authTokens := md[authorizationHeader]
		if len(authTokens) == 0 {
			return nil, status.Errorf(codes.Unauthenticated, "authorization token is missing")
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
		return handler(ctx, req)
	}

	return handler(ctx, req)
}
