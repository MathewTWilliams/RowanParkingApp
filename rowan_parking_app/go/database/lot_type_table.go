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

		err = rows.Scan(&lot_type.Id, &lot_type.TypeName, &lot_type.Rules)
		if err != nil {
			return nil, fmt.Errorf("GetLotTypes: %v", err)
		}

		lot_types = append(lot_types, lot_type)
	}

	return lot_types, nil

}
