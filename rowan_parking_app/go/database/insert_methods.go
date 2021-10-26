package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
)

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

func (ds *DataStore) InsertCheckIn(checkIn models.Lot_Check_in) (int64, error) {
	cols := []string{"Id", "LotId", "CheckInTime", "CheckOutTime", "UserId"}

	query := ds.InsertQueryBuilder(constants.TABLENAME_LCI, cols)
	result, err := ds.Exec(query, checkIn.Id, checkIn.LotId,
		checkIn.CheckInTime, checkIn.CheckOutTime, checkIn.UserId)

	if err != nil {
		return -1, fmt.Errorf("InsertCheckIn: %v", err)
	}

	id, err := result.LastInsertId()
	if err != nil {
		return -1, fmt.Errorf("InsertCheckIn: %v", err)
	}

	cols_vals := []string{"LastCheckIn = " + strconv.FormatInt(id, 10)}
	conds := []string{"Where Id = " + strconv.FormatInt(checkIn.UserId, 10)}

	err = ds.UpdateValues(constants.TABLENAME_USERS, cols_vals, conds)
	if err != nil {
		return -1, fmt.Errorf("InsertCheckIn: %v", err)
	}
	//update Users LastCheckIn value
	return id, nil

}

func (ds *DataStore) InsertLotRating(rating models.Lot_Rating) (int64, error) {
	cols := []string{"Id", "UserId", "LotId", "TimeOfReview", "Review"}

	query := ds.InsertQueryBuilder(constants.TABLENAME_LR, cols)
	result, err := ds.Exec(query, rating.Id, rating.UserId,
		rating.LotId, rating.TimeOfReview, rating.Review)

	if err != nil {
		return -1, fmt.Errorf("InsertLotRating: %v", err)
	}

	id, err := result.LastInsertId()
	if err != nil {
		return -1, fmt.Errorf("InsertLotRating: %v", err)
	}

	return id, nil

}

func (ds *DataStore) InsertBugReport(bug models.Bug) (int64, error) {
	cols := []string{"Id", "BugReport", "UserId"}

	query := ds.InsertQueryBuilder(constants.TABLENAME_BUGS, cols)
	result, err := ds.Exec(query, bug.Id, bug.BugReport, bug.UserId)

	if err != nil {
		return -1, fmt.Errorf("InsertBugReport: %v", err)
	}

	bid, err := result.LastInsertId()
	if err != nil {
		return -1, fmt.Errorf("InsertBugReport: %v", err)
	}

	return bid, nil

}

func (ds *DataStore) InsertUser(user models.User) (int64, error) {
	var err error
	cols := []string{"Id", "Settings", "UserName", "VenueId", "LastCheckIn"}

	var json_bytes []byte
	json_bytes, err = json.Marshal(user.Settings)

	if err != nil {
		return -1, fmt.Errorf("insert user error: %v", err)
	}

	query := ds.InsertQueryBuilder(constants.TABLENAME_USERS, cols)
	result, err := ds.Exec(query, user.Id, json_bytes,
		user.UserName, user.VenueId, nil)
	if err != nil {
		return -1, fmt.Errorf("insert user error: %v", err)
	}

	uid, err := result.LastInsertId()
	if err != nil {
		return -1, fmt.Errorf("insert user error: %v", err)
	}

	return uid, nil

}
