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

func (ds *DataStore) PostCheckIn(c *gin.Context) {

	var payload CheckInPayload

	err := c.BindJSON(&payload)
	if err != nil {
		log.Println("BindJSON Error: " + err.Error())
		c.IndentedJSON(http.StatusInternalServerError, err)
	} else {

		lid, err := strconv.ParseInt(c.Param("lid"), 10, 64)
		if err != nil {
			log.Println("Parse Int error")
			c.IndentedJSON(http.StatusBadRequest, err)

		} else {

			var newCheckIn models.Lot_Check_in
			newCheckIn.LotId = lid
			newCheckIn.CheckInTime = time.Now()
			newCheckIn.UserId = payload.UserId
			newCheckIn.CheckOutTime = time.Time{}

			err = ds.InsertCheckIn(newCheckIn)
			if err != nil {
				log.Println("Insert Check In Error " + err.Error())
				c.IndentedJSON(http.StatusInternalServerError, err)

			} else {

				c.IndentedJSON(http.StatusCreated, newCheckIn)
			}
		}
	}
}

func (ds *DataStore) PostLotRating(c *gin.Context) {
	var payload LotRatingPayload

	err := c.BindJSON(&payload)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	}

	lid, err := strconv.ParseInt(c.Param("lid"), 10, 64)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	}

	var newLotRating models.Lot_Rating
	newLotRating.LotId = lid
	newLotRating.Review = payload.Review
	newLotRating.TimeOfReview = time.Now()
	newLotRating.UserId = payload.UserId

	err = ds.InsertLotRating(newLotRating)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	}

	c.IndentedJSON(http.StatusCreated, newLotRating)
}

func (ds *DataStore) PostBugReport(c *gin.Context) {
	var payload BugReportPayload

	err := c.BindJSON(&payload)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
	}

	var newBugReport models.Bug
	newBugReport.BugReport = payload.BugReport
	newBugReport.UserId = payload.UserId

	ds.InsertBugReport(newBugReport)

	c.IndentedJSON(http.StatusCreated, newBugReport)
}
