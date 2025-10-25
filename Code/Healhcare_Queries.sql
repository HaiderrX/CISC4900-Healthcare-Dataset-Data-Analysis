CREATE TABLE Hospital (
  hospital_id INT IDENTITY(1,1) PRIMARY KEY,
  hospital_name VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE Doctor (
  doctor_id INT IDENTITY(1,1) PRIMARY KEY,
  doctor_name VARCHAR(100) NOT NULL,
  hospital_id INT NOT NULL,
  CONSTRAINT FK_Doctor_Hospital FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id)
);

CREATE TABLE Billing (
  billing_id INT IDENTITY(1,1) PRIMARY KEY,
  insurance_provider VARCHAR(100) NOT NULL UNIQUE,
  default_billing_amount DECIMAL(10,2) NOT NULL DEFAULT(0.00)
);

CREATE TABLE Patient (
  patient_id INT IDENTITY(1,1) PRIMARY KEY,
  patient_name VARCHAR(100) NOT NULL,
  age TINYINT CHECK (age BETWEEN 0 AND 120),
  gender CHAR(1) CHECK (gender IN ('M','F','O')),
  blood_type CHAR(3),
  medical_condition VARCHAR(100),
  doctor_id INT NOT NULL,
  insurance_provider_id INT,
  CONSTRAINT FK_Patient_Doctor FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
  CONSTRAINT FK_Patient_Billing FOREIGN KEY (insurance_provider_id) REFERENCES Billing(billing_id)
);

CREATE TABLE Admission (
  admission_id INT IDENTITY(1,1) PRIMARY KEY,
  patient_id INT NOT NULL,
  admission_date DATE NOT NULL,
  discharge_date DATE,
  treatment_days INT CHECK (treatment_days >= 0),
  admission_type VARCHAR(20),
  room_number INT,
  test_results VARCHAR(100),
  billing_amount DECIMAL(10,2) NOT NULL DEFAULT(0.00),
  CONSTRAINT FK_Admission_Patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE Medical_Record (
  medical_record_id INT IDENTITY(1,1) PRIMARY KEY,
  patient_id INT NOT NULL,
  medication VARCHAR(100) NOT NULL,
  test_results VARCHAR(100),
  record_date DATE NOT NULL DEFAULT (GETDATE()),
  CONSTRAINT FK_MedicalRecord_Patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);
