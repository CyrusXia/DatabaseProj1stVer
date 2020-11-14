COPY State_info(state_name, gdp, governor)
FROM 'State_info.csv'
DELIMITER ','
CSV HEADER;

COPY City(population, avg_salary, new_cases, death, city_name, state_name)
FROM 'City_info.csv'
DELIMITER ','
CSV HEADER;

COPY Hospital(facility_id, facility_name, zipcode, ownership, emergency_service, overall_rating, city_name, state_name)
FROM 'Hospital.csv'
DELIMITER ','
CSV HEADER;

COPY Patient_hospitalization(admission_date, discharge_date, age, race, facility_id, id)
FROM 'Patient_hospitalization.csv'
DELIMITER ','
CSV HEADER
;

COPY Policy_published_by_state(policy_type, details, state_name, created_time)
FROM 'Policy_published_by_state.csv'
DELIMITER ','
CSV HEADER
;

COPY User_info(username, age, gender, race)
FROM 'User_info.csv'
DELIMITER ','
CSV HEADER
;

COPY Comment(id, attitude, details, comment_created_time)
FROM 'Comment.csv'
DELIMITER ','
CSV HEADER
;




