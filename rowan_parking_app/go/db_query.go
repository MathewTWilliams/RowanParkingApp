//Author: Matt Williams
//Version: 10/7/2021

package main

import (
	"database/sql"
	"fmt"
	"time"

	geom "github.com/twpayne/go-geom"
)

//TODO: Figure out a way to use generic types in Go to limit the amount of boilerplate code

type Venue struct {
	Id            int64
	VenueName     string
	VenueLocation *geom.Point
}

type Lot_Type struct {
	Id       int64
	TypeName string
	Rules    string
}

type Lot struct {
	Id             int64
	LotName        string
	LotDescription string
	LotType        int64
	NumSpaces      int64
	VenueId        int64
	SpecificRules  string
	BoundingBox    *geom.Polygon
	LotLocation    *geom.Point
}

type Lot_Check_in struct {
	Id           int64
	LotId        int64
	CheckInTime  time.Time
	CheckOutTime time.Time
	Userid       int64
}

type User struct {
	Id          int64
	Settings    []uint8 //[]string `json:"Settings"`
	UserName    string
	VenueId     int64
	LastCheckIn int64
}

type Lot_Rating struct {
	Id           int64
	UserId       int64
	LotId        int64
	TimeOfReview time.Time
	Review       int64
}

type Bug struct {
	Id        int64
	BugReport string
	UserId    int64
}

func GetVenues(db *sql.DB) ([]Venue, error) {
	var venues []Venue

	rows, err := db.Query("Select * from " + TABLENAME_VENUES)
	if err != nil {
		return nil, fmt.Errorf("Get Venues: %v", err)
	}

	//defers the execution of a function until the surrounding function returns
	defer rows.Close()

	for rows.Next() {
		var venue Venue
		err = rows.Scan(&venue.Id, &venue.VenueName, &venue.VenueLocation)
		if err != nil {
			return nil, fmt.Errorf("Get Venues: %v", err)
		}

		venues = append(venues, venue)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("Get Venues: %v", err)
	}

	return venues, nil

}

func GetLotTypes(db *sql.DB) ([]Lot_Type, error) {
	var lotTypes []Lot_Type

	rows, err := db.Query("Select * from " + TABLENAME_LT)
	if err != nil {
		return nil, fmt.Errorf("Get LotTypes: %v", err)
	}

	//defers the execution of a function until the surrounding function returns
	defer rows.Close()

	for rows.Next() {
		var lotType Lot_Type
		err = rows.Scan(&lotType.Id, &lotType.TypeName, &lotType.Rules)
		if err != nil {
			return nil, fmt.Errorf("Get LotTypes: %v", err)
		}

		lotTypes = append(lotTypes, lotType)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("Get LotTypes: %v", err)
	}

	return lotTypes, nil

}

func GetLots(db *sql.DB) ([]Lot, error) {
	var lots []Lot

	rows, err := db.Query("Select * from " + TABLENAME_LOTS)
	if err != nil {
		return nil, fmt.Errorf("Get Lots: %v", err)
	}

	//defers the execution of a function until the surrounding function returns
	defer rows.Close()

	for rows.Next() {
		var lot Lot
		err = rows.Scan(&lot.Id, &lot.LotName, &lot.LotDescription,
			&lot.LotType, &lot.NumSpaces, &lot.VenueId,
			&lot.SpecificRules, &lot.BoundingBox, &lot.LotLocation)
		if err != nil {
			return nil, fmt.Errorf("Get Lots: %v", err)
		}

		lots = append(lots, lot)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("Get Lots: %v", err)
	}

	return lots, nil

}

func GetLotCheckins(db *sql.DB) ([]Lot_Check_in, error) {
	var check_ins []Lot_Check_in

	rows, err := db.Query("Select * from " + TABLENAME_LCI)
	if err != nil {
		return nil, fmt.Errorf("Get Lot_Check_ins: %v", err)
	}

	//defers the execution of a function until the surrounding function returns
	defer rows.Close()

	for rows.Next() {
		var check_in Lot_Check_in
		err = rows.Scan(&check_in.Id, &check_in.LotId, &check_in.CheckInTime,
			&check_in.CheckOutTime, &check_in.Userid)
		if err != nil {
			return nil, fmt.Errorf("Get Lot_Check_ins: %v", err)
		}

		check_ins = append(check_ins, check_in)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("Get Lot_Check_ins: %v", err)
	}

	return check_ins, nil

}

func GetUsers(db *sql.DB) ([]User, error) {
	var users []User

	rows, err := db.Query("Select * from " + TABLENAME_USERS)
	if err != nil {
		return nil, fmt.Errorf("Get Users: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var user User
		err = rows.Scan(&user.Id, &user.Settings, &user.UserName,
			&user.VenueId, &user.LastCheckIn)

		if err != nil {
			return nil, fmt.Errorf("Get Users: %v", err)
		}

		users = append(users, user)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("Get Users: %v", err)
	}

	return users, nil
}

func GetLotRatings(db *sql.DB) ([]Lot_Rating, error) {
	var ratings []Lot_Rating

	rows, err := db.Query("Select * from " + TABLENAME_LR)
	if err != nil {
		return nil, fmt.Errorf("Get Lot Ratings: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var rating Lot_Rating
		err = rows.Scan(&rating.Id, &rating.UserId, &rating.LotId,
			&rating.TimeOfReview, &rating.Review)

		if err != nil {
			return nil, fmt.Errorf("Get Lot Rating: %v", err)
		}

		ratings = append(ratings, rating)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("Get Lot Ratings: %v", err)
	}

	return ratings, nil
}

func GetBugs(db *sql.DB) ([]Bug, error) {
	var bugs []Bug

	rows, err := db.Query("Select * from " + TABLENAME_BUGS)
	if err != nil {
		return nil, fmt.Errorf("Get Bugs: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var bug Bug
		err = rows.Scan(&bug.Id, &bug.BugReport, &bug.UserId)

		if err != nil {
			return nil, fmt.Errorf("Get Bugs: %v", err)
		}

		bugs = append(bugs, bug)
	}

	err = rows.Err()
	if err != nil {
		return nil, fmt.Errorf("Get Bugs: %v", err)
	}

	return bugs, nil
}
