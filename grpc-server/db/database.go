package db

import (
	"go.mongodb.org/mongo-driver/mongo"
)

type MongoCollections struct {
	Users *mongo.Collection
}
