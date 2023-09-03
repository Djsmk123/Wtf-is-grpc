package auth

import (
	"context"

	"github.com/djsmk123/server/db/model"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

func GetUser(collection *mongo.Collection, context context.Context, username string) (*model.UserModel, error) {
	filter := bson.M{"username": username}
	var user model.UserModel
	err := collection.FindOne(context, filter).Decode(&user)
	if err == mongo.ErrNoDocuments {
		return nil, ErrUserNotFound
	} else if err != nil {
		return nil, err
	}
	return &user, nil
}
