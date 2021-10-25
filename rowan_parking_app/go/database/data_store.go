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

/*func (ds *DataStore) CountSpotsTaken(vid int64, lid int64) int64 {
	//Use SelectQuerybuilder from select methods?
	//pass in count ('cols here') as a row parameter?
	//conditions: vid math, lid match, date of checkInTime in their timezone

}*/

func (ds *DataStore) CheckIfExists(tablename string, conditions []string) (int64, error) {
	var query strings.Builder
	var err error
	var id int64

	query.WriteString("SELECT Id from " + tablename + " ")

	if conditions != nil && len(conditions) > 0 {
		for _, cond := range conditions {
			query.WriteString(cond + " ")
		}
	}

	query.WriteString(";")

	result := ds.QueryRow(query.String())

	err = result.Scan(&id)

	if err != nil {
		return -1, fmt.Errorf("Check if Exists Query: %v", err)
	}

	return id, nil

}
