CREATE TRIGGER CityTotalCase
AFTER UPDATE OF new_cases ON City
REFERENCING OLD ROW AS OldTuple
	    NEW ROW AS NewTuple
FOR EACH ROW
WHEN (NewTuple.new_cases != 0)
    UPDATE City
    SET total_cases = OldTuple.total_cases + NewTuple.new_cases
    WHERE state_name = NewTuple.state_name 
        AND city_name = NewTuple.city_name
