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

func TestPostLot(t *testing.T) {
	var ds db.DataStore
	ds.InitDB()

	var api api.API
	api.InitAPI(&ds)

	//good test
	json_str := []byte(`{"LotName": "Lot A", "LotDescription":"This is a commuter lot.", 
						"LotType":1, "NumSpaces":200, "SpecificRules":"Commuters may pack in this lot after 4:00pm."}`)
	rec := httptest.NewRecorder()

	req, _ := http.NewRequest("POST", "/api/venues/1/post_lot", bytes.NewBuffer(json_str))
	api.Serve(rec, req)

	assert.Equal(t, 201, rec.Code)

	//bad test
	json_str = []byte(`{"BugReports":"The login screen isn't working"}`)
	rec = httptest.NewRecorder()
	req, _ = http.NewRequest("POST", "/api/venues/1/post_lot", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 400, rec.Code)
}
