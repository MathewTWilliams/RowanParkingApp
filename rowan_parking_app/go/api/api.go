package api

import (
	db "RPA/backend/database"

	"github.com/gin-gonic/gin"
)

type API struct {
	router *gin.Engine
	ds     *db.DataStore
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
	api.router.POST("/api/users/login", api.TryPostUser)
}

func (api *API) SetPutEndPoints() {

}

func (api *API) InitAPI(ds *db.DataStore) {
	api.ds = ds
	api.router = gin.Default()
	api.SetGetEndPoints()
	api.SetPostEndPoints()
	api.SetPutEndPoints()
}

func (api *API) StartListening() {
	api.router.Run(":80")

}
