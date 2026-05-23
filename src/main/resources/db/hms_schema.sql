-- Hospital Management System (HMS) Database Design
-- Compatible with MySQL 8+

CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(80) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(40) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS department (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120) NOT NULL UNIQUE,
    description VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS patient (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(140) NOT NULL,
    gender VARCHAR(15) NOT NULL,
    dob DATE,
    mobile VARCHAR(20),
    address VARCHAR(500),
    blood_group VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS doctor (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    doctor_code VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(140) NOT NULL,
    specialization VARCHAR(120) NOT NULL,
    mobile VARCHAR(20),
    email VARCHAR(120),
    consultation_fee DECIMAL(12,2) DEFAULT 0.00,
    department_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_doctor_department
        FOREIGN KEY (department_id) REFERENCES department(id)
);

CREATE TABLE IF NOT EXISTS doctor_schedule (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    doctor_id BIGINT NOT NULL,
    day_of_week VARCHAR(12) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_schedule_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);

CREATE TABLE IF NOT EXISTS appointment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'BOOKED',
    token_no INT,
    notes VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id) REFERENCES patient(id),
    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);

CREATE TABLE IF NOT EXISTS room (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(30) NOT NULL UNIQUE,
    room_type VARCHAR(40) NOT NULL,
    daily_charge DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
);

CREATE TABLE IF NOT EXISTS bed (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    room_id BIGINT NOT NULL,
    bed_number VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    CONSTRAINT fk_bed_room
        FOREIGN KEY (room_id) REFERENCES room(id),
    CONSTRAINT uk_bed_room_bedno UNIQUE (room_id, bed_number)
);

CREATE TABLE IF NOT EXISTS admission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    bed_id BIGINT NOT NULL,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'ADMITTED',
    CONSTRAINT fk_admission_patient
        FOREIGN KEY (patient_id) REFERENCES patient(id),
    CONSTRAINT fk_admission_bed
        FOREIGN KEY (bed_id) REFERENCES bed(id)
);

CREATE TABLE IF NOT EXISTS consultation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    appointment_id BIGINT NOT NULL,
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    consultation_notes TEXT,
    diagnosis TEXT,
    consultation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_consultation_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment(id),
    CONSTRAINT fk_consultation_patient
        FOREIGN KEY (patient_id) REFERENCES patient(id),
    CONSTRAINT fk_consultation_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctor(id)
);

CREATE TABLE IF NOT EXISTS prescription (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    consultation_id BIGINT NOT NULL,
    prescription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    instructions TEXT,
    CONSTRAINT fk_prescription_consultation
        FOREIGN KEY (consultation_id) REFERENCES consultation(id)
);

CREATE TABLE IF NOT EXISTS medicine (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    medicine_name VARCHAR(160) NOT NULL UNIQUE,
    stock_qty DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    purchase_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    selling_price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    expiry_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS prescription_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    prescription_id BIGINT NOT NULL,
    medicine_id BIGINT NOT NULL,
    qty DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    dosage VARCHAR(120),
    frequency VARCHAR(80),
    duration_days INT,
    CONSTRAINT fk_prescription_item_rx
        FOREIGN KEY (prescription_id) REFERENCES prescription(id),
    CONSTRAINT fk_prescription_item_medicine
        FOREIGN KEY (medicine_id) REFERENCES medicine(id)
);

CREATE TABLE IF NOT EXISTS lab_test (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    test_name VARCHAR(120) NOT NULL UNIQUE,
    test_code VARCHAR(40) NOT NULL UNIQUE,
    test_charge DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS lab_report (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT,
    lab_test_id BIGINT NOT NULL,
    result_value TEXT,
    result_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    report_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT fk_lab_report_patient
        FOREIGN KEY (patient_id) REFERENCES patient(id),
    CONSTRAINT fk_lab_report_doctor
        FOREIGN KEY (doctor_id) REFERENCES doctor(id),
    CONSTRAINT fk_lab_report_test
        FOREIGN KEY (lab_test_id) REFERENCES lab_test(id)
);

CREATE TABLE IF NOT EXISTS bill (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    bill_no VARCHAR(50) NOT NULL UNIQUE,
    bill_date DATE NOT NULL,
    total_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    discount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    net_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'UNPAID',
    CONSTRAINT fk_bill_patient
        FOREIGN KEY (patient_id) REFERENCES patient(id)
);

CREATE TABLE IF NOT EXISTS bill_charge (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    bill_id BIGINT NOT NULL,
    charge_type VARCHAR(40) NOT NULL,
    reference_id BIGINT,
    amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
    remarks VARCHAR(250),
    CONSTRAINT fk_bill_charge_bill
        FOREIGN KEY (bill_id) REFERENCES bill(id)
);

CREATE INDEX idx_appointment_date ON appointment (appointment_date);
CREATE INDEX idx_admission_status ON admission (status);
CREATE INDEX idx_bed_status ON bed (status);
CREATE INDEX idx_bill_date ON bill (bill_date);
