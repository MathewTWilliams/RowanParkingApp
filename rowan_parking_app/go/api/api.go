package api

import (
	db "RPA/backend/database"
	"net/http"

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
	api.RouteLotTypes()
}

func (api *API) InitAPI(ds *db.DataStore) {
	api.ds = ds
	api.router = gin.Default()
	api.RouteAll()
}

func (api *API) StartListening() {
	api.router.Run(":8080")
}

func (api *API) GetStatusForContent(length int) int {

	if length == 0 {
		return http.StatusNoContent
	}

	return http.StatusOK
}
