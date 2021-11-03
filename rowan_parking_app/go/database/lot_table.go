package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"

	geom "github.com/twpayne/go-geom"
	"github.com/twpayne/go-geom/encoding/geojson"
	"github.com/twpayne/go-geom/encoding/wkb"
)

func (ds *DataStore) SelectLots(columns []string, conditions []string) ([]models.Lot, error) {
	var lots []models.Lot
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_LOTS, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLots: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lot models.Lot
		var tempBB []byte
		var tempLL []byte
		err = rows.Scan(&lot.Id, &lot.LotName, &lot.LotDescription, &lot.LotType,
			&lot.NumSpaces, &lot.VenueId, &lot.SpecificRules,
			&tempBB, &tempLL)
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}

		//need to ignore the first 4 bytes added by MySQL
		bb, err := wkb.Unmarshal(tempBB[constants.SRID_BYTE_OFFSET:])
		if err != nil {
			return nil, fmt.Errorf(("GetVenues: %v"), err)
		}

		ll, err := wkb.Unmarshal(tempLL[constants.SRID_BYTE_OFFSET:])
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}

		lot.BoundingBox, err = geojson.Encode(bb.(*geom.Polygon).SetSRID(constants.SRID))
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}
		lot.LotLocation, err = geojson.Encode(ll.(*geom.Point).SetSRID(constants.SRID))
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}
		lots = append(lots, lot)
	}

	return lots, nil

}
