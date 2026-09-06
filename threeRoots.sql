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
	`ID` INT NOT NULL AUTO_INCREMENT,
	`Species` VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID)
);

INSERT INTO `plant` VALUES
(1, 'Elephant Ear'),
(2, 'Babys Breath'),
(3, 'Hibiscus'),
(4, 'Pothos');


DROP TABLE IF EXISTS `custPlant`;
CREATE TABLE `custPlant` (
	`CustID` INT NOT NULL,
    `PlantID` INT NOT NULL,
    `Quan` INT NOT NULL,
    `NeedBugTreat` BOOLEAN DEFAULT NULL,
    `WaterFreqDays` INT DEFAULT NULL,
    `Wetness` INT DEFAULT NULL,
    `NeedFert` BOOLEAN DEFAULT NULL,
    `NeedRepot` BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (`CustID`, `PlantID`, `Quan`),
    FOREIGN KEY (`CustID`) REFERENCES `customer` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`PlantID`) REFERENCES `plant` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
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
    PRIMARY KEY (`Date`, `Time`, `CustID`),
    FOREIGN KEY (`CustID`) REFERENCES `customer` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

#Populate Appointment data

#Y-M-D Date Format
INSERT INTO `appointments` VALUES
('2026-09-01', '12:00:00', 1, TRUE),
('2026-09-08','12:00:00', 1, FALSE),
('2026-09-13', '13:00:00' , 1, FALSE),
('2026-09-03', '15:00:00', 2, TRUE),
('2026-09-10', '14:00:00', 2, FALSE),
('2026-09-17', '16:00:00', 2, FALSE);


/*VIEWS*/

CREATE VIEW `custPlant Inventory` AS 
	SELECT c.Name AS `Customer`, p.Species AS `Plant`, cp.Quan AS `No.`, cp.NeedBugTreat AS `Needs Bug Treat?`,
    cp.WaterFreqDays AS `Water Freq. (Days)`, cp.Wetness AS `Wetness 1-10`, cp.NeedFert AS `Needs Fertilizer?`,
    cp.NeedRepot AS `Needs Repotting?`
    FROM custPlant cp
    JOIN customer c
    ON cp.CustID = c.ID
    JOIN plant p
    ON cp.PlantID = p.ID
    ORDER BY cp.CustID, cp.PlantID, cp.Quan;

#SELECT * FROM `custPlant Inventory`;

CREATE VIEW `all appointments` AS
	SELECT concat(DATE_FORMAT(a.Date,'%m/%d/%Y'), ' @ ', TIME_FORMAT(a.Time,'%h:%i %p')) AS `Date and Time`,
    c.Name AS `Customer`, a.FirstVisit AS `First Visit?`
    FROM appointments a 
    JOIN customer c 
    ON a.CustID = c.ID
    ORDER BY a.Date, a.Time;
    
#SELECT * FROM `all appointments`;


/*FUNCTIONS*/

#WORKS
DELIMITER $$

CREATE FUNCTION getCustID(custName VARCHAR(50))
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE foundCustID INT;
    SELECT ID INTO foundCustID
    FROM customer
    WHERE Name = custName;
    
    IF foundCustID IS NULL
    THEN SET foundCustID = -1;
    END IF;
    
    RETURN foundCustID;
END$$

DELIMITER ;

#SELECT getCustID('John Dooe');

#WORKS
DELIMITER $$

CREATE FUNCTION getPlantID(plantName VARCHAR(50))
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE foundPlantID INT;
    SELECT ID INTO foundPlantID
    FROM plant
    WHERE Species = plantName;
    
    IF foundPlantID IS NULL
    THEN SET foundPlantID = -1;
    END IF;
    
    RETURN foundPlantID;
END$$

DELIMITER ;

#SELECT getPlantID('Hibiiscus');


/*PROCEDURES*/

DELIMITER $$

#WORKS
CREATE PROCEDURE getCustPlant(custName VARCHAR(50), plantName VARCHAR(50))

BEGIN
	DECLARE foundCustID INT;
	DECLARE foundPlantID INT;
    
    SELECT getCustID(custName) INTO foundCustID;
    
    SELECT getPlantID(plantName) INTO foundPlantID;
    
    IF foundCustID IS NULL
    THEN SET foundCustID = -1;
    END IF;
    
    IF foundPlantID IS NULL
    THEN SET foundPlantID = -1;
    END IF;

	IF foundCustID = -1 AND foundPlantID != -1
		THEN SELECT -1;
    ELSEIF foundPlantID = -1 AND foundCustID != -1
		THEN SELECT -2;
    ELSEIF foundCustID = -1 AND foundPlantID = -1
		THEN SELECT -3;
    ELSE SELECT * FROM `custPlant Inventory`
    WHERE `Customer` = custName
    AND `Plant` = plantName;
    END IF;
	
END$$

DELIMITER ;

#CALL getCustPlant('Mark Smith', 'Hibiiscus');

DELIMITER $$

#WORKS
CREATE PROCEDURE getCustInv(custName VARCHAR(50))

BEGIN
	DECLARE foundCustID INT;
    
    SELECT getCustID(custName) INTO foundCustID;
    
    IF foundCustID IS NULL
    THEN SET foundCustID = -1;
    END IF;
    

	IF foundCustID = -1
		THEN SELECT -1;
    ELSE SELECT * FROM `custPlant Inventory`
    WHERE `Customer` = custName;
    END IF;
	
END$$

DELIMITER ;

#CALL getCustInv('John Doe')

DELIMITER $$

#WORKS
CREATE PROCEDURE getPlantInv(plantName VARCHAR(50))

BEGIN
	DECLARE foundPlantID INT;
    
    SELECT getPlantID(plantName) INTO foundPlantID;
    
    IF foundPlantID IS NULL
    THEN SET foundPlantID = -1;
    END IF;

    IF foundPlantID = -1
		THEN SELECT -1;
    ELSE SELECT * FROM `custPlant Inventory`
    WHERE `Plant` = plantName;
    END IF;
	
END$$

DELIMITER ;

#CALL getPlantInv('Babys Breathh')

/*ADD AND DELETE FUNCTIONS*/