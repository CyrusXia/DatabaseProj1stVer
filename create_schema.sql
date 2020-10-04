CREATE TYPE comment_attitude AS ENUM ('positive', 'neutral', 'negative');

CREATE TYPE gender_enum as ENUM ('Female', 'Male', 'Not specified');

CREATE TYPE race_num as ENUM ('American Indian or Alaska Native', 'Asian', 'Black or African American', 'Native Hawaiian or other Pacific Islander', 'White', 'Not specified');

CREATE TYPE policy_type as ENUM ('Status of reopening','Stay at Home Order','Mandatory Quarantine for Travelers','Non-Essential Business Closures','Large Gatherings Ban','Restaurant Limits');

CREATE TYPE Hospital_rating AS ENUM ('1', '2', '3', '4', '5', '6', 'Not Available');

CREATE TABLE US_state
(governor CHAR(40),
 gdp REAL,
 state_name CHAR(40),
 PRIMARY KEY(state_name),
 UNIQUE(governor)
);

CREATE TABLE City
(population INTEGER,
 avg_salary REAL,
 total_cases INTEGER,
 new_cases INTEGER,
 death INTEGER,
 city_name CHAR(40),
 zipcode CHAR(5),
 PRIMARY KEY(city_name, zipcode)
);

CREATE TABLE City_in_state
(city_name CHAR(40),
 zipcode CHAR(5),
 state_name CHAR(40),
 PRIMARY KEY(city_name, zipcode, state_name),
 FOREIGN KEY(state_name) REFERENCES US_state,
 FOREIGN KEY(city_name, zipcode) REFERENCES City
);

CREATE TABLE Hospital
(facility_id CHAR(10),
 facility_name CHAR(50),
 zipcode CHAR(10),
 ownership CHAR(50),
 emergency_service CHAR(2),
 overall_rating Hospital_rating,
 PRIMARY KEY(facility_id)
 );

CREATE TABLE Patient_hospitalization
(id INTEGER,
 age INTEGER,
 race CHAR(20),
 facility_id CHAR(10),
 admission_date TIMESTAMP,
 discharge_date TIMESTAMP,
 PRIMARY KEY(facility_id, id, admission_date),
 FOREIGN KEY(facility_id) REFERENCES Hospital
 	ON DELETE CASCADE
);

CREATE TABLE Hospital_location_info
(facility_id CHAR(10),
 city_name CHAR(40),
 state_name CHAR(40),
 zipcode CHAR(5),
 PRIMARY KEY(facility_id),
 FOREIGN KEY(city_name, zipcode) REFERENCES City
);


CREATE TABLE Policy_published_by_state
(policy_type policy_type,
 details CHAR(3000),
 state_name CHAR(40),
 created_time TIMESTAMP,
 PRIMARY KEY(state_name, created_time, policy_type),
 FOREIGN KEY(state_name) REFERENCES US_state
  	ON DELETE CASCADE 
);

CREATE TABLE User_info
(username CHAR(50),
 age INTEGER,
 gender gender_enum,
 race race_num,
 PRIMARY KEY(username)
);

CREATE TABLE Comment
(id SERIAL,
 attitude comment_attitude,
 details CHAR(300),
 comment_created_time TIMESTAMP,
 PRIMARY KEY(id)
);

CREATE TABLE User_comment
(id INTEGER,
 username CHAR(50),
 PRIMARY KEY(id, username),
 FOREIGN KEY(id) REFERENCES Comment,
 FOREIGN KEY(username) REFERENCES User_info
);

CREATE TABLE User_policy_comment
(policy_created_time TIMESTAMP,
 policy_type policy_type,
 state_name CHAR(40),
 username CHAR(30),
 comment_id INTEGER,
 PRIMARY KEY(state_name, policy_created_time, policy_type, comment_id, username),
 FOREIGN KEY(state_name, policy_created_time, policy_type) REFERENCES Policy_published_by_state,
 FOREIGN KEY(comment_id, username) REFERENCES User_comment
);
