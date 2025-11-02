-- Initialize DB:
USE HealthcareQueries;
GO

-- Check tables
SELECT name 
FROM sys.tables 
ORDER BY name;

-- Create Empty Tables
CREATE TABLE Hospital (
  hospital_name VARCHAR(150) PRIMARY KEY
);

CREATE TABLE Doctor (
  doctor_id INT PRIMARY KEY,
  doctor_name VARCHAR(100),
  hospital_name VARCHAR(150),
  CONSTRAINT FK_Doctor_Hospital FOREIGN KEY (hospital_name) REFERENCES Hospital(hospital_name)
);

CREATE TABLE Billing (
  insurance_provider VARCHAR(100) PRIMARY KEY,
  billing_amount DECIMAL(10,2)
);

CREATE TABLE Patient (
  patient_id INT PRIMARY KEY,
  patient_name VARCHAR(100),
  age INT,
  gender VARCHAR(10),
  blood_type CHAR(3),
  medical_condition VARCHAR(100),
  doctor_id INT,
  insurance_provider VARCHAR(100),
  CONSTRAINT FK_Patient_Doctor FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
  CONSTRAINT FK_Patient_Billing FOREIGN KEY (insurance_provider) REFERENCES Billing(insurance_provider)
);

CREATE TABLE Admission (
  admission_id INT IDENTITY(1,1) PRIMARY KEY,
  patient_id INT,
  admission_date DATE,
  discharge_date DATE,
  treatment_days INT,
  admission_type VARCHAR(20),
  room_number INT,
  test_results VARCHAR(20),
  billing_amount DECIMAL(10,2),
  CONSTRAINT FK_Admission_Patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE Medical_Record (
  medication VARCHAR(100) PRIMARY KEY,
  test_results VARCHAR(20)
);

-- Verify Tables
SELECT name FROM sys.tables ORDER BY name; 

-- Check which one is populated
SELECT COUNT(*) FROM healthcare_cleaned;
SELECT COUNT(*) FROM Patient;

-- Verified the old csv is populated, need to insert values to tables
SELECT TOP 5 * FROM healthcare_cleaned;

-- Inserting columns to tables:
INSERT INTO Hospital (hospital_name)
SELECT DISTINCT hospital_name
FROM healthcare_cleaned
WHERE hospital_name IS NOT NULL;

INSERT INTO Doctor (doctor_id, doctor_name, hospital_name)
SELECT 
  doctor_id,
  doctor_name,
  MIN(hospital_name) AS hospital_name
FROM healthcare_cleaned
GROUP BY doctor_id, doctor_name;

INSERT INTO Billing (insurance_provider, billing_amount)
SELECT 
  insurance_provider,
  MIN(billing_amount) AS billing_amount
FROM healthcare_cleaned
WHERE insurance_provider IS NOT NULL
GROUP BY insurance_provider;

INSERT INTO Patient (
  patient_id, patient_name, age, gender, blood_type, medical_condition, doctor_id, insurance_provider
)
SELECT 
  patient_id, patient_name, age, gender, blood_type, medical_condition, doctor_id, insurance_provider
FROM healthcare_cleaned;

INSERT INTO Admission (
  patient_id, admission_date, discharge_date, treatment_days, admission_type, room_number, test_results, billing_amount
)
SELECT 
  patient_id, admission_date, discharge_date, treatment_days, admission_type, room_number, test_results, billing_amount
FROM healthcare_cleaned
WHERE patient_id IS NOT NULL;

INSERT INTO Medical_Record (medication, test_results)
SELECT 
  medication,
  MIN(test_results) AS test_results
FROM healthcare_cleaned
WHERE medication IS NOT NULL
GROUP BY medication;

-- Verified Tables are populated:
SELECT 'Hospital' AS TableName, COUNT(*) AS TotalRows FROM Hospital
UNION ALL
SELECT 'Doctor', COUNT(*) FROM Doctor
UNION ALL
SELECT 'Billing', COUNT(*) FROM Billing
UNION ALL
SELECT 'Patient', COUNT(*) FROM Patient
UNION ALL
SELECT 'Admission', COUNT(*) FROM Admission
UNION ALL
SELECT 'Medical_Record', COUNT(*) FROM Medical_Record;

-- Querying:

-- Gender Count:
SELECT gender, COUNT(*)
FROM Patient
GROUP BY gender;

-- Patient Count
SELECT COUNT(*) AS total_patients FROM Patient;

-- Distinct Medical Conditions:
SELECT DISTINCT medical_condition
FROM Patient;

-- Patients older than 65:
SELECT medical_condition,
       COUNT(*) AS number_of_patients_over_65
FROM Patient
WHERE age > 65
GROUP BY medical_condition;

-- Min/Max age:
SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM Patient;

--Oldest Patients to youngest:
SELECT patient_name,
		age
FROM Patient
ORDER BY age DESC;

-- Insurance Check
SELECT DISTINCT insurance_provider
FROM Billing;

-- Top 10 oldest patient information:
SELECT TOP 10 patient_name,
			medical_condition,
			age
FROM Patient
ORDER BY age DESC;

-- Bottom 10 patient information:
SELECT TOP 10 patient_name,
			medical_condition,
			age
FROM Patient
ORDER BY age;

-- Blood Types + Patient Count:
SELECT blood_type,
		COUNT(*) as Patient_Count
FROM Patient
GROUP BY blood_type
ORDER BY Patient_Count DESC;

-- Average Age for both genders:
SELECT AVG(age) as AverageAge, gender
FROM Patient
GROUP BY gender
ORDER BY AverageAge DESC;

-- Age Count + Condition Count:
SELECT
	CASE
		WHEN age BETWEEN 10 AND 20 THEN '10-20'
		WHEN age BETWEEN 21 AND 30 THEN '21-30'
		WHEN age BETWEEN 31 AND 40 THEN '31-40'
		WHEN age BETWEEN 41 AND 50 THEN '41-50'
		WHEN age BETWEEN 51 AND 60 THEN '51-60'
		WHEN age BETWEEN 61 AND 70 THEN '61-70'
		WHEN age BETWEEN 71 AND 80 THEN '71-80'
		ELSE '81+'
	END AS age_group,
	medical_condition,
	COUNT(*) AS total_patients
FROM Patient
GROUP BY 
  CASE 
    WHEN age BETWEEN 10 AND 20 THEN '10-20'
    WHEN age BETWEEN 21 AND 30 THEN '21-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
    WHEN age BETWEEN 41 AND 50 THEN '41-50'
    WHEN age BETWEEN 51 AND 60 THEN '51-60'
    WHEN age BETWEEN 61 AND 70 THEN '61-70'
    WHEN age BETWEEN 71 AND 80 THEN '71-80'
    ELSE '81+' 
  END,
  medical_condition
ORDER BY age_group, total_patients DESC;

-- Patients per Hospital:
SELECT
	d.hospital_name,
	COUNT(p.patient_id) AS total_patients
FROM Patient p
JOIN Doctor d ON p.doctor_id = d.doctor_id
GROUP BY d.hospital_name
ORDER BY total_patients DESC;

-- Avg Treatment Days by Condition:
SELECT 
	p.medical_condition,
	AVG(a.treatment_days) AS average_days
FROM Patient p
JOIN Admission a ON p.patient_id = a.patient_id
GROUP BY p.medical_condition
ORDER BY average_days DESC;

-- Total Billing per Insurance Provider:
SELECT 
	b.insurance_provider,
	SUM(a.billing_amount) AS total_bill
FROM Billing b
JOIN Patient p ON b.insurance_provider = p.insurance_provider
JOIN Admission a ON p.patient_id = a.patient_id
GROUP BY b.insurance_provider
ORDER BY total_bill DESC;

-- Most Common Conditions per Hospital:
SELECT	
	d.hospital_name,
	p.medical_condition,
	COUNT(*) as case_count
FROM Patient p
JOIN Doctor d ON p.doctor_id = d.doctor_id
GROUP BY d.hospital_name, p.medical_condition
ORDER BY d.hospital_name, case_count DESC;

-- Top 10 Doctors with the most Patients:
SELECT TOP 10
	d.doctor_name,
	COUNT(p.patient_id) as total_patients
FROM Patient p
JOIN Doctor d on p.doctor_id = d.doctor_id
GROUP BY d.doctor_name
ORDER BY total_patients DESC;

-- Total Billing by Blood Type:
SELECT 
	p.blood_type,
	SUM(a.billing_amount) AS total_bill
FROM Patient p
JOIN Admission a ON p.patient_id = a.patient_id
GROUP BY p.blood_type
ORDER BY total_bill DESC;

-- Avg Treatment Days by Admission Type:
SELECT 
	admission_type,
	AVG(treatment_days) AS avg_days
FROM Admission
GROUP BY admission_type
ORDER BY avg_days DESC;

-- Find avg billing amt for patients who stayed longer than 15 days:
WITH LongTreatments AS (
    SELECT
        p.patient_id,
        a.treatment_days,
        a.billing_amount
    FROM Patient p
    JOIN Admission a ON p.patient_id = a.patient_id
    WHERE a.treatment_days >= 15
)
SELECT 
    CAST(ROUND(AVG(CAST(billing_amount AS DECIMAL(10,2))), 2) AS DECIMAL(10,2)) AS avg_billing_for_long_treatments
FROM LongTreatments;

-- total billing amount per insurance provider, broken down by blood type:
WITH BillingDetails AS (
	SELECT
		p.blood_type,
		p.insurance_provider,
		a.billing_amount
	FROM Patient p
	JOIN Admission a ON p.patient_id = a.patient_id
)
SELECT 
  insurance_provider,
  blood_type,
  ROUND(SUM(billing_amount), 2) AS total_billed
FROM BillingDetails
GROUP BY insurance_provider, blood_type
ORDER BY insurance_provider, total_billed DESC;

-- Average billing amount per gender, but only for patients who had emergency admissions and stayed more than 5 days
WITH EmergencyStays AS (
	SELECT
		p.gender,
		a.billing_amount
	FROM Patient p
	JOIN Admission a ON p.patient_id = a.patient_id
	WHERE a.admission_type = 'EMERGENCY' AND a.treatment_days > 5
)
SELECT 
	gender,
	 CAST(ROUND(AVG(billing_amount), 2) AS FLOAT)  AS avg_emergency_billing
FROM EmergencyStays
GROUP BY gender
ORDER BY avg_emergency_billing DESC;	

-- Top 3 Admissions by Total Billing For Patients with Blood Type 'O'
WITH BloodOAdmissions AS (
	SELECT 
		a.admission_type,
		a.billing_amount
	FROM Patient p
	JOIN Admission a ON p.patient_id = a.patient_id
	WHERE p.blood_type LIKE 'O%'
),

BillingType AS (
SELECT 
	admission_type,
	SUM(billing_amount) AS total_billed
FROM BloodOAdmissions
GROUP BY admission_type
)
SELECT
	admission_type,
	ROUND(total_billed, 2) AS total_billed
FROM BillingType
ORDER BY total_billed DESC;

-- Total billing per treatment category (Short vs. Long stay), broken down by admission type
WITH StayClassification AS (
	SELECT
		a.admission_type,
		a.billing_amount,
		CASE
		WHEN a.treatment_days <= 3 THEN 'Short Stay'
		WHEN a.treatment_days <= 5 THEN 'Medium Stay'
		ELSE 'Long Stay'
		END AS stay_category
	FROM Admission a
),
BillingSummary AS (
	SELECT 
		stay_category,
		admission_type,
		SUM(billing_amount) AS total_billed
	FROM StayClassification
	GROUP BY stay_category, admission_type
)
SELECT
	stay_category,
	admission_type,
	ROUND(total_billed, 2) AS total_billed
FROM BillingSummary
ORDER BY stay_category, total_billed;


-- Doctor’s total number of patients and their average treatment duration
WITH DoctorAdmissions AS (
	SELECT
		d.doctor_id,
		d.doctor_name,
		a.treatment_days
	FROM Doctor d
	JOIN Patient p ON d.doctor_id = p.doctor_id
	JOIN Admission a ON p.patient_id = a.patient_id
),
DoctorStats AS (
	SELECT
		doctor_id,
		doctor_name,
		COUNT(*) AS total_patients,
		ROUND(AVG(treatment_days), 2) AS avg_treatment_days
	FROM DoctorAdmissions	
	GROUP BY doctor_id, doctor_name
)
SELECT 
	doctor_name,
	total_patients,
	avg_treatment_days
FROM DoctorStats
ORDER BY total_patients DESC;