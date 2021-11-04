//Author: Matt Williams
//Version: 10/19/2021
//Go script that contains the stucture of our json and database formats.
package models

import (
	"time"
)

type SettingsJson struct {
	TextSize int64  `json:"Text_Size"`
	Language string `json:"Language"`
}

type Lot_Type struct {
	Id       int64  `json:"Id"`
	TypeName string `json:"TypeName"`
	Rules    string `json:"Rules"`
	VenueId  int64  `json:"VenueId"`
}

type Lot_Check_in struct {
	Id           int64     `json:"Id"`
	LotId        int64     `json:"LotId"`
	CheckInTime  time.Time `json:"CheckInTime"`
	CheckOutTime time.Time `json:"CheckOutTime"`
	UserId       int64     `json:"Userid"`
}

type User struct {
	Id          int64        `json:"Id"`
	Settings    SettingsJson `json:"Settings"`
	UserName    string       `json:"UserName"`
	VenueId     int64        `json:"VenueId"`
	LastCheckIn int64        `json:"LastCheckIn"`
}

type Lot_Rating struct {
	Id           int64     `json:"Id"`
	UserId       int64     `json:"UserId"`
	LotId        int64     `json:"LotId"`
	TimeOfReview time.Time `json:"TimeOfReview"`
	Review       int64     `json:"Review"`
}

type Bug struct {
	Id        int64  `json:"Id"`
	BugReport string `json:"BugReport"`
	UserId    int64  `json:"UserId"`
}
