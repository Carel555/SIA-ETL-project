# Singapore Airlines ETL Project

## Table of Contents

- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Objective](#objective)
- [ETL Process](#etl-process)
  - [Extract Data : Data Collection](#extract-data--data-collection)
  - [Transform Data : Clean Data](#transform-data--clean-data)
  - [Transform Data : Transform Data](#transform-data--transform-data)
  - [Load Data : Load to Database](#load-data--load-to-database)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Tools and Technologies used](#tools-and-technologies-used)
- [Steps Involved](#steps-involved)
- [Result and Findings](#result-and-findings)
- [Recommendations](#recommendations)
- [Limitations](#limitations)
- [Improvements](#improvements)

  
## Introduction
In this project, we will do webscraping of Skytrax website to extract information on Singapore Airlines customer reviews. The aim of this project is to develop a pipeline to Extract, Transform and Load the data from a source website to the final destination as a database in PostgreSQL. <br>

For our use case, we will perform sentiment analysis and word cloud on the transformed data.<br>

The case for doing Sentiment Analysis before loading to PostgreSQL is because using Python libraries like TextBlob is computationally intensive. Doing it in-memory (Python) avoids repeated database queries and leverages parallel processing.<br>

### Project Overview

The aim of this project is firstly to extract reviews from Skytrax for Singapore Airlines. Our use case for the transformed data is to perform Sentiment Analysis before loading to PostgreSQL database.


### Objective

1. Develop web-scraper with Python that scrapes Singapore Airlines passenger reviews from the Skytrax website and saves the data into a CSV file
2. Familarising with libraries (pandas, textblob, sqlalchemy, matplotlib, seaborn) to do ETL and some EDA
3. Performing ETL and designing the schema, tables and Entity-Relationship model
4. Use of SQL to populate the database

## ETL Process

### Extract Data : Data Collection
1. For our web-scraper, we used requests to fetch HTML pages from Skytrax review pages
2. Parses HTML with BeautifulSoup to extract review details like:
* User name
* Overall rating
* Review title and content
* Trip status, type of traveller, seat type, route, and date flown
3. Handling Pagination by Looping through 100 pages of reviews, Grabbing reviews from each page one at a time and Sleeping for 15 seconds after each request 

### Transform Data : Clean Data
1. Data Cleaning And Dealing with NaN or Missing Data, Drop unnecessary columns
2. Identify NaN Values
3. Drop unnecessary columns
4. Fill NaN Values with 0 or 'Missing'
5. Change "0" in Type of Traveller to "Unknown" 
6. Final Transformed Data That Can Be Loaded To Database

### Transform Data : Transform Data
1. Rename column names to ensure compatibility and standardise column names
2. Change some column types to optimise storage

### Load Data : Load to Database
1. Creating new database, with 2 new schema within that database
2. Load transformed data to 1 schema as source data
3. Normalise source data and populate new tables via SQL script to other schema


### Exploratory Data Analysis

### Tools and Technologies used

### Steps Involved

### Result and Findings

- ....
  
- ....
  
- ....

### Recommendations

- ....

- ....

- ....

### Limitations

- ....

- ....

### Improvements

....
