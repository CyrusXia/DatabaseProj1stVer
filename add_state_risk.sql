CREATE TYPE State_evaluation AS ENUM ("High", "Low");

CREATE State_evaluation
(state_name VARCHAR(40),
 state_evaluation State_evaluation,
 PRIMARY KEY(state_name),
 FOREIGN KEY(state_name) REFERENCES State_info
	ON DELETE CASCADE
)