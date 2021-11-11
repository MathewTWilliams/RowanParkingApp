/* This script is used to fill the database with test data*/

USE RowanParkingApp; 

INSERT INTO Venues(Id, VenueName, VenueLocation, Timezone)
VALUES(1,"Rowan University", ST_GeomFromText("POINT(-75.11 39.71)", 3857), "America/New_York"); 

INSERT INTO Lot_Types(Id, TypeName, Rules, VenueId)
VALUES(1, "Handicapped Parking", 
    "Requires a Permit or handicapped liscense plate.", 1);

INSERT INTO Lots(Id, LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, 
    LotLocation, SpecificRules)
VALUES(1, "Lot A", "Generic Description of a Parking Lot", 1, 200, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(0 0)", 3857), "");

INSERT INTO Lot_Check_ins(Id, LotId, CheckInTime, CheckOutTime,
    UserId)
VALUES(1, 1, "2021-10-04 21:25:00", "2021-10-04 21:25:01", 1);

INSERT INTO Users(Id, Settings, UserName, VenueId, LastCheckIn)
VALUES(1,'{"Text_Size": 14, "Language": "English"}', "willia137", 1, 1);

INSERT INTO Lot_Ratings(Id, UserId, LotId, TimeOfReview, Review)
VALUES(1, 1, 1, "2021-10-04 21:25:02", 5);

INSERT INTO Bugs(Id, BugReport, UserId)
VALUES(1, "The Dashboard doesn't display the correct Map.", 1);