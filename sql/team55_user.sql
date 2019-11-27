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
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `Username` varchar(50) NOT NULL,
  `Firstname` varchar(50) NOT NULL,
  `Lastname` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `Status` varchar(50) NOT NULL,
  PRIMARY KEY (`Username`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('calcultron','Dwight','Schrute','333333333','Approved'),('calcultron2','Jim','Halpert','444444444','Approved'),('calcwizard','Issac','Newton','222222222','Approved'),('clarinetbeast','Squidward','Tentacles','999999999','Declined'),('cool_class4400','A. TA','Washere','333333333','Approved'),('DNAhelix','Rosalind','Franklin','777777777','Approved'),('does2Much','Carl','Gauss','1212121212','Approved'),('eeqmcsquare','Albert','Einstein','111111110','Approved'),('entropyRox','Claude','Shannon','999999999','Approved'),('fatherAI','Alan','Turing','222222222','Approved'),('fullMetal','Edward','Elric','111111100','Approved'),('gdanger','Gary','Danger','555555555','Declined'),('georgep','George P.','Burdell','111111111','Approved'),('ghcghc','Grace','Hopper','666666666','Approved'),('ilikemoney$$','Eugene','Krabs','111111110','Approved'),('imbatman','Bruce','Wayne','666666666','Approved'),('imready','Spongebob','Squarepants','777777777','Approved'),('isthisthekrustykrab','Patrick','Star','888888888','Approved'),('manager1','Manager','One','1122112211','Approved'),('manager2','Manager','Two','3131313131','Approved'),('manager3','Three','Three','8787878787','Approved'),('manager4','Four','Four','5755555555','Approved'),('notFullMetal','Alphonse','Elric','111111100','Approved'),('programerAAL','Ada','Lovelace','3131313131','Approved'),('radioactivePoRa','Marie','Curie','1313131313','Approved'),('RitzLover28','Abby','Normal','444444444','Approved'),('smith_j','John','Smith','333333333','Pending'),('texasStarKarate','Sandy','Cheeks','111111110','Declined'),('thePiGuy3.14','Archimedes','Syracuse','1111111111','Approved'),('theScienceGuy','Bill','Nye','999999999','Approved');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
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
