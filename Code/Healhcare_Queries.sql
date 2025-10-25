CREATE TABLE Hospital(
  hospital_name VARCHAR(150) PRIMARY KEY 
  ); 

CREATE TABLE Doctor (
  doctor_id INT PRIMARY KEY,
  doctor_name VARCHAR(100), 
  hospital_name VARCHAR(150), 
  CONSTRAINT FK_Doctor_Hospital FOREIGN KEY (hospital_name) REFERENCES Hospital(hospital_name)
  );

CREATE TABLE Billing ( insurance_provider VARCHAR(100) PRIMARY KEY, 
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
