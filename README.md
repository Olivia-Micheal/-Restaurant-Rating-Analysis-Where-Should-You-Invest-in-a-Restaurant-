# Restaurant Rating Analysis: Where Should You Invest in a Restaurant ?
A data analytics project that uses a real Mexican restaurant rating dataset to help entrepreneurs and investors make informed decisions on where and what to invest in within the restaurant industry.

---

## Description

This project analyzes a restaurant rating dataset from Mexico using PostgreSQL for data cleaning and modeling, and Power BI for visualization and storytelling. The goal was to answer four business questions given by a client and turn raw survey data into clear, actionable investment insights.

---

Imagine you have money to invest in a restaurant business, but you do not know which cuisine to pick, which city to focus on, or what features actually make customers happy. This project answers that exact problem using real customer and restaurant data, so the decision is backed by numbers, not guesswork.

---

## Table of Contents

1. Business Problem and Client Overview
2. Dataset Description
3. Data Model and Table Relationships
4. Tools and Technologies
5. Skills Explored
6. Data Cleaning Process
7. DAX Measures
8. Dashboard Pages
9. Key Findings
10. Summary and Conclusion
11. Recommendations
12. Caveats and Limitations
13. About Me and Contact

---

## 1. Business Problem and Client Overview

Digitaley Drive gave this project as a capstone task. The brief explained that a customer survey was carried out in Mexico in 2012 to collect information about restaurants, their cuisines, and the consumers who visit them. As the data analyst on this project, the task was to analyze the dataset and provide answers that would help business entrepreneurs and investors make more informed decisions.

The client asked four specific questions:

1. What can you learn from the highest rated restaurants? Do consumer preferences have an effect on ratings?
2. What are the consumer demographics? Does this indicate a bias in the data sample?
3. Are there any demand and supply gaps that can be exploited in the market?
4. If you were to invest in a restaurant, which characteristics would you be looking for?

**Figure 1: Digitaley Drive project brief**

---

## 2. Dataset Description

The dataset is made up of five related tables:

- **Consumers**: Consumer_ID, City, State, Country, Latitude, Longitude, Smoker, Drink_Level, Transportation_Method, Marital_Status, Children, Age, Occupation, Budget
- **Consumer_Preferences**: Consumer_ID, Preferred_Cuisine
- **Restaurants**: Restaurant_ID, Name, City, State, Country, Zip_Code, Latitude, Longitude, Alcohol_Service, Smoking_Allowed, Price, Franchise, Area, Parking
- **Restaurants_Cuisines**: Restaurant_ID, Cuisine
- **Ratings**: Consumer_ID, Restaurant_ID, Overall_Rating, Food_Rating, Service_Rating

Consumers and Restaurants each represent one side of the market, the customer side and the business side. Ratings is the table that connects both sides together, since it is the only table holding both a Consumer_ID and a Restaurant_ID.

---

## 3. Data Model and Table Relationships

The five tables were connected using Consumer_ID and Restaurant_ID as the shared keys. Consumers link to Consumer_Preferences and to Ratings through Consumer_ID. Restaurants link to Restaurants_Cuisines and to Ratings through Restaurant_ID. Ratings sits in the middle as the table that brings both sides of the market together.

Since one consumer can have more than one preferred cuisine, and one restaurant can serve more than one cuisine, care was taken during the SQL stage to avoid duplicate rows when these tables were joined.

**Figure 2: Data model and table relationships**

---

## 4. Tools and Technologies

- **PostgreSQL**: used for data cleaning, joins, and building analytical views
- **Power BI**: used for data modeling, DAX measures, and dashboard visualization
- **Excel**: used for a quick first look at the raw data before moving to SQL

---

## 5. Skills Explored

- Data cleaning and validation using SQL
- Handling many to many relationships without causing data duplication
- Writing SQL views to prepare clean data for reporting
- Writing DAX measures for KPIs and comparisons
- Dashboard design and data storytelling
- Translating a business brief into a working analytics solution

---

## 6. Data Cleaning Process

The data cleaning process followed these steps:

1. Backup copies of all five tables were created before any cleaning started.
2. Each table was checked for null values, duplicate rows, character inconsistencies such as spacing and inconsistent capitalization, orphan records, and unrealistic values.
3. Every issue found was corrected. Missing values in the Consumers table, such as Occupation and Budget, were labeled as "Unknown" instead of being guessed, since these are opinion based fields with no correct value to assume.
4. The same checks were run again after cleaning to confirm every issue was resolved.
5. Primary key and foreign key constraints were added to enforce proper relationships between the tables.
6. Calculated columns were added, including Age Group and Rating Category.
7. Since a restaurant can serve more than one cuisine, a separate view was created to assign one primary cuisine to each restaurant. This made it possible to analyze cuisine level ratings without duplicating rating rows.
8. Three main views were built to feed Power BI: one core view combining consumer, restaurant, and rating data, one view checking whether a customer's preferred cuisine matched the restaurant they visited, and one view comparing cuisine demand against cuisine supply.

**Figure 3: SQL data cleaning and view creation**

---

## 7. DAX Measures

DAX measures were built to directly support each client question.

- **Total Consumers, Total Restaurants, Average Overall Rating, Total Cuisine Types**: used to give a quick summary of the dataset on the Overview page.
- **Average Age, Most Common Occupation, Most Common Budget**: used to describe who the consumers actually are, which supports the bias question in Question 2.
- **Average Rating by Cuisine Match Status**: built specifically to test whether getting a preferred cuisine actually improves a customer's rating, which directly answers Question 1.
- **Highest Demand Cuisine, Most Available Cuisine, Largest Gap Cuisine, Gap Size**: built to measure the difference between what customers want and what restaurants supply, which directly answers Question 3.
- **Best Investment Cuisine**: this measure was built to combine both average rating and market gap together, instead of using rating alone. This was intentional, since a good investment decision should not be based on quality alone or demand alone, but both at once. This directly answers Question 4.
- **Best Price Category, Target Customer**: built to identify which restaurant features and which customer segment are linked to higher ratings.

**Figure 4: Power BI model view and DAX measures**

---

## 8. Dashboard Pages

This dashboard was built in Power BI Desktop. A live published link is not available, since that requires an active Power BI Pro license. The full interactive file (.pbix) is included in this repository. Download it and open it in Power BI Desktop, which is free to install, to explore the dashboard yourself, including all filters and slicers. Static screenshots of every page are provided below for quick viewing.

### Page 1: Overview

This page gives a quick summary of the entire dataset before going into detail on the other pages.

**Figure 5: Overview dashboard page**

The dataset covers 138 consumers and 130 restaurants across 101 cuisine types, with an average overall rating of 1.20. Most consumers are young and mostly students, and Mexican is by far the most preferred cuisine, with 97 consumers choosing it compared to 11 for American, the next closest. The following pages break down who these customers are, what affects their ratings, where the biggest market gap is, and what to look for when investing in a restaurant.

---

### Page 2: Consumers

**Client Question:** What are the consumer demographics? Does this indicate a bias in the data sample?

**Figure 6: Consumer demographic dashboard page**

Yes, the data shows a clear bias. Most consumers are between 18 and 25 years old, mostly students, and fall under the Medium budget category. They are also concentrated in a few cities, mainly San Luis Potosi, with much smaller numbers from Ciudad Victoria, Cuernavaca, and Jiutepec. This means the data does not fully represent all restaurant customers in Mexico. It mainly reflects young, student, budget-conscious consumers from a narrow set of cities, and this should be considered when using this data to make decisions.

---

### Page 3: Preferences

**Client Question:** What can you learn from the highest rated restaurants? Do consumer preferences have an effect on ratings?

**Figure 7: Consumer preferences and restaurant performance dashboard page**

The highest rated restaurants, Emilianos, Michiko, and Las Mananitas, all scored 2.0, and most of them fall under Brewery and Contemporary cuisine types, not Mexican, which is the most demanded. Interestingly, getting a customer's preferred cuisine does not improve their rating. Restaurants that matched a customer's preference scored 1.11 on average, while restaurants that did not match scored higher at 1.22. Also, only 18.9% of visits actually matched a customer's preferred cuisine. This shows that customer satisfaction is not really about getting their favorite food type. Something else, like food quality or service, likely plays a bigger role.

Note: this page uses "Cuisine" to describe what a restaurant actually serves, while it also shows "Cuisine Demand," which describes what consumers say they prefer. These are two different things measured on the same page, one from the restaurant side and one from the customer side.

---

### Page 4: Opportunity

**Client Question:** Are there any demand and supply gaps that can be exploited in the market?

**Figure 8: Market opportunity dashboard page**

Yes, there is a clear gap worth exploiting. Mexican cuisine has the highest demand, with 97 consumers wanting it, but only 28 restaurants currently serve it. This leaves a gap of 69, which is much higher than every other cuisine, where the gap is usually around 6 or 7. This makes Mexican cuisine the biggest and clearest opportunity in this market.

---

### Page 5: Investment

**Client Question:** If you were to invest in a restaurant, which characteristics would you be looking for?

**Figure 9: Investment characteristics dashboard page**

The data shows that higher priced restaurants tend to perform better. High priced restaurants scored 1.26 compared to 1.07 for low priced ones. Restaurants with a full bar scored higher than those with no alcohol service, and restaurants with valet parking scored higher than those with public parking. Family cuisine came out as the best overall investment option because it balances both rating and market opportunity, even though Brewery rated higher on its own but lacks enough demand. Based on this, the best restaurant to invest in would be a high priced, Family cuisine restaurant with full bar service and valet parking, targeting employed customers.

Note: this page shows "Family" as the best cuisine, while Page 3 shows "Brewery" as the highest rated cuisine. Both numbers are correct. Page 3 only looks at rating quality, while Page 5 combines rating quality together with market demand, since a good investment decision needs both.

---

## 9. Key Findings

- The consumer sample is biased toward young, student, budget-conscious consumers concentrated mainly in San Luis Potosi. Any conclusion from this data should be read with that in mind.
- The highest rated restaurants are Brewery and Contemporary style restaurants, not Mexican, even though Mexican is the most demanded cuisine.
- Matching a customer's preferred cuisine does not improve their rating. In fact, unmatched visits scored slightly higher on average. Something other than cuisine preference is driving satisfaction.
- Mexican cuisine has the largest demand and supply gap in the market, at 69, making it the clearest business opportunity by a wide margin.
- Higher priced restaurants, restaurants with a full bar, and restaurants with valet parking all tend to score higher.
- Family cuisine is the strongest overall investment choice once both rating quality and market demand are considered together, even though it does not have the single highest rating on its own.

---

## 10. Summary and Conclusion

This project set out to answer four questions using a restaurant rating dataset from Mexico. The data shows that the sample leans toward a young, student population, which limits how far its findings can be generalized. Despite this, clear patterns emerged. Customer satisfaction is not driven by getting a preferred cuisine, but likely by service and execution. Mexican cuisine has the biggest gap between demand and supply, making it a strong opportunity area. When it comes to investment, price level, alcohol service, and parking availability all show a consistent link to higher ratings, and Family cuisine stands out as the most balanced investment choice.

---

## 11. Recommendations

- Consider Mexican cuisine restaurants first, since this is where customer demand is highest and supply is lowest.
- If choosing based on overall performance and demand together, Family cuisine is the safer investment.
- Prioritize a higher price positioning, full bar service, and valet parking, since these features are consistently linked to higher customer ratings.
- Do not assume that matching a specific cuisine trend will automatically lead to better ratings. Focus more on service quality and overall restaurant execution.

---

## 12. Caveats and Limitations

- The consumer sample is not representative of the general population. It leans heavily toward young, student, budget-conscious consumers in a small number of cities.
- The cuisine analysis on some pages is based on each restaurant's primary listed cuisine, since some restaurants serve more than one cuisine.
- The dataset was collected in 2012, so consumer behavior and market conditions may have changed since then.

---

## 13. About Me and Contact

Olivia Anetoh is a self-taught data analyst skilled in SQL, Power BI, and Excel, with a focus on turning raw business data into clear, actionable insights.

- LinkedIn: https://www.linkedin.com/in/olivia-anetoh-955b94328
- GitHub: https://github.com/Olivia-Micheal
- Email: anetohchinecherem@gmail.com
