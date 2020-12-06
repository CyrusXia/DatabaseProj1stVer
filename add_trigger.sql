DROP TABLE IF EXISTS City_evaluation;
DROP TYPE IF EXISTS evaluation;

CREATE TYPE evaluation AS ENUM ('Low risk', 'High risk');

CREATE TABLE City_evaluation(
state_name VARCHAR(40),
city_name VARCHAR(40),
evaluate_time TIMESTAMP,
evaluation evaluation,
PRIMARY KEY (state_name, city_name, evaluate_time),
FOREIGN KEY (state_name, city_name) REFERENCES City
	ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION update_city_evaluation_func()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL AS
$$
BEGIN
	IF NEW.new_cases / OLD.population > 0.1 THEN
		INSERT INTO City_evaluation(state_name, city_name, evaluate_time, evaluation)
		VALUES(NEW.state_name, NEW.city_name, now(), 'High risk');
	ELSE
		INSERT INTO City_evaluation(state_name, city_name, evaluate_time, evaluation)
		VALUES(NEW.state_name, NEW.city_name, now(), 'Low risk');
	END IF;

	RETURN NEW;

END;
$$;

CREATE OR REPLACE TRIGGER update_city_evaluation
  AFTER UPDATE
  ON City
  FOR EACH ROW
  EXECUTE PROCEDURE update_city_evaluation_func();

