# Hospital Patient & Appointment Analysis Dataset

Files:
- patients.csv: 1,200 patient records
- doctors.csv: 50 doctor records
- appointments.csv: 5,000 appointment records
- billing.csv: 5,000 billing records
- diagnoses.csv: 5,000 diagnosis records

Suggested tools:
- MySQL Workbench for database creation, joins, aggregations, CTEs, subqueries and window functions.
- Python/Anaconda/Jupyter for Pandas data cleaning, EDA and visualization.
- Power BI can be added later for an optional dashboard.

Primary relationships:
patients.patient_id -> appointments.patient_id
doctors.doctor_id -> appointments.doctor_id
appointments.appointment_id -> billing.appointment_id
appointments.appointment_id -> diagnoses.appointment_id
