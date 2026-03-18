-- ============================================
-- FINBANK DATABASE SETUP
-- Analyst: Benson Kioko
-- Tool: SQL Server Management Studio
-- Date: 2024
-- Description: Creates and populates the
-- FinBank database with 5 tables covering
-- loans, customers, repayments, agents,
-- and branches across Kenya.
-- ============================================

CREATE DATABASE FinBank;
GO
USE FinBank;
GO

-- ??? TABLE CREATION ???????????????????????

CREATE TABLE Branches (
    branch_id     INT PRIMARY KEY,
    branch_name   VARCHAR(50),
    region        VARCHAR(30)
);

CREATE TABLE Agents (
    agent_id    INT PRIMARY KEY,
    branch_id   INT FOREIGN KEY REFERENCES Branches(branch_id),
    agent_name  VARCHAR(50),
    team        VARCHAR(10)
);

CREATE TABLE Customers (
    customer_id         INT PRIMARY KEY,
    full_name           VARCHAR(80),
    gender              VARCHAR(10),
    age                 INT,
    city                VARCHAR(40),
    credit_score        INT,
    join_date           DATE,
    employment_status   VARCHAR(20)
);

CREATE TABLE Loans (
    loan_id             INT PRIMARY KEY,
    customer_id         INT FOREIGN KEY REFERENCES Customers(customer_id),
    agent_id            INT FOREIGN KEY REFERENCES Agents(agent_id),
    loan_type           VARCHAR(30),
    loan_amount         DECIMAL(12,2),
    interest_rate       DECIMAL(5,2),
    tenure_months       INT,
    application_date    DATE,
    approval_date       DATE,
    disbursement_date   DATE,
    status              VARCHAR(20)
);

CREATE TABLE Repayments (
    repayment_id    INT PRIMARY KEY,
    loan_id         INT FOREIGN KEY REFERENCES Loans(loan_id),
    due_date        DATE,
    payment_date    DATE,
    amount_due      DECIMAL(10,2),
    amount_paid     DECIMAL(10,2),
    payment_status  VARCHAR(20)
);
GO

-- ??? BRANCHES ?????????????????????????????

INSERT INTO Branches VALUES
(1,'Nairobi CBD','Nairobi'),
(2,'Westlands','Nairobi'),
(3,'Mombasa','Coast'),
(4,'Kisumu','Western'),
(5,'Nakuru','Rift Valley');

-- ??? AGENTS ???????????????????????????????

INSERT INTO Agents VALUES
(1,1,'Alice Mwangi','Team A'),
(2,1,'Brian Otieno','Team B'),
(3,2,'Carol Njeri','Team A'),
(4,2,'David Kimani','Team B'),
(5,3,'Esther Wanjiku','Team A'),
(6,3,'Felix Ochieng','Team B'),
(7,4,'Grace Akinyi','Team A'),
(8,4,'Henry Maina','Team B'),
(9,5,'Irene Chebet','Team A'),
(10,5,'James Rotich','Team B');

-- ??? CUSTOMERS ????????????????????????????

INSERT INTO Customers VALUES
(1,'Samuel Kariuki','Male',34,'Nairobi',720,'2024-01-10','Employed'),
(2,'Fatuma Hassan','Female',28,'Mombasa',580,'2024-01-15','Self-employed'),
(3,'John Omondi','Male',45,'Kisumu',650,'2024-01-20','Employed'),
(4,'Mary Wanjiru','Female',31,'Nairobi',710,'2024-02-01','Employed'),
(5,'Peter Mutua','Male',52,'Nakuru',490,'2024-02-10','Unemployed'),
(6,'Grace Adhiambo','Female',26,'Kisumu',630,'2024-02-14','Self-employed'),
(7,'Daniel Njoroge','Male',38,'Nairobi',760,'2024-02-20','Employed'),
(8,'Alice Chebet','Female',29,'Nakuru',540,'2024-03-05','Self-employed'),
(9,'Kevin Otieno','Male',41,'Mombasa',680,'2024-03-12','Employed'),
(10,'Winnie Achieng','Female',33,'Nairobi',700,'2024-03-18','Employed'),
(11,'Moses Kiptoo','Male',47,'Nakuru',460,'2024-03-25','Unemployed'),
(12,'Susan Wairimu','Female',36,'Nairobi',730,'2024-04-02','Employed'),
(13,'Charles Odhiambo','Male',30,'Kisumu',610,'2024-04-10','Self-employed'),
(14,'Beatrice Njeri','Female',42,'Nairobi',690,'2024-04-15','Employed'),
(15,'Anthony Mwenda','Male',27,'Mombasa',550,'2024-04-22','Self-employed'),
(16,'Lydia Moraa','Female',35,'Nakuru',670,'2024-05-03','Employed'),
(17,'Eric Odhiambo','Male',48,'Kisumu',500,'2024-05-10','Unemployed'),
(18,'Jane Wambui','Female',32,'Nairobi',740,'2024-05-18','Employed'),
(19,'Robert Kiplagat','Male',39,'Nakuru',620,'2024-05-25','Self-employed'),
(20,'Diana Auma','Female',25,'Mombasa',560,'2024-06-01','Self-employed');

-- ??? LOANS ????????????????????????????????

INSERT INTO Loans VALUES
(1,1,1,'Personal Loan',50000,14.5,24,'2024-01-12','2024-01-14','2024-01-15','Active'),
(2,2,5,'Business Loan',120000,16.0,36,'2024-01-18','2024-01-22','2024-01-23','Active'),
(3,3,7,'Personal Loan',30000,14.5,12,'2024-01-22','2024-01-24','2024-01-25','Closed'),
(4,4,1,'Mortgage',850000,12.5,180,'2024-02-03','2024-02-10','2024-02-12','Active'),
(5,5,10,'Personal Loan',25000,18.0,12,'2024-02-12','2024-02-16','2024-02-18','Defaulted'),
(6,6,7,'Business Loan',75000,15.5,24,'2024-02-16','2024-02-19','2024-02-20','Active'),
(7,7,2,'Mortgage',1200000,12.0,240,'2024-02-22','2024-03-01','2024-03-03','Active'),
(8,8,9,'Personal Loan',20000,18.0,12,'2024-03-07','2024-03-10','2024-03-11','Defaulted'),
(9,9,5,'Business Loan',200000,15.0,48,'2024-03-14','2024-03-18','2024-03-20','Active'),
(10,10,1,'Personal Loan',45000,14.5,24,'2024-03-20','2024-03-22','2024-03-23','Active'),
(11,11,10,'Personal Loan',15000,19.0,6,'2024-03-27','2024-04-01','2024-04-02','Defaulted'),
(12,12,3,'Mortgage',950000,12.5,180,'2024-04-04','2024-04-12','2024-04-14','Active'),
(13,13,7,'Business Loan',60000,15.5,24,'2024-04-12','2024-04-15','2024-04-16','Active'),
(14,14,2,'Personal Loan',55000,14.0,24,'2024-04-17','2024-04-19','2024-04-20','Active'),
(15,15,6,'Business Loan',90000,16.0,36,'2024-04-24','2024-04-28','2024-04-29','Active'),
(16,16,9,'Personal Loan',35000,14.5,18,'2024-05-05','2024-05-08','2024-05-09','Active'),
(17,17,10,'Personal Loan',20000,19.5,12,'2024-05-12','2024-05-15','2024-05-16','Defaulted'),
(18,18,3,'Mortgage',750000,12.5,120,'2024-05-20','2024-05-28','2024-05-30','Active'),
(19,19,8,'Business Loan',110000,15.5,36,'2024-05-27','2024-05-31','2024-06-01','Active'),
(20,20,5,'Personal Loan',28000,17.0,18,'2024-06-03','2024-06-06','2024-06-07','Active'),
(21,1,1,'Business Loan',180000,15.0,36,'2024-06-15','2024-06-18','2024-06-19','Active'),
(22,3,7,'Personal Loan',40000,14.5,24,'2024-07-01','2024-07-03','2024-07-04','Active'),
(23,7,2,'Business Loan',250000,14.5,48,'2024-07-10','2024-07-15','2024-07-16','Active'),
(24,10,1,'Personal Loan',60000,14.0,24,'2024-08-05','2024-08-07','2024-08-08','Active'),
(25,12,3,'Business Loan',140000,15.5,36,'2024-09-01','2024-09-05','2024-09-06','Active');

-- ??? REPAYMENTS ???????????????????????????

INSERT INTO Repayments VALUES
(1,1,'2024-02-15','2024-02-15',2300,2300,'On Time'),
(2,1,'2024-03-15','2024-03-16',2300,2300,'Late'),
(3,1,'2024-04-15','2024-04-15',2300,2300,'On Time'),
(4,2,'2024-02-23','2024-02-23',4200,4200,'On Time'),
(5,2,'2024-03-23','2024-03-25',4200,4200,'Late'),
(6,2,'2024-04-23','2024-04-23',4200,4200,'On Time'),
(7,3,'2024-02-25','2024-02-25',2800,2800,'On Time'),
(8,3,'2024-03-25','2024-03-25',2800,2800,'On Time'),
(9,3,'2024-04-25','2024-04-25',2800,2800,'On Time'),
(10,4,'2024-03-12','2024-03-12',8500,8500,'On Time'),
(11,4,'2024-04-12','2024-04-14',8500,8500,'Late'),
(12,5,'2024-03-18',NULL,2200,0,'Missed'),
(13,5,'2024-04-18',NULL,2200,0,'Missed'),
(14,6,'2024-03-20','2024-03-20',3600,3600,'On Time'),
(15,6,'2024-04-20','2024-04-20',3600,3600,'On Time'),
(16,7,'2024-04-03','2024-04-03',9800,9800,'On Time'),
(17,7,'2024-05-03','2024-05-05',9800,9800,'Late'),
(18,8,'2024-04-11',NULL,1900,0,'Missed'),
(19,8,'2024-05-11',NULL,1900,0,'Missed'),
(20,9,'2024-04-20','2024-04-20',5200,5200,'On Time'),
(21,9,'2024-05-20','2024-05-20',5200,5200,'On Time'),
(22,10,'2024-04-23','2024-04-23',2100,2100,'On Time'),
(23,10,'2024-05-23','2024-05-24',2100,2100,'Late'),
(24,11,'2024-05-02',NULL,2800,0,'Missed'),
(25,12,'2024-05-14','2024-05-14',6200,6200,'On Time'),
(26,12,'2024-06-14','2024-06-16',6200,6200,'Late'),
(27,13,'2024-05-16','2024-05-16',3100,3100,'On Time'),
(28,14,'2024-05-20','2024-05-20',2700,2700,'On Time'),
(29,14,'2024-06-20','2024-06-20',2700,2700,'On Time'),
(30,15,'2024-05-29','2024-05-29',3000,3000,'On Time'),
(31,16,'2024-06-09','2024-06-09',2200,2200,'On Time'),
(32,17,'2024-06-16',NULL,1900,0,'Missed'),
(33,18,'2024-06-30','2024-06-30',8100,8100,'On Time'),
(34,19,'2024-07-01','2024-07-01',3700,3700,'On Time'),
(35,20,'2024-07-07','2024-07-08',1800,1800,'Late'),
(36,21,'2024-07-19','2024-07-19',5900,5900,'On Time'),
(37,22,'2024-08-04','2024-08-04',2000,2000,'On Time'),
(38,23,'2024-08-16','2024-08-16',6400,6400,'On Time'),
(39,24,'2024-09-08','2024-09-08',3100,3100,'On Time'),
(40,25,'2024-10-06','2024-10-06',4600,4600,'On Time');
GO