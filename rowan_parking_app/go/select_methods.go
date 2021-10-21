package main

import (
	"RPA/backend/models"
	"database/sql"
	"encoding/json"
	"fmt"
	"strings"

	geom "github.com/twpayne/go-geom"
	"github.com/twpayne/go-geom/encoding/geojson"
	"github.com/twpayne/go-geom/encoding/wkb"
)

func (ds *DataStore) SelectQueryBuilder(table string,
	cols []string, conditions []string) string {

	var query strings.Builder
	query.WriteString("Select ")
	if cols == nil || len(cols) == 0 {
		query.WriteString("* ")
	} else {
		for index, col := range cols {
			if index+1 < len(cols) {
				query.WriteString(col + ", ")
			} else {
				query.WriteString(col + " ")
			}

		}
	}

	query.WriteString("from " + table + " ")

	if conditions != nil || len(conditions) > 0 {
		for _, cond := range conditions {
			query.WriteString(cond + " ")
		}
	}

	query.WriteString(";")
	return query.String()

}

func (ds *DataStore) SelectVenues(columns []string, conditions []string) ([]models.Venue, error) {
	var venues []models.Venue
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQueryBuilder(TABLENAME_VENUES, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("Get Venues: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var venue models.Venue
		var temp []byte
		err = rows.Scan(&venue.Id, &venue.VenueName, &temp)
		if err != nil {
			return nil, fmt.Errorf("GetVenues: %v", err)
		}

		//need to ignore the first 4 bytes added by MySQL
		vl, err := wkb.Unmarshal(temp[4:])
		if err != nil {
			return nil, fmt.Errorf("GetVenues: %v", err)
		}

		venue.VenueLocation, err = geojson.Encode(vl.(*geom.Point).SetSRID(SRID))
		if err != nil {
			return nil, fmt.Errorf("GetVenues: %v", err)
		}
		venues = append(venues, venue)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetVenues: %v", err)
	}

	return venues, nil

}

func (ds *DataStore) SelectLotTypes(columns []string, conditions []string) ([]models.Lot_Type, error) {
	var lot_types []models.Lot_Type
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQueryBuilder(TABLENAME_LT, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLotTypes: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lot_type models.Lot_Type

		err = rows.Scan(&lot_type.Id, &lot_type.TypeName, &lot_type.Rules)
		if err != nil {
			return nil, fmt.Errorf("GetLotTypes: %v", err)
		}

		lot_types = append(lot_types, lot_type)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetLotTypes: %v", err)
	}

	return lot_types, nil

}

func (ds *DataStore) SelectLots(columns []string, conditions []string) ([]models.Lot, error) {
	var lots []models.Lot
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQueryBuilder(TABLENAME_LOTS, columns, conditions))

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
		bb, err := wkb.Unmarshal(tempBB[4:])
		if err != nil {
			return nil, fmt.Errorf(("GetVenues: %v"), err)
		}

		ll, err := wkb.Unmarshal(tempLL[4:])
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}

		lot.BoundingBox, err = geojson.Encode(bb.(*geom.Polygon).SetSRID(SRID))
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}
		lot.LotLocation, err = geojson.Encode(ll.(*geom.Point).SetSRID(SRID))
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}
		lots = append(lots, lot)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetLots: %v", err)
	}

	return lots, nil

}

func (ds *DataStore) SelectLotCheckIns(columns []string, conditions []string) ([]models.Lot_Check_in, error) {
	var check_ins []models.Lot_Check_in
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQueryBuilder(TABLENAME_LCI, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLotCheckIns: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lci models.Lot_Check_in

		err = rows.Scan(&lci.Id, &lci.LotId, &lci.CheckInTime, &lci.CheckOutTime,
			&lci.UserId)
		if err != nil {
			return nil, fmt.Errorf("GetLotCheckIns: %v", err)
		}

		check_ins = append(check_ins, lci)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetLotCheckIns: %v", err)
	}

	return check_ins, nil

}

func (ds *DataStore) SelectUsers(columns []string, conditions []string) ([]models.User, error) {
	var users []models.User
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQueryBuilder(TABLENAME_USERS, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetUsers: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var user models.User
		var temp []byte
		err = rows.Scan(&user.Id, &temp, &user.UserName, &user.VenueId, &user.LastCheckIn)
		if err != nil {
			return nil, fmt.Errorf("GetUsers: %v", err)
		}

		var settings models.SettingsJson
		json.Unmarshal(temp, &settings)
		user.Settings = settings
		users = append(users, user)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetUsers: %v", err)
	}

	return users, nil

}

func (ds *DataStore) SelectLotRatings(columns []string, conditions []string) ([]models.Lot_Rating, error) {
	var ratings []models.Lot_Rating
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQueryBuilder(TABLENAME_LR, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLotRatings: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var rating models.Lot_Rating

		err = rows.Scan(&rating.Id, &rating.UserId, &rating.LotId,
			&rating.TimeOfReview, &rating.Review)
		if err != nil {
			return nil, fmt.Errorf("GetLotRatings: %v", err)
		}

		ratings = append(ratings, rating)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetLotRatings: %v", err)
	}

	return ratings, nil

}

func (ds *DataStore) SelectBugs(columns []string, conditions []string) ([]models.Bug, error) {
	var bugs []models.Bug
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQueryBuilder(TABLENAME_BUGS, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetBugs: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var bug models.Bug

		err = rows.Scan(&bug.Id, &bug.BugReport, &bug.UserId)
		if err != nil {
			return nil, fmt.Errorf("GetBugs: %v", err)
		}

		bugs = append(bugs, bug)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetBugs: %v", err)
	}

	return bugs, nil

}
