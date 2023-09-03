package auth

import (
	"context"
	"errors"
	"fmt"

	"github.com/djsmk123/server/db/model"
	"github.com/djsmk123/server/utils"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

var ErrUserAlreadyRegistered = errors.New("user already registered")

func RegisterUser(username string, password string, name string, collection *mongo.Collection, context context.Context) (*model.UserModel, error) {

	filter := bson.M{"username": username}
	var existingUser model.UserModel
	err := collection.FindOne(context, filter).Decode(&existingUser)
	if err == mongo.ErrNoDocuments {
		passwordhash, err := utils.HashPassword(password)
		if err != nil {
			return nil, fmt.Errorf("unable to parse password hash: %v", err)
		}
		newUser := model.UserModel{
			Username: username,
			Password: passwordhash,
			Name:     name,
		}
		result, err := collection.InsertOne(context, newUser)
		if err != nil {
			return nil, fmt.Errorf("unable to create user: %v", err)
		}
		newUser.ID = result.InsertedID.(primitive.ObjectID)
		return &newUser, nil
	} else if err != nil {
		return nil, fmt.Errorf("unable to create user:" + err.Error())
	}
	return nil, ErrUserAlreadyRegistered

}
