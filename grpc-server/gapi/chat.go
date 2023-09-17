package gapi

import (
	"context"
	"fmt"
	"io"
	"log"
	"time"

	pb "github.com/djsmk123/server/pb"
	"github.com/djsmk123/server/services"
	"github.com/djsmk123/server/token"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// SendMessage handles sending messages.
func (server *Server) SendMessage(stream pb.GrpcServerService_SendMessageServer) error {
	// Extract the user payload from the context.
	payload, ok := stream.Context().Value(payloadHeader).(*token.Payload)
	if !ok {
		return status.Errorf(codes.Internal, "missing required token")
	}

	// Initialize the clients map if it's nil.
	server.mu.Lock()
	if server.clients == nil {
		server.clients = make(map[string]pb.GrpcServerService_SendMessageServer)
	}
	server.clients[payload.Username] = stream
	server.mu.Unlock()

	// Continuously receive and forward messages.
	for {
		message, err := stream.Recv()
		if err == io.EOF {
			// The client has closed the connection.
			break
		}
		if err != nil {
			return status.Errorf(codes.Internal, "Error receiving message: %v", err)
		}

		if message.Message == "Join_room" {
			// Special handling for "Join_room" message.
			// Send a confirmation message back to the sender.
			response := &pb.Message{
				Sender:    "Server", // You can set the sender to "Server" or any other identifier.
				Receiver:  payload.Username,
				Message:   "You have joined the room.",
				CreatedAt: timestamppb.New(time.Now()),
			}
			if err := stream.Send(response); err != nil {
				log.Printf("Error sending confirmation message: %v", err)
			}
			receiverConfirmation := &pb.Message{
				Sender:    "Server", // Sender is the server in this case.
				Receiver:  message.Reciever,
				Message:   fmt.Sprintf("%s has joined the room.", payload.Username),
				CreatedAt: timestamppb.New(time.Now()),
			}
			server.mu.Lock()
			receiver, ok := server.clients[message.Reciever]
			server.mu.Unlock()

			if ok {
				// Send the notification to the receiver.
				if err := receiver.Send(receiverConfirmation); err != nil {
					log.Printf("Error sending notification to %s: %v", message.Reciever, err)
				}
			}

		} else {
			// Normal message handling.
			res, err := services.SendMessage(stream.Context(), message.Message, payload.Username, message.Reciever, &server.dbCollection)
			if err != nil {
				return status.Errorf(codes.Internal, "Error saving message: %v", err)
			}

			// Find the receiver by username.
			server.mu.Lock()
			receiver, ok := server.clients[message.Reciever]
			if !ok {
				// If the receiver or sender is not found, send an error message back to the sender.
				continue
			}

			sender, ok := server.clients[payload.Username]
			server.mu.Unlock()

			if !ok {
				// If the receiver or sender is not found, send an error message back to the sender.
				continue
			}

			// Forward the message to the receiver.
			err = receiver.Send(&pb.Message{
				Sender:    payload.Username,
				Receiver:  message.Reciever,
				Message:   message.Message,
				CreatedAt: timestamppb.New(time.Now()),
				Id:        res.ID.Hex(),
			})
			if err != nil {
				log.Printf("Error sending message to %s: %v", message.Reciever, err)
				continue
			}

			// Send the same message back to the sender as a confirmation.
			err = sender.Send(&pb.Message{
				Sender:    payload.Username,
				Receiver:  message.Reciever,
				Message:   message.Message,
				Id:        res.ID.Hex(),
				CreatedAt: timestamppb.New(time.Now()),
			})
			if err != nil {
				log.Printf("Error sending confirmation message to %s: %v", payload.Username, err)
				continue
			}
		}
	}

	// Remove the sender from the clients map when the client disconnects.
	server.mu.Lock()
	delete(server.clients, payload.Username)
	server.mu.Unlock()
	return nil
}

// GetAllMessage retrieves all messages for a user.
func (server *Server) GetAllMessage(ctx context.Context, req *pb.GetAllMessagesRequest) (*pb.GetAllMessagesResponse, error) {
	// Extract the user payload from the context.
	payload, ok := ctx.Value(payloadHeader).(*token.Payload)
	if !ok {
		return nil, status.Errorf(codes.Internal, "missing required token")
	}

	// Call the GetAllMessage service.
	return services.GetAllMessage(ctx, &server.dbCollection, payload.Username, req.GetReciever())
}
