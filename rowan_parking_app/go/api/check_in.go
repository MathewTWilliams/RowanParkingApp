package api

import (
	"net/http"
	"strconv"
	"time"
	"RPA/backend/models"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteCheckIns() {
	api.router.POST("/api/venues/:vid/lots/:lid/check_in", api.PostCheckIn)
}

func (api *API) PostCheckIn(c *gin.Context) {
	var payload models.CheckInPayload

	err := c.BindJSON(&payload)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	lid, err := strconv.ParseInt(c.Param("lid"), 10, 64)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return

	}

	vid, err := strconv.ParseInt(c.Param("vid"), 10, 64)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	/*venues, err := api.ds.SelectVenues(nil, []string{"Where Id = " + strconv.FormatInt(vid, 10)})
	if err != nil || len(venues) == 0 || len(venues) > 1 {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}*/

	//loc, _ := time.LoadLocation(api.ds.GetVenueTimeZone(venues[0].GetPoint()))

	checkInTime := time.Now() //.In(loc)
	var checkInResponse models.PostCheckInResponse
	checkInResponse.CheckInInfo.LotId = lid
	checkInResponse.CheckInInfo.CheckInTime = checkInTime
	checkInResponse.CheckInInfo.UserId = payload.UserId

	checkin_id, err := api.ds.InsertCheckIn(checkInResponse.CheckInInfo)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)

	} else {
		checkInResponse.CheckInInfo.Id = checkin_id
		checkInResponse.SpotsTaken, _ = api.ds.CountSpotsTaken(vid, lid)
		c.IndentedJSON(http.StatusCreated, checkInResponse)
	}
}
