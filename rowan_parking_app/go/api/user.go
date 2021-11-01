package api

import (
	"net/http"
	"strconv"
	"log"
	"RPA/backend/constants"
	"RPA/backend/models"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteUsers() {
	api.router.POST("/api/users/login", api.TryPostUser)
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
	uid := api.ds.CheckIfExists(constants.TABLENAME_USERS, conditions)

	if uid < 0 {
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

	users, err := api.ds.SelectUsers(nil, []string{"Where Id = " + strconv.FormatInt(uid, 10)})
	if err != nil || len(users) == 0 || len(users) > 1 {
		log.Println(err.Error())
		c.IndentedJSON(http.StatusInternalServerError, err)
	}

	c.IndentedJSON(http.StatusOK, users[0])
}
