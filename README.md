# Singapore Airlines ETL Project

## Table of Contents

- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Objective](#objective)
- [ETL Process](#etl-process)
  - [Extract Data: Data Collection](#extract-data-data-collection)
  - [Transform Data: Clean Data](#transform-data-clean-data)
  - [Transform Data: Transform Data](#transform-data-transform-data)
  - [Load Data: Load to Database](#load-data-load-to-database)
- [Database Design](#database-design)
  - [Schema Overview](#schema-overview)
  - [Tables and Relationships](#tables-and-relationships)
  - [Entity-Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Steps Involved](#steps-involved)
- [Result and Findings](#result-and-findings)
- [Recommendations](#recommendations)
- [Limitations](#limitations)
- [Improvements](#improvements)

  
## Introduction

In this project, we will perform **web scraping** on the Skytrax website to extract customer reviews for **Singapore Airlines**. The goal is to build an **ETL (Extract, Transform, Load)** pipeline that moves data from the source website into a **PostgreSQL database**.  
<br>

For our use case, we will perform:
- 💬 **Sentiment Analysis** on the reviews  
- ☁️ **Word Cloud** generation on the transformed text data  
<br>

📌 *Why Sentiment Analysis before loading to PostgreSQL?*  
Because performing sentiment analysis using Python libraries like `TextBlob` is computationally intensive. Processing it in-memory (Python) is more efficient than running repeated database queries, and it also allows for parallel processing.

---

### 📋 Project Overview

The primary aim is to:
- 🔍 Extract reviews from the Skytrax website for Singapore Airlines  
- 🧹 Transform and clean the review data  
- 💡 Perform sentiment analysis  
- 🛢️ Load the processed data into a PostgreSQL database for further exploration and analysis

---

### 🎯 Objectives

1. 🛠️ Develop a Python-based web scraper to extract Singapore Airlines passenger reviews from Skytrax and save them into a CSV file  
2. 📚 Familiarize with data tools and libraries like `pandas`, `textblob`, `sqlalchemy`, `matplotlib`, and `seaborn` for ETL and EDA  
3. 🧱 Design and build a relational database with a schema, tables, and an Entity-Relationship (ER) model  
4. 💾 Use SQL scripts to populate the database with clean, normalized data


## 🔄 ETL Process

### 🛫 Extract Data : Data Collection
1. For our web-scraper, we used `requests` to fetch HTML pages from Skytrax review pages.
2. Parsed HTML with `BeautifulSoup` to extract review details like:
   - 🧑 User name  
   - ⭐ Overall rating  
   - 📝 Review title and content  
   - ✈️ Trip status, type of traveller, seat type, route, and date flown  
3. Handled pagination by:
   - Looping through 100 pages of reviews  
   - Grabbing reviews from each page one at a time  
   - Sleeping for 15 seconds after each request to avoid overwhelming the server

### 🧹 Transform Data : Clean Data
1. Cleaned the raw data and dealt with NaN or missing values
2. Identified null values
3. Dropped unnecessary columns
4. Filled missing values with `0` or `'Missing'`
5. Replaced `"0"` in `Type of Traveller` with `"Unknown"`
6. Prepared the final transformed dataset ready for loading

### 🔧 Transform Data : Transform Data
1. Renamed column names to ensure compatibility and standardization
2. Converted some column types (e.g., text to category, int to smallint) to optimize storage

### 🗄️ Load Data : Load to Database
1. Created a new PostgreSQL database with two schemas:
   - `sia_source` for raw/transformed data  
   - `sia_normalised` for normalized tables
2. Loaded transformed data to the `sia_source` schema
3. Normalized the data and populated relational tables in the `sia_normalised` schema using SQL scripts


## 🧩 Database Design

As part of the **Load** step in our ETL process, we designed a normalized PostgreSQL database schema under the `sia_normalised` schema. This design helps to improve query efficiency, eliminate redundancy, and support future scalability of the system (e.g., adding other airlines' reviews later). It must be noted that our analysis is still exploratory and not massive in scale.

### 📘 Schema Overview

The database consists of four main tables:
1. `sia_users`: stores user and review-level information.
2. `user_ratings`: stores detailed ratings per review.
3. `traveller_type`: lookup table for traveller categories (e.g., Solo Leisure, Couple Leisure).
4. `seat_type`: lookup table for seat types (e.g., Economy, Business).

Each table is normalized and uses **surrogate primary keys** (e.g., `sia_user_id`, `seat_type_id`) to maintain consistency and improve indexing performance.

### 🗂️ Tables and Relationships

#### 1. `traveller_type`
- Stores unique traveller categories.
- **Primary Key**: `traveller_type_id`
- **Unique Constraint**: `type_of_traveller`

#### 2. `seat_type`
- Stores unique seat types mentioned in reviews.
- **Primary Key**: `seat_type_id`
- **Unique Constraint**: `seat_type`

#### 3. `sia_users`
- Stores review-level details including user name, rating, comments, and trip metadata.
- **Primary Key**: `sia_user_id` (surrogate)
- **Foreign Keys**:
  - `traveller_type_id` → `traveller_type(traveller_type_id)`
  - `seat_type_id` → `seat_type(seat_type_id)`

#### 4. `user_ratings`
- Stores sub-rating metrics such as seat comfort, food quality, staff service, etc.
- **Primary Key**: `rating_id` (surrogate)
- **Foreign Key**:
  - `sia_user_id` → `sia_users(sia_user_id)`

### 🔗 Entity Relationships

- **One-to-Many** from `traveller_type` to `sia_users`: One traveller type can be linked to multiple user reviews.
- **One-to-Many** from `seat_type` to `sia_users`: One seat type can be associated with many users.
- **One-to-Many** from `sia_users` to `user_ratings`: Each user review has exactly one set of detailed ratings.

This relational structure supports efficient joins, flexible queries, and easy extension in the future (e.g., adding new lookup tables like cabin crew type or airport used).

### 🧱 Surrogate Keys

Surrogate keys are used across all main tables:
- These are auto-incremented integer IDs (`SERIAL` in PostgreSQL).
- They ensure stable, unique identifiers even when source data values (e.g., user names or seat types) are duplicated or may change over time.


### Entity-Relationship Diagram (ERD)
![SIA ERD pic](https://github.com/ArronATW/SIA-ETL-project/blob/main/SIA%20ER%20diagram.png)

## Exploratory Data Analysis

### Steps Involved
#### 1. Data Extraction
- **Objective**: Scrape Singapore Airlines reviews from Skytrax using Python libraries like Beautiful Soup.
- **Process**:
- Extract key fields such as User Name, Overall Rating, Review, Detail Review, Type of Traveller, Seat Type, Route, etc.
- Handle pagination to scrape multiple pages of reviews.
- Save the extracted data into a CSV file for further processing.

#### 2. Data Transformation
- **Objective**: Clean and preprocess the extracted data for analysis and sentiment scoring.
- **Steps**:
    - Identify and handle missing values (NaN), filling them with default values like 'Missing' or 0.
    - Drop unnecessary columns to focus on relevant features.
    - Standardize text in the Detail Review column for sentiment analysis.

#### 3. Sentiment Analysis
- **Objective**: Analyze customer sentiment using TextBlob's polarity scores.
- **Steps**:
    - Calculate sentiment polarity for each review (-1 for negative, 0 for neutral, and 1 for positive).
    - Classify reviews into sentiment categoreis (positive, negative or neutral) based on polarity thresholds.

#### 4. Visualization
- **Objective**: Gain insights into sentiment distribution and word usage patterns.
- **Steps**:
    - Create histograms to visualize the distribution of sentiment scores.
    - Generate word clouds for all reviews, positive sentiments and negative sentiments.

### Result and Findings

- **Sentiment Distribution**:
  - The average sentiment score is slightly positive (mean = 0.193610), indicating overall satisfaction but with room for improvement.
  - Negative reviews highlight common issues such as flight delays, poor service, or uncomfortable seating.
  
- **Word Cloud Insights**:
  - Positive reviews frequently mention terms like "friendly", "comfortable", and "excellent".
  - Negative reviews highlight terms such as "delay", "poor", and "uncomfortable".
  
- **Feature Correlation**:
  - Higher ratings correlate strongly with positive sentiment polarity scores.
  - Economy-class passengers tend to leave more negative reviews compared to business/first-class travellers.

### Recommendations

- Focus on addressing recurring complaints in negative reviews (e.g delays, staff behaviour).

- Leverage positive feedback by emphasizing strengths like friendly staff and inflight entertainment in marketing campaigns.

- Conduct further analysis to identify seasonal trends in customer satisfaction (e.g. holiday travel periods).

### Limitations

- **Data Bias**: Reviews may be biased toward extreme opinions (very positive or very negative), which could skew overall sentiment analysis results.

- **Incomplete Features**: Some fields (e.g. routes or traveler types) may have missing values due to incomplete data extraction.

## 📈 Improvements

1. **Introduce Star Schema for Analytics**  
   While the current **Entity-Relationship Diagram (ERD)** and normalized database design are ideal for maintaining data integrity and scalability, future expansion into **business intelligence (BI)** tools or **dashboarding** may benefit from implementing a **star schema**.  
   - This would involve creating a **fact table** (e.g., `fact_reviews`) to capture measurable events such as sentiment scores and ratings.  
   - Related **dimension tables** (e.g., `dim_seat_type`, `dim_traveller_type`, `dim_airline`, `dim_date`) can provide context to support faster and more flexible queries.  
   - A star schema structure simplifies analytical queries, improves performance in BI tools like Tableau or Power BI, and supports trend reporting and aggregations more efficiently.

2. **Add Support for Multi-Airline Reviews**  
   Extend the schema to include an `airline` table and associated foreign key in `sia_users` to support scraping and storing reviews for multiple airlines beyond Singapore Airlines.

3. **Time Dimension for Trend Analysis**  
   Introduce a `dim_date` table to enable time-based analytics such as seasonal trends in sentiment or ratings, e.g., fluctuations around holidays or during major travel disruptions.
