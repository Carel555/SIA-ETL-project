--CREATING 4 TABLES IN sia_normalised schema
CREATE TABLE IF NOT EXISTS sia_normalised.traveller_type (
    traveller_type_id SERIAL PRIMARY KEY,
    type_of_traveller VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS sia_normalised.seat_type (
    seat_type_id SERIAL PRIMARY KEY,
    seat_type VARCHAR(100) UNIQUE
);

CREATE TABLE IF NOT EXISTS sia_normalised.sia_users (
    sia_user_id SERIAL PRIMARY KEY,
    user_name TEXT,
    overall_rating SMALLINT,
    detail_review TEXT,
    date_flown DATE,
    value_for_money_rating SMALLINT,
    recommended BOOLEAN,
	traveller_type_id INT REFERENCES sia_normalised.traveller_type(traveller_type_id),
    seat_type_id INT REFERENCES sia_normalised.seat_type(seat_type_id)
);

CREATE TABLE IF NOT EXISTS sia_normalised.user_ratings (
    rating_id SERIAL PRIMARY KEY,
    sia_user_id INT REFERENCES sia_normalised.sia_users(sia_user_id),
    seat_comfort_rating NUMERIC(3,1),
    staff_service_rating NUMERIC(3,1),
    food_beverages_rating NUMERIC(3,1),
    inflight_entertainment_rating NUMERIC(3,1),
    ground_service_rating NUMERIC(3,1)
);

-- Populate traveller_type table
INSERT INTO sia_normalised.traveller_type (type_of_traveller)
SELECT DISTINCT type_of_traveller 
FROM sia_source.sia_users;

SELECT * FROM sia_normalised.traveller_type;

-- Populate seat_type table
INSERT INTO sia_normalised.seat_type (seat_type)
SELECT DISTINCT seat_type 
FROM sia_source.sia_users;

SELECT * FROM sia_normalised.seat_type;

-- Populate sia_users table
INSERT INTO sia_normalised.sia_users (
	user_name, 
	overall_rating, 
	detail_review, 
	date_flown, 
	value_for_money_rating, 
	recommended,
	traveller_type_id,
    seat_type_id
)
SELECT user_name, 
	overall_rating, 
	detail_review, 
	date_flown, 
	value_for_money_rating, 
	recommended,
	(SELECT traveller_type_id FROM sia_normalised.traveller_type WHERE type_of_traveller = sia_source.sia_users.type_of_traveller LIMIT 1),
    (SELECT seat_type_id FROM sia_normalised.seat_type WHERE seat_type = sia_source.sia_users.seat_type LIMIT 1)
FROM sia_source.sia_users;

SELECT * FROM sia_normalised.sia_users;

-- Populate user_ratings table
INSERT INTO sia_normalised.user_ratings (
	sia_user_id,
    seat_comfort_rating,
    staff_service_rating,
	food_beverages_rating,
    inflight_entertainment_rating,
    ground_service_rating
)
SELECT su.sia_user_id,
	src.seat_comfort_rating,
	src.staff_service_rating,
	src.food_beverages_rating,
    src.inflight_entertainment_rating,
    src.ground_service_rating
FROM sia_source.sia_users src
JOIN sia_normalised.sia_users su 
ON src.user_name = su.user_name;

SELECT * FROM sia_normalised.user_ratings;