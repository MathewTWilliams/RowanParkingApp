package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"encoding/json"
	"fmt"
)

func (ds *DataStore) SelectUsers(conditions []string) ([]models.User, error) {
	var users []models.User
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_USERS, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetUsers: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var user models.User
		var temp []byte
		var lci_null sql.NullInt64
		err = rows.Scan(&user.Id, &temp, &user.UserName, &user.VenueId, &lci_null)
		if err != nil {
			return nil, fmt.Errorf("GetUsers: %v", err)
		}

		if lci_null.Valid {
			user.LastCheckIn = lci_null.Int64
		} else {
			user.LastCheckIn = -1
		}

		var settings models.SettingsJson
		err = json.Unmarshal(temp, &settings)
		if err != nil {
			return nil, fmt.Errorf("SelectUsers: %v", err)
		}
		user.Settings = settings
		users = append(users, user)
	}

	return users, nil

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
