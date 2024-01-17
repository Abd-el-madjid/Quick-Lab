CREATE DATABASE  IF NOT EXISTS `quick_lab` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `quick_lab`;
-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: quick_lab
-- ------------------------------------------------------
-- Server version	8.0.28

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
-- Table structure for table `abonnement`
--

DROP TABLE IF EXISTS `abonnement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abonnement` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  `type_abonnement` enum('one_month','three_months','one_year') DEFAULT NULL,
  `statut` enum('actif','expiré','annulé','en attente') DEFAULT NULL,
  `montant` decimal(10,2) DEFAULT NULL,
  `id_lab` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_abn_lab_idx` (`id_lab`),
  CONSTRAINT `id_lab_abb` FOREIGN KEY (`id_lab`) REFERENCES `laboratoire` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abonnement`
--

LOCK TABLES `abonnement` WRITE;
/*!40000 ALTER TABLE `abonnement` DISABLE KEYS */;
INSERT INTO `abonnement` VALUES (6,'2023-05-24','2024-09-06',NULL,'actif',2002.00,1001),(16,'2023-06-09','2024-06-08',NULL,'actif',365000.00,1009),(17,'2023-06-10','2023-09-08',NULL,'actif',90000.00,1010),(18,'2023-06-10','2024-06-09',NULL,'en attente',NULL,1011);
/*!40000 ALTER TABLE `abonnement` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_abonnement_status_change` AFTER UPDATE ON `abonnement` FOR EACH ROW BEGIN
    DECLARE lab_id INT;
    DECLARE dir_id BIGINT;
    DECLARE per_id BIGINT;

    IF NEW.statut = 'actif' AND NEW.montant IS NOT NULL THEN
        SELECT id_lab INTO lab_id FROM abonnement WHERE id = NEW.id;
        SELECT id FROM directeur WHERE id_lab = lab_id INTO dir_id;
        SELECT id FROM personne WHERE id = dir_id INTO per_id;

        INSERT INTO notification (contenu, id_prs) VALUES (CONCAT('Your abonnement with ID ', NEW.id, ' is now active.'), per_id);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(45) DEFAULT NULL,
  `prenom` varchar(45) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  `mot_de_pass` varchar(45) DEFAULT NULL,
  `sex` varchar(45) DEFAULT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'Kahoul','Abd El Madjid ','madjid','123',NULL,'2023-06-11 10:31:02.728243');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `analyse_champ`
--

DROP TABLE IF EXISTS `analyse_champ`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `analyse_champ` (
  `code` varchar(20) NOT NULL,
  `champ_name` text,
  `units` text,
  PRIMARY KEY (`code`),
  CONSTRAINT `code_analyse` FOREIGN KEY (`code`) REFERENCES `type_analyse` (`code`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `analyse_champ`
--

LOCK TABLES `analyse_champ` WRITE;
/*!40000 ALTER TABLE `analyse_champ` DISABLE KEYS */;
INSERT INTO `analyse_champ` VALUES ('BAA','Red Blood Cell Count$Packed Cell Volume$Mean Corpuscular Volume$Mean Corpuscular Hemoglobin$Mean Corpuscular Hemoglobin Concentration$Red Cell Distribution Width$Total Leukocyte Count$Platelets$Hemoglobin','Cells/ΜL$%$FL$Pg$G/DL$%$Cells/ΜL$Cells/ΜL$G/DL'),('BBMP','Sodium (Na)$Potassium (K)','mmol/L$mmol/L'),('BBT','Blood groups',''),('BCBC','Red Blood Cells (RBC)$Hemoglobin (Hb)$Hematocrit (Hct)$White Blood Cells (WBC)$Platelet Count$Mean Corpuscular Volume (MCV)$Mean Corpuscular Hemoglobin (MCH)$Mean Corpuscular Hemoglobin Concentration (MCHC)','millions of cells/mcL$grams/dL$%$cells/mcL$thousands/mcL$femtoliters$picograms$grams/dL%'),('BCMP','Sodium (Na)$Potassium (K)$Chloride (Cl)$Bicarbonate (HCO3-)$Blood Urea Nitrogen (BUN)$Creatinine$Glucose$Calcium (Ca)$Albumin','mmol/L$mmol/L$mmol/L$mmol/L$mg/dL$mg/dL$mg/dL$mg/dL'),('BCP','Prothrombin Time (PT)$Activated Partial Thromboplastin Time (aPTT)$International Normalized Ratio (INR)','seconds$seconds$seconds'),('BDA','Number Of Times Pregnant$Plasma Glucose Concentration$Diastolic Blood Pressure$Triceps Skin Fold Thickness$2-Hour Serum Insulin$Body Mass Index$Diabetes Pedigree Function','Nb$Mg/DL$Mm Hg$Mm$Mu U/Ml$Kg/(M^2)$Dp'),('BESR','Erythrocyte Sedimentation Rate (ESR)','mm/hour'),('BF','Folate','ng/mL'),('BHA','Hemoglobin A1c (HbA1c)','%'),('BHAT','HIV Antibody Test','NA'),('BHBSA',' hepatitis B surface antigen','Positive/Negative'),('BHCA',' antibodies against the hepatitis C virus','Positive/Negative'),('BHIV','presence of antibodies related to HIV','Positive/Negative'),('BHP','Hepatitis Panel','NA'),('BIP','Iron Panel','ug/dL'),('BLA','Total Bilirubin$Direct Bilirubin$Alkaline Phosphatase$Alamine Aminotransferase$Aspartate Aminotransferase$Total Proteins$Albumin$Albumin And Globulin Ratio','Mg/DL$Mg/DL$IU/L$IU/L$IU/L$G/DL$G/DL$AL/G\n'),('BLFT','Liver Function Tests (LFTs)','Various units'),('BLP','Lipid Panel','mg/dL'),('BTP','Thyroid Panel','Various units'),('BTPHA',' antibodies against the bacterium Treponema pallidum','Positive/Negative'),('BVBL','Vitamin B12 Level','pg/mL'),('BVDL','Vitamin D Level','ng/mL');
/*!40000 ALTER TABLE `analyse_champ` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annulation`
--

DROP TABLE IF EXISTS `annulation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annulation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_patient` bigint NOT NULL,
  `branche_id` int NOT NULL,
  `prix` decimal(10,2) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `annulation_pat_id_idx` (`id_patient`),
  CONSTRAINT `annulation_pat_id` FOREIGN KEY (`id_patient`) REFERENCES `patient` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annulation`
--

LOCK TABLES `annulation` WRITE;
/*!40000 ALTER TABLE `annulation` DISABLE KEYS */;
INSERT INTO `annulation` VALUES (19,1000003,100101,78.45,'2023-05-04 15:16:00'),(20,1000003,100101,21.30,'2023-06-07 13:30:13');
/*!40000 ALTER TABLE `annulation` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bloked_client` AFTER INSERT ON `annulation` FOR EACH ROW BEGIN
    DECLARE labo_id INT;
    DECLARE patient_count INT;

    SELECT COUNT(*) INTO patient_count
    FROM annulation
    WHERE id_patient = NEW.id_patient AND branche_id = NEW.branche_id;

    IF patient_count = 3 THEN
        SELECT branche.labo INTO labo_id
        FROM branche
        WHERE branche.id = NEW.branche_id;

        UPDATE client_labo
        SET is_bloked = 1
        WHERE id_labo = labo_id AND id_patient = NEW.id_patient;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add personne',7,'add_personne'),(26,'Can change personne',7,'change_personne'),(27,'Can delete personne',7,'delete_personne'),(28,'Can view personne',7,'view_personne'),(29,'Can add admin',8,'add_admin'),(30,'Can change admin',8,'change_admin'),(31,'Can delete admin',8,'delete_admin'),(32,'Can view admin',8,'view_admin'),(33,'Can add branche',9,'add_branche'),(34,'Can change branche',9,'change_branche'),(35,'Can delete branche',9,'delete_branche'),(36,'Can view branche',9,'view_branche'),(37,'Can add laboratoire',10,'add_laboratoire'),(38,'Can change laboratoire',10,'change_laboratoire'),(39,'Can delete laboratoire',10,'delete_laboratoire'),(40,'Can view laboratoire',10,'view_laboratoire'),(41,'Can add patient',11,'add_patient'),(42,'Can change patient',11,'change_patient'),(43,'Can delete patient',11,'delete_patient'),(44,'Can view patient',11,'view_patient'),(45,'Can add directeur',12,'add_directeur'),(46,'Can change directeur',12,'change_directeur'),(47,'Can delete directeur',12,'delete_directeur'),(48,'Can view directeur',12,'view_directeur'),(49,'Can add medecin chef',13,'add_medecinchef'),(50,'Can change medecin chef',13,'change_medecinchef'),(51,'Can delete medecin chef',13,'delete_medecinchef'),(52,'Can view medecin chef',13,'view_medecinchef'),(53,'Can add infirmier',14,'add_infirmier'),(54,'Can change infirmier',14,'change_infirmier'),(55,'Can delete infirmier',14,'delete_infirmier'),(56,'Can view infirmier',14,'view_infirmier'),(57,'Can add receptionniste',15,'add_receptionniste'),(58,'Can change receptionniste',15,'change_receptionniste'),(59,'Can delete receptionniste',15,'delete_receptionniste'),(60,'Can view receptionniste',15,'view_receptionniste'),(61,'Can add employe',16,'add_employe'),(62,'Can change employe',16,'change_employe'),(63,'Can delete employe',16,'delete_employe'),(64,'Can view employe',16,'view_employe'),(65,'Can add annulation',17,'add_annulation'),(66,'Can change annulation',17,'change_annulation'),(67,'Can delete annulation',17,'delete_annulation'),(68,'Can view annulation',17,'view_annulation'),(69,'Can add canaux',18,'add_canaux'),(70,'Can change canaux',18,'change_canaux'),(71,'Can delete canaux',18,'delete_canaux'),(72,'Can view canaux',18,'view_canaux'),(73,'Can add communication',19,'add_communication'),(74,'Can change communication',19,'change_communication'),(75,'Can delete communication',19,'delete_communication'),(76,'Can view communication',19,'view_communication'),(77,'Can add conseille',20,'add_conseille'),(78,'Can change conseille',20,'change_conseille'),(79,'Can delete conseille',20,'delete_conseille'),(80,'Can view conseille',20,'view_conseille'),(81,'Can add conseille analyse',21,'add_conseilleanalyse'),(82,'Can change conseille analyse',21,'change_conseilleanalyse'),(83,'Can delete conseille analyse',21,'delete_conseilleanalyse'),(84,'Can view conseille analyse',21,'view_conseilleanalyse'),(85,'Can add facture',22,'add_facture'),(86,'Can change facture',22,'change_facture'),(87,'Can delete facture',22,'delete_facture'),(88,'Can view facture',22,'view_facture'),(89,'Can add payment',23,'add_payment'),(90,'Can change payment',23,'change_payment'),(91,'Can delete payment',23,'delete_payment'),(92,'Can view payment',23,'view_payment'),(93,'Can add rendez vous',24,'add_rendezvous'),(94,'Can change rendez vous',24,'change_rendezvous'),(95,'Can delete rendez vous',24,'delete_rendezvous'),(96,'Can view rendez vous',24,'view_rendezvous'),(97,'Can add travail infermier',25,'add_travailinfermier'),(98,'Can change travail infermier',25,'change_travailinfermier'),(99,'Can delete travail infermier',25,'delete_travailinfermier'),(100,'Can view travail infermier',25,'view_travailinfermier'),(101,'Can add branche',26,'add_branche'),(102,'Can change branche',26,'change_branche'),(103,'Can delete branche',26,'delete_branche'),(104,'Can view branche',26,'view_branche'),(105,'Can add client labo',27,'add_clientlabo'),(106,'Can change client labo',27,'change_clientlabo'),(107,'Can delete client labo',27,'delete_clientlabo'),(108,'Can view client labo',27,'view_clientlabo'),(109,'Can add directeur',28,'add_directeur'),(110,'Can change directeur',28,'change_directeur'),(111,'Can delete directeur',28,'delete_directeur'),(112,'Can view directeur',28,'view_directeur'),(113,'Can add laboratoire',29,'add_laboratoire'),(114,'Can change laboratoire',29,'change_laboratoire'),(115,'Can delete laboratoire',29,'delete_laboratoire'),(116,'Can view laboratoire',29,'view_laboratoire'),(117,'Can add prix analyse',30,'add_prixanalyse'),(118,'Can change prix analyse',30,'change_prixanalyse'),(119,'Can delete prix analyse',30,'delete_prixanalyse'),(120,'Can view prix analyse',30,'view_prixanalyse'),(121,'Can add infirmier',31,'add_infirmier'),(122,'Can change infirmier',31,'change_infirmier'),(123,'Can delete infirmier',31,'delete_infirmier'),(124,'Can view infirmier',31,'view_infirmier'),(125,'Can add employe',32,'add_employe'),(126,'Can change employe',32,'change_employe'),(127,'Can delete employe',32,'delete_employe'),(128,'Can view employe',32,'view_employe'),(129,'Can add medecin chef',33,'add_medecinchef'),(130,'Can change medecin chef',33,'change_medecinchef'),(131,'Can delete medecin chef',33,'delete_medecinchef'),(132,'Can view medecin chef',33,'view_medecinchef'),(133,'Can add receptionniste',34,'add_receptionniste'),(134,'Can change receptionniste',34,'change_receptionniste'),(135,'Can delete receptionniste',34,'delete_receptionniste'),(136,'Can view receptionniste',34,'view_receptionniste'),(137,'Can add type analyse',35,'add_typeanalyse'),(138,'Can change type analyse',35,'change_typeanalyse'),(139,'Can delete type analyse',35,'delete_typeanalyse'),(140,'Can view type analyse',35,'view_typeanalyse'),(141,'Can add analyse champ',36,'add_analysechamp'),(142,'Can change analyse champ',36,'change_analysechamp'),(143,'Can delete analyse champ',36,'delete_analysechamp'),(144,'Can view analyse champ',36,'view_analysechamp'),(145,'Can add resultat',37,'add_resultat'),(146,'Can change resultat',37,'change_resultat'),(147,'Can delete resultat',37,'delete_resultat'),(148,'Can view resultat',37,'view_resultat'),(149,'Can add tube analyse',38,'add_tubeanalyse'),(150,'Can change tube analyse',38,'change_tubeanalyse'),(151,'Can delete tube analyse',38,'delete_tubeanalyse'),(152,'Can view tube analyse',38,'view_tubeanalyse'),(153,'Can add poche sang',39,'add_pochesang'),(154,'Can change poche sang',39,'change_pochesang'),(155,'Can delete poche sang',39,'delete_pochesang'),(156,'Can view poche sang',39,'view_pochesang'),(157,'Can add rapport',40,'add_rapport'),(158,'Can change rapport',40,'change_rapport'),(159,'Can delete rapport',40,'delete_rapport'),(160,'Can view rapport',40,'view_rapport'),(161,'Can add resultat rapport pdf',41,'add_resultatrapportpdf'),(162,'Can change resultat rapport pdf',41,'change_resultatrapportpdf'),(163,'Can delete resultat rapport pdf',41,'delete_resultatrapportpdf'),(164,'Can view resultat rapport pdf',41,'view_resultatrapportpdf'),(165,'Can add abonnement',42,'add_abonnement'),(166,'Can change abonnement',42,'change_abonnement'),(167,'Can delete abonnement',42,'delete_abonnement'),(168,'Can view abonnement',42,'view_abonnement'),(169,'Can add payment lab',43,'add_paymentlab'),(170,'Can change payment lab',43,'change_paymentlab'),(171,'Can delete payment lab',43,'delete_paymentlab'),(172,'Can view payment lab',43,'view_paymentlab'),(173,'Can add evaluation',44,'add_evaluation'),(174,'Can change evaluation',44,'change_evaluation'),(175,'Can delete evaluation',44,'delete_evaluation'),(176,'Can view evaluation',44,'view_evaluation'),(177,'Can add reclamation',45,'add_reclamation'),(178,'Can change reclamation',45,'change_reclamation'),(179,'Can delete reclamation',45,'delete_reclamation'),(180,'Can view reclamation',45,'view_reclamation'),(181,'Can add canaux emp',46,'add_canauxemp'),(182,'Can change canaux emp',46,'change_canauxemp'),(183,'Can delete canaux emp',46,'delete_canauxemp'),(184,'Can view canaux emp',46,'view_canauxemp'),(185,'Can add discussion',47,'add_discussion'),(186,'Can change discussion',47,'change_discussion'),(187,'Can delete discussion',47,'delete_discussion'),(188,'Can view discussion',47,'view_discussion'),(189,'Can add notification',48,'add_notification'),(190,'Can change notification',48,'change_notification'),(191,'Can delete notification',48,'delete_notification'),(192,'Can view notification',48,'view_notification');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branche`
--

DROP TABLE IF EXISTS `branche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branche` (
  `id` int NOT NULL,
  `branche_nom` varchar(120) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `localisation` varchar(45) DEFAULT NULL,
  `code_postal` varchar(10) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `num_telephone` varchar(13) DEFAULT NULL,
  `jour_heur_tarvail` text,
  `num_rdv` int DEFAULT NULL,
  `labo` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_lab_idx` (`labo`),
  CONSTRAINT `id_lab` FOREIGN KEY (`labo`) REFERENCES `laboratoire` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branche`
--

LOCK TABLES `branche` WRITE;
/*!40000 ALTER TABLE `branche` DISABLE KEYS */;
INSERT INTO `branche` VALUES (100101,'ibn sina ','Boussouf District, Building No. 10 ','36.327039,6.575282','25019','zizou.b200320015@gmail.com','0561731860','Monday>13:00>17:00$Tuesday>08:00>17:00$Wednesday>08:00>17:00$Thursday>08:00>17:00$Friday>08:00>16:00$Saturday>08:00>17:00$Sunday>08:00>17:00$',8,1001),(100102,'ibn sina','Ali Manjli District 400 Housing Building No. 7','36.264561, 6.578687','25045','zizoub200320015@gmail.com','0561731855','Monday>10:00>05:00$Tuesday>08:00>12:00$Wednesday>09:00>12:00$Thursday>08:00>12:00$Saturday>09:00>00:00$',6,1001),(100901,'EL KAWTER','Al-Kharoub, District 1600, Building No. 17','36.260065, 6.702253','25103','abdelmadjidkahoul5@gmail.com','0658639917','Monday>10:00>16:00$Tuesday>09:00>15:00$Wednesday>13:00>18:00$Sunday>11:00>15:00$',6,1009),(101001,'hama','Al-gmas, District 1620, Building No. 1','36.260065,6.702253','25001','ibnrouchd.Hama@gmail.com','+213658639917','Monday>13:16>14:16$Tuesday>09:16>13:16$Wednesday>10:16>12:16$',12,1010);
/*!40000 ALTER TABLE `branche` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `generate_branche_id` BEFORE INSERT ON `branche` FOR EACH ROW BEGIN 
  DECLARE labo_id INT;
  DECLARE new_id INT;

  SELECT `id` INTO labo_id FROM `laboratoire` WHERE `id` = NEW.`labo`;

  IF labo_id IS NOT NULL THEN
    SELECT COALESCE(MAX(RIGHT(`id`, 2)), 0) + 1 INTO new_id FROM `branche` WHERE `id` LIKE CONCAT(labo_id, '%');
    SET NEW.`id` = CONCAT(labo_id, LPAD(new_id, 2, '0'));
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `canaux`
--

DROP TABLE IF EXISTS `canaux`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `canaux` (
  `id` int NOT NULL AUTO_INCREMENT,
  `branch_id` int DEFAULT NULL,
  `pat_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `canaux_brach_id_idx` (`branch_id`),
  KEY `canauc_pat_id_idx` (`pat_id`),
  CONSTRAINT `canauc_pat_id` FOREIGN KEY (`pat_id`) REFERENCES `patient` (`id`) ON DELETE CASCADE,
  CONSTRAINT `canaux_brach_id` FOREIGN KEY (`branch_id`) REFERENCES `branche` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `canaux`
--

LOCK TABLES `canaux` WRITE;
/*!40000 ALTER TABLE `canaux` DISABLE KEYS */;
INSERT INTO `canaux` VALUES (1,100101,1000003),(2,100102,1000003),(3,100101,184984984);
/*!40000 ALTER TABLE `canaux` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `canaux_emp`
--

DROP TABLE IF EXISTS `canaux_emp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `canaux_emp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_med` int NOT NULL,
  `id_inf` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `canaux_med_id_idx` (`id_med`),
  KEY `canaux_inf_id_idx` (`id_inf`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `canaux_emp`
--

LOCK TABLES `canaux_emp` WRITE;
/*!40000 ALTER TABLE `canaux_emp` DISABLE KEYS */;
INSERT INTO `canaux_emp` VALUES (27,100101004,100101003);
/*!40000 ALTER TABLE `canaux_emp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_labo`
--

DROP TABLE IF EXISTS `client_labo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_labo` (
  `id_labo` int NOT NULL,
  `id_patient` bigint NOT NULL,
  `is_bloked` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_labo`,`id_patient`),
  KEY `id_labo_client_idx` (`id_labo`),
  KEY `id_pat_lab_client_idx` (`id_patient`),
  CONSTRAINT `id_labo_client` FOREIGN KEY (`id_labo`) REFERENCES `laboratoire` (`id`) ON DELETE CASCADE,
  CONSTRAINT `id_pat_lab_client` FOREIGN KEY (`id_patient`) REFERENCES `patient` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_labo`
--

LOCK TABLES `client_labo` WRITE;
/*!40000 ALTER TABLE `client_labo` DISABLE KEYS */;
INSERT INTO `client_labo` VALUES (1001,1000003,0),(1001,184984984,1),(1001,100020887151860008,0);
/*!40000 ALTER TABLE `client_labo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communication`
--

DROP TABLE IF EXISTS `communication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication` (
  `id` int NOT NULL AUTO_INCREMENT,
  `emetteur` enum('patient','laboratoire') NOT NULL,
  `message` text,
  `date` datetime NOT NULL,
  `canaux_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `communication_lab_id` (`emetteur`),
  KEY `id_canaux` (`canaux_id`),
  CONSTRAINT `id_canaux` FOREIGN KEY (`canaux_id`) REFERENCES `canaux` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=255 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communication`
--

LOCK TABLES `communication` WRITE;
/*!40000 ALTER TABLE `communication` DISABLE KEYS */;
INSERT INTO `communication` VALUES (1,'patient','Hi','2023-05-19 01:58:47',1),(2,'laboratoire','bonjour','2023-05-19 01:59:09',2),(178,'patient','Hello','2023-06-09 17:46:45',3),(252,'patient','how are you','2023-06-11 08:16:39',1),(253,'laboratoire','im good and you','2023-06-11 08:17:37',1),(254,'patient','gvuhjokp','2023-06-11 14:16:41',1);
/*!40000 ALTER TABLE `communication` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `communication_insert_trigger` AFTER INSERT ON `communication` FOR EACH ROW BEGIN
    DECLARE v_canaux_id, v_branch_id INT;
    DECLARE v_emetteur ENUM('patient','laboratoire');
    DECLARE v_id_prs INT;
   
    DECLARE v_pat_id BIGINT;
    DECLARE v_labo_name VARCHAR(45);
    DECLARE v_contenu TEXT;
    
    -- Get the values from the inserted row
    SET v_emetteur = NEW.emetteur;
    SET v_canaux_id = NEW.canaux_id;
    
    
    
    IF NEW.emetteur = 'patient' THEN
        SELECT canaux_id, branch_id INTO v_canaux_id, v_branch_id FROM communication c
        INNER JOIN canaux cx ON c.canaux_id = cx.id
        WHERE c.id = NEW.id;
        
        INSERT INTO notification (date, contenu, id_prs, is_read)
        SELECT NEW.date, 'You received a new message from the patient. Check your DM.', e.id_prs, 0
        FROM employe e
        INNER JOIN receptionniste r ON e.id = r.id
        WHERE e.id_branche = v_branch_id;
	ELSEIF v_emetteur = 'laboratoire' THEN
    
        -- Get the pat_id from the canaux table
        SELECT pat_id INTO v_pat_id FROM canaux WHERE id = v_canaux_id;
        
        -- Get the id_prs from the patient table
        SELECT id INTO v_id_prs FROM patient WHERE id = v_pat_id;
        
        -- Get the branch_id from the canaux table
        SELECT branch_id INTO v_branch_id FROM canaux WHERE id = v_canaux_id;
        
        -- Get the labo_name from the branch table
        SELECT laboratoire.nom INTO v_labo_name FROM branche
        INNER JOIN laboratoire ON branche.labo = laboratoire.id
        WHERE branche.id = v_branch_id;
        
        -- Create the notification content
        SET v_contenu = CONCAT('You have a new message from ', v_labo_name, '. Check your DM.');
        
        -- Insert the notification into the notification table
        INSERT INTO notification (date,contenu, id_prs,is_read) VALUES (NEW.date,v_contenu, v_id_prs,0);
        
 
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `conseille`
--

DROP TABLE IF EXISTS `conseille`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conseille` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conseille` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conseille`
--

LOCK TABLES `conseille` WRITE;
/*!40000 ALTER TABLE `conseille` DISABLE KEYS */;
INSERT INTO `conseille` VALUES (1,'Ensure you are fasting for at least 8 hours before the test.'),(2,'Ensure you are properly hydrated before the test.'),(3,'No special instructions.'),(4,'Avoid eating or drinking anything except water for 10-12 hours before the test.');
/*!40000 ALTER TABLE `conseille` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conseille_analyse`
--

DROP TABLE IF EXISTS `conseille_analyse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conseille_analyse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code_analyse` varchar(10) NOT NULL,
  `id_conseille` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `code_type_analyse_idx` (`code_analyse`),
  KEY `id_conseille_idx` (`id_conseille`),
  CONSTRAINT `code_type_analyse` FOREIGN KEY (`code_analyse`) REFERENCES `type_analyse` (`code`) ON DELETE CASCADE,
  CONSTRAINT `id_conseille` FOREIGN KEY (`id_conseille`) REFERENCES `conseille` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=428 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conseille_analyse`
--

LOCK TABLES `conseille_analyse` WRITE;
/*!40000 ALTER TABLE `conseille_analyse` DISABLE KEYS */;
INSERT INTO `conseille_analyse` VALUES (372,'BAA',1),(373,'BAA',2),(374,'BBMP',3),(375,'BBT',3),(376,'BCBC',4),(377,'BCMP',3),(387,'BCP',3),(388,'BCP',4),(389,'BDA',3),(390,'BDA',4),(391,'BESR',3),(396,'BESR',4),(397,'BF',3),(400,'BF',4),(402,'BHAT',3),(403,'BHAT',4),(404,'BHBSA',3),(405,'BHBSA',4),(406,'BHCA',3),(407,'BHCA',4),(408,'BHIV',3),(409,'BHIV',4),(410,'BHP',3),(411,'BHP',4),(412,'BIP',3),(413,'BIP',4),(414,'BLA',3),(415,'BLA',4),(416,'BLFT',3),(417,'BLFT',4),(418,'BLP',3),(419,'BLP',4),(420,'BTP',3),(421,'BTP',4),(422,'BTPHA',3),(423,'BTPHA',4),(424,'BVBL',3),(425,'BVBL',4),(426,'BVDL',3),(427,'BVDL',4);
/*!40000 ALTER TABLE `conseille_analyse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directeur`
--

DROP TABLE IF EXISTS `directeur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `directeur` (
  `id` bigint NOT NULL,
  `id_lab` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_der_lab_idx` (`id_lab`),
  KEY `id_per_der_idx` (`id`),
  CONSTRAINT `id_lab_der` FOREIGN KEY (`id_lab`) REFERENCES `laboratoire` (`id`) ON DELETE CASCADE,
  CONSTRAINT `id_per_der` FOREIGN KEY (`id`) REFERENCES `personne` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directeur`
--

LOCK TABLES `directeur` WRITE;
/*!40000 ALTER TABLE `directeur` DISABLE KEYS */;
INSERT INTO `directeur` VALUES (1000002,1001),(10000011,1009),(1003994888757,1010),(1000003298,1011);
/*!40000 ALTER TABLE `directeur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion`
--

DROP TABLE IF EXISTS `discussion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `emetteur` enum('infirmier','medcin_chef') DEFAULT NULL,
  `message` text,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_canaux` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_can_discussion_idx` (`id_canaux`),
  CONSTRAINT `id_can_discussion` FOREIGN KEY (`id_canaux`) REFERENCES `canaux_emp` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion`
--

LOCK TABLES `discussion` WRITE;
/*!40000 ALTER TABLE `discussion` DISABLE KEYS */;
INSERT INTO `discussion` VALUES (32,'medcin_chef','Hi','2023-06-09 23:14:52',27);
/*!40000 ALTER TABLE `discussion` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `discussion_insert_trigger` AFTER INSERT ON `discussion` FOR EACH ROW BEGIN
    DECLARE v_canaux_id, v_branch_id INT;
    DECLARE v_emetteur ENUM('infirmier', 'medcin_chef');
    DECLARE v_id_prs bigint;
   
    DECLARE id_med int;
    DECLARE id_inf int;
    DECLARE v_contenu TEXT;
    
    -- Get the values from the inserted row
    SET v_emetteur = NEW.emetteur;
    SET v_canaux_id = NEW.id_canaux;
    
    
    
    IF NEW.emetteur = 'medcin_chef' THEN
        
        
        SELECT id_prs INTO v_id_prs from employe where id = (
        SELECT id_inf FROM discussion d
		INNER JOIN canaux_emp cx ON d.id_canaux = cx.id
		WHERE d.id = NEW.id);
        
        
        set v_contenu =  'You received a new message from the nurse. Check your message.';
        INSERT INTO notification (date, contenu, id_prs) VALUES (NEW.date, v_contenu, v_id_prs);
        
	ELSEIF v_emetteur = 'infirmier' THEN
    
        SELECT id_prs INTO v_id_prs from employe where id = (
        SELECT id_med FROM discussion d
		INNER JOIN canaux_emp cx ON d.id_canaux = cx.id
		WHERE d.id = NEW.id);
        
        set v_contenu =  'You received a new message from the auditor. Check your message.';
        INSERT INTO notification (date,contenu, id_prs) VALUES (NEW.date,v_contenu, v_id_prs);
        
 
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (48,'accueill','notification'),(42,'admin','abonnement'),(8,'admin','admin'),(1,'admin','logentry'),(43,'admin','paymentlab'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(26,'directeur','branche'),(27,'directeur','clientlabo'),(28,'directeur','directeur'),(32,'directeur','employe'),(44,'directeur','evaluation'),(31,'directeur','infirmier'),(29,'directeur','laboratoire'),(33,'directeur','medecinchef'),(30,'directeur','prixanalyse'),(34,'directeur','receptionniste'),(45,'directeur','reclamation'),(35,'directeur','typeanalyse'),(36,'infirmier','analysechamp'),(46,'infirmier','canauxemp'),(47,'infirmier','discussion'),(37,'infirmier','resultat'),(38,'infirmier','tubeanalyse'),(9,'login','branche'),(12,'login','directeur'),(16,'login','employe'),(14,'login','infirmier'),(10,'login','laboratoire'),(13,'login','medecinchef'),(11,'login','patient'),(7,'login','personne'),(15,'login','receptionniste'),(39,'medecin_chef','pochesang'),(40,'medecin_chef','rapport'),(41,'medecin_chef','resultatrapportpdf'),(17,'patient','annulation'),(18,'patient','canaux'),(19,'patient','communication'),(20,'patient','conseille'),(21,'patient','conseilleanalyse'),(22,'patient','facture'),(23,'patient','payment'),(24,'patient','rendezvous'),(25,'patient','travailinfermier'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2023-04-18 00:42:06.364331'),(2,'auth','0001_initial','2023-04-18 00:42:09.192165'),(6,'contenttypes','0002_remove_content_type_name','2023-04-18 00:42:10.306862'),(7,'auth','0002_alter_permission_name_max_length','2023-04-18 00:42:10.567728'),(8,'auth','0003_alter_user_email_max_length','2023-04-18 00:42:10.663403'),(9,'auth','0004_alter_user_username_opts','2023-04-18 00:42:10.691818'),(10,'auth','0005_alter_user_last_login_null','2023-04-18 00:42:10.927764'),(11,'auth','0006_require_contenttypes_0002','2023-04-18 00:42:10.947706'),(12,'auth','0007_alter_validators_add_error_messages','2023-04-18 00:42:10.988684'),(13,'auth','0008_alter_user_username_max_length','2023-04-18 00:42:11.330020'),(14,'auth','0009_alter_user_last_name_max_length','2023-04-18 00:42:11.590445'),(15,'auth','0010_alter_group_name_max_length','2023-04-18 00:42:11.670220'),(16,'auth','0011_update_proxy_permissions','2023-04-18 00:42:11.701177'),(17,'auth','0012_alter_user_first_name_max_length','2023-04-18 00:42:12.012176'),(18,'login','0001_initial','2023-04-18 00:42:12.052869'),(19,'sessions','0001_initial','2023-04-18 00:42:12.321868'),(20,'admin','0001_initial','2023-06-01 18:13:00.527286'),(21,'login','0002_branche_directeur_employe_laboratoire_patient_and_more','2023-06-01 18:13:00.543214'),(22,'directeur','0001_initial','2023-06-01 18:13:00.569254'),(23,'infirmier','0001_initial','2023-06-01 18:13:00.580192'),(24,'medecin_chef','0001_initial','2023-06-01 18:13:00.588014'),(25,'patient','0001_initial','2023-06-01 18:13:00.602974'),(26,'admin','0002_alter_admin_options','2023-06-01 22:55:32.084064'),(27,'directeur','0002_evaluation_reclamation','2023-06-06 18:30:33.333640'),(28,'infirmier','0002_canauxemp_discussion','2023-06-06 18:30:33.345723'),(29,'login','0003_delete_directeur','2023-06-06 18:30:33.353699'),(30,'accueill','0001_initial','2023-06-07 23:04:00.865328');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('00enjn59yeyw1v43gzb77rnjytzeh8nr','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q83S1:33aa0LMJPff3nDKHB6CZYPGrXXFavqadVUj7xcAX1Vo','2023-06-24 18:36:37.452703'),('00n8e8djq7yktlx0w9yluw28asd0pta7','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pzmeL:k2sp-J4Ke0BqGNbIl7SFZrG37u792HVHyPp0Ev7rwAk','2023-06-01 23:03:09.873577'),('05fcpm1s5h9clpix34tsla71alsvdvay','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5sC5:DOJjt34Lt9N5-LICbr1TJJwUGzgkuRe7SFAKYts1WCM','2023-06-18 18:11:09.438366'),('0ixzpwomkd6wfv8it2ubm56paivxm20k','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1ptzOu:5eks-ESmQ76oMk8KE19hLUnGT-ILPnqUSIJY824iGi4','2023-05-16 23:27:16.603399'),('0l33jxez36rlkhak5f416rcqr73vatmp','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0t1D:0KJKAdvfEc7apcdm_FWL6CdEgRiK5IREYF7M-PN4bkY','2023-06-05 00:03:19.258372'),('0ruvf5cvm7nvx1x67pe04nr9kf0btca4','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1pyJiF:2T-epRFTG6NVUPoszI2j6I6RU8YSWz-zvpBzQLKsbB4','2023-05-28 21:57:07.663530'),('0sbb62wr2obvd07y8bfeq7700hej4cu5','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5qrJ:emYlQU-E9MLwsrpCTvg84QR1PK2QslScyA2SGnnDodM','2023-06-18 16:45:37.233359'),('0u67waro8i2xysou2av6mizhnwds9al7','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q88bd:CikCLriGHNL2bBtNHPurMSeUnjw2I2O6UWfOqiMMYGQ','2023-06-25 00:06:53.871851'),('0usd1wc4mygnk481wti0dz0nnw0l3d89','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0Ate:Tre4nFsSxfoV-7BYlwwS8_0CMSV9u5csCipSeBzJwI8','2023-06-03 00:56:34.535750'),('0ve7ayh3j9mf19934vaabdwipqcc2rd0','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1q68Sd:At5cgeFvT4xE0ehkLA8EQYmnhqTDJMvd2MZQ4P--H-o','2023-06-19 11:33:19.744777'),('0wx62xrsvcbpi0ulajm8yazhj38mwopb','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1puD6C:pv0KGp3cXaU5UXb7AVB5aWWbHWiepLrvlVDwO_aTtY0','2023-05-17 14:04:52.287397'),('16bge80xoyh2wd9uspcthj9kmhfssjqp','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1pyg8S:2HHpTbD_ifwzj-HfItr3swh5r-7vJrdTau8antdywl8','2023-05-29 21:53:40.689850'),('19fdfkjqvu09rplnn1bxzn3n4jfkdvx0','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5otU:RJop8XSpaErysAYPVebxIBpqWm4WWn5ExtJyr5bCfe8','2023-06-18 14:39:44.853367'),('1jy2xqgfsops189htob2mci7rc7chw0v','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q1cgM:QAxYcL0wdpSvlWnkDRK_4tuyrcG7vPbITLj0FQzrV9c','2023-06-07 00:48:50.183774'),('1op0zaqi2yljqivu5hutoy7le10kdw9o','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q58Wc:j3J_roIFHJJ8oCqki11q7AmYFEjF3IY0km8z2fKzP5Y','2023-06-16 17:25:18.940996'),('1q6v6dw2j9al0718mcsroyu34hrmeajo','e30:1pr6LG:1B--WU5Ap15vI7XWRl6ixRc2sAOu2NpKR2Q-lLr6mYQ','2023-05-09 00:15:34.563501'),('1wahiou9gqkw9l2j02xxqch6faxqyfcm','.eJyrVopPLC3JiC8tTi2Kz0xRslIyVNJBFktKTM5OzQNJJKbkZubpQfnFeo4grhNUFkVLRmJxBlC9Ui0ADuAg3A:1q8GTJ:z7J1QffHebs3ETdYuh1lOH4GCfqhn1zBEupMjIUT_bA','2023-06-25 08:30:49.358989'),('1z4t1wilbeik4x3asap5gslnxzoljuyi','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1q1yNi:aHcQxw93ctWz45anoO1Sqez74sFlE-YFNYPg4tXQYJ0','2023-06-07 23:59:02.229686'),('1zo1ybf4g40pbzs0e6eci05x1da2hzax','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1q7qUL:IuY2IJvuG0HO8dBxlxQzcc-8tp9Xq_NUskFemGI0M4A','2023-06-24 04:46:09.012757'),('20mmr6nfykeuzpbbjdw14ld8iu5nhycp','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7Lnh:z_gMul0W2KuPasXdrfy5GqzNYRwrv52H3ck_K0_R-G0','2023-06-22 20:00:05.836318'),('23rgqopor5ddvscjxtq9toadnxke4gny','.eJxVjEEOwiAQRe_C2jQDFGRcegJvQAZmkEZDk2JXxrsbki70737e-_-tIu2vGvcuW1xYXZSGEadOvyRRfkgb-LnelzYdvU832framlwP4W9VqdfxeKagPTqbGN1MiBmzlwDCRjxzACAoHpwOxUkuhinJ7C3OaCEba9XnCxOCNNE:1q7h1N:HbaHcPIVQcCe8mhQwxf202HiNo8nDZlfrKtACSEHuZ8','2023-06-23 18:39:37.015206'),('26r5zjlkejvz8tuwxvf7g1x5xu40shlj','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q7i3d:w-Wdqqo_PCJalf2VXXRkyS1w9eDkS8vjkM9QqkhFRw0','2023-06-23 19:46:01.721132'),('2b6qofq7eszkpdxh5x62baywq7cf9zrd','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1prSS7:15w1NKUksyzgb3jd6uWdV6Tyajum95DLR3E5GkFBoG8','2023-05-09 23:52:07.231389'),('2c8x28aswzh7fle83u0ssdezmfio805l','.eJxVi0sOwjAMBe_iNaqajxOHJSfgBpHjJqQCpVJDV4i7Q6Uu4O2eZuYFkbdnjVvPa5wnOIMa9yGcfkliuee248dym9tw_D5c89qX1vLlEP6qyr1-E2YjyhOSQ0JneOLEQchyooSFzOi0IuFgUIgkoyVddCjFa2uN9QreHxV1NH0:1q8NJH:mgXaxpIgIfJFx7NohwlpP_eQpa2WFBidylBmEtIb1Yc','2023-06-25 15:48:55.912230'),('2hq7gljolfqh7usndmhk9dy7ub5mxmod','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pvplh:M46Tn9zjZjAsLp290iARmwPsRO7IyhBdvYA4X5iYFfk','2023-05-22 01:34:25.966905'),('2jabujo7l8uhqarmk93c4rpf0ksvb704','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7mu5:OnMyq0i5knSjtPpgomk84o-5tSeqEXD7QR1OlOhXNOU','2023-06-24 00:56:29.096831'),('2n1udeb37ctcbohq33skmyjts9xu5740','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pvRp1:HtzIGTTAVHaWvsdtoeGsz8cGhCHO7BVpyrtnAnEygs4','2023-05-21 00:00:15.322914'),('2vmgpdfn6v6qok90uhy8m0vr8wnwiovt','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q09eO:SLLsU5Ca-3lSsJXGAhU6j63BvRZF5qOkASgcDH5vUpo','2023-06-02 23:36:44.162679'),('2xw7it79oskgqzp6x0cde0kv7wn7pcz1','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1pvRRn:kCkLP8T8bOP0HgCu5tY4FUpy7GJwwKPLgzdC6HsKgnY','2023-05-20 23:36:15.876744'),('30wwqjorfo15arf8g9kt4s0f322w2oo8','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q6q6Y:J86Q-YtwlUUCq78xco49ngc1_11h9GbzRQHddyxN8vI','2023-06-21 10:09:26.468818'),('32qq0h1ypz4pguil72yi6il4o8ewjb16','e30:1q4rPE:DaBJorWpwEx9tKo-I6hHmz0MUjz0s1EU9xr1k3wJeNA','2023-06-15 23:08:32.148941'),('3b60yhbdhf5xh9tyvfestsbc1wrt4s80','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1q8P9V:VO8z5-gQLi5fgPLJQUSC_BT8DBxbV2kTVLGXPuhKAvU','2023-06-25 17:46:57.130276'),('3k19b4045ujfgtkl6w7mur71svjw1fl3','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q2ho6:VYqoKIsPHf_Y1pw3_X1ao1RkfcBCwt3QIcijXvt690g','2023-06-10 00:29:18.379821'),('3nfefye89mhk8wccrdtitbksvvhx4o90','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q2hPd:qoS0-56VD8eCTcI9pO9rGQYyv0jhTM0dvXkt3ruFzIM','2023-06-10 00:04:01.889933'),('3rh9te4k9wb02b5ownd7uot0ldx8gbrb','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q2hs5:buFN2AW_-wZIYLGP5ti8aN1nsfAJ8mUgehd5iHWNRJg','2023-06-10 00:33:25.464480'),('40l1k5c31m1g2qf648elzzqpx8k5jhpp','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7K6x:SBhHtIMxJxwO49NUGD30eq8em6M0F6qQjHEAlztQKTE','2023-06-22 18:11:51.522154'),('43b1uou3pjswf7rqqzuhnqzhykvghdk6','e30:1pu28u:fBmhqGyxELQuQaWPZIDbMgFvgULUBQTz1tModFL6nFI','2023-05-17 02:22:56.341114'),('4elg00771e0an7tasf7ej485z85cnp0s','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0VJE:a5GqW9GHg9mICXLYBkJIdmsULZBr0WejXheSa8XgxTE','2023-06-03 22:44:20.431058'),('4h6yqmv8bm32dtb7hux7mofn568fifm2','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q3dhc:DRMiorpvTde5BrpU8RDLkMUwbL5faK7nT5HPHVKgGw4','2023-06-12 14:18:28.097545'),('4pk95671951w56pru0ctpss0t4vywys0','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1pyZ0i:QyH7usjGjBsoAgjK7Inaw8E7a2aiNwv17aZxRpH1Ds8','2023-05-29 14:17:12.388145'),('50fuki08ah6bac4ty4t7ygy4kq1hzogu','.eJxVjDsKwzAQRO-iOhhr9d2UOUFuINbSKjIJMlh2FXL3IHBhTze8N_MVgfathL3xGuYk7kKOPSBuZzJRfHPt-LO85jocvQ1PXttSKz8O4bIq1Ep_9EjInD0CmhSNUkZpJnASrExeoyNrNUyg9ejBENoIRroMxMplieL3B_CiM7s:1q87tT:pvXer14xZpq-0QzL00FsDZsBlgqMXBmYmAlhysaTOyw','2023-06-24 23:21:15.117717'),('55nrx35f6j62cy9szv8997w3tk2xvdmc','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q04xS:gVCRd06ZXQkfyLlogeNcIYyRhGuk1Tdo7aqCdjeJUCg','2023-06-02 18:36:06.946595'),('59z49mqairfzv4aj7dyuw7tqxf1ziq8j','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pwjga:Ic-eEauVe5HNpG0j9VQq9RdppGNgvjX1p4eqRF4vhRA','2023-05-24 13:16:52.559054'),('5gki4l0mt9q2uhgcb3vf5kaualv8tpo4','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5qon:ga50w1qBTVzfSCZ-0Jz0OvtzZsJOb_wyfkq0zrxFehE','2023-06-18 16:43:01.609025'),('5ymm7ruurp3zokzelwjzm7cip9zzmtp2','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pux4t:7-qFLznV7cPARsYOsi3SsGUO60HJpzP9IaD0asMieJI','2023-05-19 15:10:35.912176'),('641zg1sb9ehojuosg9tll9hjfxdgnk6v','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0w3V:WPnqdcNya5vmsN_wgedMaEEzXMOuR8gSLt9rN57UkpU','2023-06-05 03:17:53.487625'),('6kemvcb3ywzdb74h4pgkvlw7d6kz32cl','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q8Lgi:qXKODleRjg9QuyX-ba-C5pzX0yy0mPdNoacoTCi50g8','2023-06-25 14:05:00.238138'),('6npogtqekmzq2r9s0wed9yb0eh5exklg','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q1bzg:IRYkIirxmui7cBhIq6cXYO7ZXcK0YHYXSF3OOToFoEo','2023-06-07 00:04:44.089600'),('6xfu3b73lw5039z6pjfoqhh1hsjo2zxx','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q3oTD:rv3FR84jSgwCp1WkHcR0e0sxZqa5gPvOIyVVO9ofPAY','2023-06-13 01:48:19.269820'),('6yhzx0zencc9h8rjymt4k1e7yz8wji3x','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7JgI:2Mwh78udLMY0vUAzPjNVr75N8q0psQD6R6HLOFZnE9g','2023-06-22 17:44:18.387189'),('70sp453dwnaromsdad85sv4ij1oql2rh','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0tei:hTJrK8QBsGvrIS0KladedZJH9SG2cZVrerNJCDQCrcc','2023-06-05 00:44:08.696143'),('77ne3f3qzlsj6vxrq96xe5kiycai1gn5','.eJxVjEEOwiAQRe_C2jQDFGRcegJvQAZmkEZDk2JXxrsbki70737e-_-tIu2vGvcuW1xYXZSGEadOvyRRfkgb-LnelzYdvU832framlwP4W9VqdfxeKagPTqbGN1MiBmzlwDCRjxzACAoHpwOxUkuhinJ7C3OaCEba9XnCxOCNNE:1q7pKX:oNcgwCkieGKEPYbCVHLY4G_aBThwhh1Y5qYpbhNIQpo','2023-06-24 03:31:57.194976'),('7a3c274c97ymibhnpy48kax0p01snion','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q2hKM:jKHJML5ddEC77oUyTTktSG1Pbq0wDyACZxGh05W0n50','2023-06-09 23:58:34.756389'),('7gcodtp0y9x338x6enifegrqe5mj6xz4','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q1bts:bZxseW7hom-RoipdeLu5SxJCosHCYhJ--mWgluqlg9A','2023-06-06 23:58:44.426256'),('7js5tpb4pwzq1zvgfgcnb5a6rbhu7zqx','e30:1q4rgI:e_K_5tVWmn8jmKLnb5lcL7RONZYv79JsJ88avtGFAp8','2023-06-15 23:26:10.533376'),('7xvp62rci7nna4bcmofnkgrber845ya3','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pv4ZX:-p34SqZQbB5vlOGXf5yDT8JiL4XmMjjdF2_YkVdsqvg','2023-05-19 23:10:43.060297'),('7xzn75310hddu5u9ex92vfc9kedcv5ms','e30:1q58YQ:LMXZpYazaaXF9W9P3G8XipQSFRyllBDCnsohT1ViIVU','2023-06-16 17:27:10.945484'),('89dclyr6q26ztn0dx4y86j5tt0yvr1nn','.eJxVi0EOwiAQAP_C2TS7boHFoy_wBwS6rDQamhR7Mv5dTXrQ42Rmniam7VHj1ssaZzEngwAUwsjM3npz-PU5TbfSvtF9uc5t2LkPl7L2pbVy3oO_q6ZeP4sjKkdUTwLWgdjJixTJoiAaNOWgjjLTmJ0nTJyRGa1DUkXvEoB5vQEiLjaD:1q7tdv:r4VZSz-r36ZeM37FQlkHfbfU3gGhY7PwOhQwYvGuO18','2023-06-24 08:08:15.260736'),('8h0ytw5z097tawzx5qyz0px0l68nih6d','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q1EMk:GvrKrXAJe7E6PflgacC_iQHqGUoB_ZT8eGqqbXuQ0tw','2023-06-05 22:50:58.153750'),('8j0oar8qfr8gqbstx45nmj9p68b55ddt','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1pz5Oq:mUCV0tx6wnOP2blAoSV_t8PCiFAYOv7pQR2u0lSbrPo','2023-05-31 00:52:16.584284'),('8p6nuwo3rk8xkafbmylsl2lz66j5jpvq','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q1GR5:XJhsRtfcoxZ74cB3HP3fHk0lUoOSMX8uVmmsVb5X2F4','2023-06-06 01:03:35.384946'),('8qvgq5bav482pvd6yolqkcbim8y1xax0','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7fa7:uiKuupuxqiQNmDjSIr2XHKN09PMZJCePd3HRojz7Tp4','2023-06-23 17:07:23.407383'),('8rjyt28bm207coy8pz87ukunaawn0rxj','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q2hUe:365bwZQwDyWtV8aJzE7b8z5ch431d-dy-19ZjVOXOHA','2023-06-10 00:09:12.245976'),('8tnyl6sgyfdfo3ef3hdpjppn077e42pi','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1pyXWh:HH2tZuf32bFnuEMoRq5dYQthnZAwvDJ9gbWMF_eRZvk','2023-05-29 12:42:07.716986'),('92gg26e3v2ooobp6bcekm5j01hgc4n6y','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0Yhs:FWDMmdj0HS1bXZPH4XD5kxeUVRtwXrwB7btb_aPPKm0','2023-06-04 02:22:00.804626'),('93wyzw3d5vekjc3a1a127n9kgik1xrog','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1pz4eh:EIFHgKA4st89UgKLUR5KkSocNvuUpzFcFi7FEZoYssM','2023-05-31 00:04:35.996109'),('9c1whvxueowzq2kl7y68oixzt803vvec','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q3dM3:zs0IMKoMrgZqPF7c8v4wX0TBptM668JppbwdggPM_o8','2023-06-12 13:56:11.634786'),('9g58t4c3yopr0g1pnykq25cvkhjv88xi','e30:1q7stB:BydlDnywuWxsmS2kfZF2Kv7WFMCdAF5tHlbzWMDabAc','2023-06-24 07:19:57.377974'),('9h6gvv6zxizsoa2kqv4tdgmhjyy5tjgi','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q01Xb:AAKoe36cwARYbsiX6Ek6inM5EV55VoXtdp_3-jId_ZM','2023-06-02 14:57:11.995895'),('9pbaeuzsgbvp4fa25z18dsl4g6tx8men','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q69ef:DP0P0pIfftoLnZ6m2Oucgcvj6D8cBXVltetszXyKj2I','2023-06-19 12:49:49.762801'),('9ppyjmh83pumprnom8luknqow59s5jlm','.eJxVjEEOwiAQRe_C2jQDFGRcegJvQAZmkEZDk2JXxrsbki70737e-_-tIu2vGvcuW1xYXZSGEadOvyRRfkgb-LnelzYdvU832framlwP4W9VqdfxeKagPTqbGN1MiBmzlwDCRjxzACAoHpwOxUkuhinJ7C3OaCEba9XnCxOCNNE:1q7pwg:CHxbMFpkov5camIpB4R4m_EZ8LaLOhxptNW5DSAU0r4','2023-06-24 04:11:22.250080'),('aal0b51jdg6q9zj8d2jlesnihtdhnarj','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q2Kyc:4mBSy840049PC--zvgdhZZ7vZzB4893iwsHiPq-b_Ww','2023-06-09 00:06:38.186971'),('agal2fi5x4celklewbf1l5l4zp4nszul','e30:1q4rPN:jSChK2L--D-TGRq1U2ls-6V-dUdjnLBjYP-CJPBcIHg','2023-06-15 23:08:41.205847'),('ak3dxr6pnkcg9w9mf9er2tr01ddhi43j','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1ps66f:jkKajdjHT1NLz0SUqjOX5T0Kmm8bsXeTSTA6AxN780c','2023-05-11 18:12:37.999885'),('amt2lky5d5vixekeuoeo9b9af5yvzscd','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0fr5:Cli-VNUtKkI-LbpYJ1zAS_-fZ7Nbrc_IwDXjIpPwWnk','2023-06-04 09:59:59.782174'),('asyu5073cd2w2togmeupdffhy92ea7y0','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7o6x:4KD9e5mv1viCIjSUSm8yhWmrdaYqWXNID6nn7IMFveA','2023-06-24 02:13:51.524734'),('auth0jifh7o1e3fdqkxwzddb1fy9ol37','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q2BxZ:bo9FhdsmKkaamQHMTlZs1lKsFGTOLIEZ_DkX1JXiBMw','2023-06-08 14:28:57.230436'),('b3uj7dqe8qcfzqcpc603oww9a1b77ffb','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3oLA:oyvFCrV_3BOXd9qaJ2_hanbeDVxj31HhIgkbNXAJbq8','2023-06-13 01:40:00.392240'),('b72y5sdk8pkfaoc0k1k8xj81fu848auy','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pv07E:h81sKrkQJaycTQloxSrs2yPIurSrMa1SkAXXIpaCMQI','2023-05-19 18:25:12.543513'),('b9eu3qnown20lgr144oglptgh6fwxo5o','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5Z6S:4RKtlpsXRbMY8NhVAzKRjSAudurx5WIeVTGMUhRKfSo','2023-06-17 21:48:04.613135'),('bckaikccewkajovz5ccar2j860q3hxi2','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q3RD5:N-zGOyrW0nYImSgu4NioNqq-hTq9iOid3O7iYuyOsEY','2023-06-12 00:58:07.162927'),('bco221r4z4eumnleel9q5y372pidsuax','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0A7j:x2htkwRKI4a8YV41QYsLJEZtLwaaKDl6TsgH_1kfJS8','2023-06-03 00:07:03.261502'),('c17uzd4p270d9ubhfno6wtkqp5o7eghx','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5bW7:hvtNJ2YWgJu1igIr2IvbIgoz3ADFS2RmsFemWrO4Tyg','2023-06-18 00:22:43.661669'),('c6ebbmpqofxljy412qyfnlml97wzarmc','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3od6:I01zPfuoArxSS1sC99cc_ShSuHx48CPXrI3ypGz0EfY','2023-06-13 01:58:32.936906'),('c8he4ulklekc29ek2p3vx60ool3cfg1l','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q7pHC:0ejvD60hcT-WwzwJJg2Hv0gP_SQeiRlerjAVUpzo0kk','2023-06-24 03:28:30.335981'),('ccr3mjn9nk35gasqs0ch34ejb020njpc','e30:1q4qwj:hnTHlD3o05ZeakjSLUndP9MbH-PuPcTlAW9vFHbVtpU','2023-06-15 22:39:05.525657'),('ch2ydgvide9m48apdjkh479uwjvq3d4j','e30:1q6aVS:9r9-jAz0IRNIzdLGkG4GvW5Pv-2YJGFcJPWJxiTVGa4','2023-06-20 17:30:06.326594'),('cv3nkwan86zi7b8anfzqzxy2t53v77oh','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q6iw1:Q5dlEFUk1boC75nEYeQEM9k1jz99hP2OqjtzfSSdw2Y','2023-06-21 02:30:05.853347'),('cz3wpteikg49we3uqq3rqoph7iaqvohr','.eJxVjEEOwiAQRe_C2jQDFGRcegJvQAZmkEZDk2JXxrsbki70737e-_-tIu2vGvcuW1xYXZSGEadOvyRRfkgb-LnelzYdvU832framlwP4W9VqdfxeKagPTqbGN1MiBmzlwDCRjxzACAoHpwOxUkuhinJ7C3OaCEba9XnCxOCNNE:1q7e36:sWahztIT-UZKk5NFyHhUSFbOrx-N8nKLCAV1vur6_io','2023-06-23 15:29:12.198846'),('d7zpb863jpqqzv5ye7ko5qgtj4c7coxx','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7J48:CT8juTspGRmcEXeI66qGJ2yn1GOSk6_R6RFqTonhAjc','2023-06-22 17:04:52.139563'),('dib25p4mz1nj3kdjrm6udhfqlu5bgx34','e30:1q7ssp:AS2T_ujXtzkUS4y9kgNZb-sjwmXpexbAx9sakJ2wbF8','2023-06-24 07:19:35.343960'),('dkybc4ff71jk2j5nx0qiasrp42nnm351','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q7idQ:fNYVhTUOYv45caZHseD1LPQRau34UyfrDvXaoTUXpS0','2023-06-23 20:23:00.334542'),('dnww81re8pxl4kr92bg4wc1q0w55vg78','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q3d3L:fiIEpF5sUMWaO3213I8UFuy5Wq2SrAwwIGBcsf7Ccdk','2023-06-12 13:36:51.684889'),('dx207emxt5x4fuxdun7g3n2a4f5c75mw','e30:1pr64s:WugmpatKfSHQSXMcHUkClI1-O5uODc86_kAmudhgy7w','2023-05-08 23:58:38.622206'),('e151ztu46175j2f2h2egz5ytypj9z4ij','e30:1q4qwx:Y6d3bGrgrrPSEuUxLPAmKWMoxvKIHiTUC66bzcfKVMw','2023-06-15 22:39:19.803145'),('e4ibtwanug1rlwa47255bo6pwz3bbifs','.eJxVi00OwiAQRu_C2jQDQ_lx6Qm8AQFmkEZDk9KujHe3TbrQb_flvfcWIW5rDVvnJUwkrkLCMVRKXH5ZivnJ7RBe82Nqw_n7cOelz63x7RT-qhp73RNtcmZTCGTM2XqFkvRIEZAVKCAnPSuNEaxLbHAnxYLzhbFQwjFb8fkCaDw1rQ:1q7rrL:M6JlKqzk3UeI-nU9ebusuoC23SxbyBNLVp9_EmzGTBM','2023-06-24 06:13:59.689914'),('edkwa37qp388ipgdozgakr3nt5eciq3n','.eJxVi00KwjAQRu-StZT8jJPEpSfwBmGSGU1RUmjalXh3q3Sh8G0e33tPlWhdalq7zGlkdVImQPxOHX6_TOUu7SM8ptvYhp37cJG5T63JeRf-qkq9bsmRss9EEcCB3Uo0IRZmLtmj9q44bXwMNjMjBYNwxSKiQRyaEq1G9XoDjRo1rg:1q7gBE:dGbVi134JCQAZQYV1aU1NQwffuwVrGTYYTpx_DbTBc0','2023-06-23 17:45:44.237619'),('eftne8t35boai8xc1kyreyu8yt0w5tpa','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1pzefo:1srBYmbriJYvpOUIrZ00RrblrktudnvfV1gxafcijP0','2023-06-01 14:32:08.353675'),('enr2xbq05e2xsnwkl57s24cik59ishtu','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5o1b:0sp1borOgWEBbrmNVm8t2ha5Gn3ub0bhAX4Wre0hZ-A','2023-06-18 13:44:03.313388'),('esra61yko2jwcxck0g8t0y7y899js2db','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1ptzb4:i_TGLHlD6rpDInPvN6pbKEJ4xgHNYo-8rRn-S3M2ICU','2023-05-16 23:39:50.597928'),('ev5t4hcu54eebq5aaxlxn2jp3mjawqwp','e30:1pr62m:mPAMQjlrBg-g1ooQxFF7-zP24x8xT2pzCQBaFC5ol14','2023-05-08 23:56:28.765128'),('ewfma8ejwpzkmyy65jbxf9yg9zi2lj7y','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0fSk:Sa5yC5lxLuv4-MFD71NOeJgu2OmjU2yBfb7cLzMwgxg','2023-06-04 09:34:50.823929'),('f056cd8i3zcpte8uyjl7m8pjrf2i8xsr','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q7ptd:Ino6eCazu3e9aX6trhpQlDqGKBCpU9EnYA0j7ViB-88','2023-06-24 04:08:13.898112'),('f39cmlzok5flwbdbhrxojwn1pqe50m4k','e30:1powMO:sSG2-BFjs7YZ62i_KzGJrygX-ReyvGhQSD7NPeWyPLU','2023-05-03 01:11:48.943190'),('f4bc6nt9i06q762154uaxktyofl8mqza','e30:1q4rIJ:kljyMux-eKb7Yrn1TmNf3-x5PXnpE6MjZq6hO8LsAYk','2023-06-15 23:01:23.949898'),('f6wg7d038ibp0x9nbdj9hkhtr08vta3z','e30:1q4rOn:qpsbAcJ47C9nK6HpccjnkgwMm10MLwYoZ4PXovAA9-E','2023-06-15 23:08:05.913098'),('fjspbhrenlueabxd70donaey12w1o4sk','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q71f9:bzxATwkYNcJukRzFguZ9zkj34k1c836-12Tx1_M8C18','2023-06-21 22:29:55.195915'),('flos9c6tofhz0fd2wm7tx5tf99uydhpe','.eJxVjDsKwzAQRO-iOhhr9d2UOUFuINbSKjIJMlh2FXL3IHBhTze8N_MVgfathL3xGuYk7kKOPSBuZzJRfHPt-LO85jocvQ1PXttSKz8O4bIq1Ep_9EjInD0CmhSNUkZpJnASrExeoyNrNUyg9ejBENoIRroMxMplieL3B_CiM7s:1q881A:W-vB8ULTNT_UI8kHPV_veNFGKGF8QZHmC3FVC_KheWk','2023-06-24 23:29:12.472391'),('fxz9jq0thrgof3g1u77wb32qcs7i5gtm','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q752D:VIWxooartr8i-Lj6Rai6WuXWjOnhRQ1I_zE0tpiNc1A','2023-06-22 02:05:57.321870'),('g2zrqoogp1xapb4ja36kvg2du8dn33ez','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q3dFx:guQESVe2-kVodO1TsqOxVA3CaHxlfVzfblK6T_DQNdg','2023-06-12 13:49:53.138204'),('g3ybvb0bof6iidxszupy4q5v3qst417t','e30:1q4rXD:VouIBSCcvnjrF2qPxMnfmDcgawaRi1uMLLc4zEMrhiU','2023-06-15 23:16:47.883837'),('g5yi2myapct1ifiyabkpqi1vden7iw7n','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1ptGaa:6pm_JksRdtQPCzbs6K39DLlQSr4t6Y10eq3agzgBpYA','2023-05-14 23:36:20.037962'),('g73vf6gckgdcpn7y86hrkx2g9inz8mom','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1pyKlS:t75mRlG4uBSf5DfDWnaNbDvpm8da7c1p5H6i5U4OIRg','2023-05-28 23:04:30.417648'),('gc3qgmns49x9ivu6axmwhowbyuxlj5a6','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3n0G:ZZ96iLm6B1agwUT0UGCSBiSZxdju4dOWTRn9kWLYm1M','2023-06-13 00:14:20.466166'),('gf2gap1u5y99czm1l9pgxar8vtexnmng','e30:1q4mt0:iQaIdDc3XLtf7eEYDAF6il85pe8z6jboXlULxrH-nqM','2023-06-15 18:18:58.506678'),('gp59h3xbzr02401ay1536izvsah7cuzl','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1pxya6:1J1HKWAydiCFo2Urx3BtE9mbrIU6O49rbSJjPA3tCTg','2023-05-27 23:23:18.625735'),('grqrucw7xkvwtuomruux04kczfp1zqad','.eJxVi0sOwjAMBe_iNaqajxOHJSfgBpHjJqQCpVJDV4i7Q6Uu4O2eZuYFkbdnjVvPa5wnOIMa9yGcfkliuee248dym9tw_D5c89qX1vLlEP6qyr1-E2YjyhOSQ0JneOLEQchyooSFzOi0IuFgUIgkoyVddCjFa2uN9QreHxV1NH0:1q8GWV:lkbIe4gpWYDm9kjlh-w6GdIJgIZyJGHN17-3rkQNK7U','2023-06-25 08:34:07.389563'),('h0nwwhxpontmibyprepw83ihzqo6d67c','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0rYx:RpMs12cQbS1H88nkWfWYGIysSEn1cQMgdGyGLloNJNU','2023-06-04 22:30:03.174688'),('hampx1li1kpmoej3vda21jvsf5uxdk6j','e30:1potu0:lVgk26R7sSbDhK-Ap8A_urcLv5_HmzmmF-ViFlVsAYs','2023-05-02 22:34:20.470098'),('hctwilzfbnapfwfgx8q3kmxd76yyjov9','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q58lN:WODYbPpcTejdW0BLvbxxTB-hoWHin4qahjzaGX63bqs','2023-06-16 17:40:33.849057'),('hdkj1pb0yv12a0904t4nloj3jl02305r','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q7oHk:4eJkvDDdoxijF8J82qvdZgIfEjY43rZ9sBEVh5a6WGE','2023-06-24 02:25:00.347253'),('he35ebbebmtij7hxtb8rgc3gepytye4r','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5qHk:YqZXeX8-08J6oWKBmkduGskUDiexQQmgGdXGSN8UcZg','2023-06-18 16:08:52.252425'),('hhu9mrtvww9oel555r6xtvk4xs4j8soo','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3obN:g_lCpQQ7UWymuFuFpBGTlOYj8qHeW4kcobc2dpPAxNI','2023-06-13 01:56:45.842922'),('hrgsqum1sdyzm0y7extojkplgyrf9s8w','e30:1q4r2o:NpbhXTnIL31ulu_4IvkiHfrdvSBgbE8Q6tj0n7W13ps','2023-06-15 22:45:22.601647'),('i2ymi9fh31iqahhruun893w4edkwqv6e','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0AQF:XXJ4pxxFQTqHrp7FL7ST6y_5M69p1qG8FX4UuVVM61k','2023-06-03 00:26:11.788383'),('i3t8xulx2cpa9uwxp8vly7wjh5eb5vrc','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q1EQJ:0iF8bWt7-C2vK16z_V7EOOXuAy4nXEwJOUSAeL5L8YU','2023-06-05 22:54:39.344650'),('i5v1zrz877mhy7ud1tc8tjt323u7667e','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3oQc:FbdqLqO4M1Lg1e3d34BMS9vAXCcRTUZtGGuN079GWXM','2023-06-13 01:45:38.827139'),('i6ucr9r9i7ccj6fp5ul576wr69fzv4ip','e30:1q7QHz:u__PVHbHWOhBpcPVIRrx_fyHN4F38Bp71_shjJGGeHI','2023-06-23 00:47:39.990218'),('i9fl2npanxibdg3r6uifv97fu1qppaj8','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3of9:rQlHrA3W5tODiGWPEEGmd7_hCHIxAV4GSUMfi06e7ag','2023-06-13 02:00:39.269216'),('icr4ukvt7dk5u2mafm81muy8v0u09qci','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q3oCH:T_Fg1U4Bhx7-wXNsjk7SGQvZbghtgxHVxmaUNiABjww','2023-06-13 01:30:49.829829'),('ifgcc8yz903sa24y3z7416nzx22q63kv','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5rym:-sgG2JQste0tVeTu1XQsXUbkV_fFdfCJj2-ki0gSOe0','2023-06-18 17:57:24.890993'),('ikkwfurro37h4bj1q6ol7givzn8cd9ay','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0Yf2:33LntVxVLI_sTGQidVqTNkfTOcqZ5KoKkuDrFxdEW2E','2023-06-04 02:19:04.612886'),('ilabjyzpvksq9ruepcduuj928kne4mb3','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3ocU:t75ZDlRW-L1TMNd9Ux-IeRORJW6Rfc_nSaVpXV2Bm1s','2023-06-13 01:57:54.312703'),('iotn9omcpm01ixv8txciwrcvthkwyz3i','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q2iNt:grGOKH3d0kKUpTlLniVW7fzz0XE8w8PZSsDuhRdWGaE','2023-06-10 01:06:17.743697'),('j80cqyo9ywplvgkn959nogdijif9sqkb','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q2hf8:hOnM19B5oxt3vx_qkNeLTXYznYjCrGt35Yj_EdhRFDE','2023-06-10 00:20:02.312859'),('j8btkrfurzyyqubxpoik79wmvf9zzj2r','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5owf:lSmiUjPp6JkF8Q6w-luTk9xU1BVf4IsQZw283LZTmfM','2023-06-18 14:43:01.621918'),('jlqubqlo3o0s2ui9cbasnn3yxa0rttpc','e30:1pr5oW:EA7HoXohrJyJuuJ8IA-wr8E6wMThWJuVCWEGibvUg3c','2023-05-08 23:41:44.780809'),('jzsd9wl2vyx23r494v64m4q5oedvpj7g','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q3RAy:kkBAnixZNATSgekB-TkGQSeBJtTNERH2Qbt-CMylZuc','2023-06-12 00:55:56.025189'),('k2kdcz3j3ouql4fhfhpi4aiysjo3sgze','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q2jjn:Jrcj7DGmzRVTmY94AqnRE3Mv1cUZa-A1j5IpWeERXGY','2023-06-10 02:32:59.291584'),('k2m5m1m2u417qab5iqw13wa3kz2533wu','e30:1pr613:eqVVxMeM41ziIRrkVFrtQrXJm1X6vYrPYj2GLrqX0pU','2023-05-08 23:54:41.990061'),('kenfroid59hwf9usehkaulr6c13m8oqy','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q2hgO:3eh5Ixkw9Lbbg9TATC9UcOdSuOjDdLzi3uO8MtIBhvQ','2023-06-10 00:21:20.232589'),('kn3w9aecf71dd0h86q2jnn27w5r3mn35','e30:1pr6Or:iGbYwuinpIqF008vQXc6hrxxJyk00lw3CpctyNwUW3U','2023-05-09 00:19:17.327361'),('kr6e48puzf6wmdujsdrknh7ksbpq8jns','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q8LRJ:uCF6mFltQPY13AVwOv_VE8WTdcJ2A9S4coC6WxXdk2U','2023-06-25 13:49:05.082916'),('l2cjy416u10xm5dgj6jz45ormh6uz8ky','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q6LjC:rrrVemknqde9qSPReNsgMIqVon52afQGbDaEm-3KsxE','2023-06-20 01:43:18.581642'),('l676qcjal4uiereo81r2rnrgutgdcu3x','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q2Bj0:i-JiEiPMxLuzksfbuvOp722RRoAL-9Bq0p6fLXQz5iw','2023-06-08 14:13:54.634285'),('l9aye3v8f3zoau4cv11suip5stfsqjsy','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0Xmq:dgieUH71BZjRy4I0cO21pTdtAHh-gUHaHli5XgzCLaE','2023-06-04 01:23:04.890791'),('l9bbufb2jf1cb5h4drwzyf0udhxtxeba','e30:1pr5qn:HmmtRwsjwSkpnLLH_2EEt0FVTb8mHk1oh-nd1t4eTfU','2023-05-08 23:44:05.234392'),('lgf4mi9xz8401e243qrf3kcjgm5icdu6','e30:1pr5pi:bScsYSp0Fd8PUFKzJZd1NYfYyn3joi31EWsUhm6OKqI','2023-05-08 23:42:58.825967'),('lh29gh5954oceoywfa074vwxim0mc4jv','e30:1pr5mc:-1rQbAZuIzfD2vvE9S9bdB52uIYoTGfYvhOFGutYLik','2023-05-08 23:39:46.357620'),('lhq4bcw52g38im4n5xou1a0fmh0armbx','.eJxVjDsKwzAQRO-iOhhr9d2UOUFuINbSKjIJMlh2FXL3IHBhTze8N_MVgfathL3xGuYk7kKOPSBuZzJRfHPt-LO85jocvQ1PXttSKz8O4bIq1Ep_9EjInD0CmhSNUkZpJnASrExeoyNrNUyg9ejBENoIRroMxMplieL3B_CiM7s:1q87sz:P-VZWy8NhiQr5QnvpS9Y3Shc_7DdouIi7VspHbQnO18','2023-06-24 23:20:45.242182'),('lpol3se1c7dw4o00alpur3tzgq3tbvuo','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pzmy6:93wb8hjQe7O2fpsmW3tiSHVP5-uP12IJ8wQYjq_X11s','2023-06-01 23:23:34.013292'),('lpy7yvdqeqxk6fq5whxqcddqm6jn99y5','e30:1q6bI9:3_QCQ935aa7S--19ihLRvpfziV0ATcPsMMsjOdWGeg4','2023-06-20 18:20:25.581710'),('lv537nie5etmktp7ge7t3vbujicqakpq','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1puhp5:dyQcLLv5PF2WwZo6MyNI1Im8QWCWD5ZyEWNdwhkQcJs','2023-05-18 22:53:15.163579'),('m5cxatywfyhkdsis09vseb8yobj99rzr','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q7sj5:aG596Kp4pCi1iAeSEwWeRsG8fFRvi2uQ9B4ZCYncGkw','2023-06-24 07:09:31.795242'),('ml4exfxurm1z5vcqyz4wtn1s5x4kma1c','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1puhSN:kmpAiSzD5C3y8EYHRINfhNEDpdYJwQpmRyk1gJ05Z9M','2023-05-18 22:29:47.488798'),('mu6mu9yjf2v9t6xiirwtef9kizlb7aoj','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7gIK:aUIvsQsQoYdkz5Vj0ycF9J7RiHVWTCuizKkyGUebpqg','2023-06-23 17:53:04.857166'),('mvo4s2rvgt5h6b64fg6xydqvvda1chn2','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5uJE:CkHCMtztJU6MYdmE5TVm9fOU30_Zbsji_5-LeLjuDYk','2023-06-18 20:26:40.817864'),('n06z2agjtu6jv7lh7tl8dtveq39hpb9i','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q3dEk:TlK850uLIVLGFuKOOk9uB1eVNdJzzLiQs7tO7k_NLPM','2023-06-12 13:48:38.760370'),('n0cbr12ei54ty6rb5r3ddst6a0y91ko7','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7m90:4xHjQelIF94yDIHeoWIQf7DQ4csR3nLVS-8ldq09qrI','2023-06-24 00:07:50.714463'),('n0pinkfhmlormq1pk7ogwgnv8bru7b1p','e30:1q4mvs:nWWfsFtR1v0AUzGwuYL4VhtaRt8wvLHSynoIhtua7jc','2023-06-15 18:21:56.874873'),('n1g4nvtrmmppkcrzns7hgr9ki00tqfkh','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1pvnKZ:ADFuH3_5kiKvb87uq8JZeOQjQUIcEhXkwZdiJ0tCRXU','2023-05-21 22:58:15.638728'),('n31wnpcbcrfung1yae4bwo5tw1zrbh06','e30:1povzr:BUZgdqNEV_63dhB_aX2F3_D3Zeqsb1TeaPNPirP9zBY','2023-05-03 00:48:31.544645'),('nc2hfwdtpue8x8sig341kl3uzldngh63','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q0fTZ:moEFMEQDZn4vi0lg040pFCo-suLodQ3-agU18Uf0-ng','2023-06-04 09:35:41.315837'),('nfj8noehamljf0be4jrvqxcsmumkdd31','e30:1q4qxq:HANsz1ZuOGmXutlC9Y9JATjgNaXdV-TW2UOMq0ZxCxU','2023-06-15 22:40:14.171083'),('nhgbipqfit23ay3ctv8qcrbmpxuvk8ne','e30:1q4rdd:UjBxwZ1V7w_Oi6CIoRs-wAuxFkIOfKlfdssjgiNz_I4','2023-06-15 23:23:25.076707'),('njaj725anoydmpeyl53koyenoefxd23f','e30:1q4mxR:SNE9Zp71BRLqXzVaJPHoRD5c9mpOP2vfGpCY4VmQ-KU','2023-06-15 18:23:33.928383'),('no37tj80nba7y00l8qgmkiz13bwg0a0f','.eJxVjEEOwiAQRe_C2jQDFGRcegJvQAZmkEZDk2JXxrsbki70737e-_-tIu2vGvcuW1xYXZSGEadOvyRRfkgb-LnelzYdvU832framlwP4W9VqdfxeKagPTqbGN1MiBmzlwDCRjxzACAoHpwOxUkuhinJ7C3OaCEba9XnCxOCNNE:1q7pLu:759hODv2dPPUgFwd46L7XwVxmFD0B_xckUb-i_uZGIA','2023-06-24 03:33:22.148712'),('nshbl2ugp3qsnxizzkjjfmjo04z8b8bn','e30:1pu21a:UsBdR_LiogzDu_EZPyI2O9Wn2E7KLKWu5gKXnH1HmFg','2023-05-17 02:15:22.649929'),('nyjbnf8tnctxtmrf4ggmeqt2n6fi2gb3','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3ohZ:LKykaWtm1Js-fIGbOi7jvypsHFKI8yJtWtvFZaLSwOo','2023-06-13 02:03:09.400469'),('o38a5bqq430g2qn1a21z95klru26ow44','e30:1q58Ze:SENrP8pMTu6TYC3AnU_fF6jOmh63IryP7CiYGY4PRSs','2023-06-16 17:28:26.303416'),('ol2clb5m2vbkvmbzxa01sdzkxio10sc0','e30:1pr5zP:77-0F-udDml-qjeoVXNdYXyIkeg8IFBG0oSnQ8N9o94','2023-05-08 23:52:59.733927'),('omfiodpt4hsagltsf62m0qa0fgg99kxp','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q87bV:iRfq1L9R-I_eqwAfHuLkvZXwwjnaXOLaZIoqyQFKhco','2023-06-24 23:02:41.209051'),('ooujcrf11s1nomdfk7mqjlhpd0c38tqw','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1puBxF:QBN4Pe-L82nMJTf81U_K-Tkml-qFEHT0J6FCVpDppRI','2023-05-17 12:51:33.943757'),('p6hmpfts302oomftg2iz0qndgbp9b349','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5sQt:4ePkMwY_RdVSGXxgW5f_KogKfTruT-mKyia5BwZHyOE','2023-06-18 18:26:27.223562'),('p8n6jd1tmgos2s02bb5cv786p0x5gxxu','e30:1q4rSK:DkeNoKEVPv9Woq0urAN48tTPUkmQociR2tsf1acR-Kg','2023-06-15 23:11:44.951008'),('pge7dhsztp7vhqijy93gfg7e7by7tco5','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5ozX:fu3JQiN1AJ3KqKSkdQrYpfoLggY2AkaTtuPsT6JsuUc','2023-06-18 14:45:59.466566'),('pv2iy12pf3kj1pk37hjq884li5rjksdk','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q3cHq:9420FwJmnbGp_z9l9wTP3sxIZ1pkrhNyu7wi0BuO3aU','2023-06-12 12:47:46.470829'),('pywfd1afohyukj1ybtg1jnfz5wvspics','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3oqP:QzhOawOiGGxYKJJDsTMkrhhX7JqZA_H2z-gM6cIqBUY','2023-06-13 02:12:17.808805'),('q3olgmavpnfqdtizia9zvgpxynpxbwqa','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q7qCi:d60i7VkZKimplEe6ocYimXe1m0mHwTRbe3GyPJN3TRA','2023-06-24 04:27:56.462581'),('q9ncxkqbx50i8zs8nogfrpspuv9jrtpl','.eJxVjEEOwiAQRe_C2jQDFGRcegJvQAZmkEZDk2JXxrsbki70737e-_-tIu2vGvcuW1xYXZSGEadOvyRRfkgb-LnelzYdvU832framlwP4W9VqdfxeKagPTqbGN1MiBmzlwDCRjxzACAoHpwOxUkuhinJ7C3OaCEba9XnCxOCNNE:1q71iB:PRhC8M44MBZhpLIQjTGPUTHaexIFVIFZvYmerd9YRDg','2023-06-21 22:33:03.091936'),('qegoyegr1jo3xj0a3p1txfdlzz4sgzhj','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pv5lO:dM7wRXvOBoE52d-9pCdjjk9jjrVlg5jsijmKGMZthoQ','2023-05-20 00:27:02.501159'),('qo32scsrgtcn6g9x0xa5dbyf4tlmn5rm','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q12Ur:yRKItsTheyaQNGMqRifGc-2gVH8wITKNrKGQsiR7blc','2023-06-05 10:10:33.411399'),('qtqyaj34fowsp53rxuqftjwev18vg9xn','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1pss8P:3wO9SoHH6CpmKAJwwyckeS1fd9WdZECRx5nyuNpMJIc','2023-05-13 21:29:37.978294'),('qvnmyzy0g59o5dk6yxyrmmiy375nljd2','e30:1q4mvj:5IyD7Gm_ckXfWOU08yYbvYYG4ZyRe4gDlcAAzZFZfUs','2023-06-15 18:21:47.969318'),('qzm4g9lwrwpueyceh24q7ye1pesfc6rt','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1q8ONX:I_mDqcmeSvtqg4ADisFAvwWMUjwUVTSvXKBkFWCGooc','2023-06-25 16:57:23.037995'),('r0eame47haa6yqhbc6qaaffrje15oi43','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q2hd9:7mTelv1-l7EiLYsso-ZL804PrWBrmHFxd2H9OLNdN94','2023-06-10 00:17:59.673009'),('r43n5qpy34bhswvgcs9x423h276hlban','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q05cp:Bbx9i1dAfYnREfp6rH_6vwjQBPK_v7H0pvBhWhBeuNc','2023-06-02 19:18:51.640008'),('r57wuh7jopmun120abhjernkz8n1t00a','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1q6rTv:ILufxf79aHAlM3xoRew06M3-7PVzdmN-qC8AScIRCLo','2023-06-21 11:37:39.444024'),('rlhdudclrtktmjikzjgzorsprii187rv','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1pwBQq:krt9e2_0ghbHX3qHQkYBgFmpxff2gecqvmeobIb9y1E','2023-05-23 00:42:20.333306'),('rs7tw5jnsbwqvajxhkevdgr4b7ezbs2l','e30:1q4rUC:bD-1eLy_72U0IHCqCoN0OI9WiZawPA8Oc2NXr8wANw0','2023-06-15 23:13:40.812644'),('rsjrzhw7h4j5l6vkqovfwfj7q97g97ny','e30:1q4rS9:wy9L8BIYfnxlKJrifSYUNVaUs_ScqS_Lk8L5YbZfyNM','2023-06-15 23:11:33.377536'),('s0ebsyfaristzbpgxxozy53t933enif1','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7gNo:mxvbtihROGScL0fYrzkiSKIGkiL6Fc8DYita2NJDHUg','2023-06-23 17:58:44.084861'),('s1b174n6ql031qyyzochqzf8a61bx2au','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q6LhL:oLjYw-ISHP1Tn1OXXpUe-V28duPIu6BEHx9QBpXYfEE','2023-06-20 01:41:23.058993'),('sbku2g1au0t0uiwb1cti94nxzpn5b4sw','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q3dP4:41XAZCHvyhYQz-WbIDKwc4dfG1JFNYb7PXw1WRbwjYM','2023-06-12 13:59:18.460202'),('sf1q6upowivafijj0lqqtc2ogt3vj76n','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q82lw:UEDVTStpqP-K0zpPtl-SkyeSZi1eW68lfAZVGvcr_2c','2023-06-24 17:53:08.526349'),('soq6cynbi18gwdt5mnqhth2frbppvhmg','.eJxVi0sOwjAMBe_iNaqajxOHJSfgBpHjJqQCpVJDV4i7Q6Uu4O2eZuYFkbdnjVvPa5wnOIMa9yGcfkliuee248dym9tw_D5c89qX1vLlEP6qyr1-E2YjyhOSQ0JneOLEQchyooSFzOi0IuFgUIgkoyVddCjFa2uN9QreHxV1NH0:1q8GJ7:0ah2lI9pUQ-3ca1XBJDTSd7hoXJp_UvRcPsmjiO3HjQ','2023-06-25 08:20:17.196452'),('spi0sykkz1w8omk5wq93fcoeqamde7x4','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1pyi07:i8d8bes1yf78olZ1xJXq3N5v683Jf_9wNqcYzLpl20E','2023-05-29 23:53:11.232517'),('t3qjaqa3zlye600k885tjwcchc3csr8l','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1pyZxf:Wtto3qdYwu8WoHIRz0rUNogcseiXrX_-F3b-0doh54w','2023-05-29 15:18:07.526001'),('tovkjdze1tycgd3oiblhvizjgy4yeofv','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q0fOx:6tBMXMVZur276Fq4yjmMtmllWpcNX6J8ama5kbFJ-IE','2023-06-04 09:30:55.203052'),('tsxkpxrbe7re245iq5zf2httw00fuwm3','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q3dHO:2qSYfqw9vQov58Yvw6bQT6yBtqoSOqJNOEOgndi1eUk','2023-06-12 13:51:22.021192'),('tv3k5dk2zeai3qwneslswisavxpdrzyh','e30:1q4rPf:CtfcAa4dE7TJu10-Wo_3CPJZfPN06NOo9XQGKB4LjzU','2023-06-15 23:08:59.052380'),('tx6sd2ppfdx17bqy6mhif87e3tzgyw5j','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1pyMar:1Ii-lnwYaETXqx_OX4M-folrN9N5qtRTj2Gcwf1vANQ','2023-05-29 01:01:41.719198'),('unn13g485yhp8tngzpdmb7at5rk563ck','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1q7qdv:1Nh9SoRyIEf0HwOxGwugtdQ3zuZdhIiPC55LlXjOylM','2023-06-24 04:56:03.515210'),('upfiv6gmh4nrvh4vkafhuuk5ksbgi77q','e30:1q4msm:0fGGWTRSOAB8-j-T3lmdeCsy4VjtBvLugsdsp29w-vA','2023-06-15 18:18:44.874422'),('urh5qsdcbzvjqplo8af2jsxk2vchlddj','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7g5R:_4c2jOmEFX_WPvmLXptyBz3vxag1692nTowtrclZNf8','2023-06-23 17:39:45.570333'),('uycmrits86ere20kpoy5jm8dvkw7i4dz','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7KSo:iN63dJTQCI2g7g1A9mM3B60T8GM-kmELUTlf2__PKXg','2023-06-22 18:34:26.506923'),('uzyzc616rqsgjjduxhn5jx4ew39325tr','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q1EtD:VisSFbUlXalEXgczw2iHDnHrdmXzGBqOZX7zpJDJdB0','2023-06-05 23:24:31.829095'),('v27u5xes93z3ujcj8icm7dghp76mjqoa','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pv5s0:jLMf6HLjUQ0daMz7zAY2cx9T18NHfgRE-Tzpa3kT-4s','2023-05-20 00:33:52.067702'),('v63xxteopbt69jkwcbdpckcnpvwmgihu','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q1dKL:ytoDyV3otboDH2F12id-UUGttTzxDVDczGjH_kcp-CY','2023-06-07 01:30:09.499123'),('v7i2g23p0iucij6m699jq91rbx4ynlt5','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q09SW:yz6I-TQWLEwpjTvV1hFx96-eDjOevk9IH4u0hpF5OtQ','2023-06-02 23:24:28.051670'),('vwkxknyjkdevavc7bb9tzv38bqk2spf4','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q0A2N:EuPmy4lckPCXgY2HHohdkWEQb2J-ERabvr61lIIm3GQ','2023-06-03 00:01:31.286893'),('vx6a8a8lduhkztju10rew69kksdq6os5','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1pxd8N:xfo_l6spetYP8ER80lUgNFWea8SywvI7dtgYerCCCy0','2023-05-27 00:29:15.312275'),('w1s22mbro4d5hdfnwinizevvlrka0o2g','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q5o49:mLSc0xsv6OhJw3VYRaa-stDat_yWiUqeThL4dQYwKm0','2023-06-18 13:46:41.000801'),('wpyq536kigs6bxjwa6ad1bj1zq84dt49','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q0AGO:Rlmjr1JDFIZDxz30MRlWF6ZDelX_ZHK-ecbKJH8pJxs','2023-06-03 00:16:00.826529'),('ww38e5x1s9r4jh2m4d3hzt5ag9eiskqt','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pu08r:fmC61TOjSzbJ5pz9WR55op2lAcLt6lhI2eqnn6SVaoU','2023-05-17 00:14:45.643704'),('wzf5meym42oabcy46tyij8v93drfj8qr','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1q68YM:mpIOHXa8GEPaynyLHFCTyQo2emwTbvu1UlzpNe9RryU','2023-06-19 11:39:14.773173'),('wzwc834v5o7o8dh53fxvehl8cytj7vuz','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q09z5:ooq7fgHoWDIMpxp8PeTLDrh07oeGwqfGYYekSYebig0','2023-06-02 23:58:07.203945'),('x32lpo61gdj5ncdhxnf04h15uwe629z6','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q5T6o:vjU77f2iuIMc14-rzTYk9GZq69zr8okwGDhyEwdfyN0','2023-06-17 15:24:02.906145'),('x61peb0a9fwjbppetatv3m3itaqbq9d8','e30:1q4rNc:s_8pJRbBNcnBC4M1oTKNZca5S1pAD-CHlz_D7f7qfjU','2023-06-15 23:06:52.281239'),('x6ukfi9hfowp6284s5ovg80tvykxch1q','.eJxVi0EOwjAMBP-SM6rsJE1djryAH0SO65AKlEoNPSH-DpV6gL2tZuZlIm_PErema5wnczYI-6w5_ZLEcte648dym2t3_NZddW1LrXo5hL-qcCvfJCeEIY_kKdGUETQEtDoEEu-ReutEAgM4oEwhZRoZpCcUdWxFlc37AwYxNPY:1q7iGM:SuAJ4s97qSqYEbBddpeI_-zc4yrp02wDNqBVmAYWs_g','2023-06-23 19:59:10.878011'),('x80a1pjkx7nqxg7oize5m6clxu5fb07p','.eJxVjUEKwyAQRe_iuoQZE6N22RP0BjKOQw0tBmKyKr17DWSR_N3nv8f_qkDbmsNWZQlTUneFsGdUt_MSid9S9vkzv6bSHb12T1nqXIo8DuBiZaq5KTYOOKBjR55tROdRNHhK7AW4XRGJ6zlZH-2Y0DQAIhkCbVCTw179_hGnNIU:1pxasF:H-0AfLQ0FNOIAJ6Rkfp6VbApiqiH3NxCu_IhsgwMNf8','2023-05-26 22:04:27.104080'),('xh2uqf83bkmy9d5imjp1ze5bmhoauzgo','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7KlF:tx4-6f8QM6qoEvtwkDehYO5fWDSG_LsRTM43IvOtaTc','2023-06-22 18:53:29.781964'),('xnhnhhdxhvlp1hl1i3bb67z1n9yeajr2','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q0A9d:Cwb1zMxQxAWsloGUbdXfquMy9nY_jcM7HuNnv8GmwGE','2023-06-03 00:09:01.616825'),('xorbz6z0b20p4ejfa9onxpodfywba32n','.eJxVi0EKwyAQRe_iugSdOOp02RP0BkGdSQ0tBmKyKr17E8ii_YsPn_ffWw1xW8uwNVmGidVVGX0E1eWXpJifUg_8mh9T7c7durssba5VbufhzyqxlV3pDWBCbyk48nkv0Jms15Ds6A0RyKjRm8zUhyCaOFhCBnaMDiCA-nwB1I4zRw:1q3oO5:lQ6bN2CehegHBNz1f8oVXVZIylfONvvOoiwnX03WaAg','2023-06-13 01:43:01.552880'),('xpwrechn25afoyncc2tfajjowoqrlbe9','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1pzo2L:xUigGaL1Wkg_zd5NGo9H6EX5RDr9EKcAXeKbscl3dis','2023-06-02 00:32:01.619665'),('yrv62z375f034qs192pfvgwojv7mc8qt','.eJxVi0EOwiAQRe_C2jSDBWZw6Qm8ARlgkEZDk2JXxrvbJl3o3_28994q8PqqYe2yhCmri9Kwz6jTL4mcHtJ2_JzvUxuO34ebLH1uTa6H8FdV7nVLkhcmU1C0dWgLYBrPNgtRNMQjWcSxEJCDpDcLxDuHkhB0zpGNF_X5AgyzNLs:1q68IN:7kbjXCwO2aB6QYpYHbDQ9waMdCZzN352w7f0XgTyyDI','2023-06-19 11:22:43.289513'),('yw7m3z6d0q9jidowlp86u2d2lht56y3q','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q1Elm:__hMhD4v5nGx_sVuox9s5VV6oyJlBzzkpBk1zOFGYDo','2023-06-05 23:16:50.686120'),('z2k37aea1p9gaxklotf18z1qhm3vt1he','e30:1q4rPH:W_yZ8Bz3kz-K8MVDRRbt50uDPBaezRVv_UM7Vqsh550','2023-06-15 23:08:35.303376'),('z2kbld99hfoareep4grrcl9rfpmajg6k','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7IWe:khWTWYqnHTMt7PLMwvzOhro4ZfgugW0h0on_fxw_XOw','2023-06-22 16:30:16.790976'),('z3zpflpty0wxgxxjuuete3sy1ffhkgg4','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q7p6o:B6TdupLUPWZNi2O5EeMiXwlCCsz1xGZqhkB9riHEiEw','2023-06-24 03:17:46.292183'),('z437z17s3duzdwetg6j7tap3ow6rvczi','.eJxVizsKwzAQRO-iOhitrG_KnCA3ECvtKjIJMlh2FXL32OAimWYY3ry3iLitNW6dlziRuAqQR0Zx-SUJ85PbgV_zY2rDuftw56XPrfHtPPxZFXvdFSZElSmzB-kgaacASRcbKJe9C8hirXWFgwGfvDGjT5rsmIhY-RzE5wtG4DX1:1q6tZT:4CysCgCz4PVIdzKGS3u-lWC5VzKGbwPeuAYv7AdiYzw','2023-06-21 13:51:31.004129'),('zdphqchsmvodtn67slee36xwg9kxw7gp','.eJxVi0EOwiAQRe_C2jSFgVJcegJvQAZmRhoNTYpdGe_eNulC_-7nvfdREdd3iWvjJU6krkr3x0BdfknC_OR64Nf8mGp3_tbdeWlzrXw7hb-qYCt7QnZglB5MEJ-sI6BsEDNrMJk8G9IIWSdPYYQQBEQGIm-NS8nBKKS-G0DhNhg:1q7IF3:zcITSuDZy3IhSaVEyljkLmLz0p9Ml07sPJaVt4S3pzM','2023-06-22 16:12:05.236209'),('zy9gkkgmud4bvnlkppgfzv206bslr68e','.eJxVjEEOwiAQRe_C2jQgDFNcegJvQIZhKo2GJqVdGe-uJF3o3728__9LRdq3Evcma5yzuiije6w6_ZpE_JDa9XO5z3U4uA03WdtSq1yPwt-qUCv9kS3iSIzMKViTLAFC0AjWBk06j8aZ9AWGc0CZMnh2wEGcFw9Tyur9Af7iNJ8:1q88yI:TsbYTKnOwkgM1mlV3zHT2Z7Z6Q4GSsP485W5YdcLrgI','2023-06-25 00:30:18.125748');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employe`
--

DROP TABLE IF EXISTS `employe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employe` (
  `id` int NOT NULL,
  `id_prs` bigint NOT NULL,
  `id_branche` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_emp_brch_idx` (`id_branche`),
  KEY `id_emp_per_idx` (`id_prs`),
  CONSTRAINT `id_emp_brch` FOREIGN KEY (`id_branche`) REFERENCES `branche` (`id`) ON DELETE CASCADE,
  CONSTRAINT `id_emp_per` FOREIGN KEY (`id_prs`) REFERENCES `personne` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employe`
--

LOCK TABLES `employe` WRITE;
/*!40000 ALTER TABLE `employe` DISABLE KEYS */;
INSERT INTO `employe` VALUES (100101003,1000006,100101),(100101004,1000004,100101),(100101005,1000005,100101),(100102001,1000007,100102),(100901001,10000013,100901),(100901002,10000012,100901),(100901003,10000014,100901),(101001001,10003435356632,101001);
/*!40000 ALTER TABLE `employe` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `insert_id_employee` BEFORE INSERT ON `employe` FOR EACH ROW BEGIN
    DECLARE id_prefix VARCHAR(10);
    DECLARE id_count INT;
    DECLARE new_id VARCHAR(10);
    DECLARE id_occupied INT;
    
    -- Get the id prefix based on id_branche value
    SET id_prefix = NEW.id_branche;
    
    -- Get the count of employees in this branch
    SELECT COUNT(*) INTO id_count FROM employe WHERE id_branche = NEW.id_branche;
    
    -- Generate the new id value
    SET new_id = CONCAT(id_prefix, LPAD(id_count + 1, 3, '0'));
    
    -- Check if the generated id is occupied
    SELECT COUNT(*) INTO id_occupied FROM employe WHERE id = new_id;
    
    -- Increment the id until an unoccupied id is found
    WHILE id_occupied > 0 DO
        SET id_count = id_count + 1;
        SET new_id = CONCAT(id_prefix, LPAD(id_count + 1, 3, '0'));
        SELECT COUNT(*) INTO id_occupied FROM employe WHERE id = new_id;
    END WHILE;
    
    -- Set the new id value
    SET NEW.id = new_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `evaluation`
--

DROP TABLE IF EXISTS `evaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` bigint DEFAULT NULL,
  `barcnh_id` int DEFAULT NULL,
  `nombre_etoiles` int DEFAULT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `evaluation_pat_id_idx` (`patient_id`),
  KEY `evaluation_lab_id_idx` (`barcnh_id`),
  CONSTRAINT `evaluation_lab_id` FOREIGN KEY (`barcnh_id`) REFERENCES `branche` (`id`) ON DELETE CASCADE,
  CONSTRAINT `evaluation_pat_id` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=674 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluation`
--

LOCK TABLES `evaluation` WRITE;
/*!40000 ALTER TABLE `evaluation` DISABLE KEYS */;
INSERT INTO `evaluation` VALUES (1,1000003,100101,5,'2023-06-02 21:00:00'),(2,1000003,100101,5,'2023-06-02 21:00:00'),(3,1000003,100101,5,'2023-06-02 21:00:00'),(4,1000003,100101,2,'2023-06-02 21:00:00'),(5,1000003,100101,2,'2023-06-02 21:00:00'),(6,1000003,100101,3,'2023-06-02 21:00:00'),(7,1000003,100101,5,'2023-06-02 21:00:00'),(8,1000003,100101,3,'2023-06-02 21:00:00'),(9,1000003,100101,4,'2023-06-02 21:00:00'),(10,1000003,100101,1,'2023-06-02 21:00:00'),(11,1000003,100101,5,'2023-06-02 21:00:00'),(12,1000003,100101,5,'2023-06-02 21:00:00'),(13,1000003,100101,1,'2023-06-02 21:00:00'),(14,1000003,100101,2,'2023-06-03 21:00:00'),(15,1000003,100101,4,'2023-06-03 21:00:00'),(16,1000003,100101,5,'2023-06-03 21:00:00'),(17,1000003,100101,2,'2023-06-03 21:00:00'),(18,1000003,100101,1,'2023-06-03 21:00:00'),(19,1000003,100101,5,'2023-06-03 21:00:00'),(20,1000003,100101,5,'2023-06-03 21:00:00'),(21,1000003,100101,5,'2023-06-03 21:00:00'),(22,1000003,100101,3,'2023-06-06 22:00:00'),(23,1000003,100101,1,'2023-06-06 22:00:00'),(24,1000003,100101,5,'2023-06-07 22:00:00'),(25,1000003,100101,1,'2023-06-07 22:00:00'),(26,1000003,100101,1,'2023-06-07 22:00:00'),(27,1000003,100101,1,'2023-06-07 22:00:00'),(28,1000003,100101,3,'2023-06-07 22:00:00'),(29,1000003,100101,4,'2023-06-07 22:00:00'),(30,1000003,100101,5,'2023-06-07 22:00:00'),(31,1000003,100101,5,'2023-06-07 22:00:00'),(32,1000003,100101,5,'2023-06-07 22:00:00'),(33,1000003,100101,5,'2023-06-07 22:00:00'),(34,1000003,100101,5,'2023-06-07 22:00:00'),(35,1000003,100101,5,'2023-06-07 22:00:00'),(36,1000003,100101,4,'2023-06-07 22:00:00'),(37,1000003,100101,3,'2023-06-07 22:00:00'),(38,1000003,100101,3,'2023-06-07 22:00:00'),(39,1000003,100101,3,'2023-06-07 22:00:00'),(40,1000003,100101,3,'2023-06-07 22:00:00'),(41,1000003,100101,3,'2023-06-07 22:00:00'),(42,1000003,100101,5,'2023-06-07 22:00:00'),(43,1000003,100101,5,'2023-06-07 22:00:00'),(44,1000003,100101,1,'2023-06-07 22:00:00'),(45,1000003,100101,5,'2023-06-07 22:00:00'),(46,1000003,100101,5,'2023-06-07 22:00:00'),(47,1000003,100101,5,'2023-06-07 22:00:00'),(48,184984984,100101,2,'2023-06-08 22:00:00'),(49,1000003,100102,1,'2023-06-09 23:15:15'),(50,1000003,100102,2,'2023-06-09 23:15:15'),(51,1000003,100102,3,'2023-06-09 23:15:15'),(52,1000003,100102,4,'2023-06-09 23:15:15'),(53,1000003,100102,5,'2023-06-09 23:15:15'),(54,1000003,100102,1,'2023-06-09 23:15:15'),(55,1000003,100102,2,'2023-06-09 23:15:15'),(56,1000003,100102,3,'2023-06-09 23:15:15'),(57,1000003,100102,4,'2023-06-09 23:15:15'),(58,1000003,100102,5,'2023-06-09 23:15:15'),(59,1000003,100102,1,'2023-06-09 23:15:15'),(60,1000003,100102,2,'2023-06-09 23:15:15'),(61,1000003,100102,3,'2023-06-09 23:15:15'),(62,1000003,100102,4,'2023-06-09 23:15:15'),(63,1000003,100102,5,'2023-06-09 23:15:15'),(64,1000003,100102,1,'2023-06-09 23:15:15'),(65,1000003,100102,2,'2023-06-09 23:15:15'),(66,1000003,100102,3,'2023-06-09 23:15:15'),(67,1000003,100102,4,'2023-06-09 23:15:15'),(68,1000003,100102,5,'2023-06-09 23:15:15'),(69,1000003,100102,1,'2023-06-09 23:15:15'),(70,1000003,100102,2,'2023-06-09 23:15:15'),(71,1000003,100102,3,'2023-06-09 23:15:15'),(72,1000003,100102,4,'2023-06-09 23:15:15'),(73,1000003,100102,5,'2023-06-09 23:15:15'),(74,1000003,100102,1,'2023-06-09 23:15:15'),(75,1000003,100102,2,'2023-06-09 23:15:15'),(76,1000003,100102,3,'2023-06-09 23:15:15'),(77,1000003,100102,4,'2023-06-09 23:15:15'),(78,1000003,100102,5,'2023-06-09 23:15:15'),(79,1000003,100102,1,'2023-06-09 23:16:27'),(80,1000003,100102,2,'2023-06-09 23:16:27'),(81,1000003,100102,3,'2023-06-09 23:16:27'),(82,1000003,100102,4,'2023-06-09 23:16:27'),(83,1000003,100102,5,'2023-06-09 23:16:27'),(84,1000003,100102,1,'2023-06-09 23:16:27'),(85,1000003,100102,2,'2023-06-09 23:16:27'),(86,1000003,100102,3,'2023-06-09 23:16:27'),(87,1000003,100102,4,'2023-06-09 23:16:27'),(88,1000003,100102,5,'2023-06-09 23:16:27'),(89,1000003,100102,1,'2023-06-09 23:16:27'),(90,1000003,100102,2,'2023-06-09 23:16:27'),(91,1000003,100102,3,'2023-06-09 23:16:27'),(92,1000003,100102,4,'2023-06-09 23:16:27'),(93,1000003,100102,5,'2023-06-09 23:16:27'),(94,1000003,100102,3,'2023-06-09 23:16:35'),(95,1000003,100102,4,'2023-06-09 23:16:35'),(96,1000003,100102,5,'2023-06-09 23:16:35'),(97,1000003,100102,1,'2023-06-09 23:16:35'),(98,1000003,100102,2,'2023-06-09 23:16:35'),(99,1000003,100102,3,'2023-06-09 23:16:35'),(100,1000003,100102,4,'2023-06-09 23:16:35'),(101,1000003,100102,5,'2023-06-09 23:16:35'),(102,1000003,100102,1,'2023-06-09 23:16:35'),(103,1000003,100102,2,'2023-06-09 23:16:35'),(104,1000003,100102,3,'2023-06-09 23:16:35'),(105,1000003,100102,4,'2023-06-09 23:16:35'),(106,1000003,100102,5,'2023-06-09 23:16:35'),(107,1000003,100102,1,'2023-06-09 23:16:35'),(108,1000003,100102,2,'2023-06-09 23:16:35'),(109,1000003,100102,3,'2023-06-09 23:16:35'),(110,1000003,100102,4,'2023-06-09 23:16:35'),(111,1000003,100102,5,'2023-06-09 23:16:35'),(112,1000003,100102,1,'2023-06-09 23:16:35'),(113,1000003,100102,2,'2023-06-09 23:16:35'),(114,1000003,100102,3,'2023-06-09 23:16:35'),(115,1000003,100102,4,'2023-06-09 23:16:35'),(116,1000003,100102,5,'2023-06-09 23:16:35'),(117,1000003,100102,1,'2023-06-09 23:16:46'),(118,1000003,100102,2,'2023-06-09 23:16:46'),(119,1000003,100102,3,'2023-06-09 23:16:46'),(120,1000003,100102,4,'2023-06-09 23:16:46'),(121,1000003,100102,5,'2023-06-09 23:16:46'),(122,1000003,100102,1,'2023-06-09 23:16:46'),(123,1000003,100102,2,'2023-06-09 23:16:46'),(124,1000003,100102,3,'2023-06-09 23:16:46'),(125,1000003,100102,4,'2023-06-09 23:16:46'),(126,1000003,100102,5,'2023-06-09 23:16:46'),(127,1000003,100102,1,'2023-06-09 23:16:46'),(128,1000003,100102,2,'2023-06-09 23:16:46'),(129,1000003,100102,3,'2023-06-09 23:16:46'),(130,1000003,100102,4,'2023-06-09 23:16:46'),(131,1000003,100102,5,'2023-06-09 23:16:46'),(132,1000003,100102,1,'2023-06-09 23:16:46'),(133,1000003,100102,1,'2023-06-09 23:16:50'),(134,1000003,100102,2,'2023-06-09 23:16:50'),(135,1000003,100102,3,'2023-06-09 23:16:50'),(136,1000003,100102,4,'2023-06-09 23:16:50'),(137,1000003,100102,5,'2023-06-09 23:16:50'),(138,1000003,100102,1,'2023-06-09 23:16:50'),(139,1000003,100102,2,'2023-06-09 23:16:50'),(140,1000003,100102,3,'2023-06-09 23:16:50'),(141,1000003,100102,4,'2023-06-09 23:16:50'),(142,1000003,100102,5,'2023-06-09 23:16:50'),(143,1000003,100102,1,'2023-06-09 23:16:50'),(144,1000003,100102,2,'2023-06-09 23:16:50'),(145,1000003,100102,3,'2023-06-09 23:16:50'),(146,1000003,100102,4,'2023-06-09 23:16:50'),(147,1000003,100102,5,'2023-06-09 23:16:50'),(148,1000003,100102,1,'2023-06-09 23:16:50'),(149,1000003,100102,2,'2023-06-09 23:16:50'),(150,1000003,100102,3,'2023-06-09 23:16:50'),(151,1000003,100102,4,'2023-06-09 23:16:50'),(152,1000003,100102,5,'2023-06-09 23:16:50'),(153,1000003,100102,1,'2023-06-09 23:16:50'),(154,1000003,100102,2,'2023-06-09 23:16:50'),(155,1000003,100102,3,'2023-06-09 23:16:50'),(156,1000003,100102,4,'2023-06-09 23:16:50'),(157,1000003,100102,5,'2023-06-09 23:16:50'),(158,1000003,100102,1,'2023-06-09 23:16:50'),(159,1000003,100102,2,'2023-06-09 23:16:50'),(160,1000003,100102,3,'2023-06-09 23:16:50'),(161,1000003,100102,4,'2023-06-09 23:16:50'),(162,1000003,100102,5,'2023-06-09 23:16:50'),(163,1000003,100102,1,'2023-06-09 23:17:16'),(164,1000003,100102,1,'2023-06-09 23:17:16'),(165,1000003,100102,1,'2023-06-09 23:17:16'),(166,1000003,100102,1,'2023-06-09 23:17:17'),(167,1000003,100102,1,'2023-06-09 23:17:17'),(168,1000003,100102,1,'2023-06-09 23:17:17'),(169,1000003,100102,1,'2023-06-09 23:17:17'),(170,1000003,100102,1,'2023-06-09 23:17:18'),(171,1000003,100102,1,'2023-06-09 23:17:18'),(172,1000003,100102,1,'2023-06-09 23:17:18'),(173,1000003,100102,1,'2023-06-09 23:17:18'),(174,1000003,100102,1,'2023-06-09 23:17:18'),(175,1000003,100102,1,'2023-06-09 23:17:19'),(176,1000003,100102,1,'2023-06-09 23:17:19'),(177,1000003,100102,1,'2023-06-09 23:17:19'),(178,1000003,100102,1,'2023-06-09 23:17:19'),(179,1000003,100102,1,'2023-06-09 23:17:19'),(180,1000003,100102,1,'2023-06-09 23:17:19'),(181,1000003,100102,1,'2023-06-09 23:17:20'),(182,1000003,100102,1,'2023-06-09 23:17:20'),(183,1000003,100102,1,'2023-06-09 23:17:20'),(184,1000003,100102,1,'2023-06-09 23:17:20'),(185,1000003,100102,1,'2023-06-09 23:17:21'),(186,1000003,100102,1,'2023-06-09 23:17:21'),(187,1000003,100102,1,'2023-06-09 23:17:21'),(188,1000003,100102,1,'2023-06-09 23:17:21'),(189,1000003,100102,1,'2023-06-09 23:17:21'),(190,1000003,100102,1,'2023-06-09 23:17:21'),(191,1000003,100102,1,'2023-06-09 23:17:22'),(192,1000003,100102,1,'2023-06-09 23:17:22'),(193,1000003,100102,1,'2023-06-09 23:17:22'),(194,1000003,100102,1,'2023-06-09 23:17:22'),(195,1000003,100102,1,'2023-06-09 23:17:22'),(196,1000003,100102,1,'2023-06-09 23:17:23'),(197,1000003,100102,1,'2023-06-09 23:17:23'),(198,1000003,100102,1,'2023-06-09 23:17:23'),(199,1000003,100102,1,'2023-06-09 23:17:23'),(200,1000003,100102,1,'2023-06-09 23:17:23'),(201,1000003,100102,1,'2023-06-09 23:17:24'),(202,1000003,100102,1,'2023-06-09 23:17:24'),(203,1000003,100102,1,'2023-06-09 23:17:24'),(204,1000003,100102,1,'2023-06-09 23:17:24'),(205,1000003,100102,1,'2023-06-09 23:17:24'),(206,1000003,100102,1,'2023-06-09 23:17:24'),(207,1000003,100102,1,'2023-06-09 23:17:25'),(208,1000003,100102,1,'2023-06-09 23:17:25'),(209,1000003,100102,1,'2023-06-09 23:17:25'),(210,1000003,100102,1,'2023-06-09 23:17:25'),(211,1000003,100102,2,'2023-06-09 23:17:28'),(212,1000003,100102,2,'2023-06-09 23:17:28'),(213,1000003,100102,2,'2023-06-09 23:17:28'),(214,1000003,100102,2,'2023-06-09 23:17:28'),(215,1000003,100102,2,'2023-06-09 23:17:29'),(216,1000003,100102,2,'2023-06-09 23:17:29'),(217,1000003,100102,2,'2023-06-09 23:17:29'),(218,1000003,100102,2,'2023-06-09 23:17:29'),(219,1000003,100102,2,'2023-06-09 23:17:29'),(220,1000003,100102,3,'2023-06-09 23:17:32'),(221,1000003,100102,3,'2023-06-09 23:17:33'),(222,1000003,100102,3,'2023-06-09 23:17:33'),(223,1000003,100102,3,'2023-06-09 23:17:33'),(224,1000003,100102,3,'2023-06-09 23:17:33'),(225,1000003,100102,3,'2023-06-09 23:17:34'),(226,1000003,100102,3,'2023-06-09 23:17:34'),(227,1000003,100102,3,'2023-06-09 23:17:34'),(228,1000003,100102,3,'2023-06-09 23:17:34'),(229,1000003,100102,3,'2023-06-09 23:17:35'),(230,1000003,100102,3,'2023-06-09 23:17:35'),(231,1000003,100102,3,'2023-06-09 23:17:35'),(232,1000003,100102,3,'2023-06-09 23:17:35'),(233,1000003,100102,3,'2023-06-09 23:17:35'),(234,1000003,100102,3,'2023-06-09 23:17:35'),(235,1000003,100102,3,'2023-06-09 23:17:36'),(236,1000003,100102,5,'2023-06-09 23:17:40'),(237,1000003,100102,5,'2023-06-09 23:17:40'),(238,1000003,100102,5,'2023-06-09 23:17:40'),(239,1000003,100102,5,'2023-06-09 23:17:40'),(240,1000003,100102,5,'2023-06-09 23:17:41'),(241,1000003,100102,5,'2023-06-09 23:17:41'),(242,1000003,100102,5,'2023-06-09 23:17:41'),(243,1000003,100102,5,'2023-06-09 23:17:41'),(244,1000003,100102,5,'2023-06-09 23:17:41'),(245,1000003,100102,5,'2023-06-09 23:17:42'),(246,1000003,100102,5,'2023-06-09 23:17:42'),(247,1000003,100102,5,'2023-06-09 23:17:42'),(248,1000003,100102,5,'2023-06-09 23:17:42'),(249,1000003,100102,5,'2023-06-09 23:17:42'),(250,1000003,100102,5,'2023-06-09 23:17:43'),(251,1000003,100102,5,'2023-06-09 23:17:43'),(252,1000003,100102,5,'2023-06-09 23:17:43'),(253,1000003,100102,5,'2023-06-09 23:17:43'),(254,1000003,100102,5,'2023-06-09 23:17:43'),(255,1000003,100102,5,'2023-06-09 23:17:43'),(256,1000003,100102,5,'2023-06-09 23:17:44'),(257,1000003,100102,5,'2023-06-09 23:17:44'),(258,1000003,100102,5,'2023-06-09 23:17:44'),(259,1000003,100102,5,'2023-06-09 23:17:44'),(260,1000003,100102,5,'2023-06-09 23:17:45'),(261,1000003,100102,5,'2023-06-09 23:17:45'),(262,1000003,100102,5,'2023-06-09 23:17:45'),(263,1000003,100102,5,'2023-06-09 23:17:45'),(264,1000003,100102,5,'2023-06-09 23:17:45'),(265,1000003,100102,5,'2023-06-09 23:17:46'),(266,1000003,100102,5,'2023-06-09 23:17:46'),(267,1000003,100102,5,'2023-06-09 23:17:46'),(268,1000003,100102,5,'2023-06-09 23:17:46'),(269,1000003,100102,5,'2023-06-09 23:17:46'),(270,1000003,100102,5,'2023-06-09 23:17:46'),(271,1000003,100102,5,'2023-06-09 23:17:47'),(272,1000003,100102,5,'2023-06-09 23:17:47'),(273,1000003,100102,5,'2023-06-09 23:17:47'),(274,1000003,100102,5,'2023-06-09 23:17:47'),(275,1000003,100102,5,'2023-06-09 23:17:47'),(276,1000003,100102,5,'2023-06-09 23:17:48'),(277,1000003,100102,5,'2023-06-09 23:17:48'),(278,1000003,100102,5,'2023-06-09 23:17:48'),(279,1000003,100102,5,'2023-06-09 23:17:48'),(280,1000003,100102,5,'2023-06-09 23:17:48'),(281,1000003,100102,5,'2023-06-09 23:17:49'),(282,1000003,100102,5,'2023-06-09 23:17:49'),(283,1000003,100102,5,'2023-06-09 23:17:49'),(284,1000003,100102,5,'2023-06-09 23:17:49'),(285,1000003,100102,5,'2023-06-09 23:17:49'),(286,1000003,100102,5,'2023-06-09 23:17:50'),(287,1000003,100102,5,'2023-06-09 23:17:50'),(288,1000003,100102,5,'2023-06-09 23:17:50'),(289,1000003,100102,5,'2023-06-09 23:17:50'),(290,1000003,100102,5,'2023-06-09 23:17:50'),(291,1000003,100102,5,'2023-06-09 23:17:51'),(292,1000003,100102,5,'2023-06-09 23:17:51'),(293,1000003,100102,5,'2023-06-09 23:17:51'),(294,1000003,100102,5,'2023-06-09 23:17:51'),(295,1000003,100102,5,'2023-06-09 23:17:51'),(296,1000003,100102,5,'2023-06-09 23:17:51'),(297,1000003,100102,5,'2023-06-09 23:17:52'),(298,1000003,100102,5,'2023-06-09 23:17:52'),(299,1000003,100102,5,'2023-06-09 23:17:52'),(300,1000003,100102,5,'2023-06-09 23:17:52'),(301,1000003,100102,5,'2023-06-09 23:17:52'),(302,1000003,100102,5,'2023-06-09 23:17:53'),(303,1000003,100102,5,'2023-06-09 23:17:53'),(304,1000003,100102,5,'2023-06-09 23:17:53'),(305,1000003,100102,5,'2023-06-09 23:17:53'),(306,1000003,100102,5,'2023-06-09 23:17:53'),(307,1000003,100102,5,'2023-06-09 23:17:53'),(308,1000003,100102,5,'2023-06-09 23:17:54'),(309,1000003,100102,5,'2023-06-09 23:17:54'),(310,1000003,100102,5,'2023-06-09 23:17:54'),(311,1000003,100102,5,'2023-06-09 23:17:54'),(312,1000003,100102,5,'2023-06-09 23:17:54'),(313,1000003,100102,5,'2023-06-09 23:17:55'),(314,1000003,100102,5,'2023-06-09 23:17:55'),(315,1000003,100102,5,'2023-06-09 23:17:55'),(316,1000003,100102,5,'2023-06-09 23:17:55'),(317,1000003,100102,5,'2023-06-09 23:17:55'),(318,1000003,100102,5,'2023-06-09 23:17:55'),(319,1000003,100102,5,'2023-06-09 23:17:56'),(320,1000003,100102,5,'2023-06-09 23:17:56'),(321,1000003,100102,5,'2023-06-09 23:17:56'),(322,1000003,100102,5,'2023-06-09 23:17:56'),(323,1000003,100102,5,'2023-06-09 23:17:56'),(324,1000003,100102,5,'2023-06-09 23:17:56'),(325,1000003,100102,5,'2023-06-09 23:17:56'),(403,1000003,100901,5,'2023-06-09 23:19:20'),(404,1000003,100901,5,'2023-06-09 23:19:21'),(405,1000003,100901,5,'2023-06-09 23:19:21'),(406,1000003,100901,5,'2023-06-09 23:19:21'),(407,1000003,100901,5,'2023-06-09 23:19:21'),(408,1000003,100901,5,'2023-06-09 23:19:21'),(409,1000003,100901,5,'2023-06-09 23:19:22'),(410,1000003,100901,5,'2023-06-09 23:19:22'),(411,1000003,100901,5,'2023-06-09 23:19:22'),(412,1000003,100901,5,'2023-06-09 23:19:22'),(413,1000003,100901,5,'2023-06-09 23:19:23'),(414,1000003,100901,5,'2023-06-09 23:19:23'),(415,1000003,100901,5,'2023-06-09 23:19:23'),(416,1000003,100901,5,'2023-06-09 23:19:23'),(417,1000003,100901,5,'2023-06-09 23:19:23'),(418,1000003,100901,5,'2023-06-09 23:19:24'),(419,1000003,100901,5,'2023-06-09 23:19:24'),(420,1000003,100901,5,'2023-06-09 23:19:24'),(421,1000003,100901,5,'2023-06-09 23:19:24'),(422,1000003,100901,5,'2023-06-09 23:19:24'),(423,1000003,100901,5,'2023-06-09 23:19:25'),(424,1000003,100901,5,'2023-06-09 23:19:25'),(425,1000003,100901,5,'2023-06-09 23:19:25'),(426,1000003,100901,5,'2023-06-09 23:19:25'),(427,1000003,100901,5,'2023-06-09 23:19:25'),(428,1000003,100901,5,'2023-06-09 23:19:26'),(429,1000003,100901,5,'2023-06-09 23:19:26'),(430,1000003,100901,5,'2023-06-09 23:19:26'),(431,1000003,100901,5,'2023-06-09 23:19:26'),(432,1000003,100901,5,'2023-06-09 23:19:27'),(433,1000003,100901,5,'2023-06-09 23:19:27'),(434,1000003,100901,5,'2023-06-09 23:19:27'),(435,1000003,100901,5,'2023-06-09 23:19:27'),(436,1000003,100901,5,'2023-06-09 23:19:28'),(437,1000003,100901,5,'2023-06-09 23:19:28'),(438,1000003,100901,5,'2023-06-09 23:19:28'),(439,1000003,100901,5,'2023-06-09 23:19:28'),(440,1000003,100901,5,'2023-06-09 23:19:28'),(441,1000003,100901,5,'2023-06-09 23:19:29'),(442,1000003,100901,5,'2023-06-09 23:19:29'),(443,1000003,100901,5,'2023-06-09 23:19:29'),(444,1000003,100901,5,'2023-06-09 23:19:29'),(445,1000003,100901,5,'2023-06-09 23:19:30'),(446,1000003,100901,5,'2023-06-09 23:19:30'),(447,1000003,100901,5,'2023-06-09 23:19:30'),(448,1000003,100901,5,'2023-06-09 23:19:30'),(449,1000003,100901,5,'2023-06-09 23:19:30'),(450,1000003,100901,5,'2023-06-09 23:19:31'),(451,1000003,100901,5,'2023-06-09 23:19:31'),(452,1000003,100901,5,'2023-06-09 23:19:31'),(453,1000003,100901,5,'2023-06-09 23:19:31'),(454,1000003,100901,5,'2023-06-09 23:19:31'),(455,1000003,100901,5,'2023-06-09 23:19:32'),(456,1000003,100901,5,'2023-06-09 23:19:32'),(457,1000003,100901,5,'2023-06-09 23:19:32'),(458,1000003,100901,5,'2023-06-09 23:19:32'),(459,1000003,100901,5,'2023-06-09 23:19:33'),(460,1000003,100901,5,'2023-06-09 23:19:33'),(461,1000003,100901,5,'2023-06-09 23:19:33'),(462,1000003,100901,5,'2023-06-09 23:19:33'),(463,1000003,100901,5,'2023-06-09 23:19:34'),(464,1000003,100901,5,'2023-06-09 23:19:34'),(465,1000003,100901,5,'2023-06-09 23:19:34'),(466,1000003,100901,5,'2023-06-09 23:19:34'),(467,1000003,100901,5,'2023-06-09 23:19:35'),(468,1000003,100901,5,'2023-06-09 23:19:35'),(469,1000003,100901,5,'2023-06-09 23:19:35'),(470,1000003,100901,5,'2023-06-09 23:19:35'),(471,1000003,100901,5,'2023-06-09 23:19:35'),(472,1000003,100901,5,'2023-06-09 23:19:36'),(473,1000003,100901,5,'2023-06-09 23:19:36'),(474,1000003,100901,5,'2023-06-09 23:19:36'),(475,1000003,100901,5,'2023-06-09 23:19:36'),(476,1000003,100901,5,'2023-06-09 23:19:37'),(477,1000003,100901,5,'2023-06-09 23:19:37'),(478,1000003,100901,5,'2023-06-09 23:19:37'),(479,1000003,100901,5,'2023-06-09 23:19:37'),(480,1000003,100901,5,'2023-06-09 23:19:38'),(481,1000003,100901,5,'2023-06-09 23:19:38'),(482,1000003,100901,5,'2023-06-09 23:19:38'),(483,1000003,100901,5,'2023-06-09 23:19:38'),(484,1000003,100901,5,'2023-06-09 23:19:39'),(485,1000003,100901,5,'2023-06-09 23:19:39'),(486,1000003,100901,5,'2023-06-09 23:19:39'),(487,1000003,100901,5,'2023-06-09 23:19:39'),(488,1000003,100901,5,'2023-06-09 23:19:39'),(489,1000003,100901,4,'2023-06-09 23:19:42'),(490,1000003,100901,4,'2023-06-09 23:19:43'),(491,1000003,100901,4,'2023-06-09 23:19:43'),(492,1000003,100901,4,'2023-06-09 23:19:43'),(493,1000003,100901,4,'2023-06-09 23:19:43'),(494,1000003,100901,4,'2023-06-09 23:19:44'),(495,1000003,100901,4,'2023-06-09 23:19:44'),(496,1000003,100901,4,'2023-06-09 23:19:44'),(497,1000003,100901,4,'2023-06-09 23:19:44'),(498,1000003,100901,4,'2023-06-09 23:19:44'),(499,1000003,100901,4,'2023-06-09 23:19:45'),(500,1000003,100901,4,'2023-06-09 23:19:45'),(501,1000003,100901,4,'2023-06-09 23:19:45'),(502,1000003,100901,4,'2023-06-09 23:19:45'),(503,1000003,100901,4,'2023-06-09 23:19:45'),(504,1000003,100901,4,'2023-06-09 23:19:46'),(505,1000003,100901,4,'2023-06-09 23:19:46'),(506,1000003,100901,4,'2023-06-09 23:19:46'),(507,1000003,100901,4,'2023-06-09 23:19:46'),(508,1000003,100901,4,'2023-06-09 23:19:47'),(509,1000003,100901,4,'2023-06-09 23:19:47'),(510,1000003,100901,4,'2023-06-09 23:19:47'),(511,1000003,100901,4,'2023-06-09 23:19:47'),(512,1000003,100901,4,'2023-06-09 23:19:47'),(513,1000003,100901,4,'2023-06-09 23:19:47'),(514,1000003,100901,4,'2023-06-09 23:19:47'),(515,1000003,100901,3,'2023-06-09 23:19:51'),(516,1000003,100901,3,'2023-06-09 23:19:51'),(517,1000003,100901,3,'2023-06-09 23:19:51'),(518,1000003,100901,3,'2023-06-09 23:19:51'),(519,1000003,100901,3,'2023-06-09 23:19:52'),(520,1000003,100901,3,'2023-06-09 23:19:52'),(521,1000003,100901,3,'2023-06-09 23:19:52'),(522,1000003,100901,3,'2023-06-09 23:19:52'),(523,1000003,100901,3,'2023-06-09 23:19:53'),(524,1000003,100901,3,'2023-06-09 23:19:54'),(525,1000003,100901,3,'2023-06-09 23:19:54'),(526,1000003,100901,3,'2023-06-09 23:19:54'),(527,1000003,100901,3,'2023-06-09 23:19:54'),(528,1000003,100901,3,'2023-06-09 23:19:55'),(529,1000003,100901,3,'2023-06-09 23:19:55'),(530,1000003,100901,3,'2023-06-09 23:19:55'),(531,1000003,100901,3,'2023-06-09 23:19:55'),(532,1000003,100901,3,'2023-06-09 23:19:56'),(533,1000003,100901,3,'2023-06-09 23:19:56'),(534,1000003,100901,3,'2023-06-09 23:19:56'),(535,1000003,100901,3,'2023-06-09 23:19:56'),(536,1000003,100901,3,'2023-06-09 23:19:56'),(537,1000003,100901,3,'2023-06-09 23:19:57'),(538,1000003,100901,3,'2023-06-09 23:19:57'),(539,1000003,100901,3,'2023-06-09 23:19:57'),(540,1000003,100901,3,'2023-06-09 23:19:57'),(541,1000003,100901,3,'2023-06-09 23:19:57'),(542,1000003,100901,3,'2023-06-09 23:19:58'),(543,1000003,100901,3,'2023-06-09 23:19:58'),(544,1000003,100901,3,'2023-06-09 23:19:58'),(545,1000003,100901,3,'2023-06-09 23:19:58'),(546,1000003,100901,3,'2023-06-09 23:19:58'),(547,1000003,100901,3,'2023-06-09 23:19:58'),(548,1000003,100901,3,'2023-06-09 23:19:59'),(549,1000003,100901,3,'2023-06-09 23:19:59'),(550,1000003,100901,3,'2023-06-09 23:19:59'),(551,1000003,100901,3,'2023-06-09 23:19:59'),(552,1000003,100901,3,'2023-06-09 23:20:00'),(553,1000003,100901,3,'2023-06-09 23:20:00'),(554,1000003,100901,3,'2023-06-09 23:20:00'),(555,1000003,100901,3,'2023-06-09 23:20:00'),(556,1000003,100901,3,'2023-06-09 23:20:00'),(557,1000003,100901,3,'2023-06-09 23:20:00'),(558,1000003,100901,3,'2023-06-09 23:20:01'),(559,1000003,100901,3,'2023-06-09 23:20:01'),(560,1000003,100901,3,'2023-06-09 23:20:01'),(561,1000003,100901,3,'2023-06-09 23:20:01'),(562,1000003,100901,3,'2023-06-09 23:20:01'),(563,1000003,100901,3,'2023-06-09 23:20:01'),(564,1000003,100901,3,'2023-06-09 23:20:02'),(565,1000003,100901,3,'2023-06-09 23:20:02'),(566,1000003,100901,3,'2023-06-09 23:20:02'),(567,1000003,100901,3,'2023-06-09 23:20:02'),(568,1000003,100901,3,'2023-06-09 23:20:02'),(569,1000003,100901,3,'2023-06-09 23:20:03'),(570,1000003,100901,3,'2023-06-09 23:20:03'),(571,1000003,100901,3,'2023-06-09 23:20:03'),(572,1000003,100901,3,'2023-06-09 23:20:03'),(573,1000003,100901,3,'2023-06-09 23:20:03'),(574,1000003,100901,3,'2023-06-09 23:20:03'),(575,1000003,100901,3,'2023-06-09 23:20:03'),(576,1000003,100901,3,'2023-06-09 23:20:04'),(577,1000003,100901,3,'2023-06-09 23:20:04'),(578,1000003,100901,3,'2023-06-09 23:20:04'),(579,1000003,100901,3,'2023-06-09 23:20:04'),(580,1000003,100901,3,'2023-06-09 23:20:04'),(581,1000003,100901,3,'2023-06-09 23:20:05'),(582,1000003,100901,3,'2023-06-09 23:20:05'),(583,1000003,100901,3,'2023-06-09 23:20:05'),(584,1000003,100901,3,'2023-06-09 23:20:05'),(585,1000003,100901,3,'2023-06-09 23:20:05'),(586,1000003,100901,3,'2023-06-09 23:20:06'),(587,1000003,100901,3,'2023-06-09 23:20:06'),(588,1000003,100901,3,'2023-06-09 23:20:06'),(589,1000003,100901,3,'2023-06-09 23:20:06'),(590,1000003,100901,3,'2023-06-09 23:20:06'),(591,1000003,100901,3,'2023-06-09 23:20:07'),(592,1000003,100901,3,'2023-06-09 23:20:07'),(593,1000003,100901,3,'2023-06-09 23:20:07'),(594,1000003,100901,3,'2023-06-09 23:20:07'),(595,1000003,100901,3,'2023-06-09 23:20:07'),(596,1000003,100901,3,'2023-06-09 23:20:07'),(597,1000003,100901,3,'2023-06-09 23:20:08'),(598,1000003,100901,3,'2023-06-09 23:20:08'),(599,1000003,100901,3,'2023-06-09 23:20:08'),(600,1000003,100901,3,'2023-06-09 23:20:08'),(601,1000003,100901,3,'2023-06-09 23:20:08'),(602,1000003,100901,3,'2023-06-09 23:20:08'),(603,1000003,100901,3,'2023-06-09 23:20:08'),(604,1000003,100901,3,'2023-06-09 23:20:08'),(605,1000003,100901,3,'2023-06-09 23:20:08'),(606,1000003,100901,2,'2023-06-09 23:20:11'),(607,1000003,100901,2,'2023-06-09 23:20:11'),(608,1000003,100901,2,'2023-06-09 23:20:11'),(609,1000003,100901,2,'2023-06-09 23:20:11'),(610,1000003,100901,2,'2023-06-09 23:20:12'),(611,1000003,100901,2,'2023-06-09 23:20:12'),(612,1000003,100901,2,'2023-06-09 23:20:12'),(613,1000003,100901,2,'2023-06-09 23:20:12'),(614,1000003,100901,2,'2023-06-09 23:20:13'),(615,1000003,100901,2,'2023-06-09 23:20:13'),(616,1000003,100901,2,'2023-06-09 23:20:13'),(617,1000003,100901,2,'2023-06-09 23:20:13'),(618,1000003,100901,2,'2023-06-09 23:20:13'),(619,1000003,100901,2,'2023-06-09 23:20:14'),(620,1000003,100901,2,'2023-06-09 23:20:14'),(621,1000003,100901,2,'2023-06-09 23:20:14'),(622,1000003,100901,2,'2023-06-09 23:20:14'),(623,1000003,100901,2,'2023-06-09 23:20:15'),(624,1000003,100901,2,'2023-06-09 23:20:15'),(625,1000003,100901,2,'2023-06-09 23:20:15'),(626,1000003,100901,2,'2023-06-09 23:20:15'),(627,1000003,100901,2,'2023-06-09 23:20:15'),(628,1000003,100901,2,'2023-06-09 23:20:16'),(629,1000003,100901,2,'2023-06-09 23:20:16'),(630,1000003,100901,2,'2023-06-09 23:20:16'),(631,1000003,100901,2,'2023-06-09 23:20:16'),(632,1000003,100901,2,'2023-06-09 23:20:16'),(633,1000003,100901,2,'2023-06-09 23:20:17'),(634,1000003,100901,2,'2023-06-09 23:20:17'),(635,1000003,100901,2,'2023-06-09 23:20:17'),(636,1000003,100901,2,'2023-06-09 23:20:17'),(637,1000003,100901,2,'2023-06-09 23:20:17'),(638,1000003,100901,2,'2023-06-09 23:20:17'),(639,1000003,100901,1,'2023-06-09 23:20:18'),(640,1000003,100901,1,'2023-06-09 23:20:18'),(641,1000003,100901,1,'2023-06-09 23:20:18'),(642,1000003,100901,1,'2023-06-09 23:20:19'),(643,1000003,100901,1,'2023-06-09 23:20:19'),(644,1000003,100901,1,'2023-06-09 23:20:19'),(645,1000003,100901,1,'2023-06-09 23:20:19'),(646,1000003,100901,1,'2023-06-09 23:20:20'),(647,1000003,100901,1,'2023-06-09 23:20:20'),(648,1000003,100901,1,'2023-06-09 23:20:20'),(649,1000003,100901,1,'2023-06-09 23:20:20'),(650,1000003,100901,1,'2023-06-09 23:20:21'),(651,1000003,100901,1,'2023-06-09 23:20:21'),(652,1000003,100901,1,'2023-06-09 23:20:21'),(653,1000003,100901,1,'2023-06-09 23:20:21'),(654,1000003,100901,1,'2023-06-09 23:20:21'),(655,1000003,100901,1,'2023-06-09 23:20:22'),(656,1000003,100901,1,'2023-06-09 23:20:22'),(657,1000003,100901,1,'2023-06-09 23:20:22'),(658,1000003,100901,1,'2023-06-09 23:20:22'),(659,1000003,100901,1,'2023-06-09 23:20:22'),(660,1000003,100901,1,'2023-06-09 23:20:22'),(661,1000003,100901,1,'2023-06-09 23:20:23'),(662,1000003,100901,1,'2023-06-09 23:20:23'),(663,1000003,100901,1,'2023-06-09 23:20:23'),(664,1000003,100901,1,'2023-06-09 23:20:23'),(665,1000003,100901,1,'2023-06-09 23:20:23'),(666,1000003,100901,1,'2023-06-09 23:20:24'),(667,1000003,100901,1,'2023-06-09 23:20:24'),(668,1000003,100901,1,'2023-06-09 23:20:24'),(669,1000003,100901,1,'2023-06-09 23:20:24'),(670,1000003,100901,1,'2023-06-09 23:20:24'),(671,184984984,100101,5,'2023-06-09 22:00:00'),(672,184984984,100101,2,'2023-06-09 22:00:00'),(673,184984984,100101,5,'2023-06-09 22:00:00');
/*!40000 ALTER TABLE `evaluation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facture`
--

DROP TABLE IF EXISTS `facture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facture` (
  `id` bigint unsigned NOT NULL,
  `statut` enum('payer','inpayer') DEFAULT NULL,
  `chemin_facture` text,
  `prix` decimal(10,2) DEFAULT NULL,
  `rdv_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fact_rdv_id_idx` (`rdv_id`),
  CONSTRAINT `fact_rdv_id` FOREIGN KEY (`rdv_id`) REFERENCES `rendez_vous` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facture`
--

LOCK TABLES `facture` WRITE;
/*!40000 ALTER TABLE `facture` DISABLE KEYS */;
INSERT INTO `facture` VALUES (10010120230603162150,'payer','pdf\\invoices\\invoice-10010120230603162150.pdf',497.00,NULL),(10010120230604021037,'payer','pdf\\invoices\\invoice-10010120230604021037.pdf',148.00,NULL),(10010120230605015339,'payer','pdf\\invoices\\invoice-10010120230605015339.pdf',470.00,NULL),(10010120230605032316,'payer','pdf\\invoices\\invoice-10010120230605032316.pdf',10.00,NULL),(10010120230605102514,'payer','pdf\\invoices\\invoice-10010120230605102514.pdf',132.00,NULL),(10010120230605134932,'payer','pdf\\invoices\\invoice-10010120230605134932.pdf',122.00,NULL),(10010120230606183500,'payer','pdf\\invoices\\invoice-10010120230606183500.pdf',470.00,NULL),(10010120230607001318,'payer','pdf\\invoices\\invoice-10010120230607001318.pdf',0.00,NULL),(10010120230607001328,'payer','pdf\\invoices\\invoice-10010120230607001328.pdf',0.00,NULL),(10010120230607001355,'payer','pdf\\invoices\\invoice-10010120230607001355.pdf',0.00,NULL),(10010120230607001603,'payer','pdf\\invoices\\invoice-10010120230607001603.pdf',0.00,NULL),(10010120230607001620,'payer','pdf\\invoices\\invoice-10010120230607001620.pdf',0.00,NULL),(10010120230607001706,'payer','pdf\\invoices\\invoice-10010120230607001706.pdf',0.00,NULL),(10010120230607001829,'payer','pdf\\invoices\\invoice-10010120230607001829.pdf',0.00,NULL),(10010120230607002025,'payer','pdf\\invoices\\invoice-10010120230607002025.pdf',0.00,NULL),(10010120230607002100,'payer','pdf\\invoices\\invoice-10010120230607002100.pdf',0.00,NULL),(10010120230607002209,'payer','pdf\\invoices\\invoice-10010120230607002209.pdf',0.00,NULL),(10010120230607002837,'payer','pdf\\invoices\\invoice-10010120230607002837.pdf',0.00,NULL),(10010120230607002959,'payer','pdf\\invoices\\invoice-10010120230607002959.pdf',0.00,NULL),(10010120230607003354,'payer','pdf\\invoices\\invoice-10010120230607003354.pdf',0.00,NULL),(10010120230607003546,'payer','pdf\\invoices\\invoice-10010120230607003546.pdf',0.00,NULL),(10010120230607003624,'payer','pdf\\invoices\\invoice-10010120230607003624.pdf',0.00,NULL),(10010120230607003710,'payer','pdf\\invoices\\invoice-10010120230607003710.pdf',0.00,NULL),(10010120230607003733,'payer','pdf\\invoices\\invoice-10010120230607003733.pdf',0.00,NULL),(10010120230607004047,'payer','pdf\\invoices\\invoice-10010120230607004047.pdf',0.00,NULL),(10010120230607004119,'payer','pdf\\invoices\\invoice-10010120230607004119.pdf',0.00,NULL),(10010120230607004202,'payer','pdf\\invoices\\invoice-10010120230607004202.pdf',0.00,NULL),(10010120230607004217,'payer','pdf\\invoices\\invoice-10010120230607004217.pdf',0.00,NULL),(10010120230607004321,'payer','pdf\\invoices\\invoice-10010120230607004321.pdf',0.00,NULL),(10010120230607004633,'payer','pdf\\invoices\\invoice-10010120230607004633.pdf',0.00,NULL),(10010120230607004840,'payer','pdf\\invoices\\invoice-10010120230607004840.pdf',0.00,NULL),(10010120230607004910,'payer','pdf\\invoices\\invoice-10010120230607004910.pdf',0.00,NULL),(10010120230607005023,'payer','pdf\\invoices\\invoice-10010120230607005023.pdf',16.00,NULL),(10010120230607005108,'payer','pdf\\invoices\\invoice-10010120230607005108.pdf',16.00,NULL),(10010120230607005348,'payer','pdf\\invoices\\invoice-10010120230607005348.pdf',10.00,NULL),(10010120230607005534,'payer','pdf\\invoices\\invoice-10010120230607005534.pdf',122.00,NULL),(10010120230607005625,'payer','pdf\\invoices\\invoice-10010120230607005625.pdf',16.00,NULL),(10010120230607005705,'payer','pdf\\invoices\\invoice-10010120230607005705.pdf',60.00,NULL),(10010120230607005743,'payer','pdf\\invoices\\invoice-10010120230607005743.pdf',10.00,NULL),(10010120230607005930,'payer','pdf\\invoices\\invoice-10010120230607005930.pdf',122.00,NULL),(10010120230607010001,'payer','pdf\\invoices\\invoice-10010120230607010001.pdf',216.00,NULL),(10010120230607010226,'payer','pdf\\invoices\\invoice-10010120230607010226.pdf',60.00,NULL),(10010120230607020218,'payer','pdf\\invoices\\invoice-10010120230607020218.pdf',165.00,NULL),(10010120230607113539,'payer','pdf\\invoices\\invoice-10010120230607113539.pdf',10.00,NULL),(10010120230607124737,'payer','pdf\\invoices\\invoice-10010120230607124737.pdf',226.00,NULL),(10010120230607142909,'payer','pdf\\invoices\\invoice-10010120230607142909.pdf',142.00,NULL),(10010120230608175403,'payer','pdf\\invoices\\invoice-10010120230608175403.pdf',122.00,NULL),(10010120230608182807,'payer','pdf\\invoices\\invoice-10010120230608182807.pdf',142.00,NULL),(10010120230609182441,'payer','pdf\\invoices\\invoice-10010120230609182441.pdf',150.00,NULL),(10010120230609183141,'payer','pdf\\invoices\\invoice-10010120230609183141.pdf',10.00,NULL),(10010120230609191542,'payer','pdf\\invoices\\invoice-10010120230609191542.pdf',10.00,NULL),(10010120230609222712,'payer','pdf\\invoices\\invoice-10010120230609222712.pdf',15.00,NULL),(10010120230609222746,'payer','pdf\\invoices\\invoice-10010120230609222746.pdf',15.00,NULL),(10010120230610010609,'payer','pdf\\invoices\\invoice-10010120230610010609.pdf',470.00,NULL),(10010120230610025558,'payer','pdf\\invoices\\invoice-10010120230610025558.pdf',124.00,NULL),(10010120230610031413,'payer','pdf\\invoices\\invoice-10010120230610031413.pdf',134.00,NULL),(10010120230610031531,'payer','pdf\\invoices\\invoice-10010120230610031531.pdf',124.00,NULL),(10010120230610031739,'payer','pdf\\invoices\\invoice-10010120230610031739.pdf',124.00,NULL),(10010120230610031911,'payer','pdf\\invoices\\invoice-10010120230610031911.pdf',134.00,NULL),(10010120230610051142,'payer','pdf\\invoices\\invoice-10010120230610051142.pdf',25.00,NULL),(10010120230610051316,'payer','pdf\\invoices\\invoice-10010120230610051316.pdf',16.00,NULL),(10010120230610065344,'payer','pdf\\invoices\\invoice-10010120230610065344.pdf',123.00,NULL),(10010120230610082237,'payer','pdf\\invoices\\invoice-10010120230610082237.pdf',144.00,NULL),(10010120230610233012,'payer','pdf\\invoices\\invoice-10010120230610233012.pdf',594.00,NULL),(10010120230610233346,'payer','pdf\\invoices\\invoice-10010120230610233346.pdf',148.00,NULL),(10010120230610234427,'payer','pdf\\invoices\\invoice-10010120230610234427.pdf',470.00,NULL),(10010120230610235845,'payer','pdf\\invoices\\invoice-10010120230610235845.pdf',124.00,NULL),(10010120230611110303,'payer','pdf\\invoices\\invoice-10010120230611110303.pdf',124.00,334),(10010120230611110446,'payer','pdf\\invoices\\invoice-10010120230611110446.pdf',124.00,335),(10010120230611112745,'payer','pdf\\invoices\\invoice-10010120230611112745.pdf',123.00,336),(10010120230611142400,'payer','pdf\\invoices\\invoice-10010120230611142400.pdf',134.00,337),(10010120230611142548,'payer','pdf\\invoices\\invoice-10010120230611142548.pdf',147.00,338);
/*!40000 ALTER TABLE `facture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `infirmier`
--

DROP TABLE IF EXISTS `infirmier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `infirmier` (
  `id` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `id_inf_emp` FOREIGN KEY (`id`) REFERENCES `employe` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `infirmier`
--

LOCK TABLES `infirmier` WRITE;
/*!40000 ALTER TABLE `infirmier` DISABLE KEYS */;
INSERT INTO `infirmier` VALUES (100101003),(100102001),(100901001),(101001001);
/*!40000 ALTER TABLE `infirmier` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `create_canaux_after_insert_inf` AFTER INSERT ON `infirmier` FOR EACH ROW BEGIN
    DECLARE branch_id INT;
    
    SELECT id_branche INTO branch_id
    FROM employe
    WHERE id = NEW.id;
    
    IF branch_id IS NOT NULL THEN
        INSERT INTO canaux_emp (id_med, id_inf)
        SELECT mc.id, NEW.id
        FROM medecin_chef mc
        JOIN employe em ON em.id = mc.id
        JOIN employe inf ON inf.id = NEW.id
        WHERE em.id_branche = branch_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `laboratoire`
--

DROP TABLE IF EXISTS `laboratoire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laboratoire` (
  `id` int NOT NULL,
  `nom` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laboratoire`
--

LOCK TABLES `laboratoire` WRITE;
/*!40000 ALTER TABLE `laboratoire` DISABLE KEYS */;
INSERT INTO `laboratoire` VALUES (1001,'Ibn Sina'),(1009,'EL KAWTER'),(1010,'ibn rouchd'),(1011,'pasteur');
/*!40000 ALTER TABLE `laboratoire` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `increment_id_before_insert` BEFORE INSERT ON `laboratoire` FOR EACH ROW BEGIN
    DECLARE last_id INT;
    
    SELECT MAX(id) INTO last_id FROM laboratoire;
    
    IF last_id IS NULL THEN
        SET NEW.id = 1001;
    ELSE
        SET NEW.id = last_id + 1;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_laboratoire_insert` AFTER INSERT ON `laboratoire` FOR EACH ROW BEGIN
    DECLARE dir_id bigint;
    DECLARE per_id bigint;
    DECLARE lab_nom varchar(45);
    DECLARE notif_contenu text;
    
    -- Get the laboratory ID
    SET lab_nom = NEW.nom;
    
    -- Get the director's ID from the `directeur` table
    SELECT id INTO dir_id FROM directeur WHERE id_lab = NEW.id;
    
    -- Get the person's ID from the `directeur` table
    SELECT id INTO per_id FROM personne WHERE id = dir_id;
    
    -- Create the notification content
    SET notif_contenu = CONCAT('Welcome ', (SELECT CONCAT(nom, ' ', prenom) FROM personne WHERE id = per_id), '! Your account for laboratory "', lab_nom, '" is available and you can start your journey with us.');
    
    -- Insert the notification into the `notification` table
    INSERT INTO notification (contenu, id_prs) VALUES (notif_contenu, per_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `medecin_chef`
--

DROP TABLE IF EXISTS `medecin_chef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medecin_chef` (
  `id` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `id_med_emp` FOREIGN KEY (`id`) REFERENCES `employe` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medecin_chef`
--

LOCK TABLES `medecin_chef` WRITE;
/*!40000 ALTER TABLE `medecin_chef` DISABLE KEYS */;
INSERT INTO `medecin_chef` VALUES (100101004);
/*!40000 ALTER TABLE `medecin_chef` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `create_canaux_after_insert_med` AFTER INSERT ON `medecin_chef` FOR EACH ROW BEGIN
    DECLARE branch_id INT;
    
    SELECT id_branche INTO branch_id
    FROM employe
    WHERE id = NEW.id;
    
    IF branch_id IS NOT NULL THEN
        INSERT INTO canaux_emp (id_med, id_inf)
        SELECT NEW.id, inf.id
        FROM infirmier inf
        JOIN employe em ON em.id = inf.id
        JOIN employe mc ON mc.id = NEW.id
        WHERE em.id_branche = branch_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `contenu` text,
  `id_prs` bigint DEFAULT NULL,
  `is_read` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_not_per_idx` (`id_prs`),
  CONSTRAINT `id_not_per` FOREIGN KEY (`id_prs`) REFERENCES `personne` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=504 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (422,'2023-06-10 23:34:15','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(423,'2023-06-10 23:34:15','You have a new appointment to work with. Please check your appointment list.',1000006,0),(424,'2023-06-11 00:06:53','You have logged in at 2023-06-11 01:06:53. Welcome back, ZAKARIA ',1000003,1),(425,'2023-06-11 00:30:18','You have logged in at 2023-06-11 01:30:18. Welcome back, ZAKARIA ',1000003,1),(426,'2023-06-11 00:31:19','You have logged in at 2023-06-11 01:31:19. Welcome back, soumia ',1000006,0),(427,'2023-06-11 08:00:33','You have logged in at 2023-06-11 09:00:33. Welcome back, ZAKARIA ',1000003,1),(428,'2023-06-11 08:00:55','You have logged in at 2023-06-11 09:00:55. Welcome back, ZAKARIA ',1000003,1),(429,'2023-06-11 08:00:56','You have logged in at 2023-06-11 09:00:56. Welcome back, ZAKARIA ',1000003,1),(430,'2023-06-11 08:01:31','You have logged in at 2023-06-11 09:01:31. Welcome back, fares ',1000002,0),(431,'2023-06-11 08:02:15','You have logged in at 2023-06-11 09:02:15. Welcome back, ZAKARIA ',1000003,1),(432,'2023-06-11 08:04:33','You have logged in at 2023-06-11 09:04:33. Welcome back, ZAKARIA ',1000003,1),(433,'2023-06-11 08:12:02','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(434,'2023-06-11 08:12:27','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(435,'2023-06-11 08:12:36','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(436,'2023-06-11 07:16:39','You received a new message from the patient. Check your DM.',1000005,0),(437,'2023-06-11 08:17:17','You have logged in at 2023-06-11 09:17:17. Welcome back, NADIA ',1000005,0),(438,'2023-06-11 07:17:37','You have a new message from Ibn Sina. Check your DM.',1000003,1),(439,'2023-06-11 08:20:17','You have logged in at 2023-06-11 09:20:17. Welcome back, NADIA ',1000005,0),(440,'2023-06-11 08:22:39','You have logged in at 2023-06-11 09:22:39. Welcome back, soumia ',1000006,0),(441,'2023-06-11 08:23:55','You have logged in at 2023-06-11 09:23:55. Welcome back, fares ',1000002,0),(442,'2023-06-11 08:31:11','You have logged in at 2023-06-11 09:31:11. Welcome back, malik ',1000004,0),(443,'2023-06-11 08:32:16','You have logged in at 2023-06-11 09:32:16. Welcome back, malik ',1000004,0),(444,'2023-06-11 08:34:07','You have logged in at 2023-06-11 09:34:07. Welcome back, NADIA ',1000005,0),(445,'2023-06-11 08:37:32','You have logged in at 2023-06-11 09:37:32. Welcome back, fares ',1000002,0),(446,'2023-06-11 09:40:00','You have logged in at 2023-06-11 10:40:00. Welcome back, ZAKARIA ',1000003,1),(447,'2023-06-11 09:49:13','You have logged in at 2023-06-11 10:49:13. Welcome back, NADIA ',1000005,0),(448,'2023-06-11 09:51:09','You have logged in at 2023-06-11 10:51:09. Welcome back, ZAKARIA ',1000003,1),(449,'2023-06-11 09:59:06','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(450,'2023-06-11 09:59:38','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(451,'2023-06-11 10:03:03','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(452,'2023-06-11 10:04:04','You have a new appointment to work with. Please check your appointment list.',1000006,0),(453,'2023-06-11 10:04:46','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(454,'2023-06-11 10:05:45','You have a new appointment to work with. Please check your appointment list.',1000006,0),(455,'2023-06-11 10:17:33','You have logged in at 2023-06-11 11:17:33. Welcome back, ZAKARIA ',1000003,1),(456,'2023-06-11 10:19:48','You have logged in at 2023-06-11 11:19:48. Welcome back, NADIA ',1000005,0),(457,'2023-06-11 10:24:50','You have logged in at 2023-06-11 11:24:50. Welcome back, soumia ',1000006,0),(458,'2023-06-11 10:24:54','You have logged in at 2023-06-11 11:24:54. Welcome back, soumia ',1000006,0),(459,'2023-06-11 10:27:11','You have new results without a report. Please go to the results to check it.',1000004,0),(460,'2023-06-11 10:27:23','You have logged in at 2023-06-11 11:27:23. Welcome back, ZAKARIA ',1000003,1),(461,'2023-06-11 10:27:45','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(462,'2023-06-11 10:28:02','You have logged in at 2023-06-11 11:28:02. Welcome back, soumia ',1000006,0),(463,'2023-06-11 10:28:03','You have logged in at 2023-06-11 11:28:03. Welcome back, malik ',1000004,0),(464,'2023-06-11 10:28:36','You have a new appointment to work with. Please check your appointment list.',1000006,0),(465,'2023-06-11 10:28:54','You have new results without a report. Please go to the results to check it.',1000004,0),(466,'2023-06-11 10:30:13','You have logged in at 2023-06-11 11:30:13. Welcome back, NADIA ',1000005,0),(467,'2023-06-11 10:30:20','Your appointment on 2023-06-11 has been changed from 08:15:00 to 08:22:30 due to an emergency case. Please check your appointment.',1000003,1),(468,'2023-06-11 10:30:20','Your appointment on 2023-06-11 at 08:15:00 has been marked as  emergency case. Please check your appointment.',1000003,1),(469,'2023-06-11 13:23:33','You have logged in at 2023-06-11 14:23:33. Welcome back, ZAKARIA ',1000003,1),(470,'2023-06-11 13:23:59','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(471,'2023-06-11 13:24:02','You have a new appointment to work with. Please check your appointment list.',1000006,0),(472,'2023-06-11 13:24:42','You have logged in at 2023-06-11 14:24:42. Welcome back, NADIA ',1000005,0),(473,'2023-06-11 13:25:48','New rendez-vous created for patient KAHOUL ABDELMADJID',100020887151860008,0),(474,'2023-06-11 13:25:48','You have a new appointment to work with. Please check your appointment list.',1000006,0),(475,'2023-06-11 13:26:05','You have logged in at 2023-06-11 14:26:05. Welcome back, ZAKARIA ',1000003,1),(476,'2023-06-11 13:26:17','You have logged in at 2023-06-11 14:26:17. Welcome back, ZAKARIA ',1000003,1),(477,'2023-06-11 13:29:33','You have logged in at 2023-06-11 14:29:33. Welcome back, ZAKARIA ',1000003,1),(478,'2023-06-11 13:30:47','You have logged in at 2023-06-11 14:30:47. Welcome back, ZAKARIA ',1000003,1),(479,'2023-06-11 13:40:19','You have logged in at 2023-06-11 14:40:19. Welcome back, ZAKARIA ',1000003,1),(480,'2023-06-11 13:41:35','You have logged in at 2023-06-11 14:41:35. Welcome back, ZAKARIA ',1000003,1),(481,'2023-06-11 13:41:45','You have logged in at 2023-06-11 14:41:45. Welcome back, NADIA ',1000005,0),(482,'2023-06-11 13:42:10','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(483,'2023-06-11 13:42:10','You have a new appointment to work with. Please check your appointment list.',1000006,0),(484,'2023-06-11 13:42:11','New rendez-vous created for patient BOURAOUI ZAKARIA',1000003,1),(485,'2023-06-11 13:42:11','You have a new appointment to work with. Please check your appointment list.',1000006,0),(486,'2023-06-11 13:43:18','You have logged in at 2023-06-11 14:43:18. Welcome back, soumia ',1000006,0),(487,'2023-06-11 13:44:44','You have new results without a report. Please go to the results to check it.',1000004,0),(488,'2023-06-11 13:46:10','You have new results without a report. Please go to the results to check it.',1000004,0),(489,'2023-06-11 13:47:02','You have new results without a report. Please go to the results to check it.',1000004,0),(490,'2023-06-11 13:47:10','You have logged in at 2023-06-11 14:47:10. Welcome back, malik ',1000004,0),(491,'2023-06-11 13:48:46','Your test result has arrived. Please check it.',1000003,1),(492,'2023-06-11 13:49:05','You have logged in at 2023-06-11 14:49:05. Welcome back, ZAKARIA ',1000003,1),(493,'2023-06-11 13:59:51','You have logged in at 2023-06-11 14:59:51. Welcome back, soumia ',1000006,0),(494,'2023-06-11 14:05:00','You have logged in at 2023-06-11 15:05:00. Welcome back, soumia ',1000006,0),(495,'2023-06-11 14:06:36','You have logged in at 2023-06-11 15:06:36. Welcome back, ZAKARIA ',1000003,1),(496,'2023-06-11 13:16:41','You received a new message from the patient. Check your DM.',1000005,0),(497,'2023-06-11 14:30:04','You have logged in at 2023-06-11 15:30:04. Welcome back, NADIA ',1000005,0),(498,'2023-06-11 15:37:47','You have logged in at 2023-06-11 16:37:47. Welcome back, ZAKARIA ',1000003,0),(499,'2023-06-11 15:39:12','You have logged in at 2023-06-11 16:39:12. Welcome back, ZAKARIA ',1000003,0),(500,'2023-06-11 15:48:55','You have logged in at 2023-06-11 16:48:55. Welcome back, NADIA ',1000005,0),(501,'2023-06-11 16:57:23','You have logged in at 2023-06-11 17:57:23. Welcome back, malik ',1000004,0),(502,'2023-06-11 17:46:43','You have logged in at 2023-06-11 18:46:43. Welcome back, NADIA ',1000005,0),(503,'2023-06-11 17:46:57','You have logged in at 2023-06-11 18:46:57. Welcome back, malik ',1000004,0);
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `id` bigint NOT NULL,
  `maladie` text,
  `type_sang` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `id_pat_per` FOREIGN KEY (`id`) REFERENCES `personne` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1000003,'diabete','A+'),(184984984,'None','O-'),(100020887151860008,NULL,NULL);
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_patient_update` AFTER UPDATE ON `patient` FOR EACH ROW BEGIN
    DECLARE prs_id BIGINT;
    DECLARE prs_nom VARCHAR(45);
    DECLARE prs_prenom VARCHAR(45);
    DECLARE notification_content TEXT;

    -- Get the person's information
    SELECT id, nom, prenom INTO prs_id, prs_nom, prs_prenom
    FROM personne
    WHERE id = NEW.id;

    -- Create the notification content
    SET notification_content = CONCAT('Your personal information has been updated. Please check your profile.');

    -- Insert the notification
    INSERT INTO notification (contenu, id_prs)
    VALUES (notification_content, prs_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rdv_id` int DEFAULT NULL,
  `charge_id` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `card_last4` varchar(4) NOT NULL,
  `card_brand` varchar(20) NOT NULL,
  `payment_status` enum('success','failed') NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `payment_id_patient_idx` (`rdv_id`),
  CONSTRAINT `payment_id_patient` FOREIGN KEY (`rdv_id`) REFERENCES `rendez_vous` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (128,NULL,'ch_3NEwH2KIaTFOVFQW1JTtCo4b',497.00,'4242','Visa','success','2023-06-03 15:21:51'),(133,NULL,'ch_3NFcqlKIaTFOVFQW1ktSDAXE',122.00,'4242','Visa','success','2023-06-05 12:49:32'),(167,NULL,'0000',10.00,'0000','cash','success','2023-06-06 23:57:44'),(170,NULL,'0000',60.00,'0000','cash','success','2023-06-07 00:02:26'),(182,NULL,'ch_3NH9A0KIaTFOVFQW0Y6Mesw3',10.00,'4242','Visa','success','2023-06-09 17:31:42'),(184,NULL,'ch_3NH9qaKIaTFOVFQW1C5JUwTY',10.00,'4242','Visa','success','2023-06-09 18:15:42'),(194,NULL,'ch_3NHHJfKIaTFOVFQW1grx0Acg',134.00,'4242','Visa','success','2023-06-10 02:14:13'),(202,NULL,'0000',594.00,'0000','cash','success','2023-06-10 22:30:13'),(203,NULL,'ch_3NHaKUKIaTFOVFQW0GrqovKN',323.00,'4242','Visa','success','2023-06-10 22:32:20'),(204,NULL,'0000',148.00,'0000','cash','success','2023-06-10 22:33:27'),(205,NULL,'0000',148.00,'0000','cash','success','2023-06-10 22:33:46'),(206,NULL,'0000',470.00,'0000','cash','success','2023-06-10 22:44:27'),(207,NULL,'0000',124.00,'0000','cash','success','2023-06-10 22:58:19'),(208,NULL,'0000',124.00,'0000','cash','success','2023-06-10 22:58:46'),(209,NULL,'ch_3NHjNUKIaTFOVFQW0A6A2QVN',134.00,'4242','Visa','success','2023-06-11 08:12:03'),(210,NULL,'ch_3NHjNtKIaTFOVFQW0fFSBKbH',134.00,'4242','Visa','success','2023-06-11 08:12:28'),(211,NULL,'ch_3NHjO2KIaTFOVFQW0JWoYoZt',134.00,'4242','Visa','success','2023-06-11 08:12:37'),(212,NULL,'ch_3NHl37KIaTFOVFQW1ggjBvBQ',124.00,'4242','Visa','success','2023-06-11 09:59:07'),(213,NULL,'ch_3NHl3dKIaTFOVFQW0ehuJQHg',124.00,'4242','Visa','success','2023-06-11 09:59:39'),(214,334,'ch_3NHl6wKIaTFOVFQW1xtHafhL',124.00,'4242','Visa','success','2023-06-11 10:03:04'),(215,335,'ch_3NHl8aKIaTFOVFQW1lLiPEtN',124.00,'4242','Visa','success','2023-06-11 10:04:46'),(216,336,'ch_3NHlUpKIaTFOVFQW18pYLlq3',123.00,'4242','Visa','success','2023-06-11 10:27:45'),(217,337,'ch_3NHoFOKIaTFOVFQW1ioTDbxS',134.00,'4242','Visa','success','2023-06-11 13:24:00'),(218,338,'0000',147.00,'0000','cash','success','2023-06-11 13:25:48'),(219,339,'0000',470.00,'0000','cash','success','2023-06-11 13:42:11'),(220,340,'0000',470.00,'0000','cash','success','2023-06-11 13:42:11');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_lab`
--

DROP TABLE IF EXISTS `payment_lab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_lab` (
  `id` int NOT NULL AUTO_INCREMENT,
  `abbonment_id` int NOT NULL,
  `charge_id` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `card_last4` varchar(4) NOT NULL,
  `card_brand` varchar(100) NOT NULL,
  `payment_status` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_lab_ibfk_1` (`abbonment_id`),
  CONSTRAINT `payment_lab_ibfk_1` FOREIGN KEY (`abbonment_id`) REFERENCES `abonnement` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_lab`
--

LOCK TABLES `payment_lab` WRITE;
/*!40000 ALTER TABLE `payment_lab` DISABLE KEYS */;
INSERT INTO `payment_lab` VALUES (9,16,'ch_3NHCyMKIaTFOVFQW0rfFJomh',365000.00,'4242','Visa','success','2023-06-09 21:35:57'),(10,16,'ch_3NHCywKIaTFOVFQW1WWvpiyo',365000.00,'4242','Visa','success','2023-06-09 21:36:32'),(11,17,'ch_3NHMmtKIaTFOVFQW1lb0gvGp',90000.00,'4242','Visa','success','2023-06-10 08:04:45');
/*!40000 ALTER TABLE `payment_lab` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personne`
--

DROP TABLE IF EXISTS `personne`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personne` (
  `id` bigint NOT NULL,
  `nom` varchar(45) NOT NULL,
  `prenom` varchar(45) NOT NULL,
  `date_naissance` date NOT NULL,
  `lieu_naissance` varchar(45) NOT NULL,
  `sex` enum('homme','femme','autre') NOT NULL,
  `email` varchar(60) NOT NULL,
  `num_telephone` varchar(13) NOT NULL,
  `nom_utilisateur` varchar(45) NOT NULL,
  `mot_passe` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `date_creation` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `two_factor_secret` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom_utilisateur_UNIQUE` (`nom_utilisateur`),
  UNIQUE KEY `num_telephone_UNIQUE` (`num_telephone`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personne`
--

LOCK TABLES `personne` WRITE;
/*!40000 ALTER TABLE `personne` DISABLE KEYS */;
INSERT INTO `personne` VALUES (1000002,'tadjin','fares','1988-04-30','constantine','homme','z.izoub200320015@gmail.com','0512345678','fares','pbkdf2_sha256$600000$MKEF0R6jerQptdMWoOBzre$RGtmsqeGW35uJ4VfOrlqkePplcymlwG4rUBGfyb35Ys=',1,'2023-06-11 09:37:32.553918','2023-04-26 00:18:40.691920',0,NULL),(1000003,'BOURAOUI','ZAKARIA','2001-04-30','batna','homme','zizoub200320015@gmail.com','0561731855','zaki','pbkdf2_sha256$600000$ocW68Af2ifKz736CbsnVdG$xCwGRs7xH9epP+KGpcBLc/u3OuJFwc33sEqlN+/3ez8=',1,'2023-06-11 16:39:12.898645','2023-04-26 00:18:40.691920',0,'157354'),(1000004,'aouadek','malik','2002-06-03','constantine','homme','ziz.oub200320015@gmail.com','0561731857','malik','pbkdf2_sha256$600000$9v7itDcr53RluR4BSsOQOB$iS/4yL5Hq4DQ9kyo15B2MStQjxsWeUK+O+xyxlmdXJc=',1,'2023-06-11 18:46:57.116678','2023-04-26 00:18:40.691920',0,NULL),(1000005,'BOULEKROUNE','NADIA','1960-11-20','Constantine','femme','zi.zoub200320015@gmail.com','0561730001','nadia','pbkdf2_sha256$600000$BLg7iLNjwqKKrD7YqinAki$qwDAWursg3wUZBump+kWtiedOXI/bTk42rUWfVB5FNo=',1,'2023-06-11 18:46:43.003653','2023-05-07 23:56:37.640498',0,'459074'),(1000006,'khlefi','soumia','1980-02-22','sedrata','homme','zizo.ub200320015@gmail.com','056173185','soumia','pbkdf2_sha256$600000$2lmoSW87lwdjFAcmsQ8SNF$yc152KGCNq0oyuvb/6O2bOqnfq2/d1x/EGld0MH6Itg=',1,'2023-06-11 15:05:00.239553','2023-06-04 20:41:58.773472',0,NULL),(1000007,'merzage','azize','2023-05-28','alger','homme','zizou.b200320015@gmail.com','0561731860','bmtuvgpn','pbkdf2_sha256$600000$VL7rbdnoARzTOJGeIHNCDX$1SnSnjil+QQ0KDKwAmtSNtnr9tToeDf3kAzZUZv8jEU=',1,NULL,'2023-05-22 23:56:02.324732',0,NULL),(10000011,'HOUSSEM','ABADE','1991-10-09','Constantin','homme','abdelmadjidkahoul5@gmail.com','0658639917','houssem','pbkdf2_sha256$600000$orU5ZCZTeQtTLekiCX1k9B$wpgHhkVC9fy7Clpr75Blivq+JSLwSscga32bKmjJgbU=',1,'2023-06-10 01:59:06.062342','2023-06-09 22:33:14.917492',0,NULL),(10000012,'GHETOUTE','SAMI','1997-06-17','ORAN','homme','ab.delmadjidkahoul5@gmail.com','0542891916','tivcglym','pbkdf2_sha256$600000$WtxuG15v9Mepc2Zu9sQluZ$5hvZ1qEff1pKFDDJhn91x5JPpJtb7lNM1Sk8S/rX0mg=',1,NULL,'2023-06-09 23:53:05.010162',0,NULL),(10000013,'SMAILI','NOOR','1997-07-24','ALGER','femme','a.bdelmadjidkahoul5@gmail.com','0796196206','dxckzclt','pbkdf2_sha256$600000$VJ9FNr33xHsljyEzjJVTOH$c1XoevC8CqKjVyzEC7UCgisCBffPx2RySTLdJflz+/o=',1,NULL,'2023-06-09 23:51:10.499229',0,NULL),(10000014,'BOUDREAA','HAMZA','1987-03-12','ANABA','homme','abd.elmadjidkahoul5@gmail.com','0550325157','tepegjxn','pbkdf2_sha256$600000$jeE8Hm7ALh0fGNLdKomeXG$lcKEyMyw/m9B2wYdYEdrS/6ORPHGLEAYpR9usQn9FIk=',1,NULL,'2023-06-09 23:55:07.010850',0,NULL),(184984984,'aziz','tabbi','2002-06-22','mouzambik','homme','memoire.062023@gmail.com','0715654316','aziz','pbkdf2_sha256$600000$GCM6Xr7MLLyhfm7P0aIfGy$lF+B+k7MXPXwBUAueAi1Lcy6pOU0d9Mq8RFwerTF6DA=',1,'2023-06-10 23:27:18.551087','2023-06-09 17:49:06.899047',0,NULL),(1000003298,'redoune','yaser','1988-05-20','anaba','homme','zizoub20032015@gmail.com','056171475','yaser','pbkdf2_sha256$600000$dT7tujAejI1Pnno7iCNEap$xqU8ifcmmOHw5KlaopiqUJiIztaNADpi3zeQb++QBu0=',0,NULL,'2023-06-10 23:50:31.090486',0,NULL),(1003994888757,'benjeloul','sid ahmed','1990-06-01','batna','homme','zizoub20032.0015@gmail.com','063564778212','ben_ah','pbkdf2_sha256$600000$WVFWjANy2Jlg2tmgTVMl7J$pXAuyQ8wN44DcigfdryzIqdVe7DV/fj/YaNYNqNzoS4=',1,'2023-06-11 00:06:44.546050','2023-06-10 08:51:02.696395',0,NULL),(10003435356632,'boulazo','riheb','2000-05-31','annaba','femme','madjidgreezyboy17.@gmail.com','0658623917','xzwlksrw','pbkdf2_sha256$600000$jKGqw01AGopO6ntq3I2t7j$2dBXajXnkd0L2k9F6HUSInojjuSZShfEEiuwxM5/NCQ=',1,'2023-06-10 09:22:41.939126','2023-06-10 09:20:43.004002',0,NULL),(100020887151860008,'KAHOUL','ABDELMADJID','2002-12-04','Constantin','homme','zizoub200320.015@gmail.com','0123456789','bgkisjve','pbkdf2_sha256$600000$g8eJEZec0WKe3yckVvO65f$UJVJRut4VMgUR1WMZulUPVOb0aQcyMocn95dl6OKeh4=',1,NULL,'2023-06-11 14:25:45.241179',0,NULL);
/*!40000 ALTER TABLE `personne` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `insert_date_creation` BEFORE INSERT ON `personne` FOR EACH ROW SET NEW.date_creation = CURRENT_TIMESTAMP(6) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_last_login` BEFORE UPDATE ON `personne` FOR EACH ROW BEGIN
  IF NOT (OLD.last_login <=> NEW.last_login ) THEN
    SET NEW.last_login = CURRENT_TIMESTAMP(6);
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `personne_update_trigger` AFTER UPDATE ON `personne` FOR EACH ROW BEGIN
    DECLARE notification_content VARCHAR(500);
    
    IF NEW.nom <> OLD.nom THEN
        SET notification_content = CONCAT('The name was updated. New name: ', NEW.nom);
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.prenom <> OLD.prenom THEN
        SET notification_content = CONCAT('The first name was updated. New first name: ', NEW.prenom);
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.date_naissance <> OLD.date_naissance THEN
        SET notification_content = CONCAT('The date of birth was updated. New date of birth: ', NEW.date_naissance);
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.lieu_naissance <> OLD.lieu_naissance THEN
        SET notification_content = CONCAT('The place of birth was updated. New place of birth: ', NEW.lieu_naissance);
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.sex <> OLD.sex THEN
        SET notification_content = CONCAT('The gender was updated. New gender: ', NEW.sex);
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.email <> OLD.email THEN
        SET notification_content = CONCAT('The email was updated. New email: ', NEW.email);
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.num_telephone <> OLD.num_telephone THEN
        SET notification_content = CONCAT('The phone number was updated. New phone number: ', NEW.num_telephone);
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.nom_utilisateur <> OLD.nom_utilisateur THEN
        SET notification_content = CONCAT('The username was updated. New username: ', NEW.nom_utilisateur);
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.mot_passe <> OLD.mot_passe THEN
        SET notification_content = 'The password was updated.';
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    ELSEIF NEW.is_active <> OLD.is_active THEN
        IF NEW.is_active = 1 THEN
            SET notification_content = 'The account was activated. Welcome to QuickLab! If you have any questions, please contact us.';
        END IF;
        INSERT INTO notification (contenu, id_prs) VALUES (notification_content, NEW.id);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_update_last_login` AFTER UPDATE ON `personne` FOR EACH ROW BEGIN
    IF NEW.last_login <> OLD.last_login THEN
        INSERT INTO notification (contenu, id_prs)
        VALUES ( CONCAT('You have logged in at ', NOW(), '. Welcome back, ', NEW.prenom, ' '), NEW.id);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `poche_sang`
--

DROP TABLE IF EXISTS `poche_sang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poche_sang` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quantite_ml` int NOT NULL,
  `id_rdv` int NOT NULL,
  `is_accepted` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `poche_rdv_id_idx` (`id_rdv`),
  CONSTRAINT `poche_rdv_id` FOREIGN KEY (`id_rdv`) REFERENCES `rendez_vous` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `poche_sang`
--

LOCK TABLES `poche_sang` WRITE;
/*!40000 ALTER TABLE `poche_sang` DISABLE KEYS */;
/*!40000 ALTER TABLE `poche_sang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prix_analyse`
--

DROP TABLE IF EXISTS `prix_analyse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prix_analyse` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_lab` int DEFAULT NULL,
  `code_analyse` varchar(10) DEFAULT NULL,
  `prix` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_anlyse_lab_idx` (`id_lab`),
  KEY `code_anlyse_type_idx` (`code_analyse`),
  CONSTRAINT `code_anlyse_type` FOREIGN KEY (`code_analyse`) REFERENCES `type_analyse` (`code`) ON DELETE CASCADE,
  CONSTRAINT `id_anlyse_lab` FOREIGN KEY (`id_lab`) REFERENCES `laboratoire` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prix_analyse`
--

LOCK TABLES `prix_analyse` WRITE;
/*!40000 ALTER TABLE `prix_analyse` DISABLE KEYS */;
INSERT INTO `prix_analyse` VALUES (10,1001,'BCBC',124.00),(11,1001,'BCP',10.00),(14,1001,'BBT',10.00),(15,1001,'BHBSA',15.00),(16,1001,'BHCA',16.00),(17,1001,'BHIV',150.00),(18,1001,'BTPHA',200.00),(19,1001,'BAA',123.00),(20,1001,'BDA',200.00),(21,1001,'BLA',147.00),(23,1009,'BAA',16.00),(24,1009,'BCBC',77.00),(25,1009,'BHCA',77.00),(26,1009,'BHA',88.00);
/*!40000 ALTER TABLE `prix_analyse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion`
--

DROP TABLE IF EXISTS `promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date_debut` date NOT NULL,
  `date_fin` date NOT NULL,
  `pourcentage` decimal(5,2) NOT NULL,
  `description` text,
  `statut` enum('actif','inactif') NOT NULL,
  `lab_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pro_lab_id_idx` (`lab_id`),
  CONSTRAINT `pro_lab_id` FOREIGN KEY (`lab_id`) REFERENCES `laboratoire` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion`
--

LOCK TABLES `promotion` WRITE;
/*!40000 ALTER TABLE `promotion` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rapport`
--

DROP TABLE IF EXISTS `rapport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rapport` (
  `id` int NOT NULL,
  `med_id` int DEFAULT NULL,
  `rapport` text,
  `resultat_id` int DEFAULT NULL,
  `is_validate` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_med_rap_idx` (`med_id`),
  KEY `id_rap_res_idx` (`resultat_id`),
  CONSTRAINT `id_med_rap` FOREIGN KEY (`med_id`) REFERENCES `medecin_chef` (`id`) ON DELETE CASCADE,
  CONSTRAINT `id_rap_res` FOREIGN KEY (`resultat_id`) REFERENCES `resultat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rapport`
--

LOCK TABLES `rapport` WRITE;
/*!40000 ALTER TABLE `rapport` DISABLE KEYS */;
INSERT INTO `rapport` VALUES (60,100101004,NULL,60,0),(61,100101004,'Based on the test result that the patient underwent, it has been determined that they are 86.89% likely to have anemia. The test used various factors, such as Age, Sex, RBC, PCV, MCV, MCH, MCHC, RDW, TLC, PLT/mm3, HGB, among others, to arrive at this conclusion. It is important to note that while the test is highly accurate, it is not infallible, and additional tests and consultations with medical professionals may be required to confirm the diagnosis. Treatment and management of anemia may involve dietary changes, iron supplementation, and addressing the underlying causes. Regular follow-ups with healthcare providers are recommended for proper monitoring and care.',61,1),(62,100101004,'Based on the test result that the patient underwent, it has been determined that they are 92.68% likely to have anemia. The test used various factors, such as Age, Sex, RBC, PCV, MCV, MCH, MCHC, RDW, TLC, PLT/mm3, HGB, among others, to arrive at this conclusion. It is important to note that while the test is highly accurate, it is not infallible, and additional tests and consultations with medical professionals may be required to confirm the diagnosis. Treatment and management of anemia may involve dietary changes, iron supplementation, and addressing the underlying causes. Regular follow-ups with healthcare providers are recommended for proper monitoring and care.',62,0),(63,100101004,'Based on the test result that the patient underwent, it has been determined that they are 66.67% likely to have diabetes. The test used various factors, such as preg, gluco, bp, stinmm, insulin, mass, dpf, age, among others, to arrive at this conclusion. It is important to note that while the test is highly accurate, it is not infallible, and additional tests and consultations with medical professionals may be required to confirm the diagnosis. Additionally, it is crucial for the patient to receive proper treatment and make necessary lifestyle changes to manage the condition and prevent further complications. With proper care and management, individuals with diabetes can lead healthy and fulfilling lives.',63,0),(64,100101004,'Based on the test results, it appears that the patient 95.08% does not have a liver condition. However, these predictions are based on statistical models and should not be taken as a definitive diagnosis. It is recommended that the patient consult with a healthcare professional for further evaluation and testing.',64,0);
/*!40000 ALTER TABLE `rapport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receptionniste`
--

DROP TABLE IF EXISTS `receptionniste`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receptionniste` (
  `id` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `id_rec_emp` FOREIGN KEY (`id`) REFERENCES `employe` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receptionniste`
--

LOCK TABLES `receptionniste` WRITE;
/*!40000 ALTER TABLE `receptionniste` DISABLE KEYS */;
INSERT INTO `receptionniste` VALUES (100101005),(100901002),(100901003);
/*!40000 ALTER TABLE `receptionniste` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reclamation`
--

DROP TABLE IF EXISTS `reclamation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reclamation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reclamation_text` text,
  `patient_id` bigint DEFAULT NULL,
  `branche_id` int DEFAULT NULL,
  `reclamation_object` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rec_brch_id_idx` (`branche_id`),
  KEY `rec_pat_id_idx` (`patient_id`),
  CONSTRAINT `rec_brch_id` FOREIGN KEY (`branche_id`) REFERENCES `branche` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rec_pat_id` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reclamation`
--

LOCK TABLES `reclamation` WRITE;
/*!40000 ALTER TABLE `reclamation` DISABLE KEYS */;
INSERT INTO `reclamation` VALUES (8,'Upon receiving the results, I was shocked to discover several discrepancies and inconsistencies that have raised doubts about the accuracy and reliability of the analysis. I would like to bring the following issues to your attention:',1000003,100101,'regarding the analysis conducted by your laboratory'),(9,'Poor Customer Service: I found the customer service experience at your laboratory to be highly unsatisfactory. The staff members I interacted with demonstrated a lack of knowledge, professionalism, and courtesy. They were unresponsive to my queries and failed to provide adequate guidance throughout the process. It is essential for a service-oriented establishment to prioritize excellent customer service, and this aspect was severely lacking in my experience.',1000003,100101,'Unsatisfactory Service from Your Laboratory');
/*!40000 ALTER TABLE `reclamation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rendez_vous`
--

DROP TABLE IF EXISTS `rendez_vous`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rendez_vous` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `heur` time DEFAULT NULL,
  `analyes` text,
  `type_rdv` enum('domicile','labo') DEFAULT NULL,
  `etat` enum('urgent','normal','delay') DEFAULT 'normal',
  `purpose` enum('blood test','blood donation') DEFAULT NULL,
  `id_patient` bigint DEFAULT NULL,
  `branche_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_rend_patien _idx` (`id_patient`),
  KEY `rdv_brch_id_idx` (`branche_id`),
  CONSTRAINT `rdv_brch_id` FOREIGN KEY (`branche_id`) REFERENCES `branche` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rdv_pat_id` FOREIGN KEY (`id_patient`) REFERENCES `patient` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=341 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rendez_vous`
--

LOCK TABLES `rendez_vous` WRITE;
/*!40000 ALTER TABLE `rendez_vous` DISABLE KEYS */;
INSERT INTO `rendez_vous` VALUES (334,'2023-06-11','08:15:00','BCBC','labo','urgent','blood test',1000003,100101),(335,'2023-06-16','08:00:00','BCBC','labo','normal','blood test',1000003,100101),(336,'2023-06-11','08:22:30','BAA','labo','delay','blood test',1000003,100101),(337,'2023-06-15','08:15:00','BCP$BCBC','labo','normal','blood test',1000003,100101),(338,'2023-06-13','08:08:00','BLA','labo','normal','blood test',100020887151860008,100101),(339,'2023-06-11','08:08:00','BAA$BDA$BLA','labo','normal','blood test',1000003,100101),(340,'2023-06-11','08:08:00','BAA$BDA$BLA','labo','normal','blood test',1000003,100101);
/*!40000 ALTER TABLE `rendez_vous` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `insert_client_labo` AFTER INSERT ON `rendez_vous` FOR EACH ROW BEGIN
    INSERT IGNORE INTO client_labo (id_patient, id_labo)
    SELECT r.id_patient, b.labo
    FROM rendez_vous r
    INNER JOIN branche b ON r.branche_id = b.id
    WHERE r.branche_id = NEW.branche_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `add_notification_after_insert` AFTER INSERT ON `rendez_vous` FOR EACH ROW BEGIN
    DECLARE patient_id BIGINT;
    DECLARE patient_name VARCHAR(45);
    DECLARE notification_content TEXT;

    -- Get patient information
    SELECT id, CONCAT(nom, ' ', prenom) INTO patient_id, patient_name
    FROM personne
    WHERE id = NEW.id_patient;

    -- Create notification content
    SET notification_content = CONCAT('New rendez-vous created for patient ', patient_name);

    -- Insert notification row
    INSERT INTO notification (contenu, id_prs)
    VALUES (notification_content, patient_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_update_rendez_vous` AFTER UPDATE ON `rendez_vous` FOR EACH ROW BEGIN
  DECLARE patient_id BIGINT;
  DECLARE personne_id BIGINT;
  DECLARE rdv_time TIME;
  DECLARE rdv_date DATE;

  IF NEW.etat = 'delay' AND OLD.etat != 'delay' THEN
    -- Get the patient ID
    if new.heur > old.heur then 
    SELECT id_patient INTO patient_id FROM rendez_vous WHERE id = NEW.id;

    -- Get the person ID
    SELECT id INTO personne_id FROM patient WHERE id = patient_id;

    -- Get the new rendez-vous time
    SELECT heur INTO rdv_time FROM rendez_vous WHERE id = NEW.id;

    -- Get the new rendez-vous date
    SELECT date INTO rdv_date FROM rendez_vous WHERE id = NEW.id;

    -- Create the notification
    INSERT INTO notification (date, contenu, id_prs)
    VALUES (CURRENT_TIMESTAMP, CONCAT('Your appointment on ', rdv_date, ' has been changed from ', OLD.heur, ' to ', rdv_time, ' due to an emergency case. Please check your appointment.'), personne_id);
  END IF;
  END IF;
   IF NEW.etat = 'urgent' AND OLD.etat != 'urgent' THEN
    -- Get the patient ID
    SELECT id_patient INTO patient_id FROM rendez_vous WHERE id = NEW.id;

    -- Get the person ID
    SELECT id INTO personne_id FROM patient WHERE id = patient_id;

    -- Create the notification for urgent
    INSERT INTO notification (date, contenu, id_prs)
    VALUES (CURRENT_TIMESTAMP, CONCAT('Your appointment on ', NEW.date, ' at ', NEW.heur, ' has been marked as  emergency case. Please check your appointment.'), personne_id);
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `rdv_delete` BEFORE DELETE ON `rendez_vous` FOR EACH ROW BEGIN
    UPDATE facture SET rdv_id = NULL WHERE rdv_id = OLD.id;
    UPDATE payment SET rdv_id = NULL WHERE rdv_id = OLD.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `resultat`
--

DROP TABLE IF EXISTS `resultat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resultat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `resultat` text,
  `tube_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `res_tube_id_idx` (`tube_id`),
  CONSTRAINT `res_tube_id` FOREIGN KEY (`tube_id`) REFERENCES `tube_analyse` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resultat`
--

LOCK TABLES `resultat` WRITE;
/*!40000 ALTER TABLE `resultat` DISABLE KEYS */;
INSERT INTO `resultat` VALUES (60,'Red Blood Cells (RBC) > 1 > millions of cells/mcL$Hemoglobin (Hb) > 1 > grams/dL$Hematocrit (Hct) > 1 > %$White Blood Cells (WBC) > 1 > cells/mcL$Platelet Count > 1 > thousands/mcL$Mean Corpuscular Volume (MCV) > 1 > femtoliters$Mean Corpuscular Hemoglobin (MCH) > 1 > picograms$Mean Corpuscular Hemoglobin Concentration (MCHC) > 1 > grams/dL%$',100101003334112559),(61,'Red Blood Cell Count > 1 > Cells/ΜL$Packed Cell Volume > 1 > %$Mean Corpuscular Volume > 1 > FL$Mean Corpuscular Hemoglobin > 1 > Pg$Mean Corpuscular Hemoglobin Concentration > 1 > G/DL$Red Cell Distribution Width > 1 > %$Total Leukocyte Count > 1 > Cells/ΜL$Platelets > 1 > Cells/ΜL$Hemoglobin > 1 > G/DL$',100101003336112841),(62,'Red Blood Cell Count > 5.66 > Cells/ΜL$Packed Cell Volume > 34 > %$Mean Corpuscular Volume > 60.1 > FL$Mean Corpuscular Hemoglobin > 17 > Pg$Mean Corpuscular Hemoglobin Concentration > 28.2 > G/DL$Red Cell Distribution Width > 20 > %$Total Leukocyte Count > 11.1 > Cells/ΜL$Platelets > 128.3 > Cells/ΜL$Hemoglobin > 9.6 > G/DL$',100101003339144325),(63,'Number Of Times Pregnant > 0 > Nb$Plasma Glucose Concentration > 137 > Mg/DL$Diastolic Blood Pressure > 40 > Mm Hg$Triceps Skin Fold Thickness > 35 > Mm$2-Hour Serum Insulin > 168 > Mu U/Ml$Body Mass Index > 43.1 > Kg/(M^2)$Diabetes Pedigree Function > 2.228 > Dp$',100101003339144328),(64,'Total Bilirubin > 10.9 > Mg/DL$Direct Bilirubin > 5.5 > Mg/DL$Alkaline Phosphatase > 699 > IU/L$Alamine Aminotransferase > 64 > IU/L$Aspartate Aminotransferase > 100 > IU/L$Total Proteins > 7.5 > G/DL$Albumin > 3.2 > G/DL$Albumin And Globulin Ratio > 0.74 > AL/G\n$',100101003339144332);
/*!40000 ALTER TABLE `resultat` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `add_notification_after_result_insert` AFTER INSERT ON `resultat` FOR EACH ROW BEGIN
    DECLARE tube_id_val bigint;
    DECLARE rdv_val INT;
    DECLARE branche_id_val INT;
    
    -- Get tube_id from the inserted row
    SET tube_id_val = NEW.tube_id;

    -- Get rdv from tube_analyse table using tube_id
    SELECT rdv INTO rdv_val FROM tube_analyse WHERE id = tube_id_val;

    -- Get branche_id from rendez_vous table using rdv
    SELECT branche_id INTO branche_id_val FROM rendez_vous WHERE id = rdv_val;

    -- Insert notification for each medecin_chef with the same branche_id
    INSERT INTO notification (date, contenu, id_prs)
    SELECT CURRENT_TIMESTAMP, 'You have new results without a report. Please go to the results to check it.', p.id
    FROM medecin_chef mc
    INNER JOIN employe e ON mc.id = e.id
    INNER JOIN personne p ON p.id = e.id_prs
    WHERE e.id_branche = branche_id_val;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `resultat_rapport_pdf`
--

DROP TABLE IF EXISTS `resultat_rapport_pdf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resultat_rapport_pdf` (
  `id` bigint unsigned NOT NULL,
  `chemin` varchar(200) NOT NULL,
  `id_resultat` int DEFAULT NULL,
  `id_rapport` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_resultat_idx` (`id_resultat`),
  KEY `id_rapport_idx` (`id_rapport`),
  CONSTRAINT `id_rapport` FOREIGN KEY (`id_rapport`) REFERENCES `rapport` (`id`) ON DELETE CASCADE,
  CONSTRAINT `id_resultat` FOREIGN KEY (`id_resultat`) REFERENCES `resultat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resultat_rapport_pdf`
--

LOCK TABLES `resultat_rapport_pdf` WRITE;
/*!40000 ALTER TABLE `resultat_rapport_pdf` DISABLE KEYS */;
INSERT INTO `resultat_rapport_pdf` VALUES (10010120230611144717,'pdf\\result\\result-10010120230611144717.pdf',61,61);
/*!40000 ALTER TABLE `resultat_rapport_pdf` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_insert_resultat_rapport_pdf` AFTER INSERT ON `resultat_rapport_pdf` FOR EACH ROW BEGIN
    DECLARE id_patient_val bigint;
    DECLARE id_rapport_val int;
    DECLARE tube_id_val bigint;
    DECLARE rdv_val int;
    DECLARE id_personne_val bigint;

    -- Get id_patient from rendez_vous table using id_rapport
    SELECT rv.id_patient INTO id_patient_val
    FROM tube_analyse ta
    JOIN rendez_vous rv ON ta.rdv = rv.id
    WHERE ta.id = NEW.id_rapport;

    -- Get id_rapport from resultat_rapport_pdf table using NEW.id
    SELECT id_rapport INTO id_rapport_val
    FROM resultat_rapport_pdf
    WHERE id = NEW.id;

    -- Get tube_id from resultat table using resultat_id
    SELECT tube_id INTO tube_id_val
    FROM resultat
    WHERE id = id_rapport_val;

    -- Get rdv from tube_analyse table using tube_id
    SELECT rdv INTO rdv_val
    FROM tube_analyse
    WHERE id = tube_id_val;

    -- Get id_personne from rendez_vous table using rdv
    SELECT id_patient INTO id_personne_val
    FROM rendez_vous
    WHERE id = rdv_val;

    -- Insert into notification table
    INSERT INTO notification (date, contenu, id_prs,is_read)
    VALUES (CURRENT_TIMESTAMP(), CONCAT('Your test result has arrived. Please check it.'), id_personne_val,0);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `travail_infermier`
--

DROP TABLE IF EXISTS `travail_infermier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `travail_infermier` (
  `id_infermier` int NOT NULL,
  `id_rdv` int NOT NULL,
  `is_terminer` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_infermier`,`id_rdv`),
  KEY `id_rdv_travail_idx` (`id_rdv`),
  CONSTRAINT `id_infermier_travail` FOREIGN KEY (`id_infermier`) REFERENCES `infirmier` (`id`) ON DELETE CASCADE,
  CONSTRAINT `id_rdv_travail` FOREIGN KEY (`id_rdv`) REFERENCES `rendez_vous` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travail_infermier`
--

LOCK TABLES `travail_infermier` WRITE;
/*!40000 ALTER TABLE `travail_infermier` DISABLE KEYS */;
INSERT INTO `travail_infermier` VALUES (100101003,334,1),(100101003,335,0),(100101003,336,1),(100101003,337,0),(100101003,338,0),(100101003,339,1),(100101003,340,1);
/*!40000 ALTER TABLE `travail_infermier` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `travail_infermier_after_insert` AFTER INSERT ON `travail_infermier` FOR EACH ROW BEGIN
    DECLARE v_infirmier_id INT;
    DECLARE v_employe_id INT;
    DECLARE v_personne_id INT;
    
    -- Get infirmier id
    SELECT id_infermier INTO v_infirmier_id FROM travail_infermier WHERE id_infermier = NEW.id_infermier limit 1;
    
    -- Get employe id from infirmier
    SELECT id INTO v_employe_id FROM infirmier WHERE id = v_infirmier_id limit 1;
    
    -- Get personne id from employe
    SELECT id_prs INTO v_personne_id FROM employe WHERE id = v_employe_id limit 1;
    
    -- Create notification
    INSERT INTO notification (date, contenu, id_prs) VALUES (CURRENT_TIMESTAMP, 'You have a new appointment to work with. Please check your appointment list.', v_personne_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tube_analyse`
--

DROP TABLE IF EXISTS `tube_analyse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tube_analyse` (
  `id` bigint NOT NULL,
  `code_analyse` varchar(20) DEFAULT NULL,
  `infirmier` int DEFAULT NULL,
  `rdv` int DEFAULT NULL,
  `is_done` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_tube_rndv_idx` (`rdv`),
  KEY `id_tube_inf_idx` (`infirmier`),
  KEY `code_tube_analyse_idx` (`code_analyse`),
  CONSTRAINT `code_tube_analyse` FOREIGN KEY (`code_analyse`) REFERENCES `type_analyse` (`code`) ON DELETE CASCADE ON UPDATE SET NULL,
  CONSTRAINT `id_tube_inf` FOREIGN KEY (`infirmier`) REFERENCES `infirmier` (`id`) ON DELETE CASCADE ON UPDATE SET NULL,
  CONSTRAINT `id_tube_rndv` FOREIGN KEY (`rdv`) REFERENCES `rendez_vous` (`id`) ON DELETE CASCADE ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tube_analyse`
--

LOCK TABLES `tube_analyse` WRITE;
/*!40000 ALTER TABLE `tube_analyse` DISABLE KEYS */;
INSERT INTO `tube_analyse` VALUES (100101003334112559,'BCBC',100101003,334,1),(100101003336112841,'BAA',100101003,336,1),(100101003339144325,'BAA',100101003,339,1),(100101003339144328,'BDA',100101003,339,1),(100101003339144332,'BLA',100101003,339,1),(100101003340150253,'BAA',100101003,340,0),(100101003340150339,'BDA',100101003,340,0),(100101003340150356,'BLA',100101003,340,0);
/*!40000 ALTER TABLE `tube_analyse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `type_analyse`
--

DROP TABLE IF EXISTS `type_analyse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `type_analyse` (
  `code` varchar(20) NOT NULL,
  `type_analyse` varchar(100) DEFAULT NULL,
  `nom` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `type_analyse`
--

LOCK TABLES `type_analyse` WRITE;
/*!40000 ALTER TABLE `type_analyse` DISABLE KEYS */;
INSERT INTO `type_analyse` VALUES ('BAA','Blood Test','anemia analysis'),('BBMP','Blood Test','Basic Metabolic Panel (BMP)'),('BBT','Blood Test','Blood Typing'),('BCBC','Blood Test','Complete Blood Count (CBC)'),('BCMP','Blood Test','Comprehensive Metabolic Panel (CMP)'),('BCP','Blood Test','Coagulation Panel'),('BDA','Blood Test','diabetes analysis'),('BESR','Blood Test','Erythrocyte Sedimentation Rate (ESR)'),('BF','Blood Test','Folate'),('BHA','Blood Test','Hemoglobin A1c (HbA1c)'),('BHAT','Blood Test','HIV Antibody Test'),('BHBSA','Blood Test','HBS (Hepatitis B Surface Antigen)'),('BHCA','Blood Test','HCV (Hepatitis C Antibody)'),('BHIV','Blood Test','HIV (Human Immunodeficiency Virus)'),('BHP','Blood Test','Hepatitis Panel'),('BIP','Blood Test','Iron Panel'),('BLA','Blood Test','liver analysis'),('BLFT','Blood Test','Liver Function Tests (LFTs)'),('BLP','Blood Test','Lipid Panel'),('BTP','Blood Test','Thyroid Panel'),('BTPHA','Blood Test','TPHA (Treponema pallidum Hemagglutination Assay)'),('BVBL','Blood Test','Vitamin B12 Level'),('BVDL','Blood Test','Vitamin D Level');
/*!40000 ALTER TABLE `type_analyse` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `generate_code` BEFORE INSERT ON `type_analyse` FOR EACH ROW BEGIN 
    SET @type_initial = UPPER(LEFT(NEW.type_analyse, 1)); 
    SET @name_initial = ''; 
    SET @i = 1; 
    SET @word_count = LENGTH(NEW.nom) - LENGTH(REPLACE(NEW.nom, ' ', '')) + 1; 

    WHILE @i <= @word_count DO 
        SET @word = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(NEW.nom, ' ', @i), ' ', -1)); 
        IF LEFT(@word, 1) NOT REGEXP '[a-zA-Z]' THEN 
            SET @word = '';
        END IF; 
        SET @name_initial = CONCAT(@name_initial, UPPER(LEFT(@word, 1))); 
        SET @i = @i + 1; 
    END WHILE; 

    SET @code = CONCAT(@type_initial, @name_initial); 

    -- Check if code already exists and increment 
    SELECT COUNT(*) INTO @count FROM `type_analyse` WHERE `code` LIKE CONCAT(@code, '%'); 

    IF @count > 0 THEN 
        SET @code = CONCAT(@code, LPAD(@count, 1, '0')); 
    END IF; 

    -- Set the new code 
    SET NEW.code = @code; 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'quick_lab'
--

--
-- Dumping routines for database 'quick_lab'
--
/*!50003 DROP PROCEDURE IF EXISTS `DeleteBloodBags` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteBloodBags`(
  IN blood_type ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-'),
  IN id_lab INT,
  IN bags_to_delete INT
)
BEGIN
  DELETE ps
  FROM poche_sang ps
  JOIN (
    SELECT ps.id
    FROM poche_sang ps
    JOIN rendez_vous rv ON ps.id_rdv = rv.id
    JOIN patient p ON rv.id_patient = p.id
    JOIN branche b ON rv.branche_id = b.id
    JOIN laboratoire l ON b.labo = l.id
    WHERE p.type_sang = blood_type AND l.id = id_lab
    LIMIT bags_to_delete
  ) AS ps_to_delete ON ps.id = ps_to_delete.id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAppointmentsByInfermierId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAppointmentsByInfermierId`(IN infermier_id int)
BEGIN
    SELECT personne.id AS personne_id, personne.nom, personne.prenom, personne.date_naissance, rendez_vous.id, rendez_vous.date, rendez_vous.heur, rendez_vous.type_rdv, rendez_vous.purpose
    FROM personne, rendez_vous, travail_infermier, patient
    WHERE travail_infermier.is_terminer = FALSE
    AND travail_infermier.id_infermier = infermier_id
    AND travail_infermier.id_rdv = rendez_vous.id
    AND rendez_vous.id_patient = patient.id
    AND patient.id = personne.id
    AND rendez_vous.date = CURDATE();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAppointmentsFinishByInfermierId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAppointmentsFinishByInfermierId`(IN infermier_id int)
BEGIN
    SELECT personne.id AS personne_id, personne.nom, personne.prenom, personne.date_naissance, rendez_vous.date, rendez_vous.id, rendez_vous.heur, rendez_vous.type_rdv, rendez_vous.purpose
    FROM personne
    INNER JOIN patient ON patient.id = personne.id
    INNER JOIN rendez_vous ON rendez_vous.id_patient = patient.id
    INNER JOIN travail_infermier ON travail_infermier.id_rdv = rendez_vous.id
    WHERE travail_infermier.is_terminer = TRUE
    AND travail_infermier.id_infermier = infermier_id
    AND rendez_vous.date = CURDATE();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetBloodBagsCount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBloodBagsCount`(IN id_lab INT)
BEGIN
  SELECT
    b.branche_nom,
    SUM(CASE WHEN p.type_sang = 'A+' THEN 1 ELSE 0 END) AS A_positive,
    SUM(CASE WHEN p.type_sang = 'A-' THEN 1 ELSE 0 END) AS A_negative,
    SUM(CASE WHEN p.type_sang = 'B+' THEN 1 ELSE 0 END) AS B_positive,
    SUM(CASE WHEN p.type_sang = 'B-' THEN 1 ELSE 0 END) AS B_negative,
    SUM(CASE WHEN p.type_sang = 'AB+' THEN 1 ELSE 0 END) AS AB_positive,
    SUM(CASE WHEN p.type_sang = 'AB-' THEN 1 ELSE 0 END) AS AB_negative,
    SUM(CASE WHEN p.type_sang = 'O+' THEN 1 ELSE 0 END) AS O_positive,
    SUM(CASE WHEN p.type_sang = 'O-' THEN 1 ELSE 0 END) AS O_negative
  FROM
    patient p
    INNER JOIN rendez_vous rv ON p.id = rv.id_patient
    INNER JOIN poche_sang ps ON rv.id = ps.id_rdv
    INNER JOIN branche b ON rv.branche_id = b.id
    INNER JOIN laboratoire l ON b.labo = l.id
  WHERE
    l.id = id_lab
  GROUP BY
    b.branche_nom;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetReclamationDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetReclamationDetails`(IN lab_id INT)
BEGIN
    SELECT personne.nom AS nom, personne.prenom AS prenom, reclamation.id AS rec_id, reclamation.reclamation_object AS object, reclamation.reclamation_text AS text
    FROM personne, reclamation, patient, branche
    WHERE reclamation.patient_id = patient.id
    AND patient.id = personne.id
    AND reclamation.branche_id = branche.id
    AND branche.labo = lab_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_demande_lab` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_demande_lab`()
BEGIN
    SELECT personne.id AS id_der, personne.nom AS nom, personne.prenom AS prenom,
           laboratoire.id AS lab_id, laboratoire.nom AS lab_name,
           abonnement.montant AS prix, abonnement.date_fin AS date
    FROM laboratoire, directeur, abonnement, personne
    WHERE personne.id = directeur.id
        AND directeur.id_lab = laboratoire.id
        AND abonnement.id_lab = laboratoire.id
        and abonnement.statut = 'en attente';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_lab` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_lab`(in is_activ TINYINT(1))
BEGIN
    SELECT personne.id AS id_der, personne.nom AS nom, personne.prenom AS prenom,
           laboratoire.id AS lab_id, laboratoire.nom AS lab_name,
           abonnement.montant AS prix, abonnement.date_fin AS date
    FROM laboratoire, directeur, abonnement, personne
    WHERE personne.id = directeur.id
        AND directeur.id_lab = laboratoire.id
        AND abonnement.id_lab = laboratoire.id
        and personne.is_active = is_activ
        and abonnement.statut = 'actif';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_results` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_results`(IN infirmier_id INT)
BEGIN
    SELECT tube_analyse.id AS tube_id, type_analyse.nom AS name_analyse, personne.prenom, personne.nom, rendez_vous.date as date_rdv
    FROM personne, type_analyse, tube_analyse, rendez_vous, patient
    WHERE tube_analyse.is_done = FALSE
        AND tube_analyse.infirmier = infirmier_id
        AND tube_analyse.code_analyse = type_analyse.code
        AND tube_analyse.rdv = rendez_vous.id
        AND rendez_vous.id_patient = patient.id
        AND patient.id = personne.id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SearchResult` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchResult`(IN patientId BIGINT, IN appointmentDate DATE, IN brancheId int)
BEGIN
    IF patientId IS NOT NULL AND appointmentDate IS NOT NULL THEN
        SELECT rendez_vous.date as date, personne.nom as nom, personne.prenom as prenom, type_analyse.nom as analyse_name, resultat_rapport_pdf.chemin as pdf_chemin
        FROM rendez_vous
        JOIN personne ON rendez_vous.id_patient = personne.id
        JOIN patient ON rendez_vous.id_patient = patient.id
        JOIN tube_analyse ON tube_analyse.rdv = rendez_vous.id
        JOIN type_analyse ON tube_analyse.code_analyse = type_analyse.code
        JOIN resultat ON resultat.tube_id = tube_analyse.id
        JOIN resultat_rapport_pdf ON resultat_rapport_pdf.id_resultat = resultat.id
        WHERE rendez_vous.id_patient = patientId
        AND rendez_vous.date = appointmentDate
        AND rendez_vous.branche_id = brancheId;
    ELSEIF patientId IS NOT NULL AND appointmentDate IS NULL THEN
        SELECT rendez_vous.date as date, personne.nom as nom, personne.prenom as prenom, type_analyse.nom as analyse_name, resultat_rapport_pdf.chemin as pdf_chemin
        FROM rendez_vous
        JOIN personne ON rendez_vous.id_patient = personne.id
        JOIN patient ON rendez_vous.id_patient = patient.id
        JOIN tube_analyse ON tube_analyse.rdv = rendez_vous.id
        JOIN type_analyse ON tube_analyse.code_analyse = type_analyse.code
        JOIN resultat ON resultat.tube_id = tube_analyse.id
        JOIN resultat_rapport_pdf ON resultat_rapport_pdf.id_resultat = resultat.id
        WHERE rendez_vous.id_patient = patientId
        AND rendez_vous.branche_id = brancheId;
    ELSEIF patientId IS NULL AND appointmentDate IS NOT NULL THEN
        SELECT rendez_vous.date as date, personne.nom as nom, personne.prenom as prenom, type_analyse.nom as analyse_name, resultat_rapport_pdf.chemin as pdf_chemin
        FROM rendez_vous
        JOIN personne ON rendez_vous.id_patient = personne.id
        JOIN patient ON rendez_vous.id_patient = patient.id
        JOIN tube_analyse ON tube_analyse.rdv = rendez_vous.id
        JOIN type_analyse ON tube_analyse.code_analyse = type_analyse.code
        JOIN resultat ON resultat.tube_id = tube_analyse.id
        JOIN resultat_rapport_pdf ON resultat_rapport_pdf.id_resultat = resultat.id
        WHERE rendez_vous.date = appointmentDate
        AND rendez_vous.branche_id = brancheId;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SearchResultPatient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchResultPatient`(IN patientId BIGINT)
BEGIN
    SELECT rendez_vous.date as date, type_analyse.nom as analyse_name, resultat_rapport_pdf.chemin as pdf_chemin, laboratoire.nom as labo_nom, branche.branche_nom as branche_nom
    FROM rendez_vous
    JOIN personne ON rendez_vous.id_patient = personne.id
    JOIN patient ON rendez_vous.id_patient = patient.id
    JOIN tube_analyse ON tube_analyse.rdv = rendez_vous.id
    JOIN type_analyse ON tube_analyse.code_analyse = type_analyse.code
    JOIN resultat ON resultat.tube_id = tube_analyse.id
    JOIN branche ON branche.id = rendez_vous.branche_id
    JOIN laboratoire on laboratoire.id = branche.labo
    JOIN resultat_rapport_pdf ON resultat_rapport_pdf.id_resultat = resultat.id
    WHERE rendez_vous.id_patient = patientId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SelectResultsByBranchId_blood_donation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SelectResultsByBranchId_blood_donation`(IN branchId int)
BEGIN
    SELECT
		rendez_vous.id as id,
        personne.prenom AS prenom,
        personne.nom AS nom,
        rendez_vous.date AS date
    FROM
        rendez_vous,
        personne,
        patient
    WHERE
        rendez_vous.purpose = 'blood donation'
        AND rendez_vous.id_patient = patient.id
        AND patient.id = personne.id
        AND rendez_vous.branche_id = branchId
        AND rendez_vous.id IN (
            SELECT DISTINCT tube_analyse.rdv AS rdv_id
            FROM tube_analyse
            JOIN resultat ON tube_analyse.id = resultat.tube_id
            JOIN rendez_vous ON tube_analyse.rdv = rendez_vous.id
            WHERE tube_analyse.code_analyse IN ('BBT', 'BHBSA', 'BHCA', 'BHIV', 'BTPHA')
                AND tube_analyse.is_done = true
                AND (
                    EXISTS (
                        SELECT 1
                        FROM rapport
                        WHERE resultat.id = rapport.resultat_id
                            AND rapport.is_validate = false
                    )
                    OR NOT EXISTS (
                        SELECT 1
                        FROM rapport
                        WHERE resultat.id = rapport.resultat_id
                    )
                )
        );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SelectResultsByBranchId_blood_test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SelectResultsByBranchId_blood_test`(IN branchId int)
BEGIN
    SELECT
        resultat.id AS id_res,
        personne.prenom AS prenom,
        personne.nom AS nom,
        rendez_vous.date AS date,
        type_analyse.nom AS analyse_nom
    FROM
        resultat
        JOIN tube_analyse ON resultat.tube_id = tube_analyse.id
        JOIN rendez_vous ON tube_analyse.rdv = rendez_vous.id
        JOIN patient ON rendez_vous.id_patient = patient.id
        JOIN personne ON patient.id = personne.id
        JOIN type_analyse ON tube_analyse.code_analyse = type_analyse.code
        LEFT JOIN rapport ON resultat.id = rapport.resultat_id
    WHERE
        rendez_vous.branche_id = branchId
        AND rendez_vous.purpose = 'blood test'
        AND (
            rapport.is_validate = false
            OR rapport.resultat_id IS NULL
        );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_travail_infermier` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_travail_infermier`(
    IN rdv_id INT
)
BEGIN    
    
        UPDATE travail_infermier
        SET is_terminer = 1
        WHERE id_rdv = rdv_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-12 23:41:31
