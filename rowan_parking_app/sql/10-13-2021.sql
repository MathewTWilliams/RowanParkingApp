/*Changes made to the database on 10-13-2021
    - Gave all Spatial data related Columns an SRID of
        3857 so they are defined as Web Mercator coordinates.
        
    - Made sure all Spatial data related columns are labeled as Not NULL.
    
    -With these two adjustments above, we can have indexing of spatial
        data related columns if needed.  */

USE RowanParkingApp; 

ALTER TABLE Venues
MODIFY VenueLocation POINT NOT NULL SRID 3857; 

ALTER TABLE Lots
MODIFY BoundingBox Polygon NOT NULL SRID 3857, 
MODIFY LotLocation Point NOT NULL SRID 3857; 



