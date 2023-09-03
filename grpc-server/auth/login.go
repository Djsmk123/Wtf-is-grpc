package auth

import (
	"context"
	"errors"

	"github.com/djsmk123/server/db/model"
	"github.com/djsmk123/server/utils"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

var ErrUserNotFound = errors.New("user not found")
var ErrInvalidCredentials = errors.New("credentials are not valid")

func LoginUser(username string, password string, collection *mongo.Collection, context context.Context) (*model.UserModel, error) {

	filter := bson.M{"username": username}
	var user model.UserModel
	err := collection.FindOne(context, filter).Decode(&user)
	if err == mongo.ErrNoDocuments {
		return nil, ErrUserNotFound
	} else if err != nil {
		return nil, err
	}
	err = utils.CheckPassword(password, user.Password)
	if err != nil {
		return nil, ErrInvalidCredentials
	}
	return &user, nil
}
