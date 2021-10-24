package main

import (
	"RPA/backend/models"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type CheckInPayload struct {
	UserId int64 `json:"UserId"`
}

type LotRatingPayload struct {
	UserId int64 `json:"UserId"`
	Review int64 `json:"Review"`
}

type BugReportPayload struct {
	UserId    int64  `json:"UserId"`
	BugReport string `json:"BugReport"`
}

func (api *API) PostCheckIn(c *gin.Context) {

	var payload CheckInPayload

	err := c.BindJSON(&payload)
	if err != nil {
		log.Println("BindJSON Error: " + err.Error())
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {

		lid, err := strconv.ParseInt(c.Param("lid"), 10, 64)
		if err != nil {
			log.Println("Parse Int error")
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

			err = api.ds.InsertCheckIn(newCheckIn)
			if err != nil {
				log.Println("Insert Check In Error " + err.Error())
				c.IndentedJSON(http.StatusInternalServerError, err)

			} else {

				c.IndentedJSON(http.StatusCreated, newCheckIn)
			}
		}
	}
}

func (api *API) PostLotRating(c *gin.Context) {
	var payload LotRatingPayload

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

			err = api.ds.InsertLotRating(newLotRating)
			if err != nil {
				c.IndentedJSON(http.StatusInternalServerError, err)
			} else {

				c.IndentedJSON(http.StatusCreated, newLotRating)
			}
		}
	}
}

func (api *API) PostBugReport(c *gin.Context) {
	var payload BugReportPayload

	err := c.BindJSON(&payload)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {

		var newBugReport models.Bug
		newBugReport.BugReport = payload.BugReport
		newBugReport.UserId = payload.UserId

		err = api.ds.InsertBugReport(newBugReport)

		if err != nil {
			c.IndentedJSON(http.StatusInternalServerError, err)
		}

		c.IndentedJSON(http.StatusCreated, newBugReport)
	}
}
