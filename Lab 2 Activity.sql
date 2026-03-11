-- Part A: Database Patient_Related_DB created and 4 CSV files imported
CREATE DATABASE Patient_Related_DB;
USE Patient_Related_DB;
CREATE DATABASE IF NOT EXISTS patient_related_db;
USE patient_related_db;

-- 1. Patient Table
CREATE TABLE Patient (
    patient_id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year INT NOT NULL,
    sex VARCHAR(20) NOT NULL,
    height_cm FLOAT NOT NULL,
    weight_kg FLOAT NOT NULL
) ENGINE=InnoDB;


-- 2. procedure_types Table
CREATE TABLE procedure_types (
    procedure_code VARCHAR(50) PRIMARY KEY,
    procedure_name VARCHAR(100) NOT NULL,
    typical_duration_min INT NOT NULL,
    procedure_type VARCHAR(50) NOT NULL
) ENGINE=InnoDB;


-- 3. procedure Table
CREATE TABLE `procedure` (
    procedure_id VARCHAR(50) PRIMARY KEY,
    procedure_year INT NOT NULL,
    procedure_code VARCHAR(50) NOT NULL,
    procedure_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (procedure_code) REFERENCES procedure_types(procedure_code)
) ENGINE=InnoDB;

-- 4. patients_procedure Table  (FIXED TYPE HERE)
CREATE TABLE patients_procedure (
    procedure_id VARCHAR(50) NOT NULL,
    patient_id VARCHAR(50) NOT NULL,
    PRIMARY KEY (procedure_id, patient_id),
    FOREIGN KEY (procedure_id) REFERENCES `procedure`(procedure_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
) ENGINE=InnoDB;

-- verification
SELECT 'Patient' AS table_name, COUNT(*) AS total_rows FROM Patient
UNION ALL
SELECT 'procedure_types', COUNT(*) FROM procedure_types
UNION ALL
SELECT 'procedure', COUNT(*) FROM `procedure`
UNION ALL
SELECT 'patients_procedure', COUNT(*) FROM patients_procedure;

-- Lab Part B: Healthcare Data Analytics & Extraction
-- Task #1 – Population Health & Administrative Reporting
-- Q1: Patient Age Distribution
SELECT 
    patient_id,
    first_name,
    last_name,
    (2026 - birth_year) AS Age
FROM Patient;
-- Q1: Average Age
SELECT 
    AVG(2026 - birth_year) AS Average_Age
FROM Patient;

-- Q2: Annual Clinical Volume (2015–2024)
-- Q2: Annual Clinical Volume
SELECT 
    procedure_year,
    COUNT(*) AS total_procedures
FROM `procedure`
GROUP BY procedure_year
ORDER BY total_procedures DESC;

-- Q3: Procedure Duration Benchmarking
SELECT 
    pt.procedure_type,
    AVG(pt.typical_duration_min) AS avg_duration_minutes
FROM procedure_types pt
GROUP BY pt.procedure_type
ORDER BY avg_duration_minutes DESC;

-- --------------------------------------------------------------------------------------------------------- --
-- Task #2 – Clinical Utilization & Outlier Detection
-- Q4: High-Utilizers
SELECT 
    p.patient_id,
    p.first_name,
    p.last_name,
    COUNT(pp.procedure_id) AS total_procedures
FROM Patient p
JOIN patients_procedure pp 
    ON p.patient_id = pp.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
HAVING COUNT(pp.procedure_id) > 3
ORDER BY total_procedures DESC;

-- Q5: Weight Outliers
SELECT 
    patient_id,
    first_name,
    last_name,
    weight_kg
FROM Patient
WHERE weight_kg > (
    SELECT AVG(weight_kg)
    FROM Patient
);

-- Q6: Patients with No Procedures
SELECT 
    p.patient_id,
    p.first_name,
    p.last_name
FROM Patient p
LEFT JOIN patients_procedure pp
    ON p.patient_id = pp.patient_id
WHERE pp.procedure_id IS NULL;

-- --------------------------------------------------------------------------------------------------------------------------- --
-- Task #3 – Advanced Clinical Logic
-- Q7: BMI Classification
SELECT 
    patient_id,
    first_name,
    last_name,
    weight_kg / POWER(height_cm / 100, 2) AS BMI,
    CASE
        WHEN weight_kg / POWER(height_cm / 100, 2) < 18.5 THEN 'Underweight'
        WHEN weight_kg / POWER(height_cm / 100, 2) BETWEEN 18.5 AND 24.9 THEN 'Normal'
        WHEN weight_kg / POWER(height_cm / 100, 2) BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS BMI_Category
FROM Patient;

-- Q8: Full Clinical Report
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS Patient_Name,
    pr.procedure_name,
    pt.procedure_type,
    pr.procedure_year
FROM Patient p
JOIN patients_procedure pp 
    ON p.patient_id = pp.patient_id
JOIN `procedure` pr 
    ON pp.procedure_id = pr.procedure_id
JOIN procedure_types pt 
    ON pr.procedure_code = pt.procedure_code
ORDER BY pr.procedure_year DESC;

-- Q9: Data Quality Audit
-- Q9: Data Quality Audit
SELECT *
FROM Patient
WHERE birth_year > 2026
   OR weight_kg <= 0;
-- ------------------------------------------------------------------------------------------- --

-- Lab Part C: Visual Analytics (Data Extraction to Chart)
-- Q10: Graph Ready Query
SELECT 
    procedure_year AS Year,
    COUNT(*) AS Total_Procedures
FROM `procedure`
GROUP BY procedure_year
ORDER BY procedure_year ASC;


-- Q11 – Clinical Department Mix (Pie Chart Data)
SELECT 
    pt.procedure_type,
    COUNT(*) AS Volume
FROM procedure_types pt
JOIN `procedure` p 
    ON pt.procedure_code = p.procedure_code
GROUP BY pt.procedure_type;










