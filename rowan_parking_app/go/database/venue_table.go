package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"
)

func (ds *DataStore) SelectVenues(columns []string, conditions []string) ([]models.Venue, error) {
	var venues []models.Venue
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_VENUES, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("get venues: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var venue models.Venue
		var temp []byte
		err = rows.Scan(&venue.Id, &venue.VenueName, &temp)
		if err != nil {
			return nil, fmt.Errorf("GetVenues: %v", err)
		}

		venue.SetVenueLocation_Bytes(temp)
		venues = append(venues, venue)
	}

	return venues, nil

}
