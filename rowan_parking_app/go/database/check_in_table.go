package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"
	"strconv"
	"strings"
)

func (ds *DataStore) SelectLotCheckIns(columns []string, conditions []string) ([]models.Lot_Check_in, error) {
	var check_ins []models.Lot_Check_in
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_LCI, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("SelectLotCheckIns: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lci models.Lot_Check_in

		err = rows.Scan(&lci.Id, &lci.LotId, &lci.CheckInTime, &lci.CheckOutTime,
			&lci.UserId)
		if err != nil {
			return nil, fmt.Errorf("SelectLotCheckIns: %v", err)
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

//A much more specific select function that returns all columns of Lot_Check_ins
//where the check_ins are associated with the given venue. Enter a negative value for l_id
//if you want all Lot Checkins for all lots in the given venue. Otherwise the method
//will return the checkins for only a specific lot at the given venue.
func (ds *DataStore) SelectLotCheckIns_Specific(v_id string, l_id string) ([]models.Lot_Check_in, error) {

	var err error
	var check_ins []models.Lot_Check_in
	var builder strings.Builder
	table_name := constants.TABLENAME_LCI
	builder.WriteString("Select " + table_name + ".* from ")
	builder.WriteString("(" + table_name + " inner join Users on ")
	builder.WriteString(table_name + ".UserId = Users.Id) as Q1 ")
	builder.WriteString("Where Q1.VenueId = " + v_id)
	if l_id != "" {
		builder.WriteString(" And Where Q1.LotId = " + l_id)
	}
	builder.WriteString(";")
	rows, err := ds.Query(builder.String())

	if err != nil {
		return nil, fmt.Errorf("SelectLotCheckIns_Venue: %v", err)
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