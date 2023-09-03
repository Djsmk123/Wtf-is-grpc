package db

import (
	"go.mongodb.org/mongo-driver/mongo"
)

type MongoCollections struct {
	Database *mongo.Database
	Users    *mongo.Collection
}
