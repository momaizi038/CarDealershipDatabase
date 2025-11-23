DROP DATABASE IF EXISTS car_dealership;
CREATE DATABASE car_dealership;
USE car_dealership;

CREATE TABLE dealerships (
    dealership_id INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    address     VARCHAR(50),
    phone       VARCHAR(12)
);

CREATE TABLE vehicles (
    VIN     CHAR(17) PRIMARY KEY,
    make    VARCHAR(30) NOT NULL,
    model   VARCHAR(30) NOT NULL,
    year    INT         NOT NULL,
    color   VARCHAR(20),
    price   DECIMAL(10,2),
    sold    TINYINT(1) NOT NULL DEFAULT 0
);

CREATE TABLE inventory (
    dealership_id INT      NOT NULL,
    VIN           CHAR(17) NOT NULL,
    PRIMARY KEY (dealership_id, VIN),
    FOREIGN KEY (dealership_id) REFERENCES dealerships(dealership_id),
    FOREIGN KEY (VIN)           REFERENCES vehicles(VIN)
);

CREATE TABLE sales_contracts (
    sale_id        INT AUTO_INCREMENT PRIMARY KEY,
    VIN            CHAR(17) NOT NULL,
    dealership_id  INT      NOT NULL,
    customer_name  VARCHAR(100) NOT NULL,
    sale_date      DATE     NOT NULL,
    sale_price     DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (VIN)           REFERENCES vehicles(VIN),
    FOREIGN KEY (dealership_id) REFERENCES dealerships(dealership_id)
);

CREATE TABLE lease_contracts (
    lease_id        INT AUTO_INCREMENT PRIMARY KEY,
    VIN             CHAR(17) NOT NULL,
    dealership_id   INT      NOT NULL,
    customer_name   VARCHAR(100) NOT NULL,
    lease_start     DATE NOT NULL,
    lease_end       DATE NOT NULL,
    monthly_payment DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (VIN)           REFERENCES vehicles(VIN),
    FOREIGN KEY (dealership_id) REFERENCES dealerships(dealership_id)
);

INSERT INTO dealerships (name, address, phone) VALUES
('Main Street Motors', '123 Main St', '555-111-2222'),
('Highway Auto Plaza', '456 Highway Rd', '555-222-3333'),
('City Center Cars',   '789 Market Ave', '555-444-5555');

INSERT INTO vehicles (VIN, make, model, year, color, price, sold) VALUES
('1HGCM82633A000001', 'Honda',  'Civic',   2019, 'Blue',   18500.00, 0),
('1HGCM82633A000002', 'Honda',  'Accord',  2020, 'Black',  24000.00, 1),
('1FAFP404X1F000003', 'Ford',   'Mustang', 2018, 'Red',    27000.00, 0),
('2G1WF52E859000004', 'Chevy',  'Impala',  2017, 'Silver', 15000.00, 0),
('3N1AB7AP4GY000005', 'Nissan', 'Sentra',  2019, 'Gray',   17000.00, 1),
('JN1AZ34E54M000006', 'Nissan', '350Z',    2006, 'Orange', 16000.00, 0);

INSERT INTO inventory (dealership_id, VIN) VALUES
(1, '1HGCM82633A000001'),
(1, '1FAFP404X1F000003'),
(2, '1HGCM82633A000002'),
(2, '2G1WF52E859000004'),
(3, '3N1AB7AP4GY000005'),
(3, 'JN1AZ34E54M000006');

INSERT INTO sales_contracts
(VIN, dealership_id, customer_name, sale_date, sale_price)
VALUES
('1HGCM82633A000002', 2, 'John Smith',  '2024-03-15', 23500.00),
('3N1AB7AP4GY000005', 3, 'Maria Lopez', '2024-04-10', 16800.00);

INSERT INTO lease_contracts
(VIN, dealership_id, customer_name, lease_start, lease_end, monthly_payment)
VALUES
('1FAFP404X1F000003', 1, 'Kevin Jones', '2024-05-01', '2027-05-01', 399.99);

-- 1) Get all dealerships
SELECT * FROM dealerships;

-- 2) Find all vehicles for a specific dealership
SELECT v.*
FROM vehicles v
JOIN inventory i ON v.VIN = i.VIN
WHERE i.dealership_id = 1;

-- 3) Find a car by VIN
SELECT *
FROM vehicles
WHERE VIN = '1FAFP404X1F000003';

-- 4) Find the dealership where a certain car is located, by VIN
SELECT d.*
FROM dealerships d
JOIN inventory i ON d.dealership_id = i.dealership_id
WHERE i.VIN = '1FAFP404X1F000003';

-- 5) Find all dealerships that have a certain car type (example: Red Ford Mustang)
SELECT DISTINCT d.*
FROM dealerships d
JOIN inventory i ON d.dealership_id = i.dealership_id
JOIN vehicles v ON v.VIN = i.VIN
WHERE v.make = 'Ford'
  AND v.model = 'Mustang'
  AND v.color = 'Red';

-- 6) Get all sales info for a specific dealer in a date range
SELECT s.*, v.make, v.model, v.year
FROM sales_contracts s
JOIN vehicles v ON s.VIN = v.VIN
WHERE s.dealership_id = 2
  AND s.sale_date BETWEEN '2024-03-01' AND '2024-06-30';
