#Title:- Supply Chain Analysis
#Tool used:-MySQL

/*
Description :-
--This is a SupplyChain SQL Project.
--orderlist table has 9000 rows.
--Dataset is divided into 7 tables, one table for all orders that needs to be assigned a route-orderlist table , and 6 additional files specifying the problem and restrictions.
--For instance , the freightrates table describes all available couriers.
--The weight gaps for each individual lane and rates asociated.
--The plantports table describes the allowes links between the warehouse and shipping ports in real world.
--Furthermore, The productsperplant table list all supported warehouse-product combinations.
--The vmicustomers table lists all special cases, where warehouse is only allowed to support specific customer,while any other non-listed warehouse can supply any customer.
--The whcapaities lists warehouse capacities measured innumber of orders per day
--The whcosts specifies the cost associated in storing the products in given warehouse measured in dollars per unit . 

Approach :-
1. Understanding the datasets.
2. Creating the tables.
3. Creating business questions. 
4. Analysing through SQL queries.

Note :-
In this SQL file , we will be creating all the 7 tables and importing the csv file. 

*/


# Table 1 plantports
CREATE TABLE plantports
(
Plant_code             varchar(50),
Port_number            varchar(50)
)

SELECT * FROM `supplychain-analysis`.plantports

#Table 2 productsperplant
CREATE TABLE productsperplant
(
Plant_code         varchar(50),
Product_ID         int
)

SELECT * FROM `supplychain-analysis`.productsperplant 

#Table 3 whcapacities
CREATE TABLE whcapacities
(
Plant_ID             varchar(50),
Daily_Capacity       int
)

SELECT * FROM `supplychain-analysis`.whcapacities 

#Table 4 whcosts
CREATE TABLE whcosts
(
WH        varchar(50),
Cost_Unit int
)

SELECT * FROM `supplychain-analysis`.whcosts

#Table 5 wmicustomers
CREATE TABLE vmicustomers
(
Plant_code         varchar(50),
Customers          varchar(50)
)

SELECT * FROM `supplychain-analysis`.vmicustomers

#Table 6 freightrates
CREATE TABLE freightrates
(
Carrier          varchar(50),
Orig_port_cd     varchar(50),
des_port_cd      varchar(50),
min_wgh_qty      decimal,
max_wgh_qty      decimal,
svc_cd           varchar(50),
minimum_cost     decimal,
rate             decimal,
mode_dsc         varchar(50),
tpt_day_cnt      int,
Carrier_type      varchar(50)
)

SELECT * FROM `supplychain-analysis`.freightrates

#Table 7 orderlist
CREATE TABLE orderlist 
(
Order_date                        date,
Order_ID                          decimal,
Product_ID                        int,
Customer                          varchar(50),
Unit_quantity                     int,
Weight                            decimal,
Ship_ahead_day_count              int,
Ship_late_day_count               int,
Origin_port                       varchar(50),
Destination_port                  varchar(50),
Carrier                           varchar(50),
Plant_code                        varchar(50),
TPT                               varchar(50),
Service_level                     varchar(50)
)

SELECT * FROM `supplychain-analysis`.orderlist





