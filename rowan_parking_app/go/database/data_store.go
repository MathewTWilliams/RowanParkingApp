//Author: Matt Willaims
//Version: 10/18/2021
//This script contains the core code for our database connection to the
//mysql database.

package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/go-sql-driver/mysql"
	geom "github.com/twpayne/go-geom"
	tzmapper "github.com/zsefvlol/timezonemapper"
)

type DataStore struct {
	*sql.DB
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
	ds.DB, err = sql.Open("mysql", cfg.FormatDSN())

	if err != nil {
		log.Fatal(err)
	}

	pingErr := ds.DB.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
}

func (ds *DataStore) GetVenueTimeZone(point *geom.Point) string {
	points := point.FlatCoords()
	lat := points[0]
	long := points[1]

	return tzmapper.LatLngToTimezoneString(lat, long)

}

//Given a check in time and check out time, determine if a spot is being occupied.
//A spot is being occupied if: the check in date matches the time_now date (after timezone conversion),
//and if the check_out time is nil
func (ds *DataStore) IsOccupyingSpot(check_in *time.Time, check_out *time.Time) bool {

	if check_out == nil {
		return false
	}

	time_now := time.Now().In(check_in.Location())
	if check_in.Year() == time_now.Year() &&
		check_in.Month() == time_now.Month() &&
		check_in.Day() == time_now.Day() {
		return true
	}

	return false
}

func (ds *DataStore) CountSpotsTaken(vid int64, lid int64) (int64, error) {
	var err error
	var rows *sql.Rows
	var count int64

	vid_str := strconv.FormatInt(vid, 10)
	lid_str := strconv.FormatInt(lid, 10)

	//building the query from the inside out
	q := "(Select LastCheckIn From Users Where Users.VenueId = " + vid_str
	q += " And Users.LastCheckIn Is Not Null) As Q1"
	q = "(Lot_Check_ins inner join" + q + " On Lot_Check_ins.Id = Q1.LastCheckIn) "
	q = "Select CheckInTime,CheckOutTime from " + q
	q += "Where Lot_Check_ins.LotId = " + lid_str + ";"

	rows, err = ds.DB.Query(q)

	if err != nil {
		return -1, fmt.Errorf("CountSpotsTaken: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var check_in *time.Time
		var check_out *time.Time

		err = rows.Scan(check_in, check_out)
		if err != nil {
			return -1, fmt.Errorf("CountSpotsTaken: %v", err)
		}

		if ds.IsOccupyingSpot(check_in, check_out) {
			count += 1
		}
	}

	return count, nil
}

func (ds *DataStore) CheckIfExists(tablename string, conditions []string) (int64, error) {
	var query strings.Builder
	var err error
	var id int64

	query.WriteString("SELECT Id from " + tablename + " ")

	if len(conditions) > 0 {
		ds.AppendValuesToQuery(&query, conditions, " ", "")
	}

	query.WriteString(";")

	result := ds.QueryRow(query.String())

	err = result.Scan(&id)

	if err != nil {
		return -1, fmt.Errorf("check if exists query: %v", err)
	}

	return id, nil

}

func (ds *DataStore) AppendValuesToQuery(query *strings.Builder, values []string, delim string, end string) {
	for i, value := range values {
		if i+1 < len(values) {
			query.WriteString(value + delim)
		} else {
			query.WriteString(value + end)
		}
	}
}

func (ds *DataStore) UpdateValues(table string, columns_and_values []string, conds []string) error {

	var query strings.Builder
	query.WriteString("Update " + table + " Set ")
	ds.AppendValuesToQuery(&query, columns_and_values, ", ", " ")
	if len(conds) > 0 {
		ds.AppendValuesToQuery(&query, conds, " ", "")
	}

	query.WriteString(";")

	_, err := ds.DB.Exec(query.String())
	return err
}
