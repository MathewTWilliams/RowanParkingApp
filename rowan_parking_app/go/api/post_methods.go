package api

import (
	db "RPA/backend/database"
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
	} else {

		lid, err := strconv.ParseInt(c.Param("lid"), 10, 64)
		if err != nil {
			c.IndentedJSON(http.StatusBadRequest, err)

		} else {

			checkInTime := time.Now()
			var newCheckIn models.Lot_Check_in
			newCheckIn.LotId = lid
			newCheckIn.CheckInTime = checkInTime
			newCheckIn.UserId = payload.UserId
			//subtract the check in time, by 1 second.
			//Having a Checkout time that happened before your check in means
			//you are currenlty check into a parking lot.
			newCheckIn.CheckOutTime = checkInTime.Add(time.Second * -1)

			checkin_id, err := api.ds.InsertCheckIn(newCheckIn)
			if err != nil {
				c.IndentedJSON(http.StatusInternalServerError, err)

			} else {
				newCheckIn.Id = checkin_id
				c.IndentedJSON(http.StatusCreated, newCheckIn)
			}
		}
	}
}

func (api *API) PostLotRating(c *gin.Context) {
	var payload models.LotRatingPayload

	err := c.BindJSON(&payload)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {
		lid, err := strconv.ParseInt(c.Param("lid"), 10, 64)
		if err != nil {
			c.IndentedJSON(http.StatusBadRequest, err)
		} else {

			var newLotRating models.Lot_Rating
			newLotRating.LotId = lid
			newLotRating.Review = payload.Review
			newLotRating.TimeOfReview = time.Now()
			newLotRating.UserId = payload.UserId

			lr_id, err := api.ds.InsertLotRating(newLotRating)
			if err != nil {
				c.IndentedJSON(http.StatusInternalServerError, err)
			} else {
				newLotRating.Id = lr_id
				c.IndentedJSON(http.StatusCreated, newLotRating)
			}
		}
	}
}

func (api *API) PostBugReport(c *gin.Context) {
	var payload models.BugReportPayload

	err := c.BindJSON(&payload)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {

		var newBugReport models.Bug
		newBugReport.BugReport = payload.BugReport
		newBugReport.UserId = payload.UserId

		b_id, err := api.ds.InsertBugReport(newBugReport)

		if err != nil {
			c.IndentedJSON(http.StatusInternalServerError, err)
		}

		newBugReport.Id = b_id
		c.IndentedJSON(http.StatusCreated, newBugReport)
	}
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
	conditions = append(conditions, "Where VenueID = "+strconv.Itoa(int(payload.VenueId)))
	conditions = append(conditions, "AND UserName = \""+payload.UserName+"\"")
	uid, err := api.ds.CheckIfExists(db.TABLENAME_USERS, conditions)

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
