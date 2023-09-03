package auth

import (
	"github.com/djsmk123/server/db/model"
	pb "github.com/djsmk123/server/pb"
)

func ConvertUserObjectToUser(model *model.UserModel) *pb.User {
	return &pb.User{
		Username: model.Username,
		Name:     model.Name,
		Id:       int32(model.ID.Timestamp().Day()),
	}
}
