package api

import (
	"RPA/backend/constants"
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
	api.router.GET("/api/check_ins/:cid", api.GetLotCheckById)
}

func (api *API) GetLotCheckById(c *gin.Context) {
	c_id := c.Param("cid")
	c_id_int, err := strconv.ParseInt(c_id, 10, 64)
	if err != nil || c_id_int <= 0 {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	conds := []string{"Where Id = " + c_id}
	if api.ds.CheckIfExists(constants.TABLENAME_LCI, conds) == -1 {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	result, err := api.ds.SelectLotCheckIns(conds)
	if err != nil || len(result) > 1 {
		c.IndentedJSON(http.StatusInternalServerError, "")
	} else if len(result) == 0 {
		c.IndentedJSON(http.StatusNoContent, "")
	} else {
		c.IndentedJSON(http.StatusOK, result[0])
	}

}

func (api *API) PostCheckIn(c *gin.Context) {
	var payload models.CheckInPayload

	err := c.BindJSON(&payload)
	if err != nil || payload.UserId <= 0 {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	l_id := c.Param("lid")
	v_id := c.Param("vid")

	if !api.AreIdsValid(v_id, l_id) {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	l_id_int, _ := strconv.ParseInt(l_id, 10, 64)

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
	checkInResponse.CheckInInfo.LotId = l_id_int
	checkInResponse.CheckInInfo.CheckInTime = checkInTime
	checkInResponse.CheckInInfo.UserId = payload.UserId

	checkin_id, err := api.ds.InsertCheckIn(checkInResponse.CheckInInfo)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	checkInResponse.CheckInInfo.Id = checkin_id
	checkInResponse.SpotsTaken, err = api.ds.CountSpotsTaken(v_id, c.Param("lid"))
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}
	c.IndentedJSON(http.StatusCreated, checkInResponse)

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

	if !api.AreIdsValid(v_id, l_id) {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

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
	if err != nil || payload.UserId == 0 {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	v_id := c.Param("vid")
	l_id := c.Param("lid")

	if !api.AreIdsValid(v_id, l_id) {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

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
	ci_id, err := api.ds.InsertCheckOut(check_out_time, u_id, l_id)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	conds = []string{"Where Id = " + strconv.FormatInt(ci_id, 10)}
	check_in, err := api.ds.SelectLotCheckIns(conds)
	if err != nil || len(check_in) > 1 || len(check_in) == 0 {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	//Reusing the PostCheckInResponse struct for this method
	var response models.PostCheckInResponse
	response.CheckInInfo = check_in[0]
	response.SpotsTaken, err = api.ds.CountSpotsTaken(v_id, l_id)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	c.IndentedJSON(http.StatusAccepted, response)
}
