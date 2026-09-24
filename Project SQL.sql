CREATE DATABASE hospital;

USE hospital;

-- 1. Rooms Table
CREATE TABLE rooms (
    room_id VARCHAR(10) PRIMARY KEY,
    room_type VARCHAR(30) NOT NULL,
    floor INT NOT NULL,
    equipment_type VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    last_maintenance_date DATE NOT NULL,
    is_available VARCHAR(3) NOT NULL
);
select * from rooms;

-- 2. Patients Table
CREATE TABLE patients (
    patient_id VARCHAR(20) PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    city VARCHAR(50) NOT NULL,
    patient_type VARCHAR(20) NOT NULL,
    preferred_time_slot VARCHAR(20) NOT NULL,
    registration_date DATE NOT NULL
);
select * from patients;

-- 3. Doctors Table
CREATE TABLE doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    speciality VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    rating DECIMAL(3,2) NOT NULL,
    employment_type VARCHAR(20),
    is_active VARCHAR(3) NOT NULL
);
select * from doctors;

-- 4. Appointments Table
CREATE TABLE appointments (
    appointment_id VARCHAR(20) PRIMARY KEY,
    patient_id VARCHAR(20) NOT NULL,
    appointment_date DATE NOT NULL,
    doctor_id VARCHAR(10) NOT NULL,
    service_type VARCHAR(30) NOT NULL,
    priority VARCHAR(10) NOT NULL,
    estimated_cost DECIMAL(10,2) NOT NULL,
    booking_channel VARCHAR(20) NOT NULL,

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
);

select * from appointments;

-- 5. Treatments Table
CREATE TABLE treatments (
    treatment_id VARCHAR(20) PRIMARY KEY,
    appointment_id VARCHAR(20) NOT NULL,
    doctor_id VARCHAR(10) NOT NULL,
    room_id VARCHAR(10) NOT NULL,
    actual_treatment_date DATE,
    status VARCHAR(20) NOT NULL,
    treatment_attempt INT NOT NULL,
    treatment_duration_min INT NOT NULL,
    waiting_time_min INT NOT NULL,
    treatment_cost DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id),

    FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id),

    FOREIGN KEY (room_id)
        REFERENCES rooms(room_id)
);
select * from treatments;

-- Check table structures
DESCRIBE rooms;
DESCRIBE patients;
DESCRIBE doctors;
DESCRIBE appointments;
DESCRIBE treatments;

select * from treatments;
select * from rooms;
select * from doctors;
select * from appointments;
select * from patients;

-- Sprint 3: Basic Analysis / Data Exploration

-- 1. What is the total number of patients?

select count(*) from patients;

-- 2. What is the total number of appointments?

select count(*) from appointments;

-- 3. What is the total number of treatment records?

select count(*) AS total_treatment_records
from treatments;

-- 4. What are the different medical service types?

select distinct service_type from appointments;

-- 5. How many doctors are currently active?

select count(*) is_active from doctors;

-- 6. What are the different room types?

select distinct room_type from rooms;

-- 7. What is the total estimated appointment value?

select sum(estimated_cost) as estimated_appointment_value 
from appointments;

-- 8. What is the average treatment duration?

select avg(treatment_duration_min) as average_treatment_duration
from treatments;

# 1.4 Analytical Thinking from the ER Diagram
-- 1. Management wants to identify patients who have booked multiple appointments. Which table and columns are needed?
-- table: Appointments 
-- columns: patient_id,appointment_id co

select patient_id,appointment_id from appointments;

-- 2. Operations wants to identify appointments that required more than one treatment attempt. Where is this information found?
-- table: treatments
-- columns : appointment_id,treatment_attempt
select appointment_id,treatment_attempt from treatments;

-- 3. Patient Services wants to compare General, Corporate, and Insurance patients based on appointment activity. Which tables must be connected?
-- table: patients,appointments
-- columns: patient_type,patient_id,appointment_id,appointment_date
-- 4. Operations wants to compare service types based on treatment duration and waiting time. Which tables are required?
-- 5. The team wants to identify which doctors handled treatments and examine their recorded ratings. What information is needed?
-- 6. Operations wants to understand whether different room/equipment types are used for different service types. Which tables and columns are required?
-- 7. Management wants to compare treatment performance across cities. What information must be connected?
-- 8. Operations wants to investigate whether higher-priority appointments have longer waiting times or different outcomes. What information is needed?
-- 9. Management wants to understand whether treatment outcomes differ across service types. What tables and fields should be combined?
-- 10. The Patient Services team wants to connect each patient to their appointments and treatment outcomes. What relationships are required?

# Sprint 3: Basic Analysis / Data Exploration
-- 1. What is the total number of patients?
select count(*) from patients;

-- 2. What is the total number of appointments?
select count(*) from appointments;

-- 3. What is the total number of treatment records?
select count(*) as treatment_records from treatments;

-- 4. What are the different medical service types?
select distinct(service_type) from appointments;

-- 5. How many doctors are currently active?
select is_active from doctors
where is_active = "Yes";

-- 6. What are the different room types?
select distinct(room_type) from rooms;

-- 7. What is the total estimated appointment value?
select sum(estimated_cost) as total_estimated_appointment_value from appointments;

-- 8. What is the average treatment duration?
select avg(treatment_duration_min) as average_treatment_duration from treatments;

# Sprint 4: Objective-Based Analysis
-- 4.1 Understand Patient and Appointment Demand
-- ●Compare appointment volume across cities.
SELECT city, COUNT(*) AS appointment_volume
FROM patients
GROUP BY city
ORDER BY appointment_volume DESC;

-- Which city has the highest appointment volume?
select city,count(*) as appointment_volume
from patients
group by city
order by appointment_volume desc
limit 1;


-- ●Compare appointments across service types and priorities.

select service_type,priority from appointments;

SELECT service_type,priority,COUNT(*) AS appointment_volume
FROM appointments
GROUP BY service_type, priority
ORDER BY appointment_volume DESC;


-- ●Examine appointment volume over time.
-- How does appointment volume change over time?
SELECT appointment_date AS appointment_month,
COUNT(*) AS appointment_volume
FROM appointments
GROUP BY appointment_month
ORDER BY appointment_month;

-- ●Compare estimated appointment value across patient types.
select * from appointments;
select * from patients;
DESCRIBE appointments;

SELECT 
    service_type,
    SUM(estimated_cost) AS total_estimated_value
FROM appointments
GROUP BY service_type
ORDER BY total_estimated_value DESC
LIMIT 1;

SELECT service_type,SUM(estimated_cost) AS total_estimated_value
FROM appointments
GROUP BY service_type
ORDER BY total_estimated_value DESC;


-- ●Examine booking channels and their contribution to demand.

SELECT booking_channel,COUNT(*) AS appointment_volume
FROM appointments
GROUP BY booking_channel
ORDER BY appointment_volume DESC;


-- 4.2 Understand Patient Appointment Behaviour
-- ●Compare patients by number of appointments.
-- Which patients have the highest number of appointments?

SELECT patient_id,COUNT(appointment_id) AS appointment_count
FROM appointments
GROUP BY patient_id
ORDER BY appointment_count DESC;

-- ●Identify patients with higher cumulative estimated appointment value.
-- Which patients have the highest cumulative estimated appointment value?

SELECT patient_id,SUM(estimated_cost) AS total_estimated_value
FROM appointments
GROUP BY patient_id
ORDER BY total_estimated_value DESC;

-- ●Compare patient activity across cities.

SELECT p.city,COUNT(a.appointment_id) AS appointment_volume
FROM patients p
JOIN appointments a 
ON p.patient_id = a.patient_id
GROUP BY p.city
ORDER BY appointment_volume DESC;

-- How does patient appointment activity vary across cities?

SELECT p.city,COUNT(a.appointment_id) AS appointment_count
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.city
ORDER BY appointment_count DESC;

SELECT YEAR(appointment_date) AS year,
MONTH(appointment_date) AS month,
COUNT(appointment_id) AS appointment_volume
FROM appointments
GROUP BY YEAR(appointment_date), MONTH(appointment_date)
ORDER BY year, month;

SELECT p.patient_type,SUM(estimated_cost) AS total_estimated_value,
AVG(estimated_cost) AS average_estimated_value
FROM patients p
JOIN appointments a 
ON p.patient_id = a.patient_id
GROUP BY p.patient_type
ORDER BY total_estimated_value DESC;

-- ●Compare General, Corporate, and Insurance patients.
-- How does appointment activity vary among General, Corporate, and Insurance patients?

SELECT p.patient_type,COUNT(a.appointment_id) AS appointment_count
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_type
ORDER BY appointment_count DESC;

-- ●Examine patient booking patterns over time.
-- How do patient appointment booking patterns change over time?

SELECT appointment_date AS appointment_month,COUNT(DISTINCT patient_id) AS active_patients,
COUNT(appointment_id) AS appointment_count
FROM appointments
GROUP BY appointment_month
ORDER BY appointment_month;

-- 4.3 Evaluate Treatment Performance
-- ●Compare treatment outcomes across cities.
SELECT 
    p.city,
    t.status,
    COUNT(t.treatment_id) AS treatment_count
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
JOIN treatments t
    ON a.appointment_id = t.appointment_id
GROUP BY p.city, t.status
ORDER BY p.city, treatment_count DESC;

SELECT 
    p.patient_id,
    p.patient_name,
    COUNT(a.appointment_id) AS appointment_count
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
ORDER BY appointment_count DESC;

SELECT 
    p.patient_id,
    p.patient_name,
    SUM(estimated_cost) AS total_estimated_value
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name
ORDER BY total_estimated_value DESC;


SELECT 
    p.city,
    COUNT(DISTINCT p.patient_id) AS total_patients,
    COUNT(a.appointment_id) AS total_appointments
FROM patients p
LEFT JOIN appointments a
    ON p.patient_id = a.patient_id
GROUP BY p.city
ORDER BY total_appointments DESC;
-- ●Examine treatment duration and waiting time.

SELECT AVG(treatment_duration_min) AS average_treatment_duration,
AVG(waiting_time_min) AS average_waiting_time
FROM treatments;

-- ●Compare Completed, Cancelled, No-Show, Rescheduled, and In Progress outcomes.

SELECT status,COUNT(treatment_id) AS treatment_count
FROM treatments
GROUP BY status
ORDER BY treatment_count DESC;
-- ●Identify areas with higher treatment activity or poorer outcomes.
SELECT 
    p.city,
    COUNT(t.treatment_id) AS total_treatments,
    SUM(CASE 
        WHEN t.status IN ('Cancelled', 'No-Show', 'Rescheduled') 
        THEN 1 ELSE 0 
    END) AS unsuccessful_treatments
FROM patients p
JOIN appointments a
    ON p.patient_id = a.patient_id
JOIN treatments t
    ON a.appointment_id = t.appointment_id
GROUP BY p.city
ORDER BY unsuccessful_treatments DESC;

-- ●Compare treatment performance over time.

SELECT treatment_id,appointment_id,doctor_id,
treatment_attempt,treatment_duration_min,treatment_cost
FROM treatments
WHERE treatment_attempt > 1
ORDER BY treatment_attempt DESC;

-- 4.4 Understand Doctor and Room Performance
-- ●Compare the number of treatments handled by doctors.

SELECT doctor_id,COUNT(treatment_id) AS treatment_count
FROM treatments
GROUP BY doctor_id
ORDER BY treatment_count DESC;

-- ●Compare doctor performance across treatment outcomes.

SELECT doctor_id,status,
COUNT(treatment_id) AS treatment_count
FROM treatments
GROUP BY doctor_id, status
ORDER BY doctor_id, treatment_count DESC;

-- ●Examine treatment duration across doctors.

SELECT doctor_id,AVG(treatment_duration_min) AS average_treatment_duration
FROM treatments
GROUP BY doctor_id
ORDER BY average_treatment_duration DESC;

-- ●Compare room usage across room types and equipment types.

SELECT r.room_type,r.equipment_type,
COUNT(t.treatment_id) AS treatment_count
FROM rooms r
JOIN treatments t
    ON r.room_id = t.room_id
GROUP BY r.room_type, r.equipment_type
ORDER BY treatment_count DESC;

-- ●Evaluate treatment performance across rooms.

SELECT room_id,COUNT(treatment_id) AS treatment_count,
AVG(treatment_duration_min) AS average_treatment_duration,
AVG(waiting_time_min) AS average_waiting_time
FROM treatments
GROUP BY room_id
ORDER BY treatment_count DESC;

-- 4.5 Identify Treatment and Appointment Problems
-- ●Identify appointments requiring multiple treatment attempts.

SELECT appointment_id,COUNT(treatment_id) AS treatment_count,
MAX(treatment_attempt) AS maximum_attempts
FROM treatments
GROUP BY appointment_id
HAVING MAX(treatment_attempt) > 1
ORDER BY maximum_attempts DESC;

-- ●Find common problem statuses and patterns.

SELECT status,
COUNT(treatment_id) AS treatment_count
FROM treatments
GROUP BY status
ORDER BY treatment_count DESC;

SELECT doctor_id,
AVG(waiting_time_min) AS average_waiting_time
FROM treatments
GROUP BY doctor_id
ORDER BY average_waiting_time DESC;

SELECT treatment_id,appointment_id,doctor_id,treatment_duration_min
FROM treatments
WHERE treatment_duration_min > (
    SELECT AVG(treatment_duration_min)
    FROM treatments
)
ORDER BY treatment_duration_min DESC;

-- ●Compare waiting time for appointments with multiple attempts.
-- ●Identify cities or service types with more cancellations, no-shows, or rescheduling.
-- ●Investigate whether priority level is associated with waiting time or treatment outcomes.

SELECT patient_type,
COUNT(DISTINCT patient_id) AS total_patients
FROM patients
WHERE patient_type IN ('General', 'Corporate', 'Insurance')
GROUP BY patient_type
ORDER BY total_patients DESC;

SELECT MONTH(appointment_date) AS month,
COUNT(appointment_id) AS appointment_count
FROM appointments
GROUP BY MONTH(appointment_date)
ORDER BY month;

SELECT 
    p.city,
    t.outcome,
    COUNT(t.treatment_id) AS treatment_count
FROM patients p
JOIN treatments t
    ON p.patient_id = t.patient_id
GROUP BY p.city, t.outcome
ORDER BY p.city, treatment_count DESC;

select * from treatments;

SELECT AVG(treatment_duration_min) AS average_treatment_duration,
AVG(waiting_time_min) AS average_waiting_time
FROM treatments;

SELECT status,COUNT(treatment_id) AS treatment_count
FROM treatments
WHERE status IN ('Completed','Cancelled','No-Show','Rescheduled','In Progress')
GROUP BY status
ORDER BY treatment_count DESC;

SELECT p.city,
COUNT(treatment_id) AS total_treatments
FROM patients p
JOIN treatments t
ON p.patient_id = patient_id
GROUP BY p.city
ORDER BY total_treatments DESC;

SELECT YEAR(actual_treatment_date) AS year,
COUNT(treatment_id) AS total_treatments,
AVG(treatment_duration_min) AS average_duration,
AVG(waiting_time_min) AS average_waiting_time
FROM treatments
GROUP BY YEAR(actual_treatment_date)
ORDER BY year;

select * from treatments;

SELECT p.city,t.status,
COUNT(treatment_id) AS treatment_count
FROM patients p
JOIN treatments t
ON p.patient_id = patient_id
GROUP BY p.city, t.status
ORDER BY p.city, treatment_count DESC;

SELECT d.doctor_id,d.doctor_name,
COUNT(t.treatment_id) AS total_treatments
FROM doctors d
JOIN treatments t
ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_id, d.doctor_name
ORDER BY total_treatments DESC;

SELECT d.doctor_name,t.status,
COUNT(treatment_id) AS treatment_count
FROM doctors d
JOIN treatments t
ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_name, t.status
ORDER BY d.doctor_name, treatment_count DESC;

SELECT d.doctor_name,COUNT(t.treatment_id) AS total_treatments,
ROUND(AVG(treatment_duration_min), 2) AS average_treatment_duration
FROM doctors d
JOIN treatments t
ON d.doctor_id = t.doctor_id
GROUP BY d.doctor_name
ORDER BY average_treatment_duration DESC;

SELECT r.room_type,r.equipment_type,
COUNT(t.treatment_id) AS treatment_count
FROM rooms r
JOIN treatments t
ON r.room_id = t.room_id
GROUP BY r.room_type, r.equipment_type
ORDER BY treatment_count DESC;

SELECT r.room_id,r.room_type,
COUNT(treatment_id) AS total_treatments,
AVG(treatment_duration_min) AS avg_duration,
AVG(waiting_time_min) AS avg_waiting
FROM rooms r
JOIN treatments t ON r.room_id = t.room_id
GROUP BY r.room_id, r.room_type
ORDER BY total_treatments DESC;

SELECT a.appointment_id,a.patient_id,
COUNT(t.treatment_id) AS treatment_attempts
FROM appointments a
JOIN treatments t
ON a.appointment_id = t.appointment_id
GROUP BY a.appointment_id, a.patient_id
HAVING COUNT(t.treatment_id) > 1
ORDER BY treatment_attempts DESC;

SELECT status,
COUNT(appointment_id) AS appointment_count
FROM appointments
GROUP BY status
ORDER BY appointment_count DESC;

SELECT a.appointment_id,COUNT(t.treatment_id) AS treatment_attempts,
ROUND(AVG(waiting_time_min), 2) AS average_waiting_time
FROM appointments a
JOIN treatments t
ON a.appointment_id = t.appointment_id
GROUP BY a.appointment_id
HAVING COUNT(t.treatment_id) > 1
ORDER BY average_waiting_time DESC;

SELECT service_type,status,
COUNT(appointment_id) AS appointment_count
FROM appointments
WHERE status IN ('Cancelled', 'No-Show', 'Rescheduled')
GROUP BY service_type, status
ORDER BY appointment_count DESC;