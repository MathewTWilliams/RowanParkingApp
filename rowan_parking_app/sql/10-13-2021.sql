/*Changes made to the database on 10-13-2021
    - Gave all Spatial data related Columns an SRID of
        3857 so they are defined as Web Mercator coordinates.]
    

  Changes made on 11/8/2021
    - BoundingBox and LotLocation are now allowed to be defaulted to NULL.*/

USE RowanParkingApp; 

ALTER TABLE Venues
MODIFY VenueLocation POINT  SRID 3857; 

ALTER TABLE Lots
MODIFY BoundingBox Polygon SRID 3857, 
MODIFY LotLocation Point SRID 3857; 



