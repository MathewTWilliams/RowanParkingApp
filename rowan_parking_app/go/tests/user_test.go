package tests

import (
	"RPA/backend/api"
	db "RPA/backend/database"
	"bytes"
	"math/rand"
	"net/http"
	"net/http/httptest"
	"strconv"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestPostUser(t *testing.T) {
	var ds db.DataStore
	ds.InitDB()

	var api api.API
	api.InitAPI(&ds)

	rand.Seed(time.Now().UnixNano())
	user_name := "willia" + strconv.FormatInt(rand.Int63n(1000), 10)

	//good test
	json_str := []byte(`{"UserName": "` + user_name + `", "VenueId":1}`)
	rec := httptest.NewRecorder()

	req, _ := http.NewRequest("POST", "/api/users/login", bytes.NewBuffer(json_str))
	api.Serve(rec, req)

	assert.Equal(t, 201, rec.Code)

	//already exists test
	json_str = []byte(`{"UserName": "willia137", "VenueId":1}`)
	rec = httptest.NewRecorder()

	req, _ = http.NewRequest("POST", "/api/users/login", bytes.NewBuffer(json_str))
	api.Serve(rec, req)

	assert.Equal(t, 200, rec.Code)

	//bad test
	json_str = []byte(`{"UserName": "` + user_name + `"}`)
	rec = httptest.NewRecorder()
	req, _ = http.NewRequest("POST", "/api/users/login", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 400, rec.Code)
}
