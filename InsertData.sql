COPY State_info(state_name, gdp, governor)
FROM 'F:\PSun-data\COMS4111\final_data\State_info.csv'
DELIMITER ','
CSV HEADER;

COPY City(population, avg_salary, new_cases, death, city_name, state_name)
FROM 'F:\PSun-data\COMS4111\final_data\City_info.csv'
DELIMITER ','
CSV HEADER;

COPY Hospital(facility_id, facility_name, zipcode, ownership, emergency_service, overall_rating, city_name, state_name)
FROM 'F:\PSun-data\COMS4111\final_data\Hospital.csv'
DELIMITER ','
CSV HEADER;

COPY Patient_hospitalization(admission_date, discharge_date, age, race, facility_id, id)
FROM 'F:\PSun-data\COMS4111\final_data\Patient_hospitalization.csv'
DELIMITER ','
CSV HEADER
;

COPY Policy_published_by_state(policy_type, details, state_name, created_time)
FROM 'F:\PSun-data\COMS4111\final_data\Policy_published_by_state.csv'
DELIMITER ','
CSV HEADER
;

COPY User_info(username, age, gender, race)
FROM 'F:\PSun-data\COMS4111\final_data\User_info.csv'
DELIMITER ','
CSV HEADER
;

COPY Comment(id, attitude, details, comment_created_time)
FROM 'F:\PSun-data\COMS4111\final_data\Comment.csv'
DELIMITER ','
CSV HEADER
;




