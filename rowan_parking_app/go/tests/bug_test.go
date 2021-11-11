package tests

import (
	"RPA/backend/api"
	db "RPA/backend/database"
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestPostBugReport(t *testing.T) {
	var ds db.DataStore
	ds.InitDB()

	var api api.API
	api.InitAPI(&ds)

	//good test
	json_str := []byte(`{"UserId": 1, "BugReport":"The login screen doesn't work."}`)
	rec := httptest.NewRecorder()

	req, _ := http.NewRequest("POST", "/api/users/report_bug", bytes.NewBuffer(json_str))
	api.Serve(rec, req)

	assert.Equal(t, 201, rec.Code)

	//bad test
	json_str = []byte(`{"BugReports":"The login screen isn't working"}`)
	rec = httptest.NewRecorder()
	req, _ = http.NewRequest("POST", "/api/users/report_bug", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 400, rec.Code)

}
