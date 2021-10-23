package main

import (
	"RPA/backend/models"
	"fmt"
	"strings"
)

func (ds *DataStore) InsertQueryBuilder(table string, cols []string) string {

	var query strings.Builder
	query.WriteString("Insert Into " + table + " (")
	for index, col := range cols {
		if index+1 < len(cols) {
			query.WriteString(col + ", ")
		} else {
			query.WriteString(col + ") ")
		}
	}

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

func (ds *DataStore) InsertCheckIn(checkIn models.Lot_Check_in) error {
	cols := []string{"Id", "LotId", "CheckInTime", "CheckOutTime", "UserId"}

	query := ds.InsertQueryBuilder(TABLENAME_LCI, cols)
	result, err := ds.Exec(query, checkIn.Id, checkIn.LotId,
		checkIn.CheckInTime, checkIn.CheckOutTime, checkIn.UserId)

	if err != nil {
		return fmt.Errorf("InsertCheckIn: %v", err)
	}

	_, err = result.LastInsertId()
	if err != nil {
		return fmt.Errorf("InsertCheckIn: %v", err)
	}

	return nil

}

func (ds *DataStore) InsertLotRating(rating models.Lot_Rating) error {
	cols := []string{"Id", "UserId", "LotId", "TimeOfReview", "Review"}

	query := ds.InsertQueryBuilder(TABLENAME_LR, cols)
	result, err := ds.Exec(query, rating.Id, rating.UserId,
		rating.LotId, rating.TimeOfReview, rating.Review)

	if err != nil {
		return fmt.Errorf("InsertLotRating: %v", err)
	}

	_, err = result.LastInsertId()
	if err != nil {
		return fmt.Errorf("InsertLotRating: %v", err)
	}

	return nil

}

func (ds *DataStore) InsertBugReport(bug models.Bug) error {
	cols := []string{"Id", "BugReport", "UserId"}

	query := ds.InsertQueryBuilder(TABLENAME_BUGS, cols)
	result, err := ds.Exec(query, bug.Id, bug.BugReport, bug.UserId)

	if err != nil {
		return fmt.Errorf("InsertBugReport: %v", err)
	}

	_, err = result.LastInsertId()
	if err != nil {
		return fmt.Errorf("InsertBugReport: %v", err)
	}

	return nil

}
