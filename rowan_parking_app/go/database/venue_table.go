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

func (ds *DataStore) InsertVenue(venue models.Venue) (int64, error) {
	var err error
	cols := []string{"Id", "VenueName", "VenueLocation"}

	geom_point_bytes, err := venue.GetVenueLocation_Bytes()
	if err != nil {
		return -1, fmt.Errorf("InsertVenue: %v", err)
	}

	query := ds.InsertQueryBuilder(constants.TABLENAME_VENUES, cols)
	result, err := ds.Exec(query, venue.Id, venue.VenueName, geom_point_bytes)

	if err != nil {
		return -1, fmt.Errorf("InsertVenue: %v", err)
	}

	v_id, err := result.LastInsertId()
	if err != nil {
		return -1, fmt.Errorf("InsertVenue: %v", err)
	}

	return v_id, nil

}
