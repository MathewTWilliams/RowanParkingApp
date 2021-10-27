package api

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

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

	venues, err := api.ds.SelectVenues(nil, []string{"Where Id = " + strconv.FormatInt(vid, 10)})
	if err != nil || len(venues) == 0 || len(venues) > 1 {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

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

func (api *API) PostLotRating(c *gin.Context) {
	var payload models.LotRatingPayload

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

	venues, err := api.ds.SelectVenues(nil, []string{"Where Id = " + strconv.FormatInt(vid, 10)})
	if err != nil || len(venues) == 0 || len(venues) > 1 {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	//loc, _ := time.LoadLocation(api.ds.GetVenueTimeZone(venues[0].GetPoint()))

	var newLotRating models.Lot_Rating
	newLotRating.LotId = lid
	newLotRating.Review = payload.Review
	newLotRating.TimeOfReview = time.Now() //.In(loc)
	newLotRating.UserId = payload.UserId

	lr_id, err := api.ds.InsertLotRating(newLotRating)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else {
		newLotRating.Id = lr_id
		c.IndentedJSON(http.StatusCreated, newLotRating)
	}

}

func (api *API) PostBugReport(c *gin.Context) {
	var payload models.BugReportPayload

	err := c.BindJSON(&payload)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	var newBugReport models.Bug
	newBugReport.BugReport = payload.BugReport
	newBugReport.UserId = payload.UserId

	b_id, err := api.ds.InsertBugReport(newBugReport)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	newBugReport.Id = b_id
	c.IndentedJSON(http.StatusCreated, newBugReport)

}

func (api *API) TryPostUser(c *gin.Context) {
	var err error
	var payload models.RegisterUserPayload

	err = c.BindJSON(&payload)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	var conditions []string
	conditions = append(conditions, "Where VenueID = "+strconv.FormatInt(payload.VenueId, 10))
	conditions = append(conditions, "AND UserName = \""+payload.UserName+"\"")
	uid, err := api.ds.CheckIfExists(constants.TABLENAME_USERS, conditions)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	} else if uid < 0 {
		var user models.User
		user.Settings = models.SettingsJson{TextSize: 14, Language: "English"}
		user.UserName = payload.UserName
		user.VenueId = payload.VenueId
		uid, err = api.ds.InsertUser(user)
		if err != nil {
			log.Println(err.Error())
			c.IndentedJSON(http.StatusInternalServerError, err)
			return
		}
		user.Id = uid
		c.IndentedJSON(http.StatusCreated, user)
		return
	}

	c.IndentedJSON(http.StatusOK, models.RegisterUserResponse{UserId: uid})

}
