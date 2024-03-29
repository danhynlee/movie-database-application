-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: team55
-- ------------------------------------------------------
-- Server version	8.0.17

use team55;
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `VisitUserTheater`
--

DROP TABLE IF EXISTS `UserVisitTheater`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserVisitTheater` (
  `visitID` INT(50) NOT NULL AUTO_INCREMENT,
  `visitDate` date NOT NULL,
  `username` varchar(50) NOT NULL,
  `thName` varchar(50) NOT NULL,
  `comName` varchar(50) NOT NULL,
  PRIMARY KEY (`visitID`),
  UNIQUE KEY `visitID` (`visitID`),
  KEY `username` (`username`),
  KEY `thName` (`thName`,`comName`),
  CONSTRAINT `visit_ibfk_1` FOREIGN KEY (`username`) REFERENCES `User` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `visit_ibfk_2` FOREIGN KEY (`thName`, `comName`) REFERENCES `Theater` (`thName`, `comName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VisitUserTheater`
--

LOCK TABLES `UserVisitTheater` WRITE;
/*!40000 ALTER TABLE `UserVisitTheater` DISABLE KEYS */;
INSERT INTO `UserVisitTheater` VALUES ('1','2010-03-22','georgep','Main Movies','EZ Theater Company'),('2','2010-03-22','calcwizard','Main Movies','EZ Theater Company'),('3','2010-03-25','calcwizard','Star Movies','EZ Theater Company'),('4','2010-03-25','imready','Star Movies','EZ Theater Company'),('5','2010-03-20','calcwizard','ML Movies','AI Theater Company');
/*!40000 ALTER TABLE `UserVisitTheater` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-25  2:17:17
