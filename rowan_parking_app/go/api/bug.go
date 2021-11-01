package api

import (
	"net/http"
	"RPA/backend/models"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteBugs() {
	api.router.POST("/api/users/report_bug", api.PostBugReport)
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
