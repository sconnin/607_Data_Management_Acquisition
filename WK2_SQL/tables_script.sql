/* Build Tables for 607HW2*/

/*Data available on Github: 
Base data file: https://github.com/sconnin/607HW2/blob/main/hw2_DB.csv
viewer_ratings: https://github.com/sconnin/607HW2/blob/main/m_rating.csv
viewing_hours: https://github.com/sconnin/607HW2/blob/main/m_hrs.csv
viewer_names: https://github.com/sconnin/607HW2/blob/main/viewer.csv


-- DROP TABLE IF EXISTS viewer_rating;
-- Drop TABLE IF EXISTS viewing_hrs;
-- Drop TABLE IF EXISTS viewer;

CREATE TABLE viewer(
Id integer NOT NULL,
Name  varchar(20),
PRIMARY KEY (Id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/viewer.csv'
INTO TABLE viewer
FIELDS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Id, Name)
;

CREATE TABLE viewer_rating(
Id integer PRIMARY KEY NOT NULL,
Queens_Gambit integer NOT NULL,
Emily_in_Paris integer NOT NULL,
Lucifer integer NOT NULL,
The_Umbrella_Academy integer NOT NULL,
Money_Heist integer NOT NULL,
Dark_Desire integer NOT NULL,
Friends integer NOT NULL,
The_Crown integer NOT NULL,
Ratched integer NOT NULL,
Dark integer NOT NULL,
Id2 integer NOT NULL,
FOREIGN KEY (Id2) REFERENCES viewer(Id)
)
;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/m_rating.csv'
INTO TABLE viewer_rating
FIELDS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Id,
Queens_Gambit,
Emily_in_Paris,
Lucifer,
The_Umbrella_Academy,
Money_Heist,
Dark_Desire,
Friends,
The_Crown,
Ratched,
Dark,
Id2)
;

CREATE TABLE viewing_hrs(
Id integer NOT NULL,
Viewing_Hours integer NOT NULL,
Id2 integer NOT NULL,
PRIMARY KEY (Id),
FOREIGN KEY (Id2) REFERENCES viewer(Id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/m_hrs.csv'
INTO TABLE viewing_hrs
FIELDS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Id, Viewing_Hours, Id2)
;

