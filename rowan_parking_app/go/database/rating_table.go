package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"
	"strings"
)

func (ds *DataStore) SelectLotRatings(columns []string, conditions []string) ([]models.Lot_Rating, error) {
	var ratings []models.Lot_Rating
	var err error
	var rows *sql.Rows

	rows, err = ds.DB.Query(ds.SelectQueryBuilder(constants.TABLENAME_LR, columns, conditions))

	if err != nil {
		return nil, fmt.Errorf("GetLotRatings: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var rating models.Lot_Rating

		err = rows.Scan(&rating.Id, &rating.UserId, &rating.LotId,
			&rating.TimeOfReview, &rating.Review)
		if err != nil {
			return nil, fmt.Errorf("GetLotRatings: %v", err)
		}

		ratings = append(ratings, rating)
	}

	return ratings, nil

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

func (ds *DataStore) SelectLotRatings_Specific(v_id string, l_id string) ([]models.Lot_Rating, error) {
	var err error
	var ratings []models.Lot_Rating
	var builder strings.Builder
	table_name := constants.TABLENAME_LR

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
		return nil, fmt.Errorf("SelectLotRatings_Specific: %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var lr models.Lot_Rating

		err = rows.Scan(&lr.Id, &lr.UserId, &lr.LotId,
			&lr.TimeOfReview, &lr.Review)

		if err != nil {
			return nil, fmt.Errorf("SelectLotRatings_Specific: %v", err)
		}

		ratings = append(ratings, lr)
	}

	return ratings, nil
}
