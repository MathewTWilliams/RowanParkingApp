package api

import (
	db "RPA/backend/database"

	"github.com/gin-gonic/gin"
)

type API struct {
	router *gin.Engine
	ds     *db.DataStore
}

func (api *API) RouteAll() {
	api.RouteBugs()
	api.RouteCheckIns()
	api.RouteLots()
	api.RouteRatings()
	api.RouteUsers()
	api.RouteVenues()
}

func (api *API) InitAPI(ds *db.DataStore) {
	api.ds = ds
	api.router = gin.Default()
	api.RouteAll()
}

func (api *API) StartListening() {
	api.router.Run(":8080")
}
