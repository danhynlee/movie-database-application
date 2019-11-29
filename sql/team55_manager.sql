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
-- Table structure for table `Manager`
--

DROP TABLE IF EXISTS `Manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Manager` (
  `username` varchar(50) NOT NULL,
  `manStreet` varchar(50) NOT NULL,
  `manCity` varchar(50) NOT NULL,
  `manState` varchar(50) NOT NULL,
  `manZipCode` varchar(50) NOT NULL,
  `comName` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  KEY `comName` (`comName`),
  CONSTRAINT `manager_ibfk_1` FOREIGN KEY (`username`) REFERENCES `Employee` (`username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `manager_ibfk_2` FOREIGN KEY (`comName`) REFERENCES `Company` (`comName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Manager`
--

LOCK TABLES `Manager` WRITE;
/*!40000 ALTER TABLE `Manager` DISABLE KEYS */;
INSERT INTO `Manager` VALUES ('calcultron','123 Peachtree St','Atlanta','GA','30308','EZ Theater Company'),('entropyRox','200 Cool Place','San Francisco','CA','94016','4400 Theater Company'),('fatherAI','456 Main St','New York','NY','10001','EZ Theater Company'),('georgep','10 Pearl Dr','Seattle','WA','98105','4400 Theater Company'),('ghcghc','100 Pi St','Pallet Town','KS','31415','AI Theater Company'),('imbatman','800 Color Dr','Austin','TX','78653','Awesome Theater Company'),('manager1','123 Ferst Drive','Atlanta','GA','30332','4400 Theater Company'),('manager2','456 Ferst Drive','Atlanta','GA','30332','AI Theater Company'),('manager3','789 Ferst Drive','Atlanta','GA','30332','4400 Theater Company'),('manager4','000 Ferst Drive','Atlanta','GA','30332','4400 Theater Company'),('radioactivePoRa','100 Blu St','Sunnyvale','CA','94088','4400 Theater Company');
/*!40000 ALTER TABLE `Manager` ENABLE KEYS */;
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
