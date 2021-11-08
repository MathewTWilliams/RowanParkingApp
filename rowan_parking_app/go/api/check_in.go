package api

import (
	"RPA/backend/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteCheckIns() {
	api.router.POST("/api/venues/:vid/lots/:lid/check_in", api.PostCheckIn)
	api.router.GET("/api/check_ins", api.GetLotCheckIns)
	api.router.GET("/api/venues/:vid/check_ins", api.GetLotCheckIns_Specific)
	api.router.GET("/api/venues/:vid/lots/:lid/check_ins", api.GetLotCheckIns_Specific)
	api.router.PUT("/api/venues/:vid/lots/:lid/check_out", api.PutCheckOut)
}

func (api *API) PostCheckIn(c *gin.Context) {
	var payload models.CheckInPayload

	err := c.BindJSON(&payload)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	l_id, err := strconv.ParseInt(c.Param("lid"), 10, 64)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return

	}

	v_id := c.Param("vid")

	conds := []string{"Where Id = " + v_id}
	result, err := api.ds.SelectVenues(conds)
	if err != nil || len(result) == 0 || len(result) > 1 {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	loc, err := time.LoadLocation(result[0].Timezone)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	checkInTime := time.Now().In(loc)
	var checkInResponse models.PostCheckInResponse
	checkInResponse.CheckInInfo.LotId = l_id
	checkInResponse.CheckInInfo.CheckInTime = checkInTime
	checkInResponse.CheckInInfo.UserId = payload.UserId

	checkin_id, err := api.ds.InsertCheckIn(checkInResponse.CheckInInfo)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)

	} else {
		checkInResponse.CheckInInfo.Id = checkin_id
		checkInResponse.SpotsTaken, _ = api.ds.CountSpotsTaken(v_id, c.Param("lid"))
		c.IndentedJSON(http.StatusCreated, checkInResponse)
	}
}

func (api *API) GetLotCheckIns(c *gin.Context) {
	var check_ins []models.Lot_Check_in
	var err error

	check_ins, err = api.ds.SelectLotCheckIns(nil)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	c.IndentedJSON(api.GetStatusForContent(len(check_ins)), check_ins)
}

func (api *API) GetLotCheckIns_Specific(c *gin.Context) {
	var check_ins []models.Lot_Check_in
	var err error

	v_id := c.Param("vid")
	l_id := c.Param("lid")

	check_ins, err = api.ds.SelectLotCheckIns_Specific(v_id, l_id)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	c.IndentedJSON(api.GetStatusForContent(len(check_ins)), check_ins)

}

func (api *API) PutCheckOut(c *gin.Context) {
	//reusing checkin payload as check out payload
	var payload models.CheckInPayload
	var err error

	err = c.BindJSON(&payload)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	v_id := c.Param("vid")
	l_id := c.Param("lid")

	conds := []string{"Where Id = " + v_id}
	result, err := api.ds.SelectVenues(conds)
	if err != nil || len(result) == 0 || len(result) > 1 {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	loc, err := time.LoadLocation(result[0].Timezone)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	check_out_time := time.Now().In(loc)
	u_id := strconv.FormatInt(payload.UserId, 10)
	_, err = api.ds.InsertCheckOut(check_out_time, u_id, l_id)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	c.IndentedJSON(http.StatusCreated, nil)
}
