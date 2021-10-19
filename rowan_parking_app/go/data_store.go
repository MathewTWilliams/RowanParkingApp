//Author: Matt Willaims
//Version: 10/18/2021
//This script contains the core code for our database connection to the
//mysql database.

package main

import (
	"RPA/backend/models"
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/go-sql-driver/mysql"
	geom "github.com/twpayne/go-geom"
	"github.com/twpayne/go-geom/encoding/wkb"
)

type DataStore struct {
	db *sql.DB
}

func (ds *DataStore) InitDB() {
	cfg := mysql.Config{
		User:                 os.Getenv("DBUSER"),
		Passwd:               os.Getenv("DBPASS"),
		Net:                  "tcp",
		Addr:                 "127.0.0.1:3306",
		DBName:               "RowanParkingApp",
		AllowNativePasswords: true,
		ParseTime:            true,
	}

	var err error
	ds.db, err = sql.Open("mysql", cfg.FormatDSN())

	if err != nil {
		log.Fatal(err)
	}

	pingErr := ds.db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
}

func (ds *DataStore) SelectQuery(table string,
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
		query.WriteString("* ")
		for _, cond := range conditions {
			query.WriteString(cond + " ")
		}
	}

	query.WriteString(";")
	return query.String()

}

func (ds *DataStore) GetVenues(columns []string, conditions []string) ([]models.Venue, error) {
	var venues []models.Venue
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQuery(TABLENAME_VENUES, columns, conditions))

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
		venueLocation, err := wkb.Unmarshal(temp[4:])
		if err != nil {
			return nil, fmt.Errorf(("GetVenues: %v"), err)
		}

		venue.VenueLocation = venueLocation.(*geom.Point).SetSRID(SRID)
		venues = append(venues, venue)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetVenues: %v", err)
	}

	return venues, nil

}

func (ds *DataStore) GetLotTypes(columns []string, conditions []string) ([]models.Lot_Type, error) {
	var lot_types []models.Lot_Type
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQuery(TABLENAME_LT, columns, conditions))

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

func (ds *DataStore) GetLots(columns []string, conditions []string) ([]models.Lot, error) {
	var lots []models.Lot
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQuery(TABLENAME_LOTS, columns, conditions))

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

		lot.BoundingBox = bb.(*geom.Polygon).SetSRID(SRID)
		lot.LotLocation = ll.(*geom.Point).SetSRID(SRID)
		lots = append(lots, lot)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("GetLots: %v", err)
	}

	return lots, nil

}

func (ds *DataStore) GetLotCheckIns(columns []string, conditions []string) ([]models.Lot_Check_in, error) {
	var check_ins []models.Lot_Check_in
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQuery(TABLENAME_LCI, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLotCheckIns: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lci models.Lot_Check_in

		err = rows.Scan(&lci.Id, &lci.LotId, &lci.CheckInTime, &lci.CheckOutTime,
			&lci.Userid)
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

func (ds *DataStore) GetUsers(columns []string, conditions []string) ([]models.User, error) {
	var users []models.User
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQuery(TABLENAME_USERS, columns, conditions))

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

func (ds *DataStore) GetLotRatings(columns []string, conditions []string) ([]models.Lot_Rating, error) {
	var ratings []models.Lot_Rating
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQuery(TABLENAME_LR, columns, conditions))

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

func (ds *DataStore) GetBugs(columns []string, conditions []string) ([]models.Bug, error) {
	var bugs []models.Bug
	var err error
	var rows *sql.Rows

	rows, err = ds.db.Query(ds.SelectQuery(TABLENAME_BUGS, columns, conditions))

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
