/* Section 1. Collision Trends
================================================================
Calculate the total crashes per year and see if they’re increasing or decreasing.

Break down crashes by borough to find which areas have the highest rates.

Find the top 10 streets or intersections with the most collisions.
*/

SELECT * FROM motor_vehicle_collisions.cleaned_collisions_data;

SELECT COUNT(collision_id)
FROM cleaned_collisions_data;

-- Calculate the total crashes per year and see if they’re increasing or decreasing.
SELECT crash_year,COUNT(collision_id) AS num_year_crash
FROM(
	SELECT collision_id,YEAR(crash_datetime) AS crash_year
	FROM cleaned_collisions_data
     ) AS crash_year_count
GROUP BY crash_year
ORDER BY crash_year; 
/*
Before year 2020 the total crashes per year were beyond 200000, 2020-2022 the total crashes per year were 
about 110000,and at 2023 and 2024 the total crashes number decreased at 96501 and 91192. Apparently the trend of total
crashes is decreasing.
*/

-- Break down crashes by borough to find which areas have the highest rates.
SELECT borough,
       COUNT(collision_id) AS num_boro_crash
FROM cleaned_collisions_data
GROUP BY borough
ORDER BY num_boro_crash DESC;
/*
Brooklyn(621708) and Queens(598683) have the highest crasch rates.
*/

-- Find the top 10 streets or intersections with the most collisions.
SELECT on_street_name,
       COUNT(collision_id) AS num_street_crash
FROM cleaned_collisions_data
WHERE on_street_name != 'Unspecified'
GROUP BY on_street_name
ORDER BY num_street_crash DESC
LIMIT 10;
/*
The top 10 streets with the most collisions are Broadway(20892), Belt Parkway(19831), Atlantic Avenue(17875), 3 Avenue(14332),
Long Island Expressway(13870), Brooklyn Queens Expressway(13636), Northern Boulevard(13525), Grand Central Pkwy(11840), 
Linden Boulevard(11434), Flatbush Avenue(11202).
*/

/* Section 2. Contributing Factors
===============================================================
Count how often each contributing factor (e.g., “Driver Inattention/Distraction,” “Aggressive Driving”) appears.

Identify the top 5 causes of crashes.

Compare factors between boroughs (e.g., Is speeding more common in Queens than Manhattan?).
*/

-- Count how often each contributing factor (e.g., “Driver Inattention/Distraction,” “Aggressive Driving”) appears.
SELECT contributing_factor_vehicle_1,
       count(collision_id) AS num_factor,
       Round(count(collision_id) / (SELECT count(collision_id) FROM cleaned_collisions_data WHERE contributing_factor_vehicle_1 != 'Unspecified') * 100, 2) AS pct_factor
FROM cleaned_collisions_data
WHERE contributing_factor_vehicle_1 != 'Unspecified'
GROUP BY contributing_factor_vehicle_1
ORDER BY num_factor DESC
LIMIT 10;
/*
The most frequently happened factors are  "Driver Inattention/Distraction"(446275),"Failure to Yield Right-of-Way"(131852)
"Following Too Closely"(118152).
*/

-- Identify the top 5 causes of crashes.
/*
Top 5 causes of crashes are "Driver Inattention/Distraction", "Failure to Yield Right-of-Way", "Following Too Closely"
"Backing Unsafely" and "Other Vehicular"
*/

-- Compare fators between boroughs (e.g., Is speeding more common in Queens than Manhattan?).
WITH boro_factor_stat AS
(
	SELECT borough,contributing_factor_vehicle_1,
			COUNT(collision_id) AS num_boro_factor
	FROM cleaned_collisions_data
	WHERE contributing_factor_vehicle_1 != 'Unspecified' AND borough != 'Unspecified'
	GROUP BY borough,contributing_factor_vehicle_1
	ORDER BY borough ASC, num_boro_factor DESC
),
rank_factor AS
(
	SELECT *,
		   RANK() OVER(PARTITION BY borough ORDER BY num_boro_factor DESC) AS rank_factor
	FROM boro_factor_stat
)
SELECT *
FROM rank_factor
WHERE rank_factor <= 5;
/*
Through all the boroughs "Driver Inattention/Distraction" is the most frenquent factor which causes the crashes: Queens(134418), Brooklyn(118194),
Manhattan(93039), Bronx(54986), Staten Island(22018); "Failure to Yield Right-of-Way" is more commen in Brooklyn(40766) and Queens(46891), which happened 
less frequently in Manhatten(20256); "Following Too Closely" caused more crashes in Queens(41074), compared to Brooklyn(27457) and Mahatten(18468).  
*/

/* Section 3. Injury & Fatality Analysis
========================================================
Analyze the total number of people injured and killed by borough.

Separate out pedestrians, cyclists, and motorists to see which groups are most affected.

Create charts showing injury/fatality trends over time.
*/

-- Analyze the total number of people injured and killed by borough.
SELECT borough, SUM(number_of_persons_injured) AS total_injured, 
       SUM(number_of_persons_killed) AS total_killed
FROM cleaned_collisions_data
GROUP BY borough
ORDER BY total_killed DESC;
/*
The total number of people injured by borough: Brooklyn(221627), Queens(203201), Bronx(118112), Manhatten(100774), Staten Island(31528)
The total number of people injured by borough: Queens(1022),Brooklyn(982), Bronx(587), Manhatten(491), Staten Island(177)
*/

-- Separate out pedestrians, cyclists, and motorists to see which groups are most affected.
SELECT SUM(number_of_pedestrians_injured) AS num_ped_injured,
       SUM(number_of_cyclist_injured) AS num_cyc_injured,
       SUM(number_of_motorist_injured) AS num_moto_injured,
       SUM(number_of_pedestrians_killed) AS num_ped_killed,
       SUM(number_of_cyclist_killed) AS num_cyc_killed,
       SUM(number_of_motorist_killed) AS num_ped_killed
FROM cleaned_collisions_data;

WITH num_casualty AS
(
	SELECT SUM(number_of_pedestrians_injured) AS num_ped_injured,
		   SUM(number_of_cyclist_injured) AS num_cyc_injured,
		   SUM(number_of_motorist_injured) AS num_moto_injured,
		   SUM(number_of_pedestrians_killed) AS num_ped_killed,
		   SUM(number_of_cyclist_killed) AS num_cyc_killed,
		   SUM(number_of_motorist_killed) AS num_moto_killed
	FROM cleaned_collisions_data
)
SELECT ROUND(num_ped_injured/(num_ped_injured + num_cyc_injured + num_moto_injured) * 100,2) AS pct_ped_injured,
       ROUND(num_cyc_injured/(num_ped_injured + num_cyc_injured + num_moto_injured) * 100,2) AS pct_cyc_injured,
       ROUND(num_moto_injured/(num_ped_injured + num_cyc_injured + num_moto_injured) * 100,2) AS pct_moto_injured,
       ROUND(num_ped_killed/(num_ped_killed + num_cyc_killed + num_ped_killed) * 100,2) AS pct_ped_killed,
       ROUND(num_cyc_killed/(num_ped_killed + num_cyc_killed + num_ped_killed) * 100,2) AS pct_cyc_killed,
       ROUND(num_moto_killed/(num_ped_killed + num_cyc_killed + num_ped_killed) * 100,2) AS pct_moto_killed
FROM num_casualty;
/*
For injured rate, motorist(72.60%), pedestrians(18.41%), cyclist(8.99%)
For fatality, pedestrians(46.31%), motorist(38.13%), cyclist(7,37%)
*/

-- Create charts showing injury/fatality trends over time.
SELECT  YEAR(crash_datetime) AS crash_year,
        SUM(number_of_persons_injured) AS num_year_injured,
        SUM(number_of_persons_killed) AS num_year_fatality
FROM cleaned_collisions_data
GROUP BY YEAR(crash_datetime)
ORDER BY crash_year;
-- Use Tablau for visual analysis

/* Section 4. Vehicle Types
==================================================
Determine which vehicle types are most often involved in crashes 
(e.g., Sedans, SUVs, Trucks, Mopeds).

Compare if certain vehicle types are linked to more severe crashes (higher injury/fatality rates).
*/

-- Determine which vehicle types are most often involved in crashes (e.g., Sedans, SUVs, Trucks, Mopeds).
SELECT COUNT(vehicle_type_code_1)
FROM cleaned_collisions_data
WHERE vehicle_type_code_1 != 'Unspecified';

SELECT vehicle_type_code_1,
       COUNT(collision_id) AS num_type_crashes,
       ROUND(COUNT(collision_id) / (
                                    SELECT COUNT(collision_id) 
                                    FROM cleaned_collisions_data
									WHERE vehicle_type_code_1 != 'Unspecified'
								    ) * 100, 2) AS pct_type_crash    	   
FROM cleaned_collisions_data
GROUP BY vehicle_type_code_1
ORDER BY num_type_crashes DESC
LIMIT 10 ;
/*
The vehicle types which are most often involved in crashes are Sedan(633856,29.01%),
Station Wagon(497034,22.75%), Passenger Vehicle(414885,18.99%),Sport Utility(179732,8.23%)
Taxi(87138,3.99%)
*/

-- Compare if certain vehicle types are linked to more severe crashes (higher injury/fatality rates)
SELECT vehicle_type_code_1,
       SUM(number_of_persons_injured) AS num_motor_type_injured,
       ROUND(SUM(number_of_persons_injured) / (
											   SELECT SUM(number_of_persons_injured) 
                                               FROM cleaned_collisions_data
                                               ) *100, 2) AS pct_motor_type_injured,
       SUM(number_of_persons_killed) AS num_motor_type_killed,
       ROUND(SUM(number_of_persons_killed) / (
											   SELECT SUM(number_of_persons_killed) 
                                               FROM cleaned_collisions_data
                                               ) *100, 2) AS pct_motor_type_killed   	   
FROM cleaned_collisions_data
GROUP BY vehicle_type_code_1
ORDER BY num_motor_type_injured DESC
LIMIT 10 ;
-- Sedan is linked to the most severe crashes (230558 person injured, 755 person killed)

/* Section 6. Recommendations
More speed enforcement in high-crash areas.

Bike lane improvements in boroughs with high cyclist injuries.

Public awareness campaigns for distracted driving.
*/



