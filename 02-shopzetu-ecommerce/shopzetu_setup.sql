-- ============================================
-- SHOPZETU DATABASE SETUP
-- Analyst: Benson Kioko
-- Tool: SQL Server Management Studio
-- Date: 2024
-- Description: Creates and populates the
-- ShopZetu database with 4 tables covering
-- customers, orders, order items, and products
-- for an online fashion store in Kenya.
-- ============================================

CREATE DATABASE ShopZetu;
GO
USE ShopZetu;
GO

-- ??? TABLE CREATION ???????????????????????

CREATE TABLE Customers (
    customer_id       INT PRIMARY KEY,
    full_name         VARCHAR(80),
    gender            VARCHAR(10),
    city              VARCHAR(40),
    join_date         DATE,
    age               INT
);

CREATE TABLE Products (
    product_id        INT PRIMARY KEY,
    product_name      VARCHAR(80),
    category          VARCHAR(40),
    unit_price        DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id          INT PRIMARY KEY,
    customer_id       INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date        DATE,
    delivery_status   VARCHAR(20)
);

CREATE TABLE Order_Items (
    item_id           INT PRIMARY KEY,
    order_id          INT FOREIGN KEY REFERENCES Orders(order_id),
    product_id        INT FOREIGN KEY REFERENCES Products(product_id),
    quantity          INT,
    unit_price        DECIMAL(10,2)
);
GO

-- ??? CUSTOMERS ????????????????????????????

INSERT INTO Customers VALUES
(1,'Amina Wanjiru','Female','Nairobi','2023-01-05',28),
(2,'Brian Otieno','Male','Mombasa','2023-01-12',34),
(3,'Carol Muthoni','Female','Nairobi','2023-02-03',25),
(4,'David Kiprop','Male','Kisumu','2023-02-18',41),
(5,'Esther Auma','Female','Nairobi','2023-03-07',30),
(6,'Felix Mutua','Male','Nakuru','2023-03-22',27),
(7,'Grace Chebet','Female','Eldoret','2023-04-10',33),
(8,'Henry Odhiambo','Male','Nairobi','2023-04-25',38),
(9,'Irene Wambui','Female','Mombasa','2023-05-14',29),
(10,'James Kariuki','Male','Nairobi','2023-05-30',45),
(11,'Kevin Achieng','Male','Kisumu','2023-06-08',31),
(12,'Lydia Rotich','Female','Nakuru','2023-06-20',26),
(13,'Moses Njoroge','Male','Nairobi','2023-07-04',36),
(14,'Nancy Cherop','Female','Eldoret','2023-07-19',24),
(15,'Oscar Mwenda','Male','Mombasa','2023-08-02',42),
(16,'Purity Wanjiku','Female','Nairobi','2023-08-17',27),
(17,'Quincy Omondi','Male','Kisumu','2023-09-01',35),
(18,'Rose Kamau','Female','Nairobi','2023-09-15',31),
(19,'Samuel Bett','Male','Nakuru','2023-10-03',29),
(20,'Tabitha Akinyi','Female','Nairobi','2023-10-18',33);

-- ??? PRODUCTS ?????????????????????????????

INSERT INTO Products VALUES
(1,'Floral Maxi Dress','Dresses',2500),
(2,'Slim Fit Chinos','Trousers',1800),
(3,'Leather Handbag','Accessories',3500),
(4,'Running Sneakers','Footwear',4200),
(5,'Ankara Wrap Skirt','Skirts',1500),
(6,'Classic White Shirt','Tops',1200),
(7,'Denim Jacket','Jackets',3800),
(8,'Gold Hoop Earrings','Accessories',850),
(9,'Yoga Pants','Activewear',2200),
(10,'Printed Scarf','Accessories',650),
(11,'Bodycon Dress','Dresses',2800),
(12,'Cargo Shorts','Trousers',1600),
(13,'Block Heel Sandals','Footwear',3200),
(14,'Sports Bra','Activewear',1400),
(15,'Trench Coat','Jackets',5500),
(16,'Linen Palazzo Pants','Trousers',2100),
(17,'Beaded Bracelet','Accessories',450),
(18,'Graphic Tee','Tops',900),
(19,'Pleated Midi Skirt','Skirts',1900),
(20,'Canvas Backpack','Accessories',2800);

-- ??? ORDERS ???????????????????????????????

INSERT INTO Orders VALUES
(1,1,'2023-01-15','Delivered'),
(2,1,'2023-03-22','Delivered'),
(3,1,'2023-06-10','Delivered'),
(4,1,'2023-09-05','Delivered'),
(5,1,'2023-12-18','Delivered'),
(6,1,'2024-03-07','Delivered'),
(7,1,'2024-07-14','Delivered'),
(8,2,'2023-01-20','Delivered'),
(9,2,'2023-04-11','Delivered'),
(10,2,'2023-08-30','Delivered'),
(11,2,'2024-01-15','Delivered'),
(12,3,'2023-02-10','Delivered'),
(13,3,'2023-05-25','Delivered'),
(14,3,'2023-11-08','Delivered'),
(15,4,'2023-02-28','Delivered'),
(16,4,'2023-07-14','Delivered'),
(17,5,'2023-03-15','Delivered'),
(18,5,'2023-06-22','Delivered'),
(19,5,'2023-10-30','Delivered'),
(20,5,'2024-02-14','Delivered'),
(21,6,'2023-04-05','Delivered'),
(22,6,'2023-08-19','Delivered'),
(23,7,'2023-04-18','Delivered'),
(24,7,'2023-09-27','Delivered'),
(25,7,'2024-01-08','Delivered'),
(26,7,'2024-05-20','Delivered'),
(27,8,'2023-05-02','Delivered'),
(28,9,'2023-05-20','Delivered'),
(29,9,'2023-09-14','Delivered'),
(30,9,'2024-03-25','Delivered'),
(31,10,'2023-06-05','Delivered'),
(32,11,'2023-06-15','Delivered'),
(33,11,'2023-10-22','Delivered'),
(34,11,'2024-02-28','Delivered'),
(35,12,'2023-07-01','Delivered'),
(36,13,'2023-07-10','Delivered'),
(37,13,'2023-11-25','Delivered'),
(38,13,'2024-04-15','Delivered'),
(39,14,'2023-08-05','Delivered'),
(40,15,'2023-08-20','Delivered'),
(41,15,'2024-01-30','Delivered'),
(42,16,'2023-09-10','Delivered'),
(43,16,'2023-12-05','Delivered'),
(44,16,'2024-04-22','Delivered'),
(45,17,'2023-09-25','Delivered'),
(46,18,'2023-10-08','Delivered'),
(47,18,'2023-12-20','Delivered'),
(48,18,'2024-05-10','Delivered'),
(49,19,'2023-10-15','Delivered'),
(50,20,'2023-11-01','Delivered'),
(51,20,'2024-02-20','Delivered'),
(52,20,'2024-06-08','Delivered');

-- ??? ORDER ITEMS ??????????????????????????

INSERT INTO Order_Items VALUES
(1,1,1,1,2500),(2,1,6,2,1200),
(3,2,3,1,3500),(4,2,8,1,850),
(5,3,7,1,3800),(6,3,9,1,2200),
(7,4,4,1,4200),(8,4,10,2,650),
(9,5,15,1,5500),(10,5,11,1,2800),
(11,6,1,2,2500),(12,6,19,1,1900),
(13,7,4,1,4200),(14,7,3,1,3500),
(15,8,2,2,1800),(16,8,12,1,1600),
(17,9,13,1,3200),(18,9,6,1,1200),
(19,10,7,1,3800),(20,10,20,1,2800),
(21,11,4,1,4200),(22,11,15,1,5500),
(23,12,5,2,1500),(24,12,17,3,450),
(25,13,1,1,2500),(26,13,8,2,850),
(27,14,11,1,2800),(28,14,19,1,1900),
(29,15,2,1,1800),(30,15,18,2,900),
(31,16,9,1,2200),(32,16,14,2,1400),
(33,17,3,1,3500),(34,17,10,3,650),
(35,18,6,2,1200),(36,18,5,1,1500),
(37,19,13,1,3200),(38,19,8,1,850),
(39,20,15,1,5500),(40,20,7,1,3800),
(41,21,18,2,900),(42,21,17,3,450),
(43,22,4,1,4200),(44,22,9,1,2200),
(45,23,1,1,2500),(46,23,6,1,1200),
(47,24,11,1,2800),(48,24,19,2,1900),
(49,25,3,1,3500),(50,25,20,1,2800),
(51,26,15,1,5500),(52,26,4,1,4200),
(53,27,7,1,3800),(54,27,13,1,3200),
(55,28,5,2,1500),(56,28,17,2,450),
(57,29,9,1,2200),(58,29,14,1,1400),
(59,30,4,1,4200),(60,30,3,1,3500),
(61,31,2,2,1800),(62,31,12,1,1600),
(63,32,1,1,2500),(64,32,8,2,850),
(65,33,11,1,2800),(66,33,6,1,1200),
(67,34,15,1,5500),(68,34,19,1,1900),
(69,35,13,1,3200),(70,35,10,2,650),
(71,36,7,1,3800),(72,36,3,1,3500),
(73,37,4,1,4200),(74,37,9,1,2200),
(75,38,1,2,2500),(76,38,20,1,2800),
(77,39,5,1,1500),(78,39,18,2,900),
(79,40,2,1,1800),(80,40,16,1,2100),
(81,41,15,1,5500),(82,41,13,1,3200),
(83,42,6,2,1200),(84,42,8,1,850),
(85,43,11,1,2800),(86,43,19,1,1900),
(87,44,4,1,4200),(88,44,3,1,3500),
(89,45,7,1,3800),(90,45,14,1,1400),
(91,46,1,1,2500),(92,46,10,2,650),
(93,47,9,1,2200),(94,47,5,1,1500),
(95,48,15,1,5500),(96,48,20,1,2800),
(97,49,2,1,1800),(98,49,12,2,1600),
(99,50,13,1,3200),(100,50,8,2,850),
(101,51,4,1,4200),(102,51,6,1,1200),
(103,52,11,1,2800),(104,52,19,2,1900);
GO