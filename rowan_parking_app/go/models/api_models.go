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

type RegisterUserResponse struct {
	UserId int64 `json:"UserId"`
}