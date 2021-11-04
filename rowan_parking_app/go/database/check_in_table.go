package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"
	"strconv"
)

func (ds *DataStore) SelectLotCheckIns(columns []string, conditions []string) ([]models.Lot_Check_in, error) {
	var check_ins []models.Lot_Check_in
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_LCI, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLotCheckIns: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lci models.Lot_Check_in

		err = rows.Scan(&lci.Id, &lci.LotId, &lci.CheckInTime, &lci.CheckOutTime,
			&lci.UserId)
		if err != nil {
			return nil, fmt.Errorf("GetLotCheckIns: %v", err)
		}

		check_ins = append(check_ins, lci)
	}

	return check_ins, nil

}

func (ds *DataStore) InsertCheckIn(checkIn models.Lot_Check_in) (int64, error) {
	cols := []string{"Id", "LotId", "CheckInTime", "CheckOutTime", "UserId"}

	query := ds.InsertQueryBuilder(constants.TABLENAME_LCI, cols)

	result, err := ds.Exec(query, checkIn.Id, checkIn.LotId,
		checkIn.CheckInTime, nil, checkIn.UserId)

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

	return id, nil

}
