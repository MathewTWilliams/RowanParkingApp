/* This script is used to intialize the database. */


/*Changes made to the database on 11/3/2021
    - Gave the Lot_Types Table a new Column, Venue_Id
    - Made the column a foreign key*/
    
/*Changes made to the database on 11/6/2021
    - Gave the Venues table a new Column, Timezone.
    - This timezone has been added because time is used
        in order to "reset" the count for the lots.
    - Once a new day begins, the db will only count
        check_ins from that day toward the lot counts,
        given that a check_out from the same user that day hasn't already occurred.
    - The time used needs to be in the correct timezone 
        based on the Venue a user is at. 
    - We can't just use UTC time. For example, when UTC time reaches 12:00 AM for the 
        following day, it may only be 4:00PM on the previous day here are Rowan, so
        it wouldn't be beneficial for the app to "reset" counts at Rowan. */ 


CREATE DATABASE IF NOT EXISTS RowanParkingApp;
USE RowanParkingApp; 


CREATE TABLE IF NOT EXISTS Venues (
    Id INT NOT NULL AUTO_INCREMENT,
    VenueName VARCHAR(255) NOT NULL, 
    VenueLocation POINT SRID 3857, 
    Timezone VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id));


CREATE TABLE IF NOT EXISTS Lot_Types(
    Id INT NOT NULL AUTO_INCREMENT, 
    TypeName VARCHAR(255) NOT NULL, 
    Rules VARCHAR(1020), 
    VenueId INT NOT NULL, 
    FOREIGN Key (VenueId) REFERENCES Venues(Id),
    PRIMARY KEY(Id));



CREATE TABLE IF NOT EXISTS Lots (
    Id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),
    LotName VARCHAR(255) NOT NULL, 
    LotDescription VARCHAR(255), 
    LotType INT NOT NULL, 
    FOREIGN KEY(LotType) REFERENCES Lot_Types(Id),
    NumSpaces INT NOT NULL, 
    VenueId INT NOT NULL, 
    FOREIGN KEY (VenueId) REFERENCES Venues(Id),
    SpecificRules VARCHAR(510), 
    BoundingBox POLYGON SRID 3857, 
    LotLocation POINT SRID 3857);


CREATE TABLE IF NOT EXISTS Lot_Check_ins (
    Id INT NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (Id),
    LotId INT NOT NULL, 
    FOREIGN KEY(LotId) REFERENCES Lots(Id), 
    CheckInTime DATETIME NOT NULL, 
    CheckOutTime DATETIME, 
    UserId INT NOT NULL);


CREATE TABLE IF NOT EXISTS Users (
    Id Int NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (Id),
    Settings JSON NOT NULL, 
    UserName VARCHAR(255) NOT NULL, 
    VenueId INT NOT NULL, 
    FOREIGN KEY(VenueId) REFERENCES Venues(Id), 
    LastCheckIn INT NULL, 
    FOREIGN KEY(LastCheckIn) REFERENCES Lot_Check_ins(Id));


CREATE TABLE IF NOT EXISTS Lot_Ratings(
    Id INT NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY(Id),
    UserId INT NOT NULL, 
    FOREIGN KEY(UserId) REFERENCES Users(Id), 
    LotId INT NOT NULL, 
    FOREIGN KEY(LotId) REFERENCES Lots(Id), 
    TimeOfReview DATETIME NOT NULL, 
    Review Int NOT NULL);



CREATE TABLE IF NOT EXISTS Bugs(
    Id INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (Id),  
    BugReport VARCHAR(510) NOT NULL, 
    UserId INT NOT NULL, 
    FOREIGN KEY (UserId) REFERENCES Users(Id));


