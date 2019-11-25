-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: team55
-- ------------------------------------------------------
-- Server version	8.0.17

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
-- Table structure for table `movieplay`
--

DROP TABLE IF EXISTS `movieplay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movieplay` (
  `PlayDate` date NOT NULL,
  `MovieName` varchar(50) NOT NULL,
  `MovieReleaseDate` date NOT NULL,
  `TheaterName` varchar(50) NOT NULL,
  `CoName` varchar(50) NOT NULL,
  PRIMARY KEY (`PlayDate`,`MovieName`,`MovieReleaseDate`,`TheaterName`,`CoName`),
  KEY `MovieName` (`MovieName`,`MovieReleaseDate`),
  KEY `TheaterName` (`TheaterName`,`CoName`),
  CONSTRAINT `movieplay_ibfk_1` FOREIGN KEY (`MovieName`, `MovieReleaseDate`) REFERENCES `movie` (`Name`, `ReleaseDate`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `movieplay_ibfk_2` FOREIGN KEY (`TheaterName`, `CoName`) REFERENCES `theater` (`Name`, `CompanyName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movieplay`
--

LOCK TABLES `movieplay` WRITE;
/*!40000 ALTER TABLE `movieplay` DISABLE KEYS */;
INSERT INTO `movieplay` VALUES ('2019-08-12','4400 The Movie','2019-08-12','Star Movies','EZ Theater Company'),('2019-09-12','4400 The Movie','2019-08-12','Cinema Star','4400 Theater Company'),('2019-10-12','4400 The Movie','2019-08-12','ABC Theater','Awesome Theater Company'),('2019-10-10','Calculus Returns: A ML Story','2019-09-19','ML Movies','AI Theater Company'),('2019-12-30','Calculus Returns: A ML Story','2019-09-19','ML Movies','AI Theater Company'),('2010-05-20','George P Burdell\'s Life Story','1927-08-12','Cinema Star','4400 Theater Company'),('2019-07-14','George P Burdell\'s Life Story','1927-08-12','Main Movies','EZ Theater Company'),('2019-10-22','George P Burdell\'s Life Story','1927-08-12','Main Movies','EZ Theater Company'),('1985-08-13','Georgia Tech The Movie','1985-08-13','ABC Theater','Awesome Theater Company'),('2019-09-30','Georgia Tech The Movie','1985-08-13','Cinema Star','4400 Theater Company'),('2010-03-22','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),('2010-03-23','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),('2010-03-25','How to Train Your Dragon','2010-03-21','Star Movies','EZ Theater Company'),('2010-04-02','How to Train Your Dragon','2010-03-21','Cinema Star','4400 Theater Company'),('1999-06-24','Spaceballs','1987-06-24','Main Movies','EZ Theater Company'),('2000-02-02','Spaceballs','1987-06-24','Cinema Star','4400 Theater Company'),('2010-04-02','Spaceballs','1987-06-24','ML Movies','AI Theater Company'),('2023-01-23','Spaceballs','1987-06-24','ML Movies','AI Theater Company'),('2019-09-30','Spider-Man: Into the Spider-Verse','2018-12-01','ML Movies','AI Theater Company'),('2018-07-19','The First Pokemon Movie','1998-07-19','ABC Theater','Awesome Theater Company'),('2019-12-20','The King\'s Speech','2010-11-26','Cinema Star','4400 Theater Company'),('2019-12-20','The King\'s Speech','2010-11-26','Main Movies','EZ Theater Company');
/*!40000 ALTER TABLE `movieplay` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-25  2:17:15
