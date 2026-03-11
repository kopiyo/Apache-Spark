-- Q1: Display all patients whose:
-- height_cm is greater than 170 OR
-- weight_kg is greater than 80
-- Order the results by: weight_kg in ascending order and height_cm in descending order
SELECT
  patient_id, first_name, last_name, birth_year, sex, height_cm, weight_kg
FROM patients
WHERE height_cm > 170
   OR weight_kg > 80
ORDER BY weight_kg ASC, height_cm DESC;

-- Q2: Find the Cartesian product between the patients table and the procedures table.
SELECT
  p.patient_id, p.first_name, p.last_name,
  pr.procedure_id, pr.procedure_year, pr.procedure_code, pr.procedure_name
FROM patients AS p
CROSS JOIN procedures AS pr;

-- If one new patient is added, 7 additional rows will appear in the Cartesian product because the new patient will be paired with each of the 7 existing procedures, 
-- creating one new row per procedure.


-- Q3: Find the patient_id, first_name, and last_name of patients whose second character in their
-- first_name is either 'o' or 'i
SELECT
  patient_id, first_name, last_name
FROM patients
WHERE SUBSTRING(first_name, 2, 1) IN ('o', 'i');

-- Q4: Display patients whose: first_name has exactly five characters
-- OR
-- have undergone a procedure with the name 'Cardiac Surgery'

SELECT DISTINCT
  p.patient_id, p.first_name, p.last_name, p.birth_year, p.sex, p.height_cm, p.weight_kg
FROM patients AS p
LEFT JOIN patient_procedures AS pp
  ON pp.patient_id = p.patient_id
LEFT JOIN procedures AS pr
  ON pr.procedure_id = pp.procedure_id
WHERE CHAR_LENGTH(p.first_name) = 5
   OR pr.procedure_name = 'Cardiac Surgery';
   
-- Q5: Display all procedures performed on:
-- Emily Johnson
-- Michael Smith
-- Use the UNION operator.
SELECT
  p.patient_id, p.first_name, p.last_name,
  pr.procedure_id, pr.procedure_year, pr.procedure_code, pr.procedure_name
FROM patients AS p
JOIN patient_procedures AS pp ON pp.patient_id = p.patient_id
JOIN procedures AS pr ON pr.procedure_id = pp.procedure_id
WHERE p.first_name = 'Emily' AND p.last_name = 'Johnson'

UNION

SELECT
  p.patient_id, p.first_name, p.last_name,
  pr.procedure_id, pr.procedure_year, pr.procedure_code, pr.procedure_name
FROM patients AS p
JOIN patient_procedures AS pp ON pp.patient_id = p.patient_id
JOIN procedures AS pr ON pr.procedure_id = pp.procedure_id
WHERE p.first_name = 'Michael' AND p.last_name = 'Smith';

-- Q6: Display all procedures that were performed in the year 2018.
SELECT
  procedure_id, procedure_year, procedure_code, procedure_name
FROM procedures
WHERE procedure_year = 2018;

