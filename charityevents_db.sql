-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: charityevents_db
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

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
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `slug` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Fun Run','fun-run'),(2,'Gala Dinner','gala-dinner'),(3,'Charity Auction','charity-auction'),(4,'Community Cleanup','community-cleanup'),(5,'Food Drive','food-drive');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `org_id` int(10) unsigned NOT NULL,
  `category_id` int(10) unsigned NOT NULL,
  `title` varchar(160) NOT NULL,
  `description` text DEFAULT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `location_city` varchar(100) DEFAULT NULL,
  `location_venue` varchar(160) DEFAULT NULL,
  `image_url` varchar(300) DEFAULT NULL,
  `is_free` tinyint(1) NOT NULL DEFAULT 1,
  `price_cents` int(10) unsigned DEFAULT 0,
  `goal_amount_cents` int(10) unsigned DEFAULT 0,
  `raised_amount_cents` int(10) unsigned DEFAULT 0,
  `status` enum('active','suspended') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_events_org` (`org_id`),
  KEY `idx_events_start` (`start_datetime`),
  KEY `idx_events_city` (`location_city`),
  KEY `idx_events_cat` (`category_id`),
  KEY `idx_events_status` (`status`),
  CONSTRAINT `fk_events_cat` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_events_org` FOREIGN KEY (`org_id`) REFERENCES `organisations` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `chk_time` CHECK (`end_datetime` > `start_datetime`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,1,1,'KindSteps 10K Fun Run','Annual 10K run to fund health programs.','2025-10-18 07:00:00','2025-10-18 11:00:00','Sydney','Centennial Park','https://picsum.photos/seed/run1/800/400',0,3000,500000,120000,'active','2025-09-28 18:11:03'),(2,1,2,'Spring Charity Gala','Formal dinner with live music and speakers.','2025-11-08 18:30:00','2025-11-09 00:00:00','Melbourne','Grand Ballroom','https://picsum.photos/seed/gala1/800/400',0,12000,1500000,350000,'active','2025-09-28 18:11:03'),(3,2,4,'Riverbank Cleanup Day','Join volunteers to clean the riverbank and parks.','2025-09-20 09:00:00','2025-09-20 13:00:00','Brisbane','Riverbend Park','https://picsum.photos/seed/cleanup1/800/400',1,0,0,0,'active','2025-09-28 18:11:03'),(4,1,5,'Spring Food Drive','Collecting non-perishables for local shelters.','2025-09-10 10:00:00','2025-09-10 16:00:00','Sydney','Community Hall','https://picsum.photos/seed/food1/800/400',1,0,0,0,'active','2025-09-28 18:11:03'),(5,2,3,'Art for Earth Auction','Bid on donated artworks to support tree-planting.','2025-10-25 17:00:00','2025-10-25 21:00:00','Adelaide','Cultural Centre','https://picsum.photos/seed/auction1/800/400',0,2500,300000,45000,'active','2025-09-28 18:11:03'),(6,2,4,'Beach Cleanup Weekend','Two-hour cleanup followed by workshop.','2025-10-05 08:00:00','2025-10-05 10:00:00','Gold Coast','Main Beach','https://picsum.photos/seed/cleanup2/800/400',1,0,0,0,'active','2025-09-28 18:11:03'),(7,1,1,'City Night Run','Night run through CBD — suspended due to policy violation pending review.','2025-10-12 19:00:00','2025-10-12 22:00:00','Sydney','Harbour Loop','https://picsum.photos/seed/run2/800/400',0,2000,0,0,'suspended','2025-09-28 18:11:03'),(8,1,5,'Holiday Food Drive','Help us prepare food hampers for families.','2025-12-06 09:00:00','2025-12-06 15:00:00','Canberra','Civic Centre','https://picsum.photos/seed/food2/800/400',1,0,0,0,'active','2025-09-28 18:11:03');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organisations`
--

DROP TABLE IF EXISTS `organisations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organisations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `mission` text DEFAULT NULL,
  `contact_email` varchar(160) DEFAULT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organisations`
--

LOCK TABLES `organisations` WRITE;
/*!40000 ALTER TABLE `organisations` DISABLE KEYS */;
INSERT INTO `organisations` VALUES (1,'KindSteps Foundation','Supporting community health and education.','hello@kindsteps.org','+61-2-5555-1000','https://kindsteps.org','2025-09-28 18:11:03'),(2,'GreenPulse','Environmental conservation and climate action.','contact@greenpulse.au','+61-3-5555-2000','https://greenpulse.au','2025-09-28 18:11:03');
/*!40000 ALTER TABLE `organisations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-29  2:28:53
