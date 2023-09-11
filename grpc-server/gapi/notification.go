package gapi

import (
	"fmt"

	"github.com/djsmk123/server/db/model"
	"github.com/djsmk123/server/pb"
	"github.com/djsmk123/server/services"
)

func (server *Server) GetNotifications(req *pb.EmptyRequest, stream pb.GrpcServerService_GetNotificationsServer) error {
	fmt.Println("Notification service started")
	notificationCh := make(chan *model.Notification)
	go services.NotificationNewUser(server.dbCollection.Users, notificationCh)
	fmt.Println("Notification service created")
	for {
		select {
		case <-stream.Context().Done():
			// Client disconnected, close the channel and exit
			close(notificationCh)
			return nil
		case notification := <-notificationCh:

			if err := stream.Send(&pb.NotificationMessage{
				Title:       notification.Title,
				Id:          int32(notification.Id),
				Description: notification.Description,
			}); err != nil {
				return err
			}
		}
	}

}
