package api

import (
	"RPA/backend/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteRatings() {
	api.router.POST("/api/venues/:vid/lots/:lid/rating", api.PostLotRating)
	api.router.GET("/api/lot_ratings", api.GetLotRatings)
	api.router.GET("/api/venues/:vid/lot_ratings", api.GetLotRatings_Specific)
	api.router.GET("api/venues/:vid/lots/:lid/lot_ratings", api.GetLotRatings_Specific)
}

func (api *API) GetLotRatings(c *gin.Context) {
	var err error
	var ratings []models.Lot_Rating

	ratings, err = api.ds.SelectLotRatings(nil)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	c.IndentedJSON(api.GetStatusForContent(len(ratings)), ratings)
}

func (api *API) GetLotRatings_Specific(c *gin.Context) {
	var ratings []models.Lot_Rating
	var err error

	l_id := c.Param("lid")
	v_id := c.Param("vid")

	ratings, err = api.ds.SelectLotRatings_Specific(v_id, l_id)

	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
		return
	}

	c.IndentedJSON(api.GetStatusForContent(len(ratings)), ratings)

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

	venues, err := api.ds.SelectVenues([]string{"Where Id = " + strconv.FormatInt(vid, 10)})
	if err != nil || len(venues) == 0 || len(venues) > 1 {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

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
