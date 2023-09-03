package main

import (
	"context"
	"log"

	"net"

	"github.com/djsmk123/server/db"
	"github.com/djsmk123/server/gapi"

	"github.com/djsmk123/server/pb"

	"github.com/djsmk123/server/utils"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func main() {
	config, err := utils.LoadConfiguration(".")
	if err != nil {
		log.Fatal("Failed to load configuration", err)
	}
	clientOptions := options.Client().ApplyURI(config.DBSource)
	ctx := context.TODO()
	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		log.Fatal("Failed to connect to MongoDB", err)

	}
	database := client.Database(config.DBNAME)

	conn := db.MongoCollections{
		Users: database.Collection("users"),
	}
	runGrpcServer(config, conn)

}

func runGrpcServer(config utils.ViperConfig, collection db.MongoCollections) {

	server, err := gapi.NewServer(config, collection)

	if err != nil {
		log.Fatal("Error creating server", err)
	}

	grpcServer := grpc.NewServer(
		grpc.UnaryInterceptor(server.AuthInterceptor),
	)
	pb.RegisterGrpcServerServiceServer(grpcServer, server)

	reflection.Register(grpcServer)

	listner, err := net.Listen("tcp", config.RPCSERVERADDRESS)
	if err != nil {
		log.Fatal("Error creating server", err)
	}

	log.Printf("server listening on %s", config.RPCSERVERADDRESS)
	err = grpcServer.Serve(listner)
	if err != nil {
		log.Fatal("Error serving server", err)
	}
}
