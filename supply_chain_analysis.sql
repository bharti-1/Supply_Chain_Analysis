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
In this SQL file ,we will be analysing the data with some business questions. 

*/

#Q1 :-Count of top 50 products which has maximum order

SELECT product_ID,COUNT(order_ID) AS total_orders
FROM `supplychain-analysis`.orderlist
GROUP BY product_id
ORDER BY total_orders desc
LIMIT 50

#Q2 :- Sum of quantity ordered by each customer

SELECT customer,
       SUM(unit_quantity) AS total_quantity
FROM `supplychain-analysis`.orderlist
GROUP BY customer
ORDER BY total_quantity desc

#	Q3:- Origin and destination port 

SELECT DISTINCT(a.customer),
	   b.origin_port,
       b.destination_port,
       b.plant_code
FROM `supplychain-analysis`.orderlist AS a
INNER JOIN `supplychain-analysis`.orderlist AS b
ON a.order_id=b.order_id 

SELECT DISTINCT(customer),
       origin_port,
       destination_port,
       plant_code
FROM `supplychain-analysis`.orderlist
ORDER BY customer
       

#Q4 :- List of customers with respective product ids where the early delievery is more than 3 

SELECT customer,
       product_id,
       ROUND(AVG(ship_ahead_day_count),0) AS avg_delivery
FROM `supplychain-analysis`.orderlist
GROUP BY customer,product_id
HAVING ROUND(AVG(ship_ahead_day_count),0)>3
ORDER BY customer DESC ,avg_delivery DESC 

#Q5:- List the product with total orders and quatity and average weight 
SELECT product_id,
       COUNT(product_id) AS total_orders,
	   SUM(unit_quantity) AS total_units,
       ROUND(AVG(weight),0) AS avg_weight
FROM `supplychain-analysis`.orderlist
GROUP BY product_id
ORDER BY avg_weight DESC 

# Q6 :-List of ports and plants used for customers

SELECT DISTINCT(a.customer),
       b.plant_code,b.port_number
FROM `supplychain-analysis`.orderlist AS a 
INNER JOIN `supplychain-analysis`.plantports AS b 
ON a.plant_code=b.plant_code 
ORDER BY a.customer DESC 

#Q7:- List the plants which are operating at under and over capacity 

CREATE VIEW capacity AS
SELECT a.plant_code,
       COUNT(a.order_ID) AS order_count,
       b.daily_capacity,
       (b.daily_capacity - COUNT(a.order_id)) AS diff
FROM `supplychain-analysis`.orderlist AS a
INNER JOIN whcapacities AS b ON a.plant_code = b.plant_ID
GROUP BY a.plant_code, b.daily_capacity;

SELECT *,
       CASE
           WHEN diff < 0 THEN 'over_capacity'
           ELSE 'under_capacity'
       END AS ca
FROM capacity
ORDER BY diff;

#Q8 :- Count of plants which are operating at over-capacity

SELECT COUNT(ca)
FROM (SELECT *,
            CASE
                WHEN diff < 0 Then 'over_capacity'
                ELSE 'under_capacity'
                END AS ca 
		FROM capacity
        ORDER BY diff) AS sub
WHERE ca='over_capacity' 

#Q9:- Count of plants which are operating at under-capacity

SELECT COUNT(ca)
FROM (SELECT *,
            CASE
                WHEN diff < 0 Then 'over_capacity'
                ELSE 'under_capacity'
                END AS ca 
		FROM capacity
        ORDER BY diff) AS sub
WHERE ca='under_capacity'  

# Q10 :- Total cost incured at each plant by every customer

SELECT DISTINCT a.customer,
       SUM(a.unit_quantity) AS total_quantity,
       b.plant_code,
       b.port_number,
       c.cost_unit,
       SUM(a.unit_quantity * c.cost_unit) AS total_cost
FROM `supplychain-analysis`.orderlist AS a 
INNER JOIN `supplychain-analysis`.plantports AS b ON a.plant_code = b.plant_code
INNER JOIN `supplychain-analysis`.whcosts AS c ON a.plant_code = c.WH
GROUP BY a.customer,
         b.plant_code,
         b.port_number,
         c.cost_unit
ORDER BY a.customer DESC; 

#Q11 :-Total cost incurred for each product 
SELECT DISTINCT a.product_ID,
       Sum(a.unit_quantity) AS total_quantity,
       SUM(a.unit_quantity * b.cost_unit) AS total_cost
FROM `supplychain-analysis`.orderlist AS a
INNER JOIN `supplychain-analysis`.whcosts AS b
ON a.plant_code=b.WH
GROUP BY a.product_id
ORDER BY total_cost DESC 

#Q12 :-Show the total cost column in the orederlist table 

SELECT a.*,
       (a.unit_quantity * b.cost_unit)AS total_cost
FROM `supplychain-analysis`.orderlist AS a
INNER JOIN `supplychain-analysis`.whcosts AS b 
ON a.plant_code=b.WH

#Q13:- Create table oder_list02 with total cost

CREATE TABLE order_list02 AS
SELECT a.*,
       (a.unit_quantity * b.cost_unit) AS total_cost
FROM `supplychain-analysis`.orderlist AS a
INNER JOIN `supplychain-analysis`.whcosts AS b
ON a.plant_code = b.WH;

SELECT *
FROM `supplychain-analysis`.order_list02; 

#Q14:-Query a output representing min and max quantity of origin port and destination port 

SELECT orig_port_cd,
       des_port_cd,
       SUM(min_wgh_qty) AS min_qty,
       SUM(max_wgh_qty) AS max_qty,
       SUM(minimum_cost) AS min_cost
FROM `supplychain-analysis`.freightrates
GROUP BY Orig_port_cd,des_port_cd
ORDER BY Orig_port_cd,des_port_cd 

#Q15:- Query a output representing min and max quantity of mode type

SELECT mode_dsc,
       SUM(min_wgh_qty) AS min_qty,
       SUM(max_wgh_qty) AS max_qty,
       SUM(minimum_cost) AS min_cost
FROM `supplychain-analysis`.freightrates
GROUP BY mode_dsc
ORDER BY min_cost 

#Q16:- Find out average transport day count by carrier

SELECT carrier,
       ROUND(AVG(tpt_day_cnt),2)
FROM `supplychain-analysis`.freightrates
GROUP BY carrier
ORDER BY carrier 

#Q17 :- Query total rate by origin port 

SELECT orig_port_cd,
       SUM(rate)AS total_rate
FROM `supplychain-analysis`.freightrates
GROUP BY orig_port_cd
ORDER BY orig_port_cd

