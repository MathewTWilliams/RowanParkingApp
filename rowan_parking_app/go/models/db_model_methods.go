package models

import (
	"RPA/backend/constants"
	"fmt"

	"github.com/twpayne/go-geom"
	"github.com/twpayne/go-geom/encoding/geojson"
	"github.com/twpayne/go-geom/encoding/wkb"
)

func (v *Venue) SetVenueLocation(bytes []byte) error {

	vl, err := wkb.Unmarshal(bytes[constants.SRID_BYTE_OFFSET:])
	if err != nil {
		return fmt.Errorf("SetVenueLocation: %v", err)
	}

	v.VenueLocation, err = geojson.Encode(vl.(*geom.Point).SetSRID(constants.SRID))
	if err != nil {
		return fmt.Errorf("SetVenueLocation: %v", err)
	}

	return nil
}

func (v *Venue) GetPoint() *geom.Point {
	point, _ := v.VenueLocation.Decode()
	return point.(*geom.Point)

}
