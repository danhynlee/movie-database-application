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
-- Table structure for table `used`
--

DROP TABLE IF EXISTS `used`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `used` (
  `CCnum` varchar(16) NOT NULL,
  `MoviePlayDate` date NOT NULL,
  `MovieName` varchar(50) NOT NULL,
  `MovieReleaseDate` date NOT NULL,
  `TheaterName` varchar(50) NOT NULL,
  `CoName` varchar(50) NOT NULL,
  PRIMARY KEY (`CCnum`,`MoviePlayDate`,`MovieName`,`MovieReleaseDate`,`TheaterName`,`CoName`),
  KEY `MoviePlayDate` (`MoviePlayDate`,`MovieName`,`MovieReleaseDate`,`TheaterName`,`CoName`),
  CONSTRAINT `used_ibfk_2` FOREIGN KEY (`MoviePlayDate`, `MovieName`, `MovieReleaseDate`, `TheaterName`, `CoName`) REFERENCES `movieplay` (`PlayDate`, `MovieName`, `MovieReleaseDate`, `TheaterName`, `CoName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `used`
--

LOCK TABLES `used` WRITE;
/*!40000 ALTER TABLE `used` DISABLE KEYS */;
INSERT INTO `used` VALUES ('1111111111111111','2010-03-22','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),('1111111111111111','2010-03-23','How to Train Your Dragon','2010-03-21','Main Movies','EZ Theater Company'),('1111111111111100','2010-03-25','How to Train Your Dragon','2010-03-21','Star Movies','EZ Theater Company'),('1111111111111111','2010-04-02','How to Train Your Dragon','2010-03-21','Cinema Star','4400 Theater Company');
/*!40000 ALTER TABLE `used` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-25  2:17:18
