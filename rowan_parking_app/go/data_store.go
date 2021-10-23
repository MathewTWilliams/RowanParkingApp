//Author: Matt Willaims
//Version: 10/18/2021
//This script contains the core code for our database connection to the
//mysql database.

package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

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

//func (ds *DataStore) CheckIfExists(tablename string, cols []string, conditions []string) (bool, error) {
//	var builder string.Builder

//}
