package auth

import (
	"context"

	"github.com/djsmk123/server/db/model"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func GetUsers(collection *mongo.Collection, context context.Context, page int, pageSize int, query *string, selfUserName string) ([]*model.UserModel, error) {
	// Define filters based on the query parameter (if provided) and exclude the self user
	filter := bson.M{}
	if query != nil {
		filter["name"] = bson.M{"$regex": query, "$options": "i"} // Case-insensitive regex search on 'name' field
	}
	filter["username"] = bson.M{"$ne": selfUserName} // Exclude the self user

	// Set options for pagination
	findOptions := options.Find()
	findOptions.SetLimit(int64(pageSize))
	findOptions.SetSkip(int64((page - 1) * pageSize))

	// Perform the query
	cursor, err := collection.Find(context, filter, findOptions)
	if err != nil {
		return nil, err
	}
	defer cursor.Close(context)

	var users []*model.UserModel
	for cursor.Next(context) {
		var user model.UserModel
		if err := cursor.Decode(&user); err != nil {
			return nil, err
		}
		users = append(users, &user)
	}

	if err := cursor.Err(); err != nil {
		return nil, err
	}

	return users, nil
}
