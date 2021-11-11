package api

import (
	"RPA/backend/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteLotTypes() {
	api.router.GET("api/venues/:vid/lot_types", api.GetLotTypes)
	api.router.GET("api/lot_types", api.GetLotTypes)
	api.router.POST("api/venues/:vid/post_lot_type", api.PostLotType)
}

func (api *API) GetLotTypes(c *gin.Context) {
	var types []models.Lot_Type
	var err error
	var conditions []string

	v_id := c.Param("vid")
	l_id := c.Param("lid")
	if !api.AreIdsValid(v_id, l_id) {
		c.IndentedJSON(http.StatusBadRequest, "")
		return
	}

	if v_id != "" {
		conditions = append(conditions, "Where VenueId = "+v_id)
	}

	types, err = api.ds.SelectLotTypes(conditions)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	c.IndentedJSON(api.GetStatusForContent(len(types)), types)

}

func (api *API) PostLotType(c *gin.Context) {
	var payload models.PostLotTypePayload

	err := c.BindJSON(&payload)
	if err != nil || payload.TypeName == "" {
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

	var newType models.Lot_Type
	newType.TypeName = payload.TypeName
	newType.Rules = payload.Rules
	newType.VenueId = v_id_int

	lt_id, err := api.ds.InsertLotType(newType)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	newType.Id = lt_id
	c.IndentedJSON(http.StatusCreated, newType)

}
