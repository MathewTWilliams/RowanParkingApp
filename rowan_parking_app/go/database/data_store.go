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
	"strings"
	"time"

	"github.com/go-sql-driver/mysql"
)

type DataStore struct {
	*sql.DB
}

func (ds *DataStore) InitDB() {
	cfg := mysql.Config{
		User:                 os.Getenv("DBUSER"),
		Passwd:               os.Getenv("DBPASS"),
		Net:                  "tcp",
		Addr:                 os.Getenv("DBADDR"),
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

//Given a check in time and check out time, determine if a spot is being occupied.
func (ds *DataStore) IsOccupyingSpot(check_in time.Time, check_out sql.NullTime) bool {

	if check_out.Valid && check_out.Time.After(check_in) {
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

func (ds *DataStore) CountSpotsTaken(v_id string, l_id string) (int64, error) {
	var err error
	var rows *sql.Rows
	var count int64

	//building the query from the inside out
	q := "(Select LastCheckIn From Users Where Users.VenueId = " + v_id
	q += " And Users.LastCheckIn Is Not Null) As Q1"
	q = "(Lot_Check_ins inner join" + q + " On Lot_Check_ins.Id = Q1.LastCheckIn) "
	q = "Select CheckInTime,CheckOutTime from " + q
	q += "Where Lot_Check_ins.LotId = " + l_id + ";"

	rows, err = ds.DB.Query(q)

	if err != nil {
		return -1, fmt.Errorf("CountSpotsTaken: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var check_in time.Time
		var check_out_null sql.NullTime
		err = rows.Scan(&check_in, &check_out_null)
		if err != nil {
			return -1, fmt.Errorf("CountSpotsTaken: %v", err)
		}

		if ds.IsOccupyingSpot(check_in, check_out_null) {
			count += 1
		}
	}

	return count, nil
}

func (ds *DataStore) CheckIfExists(tablename string, conditions []string) int64 {
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
		return -1
	}

	return id

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

func (ds *DataStore) UpdateValuesBuilder(table string, columns_and_values []string, conds []string) string {

	var query strings.Builder
	query.WriteString("Update " + table + " Set ")
	ds.AppendValuesToQuery(&query, columns_and_values, ", ", " ")
	if len(conds) > 0 {
		ds.AppendValuesToQuery(&query, conds, " ", "")
	}

	query.WriteString(";")

	return query.String()
}

func (ds *DataStore) InsertQueryBuilder(table string, cols []string) string {

	var query strings.Builder
	query.WriteString("Insert Into " + table + " (")
	ds.AppendValuesToQuery(&query, cols, ", ", ") ")
	query.WriteString("Values (")

	for index := 0; index < len(cols); index++ {
		if index+1 < len(cols) {
			query.WriteString("?, ")
		} else {
			query.WriteString("?)")
		}
	}

	query.WriteString(";")
	return query.String()

}

func (ds *DataStore) SelectQueryBuilder(table string, conditions []string) string {

	var query strings.Builder
	query.WriteString("Select * from " + table + " ")

	if len(conditions) > 0 {
		ds.AppendValuesToQuery(&query, conditions, " ", "")
	}

	query.WriteString(";")
	return query.String()
}
