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

func TestPostLotType(t *testing.T) {
	var ds db.DataStore
	ds.InitDB()

	var api api.API
	api.InitAPI(&ds)

	//good test
	json_str := []byte(`{"TypeName":"Generic Type", "Rules":"This is a rule."}`)
	rec := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/venues/1/post_lot_type", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 201, rec.Code)

	//bad test
	json_str = []byte(`{}`)
	rec = httptest.NewRecorder()
	req, _ = http.NewRequest("POST", "/api/venues/1/post_lot_type", bytes.NewBuffer(json_str))
	api.Serve(rec, req)
	assert.Equal(t, 400, rec.Code)
}
