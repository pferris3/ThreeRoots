#Paul Ferris
#Three Roots DB 

DROP DATABASE IF EXISTS `ThreeRoots`;
CREATE DATABASE IF NOT EXISTS `ThreeRoots`;
USE `ThreeRoots`;

DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
	`ID` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL,
    `Address` VARCHAR(50) DEFAULT NULL,
    `City` VARCHAR(50) DEFAULT NULL,
    `State` CHAR(2) DEFAULT NULL,
    `ZIP` CHAR(5) DEFAULT NULL,
    `Phone` CHAR(12) DEFAULT NULL,
    `Email` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`ID`)
);

INSERT INTO `customer` VALUES 
(1, 'John Doe', '123 Main St', 'Townville', 'VA', '12345', '555-555-5555', 'johndoe@gmail.com'),
(2,'Mark Smith', '456 River Rd', 'Cityburg', 'VA', '67890', '222-222-2222', 'marksmith@gmail.com');

#ADD CUST KEY OR MAKE JOIN TABLE
DROP TABLE IF EXISTS `plant`;
CREATE TABLE `plant` (
	`PlantID` INT NOT NULL AUTO_INCREMENT,
	`Species` VARCHAR(50) NOT NULL
);

INSERT INTO `plant` VALUES
(1, 'Elephant Ear'),
(2, 'Babys Breath'),
(3, 'Hibiscus'),
(4, 'Pothos');


DROP TABLE IF EXISTS `custPlant`;
CREATE TABLE `custPlant` (
	`PlantID` INT NOT NULL,
    `CustID` INT NOT NULL,
    `Quan` INT NOT NULL,
    `NeedBugTreat` BOOLEAN DEFAULT NULL,
    `WaterFreqDays` INT DEFAULT NULL,
    `Wetness` INT DEFAULT NULL,
    `NeedFert` BOOLEAN DEFAULT NULL,
    `NeedRepot` BOOLEAN DEFAULT TRUE
);

INSERT INTO `custPlant` VALUES
(1, 1, 1, TRUE, 5, 7, TRUE, TRUE),
(1, 2, 1, TRUE, 6, 8, TRUE, FALSE),
(1, 4, 1, FALSE, 7, 6, FALSE, FALSE),
(2, 2, 1, TRUE, 4, 5, FALSE, TRUE),
(2, 3, 1, FALSE, 5, 6, TRUE, TRUE),
(2, 3, 2, TRUE, 5, 5, FALSE, FALSE);

DROP TABLE IF EXISTS `appointments`;
CREATE TABLE `appointments` (
	`Date` DATE NOT NULL,
    `Time` TIME(2) NOT NULL,
    `CustID` INT NOT NULL,
    `FirstVisit` BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (`CustID`) REFERENCES `customer` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
);



