-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tutorSystem
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tutorSystem
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tutorSystem` DEFAULT CHARACTER SET utf8 ;
USE `tutorSystem` ;

-- -----------------------------------------------------
-- Table `tutorSystem`.`questions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`questions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tutorSystem`.`subjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`subjects` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tutorSystem`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`roles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tutorSystem`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `login` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `roleId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_roles1_idx` (`roleId` ASC) VISIBLE,
  UNIQUE INDEX `login_UNIQUE` (`login` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `password_UNIQUE` (`password` ASC) VISIBLE,
  CONSTRAINT `fk_users_roles1`
    FOREIGN KEY (`roleId`)
    REFERENCES `tutorSystem`.`roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tutorSystem`.`tests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`tests` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL,
  `description` VARCHAR(110) NOT NULL,
  `subjectId` INT(11) NULL,
  `authorId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tests_subjects_idx` (`subjectId` ASC) VISIBLE,
  INDEX `fk_tests_users_idx` (`authorId` ASC) VISIBLE,
  UNIQUE INDEX `title_UNIQUE` (`title` ASC) VISIBLE,
  CONSTRAINT `fk_tests_subjects`
    FOREIGN KEY (`subjectId`)
    REFERENCES `tutorSystem`.`subjects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tests_users`
    FOREIGN KEY (`authorId`)
    REFERENCES `tutorSystem`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tutorSystem`.`answers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`answers` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(45) NOT NULL,
  `isCorrect` INT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tutorSystem`.`answerGroups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`answerGroups` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `answerId` INT(11) NOT NULL,
  `questionId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_answerGroup_answer1_idx` (`answerId` ASC) VISIBLE,
  INDEX `fk_answerGroup_questions1_idx` (`questionId` ASC) VISIBLE,
  CONSTRAINT `fk_answerGroup_answer1`
    FOREIGN KEY (`answerId`)
    REFERENCES `tutorSystem`.`answers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_answerGroup_questions1`
    FOREIGN KEY (`questionId`)
    REFERENCES `tutorSystem`.`questions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tutorSystem`.`testQuestions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`testQuestions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `testId` INT(11) NOT NULL,
  `questionId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_testQuestionsBank_tests1_idx` (`testId` ASC) VISIBLE,
  INDEX `fk_testQuestionsBank_questions1_idx` (`questionId` ASC) VISIBLE,
  CONSTRAINT `fk_testQuestionsBank_tests1`
    FOREIGN KEY (`testId`)
    REFERENCES `tutorSystem`.`tests` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_testQuestionsBank_questions1`
    FOREIGN KEY (`questionId`)
    REFERENCES `tutorSystem`.`questions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tutorSystem`.`assignments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`assignments` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `testId` INT(11) NOT NULL,
  `studentId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_assignments_tests1_idx` (`testId` ASC) VISIBLE,
  INDEX `fk_assignments_users1_idx` (`studentId` ASC) VISIBLE,
  CONSTRAINT `fk_assignments_tests1`
    FOREIGN KEY (`testId`)
    REFERENCES `tutorSystem`.`tests` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assignments_users1`
    FOREIGN KEY (`studentId`)
    REFERENCES `tutorSystem`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tutorSystem`.`replies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tutorSystem`.`replies` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `assigmentId` INT(11) NOT NULL,
  `answerId` INT(11) NOT NULL,
  `questionId` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_replies_assignments1_idx` (`assigmentId` ASC) VISIBLE,
  INDEX `fk_replies_answers1_idx` (`answerId` ASC) VISIBLE,
  INDEX `fk_replies_questions1_idx` (`questionId` ASC) VISIBLE,
  CONSTRAINT `fk_replies_assignments1`
    FOREIGN KEY (`assigmentId`)
    REFERENCES `tutorSystem`.`assignments` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_replies_answers1`
    FOREIGN KEY (`answerId`)
    REFERENCES `tutorSystem`.`answers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_replies_questions1`
    FOREIGN KEY (`questionId`)
    REFERENCES `tutorSystem`.`questions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
