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
-- Table structure for table `theater`
--

DROP TABLE IF EXISTS `theater`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `theater` (
  `Name` varchar(50) NOT NULL,
  `CompanyName` varchar(50) NOT NULL,
  `ThtrStreet` varchar(50) NOT NULL,
  `ThtrCity` varchar(50) NOT NULL,
  `ThtrState` varchar(50) NOT NULL,
  `ThtrZipcode` varchar(50) NOT NULL,
  `Capacity` int(11) NOT NULL,
  `MngUsername` varchar(50) NOT NULL,
  PRIMARY KEY (`Name`,`CompanyName`),
  KEY `MngUsername` (`MngUsername`),
  KEY `CompanyName` (`CompanyName`),
  CONSTRAINT `theater_ibfk_1` FOREIGN KEY (`CompanyName`) REFERENCES `company` (`Name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `theater_ibfk_2` FOREIGN KEY (`MngUsername`) REFERENCES `manager` (`Username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `theater`
--

LOCK TABLES `theater` WRITE;
/*!40000 ALTER TABLE `theater` DISABLE KEYS */;
INSERT INTO `theater` VALUES ('ABC Theater','Awesome Theater Company','880 Color Dr','Austin','TX','73301',5,'imbatman'),('Cinema Star','4400 Theater Company','100 Cool Place','San Francisco','CA','94016',4,'entropyRox'),('Jonathan\'s Movies','4400 Theater Company','67 Pearl Dr','Seattle','WA','98101',2,'georgep'),('Main Movies','EZ Theater Company','123 Main St','New York','NY','10001',3,'fatherAI'),('ML Movies','AI Theater Company','314 Pi St','Pallet Town','KS','31415',3,'ghcghc'),('Star Movies','4400 Theater Company','4400 Rocks Ave','Boulder','CA','80301',5,'radioactivePoRa'),('Star Movies','EZ Theater Company','745 GT St','Atlanta','GA','30332',2,'calcultron');
/*!40000 ALTER TABLE `theater` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-25  2:17:16
