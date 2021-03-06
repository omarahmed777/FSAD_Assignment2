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
DROP DATABASE IF EXISTS "SmokedTrout";

/* *********************************************************
* Exercise 1. Create the Smoked Trout database
* 
************************************************************ */

-- The first time you login to execute this file with \i it may
-- be convenient to change the working directory.
  -- In PostgreSQL, folders are identified with '/'
\cd 'C:/Users/AnerdyArab/GitProjects/FSAD_Assignment2'

-- 1) Create a database called SmokedTrout.
CREATE DATABASE "SmokedTrout"
	WITH OWNER = fsad
	ENCODING = 'UTF8'
	CONNECTION LIMIT = -1;

-- 2) Connect to the database
\c SmokedTrout fsad


/* *********************************************************
* Exercise 2. Implement the given design in the Smoked Trout database
* 
************************************************************ */

--Initially set up including all tables and their attributes:

-- 1) Create a new ENUM type called materialState for storing the raw material state
CREATE TYPE "materialState" AS ENUM ('Solid', 'Liquid', 'Gas', 'Plasma');

-- 2) Create a new ENUM type called materialComposition for storing whether
-- a material is Fundamental or Composite.
CREATE TYPE "materialComposition" AS ENUM ('Fundamental', 'Composite');

-- 3) Create the table TradingRoute with the corresponding attributes.
CREATE TABLE "TradingRoute" (
	"MonitoringKey" SERIAL,
 	"FleetSize" integer,
 	"OperatingCompany" varchar(40),
 	"LastYearRevenue" real NOT NULL,
 	PRIMARY KEY ("MonitoringKey")
);

-- 4) Create the table Planet with the corresponding attributes.
CREATE TABLE "Planet" (
	"PlanetID" SERIAL,
	"StarSystem" varchar(40),
	"PlanetName" varchar(40),
	"Population" integer,
	PRIMARY KEY ("PlanetID")
);

-- 5) Create the table SpaceStation with the corresponding attributes.
CREATE TABLE "SpaceStation" (
	"StationID" SERIAL,
	"PlanetID" integer,
	"StationName" varchar(40),
	"Longitude" varchar(40),
	"Latitude" varchar(40),
	PRIMARY KEY ("StationID"),
	CONSTRAINT spacestation_fk_planetid
		FOREIGN KEY ("PlanetID")
			REFERENCES "Planet"("PlanetID")
			ON UPDATE CASCADE ON DELETE CASCADE NOT VALID
);

-- 6) Create the parent table Product with the corresponding attributes.
CREATE TABLE "Product" (
	"ProductID" SERIAL,
	"ProductName" varchar(40),
	"VolumePerTon" real,
	"ValuePerTon" real,
	PRIMARY KEY ("ProductID")
);
-- 7) Create the child table RawMaterial with the corresponding attributes.
CREATE TABLE "RawMaterial" (
	"FundamentalOrComposite" "materialComposition",
	"State" "materialState"
) INHERITS ("Product");

-- 8) Create the child table ManufacturedGood. 
CREATE TABLE "ManufacturedGood" (
) INHERITS ("Product");

-- 9) Create the table MadeOf with the corresponding attributes.
CREATE TABLE "MadeOf" (
	"ManufacturedGoodID" integer,
	"ProductID" integer
);

-- 10) Create the table Batch with the corresponding attributes.
CREATE TABLE "Batch" (
	"BatchID" SERIAL,
	"ProductID" integer,
	"ExtractionOrManufacturingDate" date,
	"OriginalFrom" integer,
	PRIMARY KEY ("BatchID"),
	CONSTRAINT batch_fk_originalfrom
		FOREIGN KEY ("OriginalFrom") REFERENCES "Planet"("PlanetID")
		ON UPDATE CASCADE ON DELETE CASCADE NOT VALID
);

-- 11) Create the table Sells with the corresponding attributes.
CREATE TABLE "Sells" (
	"BatchID" integer,
	"StationID" integer,
	CONSTRAINT sells_fk_batchid
		FOREIGN KEY ("BatchID") REFERENCES "Batch"("BatchID")
		ON UPDATE CASCADE ON DELETE CASCADE NOT VALID,
	CONSTRAINT sells_fk_stationid
		FOREIGN KEY ("StationID") REFERENCES "SpaceStation"("StationID")
		ON UPDATE CASCADE ON DELETE CASCADE NOT VALID
);

-- 12)  Create the table Buys with the corresponding attributes.
--Needs testing whether SERIAL or integer is better
CREATE TABLE "Buys" (
	"BatchID" integer,
	"StationID" integer,
	CONSTRAINT buys_fk_batchid
		FOREIGN KEY ("BatchID") REFERENCES "Batch"("BatchID")
		ON UPDATE CASCADE ON DELETE CASCADE NOT VALID,
	CONSTRAINT buys_fk_stationid
		FOREIGN KEY ("StationID") REFERENCES "SpaceStation"("StationID")
		ON UPDATE CASCADE ON DELETE CASCADE NOT VALID
);

-- 13)  Create the table CallsAt with the corresponding attributes.
CREATE TABLE "CallsAt" (
	"MonitoringKey" integer REFERENCES "TradingRoute"("MonitoringKey"),
	"StationID" integer REFERENCES "SpaceStation"("StationID"),
	"VisitOrder" integer
);

-- 14)  Create the table Distance with the corresponding attributes.
CREATE TABLE "Distance" (
	"PlanetOrigin" integer REFERENCES "Planet"("PlanetID"),
	"PlanetDestination" integer REFERENCES "Planet"("PlanetID"),
	"AvgDistance" real
);


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

--Creating Dummy table--
CREATE TABLE "TradeDummy" (
	"MonitoringKey" SERIAL,
	"FleetSize" integer,
	"OperatingCompany" varchar(40),
	"LastYearRevenue" real NOT NULL
);

--copying csv file contents into dummy table--
\copy "TradeDummy" from './data/TradeRoutes.csv' WITH (FORMAT CSV, HEADER);

--inserting csv file contents into TradingRoute table--
INSERT INTO "TradingRoute" ("MonitoringKey", "FleetSize", "OperatingCompany", "LastYearRevenue")
	SELECT "MonitoringKey", "FleetSize", "OperatingCompany", "LastYearRevenue" FROM "TradeDummy";

--Dropping Dummy table, repeat these steps in this order for all other populating tasks--
DROP TABLE "TradeDummy";

-- 3) Populate the table Planet with the data in the file Planets.csv.

CREATE TABLE "PlanetDummy" (
	"PlanetID" SERIAL,
	"StarSystem" varchar(40),
	"Planet" varchar(40),
	"Population_inMillions_" integer
);

\copy "PlanetDummy" FROM './data/Planets.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "Planet" ("PlanetID", "StarSystem", "PlanetName", "Population")
SELECT "PlanetID", "StarSystem", "Planet", "Population_inMillions_" FROM "PlanetDummy";

DROP TABLE "PlanetDummy";
-- 4) Populate the table SpaceStation with the data in the file SpaceStations.csv.

CREATE TABLE "StationDummy" (
	"StationID" SERIAL,
	"PlanetID" integer,
	"SpaceStations" varchar(40),
	"Longitude" varchar(40),
	"Latitude" varchar(40)
);

\copy "StationDummy" from './data/SpaceStations.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "SpaceStation" ("StationID", "PlanetID", "StationName", "Longitude", "Latitude")
	SELECT "StationID", "PlanetID", "SpaceStations", "Longitude", "Latitude" FROM "StationDummy";

DROP TABLE "StationDummy";

-- 5) Populate the tables RawMaterial and Product with the data in the file Products_Raw.csv. 

CREATE TABLE "RawDummy" (
	"ProductID" SERIAL,
	"Product" varchar(30),
	"Composite" varchar(20),
	"VolumePerTon" real,
	"ValuePerTon" real,
	"State" varchar(10)
);

\copy "RawDummy" from './data/Products_Raw.csv' WITH (FORMAT CSV, HEADER);

--Update table to use the ENUM materialComposition
UPDATE "RawDummy"
	SET "Composite" =
	CASE
		WHEN "Composite" = 'Yes' THEN "materialComposition"('Composite')
		WHEN "Composite" = 'No' THEN "materialComposition"('Fundamental')
	END;

--Update table to use the ENUM materialState
UPDATE "RawDummy"
	SET "State" =
	CASE
		WHEN "State" = 'Solid' THEN "materialState"('Solid')
		WHEN "State" = 'Liquid' THEN "materialState"('Liquid')
		WHEN "State" = 'Gas' THEN "materialState"('Gas')
		WHEN "State" = 'Plasma' THEN "materialState"('Plasma')
	END;

--Cast varchar to ENUM in the insert
INSERT INTO "RawMaterial" ("ProductID", "ProductName", "VolumePerTon", "ValuePerTon", "FundamentalOrComposite", "State")
	SELECT "ProductID", "Product", "VolumePerTon", "ValuePerTon", "Composite"::"materialComposition", "State"::"materialState" FROM "RawDummy";

DROP TABLE "RawDummy";

-- 6) Populate the tables ManufacturedGood and Product with the data in the file  Products_Manufactured.csv.

CREATE TABLE "ManufacturedDummy" (
	"ProductID" SERIAL,
	"Product" varchar(30),
	"VolumePerTon" real,
	"ValuePerTon" real
);

\copy "ManufacturedDummy" FROM './data/Products_Manufactured.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "ManufacturedGood" ("ProductID", "ProductName", "VolumePerTon", "ValuePerTon")
	SELECT "ProductID", "Product", "VolumePerTon", "ValuePerTon" FROM "ManufacturedDummy";

DROP TABLE "ManufacturedDummy";

-- 7) Populate the table MadeOf with the data in the file MadeOf.csv.

CREATE TABLE "MadeOfDummy" (
	"ManufacturedGoodID" integer,
	"ProductID" integer
);

\copy "MadeOfDummy" FROM './data/MadeOf.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "MadeOf" ("ManufacturedGoodID", "ProductID")
	SELECT "ManufacturedGoodID", "ProductID" FROM "MadeOfDummy";

DROP TABLE "MadeOfDummy";

-- 8) Populate the table Batch with the data in the file Batches.csv.

CREATE TABLE "BatchDummy" (
	"BatchID" SERIAL,
	"ProductID" integer,
	"ExtractionOrManufacturingDate" date,
	"OriginalFrom" integer
);

\copy "BatchDummy" FROM './data/Batches.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "Batch" ("BatchID", "ProductID", "ExtractionOrManufacturingDate", "OriginalFrom")
	SELECT "BatchID", "ProductID", "ExtractionOrManufacturingDate", "OriginalFrom" FROM "BatchDummy";

DROP TABLE "BatchDummy";
-- 9) Populate the table Sells with the data in the file Sells.csv.

CREATE TABLE "SellsDummy" (
	"BatchID" integer,
	"StationID" integer
);

\copy "SellsDummy" FROM './data/Sells.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "Sells" ("BatchID", "StationID")
	SELECT "BatchID", "StationID" FROM "SellsDummy";

DROP TABLE "SellsDummy";
-- 10) Populate the table Buys with the data in the file Buys.csv.

CREATE TABLE "BuysDummy" (
	"BatchID" integer,
	"StationID" integer
);

\copy "BuysDummy" FROM './data/Buys.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "Buys" ("BatchID", "StationID")
	SELECT "BatchID", "StationID" FROM "BuysDummy";

DROP TABLE "BuysDummy";
-- 11) Populate the table CallsAt with the data in the file CallsAt.csv.

CREATE TABLE "CallsAtDummy" (
	"MonitoringKey" integer,
	"StationID" integer,
	"VisitOrder" integer
);

\copy "CallsAtDummy" FROM './data/CallsAt.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "CallsAt" ("MonitoringKey", "StationID", "VisitOrder")
	SELECT "MonitoringKey", "StationID", "VisitOrder" FROM "CallsAtDummy";

DROP TABLE "CallsAtDummy";

-- 12) Populate the table Distance with the data in the file PlanetDistances.csv.

CREATE TABLE "DistanceDummy" (
	"PlanetOrigin" integer,
	"PlanetDestination" integer,
	"Distance" real
);

\copy "DistanceDummy" FROM './data/PlanetDistances.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO "Distance" ("PlanetOrigin", "PlanetDestination", "AvgDistance")
	SELECT "PlanetOrigin", "PlanetDestination", "Distance" FROM "DistanceDummy";

DROP TABLE "DistanceDummy";

/* *********************************************************
* Exercise 4. Query the database
* 
************************************************************ */

-- 4.1 Report last year taxes per company
-- 1) Add an attribute Taxes to table TradingRoute
ALTER TABLE "TradingRoute"
ADD COLUMN "Taxes" real
-- 2) Set the derived attribute taxes as 12% of LastYearRevenue
GENERATED ALWAYS AS ("LastYearRevenue" * 0.12) STORED;
-- 3) Report the operating company and the sum of its taxes group by company.
SELECT "OperatingCompany", SUM("Taxes") AS "Taxes"
	FROM "TradingRoute"
	GROUP BY "OperatingCompany";

-- 4.2 What's the longest trading route in parsecs?
-- 1) Create a dummy table RouteLength to store the trading route and their lengths.
CREATE TABLE "RouteLength" (
	"RouteMonitoringKey" integer,
	"RouteTotalDistance" real
);
-- 2) Create a view EnrichedCallsAt that brings together trading route, space stations and planets.
-- CREATE VIEW "EnrichedCallsAt" AS
-- 	SELECT "Planet"."PlanetID", "CallsAt"."MonitoringKey", "CallsAt"."VisitOrder"
-- 	FROM "Planet", "CallsAt"
-- 	INNER JOIN "SpaceStation" ON "CallsAt"."StationID" = "SpaceStation"."StationID"; 
CREATE VIEW "EnrichedCallsAt" AS
	SELECT "CallsAt"."MonitoringKey", "CallsAt"."VisitOrder", "SpaceStation"."StationName", "SpaceStation"."PlanetID"
	FROM "CallsAt"
	INNER JOIN "SpaceStation" ON "CallsAt"."StationID" = "SpaceStation"."StationID";
-- 3) Add the support to execute an anonymous code block as follows;
DO
$$
DECLARE
-- 4) Within the declare section, declare a variable of type real to store a route total distance.
"routeDistance" real := 0.0; -- Trade route total distance --
-- 5) Within the declare section, declare a variable of type real to store a hop partial distance.
"hopDistance" real := 0.0; -- hop partial distance --
-- 6) Within the declare section, declare a variable of type record to iterate over routes.
"rRoute" record; -- record of routes --
-- 7) Within the declare section, declare a variable of type record to iterate over hops.
"rHop" record; -- record of hops --
-- 8) Within the declare section, declare a variable of type text to transiently build dynamic queries.
"query" text; -- dynamic query builder --
-- 9) Within the main body section, loop over routes in TradingRoutes
BEGIN
FOR "rRoute" IN SELECT "MonitoringKey" FROM "TradingRoute"
LOOP
-- 10) Within the loop over routes, get all visited planets (in order) by this trading route.
"query" := 'CREATE VIEW "PortsOfCall" AS '
|| 'SELECT "PlanetID", "VisitOrder" '
|| 'FROM "EnrichedCallsAt" '
|| 'WHERE "MonitoringKey" = ' || "rRoute"."MonitoringKey"
|| ' ORDER BY "VisitOrder"';
-- 11) Within the loop over routes, execute the dynamic view
EXECUTE "query";
-- 12) Within the loop over routes, create a view Hops for storing the hops of that route. 
CREATE VIEW "Hops" AS
	SELECT p1."PlanetID" AS "Origin", p2."PlanetID" AS "Destination"
	FROM "PortsOfCall" p1
	INNER JOIN "PortsOfCall" p2 ON p1."VisitOrder" = (p2."VisitOrder" - 1);
-- 13) Within the loop over routes, initialize the route total distance to 0.0.
"routeDistance" := 0.0;
-- 14) Within the loop over routes, create an inner loop over the hops
FOR "rHop" IN SELECT "Origin" FROM "Hops"
LOOP
-- 15) Within the loop over hops, get the partial distances of the hop. 
"query" := 'SELECT "AvgDistance" '
|| 'FROM "Distance" '
|| 'WHERE "PlanetOrigin" = ' || "rHop"."Origin";
-- 16)  Within the loop over hops, execute the dynamic view and store the outcome INTO the hop partial distance.
EXECUTE "query" INTO "hopDistance";
-- 17)  Within the loop over hops, accumulate the hop partial distance to the route total distance.
"routeDistance" = "routeDistance" + "hopDistance";
-- 18)  Go back to the routes loop and insert into the dummy table RouteLength the pair (RouteMonitoringKey,RouteTotalDistance).
END LOOP;
INSERT INTO "RouteLength" ("RouteMonitoringKey", "RouteTotalDistance")
	VALUES ("rRoute"."MonitoringKey", "routeDistance");
-- 19)  Within the loop over routes, drop the view for Hops (and cascade to delete dependent objects).
DROP VIEW "Hops" CASCADE;
-- 20)  Within the loop over routes, drop the view for PortsOfCall (and cascade to delete dependent objects).
DROP VIEW "PortsOfCall" CASCADE;
-- 21)  Finally, just report the longest route in the dummy table RouteLength.
END LOOP;
END;
$$;

SELECT "RouteMonitoringKey" AS "Route", MAX("RouteTotalDistance") AS "Length"
	FROM "RouteLength"
	WHERE "RouteTotalDistance" = (SELECT MAX("RouteTotalDistance") FROM "RouteLength")
	GROUP BY "RouteMonitoringKey";