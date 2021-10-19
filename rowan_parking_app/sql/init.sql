/* This script is used to intialize the database. */

CREATE DATABASE IF NOT EXISTS RowanParkingApp;
USE RowanParkingApp; 


CREATE TABLE IF NOT EXISTS Venues (
    Id INT NOT NULL AUTO_INCREMENT,
    VenueName VARCHAR(255) NOT NULL, 
    VenueLocation POINT, 
    PRIMARY KEY (Id));


CREATE TABLE IF NOT EXISTS Lot_Types(
    Id INT NOT NULL AUTO_INCREMENT, 
    TypeName VARCHAR(255) NOT NULL, 
    Rules VARCHAR(1020), 
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
    BoundingBox POLYGON NOT NULL, 
    LotLocation POINT NOT NULL);


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
    LastCheckIn INT NOT NULL, 
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


