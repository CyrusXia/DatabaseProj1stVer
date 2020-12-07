CREATE TYPE comment_attitude AS ENUM ('positive', 'neutral', 'negative');

CREATE TYPE gender_enum as ENUM ('Female', 'Male', 'Not specified');

CREATE TYPE race_enum as ENUM ('American Indian or Alaska Native', 'Asian', 'Black or African American', 'Hispanic or Latino', 'Native Hawaiian or other Pacific Islander', 'White', 'Not specified');

CREATE TYPE policy_type as ENUM ('Status of Reopening','Stay at Home Order','Mandatory Quarantine for Travelers','Non-Essential Business Closures','Large Gatherings Ban','Restaurant Limits');

CREATE TYPE Hospital_rating AS ENUM ('1', '2', '3', '4', '5', '6', 'Not Available');

CREATE TABLE State_info
(state_name VARCHAR(40),
 gdp REAL CHECK (gdp >= 0),
 governor VARCHAR(40),
 PRIMARY KEY(state_name)
);

CREATE TABLE City
(population INTEGER CHECK (population >= 0),
 avg_salary REAL CHECK (avg_salary >= 0),
 total_cases INTEGER CHECK (total_cases >= 0),
 new_cases INTEGER CHECK (new_cases >= 0),
 death INTEGER CHECK (death >= 0),
 city_name VARCHAR(40),
 state_name VARCHAR(40),
 PRIMARY KEY(state_name, city_name),
 FOREIGN KEY(state_name) REFERENCES State_info
 	ON DELETE CASCADE
);

CREATE TABLE Hospital
(facility_id VARCHAR(10),
 facility_name VARCHAR(100),
 zipcode VARCHAR(10),
 ownership VARCHAR(50),
 emergency_service VARCHAR(3),
 overall_rating Hospital_rating,
 city_name VARCHAR(40) NOT NULL,
 state_name VARCHAR(40) NOT NULL,
 PRIMARY KEY(facility_id)
 );

CREATE TABLE Patient_hospitalization
(id INTEGER,
 age INTEGER CHECK (age >= 0),
 race VARCHAR(50),
 facility_id VARCHAR(10),
 admission_date TIMESTAMP,
 discharge_date TIMESTAMP CHECK (admission_date < discharge_date),
 PRIMARY KEY(facility_id, id, admission_date),
 FOREIGN KEY(facility_id) REFERENCES Hospital
 	ON DELETE CASCADE
);

CREATE TABLE Policy_published_by_state
(policy_type policy_type,
 details VARCHAR(3000),
 state_name VARCHAR(40),
 created_time TIMESTAMP,
 PRIMARY KEY(state_name, created_time, policy_type),
 FOREIGN KEY(state_name) REFERENCES State_info
  	ON DELETE CASCADE 
);

CREATE TABLE User_info
(username VARCHAR(50),
 age INTEGER,
 gender gender_enum,
 race race_enum,
 PRIMARY KEY(username)
);

CREATE TABLE Comment
(id INTEGER,
 attitude comment_attitude,
 details text,
 comment_created_time TIMESTAMP,
 PRIMARY KEY(id)
);

CREATE TABLE User_comment
(id INTEGER,
 policy_created_time TIMESTAMP NOT NULL,
 policy_type policy_type NOT NULL,
 state_name VARCHAR(40) NOT NULL,
 username VARCHAR(30),
 PRIMARY KEY(id),
 FOREIGN KEY(id) REFERENCES Comment,
 FOREIGN KEY(username) REFERENCES User_info,
 FOREIGN KEY(state_name, policy_created_time, policy_type) REFERENCES Policy_published_by_state
);