CREATE DATABASE hospital_analysis;
USE hospital_analysis;

CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50),
    registration_date DATE
);

CREATE TABLE doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    doctor_name VARCHAR(100),
    department VARCHAR(50),
    experience_years INT,
    consultation_fee DECIMAL(10,2)
);

CREATE TABLE appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    doctor_id VARCHAR(10),
    appointment_date DATE,
    appointment_time TIME,
    appointment_status VARCHAR(20),
    appointment_reason VARCHAR(50)
);

CREATE TABLE billing (
    bill_id VARCHAR(10) PRIMARY KEY,
    appointment_id VARCHAR(10),
    patient_id VARCHAR(10),
    treatment_type VARCHAR(50),
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    bill_amount DECIMAL(12,2),
    discount DECIMAL(12,2),
    net_amount DECIMAL(12,2)
);

CREATE TABLE diagnoses (
    diagnosis_id VARCHAR(10) PRIMARY KEY,
    appointment_id VARCHAR(10),
    patient_id VARCHAR(10),
    diagnosis VARCHAR(50),
    severity VARCHAR(20)
);

SHOW TABLES;

SELECT COUNT(*) FROM patients;
SELECT COUNT(*) FROM doctors;
SELECT COUNT(*) FROM appointments;
SELECT COUNT(*) FROM billing;
SELECT COUNT(*) FROM diagnoses;

SELECT COUNT(*) AS total_patients   -- Count Total Patients
FROM patients;

SELECT COUNT(*) AS total_doctors    -- Count Total Doctors
FROM doctors;

SELECT COUNT(*) AS total_appointments  -- Count Total Appointments 
FROM appointments;

SELECT                                 -- Patient Count by Gender 
    gender,
    COUNT(*) AS total_patients
FROM patients
GROUP BY gender;

SELECT                             -- Doctors by Department
department,
    COUNT(*) AS total_doctors
FROM doctors
GROUP BY department
ORDER BY total_doctors DESC;

SELECT                          --  Appointments by Status
    appointment_status,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY appointment_status
ORDER BY total_appointments DESC;


SELECT                      --  Appointments by Department
    d.department,
    COUNT(*) AS total_appointments
FROM appointments a
JOIN doctors d
    ON a.doctor_id = d.doctor_id
GROUP BY d.department
ORDER BY total_appointments DESC;

SELECT                       --  Top 10 Doctors by Appointments
    d.doctor_name,
    d.department,
    COUNT(a.appointment_id) AS total_appointments
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.department
ORDER BY total_appointments DESC
LIMIT 10;

  
SELECT SUM(bill_amount) AS total_bill_amount          -- Calculate Total Bill Amount 
FROM billing;

SELECT SUM(net_amount) AS total_net_revenue           --  Calculate Total Net Revenue
FROM billing;

SELECT AVG(bill_amount) AS average_bill_amount       -- Calculate Average Bill Amount
FROM billing;

SELECT                                                -- Revenue by Treatment Type  
    treatment_type,
    SUM(net_amount) AS total_revenue
FROM billing
GROUP BY treatment_type
ORDER BY total_revenue DESC;


SELECT                    -- Revenue by Payment Method
    payment_method,
    SUM(net_amount) AS total_revenue
FROM billing
GROUP BY payment_method
ORDER BY total_revenue DESC;


SELECT                   -- Bills by Payment Status
    payment_status,
    COUNT(*) AS total_bills
FROM billing
GROUP BY payment_status
ORDER BY total_bills DESC;


SELECT                      --  Top 10 Treatments by Revenue
    treatment_type,
    SUM(net_amount) AS total_revenue
FROM billing
GROUP BY treatment_type
ORDER BY total_revenue DESC
LIMIT 10;

SELECT                                      -- Patients by City
    city,
    COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC;


SELECT                                      -- Patients by Age Group
    CASE
        WHEN age < 18 THEN 'Child'
        WHEN age BETWEEN 18 AND 40 THEN 'Adult'
        WHEN age BETWEEN 41 AND 60 THEN 'Middle Age'
        ELSE 'Senior'
    END AS age_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY age_group
ORDER BY total_patients DESC;


SELECT                                      -- Average Patient Age
    AVG(age) AS average_patient_age
FROM patients;


SELECT                                      -- Patients by State
    state,
    COUNT(*) AS total_patients
FROM patients
GROUP BY state
ORDER BY total_patients DESC;


SELECT                                      -- Most Common Diagnoses
    diagnosis,
    COUNT(*) AS total_cases
FROM diagnoses
GROUP BY diagnosis
ORDER BY total_cases DESC;


SELECT                                      -- Diagnoses by Severity
    severity,
    COUNT(*) AS total_cases
FROM diagnoses
GROUP BY severity
ORDER BY total_cases DESC;


SELECT                                      -- Top 10 Doctors by Revenue
    d.doctor_name,
    d.department,
    SUM(b.net_amount) AS total_revenue
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
JOIN billing b
    ON a.appointment_id = b.appointment_id
GROUP BY d.doctor_id, d.doctor_name, d.department
ORDER BY total_revenue DESC
LIMIT 10;


SELECT                             -- Monthly Appointment Count
    MONTH(appointment_date) AS month_number,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY MONTH(appointment_date)
ORDER BY month_number;


SELECT                                -- Monthly Revenue
    MONTH(a.appointment_date) AS month_number,
    SUM(b.net_amount) AS total_revenue
FROM appointments a
JOIN billing b
    ON a.appointment_id = b.appointment_id
GROUP BY MONTH(a.appointment_date)
ORDER BY month_number;


SELECT                                 -- Appointment Cancellation Rate
    ROUND(
        SUM(CASE WHEN appointment_status = 'Cancelled' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM appointments;


SELECT                                  -- Completed Appointment Revenue
    SUM(b.net_amount) AS completed_appointment_revenue
FROM appointments a
JOIN billing b
    ON a.appointment_id = b.appointment_id
WHERE a.appointment_status = 'Completed';


SELECT                                  -- Patients Above Average Age
    patient_id,
    patient_name,
    age
FROM patients
WHERE age > (
    SELECT AVG(age)
    FROM patients
)
ORDER BY age DESC;


WITH department_appointments AS (                -- CTE - Department-wise Appointment Analysis
    SELECT
        d.department,
        COUNT(a.appointment_id) AS total_appointments
    FROM doctors d
    JOIN appointments a
        ON d.doctor_id = a.doctor_id
    GROUP BY d.department
)
SELECT *
FROM department_appointments
ORDER BY total_appointments DESC;


SELECT                          -- Rank Doctors by Revenue
    d.doctor_name,
    d.department,
    SUM(b.net_amount) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(b.net_amount) DESC
    ) AS revenue_rank
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
JOIN billing b
    ON a.appointment_id = b.appointment_id
GROUP BY d.doctor_id, d.doctor_name, d.department;


SELECT                             -- Top 5 Departments by Revenue
    d.department,
    SUM(b.net_amount) AS total_revenue
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
JOIN billing b
    ON a.appointment_id = b.appointment_id
GROUP BY d.department
ORDER BY total_revenue DESC
LIMIT 5;


SELECT                        -- Overall Healthcare KPI Summary
    COUNT(*) AS total_patients
FROM patients;

SELECT
    COUNT(*) AS total_doctors
FROM doctors;

SELECT
    COUNT(*) AS total_appointments
FROM appointments;

SELECT                               
    SUM(bill_amount) AS total_bill_amount,
    SUM(discount) AS total_discount,
    SUM(net_amount) AS total_net_revenue,
    AVG(bill_amount) AS average_bill_amount,
    AVG(net_amount) AS average_net_amount
FROM billing;


SELECT                                -- Appointment Status Analysis
    appointment_status,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY appointment_status
ORDER BY total_appointments DESC;


SELECT                                  -- Revenue by Treatment Type
    treatment_type,
    SUM(net_amount) AS total_revenue
FROM billing
GROUP BY treatment_type
ORDER BY total_revenue DESC;

SELECT                                 -- Most Common Diagnoses
    diagnosis,
    COUNT(*) AS total_cases
FROM diagnoses
GROUP BY diagnosis
ORDER BY total_cases DESC;

SELECT                                -- Top 10 Doctors by Revenue
    d.doctor_name,
    d.department,
    SUM(b.net_amount) AS total_revenue
FROM doctors d
JOIN appointments a
    ON d.doctor_id = a.doctor_id
JOIN billing b
    ON a.appointment_id = b.appointment_id
GROUP BY d.doctor_id, d.doctor_name, d.department
ORDER BY total_revenue DESC
LIMIT 10;





























