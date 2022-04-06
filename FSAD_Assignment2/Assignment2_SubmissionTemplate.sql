/*
* File: Assignment2_SubmissionTemplate.sql
* 
* 1) Rename this file according to the instructions in the assignment statement.
* 2) Use this file to insert your solution.
*
*
* Author: Ahmed, Omar
* Student ID Number: 2308493
* Institutional mail prefix: oxa193
*/


/*
*  Assume a user account 'fsad' with password 'fsad2022' with permission
* to create  databases already exists. You do NO need to include the commands
* to create the user nor to give it permission in you solution.
* For your testing, the following command may be used:
*
* CREATE USER fsad PASSWORD 'fsad2022' CREATEDB;
* GRANT pg_read_server_files TO fsad;
*/


/* *********************************************************
* Exercise 1. Create the Smoked Trout database
* 
************************************************************ */

-- The first time you login to execute this file with \i it may
-- be convenient to change the working directory.
\cd 'YOUR WORKING DIRECTORY HERE'
  -- In PostgreSQL, folders are identified with '/'


-- 1) Create a database called SmokedTrout.
CREATE DATABASE SmokedTrout
	WITH OWNER = fsad
	ENCODING = 'UTF8'
	CONNECTION LIMIT = -1;

-- 2) Connect to the database
\c smokedtrout fsad


/* *********************************************************
* Exercise 2. Implement the given design in the Smoked Trout database
* 
************************************************************ */

--Initially set up including all tables and their attributes:

-- 1) Create a new ENUM type called materialState for storing the raw material state
CREATE TYPE materialState AS ENUM ('Solid', 'Liquid', 'Gas', 'Plasma');

-- 2) Create a new ENUM type called materialComposition for storing whether
-- a material is Fundamental or Composite.
CREATE TYPE materialComposition AS ENUM ('Fundamental', 'Composite');

-- 3) Create the table TradingRoute with the corresponding attributes.
CREATE TABLE TradingRoute (
	MonitoringKey SERIAL NOT NULL,
 	FleetSize integer,
 	OperatingCompany varchar(40),
 	LastYearRevenue real NOT NULL,
 	PRIMARY KEY (MonitoringKey)
);

-- 4) Create the table Planet with the corresponding attributes.
CREATE TABLE Planet (
	PlanetID SERIAL NOT NULL,
	StarSystem varchar(30),
	PlanetName varchar(30),
	Population integer,
	PRIMARY KEY (PlanetID)
);

-- 5) Create the table SpaceStation with the corresponding attributes.
CREATE TABLE SpaceStation (
	StationID SERIAL NOT NULL,
	PlanetID SERIAL NOT NULL,
	StationName varchar(40),
	Longitude varchar(20),
	Latitude varchar(20),
	PRIMARY KEY (StationID)
);

-- 6) Create the parent table Product with the corresponding attributes.
CREATE TABLE Product (
	ProductID SERIAL NOT NULL,
	ProductName varchar(30),
	VolumePerTon real,
	ValuePerTon real,
	PRIMARY KEY (ProductID)
);
-- 7) Create the child table RawMaterial with the corresponding attributes.
CREATE TABLE RawMaterial (
	FundamentalOrComposite varchar(3),
	State varchar(6)
) INHERITS (Product);

-- 8) Create the child table ManufacturedGood. 
CREATE TABLE ManufacturedGood (
) INHERITS (Product);

-- 9) Create the table MadeOf with the corresponding attributes.
CREATE TABLE MadeOf (
	ManufacturedGoodID SERIAL NOT NULL,
	ProductID SERIAL NOT NULL
);

-- 10) Create the table Batch with the corresponding attributes.
CREATE TABLE Batch (
	BatchID SERIAL NOT NULL,
	ProductID SERIAL NOT NULL REFERENCES Product(ProductID),
	ExtractionOrManufacturingDate date,
	OriginalFrom SERIAL NOT NULL REFERENCES Planet(PlanetID),
	PRIMARY KEY (BatchID)
);

-- 11) Create the table Sells with the corresponding attributes.
CREATE TABLE Sells (
	BatchID SERIAL NOT NULL REFERENCES Batch(BatchID),
	StationID SERIAL NOT NULL REFERENCES SpaceStation(StationID)
);

-- 12)  Create the table Buys with the corresponding attributes.
--Needs testing whether SERIAL or integer is better
CREATE TABLE Buys (
	BatchID integer NOT NULL REFERENCES Batch(BatchID),
	StationID integer NOT NULL REFERENCES SpaceStation(StationID)
);

-- 13)  Create the table CallsAt with the corresponding attributes.
CREATE TABLE CallsAt (
	MonitoringKey integer NOT NULL REFERENCES TradingRoute(MonitoringKey),
	StationID integer NOT NULL REFERENCES SpaceStation(StationID),
	VisitOrder integer NOT NULL
);

-- 14)  Create the table Distance with the corresponding attributes.
CREATE TABLE Distance (
	PlanetOrigin integer NOT NULL REFERENCES Planet(PlanetID),
	PlanetDestination integer NOT NULL REFERENCES Planet(PlanetID),
	Distance real
);

--Creating all Foreign Key Relationships:


/* *********************************************************
* Exercise 3. Populate the Smoked Trout database
* 
************************************************************ */
/* *********************************************************
* NOTE: The copy statement is NOT standard SQL.
* The copy statement does NOT permit on-the-fly renaming columns,
* hence, whenever necessary, we:
* 1) Create a dummy table with the column name as in the file
* 2) Copy from the file to the dummy table
* 3) Copy from the dummy table to the real table
* 4) Drop the dummy table (This is done further below, as I keep
*    the dummy table also to imporrt the other columns)
************************************************************ */



-- 1) Unzip all the data files in a subfolder called data from where you have your code file 
-- NO CODE GOES HERE. THIS STEP IS JUST LEFT HERE TO KEEP CONSISTENCY WITH THE ASSIGNMENT STATEMENT

-- 2) Populate the table TradingRoute with the data in the file TradeRoutes.csv.

-- 3) Populate the table Planet with the data in the file Planets.csv.

-- 4) Populate the table SpaceStation with the data in the file SpaceStations.csv.

-- 5) Populate the tables RawMaterial and Product with the data in the file Products_Raw.csv. 

-- 6) Populate the tables ManufacturedGood and Product with the data in the file  Products_Manufactured.csv.

-- 7) Populate the table MadeOf with the data in the file MadeOf.csv.

-- 8) Populate the table Batch with the data in the file Batches.csv.

-- 9) Populate the table Sells with the data in the file Sells.csv.

-- 10) Populate the table Buys with the data in the file Buys.csv.

-- 11) Populate the table CallsAt with the data in the file CallsAt.csv.

-- 12) Populate the table Distance with the data in the file PlanetDistances.csv.





/* *********************************************************
* Exercise 4. Query the database
* 
************************************************************ */

-- 4.1 Report last year taxes per company

-- 1) Add an attribute Taxes to table TradingRoute

-- 2) Set the derived attribute taxes as 12% of LastYearRevenue

-- 3) Report the operating company and the sum of its taxes group by company.




-- 4.2 What's the longest trading route in parsecs?

-- 1) Create a dummy table RouteLength to store the trading route and their lengths.

-- 2) Create a view EnrichedCallsAt that brings together trading route, space stations and planets.

-- 3) Add the support to execute an anonymous code block as follows;

-- 4) Within the declare section, declare a variable of type real to store a route total distance.

-- 5) Within the declare section, declare a variable of type real to store a hop partial distance.

-- 6) Within the declare section, declare a variable of type record to iterate over routes.

-- 7) Within the declare section, declare a variable of type record to iterate over hops.

-- 8) Within the declare section, declare a variable of type text to transiently build dynamic queries.

-- 9) Within the main body section, loop over routes in TradingRoutes

-- 10) Within the loop over routes, get all visited planets (in order) by this trading route.

-- 11) Within the loop over routes, execute the dynamic view

-- 12) Within the loop over routes, create a view Hops for storing the hops of that route. 

-- 13) Within the loop over routes, initialize the route total distance to 0.0.

-- 14) Within the loop over routes, create an inner loop over the hops

-- 15) Within the loop over hops, get the partial distances of the hop. 

-- 16)  Within the loop over hops, execute the dynamic view and store the outcome INTO the hop partial distance.

-- 17)  Within the loop over hops, accumulate the hop partial distance to the route total distance.

-- 18)  Go back to the routes loop and insert into the dummy table RouteLength the pair (RouteMonitoringKey,RouteTotalDistance).

-- 19)  Within the loop over routes, drop the view for Hops (and cascade to delete dependent objects).

-- 20)  Within the loop over routes, drop the view for PortsOfCall (and cascade to delete dependent objects).

-- 21)  Finally, just report the longest route in the dummy table RouteLength.
