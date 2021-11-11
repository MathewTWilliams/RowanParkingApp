package api

import (
	"RPA/backend/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (api *API) RouteBugs() {
	api.router.POST("/api/users/report_bug", api.PostBugReport)
	api.router.GET("/api/bug_reports", api.GetBugReports)
}

func (api *API) PostBugReport(c *gin.Context) {
	var payload models.BugReportPayload

	err := c.BindJSON(&payload)

	if err != nil || payload.UserId <= 0 || payload.BugReport == "" {
		c.IndentedJSON(http.StatusBadRequest, "")
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

func (api *API) GetBugReports(c *gin.Context) {
	var bugs []models.Bug
	var err error

	bugs, err = api.ds.SelectBugs(nil)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err)
		return
	}

	c.IndentedJSON(api.GetStatusForContent(len(bugs)), bugs)
}
