package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/go-sql-driver/mysql"
)

//TODO: figure out a way to use Generics in Go in order to reduce the amount of boilerplate code.

func GetAndPrintVenues(db *sql.DB) {
	var venues []Venue
	venues, err := GetVenues(db)
	if err != nil {
		log.Fatal(err)
	} else {
		for _, venue := range venues {
			fmt.Println(venue)
		}
	}
}

func GetAndPrintLotTypes(db *sql.DB) {
	var lotTypes []Lot_Type
	lotTypes, err := GetLotTypes(db)
	if err != nil {
		log.Fatal(err)
	} else {
		for _, lotType := range lotTypes {
			fmt.Println(lotType)
		}
	}
}

func GetAndPrintLots(db *sql.DB) {
	var lots []Lot
	lots, err := GetLots(db)
	if err != nil {
		log.Fatal(err)
	} else {
		for _, lot := range lots {
			fmt.Println(lot)
		}
	}
}

func GetAndPrintLotCheckins(db *sql.DB) {
	var check_ins []Lot_Check_in
	check_ins, err := GetLotCheckins(db)
	if err != nil {
		log.Fatal(err)
	} else {
		for _, check_in := range check_ins {
			fmt.Println(check_in)
		}
	}
}

func GetAndPrintUsers(db *sql.DB) {
	var users []User
	users, err := GetUsers(db)
	if err != nil {
		log.Fatal(err)
	} else {
		for _, user := range users {
			fmt.Println(user)
		}
	}
}

func GetandPrintLotRatings(db *sql.DB) {
	var reviews []Lot_Rating
	reviews, err := GetLotRatings(db)
	if err != nil {
		log.Fatal(err)
	} else {
		for _, review := range reviews {
			fmt.Println(review)
		}
	}
}

func GetAndPrintBugs(db *sql.DB) {
	var bugs []Bug
	bugs, err := GetBugs(db)
	if err != nil {
		log.Fatal(err)
	} else {
		for _, bug := range bugs {
			fmt.Println(bug)
		}
	}
}

func main() {
	var db *sql.DB
	fmt.Println("MySQL Demo!")

	//Connection Properties
	cfg := mysql.Config{
		User:                 os.Getenv("DBUSER"),
		Passwd:               os.Getenv("DBPASS"),
		Net:                  "tcp",
		Addr:                 "127.0.0.1:3306",
		DBName:               "RowanParkingApp",
		AllowNativePasswords: true,
		ParseTime:            true,
	}

	//Get Database handle.
	var err error
	db, err = sql.Open("mysql", cfg.FormatDSN())

	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")

	GetAndPrintVenues(db)
	GetAndPrintLotTypes(db)
	GetAndPrintLots(db)
	GetAndPrintLotCheckins(db)
	GetAndPrintUsers(db)
	GetandPrintLotRatings(db)
	GetAndPrintBugs(db)
}
