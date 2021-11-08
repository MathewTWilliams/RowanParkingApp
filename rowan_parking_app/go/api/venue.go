package api

import (
	"RPA/backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteVenues() {
	api.router.GET("/api/venues", api.GetVenues)
	api.router.GET("/api/venues/:vid", api.GetVenueById)
}

func (api *API) GetVenues(c *gin.Context) {
	var venues []models.Venue
	var err error
	venues, err = api.ds.SelectVenues(nil)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}
	c.IndentedJSON(api.GetStatusForContent(len(venues)), venues)
}

func (api *API) GetVenueById(c *gin.Context) {
	var queryResult []models.Venue
	var err error

	vid := c.Param("vid")
	var conditions []string
	conditions = append(conditions, "Where Id = "+vid)
	queryResult, err = api.ds.SelectVenues(conditions)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if len(queryResult) == 0 || len(queryResult) > 1 {
		c.IndentedJSON(http.StatusNoContent, []models.Venue{})
	} else {
		c.IndentedJSON(http.StatusOK, queryResult[0])
	}
}

func (api *API) PostVenue(c *gin.Context) {
	var payload models.PostVenuePayload

	err := c.BindJSON(&payload)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	var newVenue models.Venue
	newVenue.VenueName = payload.VenueName
	newVenue.SetVenueLocation_Coords(payload.Latitude, payload.Longitude)
	newVenue.Timezone = payload.Timezone

	v_id, err := api.ds.InsertVenue(newVenue)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	newVenue.Id = v_id
	c.IndentedJSON(http.StatusCreated, newVenue)
}
