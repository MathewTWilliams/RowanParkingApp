package api

import (
	"net/http"
	"strconv"
	"time"
	"RPA/backend/models"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteRatings() {
	api.router.POST("/api/venues/:vid/lots/:lid/rating", api.PostLotRating)
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
