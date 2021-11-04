/*Changes made to the database on 11/3/2021
    - Gave the Lot_Types Table a new Column, Venue_Id
    - Made the column a foreign key
    - Input a venue Id into the test data*/


Use RowanParkingApp

Alter Table Lot_Types
Add VenueId INT NOT NULL, 
Add FOREIGN Key (VenueId) REFERENCES Venues(Id);


Update Lot_Types
Set VenueId = 1
Where Id = 1; 