-- creating the database ml100k if it does not exists
CREATE database IF NOT EXISTS ml100k 
comment "This is ml-100k dataset" 
LOCATION '/user/hive/warehouse/ml-100k' 
WITH DBPROPERTIES ('createdby'='naqeeb','createdfor'='training');

-- creating the users table from ml100k
CREATE TABLE IF NOT EXISTS ml100k.users (
user_id BIGINT COMMENT 'unique id for each user',
age INT COMMENT 'user age',
gender CHAR(1) COMMENT 'user gender',
occupation STRING COMMENT 'user occupation',
zip INT COMMENT 'user address zip code'
)
COMMENT 'This table holds the demography info for each user'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/ml-100k.db/users';
;

-- loading the users data from ml-100k
LOAD DATA INPATH '/user/hadoop/ml-100k/u.user'
INTO TABLE ml100k.users;

-- CREATING movie table
CREATE TABLE IF NOT EXISTS ml100k.movies (
movieid BIGINT COMMENT 'unique id for each movie',
title STRING COMMENT 'title of the movie',
release_date STRING COMMENT 'release_date of the movie'
)
COMMENT 'This table holds the info for each movie'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/ml-100k.db/movies';
;

-- loading the movies data from ml-100k
LOAD DATA INPATH '/user/hadoop/ml-100k/u.item'
INTO TABLE ml100k.movies;

-- creating the ratings table from ml100k
CREATE TABLE IF NOT EXISTS ml100k.ratings (
user_id BIGINT COMMENT 'unique id for each user',
movieid BIGINT COMMENT 'unique id for each movie',
rating INT COMMENT 'rating by each user to each movie',
rating_time STRING COMMENT 'time stamp for each user'
)
COMMENT 'This table holds the rating for each movie'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/ml-100k.db/ratings';

-- loading the movies data from ml-100k
LOAD DATA INPATH '/user/hadoop/ml-100k/u.data'
INTO TABLE ml100k.ratings;