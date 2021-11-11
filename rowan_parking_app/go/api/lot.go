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
	api.router.POST("/api/venues/:vid/post_lot", api.PostLot)
}

func (api *API) GetLotsFromVenue(c *gin.Context) {
	var lots []models.Lot
	var err error

	v_id := c.Param("vid")
	l_id := c.Param("lid")
	if !api.AreIdsValid(v_id, l_id) {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	var conditions []string
	conditions = append(conditions, "Where VenueId = "+v_id)

	lots, err = api.ds.SelectLots(conditions)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if len(lots) == 0 {
		c.IndentedJSON(http.StatusNoContent, lots)
	} else {
		var responses []models.GetLotResponse
		for _, lot := range lots {
			spots, err := api.ds.CountSpotsTaken(v_id, strconv.FormatInt(lot.Id, 10))
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

	v_id := c.Param("vid")
	l_id := c.Param("lid")
	if !api.AreIdsValid(v_id, l_id) {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}
	var conditions []string

	conditions = append(conditions, "Where VenueID = "+v_id)
	conditions = append(conditions, " AND Id = "+l_id)

	queryResult, err = api.ds.SelectLots(conditions)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else if len(queryResult) == 0 || len(queryResult) > 1 {
		c.IndentedJSON(http.StatusNoContent, models.Lot{})
	} else {
		lot := queryResult[0]
		spots, err := api.ds.CountSpotsTaken(v_id, l_id)
		if err != nil {
			c.IndentedJSON(http.StatusInternalServerError, err)
			return
		}
		c.IndentedJSON(http.StatusOK, models.GetLotResponse{SpotsTaken: spots, LotInfo: lot})
	}
}

func (api *API) PostLot(c *gin.Context) {
	var payload models.PostLotPayload

	err := c.BindJSON(&payload)
	if err != nil || payload.LotName == "" ||
		payload.LotType <= 0 || payload.NumSpaces <= 0 {

		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	v_id := c.Param("vid")
	l_id := c.Param("lid")
	if !api.AreIdsValid(v_id, l_id) {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	v_id_int, _ := strconv.ParseInt(v_id, 10, 64)

	var newLot models.Lot
	newLot.LotName = payload.LotName
	newLot.LotDescription = payload.LotDescription
	newLot.LotType = payload.LotType
	newLot.NumSpaces = payload.NumSpaces
	newLot.SpecificRules = payload.SpecificRules
	newLot.VenueId = v_id_int

	l_id_int, err := api.ds.InsertLot(newLot)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	newLot.Id = l_id_int
	c.IndentedJSON(http.StatusCreated, newLot)

}
