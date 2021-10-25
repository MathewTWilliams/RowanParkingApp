/*Changes made to the database: 
    - Database now allows the backend to insert a User into the User Table with a
    a LastCheckIn Value of Null
 */

 Use RowanParkingApp; 

 ALTER TABLE Users
 MODIFY LastCheckIn INT NULL;
