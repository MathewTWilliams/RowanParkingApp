package models

import (
	"RPA/backend/constants"
	"fmt"

	geom "github.com/twpayne/go-geom"
	"github.com/twpayne/go-geom/encoding/geojson"
	"github.com/twpayne/go-geom/encoding/wkb"
)

func (v *Venue) SetVenueLocation_Bytes(bytes []byte) error {

	vl, err := wkb.Unmarshal(bytes[constants.SRID_BYTE_OFFSET:])
	if err != nil {
		return fmt.Errorf("SetVenueLocation_Bytes: %v", err)
	}

	v.VenueLocation, err = geojson.Encode(vl.(*geom.Point).SetSRID(constants.SRID))
	if err != nil {
		return fmt.Errorf("SetVenueLocation_Bytes: %v", err)
	}

	return nil
}

func (v *Venue) SetVenueLocation_Coords(lat float64, long float64) error {
	var point *geom.Point
	var err error
	point = geom.NewPointFlat(geom.XY, []float64{lat, long}).SetSRID(constants.SRID)
	v.VenueLocation, err = geojson.Encode(point)
	if err != nil {
		return fmt.Errorf("SetVenueLocation_Coords: %v", err)
	}

	return nil
}
