package main

import (
	"github.com/gin-gonic/gin"
)

type API struct {
	router *gin.Engine
	ds     *DataStore
}

func (api *API) SetGetEndPoints() {
	api.router.GET("/api/venues", api.GetVenues)
	api.router.GET("/api/venues/:vid", api.GetVenueById)
	api.router.GET("/api/venues/:vid/lots", api.GetLotsFromVenue)
	api.router.GET("/api/venues/:vid/lots/:lid", api.GetLotFromVenue)
}

func (api *API) SetPostEndPoints() {
	api.router.POST("/api/venues/:vid/lots/:lid/check_in", api.PostCheckIn)
	api.router.POST("/api/venues/:vid/lots/:lid/rating", api.PostLotRating)
	api.router.POST("/api/users/report_bug", api.PostBugReport)
}

func (api *API) InitAPI(ds *DataStore) {
	api.ds = ds
	api.router = gin.Default()
	api.SetGetEndPoints()
	api.SetPostEndPoints()
}

func (api *API) StartListening() {
	api.router.Run("localhost:80")
}
