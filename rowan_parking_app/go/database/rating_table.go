package database

import (
	"RPA/backend/constants"
	"RPA/backend/models"
	"database/sql"
	"fmt"
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
