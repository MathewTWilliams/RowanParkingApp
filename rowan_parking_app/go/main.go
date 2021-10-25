//Author: Matt Williams
//Version: 10/19/2021
//contains the main function for our go backend.

package main

import (
	api "RPA/backend/api"
	db "RPA/backend/database"
)

func main() {
	var database db.DataStore
	database.InitDB()

	var api api.API
	api.InitAPI(&database)
	api.StartListening()
}
