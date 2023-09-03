package api

import (
	"github.com/djsmk123/server/utils"
	"github.com/gin-gonic/gin"
)

type Server struct {
	config utils.ViperConfig
	router *gin.Engine
}

func NewServer(config utils.ViperConfig) (*Server, error) {

	server := &Server{
		config: config,
	}

	server.setupRouter()

	return server, nil
}

func (server *Server) Start(address string) error {

	return server.router.Run(address)
}
