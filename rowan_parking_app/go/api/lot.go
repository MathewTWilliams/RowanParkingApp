package api

import (
	"RPA/backend/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteLots() {
	api.router.GET("/api/venues/:vid/lots", api.GetLotsFromVenue)
	api.router.GET("/api/venues/:vid/lots/:lid", api.GetLotFromVenue)
}

func (api *API) GetLotsFromVenue(c *gin.Context) {
	var lots []models.Lot
	var err error

	vid := c.Param("vid")

	var conditions []string
	conditions = append(conditions, "Where VenueId = "+vid)

	lots, err = api.ds.SelectLots(conditions)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if len(lots) == 0 {
		c.IndentedJSON(http.StatusNoContent, []models.Lot{})
	} else {
		var responses []models.GetLotResponse
		for _, lot := range lots {
			spots, err := api.ds.CountSpotsTaken(vid, strconv.FormatInt(lot.Id, 10))
			if err != nil {
				c.IndentedJSON(http.StatusInternalServerError, err)
				return
			}
			responses = append(responses, models.GetLotResponse{SpotsTaken: spots, LotInfo: lot})
		}

		c.IndentedJSON(http.StatusOK, responses)
	}
}

func (api *API) GetLotFromVenue(c *gin.Context) {
	var queryResult []models.Lot
	var err error

	vid := c.Param("vid")
	lid := c.Param("lid")

	var conditions []string

	conditions = append(conditions, "Where VenueID = "+vid)
	conditions = append(conditions, " AND Id = "+lid)

	queryResult, err = api.ds.SelectLots(conditions)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if len(queryResult) == 0 || len(queryResult) > 1 {
		c.IndentedJSON(http.StatusNoContent, models.Lot{})
	} else {
		lot := queryResult[0]
		spots, err := api.ds.CountSpotsTaken(vid, lid)
		if err != nil {
			c.IndentedJSON(http.StatusInternalServerError, err)
			return
		}
		c.IndentedJSON(http.StatusOK, models.GetLotResponse{SpotsTaken: spots, LotInfo: lot})
	}
}
