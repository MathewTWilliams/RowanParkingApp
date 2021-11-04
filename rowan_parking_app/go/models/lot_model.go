package models

import (
	"RPA/backend/constants"
	"fmt"

	geom "github.com/twpayne/go-geom"
	"github.com/twpayne/go-geom/encoding/geojson"
	"github.com/twpayne/go-geom/encoding/wkb"
)

type Lot struct {
	Id             int64             `json:"Id"`
	LotName        string            `json:"LotName"`
	LotDescription string            `json:"LotDescription"`
	LotType        int64             `json:"LotType"`
	NumSpaces      int64             `json:"NumSpaces"`
	VenueId        int64             `json:"VenueId"`
	SpecificRules  string            `json:"SpecificRules"`
	BoundingBox    *geojson.Geometry `json:"BoundingBox"`
	LotLocation    *geojson.Geometry `json:"LotLocation"`
}

func (l *Lot) SetBoundingBox_Bytes(bytes []byte) error {
	var err error
	bb, err := wkb.Unmarshal(bytes[constants.SRID_BYTE_OFFSET:])

	if err != nil {
		return fmt.Errorf("SetBoundingBox_Bytes: %v", err)
	}

	l.BoundingBox, err = geojson.Encode(bb.(*geom.Point).SetSRID(constants.SRID))
	if err != nil {
		return fmt.Errorf("SetBoundingBox_Bytes: %v", err)
	}

	return nil
}

func (l *Lot) SetLotLocation_Bytes(bytes []byte) error {
	var err error

	ll, err := wkb.Unmarshal(bytes[constants.SRID_BYTE_OFFSET:])
	if err != nil {
		return fmt.Errorf("SetLotLocation_Bytes: %v", err)
	}

	l.LotLocation, err = geojson.Encode(ll.(*geom.Point).SetSRID(constants.SRID))

	if err != nil {
		return fmt.Errorf("SetLotLocation_Bytes: %v", err)
	}

	return nil

}
