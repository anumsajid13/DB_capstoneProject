-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customer` (
  `CustomerId` INT NOT NULL,
  `CustomerName` VARCHAR(100) NULL,
  PRIMARY KEY (`CustomerId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Booking` (
  `BookingId` INT NOT NULL,
  `BookingDate` DATE NULL,
  `TableNo` INT NULL,
  `CustomerID` INT NULL,
  PRIMARY KEY (`BookingId`),
  INDEX `CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `CustomerID`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `MenuId` INT NOT NULL,
  `Name` VARCHAR(100) NULL,
  `Cuisine` VARCHAR(100) NULL,
  PRIMARY KEY (`MenuId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Order` (
  `OrderId` INT NOT NULL,
  `OrderDate` DATE NULL,
  `Quantity` INT NULL,
  `TotalCost` DECIMAL NULL,
  `CustomerId` INT NULL,
  `MenuId` INT NULL,
  PRIMARY KEY (`OrderId`),
  INDEX `CustomerId_idx` (`CustomerId` ASC) VISIBLE,
  INDEX `MenuId_idx` (`MenuId` ASC) VISIBLE,
  CONSTRAINT `FK_CustomerId`
    FOREIGN KEY (`CustomerId`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_MenuId`
    FOREIGN KEY (`MenuId`)
    REFERENCES `LittleLemonDB`.`Menu` (`MenuId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Role` (
  `RoleId` INT NOT NULL,
  `Role` VARCHAR(100) NULL,
  PRIMARY KEY (`RoleId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `StaffId` INT NOT NULL,
  `Name` VARCHAR(100) NULL,
  `Salary` DECIMAL NULL,
  `RollID` INT NULL,
  PRIMARY KEY (`StaffId`),
  INDEX `RollID_idx` (`RollID` ASC) VISIBLE,
  CONSTRAINT `RollID`
    FOREIGN KEY (`RollID`)
    REFERENCES `LittleLemonDB`.`Role` (`RoleId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`OderDeliveryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`OderDeliveryStatus` (
  `DeliveryId` INT NOT NULL,
  `Date` DATE NULL,
  `Status` VARCHAR(100) NULL,
  `StaffId` INT NULL,
  `OrderId` INT NULL,
  PRIMARY KEY (`DeliveryId`),
  INDEX `StaffId_idx` (`StaffId` ASC) VISIBLE,
  INDEX `OrderId_idx` (`OrderId` ASC) VISIBLE,
  CONSTRAINT `StaffId`
    FOREIGN KEY (`StaffId`)
    REFERENCES `LittleLemonDB`.`Staff` (`StaffId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `OrderId`
    FOREIGN KEY (`OrderId`)
    REFERENCES `LittleLemonDB`.`Order` (`OrderId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`ContactDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`ContactDetails` (
  `ContactId` INT NOT NULL,
  `Email` VARCHAR(100) NULL,
  `PhoneNO` VARCHAR(45) NULL,
  `Address` VARCHAR(100) NULL,
  `Country` VARCHAR(100) NULL,
  `City` VARCHAR(100) NULL,
  `CustomerId` INT NULL,
  `StaffId` INT NULL,
  PRIMARY KEY (`ContactId`),
  INDEX `CustomerId_idx` (`CustomerId` ASC) VISIBLE,
  INDEX `StaffId_idx` (`StaffId` ASC) VISIBLE,
  CONSTRAINT `FK1_CustomerId`
    FOREIGN KEY (`CustomerId`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK1_StaffId`
    FOREIGN KEY (`StaffId`)
    REFERENCES `LittleLemonDB`.`Staff` (`StaffId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`MenuItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`MenuItems` (
  `MenuItemId` INT NOT NULL,
  `Course` VARCHAR(100) NULL,
  `desert` VARCHAR(100) NULL,
  `Starter` VARCHAR(100) NULL,
  PRIMARY KEY (`MenuItemId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`MenuContent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`MenuContent` (
  `MenuId` INT NOT NULL,
  `MenuItemId` INT NOT NULL,
  INDEX `MenuId_idx` (`MenuId` ASC) VISIBLE,
  CONSTRAINT `FK_MenuId`
    FOREIGN KEY (`MenuId`)
    REFERENCES `LittleLemonDB`.`Menu` (`MenuId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `MenuItemId`
    FOREIGN KEY (`MenuItemId`)
    REFERENCES `LittleLemonDB`.`MenuItems` (`MenuItemId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
