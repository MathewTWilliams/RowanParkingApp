package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"
)

func (ds *DataStore) SelectLotTypes(columns []string, conditions []string) ([]models.Lot_Type, error) {
	var lot_types []models.Lot_Type
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_LT, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLotTypes: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lot_type models.Lot_Type

		err = rows.Scan(&lot_type.Id, &lot_type.TypeName, &lot_type.Rules, &lot_type.VenueId)
		if err != nil {
			return nil, fmt.Errorf("GetLotTypes: %v", err)
		}

		lot_types = append(lot_types, lot_type)
	}

	return lot_types, nil

}

func (ds *DataStore) InsertLotType(lot_type models.Lot_Type) (int64, error) {
	var err error
	cols := []string{"Id", "TypeName", "Rules", "VenueId"}

	query := ds.InsertQueryBuilder(constants.TABLENAME_LT, cols)

	result, err := ds.Exec(query, lot_type.Id, lot_type.TypeName, lot_type.Rules, lot_type.VenueId)
	if err != nil {
		return -1, fmt.Errorf("InsertLotType: %v", err)
	}

	lt_id, err := result.LastInsertId()
	if err != nil {
		return -1, fmt.Errorf("InsertLotType: %v", err)
	}

	return lt_id, nil

}
