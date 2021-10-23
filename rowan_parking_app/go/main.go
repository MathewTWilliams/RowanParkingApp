//Author: Matt Williams
//Version: 10/19/2021
//contains the main function for our go backend.

package main

import (
	"github.com/gin-gonic/gin"
)

func SetGetEndPoints(router *gin.Engine, db *DataStore) {
	router.GET("/api/venues", db.GetVenues)
	router.GET("/api/venues/:vid", db.GetVenueById)
	router.GET("/api/venues/:vid/lots", db.GetLotsFromVenue)
	router.GET("/api/venues/:vid/lots/:lid", db.GetLotFromVenue)
}

func SetPostEndPoints(router *gin.Engine, db *DataStore) {
	router.POST("/api/venues/:vid/lots/:lid/check_in", db.PostCheckIn)
	router.POST("/api/venues/:vid/lots/:lid/rating", db.PostLotRating)
	router.POST("/api/users/report_bug", db.PostBugReport)
}

func main() {
	var database DataStore
	database.InitDB()

	router := gin.Default()
	SetGetEndPoints(router, &database)
	SetPostEndPoints(router, &database)

	router.Run("localhost:80")

}
