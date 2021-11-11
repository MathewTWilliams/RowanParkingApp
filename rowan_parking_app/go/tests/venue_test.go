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

func TestPostVenue(t *testing.T) {
	var ds db.DataStore
	ds.InitDB()

	var api api.API
	api.InitAPI(&ds)

	//good test
	json_str := []byte(`{"VenueName": "Temple University", "Latitude": 39.98, 
	"Longitude": -75.16, "Timezone":"America/New_York"}`)
	rec := httptest.NewRecorder()

	req, _ := http.NewRequest("POST", "/api/post_venue", bytes.NewBuffer(json_str))
	api.Serve(rec, req)

	assert.Equal(t, 201, rec.Code)

	//bad test
	json_str = []byte(`{"Latitude": 39.98, "Longitude": -75.16}`)
	rec = httptest.NewRecorder()
	req, _ = http.NewRequest("POST", "/api/post_venue", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 400, rec.Code)
}
