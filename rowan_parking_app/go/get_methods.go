//Author: Matt Williams
//Version: 10/19/2021

package main

import (
	"RPA/backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

//make our methods part of the DataStore struct so we can access db without
// the need for global variables
func (ds *DataStore) GetVenues(c *gin.Context) {
	var err error
	var venues []models.Venue
	venues, err = ds.SelectVenues(nil, nil)
	if err != nil {

		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if venues == nil {

		c.IndentedJSON(http.StatusNoContent, []models.Venue{})
	}
	c.IndentedJSON(http.StatusOK, venues)

}

func (ds *DataStore) GetVenueById(c *gin.Context) {
	var queryResult []models.Venue
	var err error

	vid := c.Param("vid")
	var conditions []string
	conditions = append(conditions, "Where Id = "+vid)
	queryResult, err = ds.SelectVenues(nil, conditions)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if queryResult == nil || len(queryResult) == 0 || len(queryResult) > 1 {
		c.IndentedJSON(http.StatusNoContent, []models.Venue{})
	} else {
		c.IndentedJSON(http.StatusOK, queryResult[0])
	}

}

//need to add it to return the number of spots taken.
func (ds *DataStore) GetLotsFromVenue(c *gin.Context) {
	var lots []models.Lot
	var err error

	vid := c.Param("vid")

	var conditions []string
	conditions = append(conditions, "Where VenueId = "+vid)

	lots, err = ds.SelectLots(nil, conditions)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if lots == nil || len(lots) == 0 {
		c.IndentedJSON(http.StatusNoContent, []models.Lot{})
	} else {
		c.IndentedJSON(http.StatusOK, lots)
	}
}

func (ds *DataStore) GetLotFromVenue(c *gin.Context) {
	var queryResult []models.Lot
	var err error

	vid := c.Param("vid")
	lid := c.Param("lid")

	var conditions []string

	conditions = append(conditions, "Where VenueID = "+vid)
	conditions = append(conditions, " AND LotId = "+lid)

	queryResult, err = ds.SelectLots(nil, conditions)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if queryResult == nil || len(queryResult) == 0 || len(queryResult) > 1 {
		c.IndentedJSON(http.StatusNoContent, models.Lot{})
	} else {
		c.IndentedJSON(http.StatusOK, queryResult[0])
	}
}
