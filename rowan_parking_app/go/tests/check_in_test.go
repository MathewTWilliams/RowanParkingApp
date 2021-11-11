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

func TestPostCheckIn(t *testing.T) {
	var ds db.DataStore
	ds.InitDB()

	var api api.API
	api.InitAPI(&ds)

	//good test
	json_str := []byte(`{"UserId":1}`)
	rec := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/venues/1/lots/1/check_in", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 201, rec.Code)

	//bad test
	json_str = []byte(`{}`)
	rec = httptest.NewRecorder()
	req, _ = http.NewRequest("POST", "/api/venues/1/lots/1/check_in", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 400, rec.Code)

}

func TestPostCheckout(t *testing.T) {
	var ds db.DataStore
	ds.InitDB()

	var api api.API
	api.InitAPI(&ds)

	//good test
	json_str := []byte(`{"UserId":1}`)
	rec := httptest.NewRecorder()
	req, _ := http.NewRequest("PUT", "/api/venues/1/lots/1/check_out", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 201, rec.Code)

	//bad test
	json_str = []byte(`{}`)
	rec = httptest.NewRecorder()
	req, _ = http.NewRequest("PUT", "/api/venues/1/lots/1/check_out", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 400, rec.Code)

}
