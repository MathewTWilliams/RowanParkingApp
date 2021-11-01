package api

import (
	"net/http"
	"RPA/backend/models"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteVenues() {
	api.router.GET("/api/venues", api.GetVenues)
	api.router.GET("/api/venues/:vid", api.GetVenueById)
}

func (api *API) GetVenues(c *gin.Context) {
	var venues []models.Venue
	var err error
	venues, err = api.ds.SelectVenues(nil, nil)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if venues == nil {
		c.IndentedJSON(http.StatusNoContent, []models.Venue{})
	}
	c.IndentedJSON(http.StatusOK, venues)
}

func (api *API) GetVenueById(c *gin.Context) {
	var queryResult []models.Venue
	var err error

	vid := c.Param("vid")
	var conditions []string
	conditions = append(conditions, "Where Id = "+vid)
	queryResult, err = api.ds.SelectVenues(nil, conditions)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if len(queryResult) == 0 || len(queryResult) > 1 {
		c.IndentedJSON(http.StatusNoContent, []models.Venue{})
	} else {
		c.IndentedJSON(http.StatusOK, queryResult[0])
	}
}
