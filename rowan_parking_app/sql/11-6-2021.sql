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


USE RowanParking App; 


Alter Table Venues
ADD Timezone VARCHAR(100) NOT NULL; 


Update Venues
Set Timezone = "America/New_York"
Where Id = 1;