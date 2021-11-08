package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"
)

func (ds *DataStore) SelectBugs(conditions []string) ([]models.Bug, error) {
	var bugs []models.Bug
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_BUGS, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetBugs: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var bug models.Bug

		err = rows.Scan(&bug.Id, &bug.BugReport, &bug.UserId)
		if err != nil {
			return nil, fmt.Errorf("GetBugs: %v", err)
		}

		bugs = append(bugs, bug)
	}

	return bugs, nil

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
