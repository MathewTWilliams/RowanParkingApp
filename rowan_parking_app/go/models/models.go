//Author: Matt Williams
//Version: 10/18/2021
//Go script that contains the stucture of our json and database formats.
package models

import (
	"time"

	geom "github.com/twpayne/go-geom"
)

type SettingsJson struct {
	TextSize int64  `json:"Text_Size"`
	Language string `json:"Language"`
}

type Venue struct {
	Id            int64
	VenueName     string
	VenueLocation *geom.Point
}

type Lot_Type struct {
	Id       int64
	TypeName string
	Rules    string
}

type Lot struct {
	Id             int64
	LotName        string
	LotDescription string
	LotType        int64
	NumSpaces      int64
	VenueId        int64
	SpecificRules  string
	BoundingBox    *geom.Polygon
	LotLocation    *geom.Point
}

type Lot_Check_in struct {
	Id           int64
	LotId        int64
	CheckInTime  time.Time
	CheckOutTime time.Time
	Userid       int64
}

type User struct {
	Id          int64
	Settings    SettingsJson
	UserName    string
	VenueId     int64
	LastCheckIn int64
}

type Lot_Rating struct {
	Id           int64
	UserId       int64
	LotId        int64
	TimeOfReview time.Time
	Review       int64
}

type Bug struct {
	Id        int64
	BugReport string
	UserId    int64
}
