DROP DATABASE IF EXISTS f1_season_2023;
CREATE DATABASE f1_season_2023;
USE f1_season_2023;

CREATE TABLE monaco_gp_2023 (
  car_number INTEGER,
  seconds DECIMAL(7,3)
);

INSERT INTO monaco_gp_2023 VALUES (1, 6531.98);
INSERT INTO monaco_gp_2023 VALUES (14, 6559.901);
INSERT INTO monaco_gp_2023 VALUES (31, 6568.97);
INSERT INTO monaco_gp_2023 VALUES (44, 6571.042);
INSERT INTO monaco_gp_2023 VALUES (63, 6588.264);
INSERT INTO monaco_gp_2023 VALUES (16, 6593.87);
INSERT INTO monaco_gp_2023 VALUES (10, 6594.342);
INSERT INTO monaco_gp_2023 VALUES (55, 6595.371);

SELECT car_number AS 'Car Number', 
seconds - (SELECT MIN(seconds) FROM monaco_gp_2023) AS 'Difference to the Winner',
seconds - LAG(seconds,1,seconds) OVER(ORDER BY seconds) AS 'Difference to Previous Pilot' 
FROM monaco_gp_2023;
