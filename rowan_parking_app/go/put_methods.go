package main

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (ds *DataStore) TryRegisterUser(c *gin.Context) {
	var userName string
	var venueId int64
	var err error
	userName = c.Param("UserName")
	venueId, err = strconv.ParseInt(c.Param("VenueId"), 10, 64)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, err)
	} else {
		// Need to see if the combination of user name, use EXISTS
	}

}
