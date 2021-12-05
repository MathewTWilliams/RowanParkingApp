/* This script is used to fill the database with test data*/

USE RowanParkingApp; 



/*Venues*/
INSERT INTO Venues(VenueName, VenueLocation, Timezone)
VALUES("Rowan University", ST_GeomFromText("POINT(-75.1177295291 39.7065471738)", 3857), "America/New_York"); 

/*Lot_Types*/

INSERT INTO Lot_Types(TypeName, Rules, VenueId)
VALUES("Commuters","No parking allowed from 2:00 am - 6:00am.",1);

INSERT INTO Lot_Types(TypeName, Rules, VenueId)
VALUES("Residents","Commuters may park in these lots, but not from 2:00 am - 6:00 am",1);

INSERT INTO Lot_Types(TypeName, Rules, VenueId)
VALUES("Garages","Each garage has its own Parking Permit.",1);

INSERT INTO Lot_Types(TypeName, Rules, VenueId)
VALUES("Employees","",1);


/*Lots*/
/*Majority of Parking Space totals obtained from: https://sites.rowan.edu/facilities/_docs/Planning/15-03-31_Rowan_University_Parking_Study_Final.pdf*/

/*Employee Lots*/
INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot A-1", "Employee Parking", 4, 104, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.123723 39.710565)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot A-2", "Employee Parking", 4, 20, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.121839 39.710034)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot C-1", "Employee Parking", 4, 10, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.118585 39.713889)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot D-2", "Employee Parking", 4, 66, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.122156 39.713621)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot E", "Employee Parking", 4, 85, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.120843 39.707674)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot G", "Employee Parking", 4, 29, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.121678 39.708710)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot H", "Employee Parking", 4, 83, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.119450 39.708310)", 3857), 
    "Commuters may park in this lot Monday-Friday from 4:30pm till 12:00am.\n
    Visitors without a pass can park in this lot for 45 minutes. ");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot H-1", "Employee Parking", 4, 50, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.118813 39.707691)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot M", "Employee Parking", 4, 60, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.118352 39.711120)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot N", "Employee Parking", 4, 8, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.123264 39.706073)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot O-1", "Employee Parking", 4, 300, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.120383 39.712506)", 3857), 
    "Commuters may park in this lot Monday-Friday from 4:30pm till 12:00am.");
    
INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot O-2", "Employee Parking", 4, 10, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.121637 39.712145)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot P", "Employee Parking", 4, 167, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.119215 39.706032)", 3857), 
    "Commuters may park in this lot Monday-Friday from 4:30pm till 12:00am.");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot S", "Employee Parking", 4, 20, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.118416 39.706763)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot Shpeen", "Employee Parking", 4, 83, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.108698 39.703803)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot T", "Employee Parking", 4, 12, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.116395 39.706518)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot U", "Employee Parking", 4, 34, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.116388 39.708022)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot Z-1", "Employee Parking", 4, 58, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.122049 39.708251)", 3857), 
    "Commuters may park in this lot Monday-Friday from 4:30pm till 12:00am.");


/*Commuter Lots*/
INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot A", "Commuter Parking", 1, 86, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.124116 39.710894)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot B-1", "Commuter Parking", 1, 220, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.117838 39.712892)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot C", "Commuter Parking", 1, 222, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.119734 39.714774)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot D", "Commuter Parking", 1, 205, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.121441 39.714961)", 3857), "");

    
INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot D-1", "Commuter Parking", 1, 125, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.122743 39.713947)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot F-1", "Commuter Parking", 1, 15, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.127033 39.711685)", 3857), "");



INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot J", "Commuter Parking", 1, 176, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.114802 39.708436)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot O", "Commuter Parking", 1, 270, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.119406 39.712925)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot R", "Commuter Parking", 1, 50, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.120021 39.705614)", 3857), "");

    
INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot Y", "Commuter Parking", 1, 50, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.122080 39.706061)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot 411 Ellis St.", "Commuter Parking", 1, 200, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.120106 39.701837)", 3857), "");

/*Resident Lots*/
INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot B", "Commuter Parking", 2, 325, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.116764 39.712052)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Chesnut Lot", "Commuter Parking", 2, 102, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.113617 39.709892)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Chesnut-1 Lot", "Commuter Parking", 2, 40, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.113042 39.709406)", 3857), "");

INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Edgewood Lot", "Commuter Parking", 2, 260, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.115355 39.711223)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Triad Lot-F", "Commuter Parking", 2, 326, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.125021 39.711303)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Lot W", "Commuter Parking", 2, 39, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.117577 39.710262)", 3857), "");



/*Garages*/
INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Townhouse Garage", "Commuter Parking", 3, 565, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.122926 39.707757)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Rowan Boulevard Garage", "Commuter Parking", 3, 1000, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.113432 39.706117)", 3857), "");


INSERT INTO Lots(LotName, LotDescription, LotType, NumSpaces,
    VenueId, BoundingBox, LotLocation, SpecificRules)
VALUES("Mick Drive Garage", "Commuter Parking", 3, 300, 
    1, ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 3857), 
    ST_GeomFromText("POINT(-75.114822 39.703782)", 3857), "");