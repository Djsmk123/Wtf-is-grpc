package services

import (
	"context"
	"strings"
	"time"

	"github.com/djsmk123/server/auth"
	"github.com/djsmk123/server/db"
	"github.com/djsmk123/server/db/model"
	"github.com/djsmk123/server/pb"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func SendMessage(ctx context.Context, messsage string, sender string, reciever string, database *db.MongoCollections) (*model.Message, error) {
	//check if reciever is exist or not
	//check if receiver and sender are the same or not
	if strings.EqualFold(sender, reciever) {
		return nil, status.Errorf(codes.InvalidArgument, "sender and receiver must not be the same")
	}
	_, err := auth.GetUser(database.Users, ctx, reciever)
	if err != nil {
		if err == auth.ErrUserNotFound {
			return nil, status.Errorf(codes.NotFound, "user not found")
		}
		return nil, status.Errorf(codes.Internal, "something went wrong")
	}

	newMessage := &model.Message{
		Sender:    sender,
		Receiver:  reciever,
		Message:   messsage,
		CreatedAt: time.Now(),
	}
	result, err := database.Chats.InsertOne(ctx, newMessage)
	insertedID, ok := result.InsertedID.(primitive.ObjectID)
	if !ok {
		return nil, status.Errorf(codes.Internal,"failed to get inserted ID")
	}
	newMessage.ID = insertedID

	if err != nil {
		return nil, err
	}
	return newMessage, nil
}

func GetAllMessage(ctx context.Context, db *db.MongoCollections, sender string, receiver string) (*pb.GetAllMessagesResponse, error) {
	var messages []*pb.Message
	//check if receiver and sender are the same or not
	if strings.EqualFold(sender, receiver) {
		return nil, status.Errorf(codes.InvalidArgument, "sender and receiver must not be the same")
	}
	_, err := auth.GetUser(db.Users, ctx, receiver)
	if err != nil {
		if err == auth.ErrUserNotFound {
			return nil, status.Errorf(codes.NotFound, "user not found")
		}
		return nil, status.Errorf(codes.Internal, "something went wrong")
	}
	filter := bson.M{
		"sender":   sender,
		"receiver": receiver,
	}

	cursor, err := db.Chats.Find(ctx, filter)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "something went wrong while fetching %v", err)
	}
	defer cursor.Close(ctx)
	for cursor.Next(ctx) {
		var message model.Message
		if err := cursor.Decode(&message); err != nil {
			return nil, err
		}
		messages = append(messages, &pb.Message{
			Id:        message.ID.Hex(),
			Receiver:  message.Receiver,
			Sender:    message.Sender,
			Message:   message.Message,
			CreatedAt: timestamppb.New(message.CreatedAt),
		})
	}
	return &pb.GetAllMessagesResponse{
		Messages: messages,
	}, nil

}
