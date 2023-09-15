package model

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type Message struct {
	ID        primitive.ObjectID `bson:"_id,omitempty"`
	Sender    string             `bson:"sender"`
	Receiver  string             `bson:"receiver"`
	Message   string             `bson:"message"`
	CreatedAt time.Time          `bson:"created_at"`
}
