package models

type CheckInPayload struct {
	UserId int64 `json:"UserId"`
}

type LotRatingPayload struct {
	UserId int64 `json:"UserId"`
	Review int64 `json:"Review"`
}

type BugReportPayload struct {
	UserId    int64  `json:"UserId"`
	BugReport string `json:"BugReport"`
}

type RegisterUserPayload struct {
	UserName string `json:"UserName"`
	VenueId  int64  `json:"VenueId"`
}

type GetLotResponse struct {
	SpotsTaken int64 `json:"SpotsTaken"`
	LotInfo    Lot   `json:"LotInfo"`
}

type PostCheckInResponse struct {
	SpotsTaken  int64        `json:"SpotsTaken"`
	CheckInInfo Lot_Check_in `json:"CheckInInfo"`
}

type PostVenuePayload struct {
	VenueName string  `json:"VenueName"`
	Latitude  float64 `json:"Latitude"`
	Longitude float64 `json:"Longitude"`
	Timezone  string  `json:"Timezone"`
}

type PostLotTypePayload struct {
	TypeName string `json:"TypeName"`
	Rules    string `json:"Rules"`
}

type PostLotPayload struct {
	LotName        string `json:"LotName"`
	LotDescription string `json:"LotDescription"`
	LotType        int64  `json:"LotType"`
	NumSpaces      int64  `json:"NumSpaces"`
	SpecificRules  string `json:"SpecificRules"`

	//BoundingBox type? `json:"BoundingBox"`
	//LotLocation type? `json:"LotLocation"`
}
