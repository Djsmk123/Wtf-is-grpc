package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func (server *Server) setupRouter() {
	router := gin.Default()

	if server.config.GINMODE == gin.ReleaseMode {
		gin.SetMode(gin.ReleaseMode)
	}
	router.LoadHTMLGlob("static/*.html")
	router.GET("/", func(ctx *gin.Context) {
		ctx.HTML(http.StatusOK, "index.html", nil)
	})

	server.router = router

}
