
# **Motor Vehicle Collisons Analysis**

---

## 📌 Project Overview
This project analyzes over 2.2 million NYC motor vehicle collision records to evaluate structural shifts in crash severity, borough-level fatal risk disparities, and risk concentration across time, geography, and road user groups. The dataset includes crash dates/times, locations, boroughs, vehicle types, injuries/fatalities, and contributing factors.

## 🎯 Objectives

- To analyze trends of vehicle collisions
- To identify most dangerous boroughs, streets, or intersections 
- To find the leading causes of crashes 
- To recognize the most severely victimized groups(pedestrians, cyclists, motorists).
  
## 🛠️ Tools Used

- Python: Pandas, SQLAlchemy, pymysql
- MySQL Workbench  
- Tableau Public

## 🧠 Skills Demonstrated

- Data cleaning and transformation with Python  
- SQL analysis using CTEs, subqueries, joins, and aggregations  
- Interactive dashboards with Tableau Public
  
---

## ⚙️ Methodology  

### 📥 Data Loading  
Raw data was imported into a Jupyter notebook using `pandas`, cleaned and transformed, then exported to MySQL Workbench via `SQLAlchemy` and `pymysql`.


### 🧹 Data Cleaning  

1. **Initial Inspection**   
   Reviewed structure and content of the raw dataset. Renamed all columns to lowercase and replaced spaces with underscores for consistency

2. **Duplicate Removal**  
  Then dropped rows with identical `crash_date`, `crash_time`, and `location`.

3. **Type Conversion**  
   Converted date fields (`crash_date`, `crash_time`) to datetime format.
   
4. **Populating the Missing Values (boroughs,streets,locations)**  
   Pupulated the missing values of boroughs, according to the streets and locations. 

5. **Standardising Vehicle Types**  
   Removed the specific vehicle types, remain the major vehicle types.
   
6. **Remove Irrelevant Columns**  
   Dropped fields which were irrelevant for the analysis: `crash_date`, `crash_time`, `latitude`, `longitude`, `location`, `off_street_name`

7. **Formating the Values**  
   Converted the values of `boroughs`, `on_street_name`, `cross_street_name` to the format of first letter capitalized.  

8. **Working With Null Values**  
   Filled gaps in all the columns.


### 📊 Exploratory Data Analysis (EDA)

The cleaned data was exported to MySQL workbench and then connected to Tableau Public for the analysis. Several techniques like aggregations, CTEs, and joins were used to glean insights using SQL. I then used Tableau Public to visualise the data and mapped NYC using zipcodes to identify violation hotspots across the city.

---

## 🔍 Key Findings  

### 📌 Collision Trends

- Before year 2020 the total crashes per year were beyond 200000, 2020-2022 the total crashes per year were about 110000,and at 2023 and 2024 the total crashes number decreased at 96501 and 91192. Apparently the trend of total crashes is decreasing.

- Brooklyn(621708) and Queens(598683) have the highest number of craches

- The top 10 streets with the most collisions are Broadway(20892), Belt Parkway(19831), Atlantic Avenue(17875), 3 Avenue(14332), Long Island Expressway(13870), Brooklyn Queens Expressway(13636), Northern Boulevard(13525), Grand Central Pkwy(11840), Linden Boulevard(11434), Flatbush Avenue(11202).

### 🚨 Contributing Factors 

- The most frequently happened factors are  "Driver Inattention/Distraction"(446275),"Failure to Yield Right-of-Way"(131852), "Following Too Closely"(118152), Backing Unsafely(80487) and Passing or Lane Usage Improper(63040).

- Across all five boroughs, “Driver Inattention/Distraction” is the leading contributing factor in traffic crashes, with the highest counts recorded in Queens (134,418), Brooklyn (118,194), Manhattan (93,039), the Bronx (54,986), and Staten Island (22,018). “Failure to Yield Right-of-Way” ranks second overall and is disproportionately prevalent in Brooklyn (40,766) and Queens (46,891), while occurring less frequently in Manhattan (20,256). Similarly, “Following Too Closely” accounts for the greatest number of crashes in Queens (41,074), followed by Brooklyn (27,457) and Manhattan (18,468).


### 🍽️ Cuisine Analysis  

- 
## 💡 Recommendations 

1. Improve re-inspection frequency in high-risk areas and restaurants
2. Targeted education for cuisines with frequent violations.
3. A city campaign to train food workers on hygiene and safety.
4. Restaurants should adhere to temperature control guidelines.
5. Pass legislation for restaurants to have internal quality assurance managers to ensure compliance to the health codes.


### 🙏 Credit

- **[Analyst Builder](https://www.analystbuilder.com/projects/restaurant-health-inspection-analysis-nyc-FhAOm)** for the datasets and the directions for the analysis.

- **[NYC Environmental Health Services team at DOHMH](https://github.com/nycehs/NYC_geography)** for the topo-json of NYC.  

---

📬 Contact
If you'd like to connect, collaborate, or discuss this project further:

📧 **Email:** felix.xuhaixin@gmail.com

🧠 **GitHub Profile:** [Felix Xu](https://github.com/Felix-Xuhaixin)
