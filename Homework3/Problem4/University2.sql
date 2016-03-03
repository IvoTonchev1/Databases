-- MySQL Script generated by MySQL Workbench
-- 06/22/15 18:16:31
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema University
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema University
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `University` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `University` ;

-- -----------------------------------------------------
-- Table `University`.`Faculties`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Faculties` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `Name` VARCHAR(20) NOT NULL COMMENT '',
  PRIMARY KEY (`Id`)  COMMENT '',
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC)  COMMENT '')
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Departments` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `Name` VARCHAR(20) NOT NULL COMMENT '',
  `FacultyId` INT NOT NULL COMMENT '',
  PRIMARY KEY (`Id`)  COMMENT '',
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC)  COMMENT '',
  INDEX `fk_Departments_Faculties1_idx` (`FacultyId` ASC)  COMMENT '',
  CONSTRAINT `fk_Departments_Faculties1`
    FOREIGN KEY (`FacultyId`)
    REFERENCES `University`.`Faculties` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Students` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `Name` VARCHAR(20) NOT NULL COMMENT '',
  `FacultyId` INT NOT NULL COMMENT '',
  PRIMARY KEY (`Id`)  COMMENT '',
  INDEX `fk_Students_Faculties1_idx` (`FacultyId` ASC)  COMMENT '',
  CONSTRAINT `fk_Students_Faculties1`
    FOREIGN KEY (`FacultyId`)
    REFERENCES `University`.`Faculties` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Courses` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `Name` VARCHAR(20) NOT NULL COMMENT '',
  `DepartmentId` INT NOT NULL COMMENT '',
  PRIMARY KEY (`Id`)  COMMENT '',
  INDEX `fk_Courses_Departments1_idx` (`DepartmentId` ASC)  COMMENT '',
  CONSTRAINT `fk_Courses_Departments1`
    FOREIGN KEY (`DepartmentId`)
    REFERENCES `University`.`Departments` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Professors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Professors` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `Name` VARCHAR(20) NOT NULL COMMENT '',
  `DepartmentId` INT NOT NULL COMMENT '',
  PRIMARY KEY (`Id`)  COMMENT '',
  INDEX `fk_Professors_Departments1_idx` (`DepartmentId` ASC)  COMMENT '',
  CONSTRAINT `fk_Professors_Departments1`
    FOREIGN KEY (`DepartmentId`)
    REFERENCES `University`.`Departments` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Titles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Titles` (
  `Id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `Name` VARCHAR(20) NOT NULL COMMENT '',
  PRIMARY KEY (`Id`)  COMMENT '',
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC)  COMMENT '')
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`StudentsCourses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`StudentsCourses` (
  `StudentId` INT NOT NULL COMMENT '',
  `CourseId` INT NOT NULL COMMENT '',
  INDEX `fk_Students_has_Courses_Courses1_idx` (`CourseId` ASC)  COMMENT '',
  INDEX `fk_Students_has_Courses_Students_idx` (`StudentId` ASC)  COMMENT '',
  CONSTRAINT `fk_Students_has_Courses_Students`
    FOREIGN KEY (`StudentId`)
    REFERENCES `University`.`Students` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Students_has_Courses_Courses1`
    FOREIGN KEY (`CourseId`)
    REFERENCES `University`.`Courses` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`ProfessorsCourses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`ProfessorsCourses` (
  `ProfessorId` INT NOT NULL COMMENT '',
  `CourseId` INT NOT NULL COMMENT '',
  INDEX `fk_Professors_has_Courses_Courses1_idx` (`CourseId` ASC)  COMMENT '',
  INDEX `fk_Professors_has_Courses_Professors1_idx` (`ProfessorId` ASC)  COMMENT '',
  CONSTRAINT `fk_Professors_has_Courses_Professors1`
    FOREIGN KEY (`ProfessorId`)
    REFERENCES `University`.`Professors` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Professors_has_Courses_Courses1`
    FOREIGN KEY (`CourseId`)
    REFERENCES `University`.`Courses` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`ProfessorsTitles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`ProfessorsTitles` (
  `ProfessorId` INT NOT NULL COMMENT '',
  `TitleId` INT NOT NULL COMMENT '',
  INDEX `fk_Professors_has_Titles_Titles1_idx` (`TitleId` ASC)  COMMENT '',
  INDEX `fk_Professors_has_Titles_Professors1_idx` (`ProfessorId` ASC)  COMMENT '',
  CONSTRAINT `fk_Professors_has_Titles_Professors1`
    FOREIGN KEY (`ProfessorId`)
    REFERENCES `University`.`Professors` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Professors_has_Titles_Titles1`
    FOREIGN KEY (`TitleId`)
    REFERENCES `University`.`Titles` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;