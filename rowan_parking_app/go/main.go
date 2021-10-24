//Author: Matt Williams
//Version: 10/19/2021
//contains the main function for our go backend.

package main

func main() {
	var database DataStore
	database.InitDB()

	var api API
	api.InitAPI(&database)
	api.StartListening()
}
