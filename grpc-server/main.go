package main

import (
	"context"
	"fmt"
	"log"
	"net"

	"github.com/djsmk123/server/api"
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

	// Start the Gin server in a goroutine
	go runGinServer(config)

	// Start the gRPC server
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

	listener, err := net.Listen("tcp", config.RPCSERVERADDRESS)
	if err != nil {
		log.Fatal("Error creating server", err)
	}

	log.Printf("gRPC server listening on %s", config.RPCSERVERADDRESS)
	err = grpcServer.Serve(listener)
	if err != nil {
		log.Fatal("Error serving gRPC server", err)
	}
}

func runGinServer(config utils.ViperConfig) {
	server, err := api.NewServer(config)
	if err != nil {
		log.Fatal("Cannot start Gin server", err)
	}
	err = server.Start(config.GINSERVERADDRESS)
	if err != nil {
		log.Fatal("Cannot start Gin server", err)
	}
	fmt.Printf("Gin server started on %s\n", config.GINSERVERADDRESS)
}
