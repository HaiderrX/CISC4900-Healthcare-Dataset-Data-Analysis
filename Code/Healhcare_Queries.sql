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

