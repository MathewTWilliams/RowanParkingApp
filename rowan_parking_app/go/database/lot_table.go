package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"
)

func (ds *DataStore) SelectLots(conditions []string) ([]models.Lot, error) {
	var lots []models.Lot
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_LOTS, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLots: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lot models.Lot
		var tempBB []byte
		var tempLL []byte
		err = rows.Scan(&lot.Id, &lot.LotName, &lot.LotDescription, &lot.LotType,
			&lot.NumSpaces, &lot.VenueId, &lot.SpecificRules,
			&tempBB, &tempLL)
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}

		err = lot.SetBoundingBox_Bytes(tempBB)
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}

		err = lot.SetLotLocation_Bytes(tempLL)
		if err != nil {
			return nil, fmt.Errorf("GetLots: %v", err)
		}
		lots = append(lots, lot)
	}

	return lots, nil

}

func (ds *DataStore) InsertLot(lot models.Lot) (int64, error) {
	cols := []string{"Id", "LotName", "LotDescription",
		"LotType", "NumSpaces", "VenueId",
		"SpecificRules", "BoundingBox", "LotLocation"}

	query := ds.InsertQueryBuilder(constants.TABLENAME_LOTS, cols)

	result, err := ds.Exec(query, lot.Id, lot.LotName, lot.LotDescription,
		lot.LotType, lot.NumSpaces, lot.VenueId, lot.SpecificRules,
		nil, nil)

	if err != nil {
		return -1, fmt.Errorf("InsertLot: %v", err)
	}

	l_id, err := result.LastInsertId()
	if err != nil {
		return -1, fmt.Errorf("InsertLot: %v", err)
	}

	return l_id, nil
}
