CREATE TABLE consumers (
    consumer_id VARCHAR PRIMARY KEY,
    city VARCHAR,
    state VARCHAR,
    country VARCHAR,
    latitude FLOAT,
    longitude FLOAT,
    smoker VARCHAR,
    drink_level VARCHAR,
    transportation_method VARCHAR,
    marital_status VARCHAR,
    children VARCHAR,
    age INT,
    occupation VARCHAR,
    budget VARCHAR
);


-----
CREATE TABLE consumer_preferences (
    consumer_id VARCHAR,
    preferred_cuisine VARCHAR
);


---
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR,
    city VARCHAR,
    state VARCHAR,
    country VARCHAR,
    zip_code INT,
    latitude FLOAT,
    longitude FLOAT,
    alcohol_service VARCHAR,
    smoking_allowed VARCHAR,
    price VARCHAR,
    franchise VARCHAR,
    area VARCHAR,
    parking VARCHAR
);


-----
CREATE TABLE restaurants_cuisines (
    restaurant_id INT,
    cuisine VARCHAR
);


----
CREATE TABLE ratings (
    consumer_id VARCHAR,
    restaurant_id VARCHAR,
    overall_rating INT,
    food_rating INT,
    service_rating INT
);


--
ALTER TABLE ratings
ALTER COLUMN restaurant_id TYPE INT
USING restaurant_id :: INT;


----- Confierming if import worked
SELECT * FROM consumers;
--
SELECT * FROM consumer_preferences;
--
SELECT * FROM restaurants;
--
SELECT *FROM restaurants_cuisines;
--
SELECT * FROM ratings;

------Creating backup tables
CREATE TABLE consumers_backup AS TABLE consumers;
--
CREATE TABLE consumer_preferences_backup AS TABLE consumer_preferences;
---
CREATE TABLE restaurants_backup AS TABLE restaurants;
--
CREATE TABLE restaurants_cuisines_backup AS TABLE restaurants_cuisines;
--
CREATE TABLE ratings_backup AS TABLE ratings;


------— Check for Null Values
SELECT
    SUM(CASE WHEN consumer_id IS NULL THEN 1 ELSE 0 END) AS null_consumer_id,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) AS null_latitude,
    SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) AS null_longitude,
    SUM(CASE WHEN smoker IS NULL THEN 1 ELSE 0 END) AS null_smoker,
    SUM(CASE WHEN drink_level IS NULL THEN 1 ELSE 0 END) AS null_drink_level,
    SUM(CASE WHEN transportation_method IS NULL THEN 1 ELSE 0 END) AS null_transport,
    SUM(CASE WHEN marital_status IS NULL THEN 1 ELSE 0 END) AS null_marital,
    SUM(CASE WHEN children IS NULL THEN 1 ELSE 0 END) AS null_children,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN occupation IS NULL THEN 1 ELSE 0 END) AS null_occupation,
    SUM(CASE WHEN budget IS NULL THEN 1 ELSE 0 END) AS null_budget
FROM consumers;


-----
SELECT *
FROM consumers
WHERE consumer_id IS NULL
   OR city IS NULL
   OR state IS NULL
   OR country IS NULL
   OR latitude IS NULL
   OR longitude IS NULL
   OR smoker IS NULL
   OR drink_level IS NULL
   OR transportation_method IS NULL
   OR marital_status IS NULL
   OR children IS NULL
   OR age IS NULL
   OR occupation IS NULL
   OR budget IS NULL;


   ------ from Rating
   SELECT *
FROM ratings
WHERE consumer_id IS NULL
   OR restaurant_id IS NULL
   OR overall_rating IS NULL
   OR food_rating IS NULL
   OR service_rating IS NULL;


   --- Restaurant
   SELECT *
FROM restaurants
WHERE restaurant_id IS NULL
   OR name IS NULL
   OR city IS NULL
   OR state IS NULL
   OR country IS NULL
   OR zip_code IS NULL
   OR latitude IS NULL
   OR longitude IS NULL
   OR alcohol_service IS NULL
   OR smoking_allowed IS NULL
   OR price IS NULL
   OR franchise IS NULL
   OR area IS NULL
   OR parking IS NULL;


  ---- Checking null values for restaurant cuisine
 SELECT *
FROM restaurants_cuisines
WHERE restaurant_id IS NULL
OR cuisine IS NULL;

---- Checking null values for consumer preferences
SELECT *
FROM consumer_preferences
WHERE consumer_id IS NULL
OR preferred_cuisine IS NULL;


------Checking duplicate on consumers table
SELECT consumer_id, COUNT(*)
FROM consumers
GROUP BY consumer_id
HAVING COUNT(*) > 1;

---- Checking duplicate on consumer preferences table
SELECT consumer_id, preferred_cuisine, COUNT(*)
FROM consumer_preferences
GROUP BY consumer_id, preferred_cuisine
HAVING COUNT(*) > 1;


------ checking duplicate rows in Restaurants
SELECT restaurant_id, COUNT(*)
FROM restaurants
GROUP BY restaurant_id
HAVING COUNT(*) > 1;


---- checking for Duplicate cuisine
SELECT restaurant_id, cuisine, COUNT(*)
FROM restaurants_cuisines
GROUP BY restaurant_id, cuisine
HAVING COUNT(*) > 1;


----checking for Duplicate ratings 
SELECT consumer_id, restaurant_id, COUNT(*) AS times_rated
FROM ratings
GROUP BY consumer_id, restaurant_id
HAVING COUNT(*) > 1;

 
----Checking for character inconsistencies
SELECT DISTINCT preferred_cuisine FROM consumer_preferences ORDER BY 1;
----
SELECT DISTINCT cuisine FROM restaurants_cuisines ORDER BY 1;
--
SELECT DISTINCT budget FROM consumers ORDER BY 1;
--
SELECT DISTINCT smoker FROM consumers ORDER BY 1;
--
SELECT DISTINCT drink_level FROM consumers ORDER BY 1;
--
SELECT DISTINCT marital_status FROM consumers ORDER BY 1;
--
SELECT DISTINCT occupation FROM consumers ORDER BY 1;
--
SELECT DISTINCT price FROM restaurants ORDER BY 1;
--
SELECT DISTINCT alcohol_service FROM restaurants ORDER BY 1;
--
SELECT DISTINCT smoking_allowed FROM restaurants ORDER BY 1;
--
SELECT DISTINCT parking FROM restaurants ORDER BY 1;
--
SELECT DISTINCT franchise FROM restaurants ORDER BY 1;
--
SELECT DISTINCT area FROM restaurants ORDER BY 1;


---
-- Consumer Preferences pointing to a consumer that doesn't exist
SELECT cp.consumer_id
FROM consumer_preferences cp
LEFT JOIN consumers c ON cp.consumer_id = c.consumer_id
WHERE c.consumer_id IS NULL;
 
-- Cuisines pointing to a restaurant that doesn't exist
SELECT rc.restaurant_id
FROM restaurants_cuisines rc
LEFT JOIN restaurants r ON rc.restaurant_id = r.restaurant_id
WHERE r.restaurant_id IS NULL;
 
-- Ratings pointing to a consumer that doesn't exist
SELECT r.consumer_id
FROM ratings r
LEFT JOIN consumers c ON r.consumer_id = c.consumer_id
WHERE c.consumer_id IS NULL;
 
-- Ratings pointing to a restaurant that doesn't exist
SELECT r.restaurant_id
FROM ratings r
LEFT JOIN restaurants res ON r.restaurant_id = res.restaurant_id
WHERE res.restaurant_id IS NULL;


--Ratings outside a valid 1-5 scale
SELECT * FROM ratings
WHERE overall_rating NOT BETWEEN 1 AND 5
   OR food_rating NOT BETWEEN 1 AND 5
   OR service_rating NOT BETWEEN 1 AND 5;
 
-- Ages outside a realistic human range
SELECT * FROM consumers
WHERE age < 10 OR age > 100;
 
-- Latitude/Longitude outside valid world coordinate range
SELECT * FROM consumers
WHERE latitude NOT BETWEEN -90 AND 90
   OR longitude NOT BETWEEN -180 AND 180;
   
 ----- from restuarant
SELECT * FROM restaurants
WHERE latitude NOT BETWEEN -90 AND 90
   OR longitude NOT BETWEEN -180 AND 180;


----
UPDATE consumers
SET smoker = COALESCE(smoker, 'Unknown'),
    transportation_method = COALESCE(transportation_method, 'Unknown'),
    marital_status = COALESCE(marital_status, 'Unknown'),
    children = COALESCE(children, 'Unknown'),
    occupation = COALESCE(occupation, 'Unknown'),
    budget = COALESCE(budget, 'Unknown')
WHERE smoker IS NULL
   OR transportation_method IS NULL
   OR marital_status IS NULL
   OR children IS NULL
   OR occupation IS NULL
   OR budget IS NULL;


----Checking for data type
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'consumers';

----
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'ratings';
---
 
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'restaurants';
----

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'consumer_preferences';

---
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'restaurants_cuisines';

-------------------------------------Adding Foreign keys to our tables
ALTER TABLE consumer_preferences
    ADD CONSTRAINT fk_pref_consumer
    FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id);
	
----
ALTER TABLE ratings
    ADD CONSTRAINT fk_rating_consumer
    FOREIGN KEY (consumer_id) REFERENCES consumers(consumer_id);

-----
ALTER TABLE restaurants_cuisines
    ADD CONSTRAINT fk_cuisine_restaurant
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id);


----Checking if the tables are properly connected
SELECT c.consumer_id, c.occupation, r.overall_rating, res.name
FROM consumers c
JOIN ratings r
ON c.consumer_id = r.consumer_id
JOIN restaurants res 
ON r.restaurant_id = res.restaurant_id
LIMIT 10;


---
SELECT cp.consumer_id, cp.preferred_cuisine, rc.cuisine, res.name
FROM consumer_preferences cp
JOIN restaurants_cuisines rc 
ON cp.preferred_cuisine = rc.cuisine
JOIN restaurants res
ON rc.restaurant_id = res.restaurant_id
LIMIT 10;


----Adding Calculated Columns
ALTER TABLE consumers ADD COLUMN age_group VARCHAR;

---- 
UPDATE consumers
SET age_group = CASE 
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 45 THEN '36-45'
    WHEN age > 45 THEN '46+'
    ELSE 'Unknown'
END;

--- 
ALTER TABLE ratings ADD COLUMN rating_category VARCHAR;

---- 
UPDATE ratings
SET rating_category = CASE 
    WHEN overall_rating <= 2 THEN 'Low'
    WHEN overall_rating = 3 THEN 'Medium'
    WHEN overall_rating >= 4 THEN 'High'
    ELSE 'Unknown'
END;


---Creating Indexes
CREATE INDEX idx_ratings_consumer ON ratings(consumer_id);

---
CREATE INDEX idx_ratings_restaurant ON ratings(restaurant_id);

--
CREATE INDEX idx_pref_cuisine ON consumer_preferences(preferred_cuisine);

---
CREATE INDEX idx_rest_cuisine ON restaurants_cuisines(cuisine);


----CREATING VIEW FOR THE ANALYSIS
CREATE VIEW core_analysis AS
SELECT
    r.consumer_id,
    r.restaurant_id,
    r.overall_rating,
    r.food_rating,
    r.service_rating,
    r.rating_category,
    c.age,
    c.age_group,
    c.occupation,
    c.budget,
    c.marital_status,
    c.children,
    c.smoker,
    c.drink_level,
    c.city AS consumer_city,
    c.state AS consumer_state,
    c.country AS consumer_country,
    c.latitude AS consumer_latitude,
    c.longitude AS consumer_longitude,
    res.name AS restaurant_name,
    res.price,
    res.alcohol_service,
    res.smoking_allowed,
    res.parking,
    res.franchise,
    res.area,
    res.city AS restaurant_city,
    res.state AS restaurant_state,
    res.country AS restaurant_country
FROM ratings r
JOIN consumers c ON r.consumer_id = c.consumer_id
JOIN restaurants res ON r.restaurant_id = res.restaurant_id;


----
SELECT 
    (SELECT COUNT(*) FROM ratings) AS ratings_count,
    (SELECT COUNT(*) FROM core_analysis) AS view_count;

---
SELECT *
FROM core_analysis
LIMIT 10;


----
CREATE VIEW preference_match_analysis AS
SELECT
    r.consumer_id,
    r.restaurant_id,
    r.overall_rating,
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM consumer_preferences cp
            JOIN restaurants_cuisines rc 
                ON cp.preferred_cuisine = rc.cuisine
				            WHERE cp.consumer_id = r.consumer_id
              AND rc.restaurant_id = r.restaurant_id
        ) THEN 'Match'
        ELSE 'No Match'
    END AS preference_match
FROM ratings r;


---
SELECT 
    (SELECT COUNT(*) FROM ratings) AS ratings_count,
    (SELECT COUNT(*) FROM preference_match_analysis) AS view_count;

-----
CREATE VIEW cuisine_demand AS
SELECT preferred_cuisine AS cuisine, COUNT(*) AS demand_count
FROM consumer_preferences
GROUP BY preferred_cuisine;

--
SELECT*
FROM cuisine_demand;

--- 
CREATE VIEW cuisine_supply AS
SELECT cuisine, COUNT(*) AS supply_count
FROM restaurants_cuisines
GROUP BY cuisine;

---
CREATE VIEW demand_supply_gap AS
SELECT 
    COALESCE(d.cuisine, s.cuisine) AS cuisine,
    COALESCE(d.demand_count, 0) AS demand_count,
    COALESCE(s.supply_count, 0) AS supply_count,
    COALESCE(d.demand_count, 0) - COALESCE(s.supply_count, 0) AS demand_supply_gap
FROM cuisine_demand d
FULL OUTER JOIN cuisine_supply s ON d.cuisine = s.cuisine
ORDER BY demand_supply_gap DESC;


---
SELECT*
FROM demand_supply_gap;


----
CREATE VIEW restaurant_primary_cuisine AS
SELECT DISTINCT ON (restaurant_id)
    restaurant_id,
    cuisine AS primary_cuisine
FROM restaurants_cuisines
ORDER BY restaurant_id, cuisine;


-----
DROP VIEW core_analysis;


----
CREATE VIEW core_analysis AS
SELECT
    r.consumer_id,
    r.restaurant_id,
    r.overall_rating,
    r.food_rating,
    r.service_rating,
    r.rating_category,
    c.age,
    c.age_group,
    c.occupation,
    c.budget,
    c.marital_status,
    c.children,
    c.smoker,
    c.drink_level,
    c.city AS consumer_city,
    c.state AS consumer_state,
    c.country AS consumer_country,
    c.latitude AS consumer_latitude,
    c.longitude AS consumer_longitude,
    res.name AS restaurant_name,
    res.price,
    res.alcohol_service,
    res.smoking_allowed,
    res.parking,
    res.franchise,
    res.area,
    res.city AS restaurant_city,
    res.state AS restaurant_state,
    res.country AS restaurant_country,
	res.latitude AS restaurant_latitude,
    res.longitude AS restaurant_longitude,
    rpc.primary_cuisine
FROM ratings r
JOIN consumers c ON r.consumer_id = c.consumer_id
JOIN restaurants res ON r.restaurant_id = res.restaurant_id
LEFT JOIN restaurant_primary_cuisine rpc ON r.restaurant_id = rpc.restaurant_id;


---
SELECT 
    (SELECT COUNT(*) FROM ratings) AS ratings_count,
    (SELECT COUNT(*) FROM core_analysis) AS view_count;

	--



























   


































