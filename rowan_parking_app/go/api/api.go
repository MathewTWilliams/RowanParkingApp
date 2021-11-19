package api

import (
	"RPA/backend/constants"
	db "RPA/backend/database"
	"net/http"
	"net/http/httptest"
	"strconv"

	"github.com/gin-gonic/gin"
)

type API struct {
	router *gin.Engine
	ds     *db.DataStore
}

func (api *API) RouteAll() {
	api.RouteBugs()
	api.RouteCheckIns()
	api.RouteLots()
	api.RouteRatings()
	api.RouteUsers()
	api.RouteVenues()
	api.RouteLotTypes()
}

func (api *API) InitAPI(ds *db.DataStore) {
	api.ds = ds
	api.router = gin.Default()
	//api.router.Use(AuthMiddleware)
	api.RouteAll()
}

func (api *API) StartListening() {
	api.router.Run(":8080")
}

func (api *API) GetStatusForContent(length int) int {

	if length == 0 {
		return http.StatusNoContent
	}

	return http.StatusOK
}

func (api *API) AreIdsValid(v_id string, l_id string) bool {
	if v_id != "" {
		v_id_int, err := strconv.ParseInt(v_id, 10, 64)
		if err != nil || v_id_int <= 0 {
			return false
		}

		conds := []string{"Where Id = " + v_id}
		if api.ds.CheckIfExists(constants.TABLENAME_VENUES, conds) == -1 {
			return false
		}
	}

	if l_id != "" {
		l_id_int, err := strconv.ParseInt(l_id, 10, 64)
		if err != nil || l_id_int <= 0 {
			return false
		}

		conds := []string{"Where Id = " + l_id}
		if api.ds.CheckIfExists(constants.TABLENAME_LOTS, conds) == -1 {
			return false
		}
	}

	return true
}

//Method is purely for testing purposes
func (api *API) Serve(rec *httptest.ResponseRecorder, req *http.Request) {
	api.router.ServeHTTP(rec, req)
}
