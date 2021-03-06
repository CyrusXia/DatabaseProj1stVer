DROP TABLE IF EXISTS City_evaluation;
DROP TYPE IF EXISTS evaluation;
DROP TRIGGER IF EXISTS update_city_evaluation ON City;

CREATE TYPE evaluation AS ENUM ('Low risk', 'High risk');

CREATE TYPE evaluation_suggestion AS (
	evaluation evaluation,
	suggestion text
);

CREATE TABLE City_evaluation(
state_name VARCHAR(40),
city_name VARCHAR(40),
evaluate_time TIMESTAMP,
evaluation_suggestion evaluation_suggestion,
PRIMARY KEY (state_name, city_name, evaluate_time),
FOREIGN KEY (state_name, city_name) REFERENCES City
	ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION update_city_evaluation_func()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL AS
$$
BEGIN
	IF (NEW.new_cases::decimal / OLD.population) > 0.1 THEN
		INSERT INTO City_evaluation(state_name, city_name, evaluate_time, evaluation_suggestion)
		VALUES(NEW.state_name, NEW.city_name, now(), ROW('High risk','High risk area! Please always wear masks and keep social distance.'));
	ELSE
		INSERT INTO City_evaluation(state_name, city_name, evaluate_time, evaluation_suggestion)
		VALUES(NEW.state_name, NEW.city_name, now(), ROW('Low risk','Low risk area. Please still wear masks and keep social distance.'));
	END IF;

	RETURN NEW;

END;
$$;

CREATE TRIGGER update_city_evaluation
  AFTER UPDATE
  ON City
  FOR EACH ROW
  EXECUTE PROCEDURE update_city_evaluation_func();

