//Author: Matt Williams
//Version: 10/18/2021
//A script to test the functionality
//for our DataStore struct.

package main

import (
	"RPA/backend/models"
	"fmt"
	"log"
	"testing"
)

func TestVenues(t *testing.T) {
	var database DataStore
	var venues []models.Venue
	var err error

	database.InitDB()
	venues, err = database.GetVenues(nil, nil)

	if err != nil {
		t.Fatalf(err.Error())
	}

	fmt.Println("Showing Venues: ")
	for _, venue := range venues {
		fmt.Println(venue)
	}

}

func TestLotTypes(t *testing.T) {
	var database DataStore
	var lot_types []models.Lot_Type
	var err error
	database.InitDB()
	lot_types, err = database.GetLotTypes(nil, nil)

	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Showing lot Types")
	for _, lot_type := range lot_types {
		fmt.Println(lot_type)
	}
}

func TestLots(t *testing.T) {
	var database DataStore
	var lots []models.Lot
	var err error
	database.InitDB()
	lots, err = database.GetLots(nil, nil)

	if err != nil {
		t.Fatalf(err.Error())
	}

	fmt.Println("Showing lots: ")
	for _, lot := range lots {
		fmt.Println(lot)
	}

}

func TestCheckIns(t *testing.T) {
	var database DataStore
	var check_ins []models.Lot_Check_in
	var err error
	database.InitDB()
	check_ins, err = database.GetLotCheckIns(nil, nil)

	if err != nil {
		t.Fatalf(err.Error())
	}

	fmt.Println("Showing CheckIns: ")
	for _, check_in := range check_ins {
		fmt.Println(check_in)
	}

}

func TestUsers(t *testing.T) {
	var database DataStore
	var users []models.User
	var err error
	database.InitDB()
	users, err = database.GetUsers(nil, nil)

	if err != nil {
		t.Fatalf(err.Error())
	}

	fmt.Println("Showing Users: ")
	for _, user := range users {
		fmt.Println(user)
	}
}

func TestLotRatings(t *testing.T) {
	var database DataStore
	var ratings []models.Lot_Rating
	var err error
	database.InitDB()
	ratings, err = database.GetLotRatings(nil, nil)

	if err != nil {
		t.Fatalf(err.Error())
	}

	fmt.Println("Showing Lot Ratings: ")
	for _, rating := range ratings {
		fmt.Println(rating)
	}

}

func TestBugs(t *testing.T) {
	var database DataStore
	var bugs []models.Bug
	var err error
	database.InitDB()
	bugs, err = database.GetBugs(nil, nil)

	if err != nil {
		t.Fatalf(err.Error())
	}

	fmt.Println("Showing Bugs: ")
	for _, bug := range bugs {
		fmt.Println(bug)
	}

}
