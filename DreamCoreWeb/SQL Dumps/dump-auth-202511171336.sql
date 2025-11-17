/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: auth
-- ------------------------------------------------------
-- Server version	10.11.13-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `username` varchar(32) NOT NULL DEFAULT '',
  `salt` binary(32) NOT NULL,
  `verifier` binary(32) NOT NULL,
  `session_key_auth` binary(40) DEFAULT NULL,
  `session_key_bnet` varbinary(64) DEFAULT NULL,
  `totp_secret` varbinary(128) DEFAULT NULL,
  `email` varchar(255) NOT NULL DEFAULT '',
  `reg_mail` varchar(255) NOT NULL DEFAULT '',
  `joindate` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_ip` varchar(64) NOT NULL DEFAULT '127.0.0.1',
  `last_attempt_ip` varchar(64) NOT NULL DEFAULT '127.0.0.1',
  `failed_logins` int(10) unsigned NOT NULL DEFAULT 0,
  `locked` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `lock_country` varchar(2) NOT NULL DEFAULT '00',
  `last_login` timestamp NULL DEFAULT NULL,
  `online` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `expansion` tinyint(3) unsigned NOT NULL DEFAULT 10,
  `mutetime` bigint(20) NOT NULL DEFAULT 0,
  `mutereason` varchar(255) NOT NULL DEFAULT '',
  `muteby` varchar(50) NOT NULL DEFAULT '',
  `client_build` int(10) unsigned NOT NULL DEFAULT 0,
  `locale` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `os` varchar(4) NOT NULL DEFAULT '',
  `timezone_offset` smallint(6) NOT NULL DEFAULT 0,
  `recruiter` int(10) unsigned NOT NULL DEFAULT 0,
  `battlenet_account` int(10) unsigned DEFAULT NULL,
  `battlenet_index` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_username` (`username`),
  UNIQUE KEY `uk_bnet_acc` (`battlenet_account`,`battlenet_index`),
  CONSTRAINT `fk_bnet_acc` FOREIGN KEY (`battlenet_account`) REFERENCES `battlenet_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Account System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES
(2,'2#1','Íİe#A¾mŠ¸\rVÔªUK×$I¬ÌÑ×9€ÅÍüT1±','ÉªŒdXË®J­R·|4Q‹r©Û¿6L¾@V^út',NULL,'\"&M\'S+¥Ò§˜4¹Zÿ-ıi>(¿T:d!LƒÖ‚¦BN¡n„',NULL,'ONI@DEVUNIT.COM','ONI@DEVUNIT.COM','2025-11-02 22:07:44','68.52.131.133','68.52.131.133',0,0,'00','2025-11-11 02:03:59',0,10,0,'','',64270,0,'Wn64',-360,0,2,1),
(3,'3#1','k1§³%ª—³gÿZ/!ïÀŸŸ72z¼&SÎ†ù|Ô_','\rY•Ÿ$‹ş)gb n¹,NÓòÚıéCù ~“1€',NULL,'pp­!–K\ZP·‚króµr›b§O/îu²âOÕ:í¹tRi¨Ö‰’/şÊ)z}%Ù’\"Ì\rÅÀ?Hx9Kş',NULL,'AZAR@DEVUNIT.COM','AZAR@DEVUNIT.COM','2025-11-02 22:09:46','189.60.169.35','189.60.169.35',0,0,'00','2025-11-11 13:33:47',0,10,0,'','',64270,0,'Wn64',-180,0,3,1),
(4,'4#1','&¨X1Á$Quá%f>0°×\ZËC5\ZàhXÌ ®','ZF?¬|§8Â Şœ€ÀÁÜğ’~Ø9\Z‡	W\0ìó&n',NULL,NULL,NULL,'ADMIN@THE-DEMIURGE.COM','ADMIN@THE-DEMIURGE.COM','2025-11-05 14:29:06','127.0.0.1','127.0.0.1',0,0,'00',NULL,0,10,0,'','',64154,0,'',0,0,4,1),
(5,'5#1','À´ì¬¦çu!?A£¡ş½É![öŸ,ÓOJ¥\rˆûÒ','Ş¿âƒÍ„”%+†â|Ívİ.è~©—fF¬b^è F_',NULL,NULL,NULL,'GM@THE-DEMIURGE.COM','GM@THE-DEMIURGE.COM','2025-11-05 14:37:54','127.0.0.1','127.0.0.1',0,0,'00',NULL,0,10,0,'','',64154,0,'',0,0,5,1),
(6,'GMSOAP','æe|‚.[ä$´0åY1_—öÊ£\Z“¶ñ@æI0','ößøKG\Zºäœêõó]ÜL…8®Û\\-¨.ÖSs\0ÚG6',NULL,NULL,NULL,'','','2025-11-05 15:28:26','127.0.0.1','127.0.0.1',0,0,'00',NULL,0,10,0,'','',64154,0,'',0,0,5,2),
(8,'7#1','”ØrÆ†?Ä_Á\\L/#úİin+údÁãÑéÛ@¶¨','©şh™Ù:ã%%xõÎ…§óJJÌ¿»6Q¨nïúE',NULL,'\"\0:\"`[4\\H)â!ó°<î„ˆÑËƒ	<Øˆædãï•Ê¯ö-‚ı(\r',NULL,'HUNTER.GOLDENSTONE1@GMAIL.COM','HUNTER.GOLDENSTONE1@GMAIL.COM','2025-11-05 16:41:35','142.90.232.150','142.90.232.150',0,0,'00','2025-11-09 21:07:34',0,10,0,'','',64270,0,'Wn64',-300,0,7,1),
(19,'15#1','VÌ\ZöãWfĞ\0ˆt ²&í/ÊïjÒW™<à',' 94‚â=v†«ª?_âàBãQÏ‹ÈŞèÄ¶/C&²7',NULL,'~‡2öQà‡\'a5u@èèœ ¬ò ÅW•‡WC¨tP#Ú•øÉ^3Ğ',NULL,'FATCAT@ADMIN.COM','FATCAT@ADMIN.COM','2025-11-06 01:54:26','67.183.2.55','67.183.2.55',0,0,'00','2025-11-06 02:02:57',0,10,0,'','',64154,0,'Wn64',-480,0,15,1),
(42,'31#1','\\·lr1\n³$LÆç¸~˜‰¢\'Ø*¥PÊ§9­k','ˆƒ;ÖŞÉvn|LÎV^8§·,F÷¼–‚âEÚ³†',NULL,'\ZÇÅª7\0ÉFÃì$Ø•&ßÚxï{×&\n…²¦r$)oÈûÍ`»18',NULL,'BLINKOUTATIME@YAHOO.COM','BLINKOUTATIME@YAHOO.COM','2025-11-07 03:57:05','24.167.252.55','24.167.252.55',0,0,'00','2025-11-11 00:33:47',0,10,0,'','',64270,0,'Wn64',-360,0,31,1),
(43,'32#1','˜¼dˆŞ\ZE‘J@j^’¸‡Ï™^šÔ…·\ZFš«','Ñ/Ü[ÎgĞ†ó«ë1\0<Ğrƒ<V5Tb†ºÓ9:\'Ä4',NULL,NULL,NULL,'GTFAUTO@GMAIL.COM','GTFAUTO@GMAIL.COM','2025-11-07 04:16:41','127.0.0.1','127.0.0.1',0,0,'00',NULL,0,10,0,'','',64154,0,'',0,0,32,1),
(44,'33#1','üæ–İæ£%2M}ÑBø\nêTÃ3$üªõüA>‚ÿqÆ','\"­­kÇ|ÙûØH[›•©Ñ$±Kø¤›/A',NULL,NULL,NULL,'NEWBLINKGUY182@YAHOO.COM','NEWBLINKGUY182@YAHOO.COM','2025-11-08 23:19:26','127.0.0.1','127.0.0.1',0,0,'00',NULL,0,10,0,'','',0,0,'',0,0,33,1),
(45,'34#1',':ß~*z¡ËšTƒÉµ—Qd34ô?¿—Bm³}_ˆ','{YŸÌ$²zê:19ıšfÍb…½9Ÿ]]}T¡U',NULL,NULL,NULL,'MIDNIGHTSIN09@OUTLOOK.COM','MIDNIGHTSIN09@OUTLOOK.COM','2025-11-08 23:24:45','127.0.0.1','127.0.0.1',0,0,'00',NULL,0,10,0,'','',0,0,'',0,0,34,1),
(46,'35#1','É)¢©\Z&×§Y;\nîéálË¦kÅ¸©ü\rÌ°’ª','Ï‚¢\"VØ–7œüÇ›ñOÉ\n\0òH˜r…¢äËQŠ@',NULL,'¸Ãiûğ{jïVÅ8ÔÏîRÈlPÓhâáıIoãŠÁØgÏpWP:',NULL,'RENWIZARD@GMAIL.COM','RENWIZARD@GMAIL.COM','2025-11-08 23:26:28','174.31.103.187','174.31.103.187',0,0,'00','2025-11-11 23:12:01',0,10,0,'','',64270,0,'Wn64',-480,0,35,1),
(47,'36#1','Óğd[ØLg`Ñ,VRu„ÿ÷6•¬×#^mzù¿\"^ª','‡¯ld¢R€\ZèK˜A=®¥‚:­Â«ò¾›¤á\n',NULL,'y¦r|9ğE¿ÿomp…“ÚôŒXïèã_WÒ(0cf„úR<¥û',NULL,'BRADLEYRIEDSTRA09@GMAIL.COM','BRADLEYRIEDSTRA09@GMAIL.COM','2025-11-08 23:37:27','70.26.174.8','70.26.174.8',0,0,'00','2025-11-10 19:21:09',0,10,0,'','',64270,0,'Wn64',-300,0,36,1),
(48,'37#1','Ÿ9ıØL¹uÅB®(\'3,1¸÷şÕQ­ö åEF‚øÕ','~ğfå>%/cø;®É\n^Ô!¸^*ˆ~£ä¬DmØœŒ0',NULL,'Ûbûº;iqå~zšù,_ÛM»{b÷şí×Á uNXÃÙÛê¶àé=',NULL,'SHINJOX@HARBORNET.COM','SHINJOX@HARBORNET.COM','2025-11-08 23:45:45','73.225.231.43','73.225.231.43',0,0,'00','2025-11-11 13:51:54',0,10,0,'','',64270,0,'Wn64',-480,0,37,1),
(49,'38#1','Ìş£üôHU§’¯\0ôoßæ’¥ÕT\rF‚<KV„a¥','û×¨f°;_”!ª#ºï‘¼îşª,¿€È…í­1m',NULL,NULL,NULL,'DARKTAU21@YAHOO.COM','DARKTAU21@YAHOO.COM','2025-11-09 02:29:24','127.0.0.1','127.0.0.1',0,0,'00',NULL,0,10,0,'','',0,0,'',0,0,38,1),
(51,'40#1','rÊùw¯†T…&\n«äÄ¨˜ê¹º‡ch·57á7±„','}k*&<0Ş(¾9+çh`,	‡m”¼KÛğ¿Øİ‹wêI',NULL,'€’­ñèÉó«ÂLÎÓl\0t‹YßL‹YÙ0×´—^!ÛZÜmûä6±',NULL,'SEREOPPI96@HOTMAIL.COM','SEREOPPI96@HOTMAIL.COM','2025-11-09 07:52:59','47.162.81.247','47.162.81.247',0,0,'00','2025-11-10 01:34:55',0,10,0,'','',64270,0,'Wn64',-360,0,40,1),
(53,'42#1','6*Ä¼(ê=x,%óA×ZtÑ©~ŒØàqÂhedã','Š€‰ÿK¤5òû²\0İÌºŞ*ãÄ·k‹#aĞ›c²83',NULL,'2ñíY÷–5vu‚D:&+©æ\"øt:ï•EÅé÷ğ”r²\0ö',NULL,'JAKEG23@YAHOO.COM','JAKEG23@YAHOO.COM','2025-11-11 03:36:15','69.53.4.178','69.53.4.178',0,0,'00','2025-11-11 04:07:39',0,10,0,'','',64270,0,'Wn64',-300,0,42,1),
(56,'45#1','‹4{Í°:ü\0ÿ´\"O·eÌ%ç¨s°\0dŸôv:¨õßH','A÷¾¬îK½w²ŞG}{g¢ñúbU†Í”X÷',NULL,'úÓN\0\"N˜2ùÑ†Ò_­;=0‡:Ò‚+äÇÒ¶—úª9Ã;•-»²’”',NULL,'KHSKRIS@GMAIL.COM','KHSKRIS@GMAIL.COM','2025-11-11 04:10:40','75.164.134.159','75.164.134.159',0,0,'00','2025-11-11 15:26:22',0,10,0,'','',64270,0,'Wn64',-480,0,45,1);
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_access`
--

DROP TABLE IF EXISTS `account_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_access` (
  `AccountID` int(10) unsigned NOT NULL,
  `SecurityLevel` tinyint(3) unsigned NOT NULL,
  `RealmID` int(11) NOT NULL DEFAULT -1,
  `Comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`AccountID`,`RealmID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_access`
--

LOCK TABLES `account_access` WRITE;
/*!40000 ALTER TABLE `account_access` DISABLE KEYS */;
INSERT INTO `account_access` VALUES
(1,3,-1,NULL),
(2,3,-1,NULL),
(6,3,-1,NULL),
(42,3,-1,NULL);
/*!40000 ALTER TABLE `account_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_banned`
--

DROP TABLE IF EXISTS `account_banned`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_banned` (
  `id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Account id',
  `bandate` int(10) unsigned NOT NULL DEFAULT 0,
  `unbandate` int(10) unsigned NOT NULL DEFAULT 0,
  `bannedby` varchar(50) NOT NULL,
  `banreason` varchar(255) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ban List';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_banned`
--

LOCK TABLES `account_banned` WRITE;
/*!40000 ALTER TABLE `account_banned` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_banned` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_last_played_character`
--

DROP TABLE IF EXISTS `account_last_played_character`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_last_played_character` (
  `accountId` int(10) unsigned NOT NULL,
  `region` tinyint(3) unsigned NOT NULL,
  `battlegroup` tinyint(3) unsigned NOT NULL,
  `realmId` int(10) unsigned DEFAULT NULL,
  `characterName` varchar(12) DEFAULT NULL,
  `characterGUID` bigint(20) unsigned DEFAULT NULL,
  `lastPlayedTime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`accountId`,`region`,`battlegroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_last_played_character`
--

LOCK TABLES `account_last_played_character` WRITE;
/*!40000 ALTER TABLE `account_last_played_character` DISABLE KEYS */;
INSERT INTO `account_last_played_character` VALUES
(2,1,1,1,'Oni',6,1762827807),
(3,1,1,1,'Azar',3,1762642132),
(8,1,1,1,'Natsume',4,1762724628),
(42,1,1,1,'Spyro',14,1762830750),
(46,1,1,1,'Lorric',7,1762903033),
(47,1,1,1,'Midnightsin',11,1762802856),
(48,1,1,1,'Niwa',10,1762869654),
(51,1,1,1,'Kathris',12,1762742461),
(53,1,1,1,'Assblaster',15,1762835081),
(56,1,1,1,'Krys',16,1762836178);
/*!40000 ALTER TABLE `account_last_played_character` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_muted`
--

DROP TABLE IF EXISTS `account_muted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_muted` (
  `guid` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `mutedate` int(10) unsigned NOT NULL DEFAULT 0,
  `mutetime` int(10) unsigned NOT NULL DEFAULT 0,
  `mutedby` varchar(50) NOT NULL,
  `mutereason` varchar(255) NOT NULL,
  PRIMARY KEY (`guid`,`mutedate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='mute List';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_muted`
--

LOCK TABLES `account_muted` WRITE;
/*!40000 ALTER TABLE `account_muted` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_muted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `autobroadcast`
--

DROP TABLE IF EXISTS `autobroadcast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `autobroadcast` (
  `realmid` int(11) NOT NULL DEFAULT -1,
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `weight` tinyint(3) unsigned DEFAULT 1,
  `text` longtext NOT NULL,
  PRIMARY KEY (`id`,`realmid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `autobroadcast`
--

LOCK TABLES `autobroadcast` WRITE;
/*!40000 ALTER TABLE `autobroadcast` DISABLE KEYS */;
/*!40000 ALTER TABLE `autobroadcast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battle_pet_declinedname`
--

DROP TABLE IF EXISTS `battle_pet_declinedname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battle_pet_declinedname` (
  `guid` bigint(20) NOT NULL,
  `genitive` varchar(12) NOT NULL DEFAULT '',
  `dative` varchar(12) NOT NULL DEFAULT '',
  `accusative` varchar(12) NOT NULL DEFAULT '',
  `instrumental` varchar(12) NOT NULL DEFAULT '',
  `prepositional` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`guid`),
  CONSTRAINT `fk_battle_pet__battle_pet_declinedname` FOREIGN KEY (`guid`) REFERENCES `battle_pets` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battle_pet_declinedname`
--

LOCK TABLES `battle_pet_declinedname` WRITE;
/*!40000 ALTER TABLE `battle_pet_declinedname` DISABLE KEYS */;
/*!40000 ALTER TABLE `battle_pet_declinedname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battle_pet_slots`
--

DROP TABLE IF EXISTS `battle_pet_slots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battle_pet_slots` (
  `id` tinyint(4) NOT NULL,
  `battlenetAccountId` int(11) NOT NULL,
  `battlePetGuid` bigint(20) NOT NULL,
  `locked` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`,`battlenetAccountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battle_pet_slots`
--

LOCK TABLES `battle_pet_slots` WRITE;
/*!40000 ALTER TABLE `battle_pet_slots` DISABLE KEYS */;
INSERT INTO `battle_pet_slots` VALUES
(0,2,0,1),
(0,3,0,1),
(0,7,0,1),
(0,31,0,1),
(0,35,0,1),
(0,36,1,0),
(0,37,2,0),
(0,40,0,1),
(0,42,0,1),
(0,45,0,1),
(1,2,0,1),
(1,3,0,1),
(1,7,0,1),
(1,31,0,1),
(1,35,0,1),
(1,36,0,1),
(1,37,0,1),
(1,40,0,1),
(1,42,0,1),
(1,45,0,1),
(2,2,0,1),
(2,3,0,1),
(2,7,0,1),
(2,31,0,1),
(2,35,0,1),
(2,36,0,1),
(2,37,0,1),
(2,40,0,1),
(2,42,0,1),
(2,45,0,1);
/*!40000 ALTER TABLE `battle_pet_slots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battle_pets`
--

DROP TABLE IF EXISTS `battle_pets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battle_pets` (
  `guid` bigint(20) NOT NULL,
  `battlenetAccountId` int(11) NOT NULL,
  `species` int(11) NOT NULL,
  `breed` smallint(6) NOT NULL,
  `displayId` int(11) NOT NULL DEFAULT 0,
  `level` smallint(6) NOT NULL DEFAULT 1,
  `exp` smallint(6) NOT NULL DEFAULT 0,
  `health` int(11) NOT NULL DEFAULT 1,
  `quality` tinyint(4) NOT NULL DEFAULT 0,
  `flags` smallint(6) NOT NULL DEFAULT 0,
  `name` varchar(12) NOT NULL,
  `nameTimestamp` bigint(20) NOT NULL DEFAULT 0,
  `owner` bigint(20) DEFAULT NULL,
  `ownerRealmId` int(11) DEFAULT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battle_pets`
--

LOCK TABLES `battle_pets` WRITE;
/*!40000 ALTER TABLE `battle_pets` DISABLE KEYS */;
INSERT INTO `battle_pets` VALUES
(1,36,68,6,4615,1,0,160,2,0,'',0,NULL,NULL),
(2,37,75,15,1206,1,0,145,2,0,'',0,NULL,NULL);
/*!40000 ALTER TABLE `battle_pets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_account_bans`
--

DROP TABLE IF EXISTS `battlenet_account_bans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_account_bans` (
  `id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Account id',
  `bandate` int(10) unsigned NOT NULL DEFAULT 0,
  `unbandate` int(10) unsigned NOT NULL DEFAULT 0,
  `bannedby` varchar(50) NOT NULL,
  `banreason` varchar(255) NOT NULL,
  PRIMARY KEY (`id`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ban List';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_account_bans`
--

LOCK TABLES `battlenet_account_bans` WRITE;
/*!40000 ALTER TABLE `battlenet_account_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `battlenet_account_bans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_account_heirlooms`
--

DROP TABLE IF EXISTS `battlenet_account_heirlooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_account_heirlooms` (
  `accountId` int(10) unsigned NOT NULL,
  `itemId` int(10) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`accountId`,`itemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_account_heirlooms`
--

LOCK TABLES `battlenet_account_heirlooms` WRITE;
/*!40000 ALTER TABLE `battlenet_account_heirlooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `battlenet_account_heirlooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_account_mounts`
--

DROP TABLE IF EXISTS `battlenet_account_mounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_account_mounts` (
  `battlenetAccountId` int(10) unsigned NOT NULL,
  `mountSpellId` int(10) unsigned NOT NULL,
  `flags` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`battlenetAccountId`,`mountSpellId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_account_mounts`
--

LOCK TABLES `battlenet_account_mounts` WRITE;
/*!40000 ALTER TABLE `battlenet_account_mounts` DISABLE KEYS */;
INSERT INTO `battlenet_account_mounts` VALUES
(2,5784,0),
(2,23161,0),
(3,13819,0),
(3,23214,0),
(31,41513,0),
(36,13819,0),
(36,23214,0),
(45,73629,0),
(45,73630,0);
/*!40000 ALTER TABLE `battlenet_account_mounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_account_player_data_element`
--

DROP TABLE IF EXISTS `battlenet_account_player_data_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_account_player_data_element` (
  `battlenetAccountId` int(10) unsigned NOT NULL,
  `playerDataElementAccountId` int(10) unsigned NOT NULL,
  `floatValue` float DEFAULT NULL,
  `int64Value` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`battlenetAccountId`,`playerDataElementAccountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_account_player_data_element`
--

LOCK TABLES `battlenet_account_player_data_element` WRITE;
/*!40000 ALTER TABLE `battlenet_account_player_data_element` DISABLE KEYS */;
/*!40000 ALTER TABLE `battlenet_account_player_data_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_account_player_data_flag`
--

DROP TABLE IF EXISTS `battlenet_account_player_data_flag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_account_player_data_flag` (
  `battlenetAccountId` int(10) unsigned NOT NULL,
  `storageIndex` int(10) unsigned NOT NULL,
  `mask` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`battlenetAccountId`,`storageIndex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_account_player_data_flag`
--

LOCK TABLES `battlenet_account_player_data_flag` WRITE;
/*!40000 ALTER TABLE `battlenet_account_player_data_flag` DISABLE KEYS */;
/*!40000 ALTER TABLE `battlenet_account_player_data_flag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_account_toys`
--

DROP TABLE IF EXISTS `battlenet_account_toys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_account_toys` (
  `accountId` int(10) unsigned NOT NULL,
  `itemId` int(11) NOT NULL DEFAULT 0,
  `isFavourite` tinyint(1) DEFAULT 0,
  `hasFanfare` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`accountId`,`itemId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_account_toys`
--

LOCK TABLES `battlenet_account_toys` WRITE;
/*!40000 ALTER TABLE `battlenet_account_toys` DISABLE KEYS */;
INSERT INTO `battlenet_account_toys` VALUES
(36,37460,0,0);
/*!40000 ALTER TABLE `battlenet_account_toys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_account_transmog_illusions`
--

DROP TABLE IF EXISTS `battlenet_account_transmog_illusions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_account_transmog_illusions` (
  `battlenetAccountId` int(10) unsigned NOT NULL,
  `blobIndex` smallint(5) unsigned NOT NULL,
  `illusionMask` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`battlenetAccountId`,`blobIndex`),
  CONSTRAINT `battlenet_account_transmog_illusions_ibfk_1` FOREIGN KEY (`battlenetAccountId`) REFERENCES `battlenet_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_account_transmog_illusions`
--

LOCK TABLES `battlenet_account_transmog_illusions` WRITE;
/*!40000 ALTER TABLE `battlenet_account_transmog_illusions` DISABLE KEYS */;
INSERT INTO `battlenet_account_transmog_illusions` VALUES
(2,0,12591112),
(2,1,6148),
(2,2,477634048),
(3,0,12591112),
(3,1,6148),
(3,2,477634048),
(7,0,12591112),
(7,1,6148),
(7,2,477634048),
(31,0,12591112),
(31,1,6148),
(31,2,477634048),
(35,0,12591112),
(35,1,6148),
(35,2,477634048),
(36,0,12591112),
(36,1,6148),
(36,2,477634048),
(37,0,12591112),
(37,1,6148),
(37,2,477634048),
(40,0,12591112),
(40,1,6148),
(40,2,477634048),
(42,0,12591112),
(42,1,6148),
(42,2,477634048),
(45,0,12591112),
(45,1,6148),
(45,2,477634048);
/*!40000 ALTER TABLE `battlenet_account_transmog_illusions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_account_warband_scenes`
--

DROP TABLE IF EXISTS `battlenet_account_warband_scenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_account_warband_scenes` (
  `battlenetAccountId` int(10) unsigned NOT NULL,
  `warbandSceneId` int(11) NOT NULL DEFAULT 0,
  `isFavorite` tinyint(1) DEFAULT 0,
  `hasFanfare` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`battlenetAccountId`,`warbandSceneId`),
  CONSTRAINT `fk_battlenet_account_warband_scenes__accountId` FOREIGN KEY (`battlenetAccountId`) REFERENCES `battlenet_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_account_warband_scenes`
--

LOCK TABLES `battlenet_account_warband_scenes` WRITE;
/*!40000 ALTER TABLE `battlenet_account_warband_scenes` DISABLE KEYS */;
INSERT INTO `battlenet_account_warband_scenes` VALUES
(2,1,0,0),
(2,4,0,0),
(2,29,0,0),
(3,1,0,0),
(3,4,0,0),
(3,29,0,0),
(7,1,0,0),
(7,4,0,0),
(7,29,0,0),
(31,1,0,0),
(31,4,0,0),
(31,29,0,0),
(35,1,0,0),
(35,4,0,0),
(35,29,0,0),
(36,1,0,0),
(36,4,0,0),
(36,29,0,0),
(37,1,0,0),
(37,4,0,0),
(37,29,0,0),
(40,1,0,0),
(40,4,0,0),
(40,29,0,0),
(42,1,0,0),
(42,4,0,0),
(42,29,0,0),
(45,1,0,0),
(45,4,0,0),
(45,29,0,0);
/*!40000 ALTER TABLE `battlenet_account_warband_scenes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_accounts`
--

DROP TABLE IF EXISTS `battlenet_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `email` varchar(320) NOT NULL,
  `srp_version` tinyint(4) NOT NULL DEFAULT 1,
  `salt` binary(32) NOT NULL,
  `verifier` blob NOT NULL,
  `joindate` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_ip` varchar(64) NOT NULL DEFAULT '127.0.0.1',
  `failed_logins` int(10) unsigned NOT NULL DEFAULT 0,
  `locked` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `lock_country` varchar(2) NOT NULL DEFAULT '00',
  `last_login` timestamp NULL DEFAULT NULL,
  `online` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `locale` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `os` varchar(4) NOT NULL DEFAULT '',
  `LastCharacterUndelete` int(10) unsigned NOT NULL DEFAULT 0,
  `LoginTicket` varchar(64) DEFAULT NULL,
  `LoginTicketExpiry` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Account System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_accounts`
--

LOCK TABLES `battlenet_accounts` WRITE;
/*!40000 ALTER TABLE `battlenet_accounts` DISABLE KEYS */;
INSERT INTO `battlenet_accounts` VALUES
(2,'ONI@DEVUNIT.COM',2,'\0±Oã£½!G1r]IU£üÃí6¶gsÃ°äã¸2uOÊ','MĞ\nÂZ#º§,»0QœˆŸÈJ½,RB™ë“¾Š³däîŠ,šë3éaÿp?üÿ”€§cıhOò|²Û˜H–›ì\'ˆ„n/\rÚµEúşÖí5!õ\'útx_ÿk5‹ÊóÁKUv”‡õëáJ%‘61÷ç¿èë¬1&Š\0áá:ÇBïÚœøáT!IjvÒõŸ½zf|§TO¿EtSî\ZpàØHn‚\Z½–/üÓ˜ÒwŞÚÛæ<¤ \nz	‚Î¥L8€³E}nØ<î­¯Öø˜ =bC°¡ô±ƒGõ„ê?Óñ&‹Ómé-]—=ÇlŞPöw_@','2025-11-02 22:07:44','68.52.131.133',0,0,'00','2025-11-11 02:03:59',0,0,'Wn64',0,'TC-56D33D0EBEB18DF17FF8E2B1EB5270AC66B86349',1762830239),
(3,'AZAR@DEVUNIT.COM',2,'=F”b@i `Q­;r/ÚibŸv	È~³é¬ã~aÓ','¾ÿ\Z\nœ¯ÕÊEÏ1Èº›Tn„‰Ì{2ŠMµ5Mo>ú*×¦38279M.…à¨g@FªMæÙËÉ£×\r:æƒ¦îÆo–4±™oï¦BN\Z\Z[;æHâœ\rÏø¬Ü\\î€„òÎ›@œÿéHdÚZ¾®ˆóhÌË·P1‚w\ZšÒm]\rOƒÑ€›®³£æLQ@!“Y{ZôÙ^\Z^íi­ïqÙÚU ìl¨ÒZdB4Üúÿ¶v3\rÊ6i‘öp.|\ZJĞwù‹¾&ÀQPjYÍw‘vPÉ§ë˜BöX±¿÷míH~ø„òdJ»mvşö…‘©×©$','2025-11-02 22:09:46','189.60.169.35',0,0,'00','2025-11-11 13:33:46',0,0,'Wn64',0,'TC-EFFFA7EBC98B9C1784F9389BE462BF167141797A',1762871625),
(4,'ADMIN@THE-DEMIURGE.COM',2,'\"zÈ@A`‘ÖHÍ€ŞwTĞÔ­£l`P‹Wa)°_ËäË','k«\Zh¯‰ş<ÿ]:ß\\Ô	â	LjƒÔ]ÃLá…Ê—Ú[<ŞË¼Pgb:²&\"-]³ÕÄM¹Í‡-İ‰š\"ú1Sn=•¼xô;şï“á~gòSzv|ı1Ö é+{q’zÇ]B›$ÀØ8¨P	i‡©¿G5‡opFébïÌ³ ;ß—áù6:Œ8¹£NÅ\0tüTÀÍY:ké‘şèœùip(WW‰aÌÌ:Kö ú•õ§P¨Ë l‘Ìï4çÅÙ&±MÇR ˜ab5òøŠ+¾Zx“Ë3\0(¢Ñ§Œóõ¼æe§^Æ´ÀÅ%±ï¬¹V^:l=z-4fÈ\n>o‚R‡#(','2025-11-05 14:29:06','127.0.0.1',0,0,'00',NULL,0,0,'',0,NULL,NULL),
(5,'GM@THE-DEMIURGE.COM',2,'¹%Sg°‹”ˆos&4óØ‡wRqôNT“1J/','àwÊ[¥ÃøıZ±”{“Ê–ºNdgıµû|Bò_)ár’D\0æñäÜ+ÜÒ¯\n‚ÒÓ;Áãè.ö¸:ºS6ä£E°8õ´ôrĞ\\PAÏÄİàEœ=ÊºR;¿¾~ÅuK¦!Ó«Èİ®º· \neÍ©M}İ¬@¦ ‡Iš’&D?\ZIè\'9—è>ŠÂ%£Ç.Ç®D«“À	ªÆÜöÇ]`k·ãÙ‹nn}u…d|1MV”şì#$B`ÆUNÍæD\Zeç©vÕñ‹ìï|<~È££ôÿD?ÅËçsşT¦_^°âÑl–[[Ëêë]ëTJĞ½ñç©ö¼e','2025-11-05 14:37:54','127.0.0.1',0,0,'00',NULL,0,0,'',0,NULL,NULL),
(7,'HUNTER.GOLDENSTONE1@GMAIL.COM',2,'Ï÷t§]*§òçŸˆ.öf×™`«C#aKĞî¢ïnÎ','çÂÿ·p\"únhDÒô˜âY™ÙØz^‰+\rÒ×[¾Ñ¤=ù1ßág+—S\0ê6³£©¶–?/î]w^ó\\ò­¨å%Vo/Åö©ôŠÿ@¢htÒ0…ú[Õèñ†r=\'“‡ÊôÑoıôÔ…n%LN?`sd¦§B¨‰Y¯M·t‡P:&ewTÌézˆ—˜Ršş@÷7\\©‡`†â¯M¹œS’ğB’{\0ƒ’ã•öY½’xH~f„×Êäò÷@m$CZ\r›®hºş£(èû,Pp_z5S3:Ä>3£¥a;\\Ş=à@T”²çÏ–^ëĞÚŠ\\ƒ©ubô','2025-11-05 16:41:35','142.90.232.150',0,0,'00','2025-11-09 21:07:34',0,0,'Wn64',0,'TC-1B4DC22056F2774591DB8914A4C33CAADF4BB4AC',1762726053),
(15,'FATCAT@ADMIN.COM',2,' së™ó±¨êJÆÙ’œà³æ~¤À®ùe]=B?/™','tÿøQ»‘TE5œdè?hÒ^ˆ†j +·ñ|’¶[ÖKœ0•S,˜v%¿†ã<Ò»“:ûêSÓƒMçqPÒ™{}İ *¥¶5ÜÈ·<ònÑy9Ó–Dı_CHW­Û©´ÎL„›¯¼KÈ–MÔL9³‡9€Y_¸øîWôo-op·Ëhh/†\rØg§y“3íoãê`™SÂğVY8ÓèµdöÏ6–8ë~eÀj³ÅuÄ½\"\"Ìƒu_äSE(m›¢œ“³¡Heú±ÄKÂ zFèó3_ª`]Òÿ©Öq™ù@&Ÿ‚ Å»^Ş^ic•','2025-11-06 01:54:26','67.183.2.55',0,0,'00','2025-11-06 02:02:41',0,0,'Wn64',0,'TC-4BEE99F19169C804CB9AB683910337FD9C0B1CD9',1762398161),
(31,'BLINKOUTATIME@YAHOO.COM',2,'HC¬¹6\n)ˆf5Yñ÷†UZ$=‚bÖUmæŞ','Zæ¹ïl‡YÏß&h¶aB\rúË+ataşç•d\r$OŒX=®Åİ ·<©ê€|…:½®§¾àµn=M‚ê½¡Ÿê¼UËŠ²­,1bºJÕ×\Z@O4ÔñmèÉ“P\rycì9³\'9¦¡‰R·lÆ¼MŞ~e¨ÌZïJ\'0\rhiœ„N÷|O_øåaÈEËÎ“®=>Øèt:ï„¾\"Ş>ª*…Ä ˜=‹\0Y„šAJ™t‡¡¢×Âk9™*Q	œqfeW*[ıUŠ¡;ø•p2³²}ÑT,çø«µğÒ5m”&íõŠü4ŸµúØÆ¯\rC','2025-11-07 03:57:05','24.167.252.55',0,0,'00','2025-11-11 00:33:46',0,0,'Wn64',0,'TC-62CFBAB1A724022A2478BB3C8046B8B2480FAE2E',1762824826),
(32,'GTFAUTO@GMAIL.COM',2,'¯p(q7@Eæ@¼:°~‚µÙÃP$3ä:«3e!íg','mé®Šİ%=\0\"Ğò‚øÿgŒR+»Ø­úĞ©¯GA¤-E+sû\"=å§Ïç¶ä¸Duğ¡]4¬¿ @óûß|ÀØWÉIÈ:†ŸŠUPÂ<­:ŒLf™1º­Ô3±îÚ…Ğ|Å¦ÙâŒC(â•ã\\Fÿ¿Ù\\6Ã%û®Úr$\r·fªUp¨Îá\r‡¹1ÿçõòS« D°•+ëÔ­æ†€óÙÍË jäVğg—i%ÌÿÀ¶¬yØ¸˜jFbıWır0¡L\Zèú…ª`nŠDáVĞm¯©n(|$>¤(/…¾ç³†û‘€ô`\ZÍÖwƒÅ=°³!(','2025-11-07 04:16:41','67.183.2.55',0,0,'00','2025-11-07 04:26:01',0,0,'Wn64',0,'TC-387FBDDF51AAEF7416DD266A48771D19F7996BE4',1762493160),
(33,'NEWBLINKGUY182@YAHOO.COM',2,'…ÄÁÉ Ï‰wƒ†Mœ–±÷ræ×ı³‚Yd°;¿R','|Ÿâq¶6\nï¢*€®¢0ZQCıãÉĞÒ)£]æÄğ\nµ“\0aßw¯ÛÀ}pPaè ]æ§[Q\0G÷g‡(ªÚ7e«Çì†ZEÅŠkŸò€ûdv‡—:¾eh:<±6‡\\å‹OAŒ«ş}!æ-«pLéŒİš—c#f²G¥&ñğ¤º%Ø™xÍöŞ-5y”ñÁÄ:â¯nûJ3÷¼w«ıÄğ+ vø?{Q‡Š¨WUt×Û™â†6·\Zc@’àâNÄ•ÕF}Ùºª¶€#VVM^mÂ}îûLÍ·ç½€M¡\r™,A\\İmğ•^ÛË;Ö•zx‰WĞáVNÃ7õm','2025-11-08 23:19:26','127.0.0.1',0,0,'00',NULL,0,0,'',0,NULL,NULL),
(34,'MIDNIGHTSIN09@OUTLOOK.COM',2,'ùıáL¯Ÿ˜ô%Éñÿ™L„$ã„Mù?‹ü]²ùƒ³_!','bŒ ÜB6ENàyŞĞ1Öâœ‹÷º¼ùYÚŸ¥ˆäÌÅë\n{œÂ}hšM4ã\"ûº{,\"Ø×ğ¼Çc‘†xT÷<¥úº…¦9?@¥»/!­VòÚ¯•qÁ––¦*Š÷şº¤¤0*°}¨ä…D\0PÓûµ:·çvYœÒ ÙåáÑ»ÜÛwmŞpŠLãiñÄà¿&TbÍéU%q\nİH1ƒ{wô*mMBÖõdõ”ÏeZäï™	—l]©œfQGÇnâañ	gùú©¬»O@Ì~¹#f!¤S#EØLÛ?[GÇ9¬yÓ0ÜÒO–!Ë;	\r8Ev¤LÔø/MÙ×¾°ì)}-','2025-11-08 23:24:45','127.0.0.1',0,0,'00',NULL,0,0,'',0,NULL,NULL),
(35,'RENWIZARD@GMAIL.COM',2,'u3G¼Êß\\®µİó…®^ß1ƒ×ÊØ8µ—)-J9-J',' ’¾jjÖ»”ñ«˜‘h†ûrÙ\r`%Ä†¹«%{·‘ll¶ˆ¥ò“=o‚;f}\nï’±\0\ní†éBgè8d~Çc°_}ìl=MuálØbYíÖ<|†ûu†8……>Õ‘Å\nİL”vğá~‘iî%üÖ_Q\Zÿ*Jj¨)YsÔƒ ùĞf›%wOÕt6€0“~œ9Ôc£Áç8=‚¹Ñ:MÕb\'è¹«:1¦’_OKâÆ›‹‹X\\eËçî…N¼i|È4¬ëáø{9P¶òÛõµ/À¯•<²¬X£MÁûÙ•Ö’@¦ŠEç–¾¦>i€Í¹E¾wcµ^¬[h','2025-11-08 23:26:28','174.31.103.187',0,0,'00','2025-11-11 23:12:01',0,0,'Wn64',0,'TC-4C6EDEAD192A8AC24808DFD9DE32078C0D7BB1CD',1762906320),
(36,'BRADLEYRIEDSTRA09@GMAIL.COM',2,'à_çŸ2¡r×‰C¬è{Óm~ø¯/Ïé¸~C§‰tÌ¬','&s×Âü zÄ·u&Ù,\'¢”}ºCóü[Óp2¯­Y<¢•ş`4Ü¨Ònª²-§šL5\\~QRÿ{hÊ2†T É~ğß†%ŸIÍÈ\"«>—´×,VÉ÷Àv\04¾‘Ì= àÈSXş2¸F÷$)ƒ@—‰@<,Ç¥Çåw@ Zx¯d›ÿ³±nƒÎ©vM“ÃPe¾c<gOGœª[Y	È`Íq›Ìà¾BA€İÉÏµÁÁº	öìÍşS¼âä¥şÄ{{r™ÙSÛfÀÖuó\"æ‘f%’|V“I•gDŸ &ãÿöâæ+¸ÆŞÖàğ›üĞq','2025-11-08 23:37:27','70.26.174.8',0,0,'00','2025-11-10 19:21:09',0,0,'Wn64',0,'TC-49206D8758824AE2F4F4F03A7CB2BF455774DEA6',1762806068),
(37,'SHINJOX@HARBORNET.COM',2,'<5˜Ş˜³TÛb»o”pïß˜döçÿs¹ÊİŒÆ¡','Ìw.ú£ıœ×\ZJ(¥Ë!iFKô2³ŒLŒQãÄLNe«©/Ó\rÒ¬Üà&ªl\'MßÇå<òÎÂ¨5C¥­\'»úµd.)%9”Ê`°ãæj´°iˆÊˆÃëªz£áø°qÑAvÃbf€ºNæşj5”Nş5t±ÔeÁLqõz£\0©(O‰Eà{\ZeúI~¬\0ÙŠ´k7GYËŠœ+ô&µ=‘‚úÕ†iÛ­š2–mĞˆ^<OoÃ.;7ÄqÈ?‚x1{d\Z>¬L•SğÊÍøt\'+ï˜›Ù\\¾\ZPİæ\0/=\'•œ\Zâ+ú)ûªĞ‘%ù‰‘‰9ÙxŒ®’','2025-11-08 23:45:45','73.225.231.43',0,0,'00','2025-11-11 13:51:54',0,0,'Wn64',0,'TC-547F3506B6B25F9196988D9602C45BCA5F58EDE4',1762872713),
(38,'DARKTAU21@YAHOO.COM',2,'ŒğN7^´–wnaã´Ûä3Ï®—k¶nAkmmz!','ÎõÕ½Ò’¡è0%à™g—³bMÕdÒ¤íN\"<H\\œ\n}Ğ-ˆ;\Z!ÇK«) š˜­ö“÷×v‘[Ú°I#ëø® °¶sÃc¾–ğø‰ BbÌ-‚Ú%MX›µ^ƒ@FpŠÍ®ÚîKĞ7ŸÆK­FnL¡É<·_¶¯w‘FëÜ6>Ã†õ™ üËj¦·„ê¯nB1¢q%ÊbËRñìÓÖcMî:BÅˆEyo ËÀXB/¯ı~ÒsiÇ,ó4ª@úföüm!òr%_ã ~qZ¾~“å&ÆÏé+y•$R/TóçmÊG,ÑI, )~¾\Z˜GV„ù,AM','2025-11-09 02:29:24','127.0.0.1',0,0,'00',NULL,0,0,'',0,NULL,NULL),
(40,'SEREOPPI96@HOTMAIL.COM',2,'Yå£X ´<ö¯4Ø7*X«ÎióùŒxÂ	öä','İ„?÷åß{r%·¼&ºát‹±^V`³KŠsç%Ršÿl¦¸~;8ıøŸh’ÎrlêÖ.XğGªˆ¤¬gÁşê\Z-ï¬ÂÏ\\îœ«h>T­ã¥0º5ã^J:)òMÊ¶ÊüÖ¢ÏN³9ÿ¯™Tÿ/uƒ_ƒ64–&°¥‚6Õ¡P£€.ˆH»\n\' ¿Á…H6¹)‚teuUilqC>…ÙšnİfÃ(¡oP{\\íSÒ«$Ûß¼çAâj“ÑTŸ\0U‰–’›{š½BZİĞİ«ßNÀ³YùLC!4à…K_`s>yÎ©ÔŸÆj¯8ğê‡ëNü‰%8¢‰','2025-11-09 07:52:59','47.162.81.247',0,0,'00','2025-11-10 01:34:55',0,0,'Wn64',0,'TC-5DCE96213BFD73DED1A605C359E87C79EECEC9D8',1762742095),
(42,'JAKEG23@YAHOO.COM',2,'Í«v[Ÿ)§E¨Æ)õ4GÁbÂºØl ¹#WÁ%Õ','oz×œÆ&×Y¡3¥D`2aR=ËX‰Ï­k\' ØÌÃÇôgÔÏ)>Ím˜‘óÔ ñ‘Vrø³xW°Y°I£ª;¬l¨K÷š72Ğ­Ä¬å‡»›æ¸úOã8+AŞöŒ\Zgy†Qëæé>é0µ0yåO>ÓÖL>š“´¿2¯a+Ğ:-ÍÅı¬¾díÔ\ZF[:mºƒÄ\nZ«³\r\r\\ôDz2ª9qWDø\ZÅ–~ÒNü‰¨mœ’ó’IÎ3œ†Çù#şöqøóJÍWw]\Z/à=;)œö$8ò’İ_0ï.ëá6zxG}Šp²èèpßæ	¼A·*0H/ô,a','2025-11-11 03:36:15','69.53.4.178',0,0,'00','2025-11-11 04:07:25',0,0,'Wn64',0,'TC-436867B108C81C897177F13742F7BF3A2B16A4D4',1762837645),
(45,'KHSKRIS@GMAIL.COM',2,'İ8ÃZò\0{òBG¼Æ4Áí…bÔ\0,”˜g>ºªŸ','Üusæ ¤äµmí›RP6ËXDäú8Îªm«ÉF×w¥c\"½kUªFë#èœĞx.èê+moQé]Ã-–Ô§ ÷†”°º©hŠ:”ü§H-€\"&	¢¾‰l,\"\"¯µDP¥¼üe2…EÁ3SÜÒwì(hÍÛ®bû¾‘¯òÈÑ:¹ûïªüÉ÷ƒŒ+˜²ªËşÎ ÿùv0*	HC-(Ô”TA&Ìœ–h€ „AÔH/\\µoä>nNrÈŒ!2yp¼ê¬1õ[&aÊO·ˆÚ\r–AÀšÖ\r¢ò²ĞúnüçĞ ¸øS–Ïƒ?Fà‹ÙÑ¯f·ë\0XFä	ˆãAN!','2025-11-11 04:10:40','75.164.134.159',0,0,'00','2025-11-11 15:26:22',0,0,'Wn64',0,'TC-9DBF271DFB59F1C41E2D35049D44883B76F8CD77',1762878381);
/*!40000 ALTER TABLE `battlenet_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_item_appearances`
--

DROP TABLE IF EXISTS `battlenet_item_appearances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_item_appearances` (
  `battlenetAccountId` int(10) unsigned NOT NULL,
  `blobIndex` smallint(5) unsigned NOT NULL,
  `appearanceMask` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`battlenetAccountId`,`blobIndex`),
  CONSTRAINT `fk_battlenet_item_appearances` FOREIGN KEY (`battlenetAccountId`) REFERENCES `battlenet_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_item_appearances`
--

LOCK TABLES `battlenet_item_appearances` WRITE;
/*!40000 ALTER TABLE `battlenet_item_appearances` DISABLE KEYS */;
INSERT INTO `battlenet_item_appearances` VALUES
(2,0,65536),
(2,7,67108864),
(2,28,65536),
(2,38,256),
(2,42,268435456),
(2,65,67072),
(2,124,65536),
(2,126,2),
(2,129,7168),
(2,133,32768),
(2,2416,2147483648),
(2,2417,3),
(2,2600,12),
(2,2631,2147483648),
(2,2947,134217728),
(2,3259,8192),
(2,3268,469762048),
(2,3398,262144),
(2,3399,16),
(2,3400,1073741824),
(2,3401,33254),
(2,3402,32768),
(2,5166,3221225472),
(2,5167,64527),
(3,0,131072),
(3,23,1024),
(3,133,32768),
(3,2416,2147483648),
(3,2417,3),
(3,2600,12),
(3,2631,2147483648),
(3,2947,134217728),
(3,3259,8192),
(3,3268,469762048),
(3,3400,2818572288),
(3,3401,16785),
(3,3402,16384),
(3,5166,16773120),
(7,8,134217728),
(7,42,268435456),
(7,295,524544),
(7,334,8519680),
(7,2416,2147483648),
(7,2417,3),
(7,2600,12),
(7,2631,2147483648),
(7,2947,134217728),
(7,3268,469762048),
(7,5167,1008),
(31,42,268435456),
(31,59,512),
(31,65,76800),
(31,2416,2147483648),
(31,2417,3),
(31,2600,12),
(31,2631,2147483648),
(31,2947,134217728),
(31,3268,469762048),
(31,5167,65011712),
(31,5656,4160749568),
(31,5657,5),
(35,3,262144),
(35,18,1073758208),
(35,20,2147483648),
(35,28,65536),
(35,55,8192),
(35,59,512),
(35,65,207360),
(35,66,4194304),
(35,67,16),
(35,69,8388608),
(35,77,32768),
(35,124,65536),
(35,182,64),
(35,235,1048576),
(35,755,96),
(35,766,1024),
(35,833,536),
(35,2416,2147483648),
(35,2417,3),
(35,2600,12),
(35,2631,2147483648),
(35,2913,134217728),
(35,2947,134217728),
(35,3268,469762048),
(35,5167,2031616),
(36,0,131072),
(36,5,4194304),
(36,7,131072),
(36,23,1024),
(36,27,8192),
(36,28,4194304),
(36,31,4),
(36,66,1572864),
(36,69,2147483648),
(36,70,1),
(36,130,2097152),
(36,880,37120),
(36,884,272905),
(36,887,42205184),
(36,888,1280),
(36,2416,2147483648),
(36,2417,3),
(36,2600,12),
(36,2631,2147483648),
(36,2912,25165824),
(36,2947,134217728),
(36,3259,8192),
(36,3268,469762048),
(36,3400,3355443200),
(36,3401,66018),
(36,3402,65536),
(36,5166,16773120),
(37,7,8388608),
(37,42,268435456),
(37,59,512),
(37,65,208384),
(37,66,603979776),
(37,67,16),
(37,69,8388608),
(37,106,2155872256),
(37,124,65536),
(37,194,65536),
(37,755,96),
(37,833,664),
(37,2416,2147483648),
(37,2417,3),
(37,2600,12),
(37,2631,2147483648),
(37,2913,134217736),
(37,2947,134217728),
(37,3268,469762048),
(37,5167,65011712),
(37,7192,2290089984),
(37,7193,14),
(37,7194,65536),
(40,38,16384),
(40,42,268435456),
(40,65,65536),
(40,124,65536),
(40,126,2),
(40,129,7168),
(40,2416,2147483648),
(40,2417,3),
(40,2600,12),
(40,2631,2147483648),
(40,2947,134217728),
(40,3268,469762048),
(40,5167,64512),
(42,0,65536),
(42,1065,4096),
(42,2416,2147483648),
(42,2417,3),
(42,2600,12),
(42,2631,2147483648),
(42,2947,134217728),
(42,3268,469762048),
(42,5167,1008),
(45,0,131072),
(45,23,1024),
(45,133,32768),
(45,2416,2147483648),
(45,2417,3),
(45,2600,12),
(45,2631,2147483648),
(45,2947,134217728),
(45,3268,469762048),
(45,3401,16384),
(45,5166,16515072);
/*!40000 ALTER TABLE `battlenet_item_appearances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battlenet_item_favorite_appearances`
--

DROP TABLE IF EXISTS `battlenet_item_favorite_appearances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battlenet_item_favorite_appearances` (
  `battlenetAccountId` int(10) unsigned NOT NULL,
  `itemModifiedAppearanceId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`battlenetAccountId`,`itemModifiedAppearanceId`),
  CONSTRAINT `fk_battlenet_item_favorite_appearances` FOREIGN KEY (`battlenetAccountId`) REFERENCES `battlenet_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battlenet_item_favorite_appearances`
--

LOCK TABLES `battlenet_item_favorite_appearances` WRITE;
/*!40000 ALTER TABLE `battlenet_item_favorite_appearances` DISABLE KEYS */;
/*!40000 ALTER TABLE `battlenet_item_favorite_appearances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `build_auth_key`
--

DROP TABLE IF EXISTS `build_auth_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `build_auth_key` (
  `build` int(11) NOT NULL,
  `platform` char(4) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `arch` char(4) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `type` char(4) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `key` binary(16) NOT NULL,
  PRIMARY KEY (`build`,`platform`,`arch`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `build_auth_key`
--

LOCK TABLES `build_auth_key` WRITE;
/*!40000 ALTER TABLE `build_auth_key` DISABLE KEYS */;
INSERT INTO `build_auth_key` VALUES
(25549,'Mac','x64','WoW','fü^	¸pa&y_ÈÁØ'),
(25549,'Win','x64','WoW','RbNØËÖúÇÓ?]g¥5ó'),
(25549,'Win','x86','WoW','şYOÃ^šÿ†ÙŠ6J²—'),
(25996,'Mac','x64','WoW','!—IÖõl¬›­òªÉ'),
(25996,'Win','x64','WoW','Çÿ“-j!t£Õ8Êrm+'),
(25996,'Win','x86','WoW','#ÅœYcËï[r¥xßË'),
(26124,'Mac','x64','WoW','ÉÊ™z¸íáÆTeË) †œN'),
(26124,'Win','x64','WoW','FßĞ{¦{¤šõSC^	?'),
(26124,'Win','x86','WoW','øÀZãrŞÊlÚz\\9'),
(26365,'Mac','x64','WoW','Ûçø`\'mk@\nª†³]Q¤'),
(26365,'Win','x64','WoW','Y¥?0rˆEKA›æ”ßP<'),
(26365,'Win','x86','WoW','*¬‚È‚,©×ú\Zƒ:'),
(26654,'Mac','x64','WoW','’4Á½^–‡­½÷dòàè'),
(26654,'Win','x64','WoW','§Rd‹™ş[WÁ2Ä’‰Z'),
(26654,'Win','x86','WoW','úÂÖ“ç¹ìŸu$V–Ø'),
(26822,'Mac','x64','WoW','‘\06hÂEÑNÍğ”àeàk'),
(26822,'Win','x64','WoW','+ö×FÀÆÌ~÷”P³	å•'),
(26822,'Win','x86','WoW','(>wì÷æ4{äë™ÇÇ'),
(26899,'Mac','x64','WoW','ƒhïÂ)\n3)‚\0Ô'),
(26899,'Win','x64','WoW','5Qï\0(µ’Y½%dK'),
(26899,'Win','x86','WoW','ôbÍ/äê>­øu0Û±Œ™'),
(26972,'Mac','x64','WoW','4şş=r¬©¤@}Å5ŞÖj'),
(26972,'Win','x64','WoW','n!-ïj$£Ù­õã\"÷®'),
(26972,'Win','x86','WoW','y~Ìf-ËÕ	\nD?&'),
(28153,'Win','x64','WoW','İbeÌm1“+G™4ÌÜ\n¿'),
(30706,'Win','x64','WoW','»m˜fşJ¥hQ˜x0ü'),
(30993,'Win','x64','WoW','+­aeZ¼/ÃĞH“µ6@:‘'),
(31229,'Win','x64','WoW','ŠFò6p0Ÿ*®…É¤rv8+'),
(31429,'Win','x64','WoW','w•¥¯ÃR^ÿrOîç'),
(31478,'Win','x64','WoW','ys¨ÕKÛ‹y’—°–çqï'),
(32305,'Win','x64','WoW','!õ¦üzØŸ¿AÚ‹‡8j'),
(32494,'Win','x64','WoW','X˜JÎ‘”ƒ\\a0š„Š'),
(32580,'Win','x64','WoW','‡Âú ×“ğ)%ÀİÊ'),
(32638,'Win','x64','WoW',']ìçÔ¨gİŞa]­\"·mN'),
(32722,'Win','x64','WoW','\Z	¾8¡\"XkI1¾ÌêÔª'),
(32750,'Mac','x64','WoW','ïNM	¢¨ÔÀŞ¼p†'),
(32750,'Win','x64','WoW','ÅËfŸZ[#}UCw2'),
(32978,'Mac','x64','WoW','RÁøGç•ÖëE\'ŒÔ3ó9'),
(32978,'Win','x64','WoW','v®. >R]—õhˆCõH\0'),
(33369,'Mac','x64','WoW','õ¨IÇ\nTğ~£«ƒ>¿fq'),
(33369,'Win','x64','WoW','Y†¬°M<@?V ÏŒO\n'),
(33528,'Win','x64','WoW','Î<©±’÷Òy,x[Gß'),
(33724,'Win','x64','WoW','8÷»Ï(I9İ èÆLÛùşw'),
(33775,'Mac','x64','WoW','5M-æÑ$î˜÷k6üü'),
(33775,'Win','x64','WoW','¸&0\n„Iínñn§Gú-.'),
(33941,'Win','x64','WoW','ˆ¯\Z6Òw\r\nl †Ip–¨‰'),
(34220,'Win','x64','WoW','µã[—lk¯‚PW\0çÙfj,'),
(34601,'Win','x64','WoW','\r}ór_«¤ğ	%w™¡c'),
(34769,'Win','x64','WoW','“ù¹¯c—ãäîÙM6ÑiÒ'),
(34963,'Mac','x64','WoW','ÅeŠç4Gºªäm\n'),
(34963,'Win','x64','WoW','{¥‡œ]\"#°*Ã`:'),
(35249,'Win','x64','WoW','Ç±šéÿ	õX)³Ñ\r'),
(35284,'Mac','x64','WoW','¦ \nÅ§=«/ÜÇ›²R¯'),
(35284,'Win','x64','WoW','ê8çÜı 	Ûüƒî<O'),
(35435,'Mac','x64','WoW','æWÁJF¼Û,æÚ7ä0E'),
(35435,'Win','x64','WoW','»9z’ş#t¥/Âµº.Èà'),
(35662,'Mac','x64','WoW','Yfl6Ù÷ª¶îg'),
(35662,'Win','x64','WoW','W‹ÉHpÂxËibómÂ»'),
(36753,'Win','x64','WoW','8oŞ…YµêÖ{yI ˆ'),
(36839,'Win','x64','WoW','5n´A+ü÷.:õ\rQÕ)'),
(36949,'Win','x64','WoW','QÀtÍŠ	§S„¹´AˆÅi'),
(37142,'Win','x64','WoW',']œû19ğÑ¶Â³&«É'),
(37176,'Win','x64','WoW','<r^¥ì=®ÑCëoó´ŒÚ'),
(37474,'Mac','x64','WoW','L›çäB7·èmBæxÔ3'),
(37474,'Win','x64','WoW','\ræ…»°U†çûÜK°j['),
(38134,'Win','x64','WoW','2\'^Ğñ;5|(½°æï1'),
(38556,'Win','x64','WoW','ì}ZöCd¬>qóû¡³¨‚'),
(39653,'Win','x64','WoW','Ğ«ë‘1(ÙÅ~âF2'),
(39804,'Win','x64','WoW','ä-+ºí&\nvù±äwá¥'),
(40000,'Win','x64','WoW','L±C:¶7ğŸû½\"°'),
(40120,'Mac','x64','WoW','…?)…Î®Ômô\"X<Ğz|'),
(40120,'Win','x64','WoW','ô~®ı‹ŞşªPê3fx'),
(40443,'Win','x64','WoW','…—»Cè«8ÈUè¿·*»õ'),
(40593,'Win','x64','WoW','ºW-bÕöS9Ad¨Úâ'),
(40725,'Win','x64','WoW','ÁëÛë›²•n¼Î÷ÉÒz;'),
(40906,'Win','x64','WoW','õü%œ†5HŠş\rĞ#óaÔ'),
(40944,'Win','x64','WoW','6Çúºô‡¨ IÁpept'),
(40966,'Win','x64','WoW','ÙG¯!óÒØóv;™K¬ˆ'),
(41031,'Win','x64','WoW','š¬Ö°Ö7K{¦š[gtI'),
(41079,'Win','x64','WoW','ø…<ø#¼¾Š–w§bß®á'),
(41288,'Win','x64','WoW','‡–‘ÛÅ6ë$¶Ç?­['),
(41323,'Win','x64','WoW','å=\rñúÁ¥š€q²• J'),
(41359,'Win','x64','WoW','_*i\nCu¡µ*(ÖÖú'),
(41488,'Win','x64','WoW','ÉÃhpXóõ2µSÚÙ'),
(41793,'Win','x64','WoW','³´}£·aUpt*U¹fî'),
(42010,'Win','x64','WoW','0)pA{[åSÌS\Z'),
(42423,'Win','x64','WoW','aJ~”İWT…–¾BÂ'),
(42488,'Win','x64','WoW','§‡Uæ’ƒ¢qÅÑî<Ûo'),
(42521,'Win','x64','WoW','_æÁ/ÄÆ±[J];[J];'),
(42538,'Win','x64','WoW','q§PKÕ?åòBeÓs®'),
(42560,'Win','x64','WoW','_èÃŠgÊFd».\rş'),
(42614,'Win','x64','WoW','w+ç&şïBBUÒêysÊ'),
(42698,'Win','x64','WoW','´I{ÑÉtÅû	TŠÂri'),
(42825,'Win','x64','WoW','¡M¢(Æ¦¯ñİºQ!‰9åW'),
(42852,'Win','x64','WoW','ŞŸŸ<ÈıTÓ¯ùœïüá)'),
(42937,'Win','x64','WoW','õüuçtu,’„k33’c'),
(42979,'Win','x64','WoW','áİ8®dPüM*ä`’3ÅT'),
(43114,'Win','x64','WoW','÷\\“€Ì²JH¢NîRÁYJ~'),
(43206,'Win','x64','WoW','İèS,wÿ·_%mÅñóÙ'),
(43340,'Win','x64','WoW','päm-ˆ„ß“ê„›Œô'),
(43345,'Win','x64','WoW','Ù«üÚ\rîŒ¯Nãö\rî'),
(43971,'Win','x64','WoW','hùaû\0¥ÇÓ\n­Ù'),
(44015,'Win','x64','WoW','üğ½§É‹şù*æØÃš!z½'),
(44061,'Win','x64','WoW','ı+\\2“şœªn°·x'),
(44127,'Win','x64','WoW','xx‡ÎÉüÉµH`äü4¨'),
(44232,'Win','x64','WoW','ğ§÷é‡;³u\0\"ÖM3Ï'),
(44325,'Win','x64','WoW','Š}RM&Š™4ÃÑHèğ'),
(44730,'Win','x64','WoW','üÄ{´ÇŸC\0ÊóåÊÇ'),
(44908,'Win','x64','WoW','¿úì@É¼Õ‘ÇÉY©Õ¨ºŒ'),
(45114,'Win','x64','WoW','×¯â@½\0ğl0ĞÂÑnT¨¾'),
(45161,'Win','x64','WoW','t½.xz˜±E°c½©©l½'),
(45338,'Win','x64','WoW','\\â	JA¶Úõcx¼;à'),
(45745,'Win','x64','WoW','mÉaiMvZYZ:ök'),
(46479,'Win','x64','WoW','ËšôØ›`£«¢ˆÓ•ÓÙ2'),
(46658,'Win','x64','WoW','?ûT(×S`éïâ\\Øcš'),
(46689,'Win','x64','WoW','Ù¡jÖ	õFuïÓª'),
(46702,'Win','x64','WoW','´Ñhù}ÉªüÍ\n„,'),
(46741,'Win','x64','WoW','LJ~Â	Šñû§E„Çšx'),
(46801,'Win','x64','WoW','æ¬Ñê]6«ÿ®^ŞØ0ß'),
(46879,'Win','x64','WoW','ïìC“`Qİ\Z!3¯kcÛ'),
(46924,'Win','x64','WoW','æÎ\ZğiìñçÛª{²ø'),
(47067,'Win','x64','WoW','c†,üŞ¦½+×÷@ë6¶VW'),
(47187,'Win','x64','WoW','q„UÅ\0#r’áæé1á'),
(47213,'Win','x64','WoW','#Å\rˆÎ¬\n†–­ŞÒDÔ¢'),
(47631,'Win','x64','WoW','ù†«‘Ğ®²\"ï·/BVq<'),
(47777,'Win','x64','WoW','¨Œ‘Z¹à5¡å\\MÏ_Ÿ'),
(47799,'Win','x64','WoW','sdë	<#Û,Ü•Õ§´“>'),
(47825,'Win','x64','WoW','‚£¹N^rzó¢´qÿ TÀ'),
(47849,'Win','x64','WoW','İ‹¾ ‡¢Œ\nô˜L¾#¡Ç'),
(47871,'Win','x64','WoW','O}0îI‚°+;?ˆ7ÂÄò'),
(47884,'Win','x64','WoW','+z\0+ÃYòÃ¼-àC¿'),
(47936,'Win','x64','WoW','ƒ=0ØûÄ;?®™Í8˜×I'),
(47967,'Win','x64','WoW','Ïâ%Ğ\"MuAÓµÂdx'),
(48001,'Win','x64','WoW','K`£{Ù[a^q„iæÕ»'),
(48069,'Win','x64','WoW','UŒß• ‚éXIwœ|iEå'),
(48317,'Win','x64','WoW','À–ã{E´2DéÇ™`MÔ¯'),
(48397,'Win','x64','WoW','dº‡yê©~lW˜+k\Z[2ç'),
(48526,'Win','x64','WoW','Õ·Ó0:*tiî\ZëËe'),
(48676,'Win','x64','WoW','àYûtßöCŒÂ(dÊ'),
(48749,'Win','x64','WoW','’ÛÌ ã=ûŠ¢¶£’F²ˆ'),
(48838,'Win','x64','WoW','oNFï\"-é{ÄŠª–'),
(48865,'Win','x64','WoW','KwJ¾{4Öp%q´\'šKj'),
(48892,'Win','x64','WoW','ª1¿\'Eƒ!°:\Z4idİ{'),
(48966,'Win','x64','WoW','‚1BÊ»q_õ]CCå\\m'),
(48999,'Win','x64','WoW','yºoğùg.ï‡_d\\‹bÔ'),
(49267,'Win','x64','WoW','îç~¥¢às\ZÛ´\Zï±ß1'),
(49318,'Win','x64','WoW','¯CšîbîH³l%=›¿'),
(49343,'Win','x64','WoW','0\ZL	B¹¶ö¹­l`'),
(49407,'Win','x64','WoW','d‚\rÉˆ[°i;7	»/0'),
(49426,'Win','x64','WoW','Ø^ß¿é©JUâ´Qä²'),
(49444,'Win','x64','WoW','6;+([İˆWA(f1m<'),
(49474,'Win','x64','WoW','D§Ò³Rî=	Š<´Âñ^7'),
(49570,'Win','x64','WoW','°$Şg¬®¹èîm³Å>‚'),
(49679,'Win','x64','WoW','œå›hØy~¿\0XAC'),
(49741,'Win','x64','WoW','ñâ»”ló·B*Ş¶Í\Z'),
(49801,'Win','x64','WoW','2•g¶l¨]½Vx¶Æƒ'),
(49890,'Win','x64','WoW','\"¥¸¡ëyzd™_p[=¼±L'),
(50000,'Win','x64','WoW','ğoú\"–ıf8B•ÛıZL‘'),
(50401,'Win','x64','WoW','>ïRÙÌèĞâUğªI8'),
(50438,'Win','x64','WoW','_hğkœ´ÅwöÓ&'),
(50467,'Win','x64','WoW','^™kÜîhC-c@hÑë'),
(50469,'Win','x64','WoW','hÌ¶X«;ï©Ö£“¢'),
(50504,'Win','x64','WoW','}_Ò2É¯]ÖT3³‘Ôœ'),
(50585,'Win','x64','WoW','Ä÷Ì8£¸I5¤…÷í­>vK'),
(50622,'Win','x64','WoW','Ò:&ıuıš`sëp`ª(æ§'),
(50747,'Win','x64','WoW','-<8jœEÂsí:<n³÷È'),
(50791,'Win','x64','WoW','çĞ»ï7Â\\¼h$		 '),
(51130,'Win','x64','WoW','DÍ,‘äğe]£‡H7&Î@5'),
(51187,'Win','x64','WoW','tâ]9e&”GµË1üqÆ'),
(51237,'Win','x64','WoW','Èf\n!·fdo½gôÏÏUÃ'),
(51261,'Win','x64','WoW','ëµzäP3ŸŒ0\Z§‡o«'),
(51313,'Win','x64','WoW','5AĞ«s\\÷ …EÜ0'),
(51421,'Win','x64','WoW','EâMo35&—‡ß+ c“'),
(51485,'Win','x64','WoW','ìT\n]Ø\\ç©Ù;}ÆÑ'),
(51536,'Win','x64','WoW','Wê¨ìœ?ùbc[´'),
(51754,'Win','x64','WoW','¾Õ¨aÀq«Aşö~7»\Z'),
(51886,'Win','x64','WoW','	Ï‰ı.«Ş®¼Sµ'),
(51972,'Win','x64','WoW','DMÇï5D¶gˆM­ ('),
(52038,'Win','x64','WoW','¨ï\0JŞØ£¯õ¦}+¸ÙW•'),
(52068,'Win','x64','WoW','¤O„+¬Ì~èâ—_¯ñ$t'),
(52095,'Win','x64','WoW','º68(‡Ñm\'N©–•ğÉÈ'),
(52106,'Win','x64','WoW','•ô8i·Ø!,¼¸ó“í'),
(52129,'Win','x64','WoW','İ„/*qbî¸ı[2Vø'),
(52148,'Win','x64','WoW','Š–—ÈÍÆçÿLTÕË\0Â$'),
(52188,'Win','x64','WoW','—}ù™>”…]í^2‹§¢ò'),
(52301,'Win','x64','WoW','‚\Z£»#{@‚ôIp%9ª'),
(52393,'Win','x64','WoW','°í#·ïQ²šEYM›»\r'),
(52485,'Win','x64','WoW','XÎ´e0®H’Xİ0ãDA'),
(52545,'Win','x64','WoW','ûRšƒU¤nÛûÜ\\Úı'),
(52607,'Win','x64','WoW','\0.J­Êê»«Âˆ1­`'),
(52649,'Win','x64','WoW','Ğ·yûìëÁíZ…Ø?È§['),
(52808,'Win','x64','WoW','bvq+lŠê!Í]”Õ/îpî'),
(52902,'Win','x64','WoW','Ôğ¢LßV(SŒ8z2jó'),
(52968,'Win','x64','WoW','-$Ô@ÄMOø[‡ ò'),
(52983,'Win','x64','WoW','±å­¥ıĞlšµåØ¦˜3$¬'),
(53007,'Win','x64','WoW','¢\ZûM8V¯G™BXÀîõ'),
(53040,'Win','x64','WoW','/ƒ¿{0{pÛ½uÌB×Ã'),
(53104,'Win','x64','WoW','Û×ÈßKSÇ‰1¹…Ê´'),
(53162,'Win','x64','WoW','ŠgQ¿‰„îâ¶0÷Ë#7j'),
(53212,'Win','x64','WoW','vÿ/›c“d¹©ûÿÿ¹I'),
(53262,'Win','x64','WoW','aJrÕ1&4ŠI\'ìSı+z'),
(53441,'Win','x64','WoW','¿İ}è}_uæŞ´õÉ|™'),
(53584,'Win','x64','WoW','Í×©6Y 4`µ¦ÎJÎUT'),
(53840,'Win','x64','WoW','¬—×EÆ\rÓÜ_—>UÀãd'),
(53877,'Win','x64','WoW','2•¶8F¢\'n&ÃJÔ'),
(53913,'Win','x64','WoW','GV€h!’ëÏgDÑOuQ™'),
(53989,'Win','x64','WoW',':ë¬¹á‹ˆº!õ-Q¸W'),
(54070,'Win','x64','WoW','ı ‚d·XrPÏxù¹`!i'),
(54205,'Win','x64','WoW','XYë?\rmwÂ]“÷İ'),
(54358,'Win','x64','WoW','‰Ç3ÓfèEû’d@LÔŒÊ‰'),
(54499,'Win','x64','WoW','jÁöÄÃ÷‚Û“;Ø3&'),
(54577,'Win','x64','WoW','Ë»»ÿ²ÆRğô§„†á°c'),
(54601,'Win','x64','WoW','ø¸fÏ}¹¡\"só[9)bsu'),
(54604,'Win','x64','WoW','¥ÿLå5öMcŒ²Á\"C'),
(54630,'Win','x64','WoW','óy5Q¦µY6<ñ‚0'),
(54673,'Win','x64','WoW','¯‹œŠœa(I…\"‹–Z\0M'),
(54717,'Win','x64','WoW','†+ºÿkV¼÷4Ô\Z'),
(54736,'Win','x64','WoW','şXğ9Ù$ˆ†¢‚\'Ê/'),
(54762,'Win','x64','WoW','_ÚV\00%TE·Ej(lú'),
(54847,'Win','x64','WoW','2ı 51`ìQë6\\úÎò·'),
(54904,'Win','x64','WoW','	Ëì<\rê(¼§ŸÙ¸y°ã'),
(54988,'Win','x64','WoW','\'‘U2&‡w´ù×ñs'),
(55142,'Win','x64','WoW',')‹™µ­gê=*´³àzAS'),
(55165,'Win','x64','WoW','&ÔÑÀ4¨¦r=Ê¼”KoĞ'),
(55261,'Win','x64','WoW','„áS£İ‚I\'K‘z¬zí'),
(55461,'Win','x64','WoW','ÄR&tøTïìÇl‰ÉTP™'),
(55664,'Win','x64','WoW','ÛÊXHoª şTê(z0Gé#'),
(55666,'Win','x64','WoW','÷å¨M6¶RÈ¹×na|'),
(55792,'Win','x64','WoW','ÄŞÍªD¼Tğó»ƒ}!G'),
(55793,'Win','x64','WoW','ùÏ22­8Â†hÕ»d'),
(55818,'Win','x64','WoW',':›TbH÷ÙÙ°j,$'),
(55824,'Win','x64','WoW','Šo&š(–zˆxŸ´§'),
(55846,'Win','x64','WoW','»^ípXrÂ&ƒK•©éø©'),
(55933,'Win','x64','WoW','ÃMBË5@\rÒ!|ñ'),
(55939,'Win','x64','WoW','‘RŸLääåN&`¬Ü­Å'),
(55959,'Win','x64','WoW','íWàSÑÎ™±q¾4‚1H©'),
(55960,'Win','x64','WoW','Œlü{7Ş¯0l¯'),
(56008,'Win','x64','WoW','\0üÖ¿üÌºzqãên½'),
(56110,'Win','x64','WoW','€Ê\"/®7í<	â:'),
(56162,'Win','x64','WoW','o\\“ºCfe©M¶|å6N¨'),
(56196,'Mac','A64','WoW','wj]÷šNñ¸oe;0<ç'),
(56196,'Win','x64','WoW','ü\'KÿGÿùÈ±ªkí›'),
(56263,'Win','x64','WoW','ê„rÉ’6Ìa{õ©$MV'),
(56288,'Mac','A64','WoW','Aqy>ğ!r°nÁ‰m?'),
(56288,'Win','x64','WoW','TN5ĞH	8åÁ#‹:&½İ'),
(56311,'Mac','A64','WoW','A-2\0qZ¯Ü\"ß\Z”'),
(56311,'Win','x64','WoW','¬dWZîM2s_úĞÅr&²'),
(56313,'Mac','A64','WoW','¨>ÑæY¼•Ì2-I½í»'),
(56313,'Win','x64','WoW','ê÷i\0ššÓ±ªáÃDK'),
(56380,'Win','x64','WoW','ĞxD“#>(i“?Ìñ£Á'),
(56380,'Win','x64','WoWC','O³×-‰õÿİN„”¤æ'),
(56382,'Win','x64','WoW','gÃj>öUSLX­P”!’¿Ú'),
(56382,'Win','x64','WoWC','¥½z3ŸXÍEÍ\\~½ñ\"'),
(56421,'Mac','A64','WoW','X’ÿ«®ıÎËÿª¥]/›'),
(56421,'Mac','A64','WoWC','b–fÖÙïşKsÁí×F8Şª'),
(56421,'Mac','x64','WoW','OÍ÷ƒÄ„¿EÉƒ\'Şb'),
(56421,'Mac','x64','WoWC','Kaäôó² ÿ[H¦˜ûB'),
(56421,'Win','A64','WoW','ˆˆÇ`p|ÉÁÁÖ´[H8'),
(56421,'Win','x64','WoW',';ß©ªKp,‹ŒŞ<ÂU'),
(56421,'Win','x64','WoWC','\rÛ‡8d<ØıXZ:xí'),
(56461,'Mac','A64','WoW','åæêäS\"™öH°±'),
(56461,'Mac','A64','WoWC','…D|Ö•ÂÜ/a‹#™kJP<'),
(56461,'Mac','x64','WoW','âhxß47x/n“è3´Í„:'),
(56461,'Mac','x64','WoWC','‹`°İÕYg?ÑÁÚåˆY'),
(56461,'Win','A64','WoW','/†*·$	+™È¡ö§µ?j'),
(56461,'Win','x64','WoW','<Ø0ÄÕÃÛæîËG´'),
(56461,'Win','x64','WoWC','y½Lˆ/\r¤&×j7\"Ì'),
(56513,'Mac','A64','WoW','ÇçWàŞga’QùB¶ÉŠS·'),
(56513,'Mac','A64','WoWC','<ÀdFÕWÄÙ¦%\n¨Õ³‡'),
(56513,'Mac','x64','WoW','ÑD8$ã{sËÙ“Î-ú ˜'),
(56513,'Mac','x64','WoWC','êÙ ·aÄÉÈúÕLàÙkF'),
(56513,'Win','A64','WoW','u4h÷SèÓ„]k0'),
(56513,'Win','x64','WoW','›ØÑœÆEŸã.Ç	š¶'),
(56513,'Win','x64','WoWC','»Z5Âën &ÿàıëÖé'),
(56625,'Mac','A64','WoW','Ç­—¹—`Ğ½çªîø~-'),
(56625,'Mac','A64','WoWC','Ş½´X—Vs^ö3r&å'),
(56625,'Mac','x64','WoW','ëVeıÈ58”K¨.CZSæ'),
(56625,'Mac','x64','WoWC','ª[9£Ñ<‰óÙFpX6'),
(56625,'Win','A64','WoW','hAS‡>P#g…²pÚ‡–h'),
(56625,'Win','x64','WoW','€…œ#Ãçø\'‚G ŠŒ’'),
(56625,'Win','x64','WoWC','`ií!\"wıÛºä›æèÌ¯'),
(56647,'Mac','A64','WoW','µ¢]ïŒ]<tyäâ'),
(56647,'Mac','A64','WoWC','ğò¾ÃŞY\nç¥œÏÛB _'),
(56647,'Mac','x64','WoW','*‚\\|õU(¥íè}jä'),
(56647,'Win','A64','WoW','6ÄhãXYƒğ³ßËa'),
(56647,'Win','x64','WoW','.œEkfÀÕÊÖèız/êz'),
(56647,'Win','x64','WoWC','T:i«€-sØJ°ìMŒ¬'),
(56819,'Mac','A64','WoW','SÍ!ZbâÜ’ÍaÄû]ùÃ'),
(56819,'Mac','A64','WoWC','~ğ]4 dù1å2d4—'),
(56819,'Mac','x64','WoW','[~^YåJ;–åÌºnôe'),
(56819,'Mac','x64','WoWC','+ÜÙRº¤~l½qÇ€¼ŒÍG'),
(56819,'Win','A64','WoW','}ÇRG›V„¸(›ÅµÈ_?'),
(56819,'Win','x64','WoW','Csô^av63%igÕÕé'),
(56819,'Win','x64','WoWC','¹ä\"ßvÚc^;u½T­ØŞ'),
(57171,'Mac','A64','WoW','C\'(ŠˆëÜ¾Xò{£iæ'),
(57171,'Mac','A64','WoWC','\"y&Q8ùQo8,¡`Ê½±('),
(57171,'Mac','x64','WoW','(Õ#|%1Î\ZlT\r'),
(57171,'Mac','x64','WoWC','6³±©^2‰4¤7Ã'),
(57171,'Win','A64','WoW','ŸR±ñDÚ8_Œo‘gĞW'),
(57171,'Win','x64','WoW','–{™P<]z‹G”ö	H'),
(57171,'Win','x64','WoWC','>æ(ò6Úd,°¸bL„™'),
(57212,'Mac','A64','WoW','Zğ¯²Aú¢¯t…úbª	N'),
(57212,'Mac','A64','WoWC','¤±¶ºzìZïb/;Ø'),
(57212,'Mac','x64','WoW','ûYä¬oö‘¨z ik:ÄN'),
(57212,'Mac','x64','WoWC','2ë;µê`îÄ”_qÛÒ´ó'),
(57212,'Win','A64','WoW','¡ÙIĞbìIå¢—‹Ñ“,'),
(57212,'Win','x64','WoW','¸­µ}\'ï˜Èİï™C¾î”'),
(57212,'Win','x64','WoWC','Ñ‹yÎóK^ºŒwşm '),
(57292,'Mac','A64','WoW','«HÍÓD”@ê¦ç-C‘J8$'),
(57292,'Mac','A64','WoWC','Fæü9+hkÜÉ*m'),
(57292,'Mac','x64','WoW','7[4Vq’P<ÉùÈÆó'),
(57292,'Mac','x64','WoWC','åŸu0Ç¿÷|¶.bÔæÓîÈ'),
(57292,'Win','A64','WoW','ô+†-YÌÓ K-õ™Wa'),
(57292,'Win','x64','WoW','íƒS2}U8÷_¯.XM.ó'),
(57292,'Win','x64','WoWC','güVÌ–Æô¬â‘Q7Ybô'),
(57388,'Mac','A64','WoW','úo@c”Š·O³ıã5ÀÕ'),
(57388,'Mac','A64','WoWC','9b—Eõ~ó;»ÔÉ¨!W'),
(57388,'Mac','x64','WoW','çãC#W¼cN½{vº@ÕÒ'),
(57388,'Mac','x64','WoWC','¿ıÔM‰*!C¶µD4Œ'),
(57388,'Win','A64','WoW','’é-+¥öuÅŞd+‰'),
(57388,'Win','x64','WoW','ùËrLf.>€)¤BD<c'),
(57388,'Win','x64','WoWC','ßÙ¿ı\0ûïì¿\nïü-'),
(57534,'Mac','A64','WoW',';‚>‰‘ ß*ã=f\Z``'),
(57534,'Mac','A64','WoWC','È‚EYÜ$…§ã½	qùŠ'),
(57534,'Mac','x64','WoW','|gª­@ª«ƒ‹%\\ß'),
(57534,'Mac','x64','WoWC','ÎœÙ +ğÃ±&óÇá¿r('),
(57534,'Win','A64','WoW','Ìa/…ñXÈ²s}ı’ec'),
(57534,'Win','x64','WoW','”ˆW¿v¢ÒLZÑ‹O/Ï'),
(57534,'Win','x64','WoWC','b°*EÂ`h]D\"Â£'),
(57637,'Mac','A64','WoW','%Ûh+³µm³xDh•n'),
(57637,'Mac','A64','WoWC','r/ÊCZáé¤ÙnßÜû;'),
(57637,'Mac','x64','WoW','Ë²Uå1øËë	&¸âú'),
(57637,'Mac','x64','WoWC','¦~Ërh·şuœéO[2'),
(57637,'Win','A64','WoW','K9ÇJp5¶¡Ç™ğôüg5Ò'),
(57637,'Win','x64','WoW','lA…ésÉËƒ‚Ór\Zñf'),
(57637,'Win','x64','WoWC','qµxr9<+Ü»İÄ:&'),
(57689,'Mac','A64','WoW',']OdÂ…ğøÜéŠlÅ'),
(57689,'Mac','A64','WoWC','«=ø·Ÿ[®ƒ—d˜æS'),
(57689,'Mac','x64','WoW','˜„YyK80P¾B†ùy¢'),
(57689,'Mac','x64','WoWC','ÊzÙAøâ<â\'Ôu$r'),
(57689,'Win','A64','WoW','Iâ*!ai4ÍMqF‘tŒ'),
(57689,'Win','x64','WoW','“´åe\Z(ØÌN|çDyö'),
(57689,'Win','x64','WoWC','jíØ%N—÷7Ë¨RrŠt'),
(58123,'Mac','A64','WoW','|cÎŠ‰@ÔĞÇÏ™=Ç'),
(58123,'Mac','A64','WoWC','Ï&%0\r©Ì›m7œXµ'),
(58123,'Mac','x64','WoW','h˜`¦ë$¾ªĞ\"³¹'),
(58123,'Mac','x64','WoWC','07ûjs÷FÑ€\0±3'),
(58123,'Win','A64','WoW','„·\\ó€Ã³—¶:ûIb'),
(58123,'Win','x64','WoW',')\n Ö.ù–4Ì·µùö¬'),
(58123,'Win','x64','WoWC','-^î«W¯ş1…m\rêÇ9DÚ'),
(58162,'Mac','A64','WoW','k¹:ù\'‘æÍ¥Š_ ªÁ'),
(58162,'Mac','A64','WoWC','(Ó¤ò#áØóÏ‰;¿®ûÅ'),
(58162,'Mac','x64','WoW','GXk2½Uo Œ–mOÉÿ$'),
(58162,'Mac','x64','WoWC','èa1Vs—,˜fPÁ$!–ş'),
(58162,'Win','A64','WoW','[—Ô7bğñ¾Ç^™ÍÑ5'),
(58162,'Win','x64','WoW','Ú;H¹¦D†ò{©Ø…Vˆ'),
(58162,'Win','x64','WoWC','%n×qÜbŸ+Œõ&ºV,'),
(58187,'Mac','A64','WoW','ˆÙ“’mw}Á Y˜\0šsÖ'),
(58187,'Mac','A64','WoWC','yOÕÍvïô\0ƒs8‡k¦O'),
(58187,'Mac','x64','WoW','Şw )CÁV	ø„ÿf'),
(58187,'Mac','x64','WoWC','çw}ÎÛE·í>zß#¼±Ë'),
(58187,'Win','A64','WoW','ÿêÈ±µGıïÊ‹Ï0ßŸQ'),
(58187,'Win','x64','WoW','Ù,5ÖK	E™+å8\"ç'),
(58187,'Win','x64','WoWC','ŠÂÆ@5Ÿ\'l/aSú¢†8'),
(58238,'Mac','A64','WoW','‡pQväÒœ×Ü¤z=¸²é'),
(58238,'Mac','A64','WoWC','ìr·@ÑbB›JÌÆ7,='),
(58238,'Mac','x64','WoW','\Z@…+/^îâë€I{iˆ¯'),
(58238,'Mac','x64','WoWC','HâR!æøL¤–…¹–á4Z'),
(58238,'Win','A64','WoW','j¦ğ‚å5êpäÅ½…{'),
(58238,'Win','x64','WoW','‘öÒ<bğËSNKªOÁ'),
(58238,'Win','x64','WoWC','{J­É¥˜¤”Ö^©\\'),
(58533,'Mac','A64','WoW','æ7ª2ÕŞ‘KšöŒÉÉº«'),
(58533,'Mac','A64','WoWC','æ“İ\'\\îâÖ‚ì—=y%w'),
(58533,'Mac','x64','WoW','Ş7#ï~¹‘¡²v„æQ94Ö'),
(58533,'Mac','x64','WoWC','©>ô8Qt\0iô?ğß4W'),
(58533,'Win','A64','WoW','8#Òámn1H„ÍXiIRO,'),
(58533,'Win','x64','WoW','I\nOº	sà¶*Hæd'),
(58533,'Win','x64','WoWC','=Éâ/U=c\Z\\ g÷€š=-'),
(58608,'Mac','A64','WoW',':;c›ÃDí´1H`cñ'),
(58608,'Mac','A64','WoWC','FDíøkÔ]#°ò<ã‹'),
(58608,'Mac','x64','WoW',')ìø’ñšÙp{\'$­Ú'),
(58608,'Mac','x64','WoWC','+õa=‚­:$+]Ğ±@ÎD'),
(58608,'Win','A64','WoW','oØ­|Ë;}­E\\©=:hó'),
(58608,'Win','x64','WoW','!³íë\Ze8Õ˜€VÒ¾r²'),
(58608,'Win','x64','WoWC','¬eäÜ†şCbç+¼İthS'),
(58630,'Mac','A64','WoW','Z–O;>\'::ØbÅÃŠ'),
(58630,'Mac','A64','WoWC','<Ühı{´å)B(í‚i'),
(58630,'Mac','x64','WoW','\rXˆ¥úzÕÂFlë9†'),
(58630,'Mac','x64','WoWC','—Eçbl\r}\nWß±êO'),
(58630,'Win','A64','WoW','÷Jœ¹Ö‘‡€ÈâîàòMà'),
(58630,'Win','x64','WoW','ŒœÜÇ‰.ªêy=»ó°ÈP'),
(58630,'Win','x64','WoWC','Æ£c«:˜ôƒqá½®Ê'),
(58680,'Mac','A64','WoW','^æ«å8n†d+=ı©Ô'),
(58680,'Mac','A64','WoWC','\"Æ6»J»Ä­šèóm”wt'),
(58680,'Mac','x64','WoWC','¥ÿ!Üİ`µ<ù2s)i'),
(58680,'Win','A64','WoW','mÈ¾ÒeÈ˜ƒe“©æT¡á'),
(58680,'Win','x64','WoW','ÁÎÿIŸ,*¿å_eÏ\'Œ'),
(58680,'Win','x64','WoWC','\roÇ|80ª¨q©âËã€'),
(58773,'Mac','A64','WoW','RÔd²ßÀ*Æ˜óüùÁ'),
(58773,'Mac','A64','WoWC','ğëÕï#§ƒ¯qtä±°\Z'),
(58773,'Mac','x64','WoW','¬*VÜ±&9ô?ô;©©ù–'),
(58773,'Mac','x64','WoWC','„1ÂØZnãáÇ®ƒğŞ'),
(58773,'Win','A64','WoW','šß;pßvÎÁ–H¤£'),
(58773,'Win','x64','WoW','d„tŞéñjñÀ+Ö?>›'),
(58773,'Win','x64','WoWC','6,€ÄIúãÌ\nòCá3z'),
(58867,'Mac','A64','WoW','¢•‡pß¿Û“8Q¤ªÛIP'),
(58867,'Mac','A64','WoWC','\rtzY1ß[[\\Ä‰-cáØ'),
(58867,'Mac','x64','WoW','£imòª±O4\\C“û‰'),
(58867,'Mac','x64','WoWC','·Æ_ÁÚQÕ0@&/ïï¦'),
(58867,'Win','A64','WoW','ïŒ\"XÛÆÚ\\9i›Ş·¡'),
(58867,'Win','x64','WoW','|\'§2\\WúÒ\Z)Õ{¿€¦'),
(58867,'Win','x64','WoWC','?å„{dMovH”wT\r'),
(58911,'Mac','A64','WoW','Şæ}:İZ”Ç½¡æW'),
(58911,'Mac','A64','WoWC','m<$+<vhoîé±„DÁÇ'),
(58911,'Mac','x64','WoW','xÓWf®ÓŞ¸É\nÿƒ;'),
(58911,'Mac','x64','WoWC','¤ÈÛÈ¡Ÿ«ñº¤ƒÛš'),
(58911,'Win','A64','WoW','ğ!0º{ÿ,’ò_<b@²è'),
(58911,'Win','x64','WoW','^óAÙõ¢ym[×†¥½Z'),
(58911,'Win','x64','WoWC','©À¾¡·5e	gT ©\n'),
(59207,'Mac','A64','WoW','.Åê¢§W=€Š~‘]\0'),
(59207,'Mac','A64','WoWC','#£_Üf—aş¬“¿ ©&î'),
(59207,'Mac','x64','WoW','+—ÿ}ê‡éQİé\ZeÂY['),
(59207,'Mac','x64','WoWC','_¶\nÜ‚ÆP·	V¿¼w¼'),
(59207,'Win','A64','WoW','A¯=Ÿƒ1OÄ@kõÂ; «'),
(59207,'Win','x64','WoW','´ˆweGß–ÅS'),
(59207,'Win','x64','WoWC','©‹æ*÷A0JL\'8'),
(59302,'Mac','A64','WoW','p¦¾\0!;·\n¹lQ(\rrÑ†'),
(59302,'Mac','A64','WoWC','j\\ş\r:KŞÇÑm3é¬§×'),
(59302,'Mac','x64','WoW','ŸÙY\0\nú¢åñ\nJ¾3¬b¾'),
(59302,'Mac','x64','WoWC','Ó›Gı4-VËÂè_ÊWM'),
(59302,'Win','A64','WoW','`±u|§xœšÍo¶(Õ'),
(59302,'Win','x64','WoW','3N~ñà}¨8,6P×çµ'),
(59302,'Win','x64','WoWC','µ ÅOk3Eæ‚`ö3Nu“'),
(59347,'Mac','A64','WoW','Ç¸¶ù } ÌëúÃoÀs'),
(59347,'Mac','A64','WoWC','º¹†¥Û‰Fz¥a:k£E'),
(59347,'Mac','x64','WoW','\Z413¿\Z½¿ö²‡³|#'),
(59347,'Mac','x64','WoWC',':bL7îÉ·£­E2Ï'),
(59347,'Win','A64','WoW','€ÊÄŸn©šÆŒ©¸4Fl¥Ü'),
(59347,'Win','x64','WoW','c\"ƒ9S•RÑhU—ld„‹'),
(59347,'Win','x64','WoWC','»EúÅbë|óüL|\Zé:ö'),
(59425,'Mac','A64','WoW',' ï·Å¤8Î‡é›…'),
(59425,'Mac','A64','WoWC','8¹¡øv\\’|rLşN’Â'),
(59425,'Mac','x64','WoW','#\n|¢å³…ËN$¥•)'),
(59425,'Mac','x64','WoWC','°¿‚h‘)0=Ê\\ò³ŸP'),
(59425,'Win','A64','WoW','ôí&¢EN1°D±­VK}'),
(59425,'Win','x64','WoW','_ãã˜\n¡Ôíd$ÀÆ“-'),
(59425,'Win','x64','WoWC','ì¥Ú4Jùs°ÒZÁ?¶”¸'),
(59466,'Mac','A64','WoW','öË·«føšÜ¨PR¿®@'),
(59466,'Mac','A64','WoWC','!1ìïvVü90Üäa„'),
(59466,'Mac','x64','WoW','™]\'ÿ˜¨sh ‡£ñÃ'),
(59466,'Mac','x64','WoWC','Qa#.\Z‹?<§	ò¨M'),
(59466,'Win','A64','WoW','ğ˜l­dŒ{\'sj0Š'),
(59466,'Win','x64','WoW','ıgO[QÂwõÈP^”yÓ'),
(59466,'Win','x64','WoWC','Â™ËAn3.K¾Z¡ªé¤7'),
(59538,'Mac','A64','WoW','Üo]…·jíÌş(u'),
(59538,'Mac','A64','WoWC','ãN$õWú…î]l±¼bF'),
(59538,'Mac','x64','WoW','ËÃ–Ãâ\0yùÏ‹gÜÛî'),
(59538,'Mac','x64','WoWC','sİ£aŒ Ú§œ ¸”İ'),
(59538,'Win','A64','WoW','I‚°…o¡ 9¨µå]Ó'),
(59538,'Win','x64','WoW','r¹Ì8R>\Z0ûò= É«'),
(59538,'Win','x64','WoWC','¡˜¨ÿ00êÄ;tªH›¼'),
(59570,'Mac','A64','WoW','cÆÃ\06|@BXM§ø,'),
(59570,'Mac','A64','WoWC','oT!3úNá‰,ÿÑ\"'),
(59570,'Mac','x64','WoW','–‹¹Ô©\"Ã4\nwã‡'),
(59570,'Mac','x64','WoWC',')ĞÅÆãø@N§i0î’ç'),
(59570,'Win','A64','WoW','Óê]¾ô•ä \Zé‰èôLØ'),
(59570,'Win','x64','WoW','uqàÃEœ›ıÆKõ¯_'),
(59570,'Win','x64','WoWC','ÅÊ\"ôã–WîA_Ê¥=K#'),
(59679,'Mac','A64','WoW','rÆ»%Ô‡Š‘€… Ñ'),
(59679,'Mac','A64','WoWC','EË†\0·@KF°2<ÎK4\n'),
(59679,'Mac','x64','WoW','.<ÙØ9v»}VÓHœä\ry'),
(59679,'Mac','x64','WoWC','M(ŞŸ36$11PøqÄrï'),
(59679,'Win','A64','WoW','äC^æä–‹QæYk`î-¶'),
(59679,'Win','x64','WoW','TäÅ<]Á“”ŞMĞ6_â'),
(59679,'Win','x64','WoWC','²;ı™ëÍ‡.£’0áª¼Ñ›'),
(59888,'Mac','A64','WoW','¶BƒÿÈÕú^òhœ'),
(59888,'Mac','A64','WoWC','¹àÈÂ\ncÃ·ê€7¦–Œ'),
(59888,'Mac','x64','WoW','’Ö/;°ø¦ÿ+èV}'),
(59888,'Mac','x64','WoWC','°ô¯cìÅç˜¼I‚pé'),
(59888,'Win','A64','WoW','{Ç7F¹&ş¾ÉüµS'),
(59888,'Win','x64','WoW','¶¢ÄtRW*¿’\0ÁÊ’'),
(59888,'Win','x64','WoWC','pšÖõ‘™MAË¡ôŸ!#'),
(60037,'Mac','A64','WoW','-Ÿçnj“İ“ß\r=‹/­'),
(60037,'Mac','A64','WoWC','zàå€M×İ]p{çM²È'),
(60037,'Mac','x64','WoW','¼ĞQQ<Z·‹÷°¨ìåì'),
(60037,'Mac','x64','WoWC','dçmùœiØReiy‚†\0Î'),
(60037,'Win','A64','WoW','*I9ì„@«—é(*,Î>$'),
(60037,'Win','x64','WoW','GOõ.ô}GRñ8)Cr='),
(60037,'Win','x64','WoWC','uë½<%—ä£’K^'),
(60189,'Mac','A64','WoW','|S.MD)C\rT»ÕØƒ6'),
(60189,'Mac','A64','WoWC','ÏQÒ#Ô‹$oÁ:“v¨É3õ'),
(60189,'Mac','x64','WoW','YµnPÒ¡Óë(2_W¿ct('),
(60189,'Mac','x64','WoWC','@ÎfvÜGç}kíhm1B›æ'),
(60189,'Win','A64','WoW','è÷‰Çí‘L‡*ïmsQíø'),
(60189,'Win','x64','WoW','Ù£¬Ãá\"#ÙQÜ?¸®Ä'),
(60189,'Win','x64','WoWC','§ ¾-œ£ß½&p ­'),
(60228,'Mac','A64','WoW','±Lü÷Ù*äüô¼ÇÒc'),
(60228,'Mac','A64','WoWC','óÒjÌƒ£ülëIHÂwV'),
(60228,'Mac','x64','WoW','‹µQ‹Ğıj]­%'),
(60228,'Mac','x64','WoWC','ŸáÈ%•7ö°ø¹¼Ä#ÒA'),
(60228,'Win','A64','WoW','Ğ\\‘¨VNÜHê¿¶ùĞo'),
(60228,'Win','x64','WoW','[oÓ\rÌ7ÑÃÙË”¤N³N'),
(60228,'Win','x64','WoWC','ÎÄ%Mı#ÑªÈgb*'),
(60257,'Mac','A64','WoW','µ»º\0—ÒÊu]ºq¥Š'),
(60257,'Mac','A64','WoWC','ÜüDÂtRó·ã>æğ'),
(60257,'Mac','x64','WoW',':\rµì¾Ì¥ÈpO¤ÚS‰'),
(60257,'Mac','x64','WoWC','MB\0Ø›ñ:bŞßn&X\''),
(60257,'Win','A64','WoW',']â•W¥sñnÀÒ›%iS'),
(60257,'Win','x64','WoW','†3	¸†\Z«c‰<ÒAI`'),
(60257,'Win','x64','WoWC','m8oÚË«¨†¯®8&ş1ú'),
(60392,'Mac','A64','WoW',',¸®€;ÙE}Ößa('),
(60392,'Mac','A64','WoWC','ßÎ‰Ó‹UŠ—ãK‚ÓŒirÉ'),
(60392,'Mac','x64','WoW','İ?Bº$ğc—İ\0ú'),
(60392,'Mac','x64','WoWC','Şj?)WÆŠN\nºë…Gá\''),
(60392,'Win','A64','WoW','ñşì¯†àşôÖ¬ED'),
(60392,'Win','x64','WoW','Ò&\"˜x®…é‹ÚÿëA'),
(60392,'Win','x64','WoWC','‰láºÜlÑÖQi­c€;Õ'),
(60428,'Mac','A64','WoW','.}‚Ûm*¶©Õ#·sÁÙ!'),
(60428,'Mac','A64','WoWC','\r£Z†¯	…›\"ùÊá(ÍI'),
(60428,'Mac','x64','WoW','úôPS\0b	’ÍlÏ'),
(60428,'Mac','x64','WoWC','!ƒƒEgQ8üU\0+N+¹_7'),
(60428,'Win','A64','WoW','2¬a™PB¦5[ıŞb¼u'),
(60428,'Win','x64','WoW','&NZƒ\0Ë?½Ñƒ¿ôï­O'),
(60428,'Win','x64','WoWC','§(®éœèÒ™;\n±vÆh'),
(60490,'Mac','A64','WoW','¹(œF§XÏ»>O-¤èŒJ'),
(60490,'Mac','A64','WoWC','âËr+£	¹>Ğ¤_Ş$]'),
(60490,'Mac','x64','WoW','\nGø@Ìøâó|ù9{µ²'),
(60490,'Mac','x64','WoWC','„UqF.â%K\\W,‘ˆÚ'),
(60490,'Win','A64','WoW','½J‡Œÿó&&i5X)IòÍ'),
(60490,'Win','x64','WoW','¾	/*ê\0Í§æ‡_6e'),
(60490,'Win','x64','WoWC','\"‚$aÁb`Ñ$h‡_'),
(60568,'Mac','A64','WoW','G\'I‡s7yn‹,®tÛ'),
(60568,'Mac','A64','WoWC','L¶y4GV¤Ó¤Ü\rz©'),
(60568,'Mac','x64','WoW','—Îƒaµµğæ4cÃËŒES'),
(60568,'Mac','x64','WoWC','!^P¶å`Ğ“s.§©['),
(60568,'Win','A64','WoW','x‹.CO”Âó	d(æ'),
(60568,'Win','x64','WoW','.¡Á1W\'òÍòX¢'),
(60568,'Win','x64','WoWC','-\r~ƒ»®8z\':À'),
(60822,'Mac','A64','WoW','¯Á†‡â1‹¶ ä—+Z=i¿'),
(60822,'Mac','A64','WoWC','ŸnmOîĞĞû (BW..'),
(60822,'Mac','x64','WoW','Ş!nJ¥†\Z•&ä‘Lı†z'),
(60822,'Mac','x64','WoWC','À|¼eÀnÜÆÙ	¥vÚ'),
(60822,'Win','A64','WoW','V–İI62\r‡hŠ0•\n'),
(60822,'Win','x64','WoW',':¬_·hßÉ>«'),
(60822,'Win','x64','WoWC','_j{!×pô4ï”E÷'),
(61122,'Mac','A64','WoW','Ø˜ƒ\nïÀ\0ä\Zîª}ĞKQ'),
(61122,'Mac','A64','WoWC','X¯hn\Z7µPÓuÖË'),
(61122,'Mac','x64','WoW','V®ÿüş¸’¢¨ÄxŠğ:×¼'),
(61122,'Win','A64','WoW','šÄ5yş‹äçj %\Z/V<a'),
(61122,'Win','x64','WoW',']æ³àm8àVmÖ F™'),
(61122,'Win','x64','WoWC','„Ÿá\Z§òXZF‘ôQ'),
(61188,'Mac','A64','WoW','_ì¤º^\\şM–^”ÃŸîqŠ'),
(61188,'Mac','A64','WoWC','£ò¸=z~5ª0ÿÏÚèá'),
(61188,'Mac','x64','WoW','_§ı…¼ç^†›Ûèy’8'),
(61188,'Mac','x64','WoWC','ÇÒÃÁ4ÅtM½2Åcµ¾œ‰'),
(61188,'Win','A64','WoW','™›÷Ô8“ï$sU8‘U°ç'),
(61188,'Win','x64','WoW','ø¤.±F¤İÙOÓ_ù­uß'),
(61188,'Win','x64','WoWC','C˜:Md5“ŸnçêéUÖÈª'),
(61265,'Mac','A64','WoW','Ş©bÚî%R¤2®0u<='),
(61265,'Mac','A64','WoWC',':îĞ§³Ä)ğÔ„¸Y'),
(61265,'Mac','x64','WoW','ßtÙƒŞÑhƒ‚›îI'),
(61265,'Mac','x64','WoWC','¦ä iQ\r^°á^!ß'),
(61265,'Win','A64','WoW','‡ĞS@ŞÅ¹e“^ 5§'),
(61265,'Win','x64','WoW','ÚÆUìÔy\\6â§ßc«~9'),
(61265,'Win','x64','WoWC','Àa¥…†å°¡4¼S¸Ï¥'),
(61491,'Mac','A64','WoW','jcù±B(¸ZôîŸj­-Á'),
(61491,'Mac','A64','WoWC','&: Ä{šòŞÌbÏ¼‡¸'),
(61491,'Mac','x64','WoW','BuB\"ûïK‡*³OZSg'),
(61491,'Mac','x64','WoWC','•ŞL«4_ã\'¢¹ÄÊó'),
(61491,'Win','A64','WoW','¤.æfÀOYÎ__dXÔ'),
(61491,'Win','x64','WoW','ìã+H3º\"<3îÔÀÑ'),
(61491,'Win','x64','WoWC','Nl\'I\r“,y…ñ’¬5æ'),
(61559,'Mac','A64','WoW','<&ÉÖgBô<\\SdÏ'),
(61559,'Mac','A64','WoWC','2ö«‡ééwkê¬è¶h:9º'),
(61559,'Mac','x64','WoW','Òœ±îàµ••áE¸©b`'),
(61559,'Mac','x64','WoWC','ç9xÉWh3óf”)06åT	'),
(61559,'Win','A64','WoW','ªzÕbIyë6¦–:Ÿ}à¹'),
(61559,'Win','x64','WoW','’Šs)õ>\'8‘ØZ—2HÀ'),
(61559,'Win','x64','WoWC','Ùår8İB´Nhğ]Y¦#K'),
(61609,'Mac','A64','WoW',';_=-Ş²š»m´ò8É'),
(61609,'Mac','A64','WoWC','YIó®+Q£°1U¡9Rè/w'),
(61609,'Mac','x64','WoW','|†eîÓäÉè²üIrôcl'),
(61609,'Mac','x64','WoWC','6ûËĞÌzˆª¯›ÓÏü'),
(61609,'Win','A64','WoW','!I?ŒÚfB®¨rCQ'),
(61609,'Win','x64','WoW','ŸÀ,Å†Š’\\İB¨×ùÚ'),
(61609,'Win','x64','WoWC','ôÊl!Q´´~Ã«eÆT'),
(61967,'Mac','A64','WoW','Ú¶÷xÃu1%ZÂ/?¹^ª'),
(61967,'Mac','A64','WoWC','?ÿiŸ“‹p|Š~\0'),
(61967,'Mac','x64','WoW','+´ò·„˜q¨ù_îóWé'),
(61967,'Mac','x64','WoWC','MãÔ@ÑÔj8ì2ĞÕ$\0Jº'),
(61967,'Win','A64','WoW','{D;¶´óU¹ã‰ôğ¬°Oè'),
(61967,'Win','x64','WoW','nKKSvà•8zÿM'),
(61967,'Win','x64','WoWC','[ğ´İ!¯1Šër€'),
(62213,'Mac','A64','WoW','N´y¡ …Ï¥–3ÛÊÚ'),
(62213,'Mac','A64','WoWC','\"Å«C¢—bƒÄÄ`º'),
(62213,'Mac','x64','WoW','”Õ°©b3Äğh¥÷ı^Æ'),
(62213,'Mac','x64','WoWC','º£ºüO’	¯¹í¤È»Pl'),
(62213,'Win','A64','WoW','õeæ2ËÀEò5ò¤Æi'),
(62213,'Win','x64','WoW','%”>©u>$v«N!¼'),
(62213,'Win','x64','WoWC','…„#~5qˆÍS•x²'),
(62417,'Mac','A64','WoW','»¦,e90•®ü:'),
(62417,'Mac','A64','WoWC','Ú{µç˜…jg´Bëh=Õ'),
(62417,'Mac','x64','WoW','RYe¥ŸL\ZˆnkÌ	×Z'),
(62417,'Mac','x64','WoWC','É²v±›ZY·ùã'),
(62417,'Win','A64','WoW','Üt¯$•2ï6p#Çæ÷	'),
(62417,'Win','x64','WoW','p/Èmy&,Ó9:ë?[ˆæ'),
(62417,'Win','x64','WoWC','¹{%z=i»£!ŞÁBu‘êÖ'),
(62438,'Mac','A64','WoW','\\—MoH÷z`Ñ%+'),
(62438,'Mac','A64','WoWC','3>ï]	…”Ğ“ûUfÄ'),
(62438,'Mac','x64','WoW','èéó\'{™\\?·j”r1m'),
(62438,'Mac','x64','WoWC','-’úÉ{á`<÷Ä&ã'),
(62438,'Win','A64','WoW','_C¹Ç}¦1ªõå\'ük º'),
(62438,'Win','x64','WoW','T¸\ny¸¥ÅâSf«Wğ¬°'),
(62438,'Win','x64','WoWC','Êä\Z×Ïœ.…ãˆ»ïm'),
(62493,'Mac','A64','WoW','5f>õ8%~—hH”Ü'),
(62493,'Mac','A64','WoWC','ZHÓ¤2x¦ê1²ã®\rææ'),
(62493,'Mac','x64','WoW','îÄ\'Éô„ïªÀHÕR'),
(62493,'Mac','x64','WoWC','°¡×ê5X‘cEÍ„.'),
(62493,'Win','A64','WoW','0%ÙEgy/¨(L(.wå'),
(62493,'Win','x64','WoW','[pz¶:†,.¨Hr '),
(62493,'Win','x64','WoWC','\Ze¹4ÔNğ§ty=	‚&'),
(62680,'Mac','A64','WoW','RÓÏø®rMñµ(Š‹'),
(62680,'Mac','A64','WoWC','»ò7~ƒ¹€²P²øŒ©'),
(62680,'Mac','x64','WoW','èäÙÅ8Úµö#ëó÷¥¨'),
(62680,'Mac','x64','WoWC','¬¯O.\'ÏÍ\0x{±™ù/,'),
(62680,'Win','A64','WoW','û‡ŸKe7A#ÏY¦PˆZX'),
(62680,'Win','x64','WoW','.MŞŞ#<†¾yg\Z…J‰'),
(62680,'Win','x64','WoWC','S–±ÙVc»·«\0;¶Ğº^'),
(62706,'Mac','A64','WoW','srÒŒfoxErİhL{ã4'),
(62706,'Mac','A64','WoWC','\0gõ{Û‘o$†Û6'),
(62706,'Mac','x64','WoW','ÃLKâUáW‹È£{F/'),
(62706,'Mac','x64','WoWC','¼úä!şÔt‹®•égîí'),
(62706,'Win','A64','WoW','0¬İ€¡ëWÆ§òä/\0ü}#'),
(62706,'Win','x64','WoW','âÔf4hK‘7dYÛrb„ñâ'),
(62706,'Win','x64','WoWC','°œ§Ôìr,=¥@­AF'),
(62748,'Mac','A64','WoW','œ¬ûãı¨=¬SB‚!'),
(62748,'Mac','A64','WoWC','‡§C_çïfû}¥`‰Ğq'),
(62748,'Mac','x64','WoW','ƒ¦Fw4ë/%áš!g1'),
(62748,'Mac','x64','WoWC','¹¦t(¹¦XìZêJ<úÃ'),
(62748,'Win','A64','WoW','VÅ1çÓt…ÚÒZ+Ä¤›†'),
(62748,'Win','x64','WoW','	ŸæÜ:Ğu\r¨Ğ2´'),
(62748,'Win','x64','WoWC','nÊ3(RÙ¿÷|â©×\Z—mU'),
(62801,'Mac','A64','WoW','G\'\0°ù¤êÃKG·('),
(62801,'Mac','A64','WoWC','ò1º‹uã¸¢.K`#A¿b'),
(62801,'Mac','x64','WoWC','‚m,\\M)p‡5…İÄt='),
(62801,'Win','A64','WoW','ßÈ4\r³Yiä·“ï)Š:â·'),
(62801,'Win','x64','WoW','Œo«òš¼YŸ¯¡ãËw'),
(62801,'Win','x64','WoWC','UÄ•ã2|\'§å\ZÚîB'),
(62876,'Mac','A64','WoW','“ÙzçüõÕ5<Ãhˆ+¦«'),
(62876,'Mac','A64','WoWC','~®¤_\rùXxªKl\n;'),
(62876,'Mac','x64','WoW','É²,IşEÑèŸ…ãñGN'),
(62876,'Mac','x64','WoWC','4èµòsSXçº•Òƒ'),
(62876,'Win','A64','WoW',' ¾ƒâ|±İæÊéŞ­íÒÎ'),
(62876,'Win','x64','WoW','GzİÔƒ‹|ôãÈ$7º'),
(62876,'Win','x64','WoWC','Í6Ú«õïõKG¼%ô@ŠT'),
(62958,'Mac','A64','WoW','îwÖ¿¤[«õ?äÇrWE™¦'),
(62958,'Mac','A64','WoWC','}8`ù°éå9’Bôêì†\r'),
(62958,'Mac','x64','WoW','cûì§ÑYiT’‡9,|±š'),
(62958,'Mac','x64','WoWC','21l‹:ôıÏzgıwi§ñ+'),
(62958,'Win','A64','WoW','d•¤:JÚŠH'),
(62958,'Win','x64','WoW','×/‘;UÉ,XEÏ¶‡x?'),
(62958,'Win','x64','WoWC','nvz×Y¢±œ(‘\'¤Ô®­'),
(63003,'Mac','A64','WoW','Ãßñù\0·MÑÆ\0Y×>o'),
(63003,'Mac','A64','WoWC',';¬ÑÀ¦I›n›•ƒ;Ÿ'),
(63003,'Mac','x64','WoW','|à!ãØÒS÷#\Z¯MìJ'),
(63003,'Mac','x64','WoWC','Qt{Òškc]ˆØêRöÓA'),
(63003,'Win','A64','WoW','\0ò@=ØíùÓŞõ¯Q¦Ü'),
(63003,'Win','x64','WoW','m5Mû8…V×¸˜Â'),
(63003,'Win','x64','WoWC',',uÔ÷_B0¥qn™Z'),
(63163,'Mac','A64','WoW','¨Úøx?¼íÈ8ğmù3~´'),
(63163,'Mac','A64','WoWC','¤GÚ8ñ)™Ælo@<ë!'),
(63163,'Mac','x64','WoW','9jù\r•ÌO\rò¥Œ;ãÚlU'),
(63163,'Mac','x64','WoWC','\rsÁ\'«Ì9Ë¹‰vø|\rI'),
(63163,'Win','A64','WoW','ØauJø¿ù­U´\rO'),
(63163,'Win','x64','WoW','y&vü8ëè¾À]äx¸ß'),
(63163,'Win','x64','WoWC','è1Ï‰)ì™*S‰‚+à'),
(63305,'Mac','A64','WoW','\"çÀZêı¬ÿÂ®K\'Ş'),
(63305,'Mac','A64','WoWC','¾°ò[!ô>õ*ğú¥ræè'),
(63305,'Mac','x64','WoW','şm5Ù\Z#±Œ>ÉÏX|²'),
(63305,'Mac','x64','WoWC','\r`\n—Ç x(òŞÀÜ¤›À¨'),
(63305,'Win','A64','WoW','ºfïÕ\"ë,Ü?ùKÍ‘Ê'),
(63305,'Win','x64','WoW','“Ä;jiÊ7ñ\\hª¸æ“!'),
(63305,'Win','x64','WoWC','G»¸Ò¬M ×OïÀİ2”'),
(63506,'Mac','A64','WoW','ŞRœAÊdÈ9í&¿N'),
(63506,'Mac','A64','WoWC','w¬‡‘Î¢Û_‡!Z-`'),
(63506,'Mac','x64','WoW','?#ëâ¨ ÂÈ0å,›Õ³'),
(63506,'Mac','x64','WoWC',' Ò p·‹ıîs‚|€ÎÛÜ'),
(63506,'Win','A64','WoW','m]Æ8¿Jæ½ÃJ¸bJêI§'),
(63506,'Win','x64','WoW','hc;ÎZ¤ƒœF¹Çò1'),
(63506,'Win','x64','WoWC','-=™:õOÌ„cø€úÿ'),
(63660,'Mac','A64','WoW','¥ı`¶ş`\rÍAÚÔßüóÊ'),
(63660,'Mac','A64','WoWC','Ã:UÿÁ«Œ\\¶ÒÉ_M0'),
(63660,'Mac','x64','WoW','[¨ü ˜»½Ÿ³x¹[am¦'),
(63660,'Mac','x64','WoWC','Rº\nk$2×XOYzı8À…'),
(63660,'Win','A64','WoW','XÍôÚ¯¡!\ZûÄöhµ'),
(63660,'Win','x64','WoW','Öß´¾—éT½L\rÌ<'),
(63660,'Win','x64','WoWC','vªõŠi‰\'Ù\"mê«­Ã'),
(63704,'Mac','A64','WoW','ˆ¦çú™ÖèBÿ´ÛjP] '),
(63704,'Mac','A64','WoWC','ôö|Ú9©jc0ı[3\Z'),
(63704,'Mac','x64','WoW','lÍ¯ÒL¿ÕÄ–\n—ù'),
(63704,'Mac','x64','WoWC','öº	>à›xÜ^pÿ§Êäœ'),
(63704,'Win','A64','WoW','…[œı…©F¯®ï,÷¹ˆÌ'),
(63704,'Win','x64','WoW','|´ƒëÕ)pĞË»yRlêú'),
(63704,'Win','x64','WoWC','I…ëÕşxëÇÔïny'),
(63796,'Mac','A64','WoW','7ÆÖráÆ€YK7Mâ•uŸ'),
(63796,'Mac','A64','WoWC','_ˆ-U%zU¦‚…ä'),
(63796,'Mac','x64','WoW','¡T¶Õ˜\Z«áĞ‰ív`b'),
(63796,'Mac','x64','WoWC','˜t–V¥èDıèèŸÜM¶'),
(63796,'Win','A64','WoW','ñ±UŒŞğdèĞ×Ğ”c'),
(63796,'Win','x64','WoW','-O¶Z+ªBˆW/ŒJTh'),
(63796,'Win','x64','WoWC','C––®=(ç@à?A'),
(63834,'Mac','A64','WoW','ûÛKı˜úò,Œû‘Ô°ÏV'),
(63834,'Mac','A64','WoWC','zÂ Ë¼$£T~D­'),
(63834,'Mac','x64','WoW','ÑäË‰lTœ.@CÎYo'),
(63834,'Mac','x64','WoWC','ÁÑm(“ u)õK\r”x'),
(63834,'Win','A64','WoW','š¿3b@¨ÕØ¥8Ê\0˜	'),
(63834,'Win','x64','WoW','§ç9ğı÷E¨yyìèkò'),
(63834,'Win','x64','WoWC','g€Š¡çŠ¯İ4Ppô«@İ\\'),
(63906,'Mac','A64','WoW','$˜·@“&›Â¥—¿6‹ø'),
(63906,'Mac','A64','WoWC','\ZkrÚPÎ„¿Bò•-'),
(63906,'Mac','x64','WoW','<Ö¶8ŞÔ€ö¸‹œR¹'),
(63906,'Mac','x64','WoWC','l“÷xºĞp~¥qWÔ'),
(63906,'Win','A64','WoW','^Ê¶Íbhğ+:Ì˜JWi'),
(63906,'Win','x64','WoW','¥ÚÂeÕgÁñ(3‘&Æ'),
(63906,'Win','x64','WoWC','Ë,nP‚ÂRŸlÒææÙ'),
(64154,'Mac','A64','WoW','+Gh{—ûQïÌ(\'Kğ”ï{'),
(64154,'Mac','A64','WoWC','go;\\Ù\'™µÎnËıBë¼–'),
(64154,'Mac','x64','WoW','ÓŸ;Í4Ü,İ·>©Ú\0'),
(64154,'Mac','x64','WoWC','Ag/Ò\0‚Ÿ+9é¦7İ½'),
(64154,'Win','A64','WoW','½æa¯ıR\nSia ˜‘:'),
(64154,'Win','x64','WoW',' ]qv*,Qj\\ãk5Â'),
(64154,'Win','x64','WoWC','8÷„I^ĞŸó‘²~ÃEHà'),
(64270,'Mac','A64','WoW','’\0!‰ù‹År|e\0C\\'),
(64270,'Mac','A64','WoWC','ê&!H1³\nËÂQ*àç'),
(64270,'Mac','x64','WoW','m`«/#E<#fD=t‚F0È'),
(64270,'Mac','x64','WoWC','Š« ¼tö(XÏ4“cu‰'),
(64270,'Win','A64','WoW','èİ“ kë‡…€¼(‚&‘'),
(64270,'Win','x64','WoW','`ëí¶„#‰>L1~´I¡·'),
(64270,'Win','x64','WoWC','Em:öÇì™g³mô9Å[Ğî');
/*!40000 ALTER TABLE `build_auth_key` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `build_executable_hash`
--

DROP TABLE IF EXISTS `build_executable_hash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `build_executable_hash` (
  `build` int(11) NOT NULL,
  `platform` char(4) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `executableHash` binary(20) NOT NULL,
  PRIMARY KEY (`build`,`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `build_executable_hash`
--

LOCK TABLES `build_executable_hash` WRITE;
/*!40000 ALTER TABLE `build_executable_hash` DISABLE KEYS */;
INSERT INTO `build_executable_hash` VALUES
(5875,'OSX','<Ã–ë«ó6õæg[µå'),
(5875,'Win','•í²|x#³cËİ«V£’çËsüÊ '),
(8606,'OSX','Ø°ìşSKÁºÑÔÀèîä™O'),
(8606,'Win','1šú£òU–‚ùÿe‹àV%_Eo±'),
(12340,'OSX','·Ñ?òôˆ9r”aãø âµıÀ4'),
(12340,'Win','ÍË½Qˆ1^kMDI-¼úñV£G');
/*!40000 ALTER TABLE `build_executable_hash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `build_info`
--

DROP TABLE IF EXISTS `build_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `build_info` (
  `build` int(11) NOT NULL,
  `majorVersion` int(11) DEFAULT NULL,
  `minorVersion` int(11) DEFAULT NULL,
  `bugfixVersion` int(11) DEFAULT NULL,
  `hotfixVersion` char(3) DEFAULT NULL,
  PRIMARY KEY (`build`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `build_info`
--

LOCK TABLES `build_info` WRITE;
/*!40000 ALTER TABLE `build_info` DISABLE KEYS */;
INSERT INTO `build_info` VALUES
(5875,1,12,1,NULL),
(6005,1,12,2,NULL),
(6141,1,12,3,NULL),
(8606,2,4,3,NULL),
(9947,3,1,3,NULL),
(10505,3,2,2,'a'),
(11159,3,3,0,'a'),
(11403,3,3,2,NULL),
(11723,3,3,3,'a'),
(12340,3,3,5,'a'),
(13623,4,0,6,'a'),
(13930,3,3,5,'a'),
(14545,4,2,2,NULL),
(15595,4,3,4,NULL),
(19116,6,0,3,NULL),
(19243,6,0,3,NULL),
(19342,6,0,3,NULL),
(19702,6,1,0,NULL),
(19802,6,1,2,NULL),
(19831,6,1,2,NULL),
(19865,6,1,2,NULL),
(20182,6,2,0,'a'),
(20201,6,2,0,NULL),
(20216,6,2,0,NULL),
(20253,6,2,0,NULL),
(20338,6,2,0,NULL),
(20444,6,2,2,NULL),
(20490,6,2,2,'a'),
(20574,6,2,2,'a'),
(20726,6,2,3,NULL),
(20779,6,2,3,NULL),
(20886,6,2,3,NULL),
(21355,6,2,4,NULL),
(21463,6,2,4,NULL),
(21742,6,2,4,NULL),
(22248,7,0,3,NULL),
(22293,7,0,3,NULL),
(22345,7,0,3,NULL),
(22410,7,0,3,NULL),
(22423,7,0,3,NULL),
(22498,7,0,3,NULL),
(22522,7,0,3,NULL),
(22566,7,0,3,NULL),
(22594,7,0,3,NULL),
(22624,7,0,3,NULL),
(22747,7,0,3,NULL),
(22810,7,0,3,NULL),
(22900,7,1,0,NULL),
(22908,7,1,0,NULL),
(22950,7,1,0,NULL),
(22995,7,1,0,NULL),
(22996,7,1,0,NULL),
(23171,7,1,0,NULL),
(23222,7,1,0,NULL),
(23360,7,1,5,NULL),
(23420,7,1,5,NULL),
(23911,7,2,0,NULL),
(23937,7,2,0,NULL),
(24015,7,2,0,NULL),
(24330,7,2,5,NULL),
(24367,7,2,5,NULL),
(24415,7,2,5,NULL),
(24430,7,2,5,NULL),
(24461,7,2,5,NULL),
(24742,7,2,5,NULL),
(25549,7,3,2,NULL),
(25996,7,3,5,NULL),
(26124,7,3,5,NULL),
(26365,7,3,5,NULL),
(26654,7,3,5,NULL),
(26822,7,3,5,NULL),
(26899,7,3,5,NULL),
(26972,7,3,5,NULL),
(28153,8,0,1,NULL),
(30706,8,1,5,NULL),
(30993,8,2,0,NULL),
(31229,8,2,0,NULL),
(31429,8,2,0,NULL),
(31478,8,2,0,NULL),
(32305,8,2,5,NULL),
(32494,8,2,5,NULL),
(32580,8,2,5,NULL),
(32638,8,2,5,NULL),
(32722,8,2,5,NULL),
(32750,8,2,5,NULL),
(32978,8,2,5,NULL),
(33369,8,3,0,NULL),
(33528,8,3,0,NULL),
(33724,8,3,0,NULL),
(33775,8,3,0,NULL),
(33941,8,3,0,NULL),
(34220,8,3,0,NULL),
(34601,8,3,0,NULL),
(34769,8,3,0,NULL),
(34963,8,3,0,NULL),
(35249,8,3,7,NULL),
(35284,8,3,7,NULL),
(35435,8,3,7,NULL),
(35662,8,3,7,NULL),
(36753,9,0,2,NULL),
(36839,9,0,2,NULL),
(36949,9,0,2,NULL),
(37142,9,0,2,NULL),
(37176,9,0,2,NULL),
(37474,9,0,2,NULL),
(38134,9,0,5,NULL),
(38556,9,0,5,NULL),
(39653,9,1,0,NULL),
(39804,9,1,0,NULL),
(40000,9,1,0,NULL),
(40120,9,1,0,NULL),
(40443,9,1,0,NULL),
(40593,9,1,0,NULL),
(40725,9,1,0,NULL),
(40906,9,1,5,NULL),
(40944,9,1,5,NULL),
(40966,9,1,5,NULL),
(41031,9,1,5,NULL),
(41079,9,1,5,NULL),
(41288,9,1,5,NULL),
(41323,9,1,5,NULL),
(41359,9,1,5,NULL),
(41488,9,1,5,NULL),
(41793,9,1,5,NULL),
(42010,9,1,5,NULL),
(42423,9,2,0,NULL),
(42488,9,2,0,NULL),
(42521,9,2,0,NULL),
(42538,9,2,0,NULL),
(42560,9,2,0,NULL),
(42614,9,2,0,NULL),
(42698,9,2,0,NULL),
(42825,9,2,0,NULL),
(42852,9,2,0,NULL),
(42937,9,2,0,NULL),
(42979,9,2,0,NULL),
(43114,9,2,0,NULL),
(43206,9,2,0,NULL),
(43340,9,2,0,NULL),
(43345,9,2,0,NULL),
(43971,9,2,5,NULL),
(44015,9,2,5,NULL),
(44061,9,2,5,NULL),
(44127,9,2,5,NULL),
(44232,9,2,5,NULL),
(44325,9,2,5,NULL),
(44730,9,2,5,NULL),
(44908,9,2,5,NULL),
(45114,9,2,7,NULL),
(45161,9,2,7,NULL),
(45338,9,2,7,NULL),
(45745,9,2,7,NULL),
(46479,10,0,2,NULL),
(46658,10,0,2,NULL),
(46689,10,0,2,NULL),
(46702,10,0,2,NULL),
(46741,10,0,2,NULL),
(46801,10,0,2,NULL),
(46879,10,0,2,NULL),
(46924,10,0,2,NULL),
(47067,10,0,2,NULL),
(47187,10,0,2,NULL),
(47213,10,0,2,NULL),
(47631,10,0,2,NULL),
(47777,10,0,5,NULL),
(47799,10,0,5,NULL),
(47825,10,0,5,NULL),
(47849,10,0,5,NULL),
(47871,10,0,5,NULL),
(47884,10,0,5,NULL),
(47936,10,0,5,NULL),
(47967,10,0,5,NULL),
(48001,10,0,5,NULL),
(48069,10,0,5,NULL),
(48317,10,0,5,NULL),
(48397,10,0,5,NULL),
(48526,10,0,5,NULL),
(48676,10,0,7,NULL),
(48749,10,0,7,NULL),
(48838,10,0,7,NULL),
(48865,10,0,7,NULL),
(48892,10,0,7,NULL),
(48966,10,0,7,NULL),
(48999,10,0,7,NULL),
(49267,10,0,7,NULL),
(49318,10,1,0,NULL),
(49343,10,0,7,NULL),
(49407,10,1,0,NULL),
(49426,10,1,0,NULL),
(49444,10,1,0,NULL),
(49474,10,1,0,NULL),
(49570,10,1,0,NULL),
(49679,10,1,0,NULL),
(49741,10,1,0,NULL),
(49801,10,1,0,NULL),
(49890,10,1,0,NULL),
(50000,10,1,0,NULL),
(50401,10,1,5,NULL),
(50438,10,1,5,NULL),
(50467,10,1,5,NULL),
(50469,10,1,5,NULL),
(50504,10,1,5,NULL),
(50585,10,1,5,NULL),
(50622,10,1,5,NULL),
(50747,10,1,5,NULL),
(50791,10,1,5,NULL),
(51130,10,1,5,NULL),
(51187,10,1,7,NULL),
(51237,10,1,7,NULL),
(51261,10,1,7,NULL),
(51313,10,1,7,NULL),
(51421,10,1,7,NULL),
(51485,10,1,7,NULL),
(51536,10,1,7,NULL),
(51754,10,1,7,NULL),
(51886,10,1,7,NULL),
(51972,10,1,7,NULL),
(52038,10,2,0,NULL),
(52068,10,2,0,NULL),
(52095,10,2,0,NULL),
(52106,10,2,0,NULL),
(52129,10,2,0,NULL),
(52148,10,2,0,NULL),
(52188,10,2,0,NULL),
(52301,10,2,0,NULL),
(52393,10,2,0,NULL),
(52485,10,2,0,NULL),
(52545,10,2,0,NULL),
(52607,10,2,0,NULL),
(52649,10,2,0,NULL),
(52808,10,2,0,NULL),
(52902,10,2,5,NULL),
(52968,10,2,5,NULL),
(52983,10,2,5,NULL),
(53007,10,2,5,NULL),
(53040,10,2,5,NULL),
(53104,10,2,5,NULL),
(53162,10,2,5,NULL),
(53212,10,2,5,NULL),
(53262,10,2,5,NULL),
(53441,10,2,5,NULL),
(53584,10,2,5,NULL),
(53840,10,2,6,NULL),
(53877,10,2,6,NULL),
(53913,10,2,6,NULL),
(53989,10,2,6,NULL),
(54070,10,2,6,NULL),
(54205,10,2,6,NULL),
(54358,10,2,6,NULL),
(54499,10,2,6,NULL),
(54577,10,2,7,NULL),
(54601,10,2,7,NULL),
(54604,10,2,7,NULL),
(54630,10,2,7,NULL),
(54673,10,2,7,NULL),
(54717,10,2,7,NULL),
(54736,10,2,7,NULL),
(54762,10,2,7,NULL),
(54847,10,2,7,NULL),
(54904,10,2,7,NULL),
(54988,10,2,7,NULL),
(55142,10,2,7,NULL),
(55165,10,2,7,NULL),
(55261,10,2,7,NULL),
(55461,10,2,7,NULL),
(55664,10,2,7,NULL),
(55666,11,0,0,NULL),
(55792,11,0,0,NULL),
(55793,11,0,0,NULL),
(55818,11,0,0,NULL),
(55824,11,0,0,NULL),
(55846,11,0,0,NULL),
(55933,11,0,0,NULL),
(55939,11,0,0,NULL),
(55959,11,0,2,NULL),
(55960,11,0,0,NULL),
(56008,11,0,0,NULL),
(56110,11,0,2,NULL),
(56162,11,0,2,NULL),
(56196,11,0,2,NULL),
(56263,11,0,2,NULL),
(56288,11,0,2,NULL),
(56311,11,0,2,NULL),
(56313,11,0,2,NULL),
(56380,11,0,2,NULL),
(56382,11,0,2,NULL),
(56421,11,0,2,NULL),
(56461,11,0,2,NULL),
(56513,11,0,2,NULL),
(56625,11,0,2,NULL),
(56647,11,0,2,NULL),
(56819,11,0,2,NULL),
(57171,11,0,5,NULL),
(57212,11,0,5,NULL),
(57292,11,0,5,NULL),
(57388,11,0,5,NULL),
(57534,11,0,5,NULL),
(57637,11,0,5,NULL),
(57689,11,0,5,NULL),
(58123,11,0,7,NULL),
(58162,11,0,7,NULL),
(58187,11,0,7,NULL),
(58238,11,0,7,NULL),
(58533,11,0,7,NULL),
(58608,11,0,7,NULL),
(58630,11,0,7,NULL),
(58680,11,0,7,NULL),
(58773,11,0,7,NULL),
(58867,11,0,7,NULL),
(58911,11,0,7,NULL),
(59207,11,0,7,NULL),
(59302,11,0,7,NULL),
(59347,11,1,0,NULL),
(59425,11,1,0,NULL),
(59466,11,1,0,NULL),
(59538,11,1,0,NULL),
(59570,11,1,0,NULL),
(59679,11,1,0,NULL),
(59888,11,1,0,NULL),
(60037,11,1,0,NULL),
(60189,11,1,0,NULL),
(60228,11,1,0,NULL),
(60257,11,1,0,NULL),
(60392,11,1,5,NULL),
(60428,11,1,5,NULL),
(60490,11,1,5,NULL),
(60568,11,1,5,NULL),
(60822,11,1,5,NULL),
(61122,11,1,5,NULL),
(61188,11,1,5,NULL),
(61265,11,1,5,NULL),
(61491,11,1,7,NULL),
(61559,11,1,7,NULL),
(61609,11,1,7,NULL),
(61967,11,1,7,NULL),
(62213,11,2,0,NULL),
(62417,11,2,0,NULL),
(62438,11,2,0,NULL),
(62493,11,2,0,NULL),
(62680,11,2,0,NULL),
(62706,11,2,0,NULL),
(62748,11,2,0,NULL),
(62801,11,2,0,NULL),
(62876,11,2,0,NULL),
(62958,11,2,0,NULL),
(63003,11,2,0,NULL),
(63163,11,2,0,NULL),
(63305,11,2,0,NULL),
(63506,11,2,5,NULL),
(63660,11,2,5,NULL),
(63704,11,2,5,NULL),
(63796,11,2,5,NULL),
(63834,11,2,5,NULL),
(63906,11,2,5,NULL),
(64154,11,2,5,NULL),
(64270,11,2,5,NULL);
/*!40000 ALTER TABLE `build_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ip_banned`
--

DROP TABLE IF EXISTS `ip_banned`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ip_banned` (
  `ip` varchar(64) NOT NULL DEFAULT '127.0.0.1',
  `bandate` int(10) unsigned NOT NULL,
  `unbandate` int(10) unsigned NOT NULL,
  `bannedby` varchar(50) NOT NULL DEFAULT '[Console]',
  `banreason` varchar(255) NOT NULL DEFAULT 'no reason',
  PRIMARY KEY (`ip`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Banned IPs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ip_banned`
--

LOCK TABLES `ip_banned` WRITE;
/*!40000 ALTER TABLE `ip_banned` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_banned` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `time` int(10) unsigned NOT NULL,
  `realm` int(10) unsigned NOT NULL,
  `type` varchar(250) NOT NULL,
  `level` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `string` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_ip_actions`
--

DROP TABLE IF EXISTS `logs_ip_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_ip_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique Identifier',
  `account_id` int(10) unsigned NOT NULL COMMENT 'Account ID',
  `character_guid` bigint(20) unsigned NOT NULL COMMENT 'Character Guid',
  `realm_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Realm ID',
  `type` tinyint(3) unsigned NOT NULL,
  `ip` varchar(64) NOT NULL DEFAULT '127.0.0.1',
  `systemnote` text DEFAULT NULL COMMENT 'Notes inserted by system',
  `unixtime` int(10) unsigned NOT NULL COMMENT 'Unixtime',
  `time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Timestamp',
  `comment` text DEFAULT NULL COMMENT 'Allows users to add a comment',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Used to log ips of individual actions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_ip_actions`
--

LOCK TABLES `logs_ip_actions` WRITE;
/*!40000 ALTER TABLE `logs_ip_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs_ip_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rbac_account_permissions`
--

DROP TABLE IF EXISTS `rbac_account_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rbac_account_permissions` (
  `accountId` int(10) unsigned NOT NULL COMMENT 'Account id',
  `permissionId` int(10) unsigned NOT NULL COMMENT 'Permission id',
  `granted` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Granted = 1, Denied = 0',
  `realmId` int(11) NOT NULL DEFAULT -1 COMMENT 'Realm Id, -1 means all',
  PRIMARY KEY (`accountId`,`permissionId`,`realmId`),
  KEY `fk__rbac_account_roles__rbac_permissions` (`permissionId`),
  CONSTRAINT `fk__rbac_account_permissions__account` FOREIGN KEY (`accountId`) REFERENCES `account` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk__rbac_account_roles__rbac_permissions` FOREIGN KEY (`permissionId`) REFERENCES `rbac_permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Account-Permission relation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rbac_account_permissions`
--

LOCK TABLES `rbac_account_permissions` WRITE;
/*!40000 ALTER TABLE `rbac_account_permissions` DISABLE KEYS */;
INSERT INTO `rbac_account_permissions` VALUES
(5,3,1,-1),
(5,196,1,-1),
(5,197,1,-1),
(6,196,1,-1),
(6,197,1,-1),
(42,3,1,-1),
(42,196,1,-1);
/*!40000 ALTER TABLE `rbac_account_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rbac_default_permissions`
--

DROP TABLE IF EXISTS `rbac_default_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rbac_default_permissions` (
  `secId` int(10) unsigned NOT NULL COMMENT 'Security Level id',
  `permissionId` int(10) unsigned NOT NULL COMMENT 'permission id',
  `realmId` int(11) NOT NULL DEFAULT -1 COMMENT 'Realm Id, -1 means all',
  PRIMARY KEY (`secId`,`permissionId`,`realmId`),
  KEY `fk__rbac_default_permissions__rbac_permissions` (`permissionId`),
  CONSTRAINT `fk__rbac_default_permissions__rbac_permissions` FOREIGN KEY (`permissionId`) REFERENCES `rbac_permissions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Default permission to assign to different account security levels';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rbac_default_permissions`
--

LOCK TABLES `rbac_default_permissions` WRITE;
/*!40000 ALTER TABLE `rbac_default_permissions` DISABLE KEYS */;
INSERT INTO `rbac_default_permissions` VALUES
(0,195,-1),
(1,194,-1),
(2,193,-1),
(3,192,-1);
/*!40000 ALTER TABLE `rbac_default_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rbac_linked_permissions`
--

DROP TABLE IF EXISTS `rbac_linked_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rbac_linked_permissions` (
  `id` int(10) unsigned NOT NULL COMMENT 'Permission id',
  `linkedId` int(10) unsigned NOT NULL COMMENT 'Linked Permission id',
  PRIMARY KEY (`id`,`linkedId`),
  KEY `fk__rbac_linked_permissions__rbac_permissions1` (`id`),
  KEY `fk__rbac_linked_permissions__rbac_permissions2` (`linkedId`),
  CONSTRAINT `fk__rbac_linked_permissions__rbac_permissions1` FOREIGN KEY (`id`) REFERENCES `rbac_permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk__rbac_linked_permissions__rbac_permissions2` FOREIGN KEY (`linkedId`) REFERENCES `rbac_permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Permission - Linked Permission relation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rbac_linked_permissions`
--

LOCK TABLES `rbac_linked_permissions` WRITE;
/*!40000 ALTER TABLE `rbac_linked_permissions` DISABLE KEYS */;
INSERT INTO `rbac_linked_permissions` VALUES
(192,21),
(192,42),
(192,43),
(192,193),
(192,196),
(192,776),
(192,778),
(192,779),
(192,780),
(192,781),
(192,782),
(192,783),
(192,784),
(192,785),
(192,786),
(192,787),
(192,788),
(192,789),
(192,790),
(192,791),
(192,792),
(192,793),
(192,794),
(192,795),
(192,796),
(192,835),
(192,844),
(192,845),
(192,846),
(192,847),
(192,848),
(192,849),
(192,850),
(192,851),
(192,853),
(192,854),
(193,48),
(193,194),
(193,197),
(194,1),
(194,2),
(194,9),
(194,11),
(194,12),
(194,13),
(194,14),
(194,15),
(194,16),
(194,17),
(194,18),
(194,19),
(194,20),
(194,22),
(194,23),
(194,25),
(194,26),
(194,27),
(194,28),
(194,29),
(194,30),
(194,31),
(194,32),
(194,33),
(194,34),
(194,35),
(194,36),
(194,37),
(194,38),
(194,39),
(194,40),
(194,41),
(194,44),
(194,46),
(194,47),
(194,51),
(194,195),
(194,198),
(194,632),
(194,798),
(195,3),
(195,4),
(195,5),
(195,6),
(195,24),
(195,49),
(195,199),
(196,7),
(196,10),
(196,202),
(196,203),
(196,204),
(196,205),
(196,206),
(196,208),
(196,212),
(196,213),
(196,214),
(196,215),
(196,216),
(196,226),
(196,227),
(196,230),
(196,231),
(196,233),
(196,234),
(196,235),
(196,238),
(196,239),
(196,240),
(196,241),
(196,242),
(196,243),
(196,244),
(196,245),
(196,246),
(196,247),
(196,248),
(196,249),
(196,250),
(196,251),
(196,252),
(196,253),
(196,254),
(196,255),
(196,256),
(196,257),
(196,258),
(196,259),
(196,260),
(196,261),
(196,262),
(196,264),
(196,265),
(196,266),
(196,267),
(196,268),
(196,269),
(196,270),
(196,271),
(196,272),
(196,279),
(196,280),
(196,283),
(196,287),
(196,288),
(196,289),
(196,290),
(196,291),
(196,292),
(196,293),
(196,294),
(196,295),
(196,296),
(196,297),
(196,298),
(196,299),
(196,302),
(196,303),
(196,304),
(196,305),
(196,306),
(196,309),
(196,310),
(196,314),
(196,319),
(196,320),
(196,321),
(196,322),
(196,323),
(196,324),
(196,325),
(196,326),
(196,327),
(196,328),
(196,329),
(196,330),
(196,331),
(196,335),
(196,336),
(196,337),
(196,339),
(196,340),
(196,341),
(196,342),
(196,343),
(196,344),
(196,345),
(196,346),
(196,347),
(196,348),
(196,349),
(196,350),
(196,351),
(196,352),
(196,353),
(196,354),
(196,355),
(196,356),
(196,357),
(196,358),
(196,359),
(196,360),
(196,361),
(196,362),
(196,363),
(196,364),
(196,365),
(196,366),
(196,373),
(196,375),
(196,400),
(196,401),
(196,402),
(196,403),
(196,404),
(196,405),
(196,406),
(196,407),
(196,417),
(196,418),
(196,419),
(196,420),
(196,421),
(196,422),
(196,423),
(196,424),
(196,425),
(196,426),
(196,427),
(196,428),
(196,429),
(196,434),
(196,435),
(196,436),
(196,437),
(196,438),
(196,439),
(196,440),
(196,441),
(196,442),
(196,443),
(196,444),
(196,445),
(196,446),
(196,447),
(196,448),
(196,449),
(196,450),
(196,451),
(196,452),
(196,453),
(196,454),
(196,455),
(196,456),
(196,457),
(196,458),
(196,459),
(196,460),
(196,461),
(196,463),
(196,464),
(196,465),
(196,472),
(196,473),
(196,474),
(196,475),
(196,476),
(196,477),
(196,478),
(196,488),
(196,489),
(196,491),
(196,492),
(196,493),
(196,495),
(196,497),
(196,498),
(196,499),
(196,500),
(196,502),
(196,503),
(196,505),
(196,508),
(196,511),
(196,513),
(196,514),
(196,516),
(196,519),
(196,522),
(196,523),
(196,526),
(196,527),
(196,529),
(196,530),
(196,533),
(196,535),
(196,536),
(196,537),
(196,538),
(196,539),
(196,540),
(196,541),
(196,556),
(196,581),
(196,582),
(196,592),
(196,593),
(196,596),
(196,602),
(196,603),
(196,604),
(196,605),
(196,606),
(196,607),
(196,608),
(196,609),
(196,610),
(196,611),
(196,612),
(196,613),
(196,615),
(196,616),
(196,617),
(196,618),
(196,619),
(196,620),
(196,621),
(196,623),
(196,624),
(196,625),
(196,626),
(196,627),
(196,628),
(196,629),
(196,630),
(196,631),
(196,633),
(196,634),
(196,635),
(196,636),
(196,637),
(196,638),
(196,639),
(196,640),
(196,641),
(196,642),
(196,643),
(196,644),
(196,645),
(196,646),
(196,647),
(196,648),
(196,649),
(196,650),
(196,651),
(196,652),
(196,653),
(196,654),
(196,655),
(196,656),
(196,657),
(196,658),
(196,659),
(196,660),
(196,661),
(196,663),
(196,665),
(196,666),
(196,667),
(196,668),
(196,669),
(196,670),
(196,671),
(196,672),
(196,673),
(196,674),
(196,675),
(196,676),
(196,677),
(196,678),
(196,679),
(196,680),
(196,681),
(196,682),
(196,683),
(196,684),
(196,685),
(196,686),
(196,687),
(196,688),
(196,689),
(196,690),
(196,691),
(196,693),
(196,694),
(196,695),
(196,696),
(196,697),
(196,698),
(196,699),
(196,700),
(196,701),
(196,702),
(196,703),
(196,704),
(196,707),
(196,708),
(196,709),
(196,710),
(196,711),
(196,712),
(196,713),
(196,714),
(196,715),
(196,716),
(196,717),
(196,718),
(196,719),
(196,721),
(196,722),
(196,723),
(196,724),
(196,725),
(196,726),
(196,727),
(196,728),
(196,729),
(196,730),
(196,733),
(196,734),
(196,735),
(196,736),
(196,738),
(196,739),
(196,753),
(196,757),
(196,773),
(196,777),
(196,809),
(196,817),
(196,825),
(196,829),
(196,830),
(196,831),
(196,832),
(196,833),
(196,836),
(196,837),
(196,838),
(196,839),
(196,840),
(196,842),
(196,843),
(196,852),
(196,866),
(196,869),
(196,870),
(196,871),
(196,872),
(196,873),
(196,875),
(196,876),
(196,877),
(196,878),
(196,879),
(196,880),
(196,881),
(196,882),
(196,883),
(197,232),
(197,236),
(197,237),
(197,273),
(197,274),
(197,275),
(197,276),
(197,277),
(197,284),
(197,285),
(197,286),
(197,301),
(197,311),
(197,387),
(197,388),
(197,389),
(197,390),
(197,391),
(197,392),
(197,393),
(197,394),
(197,395),
(197,396),
(197,397),
(197,398),
(197,399),
(197,479),
(197,480),
(197,481),
(197,482),
(197,485),
(197,486),
(197,487),
(197,494),
(197,501),
(197,506),
(197,509),
(197,510),
(197,517),
(197,518),
(197,521),
(197,542),
(197,543),
(197,550),
(197,558),
(197,568),
(197,571),
(197,572),
(197,573),
(197,574),
(197,575),
(197,576),
(197,577),
(197,578),
(197,579),
(197,580),
(197,583),
(197,584),
(197,585),
(197,586),
(197,587),
(197,588),
(197,589),
(197,590),
(197,591),
(197,594),
(197,595),
(197,601),
(197,761),
(197,762),
(197,763),
(197,764),
(197,765),
(197,766),
(197,767),
(197,768),
(197,769),
(197,770),
(197,771),
(197,772),
(197,774),
(197,775),
(197,805),
(197,811),
(197,813),
(197,819),
(197,821),
(197,827),
(197,856),
(197,857),
(197,858),
(197,859),
(197,860),
(197,865),
(198,218),
(198,300),
(198,312),
(198,315),
(198,316),
(198,317),
(198,318),
(198,367),
(198,368),
(198,369),
(198,370),
(198,371),
(198,372),
(198,374),
(198,376),
(198,377),
(198,408),
(198,409),
(198,410),
(198,411),
(198,412),
(198,413),
(198,414),
(198,415),
(198,430),
(198,431),
(198,432),
(198,433),
(198,462),
(198,466),
(198,467),
(198,468),
(198,469),
(198,470),
(198,471),
(198,483),
(198,484),
(198,490),
(198,504),
(198,512),
(198,515),
(198,520),
(198,524),
(198,528),
(198,531),
(198,532),
(198,544),
(198,545),
(198,547),
(198,548),
(198,549),
(198,551),
(198,552),
(198,553),
(198,554),
(198,555),
(198,557),
(198,559),
(198,560),
(198,561),
(198,562),
(198,563),
(198,564),
(198,565),
(198,566),
(198,567),
(198,569),
(198,570),
(198,597),
(198,598),
(198,599),
(198,600),
(198,737),
(198,740),
(198,741),
(198,742),
(198,802),
(198,803),
(198,804),
(198,806),
(198,807),
(198,808),
(198,810),
(198,812),
(198,814),
(198,815),
(198,816),
(198,818),
(198,820),
(198,822),
(198,823),
(198,824),
(198,826),
(198,828),
(198,855),
(198,868),
(199,207),
(199,209),
(199,210),
(199,211),
(199,217),
(199,221),
(199,222),
(199,223),
(199,225),
(199,263),
(199,378),
(199,379),
(199,380),
(199,496),
(199,507),
(199,525),
(199,534),
(199,797);
/*!40000 ALTER TABLE `rbac_linked_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rbac_permissions`
--

DROP TABLE IF EXISTS `rbac_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rbac_permissions` (
  `id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Permission id',
  `name` varchar(100) NOT NULL COMMENT 'Permission name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Permission List';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rbac_permissions`
--

LOCK TABLES `rbac_permissions` WRITE;
/*!40000 ALTER TABLE `rbac_permissions` DISABLE KEYS */;
INSERT INTO `rbac_permissions` VALUES
(1,'Instant logout'),
(2,'Skip Queue'),
(3,'Join Normal Battleground'),
(4,'Join Random Battleground'),
(5,'Join Arenas'),
(6,'Join Dungeon Finder'),
(7,'Skip idle connection check'),
(8,'Cannot earn achievements'),
(9,'Cannot earn realm first achievements'),
(10,'Use character templates'),
(11,'Log GM trades'),
(12,'Skip character creation demon hunter min level check'),
(13,'Skip Instance required bosses check'),
(14,'Skip character creation team mask check'),
(15,'Skip character creation class mask check'),
(16,'Skip character creation race mask check'),
(17,'Skip character creation reserved name check'),
(18,'Skip character creation death knight min level check'),
(19,'Skip needed requirements to use channel check'),
(20,'Skip disable map check'),
(21,'Skip reset talents when used more than allowed check'),
(22,'Skip spam chat check'),
(23,'Skip over-speed ping check'),
(24,'Two side faction characters on the same account'),
(25,'Allow say chat between factions'),
(26,'Allow channel chat between factions'),
(27,'Two side mail interaction'),
(28,'See two side who list'),
(29,'Add friends of other faction'),
(30,'Save character without delay with .save command'),
(31,'Use params with .unstuck command'),
(32,'Can be assigned tickets with .assign ticket command'),
(33,'Notify if a command was not found'),
(34,'Check if should appear in list using .gm ingame command'),
(35,'See all security levels with who command'),
(36,'Filter whispers'),
(37,'Use staff badge in chat'),
(38,'Resurrect with full Health Points'),
(39,'Restore saved gm setting states'),
(40,'Allows to add a gm to friend list'),
(41,'Use Config option START_GM_LEVEL to assign new character level'),
(42,'Allows to use CMSG_WORLD_TELEPORT opcode'),
(43,'Allows to use CMSG_WHOIS opcode'),
(44,'Receive global GM messages/texts'),
(45,'Join channels without announce'),
(46,'Change channel settings without being channel moderator'),
(47,'Enables lower security than target check'),
(48,'Enable IP, Last Login and EMail output in pinfo'),
(49,'Forces to enter the email for confirmation on password change'),
(50,'Allow user to check his own email with .account'),
(51,'Allow trading between factions'),
(192,'Role: Sec Level Administrator'),
(193,'Role: Sec Level Gamemaster'),
(194,'Role: Sec Level Moderator'),
(195,'Role: Sec Level Player'),
(196,'Role: Administrator Commands'),
(197,'Role: Gamemaster Commands'),
(198,'Role: Moderator Commands'),
(199,'Role: Player Commands'),
(200,'Command: rbac'),
(201,'Command: rbac account'),
(202,'Command: rbac account list'),
(203,'Command: rbac account grant'),
(204,'Command: rbac account deny'),
(205,'Command: rbac account revoke'),
(206,'Command: rbac list'),
(207,'Command: battlenetaccount'),
(208,'Command: battlenetaccount create'),
(209,'Command: battlenetaccount lock country'),
(210,'Command: battlenetaccount lock ip'),
(211,'Command: battlenetaccount password'),
(212,'Command: battlenetaccount set'),
(213,'Command: battlenetaccount set password'),
(214,'Command: bnetaccount link'),
(215,'Command: bnetaccount unlink'),
(216,'Command: bnetaccount gameaccountcreate'),
(217,'Command: account'),
(218,'Command: account addon'),
(219,'Command: account create'),
(220,'Command: account delete'),
(221,'Command: account lock'),
(222,'Command: account lock country'),
(223,'Command: account lock ip'),
(224,'Command: account onlinelist'),
(225,'Command: account password'),
(226,'Command: account set'),
(227,'Command: account set addon'),
(228,'Command: account set gmlevel'),
(229,'Command: account set password'),
(230,'Command: achievement'),
(231,'Command: achievement add'),
(232,'Command: arena'),
(233,'Command: arena captain'),
(234,'Command: arena create'),
(235,'Command: arena disband'),
(236,'Command: arena info'),
(237,'Command: arena lookup'),
(238,'Command: arena rename'),
(239,'Command: ban'),
(240,'Command: ban account'),
(241,'Command: ban character'),
(242,'Command: ban ip'),
(243,'Command: ban playeraccount'),
(244,'Command: baninfo'),
(245,'Command: baninfo account'),
(246,'Command: baninfo character'),
(247,'Command: baninfo ip'),
(248,'Command: banlist'),
(249,'Command: banlist account'),
(250,'Command: banlist character'),
(251,'Command: banlist ip'),
(252,'Command: unban'),
(253,'Command: unban account'),
(254,'Command: unban character'),
(255,'Command: unban ip'),
(256,'Command: unban playeraccount'),
(257,'Command: bf'),
(258,'Command: bf start'),
(259,'Command: bf stop'),
(260,'Command: bf switch'),
(261,'Command: bf timer'),
(262,'Command: bf enable'),
(263,'Command: account email'),
(264,'Command: account set sec'),
(265,'Command: account set sec email'),
(266,'Command: account set sec regmail'),
(267,'Command: cast'),
(268,'Command: cast back'),
(269,'Command: cast dist'),
(270,'Command: cast self'),
(271,'Command: cast target'),
(272,'Command: cast dest'),
(273,'Command: character'),
(274,'Command: character customize'),
(275,'Command: character changefaction'),
(276,'Command: character changerace'),
(277,'Command: character deleted'),
(279,'Command: character deleted list'),
(280,'Command: character deleted restore'),
(283,'Command: character level'),
(284,'Command: character rename'),
(285,'Command: character reputation'),
(286,'Command: character titles'),
(287,'Command: levelup'),
(288,'Command: pdump'),
(289,'Command: pdump load'),
(290,'Command: pdump write'),
(291,'Command: cheat'),
(292,'Command: cheat casttime'),
(293,'Command: cheat cooldown'),
(294,'Command: cheat explore'),
(295,'Command: cheat god'),
(296,'Command: cheat power'),
(297,'Command: cheat status'),
(298,'Command: cheat taxi'),
(299,'Command: cheat waterwalk'),
(300,'Command: debug'),
(301,'Command: debug anim'),
(302,'Command: debug areatriggers'),
(303,'Command: debug arena'),
(304,'Command: debug bg'),
(305,'Command: debug entervehicle'),
(306,'Command: debug getitemstate'),
(309,'Command: debug combat'),
(310,'Command: debug itemexpire'),
(311,'Command: debug lootrecipient'),
(312,'Command: debug los'),
(314,'Command: debug moveflags'),
(315,'Command: debug play'),
(316,'Command: debug play cinematics'),
(317,'Command: debug play movie'),
(318,'Command: debug play sound'),
(319,'Command: debug send'),
(320,'Command: debug send buyerror'),
(321,'Command: debug send channelnotify'),
(322,'Command: debug send chatmessage'),
(323,'Command: debug send equiperror'),
(324,'Command: debug send largepacket'),
(325,'Command: debug send opcode'),
(326,'Command: debug send qinvalidmsg'),
(327,'Command: debug send qpartymsg'),
(328,'Command: debug send sellerror'),
(329,'Command: debug send setphaseshift'),
(330,'Command: debug send spellfail'),
(331,'Command: debug setaurastate'),
(335,'Command: debug setvid'),
(336,'Command: debug spawnvehicle'),
(337,'Command: debug threat'),
(339,'Command: debug worldstate'),
(340,'Command: wpgps'),
(341,'Command: deserter'),
(342,'Command: deserter bg'),
(343,'Command: deserter bg add'),
(344,'Command: deserter bg remove'),
(345,'Command: deserter instance'),
(346,'Command: deserter instance add'),
(347,'Command: deserter instance remove'),
(348,'Command: disable'),
(349,'Command: disable add'),
(350,'Command: disable add criteria'),
(351,'Command: disable add battleground'),
(352,'Command: disable add map'),
(353,'Command: disable add mmap'),
(354,'Command: disable add outdoorpvp'),
(355,'Command: disable add quest'),
(356,'Command: disable add spell'),
(357,'Command: disable add vmap'),
(358,'Command: disable remove'),
(359,'Command: disable remove criteria'),
(360,'Command: disable remove battleground'),
(361,'Command: disable remove map'),
(362,'Command: disable remove mmap'),
(363,'Command: disable remove outdoorpvp'),
(364,'Command: disable remove quest'),
(365,'Command: disable remove spell'),
(366,'Command: disable remove vmap'),
(367,'Command: event info'),
(368,'Command: event activelist'),
(369,'Command: event start'),
(370,'Command: event stop'),
(371,'Command: gm'),
(372,'Command: gm chat'),
(373,'Command: gm fly'),
(374,'Command: gm ingame'),
(375,'Command: gm list'),
(376,'Command: gm visible'),
(377,'Command: go'),
(378,'Command: account 2fa'),
(379,'Command: account 2fa setup'),
(380,'Command: account 2fa remove'),
(381,'Command: account set 2fa'),
(387,'Command: gobject'),
(388,'Command: gobject activate'),
(389,'Command: gobject add'),
(390,'Command: gobject add temp'),
(391,'Command: gobject delete'),
(392,'Command: gobject info'),
(393,'Command: gobject move'),
(394,'Command: gobject near'),
(395,'Command: gobject set'),
(396,'Command: gobject set phase'),
(397,'Command: gobject set state'),
(398,'Command: gobject target'),
(399,'Command: gobject turn'),
(400,'debug transport'),
(401,'Command: guild'),
(402,'Command: guild create'),
(403,'Command: guild delete'),
(404,'Command: guild invite'),
(405,'Command: guild uninvite'),
(406,'Command: guild rank'),
(407,'Command: guild rename'),
(408,'Command: honor'),
(409,'Command: honor add'),
(410,'Command: honor add kill'),
(411,'Command: honor update'),
(412,'Command: instance'),
(413,'Command: instance listbinds'),
(414,'Command: instance unbind'),
(415,'Command: instance stats'),
(417,'Command: learn'),
(418,'Command: learn all'),
(419,'Command: learn all my'),
(420,'Command: learn all my class'),
(421,'Command: learn all my pettalents'),
(422,'Command: learn all my spells'),
(423,'Command: learn all my talents'),
(424,'Command: learn all gm'),
(425,'Command: learn all crafts'),
(426,'Command: learn all default'),
(427,'Command: learn all lang'),
(428,'Command: learn all recipes'),
(429,'Command: unlearn'),
(430,'Command: lfg'),
(431,'Command: lfg player'),
(432,'Command: lfg group'),
(433,'Command: lfg queue'),
(434,'Command: lfg clean'),
(435,'Command: lfg options'),
(436,'Command: list'),
(437,'Command: list creature'),
(438,'Command: list item'),
(439,'Command: list object'),
(440,'Command: list auras'),
(441,'Command: list mail'),
(442,'Command: lookup'),
(443,'Command: lookup area'),
(444,'Command: lookup creature'),
(445,'Command: lookup event'),
(446,'Command: lookup faction'),
(447,'Command: lookup item'),
(448,'Command: lookup itemset'),
(449,'Command: lookup object'),
(450,'Command: lookup quest'),
(451,'Command: lookup player'),
(452,'Command: lookup player ip'),
(453,'Command: lookup player account'),
(454,'Command: lookup player email'),
(455,'Command: lookup skill'),
(456,'Command: lookup spell'),
(457,'Command: lookup spell id'),
(458,'Command: lookup taxinode'),
(459,'Command: lookup tele'),
(460,'Command: lookup title'),
(461,'Command: lookup map'),
(462,'Command: announce'),
(463,'Command: channel'),
(464,'Command: channel set'),
(465,'Command: channel set ownership'),
(466,'Command: gmannounce'),
(467,'Command: gmnameannounce'),
(468,'Command: gmnotify'),
(469,'Command: nameannounce'),
(470,'Command: notify'),
(471,'Command: whispers'),
(472,'Command: group'),
(473,'Command: group leader'),
(474,'Command: group disband'),
(475,'Command: group remove'),
(476,'Command: group join'),
(477,'Command: group list'),
(478,'Command: group summon'),
(479,'Command: pet'),
(480,'Command: pet create'),
(481,'Command: pet learn'),
(482,'Command: pet unlearn'),
(483,'Command: send'),
(484,'Command: send items'),
(485,'Command: send mail'),
(486,'Command: send message'),
(487,'Command: send money'),
(488,'Command: additem'),
(489,'Command: additemset'),
(490,'Command: appear'),
(491,'Command: aura'),
(492,'Command: bank'),
(493,'Command: bindsight'),
(494,'Command: combatstop'),
(495,'Command: cometome'),
(496,'Command: commands'),
(497,'Command: cooldown'),
(498,'Command: damage'),
(499,'Command: dev'),
(500,'Command: die'),
(501,'Command: dismount'),
(502,'Command: distance'),
(503,'Command: flusharenapoints'),
(504,'Command: freeze'),
(505,'Command: gps'),
(506,'Command: guid'),
(507,'Command: help'),
(508,'Command: hidearea'),
(509,'Command: itemmove'),
(510,'Command: kick'),
(511,'Command: linkgrave'),
(512,'Command: listfreeze'),
(513,'Command: maxskill'),
(514,'Command: movegens'),
(515,'Command: mute'),
(516,'Command: neargrave'),
(517,'Command: pinfo'),
(518,'Command: playall'),
(519,'Command: possess'),
(520,'Command: recall'),
(521,'Command: repairitems'),
(522,'Command: respawn'),
(523,'Command: revive'),
(524,'Command: saveall'),
(525,'Command: save'),
(526,'Command: setskill'),
(527,'Command: showarea'),
(528,'Command: summon'),
(529,'Command: unaura'),
(530,'Command: unbindsight'),
(531,'Command: unfreeze'),
(532,'Command: unmute'),
(533,'Command: unpossess'),
(534,'Command: unstuck'),
(535,'Command: wchange'),
(536,'Command: mmap'),
(537,'Command: mmap loadedtiles'),
(538,'Command: mmap loc'),
(539,'Command: mmap path'),
(540,'Command: mmap stats'),
(541,'Command: mmap testarea'),
(542,'Command: morph'),
(543,'Command: demorph'),
(544,'Command: modify'),
(545,'Command: modify arenapoints'),
(547,'Command: modify drunk'),
(548,'Command: modify energy'),
(549,'Command: modify faction'),
(550,'Command: modify gender'),
(551,'Command: modify honor'),
(552,'Command: modify hp'),
(553,'Command: modify mana'),
(554,'Command: modify money'),
(555,'Command: modify mount'),
(556,'Command: modify phase'),
(557,'Command: modify rage'),
(558,'Command: modify reputation'),
(559,'Command: modify runicpower'),
(560,'Command: modify scale'),
(561,'Command: modify speed'),
(562,'Command: modify speed all'),
(563,'Command: modify speed backwalk'),
(564,'Command: modify speed fly'),
(565,'Command: modify speed walk'),
(566,'Command: modify speed swim'),
(567,'Command: modify spell'),
(568,'Command: modify standstate'),
(569,'Command: modify talentpoints'),
(570,'Command: npc'),
(571,'Command: npc add'),
(572,'Command: npc add formation'),
(573,'Command: npc add item'),
(574,'Command: npc add move'),
(575,'Command: npc add temp'),
(576,'Command: npc add delete'),
(577,'Command: npc add delete item'),
(578,'Command: npc add follow'),
(579,'Command: npc add follow stop'),
(580,'Command: npc set'),
(581,'Command: npc set allowmove'),
(582,'Command: npc set entry'),
(583,'Command: npc set factionid'),
(584,'Command: npc set flag'),
(585,'Command: npc set level'),
(586,'Command: npc set link'),
(587,'Command: npc set model'),
(588,'Command: npc set movetype'),
(589,'Command: npc set phase'),
(590,'Command: npc set spawndist'),
(591,'Command: npc set spawntime'),
(592,'Command: npc set data'),
(593,'Command: npc info'),
(594,'Command: npc near'),
(595,'Command: npc move'),
(596,'Command: npc playemote'),
(597,'Command: npc say'),
(598,'Command: npc textemote'),
(599,'Command: npc whisper'),
(600,'Command: npc yell'),
(601,'Command: npc tame'),
(602,'Command: quest'),
(603,'Command: quest add'),
(604,'Command: quest complete'),
(605,'Command: quest remove'),
(606,'Command: quest reward'),
(607,'Command: reload'),
(608,'Command: reload access_requirement'),
(609,'Command: reload criteria_data'),
(610,'Command: reload achievement_reward'),
(611,'Command: reload all'),
(612,'Command: reload all achievement'),
(613,'Command: reload all area'),
(615,'Command: reload all gossips'),
(616,'Command: reload all item'),
(617,'Command: reload all locales'),
(618,'Command: reload all loot'),
(619,'Command: reload all npc'),
(620,'Command: reload all quest'),
(621,'Command: reload all scripts'),
(623,'Command: reload areatrigger_involvedrelation'),
(624,'Command: reload areatrigger_tavern'),
(625,'Command: reload areatrigger_teleport'),
(626,'Command: reload auctions'),
(627,'Command: reload autobroadcast'),
(628,'Command: reload command'),
(629,'Command: reload conditions'),
(630,'Command: reload config'),
(631,'Command: reload battleground_template'),
(632,'Command: .mutehistory'),
(633,'Command: reload creature_linked_respawn'),
(634,'Command: reload creature_loot_template'),
(635,'Command: reload creature_onkill_reputation'),
(636,'Command: reload creature_questender'),
(637,'Command: reload creature_queststarter'),
(638,'Command: reload creature_summon_groups'),
(639,'Command: reload creature_template'),
(640,'Command: reload creature_text'),
(641,'Command: reload disables'),
(642,'Command: reload disenchant_loot_template'),
(643,'Command: reload event_scripts'),
(644,'Command: reload fishing_loot_template'),
(645,'Command: reload game_graveyard_zone'),
(646,'Command: reload game_tele'),
(647,'Command: reload gameobject_questender'),
(648,'Command: reload gameobject_loot_template'),
(649,'Command: reload gameobject_queststarter'),
(650,'Command: reload support'),
(651,'Command: reload gossip_menu'),
(652,'Command: reload gossip_menu_option'),
(653,'Command: reload item_random_bonus_list_template'),
(654,'Command: reload item_loot_template'),
(655,'Command: reload item_set_names'),
(656,'Command: reload lfg_dungeon_rewards'),
(657,'Command: reload locales_achievement_reward'),
(658,'Command: reload locales_creature'),
(659,'Command: reload locales_creature_text'),
(660,'Command: reload locales_gameobject'),
(661,'Command: reload locales_gossip_menu_option'),
(663,'Command: reload locales_item_set_name'),
(665,'Command: reload locales_page_text'),
(666,'Command: reload locales_points_of_interest'),
(667,'Command: reload quest_locale'),
(668,'Command: reload mail_level_reward'),
(669,'Command: reload mail_loot_template'),
(670,'Command: reload milling_loot_template'),
(671,'Command: reload npc_spellclick_spells'),
(672,'Command: reload npc_trainer'),
(673,'Command: reload npc_vendor'),
(674,'Command: reload page_text'),
(675,'Command: reload pickpocketing_loot_template'),
(676,'Command: reload points_of_interest'),
(677,'Command: reload prospecting_loot_template'),
(678,'Command: reload quest_poi'),
(679,'Command: reload quest_template'),
(680,'Command: reload rbac'),
(681,'Command: reload reference_loot_template'),
(682,'Command: reload reserved_name'),
(683,'Command: reload reputation_reward_rate'),
(684,'Command: reload reputation_spillover_template'),
(685,'Command: reload skill_discovery_template'),
(686,'Command: reload skill_extra_item_template'),
(687,'Command: reload skill_fishing_base_level'),
(688,'Command: reload skinning_loot_template'),
(689,'Command: reload smart_scripts'),
(690,'Command: reload spell_required'),
(691,'Command: reload spell_area'),
(693,'Command: reload spell_group'),
(694,'Command: reload spell_learn_spell'),
(695,'Command: reload spell_loot_template'),
(696,'Command: reload spell_linked_spell'),
(697,'Command: reload spell_pet_auras'),
(698,'Command: character changeaccount'),
(699,'Command: reload spell_proc'),
(700,'Command: reload spell_scripts'),
(701,'Command: reload spell_target_position'),
(702,'Command: reload spell_threats'),
(703,'Command: reload spell_group_stack_rules'),
(704,'Command: reload trinity_string'),
(707,'Command: reload waypoint_path'),
(708,'Command: reload vehicle_accessory'),
(709,'Command: reload vehicle_template_accessory'),
(710,'Command: reset'),
(711,'Command: reset achievements'),
(712,'Command: reset honor'),
(713,'Command: reset level'),
(714,'Command: reset spells'),
(715,'Command: reset stats'),
(716,'Command: reset talents'),
(717,'Command: reset all'),
(718,'Command: server'),
(719,'Command: server corpses'),
(720,'Command: server exit'),
(721,'Command: server idlerestart'),
(722,'Command: server idlerestart cancel'),
(723,'Command: server idleshutdown'),
(724,'Command: server idleshutdown cancel'),
(725,'Command: server info'),
(726,'Command: server plimit'),
(727,'Command: server restart'),
(728,'Command: server restart cancel'),
(729,'Command: server set'),
(730,'Command: server set closed'),
(731,'Command: server set difftime'),
(732,'Command: server set loglevel'),
(733,'Command: server set motd'),
(734,'Command: server shutdown'),
(735,'Command: server shutdown cancel'),
(736,'Command: server motd'),
(737,'Command: tele'),
(738,'Command: tele add'),
(739,'Command: tele del'),
(740,'Command: tele name'),
(741,'Command: tele group'),
(742,'Command: ticket'),
(753,'Command: ticket reset'),
(757,'Command: ticket togglesystem'),
(761,'Command: titles'),
(762,'Command: titles add'),
(763,'Command: titles current'),
(764,'Command: titles remove'),
(765,'Command: titles set'),
(766,'Command: titles set mask'),
(767,'Command: wp'),
(768,'Command: wp add'),
(769,'Command: wp event'),
(770,'Command: wp load'),
(771,'Command: wp modify'),
(772,'Command: wp unload'),
(773,'Command: wp reload'),
(774,'Command: wp show'),
(775,'Command: modify currency'),
(776,'Command: debug phase'),
(777,'Command: mailbox'),
(778,'Command: ahbot'),
(779,'Command: ahbot items'),
(780,'Command: ahbot items gray'),
(781,'Command: ahbot items white'),
(782,'Command: ahbot items green'),
(783,'Command: ahbot items blue'),
(784,'Command: ahbot items purple'),
(785,'Command: ahbot items orange'),
(786,'Command: ahbot items yellow'),
(787,'Command: ahbot ratio'),
(788,'Command: ahbot ratio alliance'),
(789,'Command: ahbot ratio horde'),
(790,'Command: ahbot ratio neutral'),
(791,'Command: ahbot rebuild'),
(792,'Command: ahbot reload'),
(793,'Command: ahbot status'),
(794,'Command: .guild info'),
(795,'Command: instance setbossstate'),
(796,'Command: instance getbossstate'),
(797,'Command: pvpstats'),
(798,'Command: .mod xp'),
(802,'Command: .ticket bug'),
(803,'Command: .ticket complaint'),
(804,'Command: .ticket suggestion'),
(805,'Command: .ticket bug assign'),
(806,'Command: .ticket bug close'),
(807,'Command: .ticket bug closedlist'),
(808,'Command: .ticket bug comment'),
(809,'Command: .ticket bug delete'),
(810,'Command: .ticket bug list'),
(811,'Command: .ticket bug unassign'),
(812,'Command: .ticket bug view'),
(813,'Command: .ticket complaint assign'),
(814,'Command: .ticket complaint close'),
(815,'Command: .ticket complaint closedlist'),
(816,'Command: .ticket complaint comment'),
(817,'Command: .ticket complaint delete'),
(818,'Command: .ticket complaint list'),
(819,'Command: .ticket complaint unassign'),
(820,'Command: .ticket complaint view'),
(821,'Command: .ticket suggestion assign'),
(822,'Command: .ticket suggestion close'),
(823,'Command: .ticket suggestion closedlist'),
(824,'Command: .ticket suggestion comment'),
(825,'Command: .ticket suggestion delete'),
(826,'Command: .ticket suggestion list'),
(827,'Command: .ticket suggestion unassign'),
(828,'Command: .ticket suggestion view'),
(829,'Command: .ticket reset all'),
(830,'Command: .bnetaccount listgameaccounts'),
(831,'Command: .ticket reset bug'),
(832,'Command: .ticket reset complaint'),
(833,'Command: .ticket reset suggestion'),
(835,'Command: debug loadcells'),
(836,'Command: .debug boundary'),
(837,'Command: npc evade'),
(838,'Command: pet level'),
(839,'Command: server shutdown force'),
(840,'Command: server restart force'),
(842,'Command: reload character_template'),
(843,'Command: reload quest_greeting'),
(844,'Command: scene'),
(845,'Command: scene debug'),
(846,'Command: scene play'),
(847,'Command: scene play package'),
(848,'Command: scene cancel'),
(849,'Command: list scenes'),
(850,'Command: reload scenes'),
(851,'Command: reload areatrigger_templates'),
(852,'Command: debug dummy'),
(853,'Command: .reload conversation_template'),
(854,'Command: .debug conversation'),
(855,'Command: debug play music'),
(856,'Command: npc spawngroup'),
(857,'Command: npc despawngroup'),
(858,'Command: gobject spawngroup'),
(859,'Command: gobject despawngroup'),
(860,'Command: list respawns'),
(865,'Command: npc showloot'),
(866,'Command: list spawnpoints'),
(868,'Command: modify power'),
(869,'Command: debug send playerchoice'),
(870,'Command: debug threatinfo'),
(871,'Command: debug instancespawn'),
(872,'Command: server debug'),
(873,'Command: reload creature_movement_override'),
(874,'Command: debug asan'),
(875,'Command: lookup map id'),
(876,'Command: lookup item id'),
(877,'Command: lookup quest id'),
(878,'Command: debug questreset'),
(879,'Command: debug poolstatus'),
(880,'Command: pdump copy'),
(881,'Command: reload vehicle_template'),
(882,'Command: reload spell_script_names'),
(883,'Command: quest objective complete');
/*!40000 ALTER TABLE `rbac_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realmcharacters`
--

DROP TABLE IF EXISTS `realmcharacters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `realmcharacters` (
  `realmid` int(10) unsigned NOT NULL DEFAULT 0,
  `acctid` int(10) unsigned NOT NULL,
  `numchars` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`realmid`,`acctid`),
  KEY `acctid` (`acctid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Realm Character Tracker';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realmcharacters`
--

LOCK TABLES `realmcharacters` WRITE;
/*!40000 ALTER TABLE `realmcharacters` DISABLE KEYS */;
INSERT INTO `realmcharacters` VALUES
(1,1,0),
(1,2,1),
(1,3,1),
(1,4,0),
(1,5,0),
(1,6,0),
(1,7,0),
(1,8,1),
(1,9,0),
(1,10,0),
(1,11,0),
(1,12,0),
(1,13,0),
(1,14,0),
(1,15,0),
(1,16,0),
(1,17,0),
(1,18,0),
(1,19,0),
(1,20,0),
(1,21,0),
(1,22,0),
(1,23,0),
(1,24,0),
(1,25,0),
(1,26,0),
(1,27,0),
(1,28,0),
(1,29,0),
(1,30,0),
(1,31,0),
(1,32,0),
(1,33,0),
(1,34,0),
(1,35,0),
(1,36,0),
(1,37,0),
(1,38,0),
(1,39,0),
(1,40,0),
(1,41,0),
(1,42,2),
(1,43,0),
(1,44,0),
(1,45,0),
(1,46,1),
(1,47,2),
(1,48,1),
(1,49,0),
(1,50,0),
(1,51,1),
(1,52,0),
(1,53,1),
(1,54,0),
(1,55,0),
(1,56,1),
(2,35,0),
(2,36,0),
(2,37,0),
(2,38,0),
(2,39,0),
(2,40,0),
(2,41,0),
(2,42,0),
(2,43,0);
/*!40000 ALTER TABLE `realmcharacters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realmlist`
--

DROP TABLE IF EXISTS `realmlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `realmlist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `localAddress` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `address3` varchar(255) DEFAULT NULL,
  `address4` varchar(255) DEFAULT NULL,
  `localSubnetMask` varchar(255) NOT NULL DEFAULT '255.255.255.0',
  `port` smallint(5) unsigned NOT NULL DEFAULT 8085,
  `icon` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `flag` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `timezone` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `allowedSecurityLevel` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `population` float NOT NULL DEFAULT 0,
  `gamebuild` int(10) unsigned NOT NULL DEFAULT 64270,
  `Region` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `Battlegroup` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Realm System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realmlist`
--

LOCK TABLES `realmlist` WRITE;
/*!40000 ALTER TABLE `realmlist` DISABLE KEYS */;
INSERT INTO `realmlist` VALUES
(1,'The Fattest Cat (Extreme)','world.the-demiurge.com','127.0.0.1',NULL,NULL,'255.255.255.0',8085,0,2,1,0,0,64270,1,1);
/*!40000 ALTER TABLE `realmlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `secret_digest`
--

DROP TABLE IF EXISTS `secret_digest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `secret_digest` (
  `id` int(10) unsigned NOT NULL,
  `digest` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secret_digest`
--

LOCK TABLES `secret_digest` WRITE;
/*!40000 ALTER TABLE `secret_digest` DISABLE KEYS */;
/*!40000 ALTER TABLE `secret_digest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `updates`
--

DROP TABLE IF EXISTS `updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `updates` (
  `name` varchar(200) NOT NULL COMMENT 'filename with extension of the update.',
  `hash` char(40) DEFAULT '' COMMENT 'sha1 hash of the sql file.',
  `state` enum('RELEASED','ARCHIVED') NOT NULL DEFAULT 'RELEASED' COMMENT 'defines if an update is released or archived.',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'timestamp when the query was applied.',
  `speed` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'time the query takes to apply in ms.',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='List of all applied updates in this database.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updates`
--

LOCK TABLES `updates` WRITE;
/*!40000 ALTER TABLE `updates` DISABLE KEYS */;
INSERT INTO `updates` VALUES
('2014_10_04_00_auth.sql','C3BC70A6EC381474B7308F442346F1E721176BC6','ARCHIVED','2015-03-21 16:55:52',0),
('2014_10_19_00_auth.sql','7472B490A4F86C9D3DA609CDD3197499CB80C87C','ARCHIVED','2015-03-21 16:55:52',0),
('2014_10_26_00_auth.sql','75CC67ADE2A3B2E54FD57D6B0DCAA8FE50F4EE35','ARCHIVED','2015-03-21 16:55:52',0),
('2014_11_03_00_auth.sql','5948C9F286CF0FEA8E241785C0259FF36B73BDC5','ARCHIVED','2015-03-21 16:55:52',0),
('2014_11_04_00_auth.sql','3AFC68B2375C2A417DDEA94583C53AFF83DE50DF','ARCHIVED','2015-03-21 16:55:52',0),
('2014_11_09_00_auth.sql','B8DD1A7047C0FDDB80344B239343EC33BF1A0D97','ARCHIVED','2015-03-21 16:55:52',0),
('2014_11_10_00_auth_from_335.sql','0E3CB119442D09DD88E967015319BBC8DAFBBFE0','ARCHIVED','2014-11-10 00:00:00',0),
('2014_11_10_00_auth.sql','8FBA737A1D3FF4631A1E662A5B500A8BD304EC63','ARCHIVED','2015-03-21 16:55:52',0),
('2014_11_10_01_auth.sql','327E77A1DA3546D5275AB249915DD57EDD6FDD3D','ARCHIVED','2014-11-10 00:00:01',0),
('2014_11_23_00_auth.sql','0BBEB3EB3AED0FEF277A062819B6B2C00084A742','ARCHIVED','2015-03-21 16:55:52',0),
('2014_11_25_00_auth.sql','4F45CDB26BDBB3EE83F1988E3D7818C5926ADC02','ARCHIVED','2015-03-21 16:55:52',0),
('2014_12_05_00_auth.sql','6A7BBCEF43111C73A2D2C3CCB6911BE50DE7DD94','ARCHIVED','2015-03-21 16:55:52',0),
('2014_12_10_00_auth.sql','821703A96D80F9080074852B5A46E2909C9562EA','ARCHIVED','2014-12-10 00:00:00',0),
('2014_12_19_00_auth.sql','44D8E12FFF327AD07878FBDF8D9C16B6B7DCB122','ARCHIVED','2015-03-21 16:55:52',0),
('2014_12_20_00_auth.sql','4DAA02AE285C02AE6C82EA2C8B97AC71990F1085','ARCHIVED','2015-03-21 16:55:52',0),
('2014_12_25_00_auth.sql','61411930F482BC73FC7FD2C370C811E944F5FF92','ARCHIVED','2015-03-21 16:55:52',0),
('2014_12_27_00_auth.sql','CE2E5D2CD82E79C25294539ADED27A1429105B43','ARCHIVED','2014-12-21 00:00:00',0),
('2014_12_28_00_auth.sql','0A913217610E76AFF119C27259737BBC523090E6','ARCHIVED','2015-03-21 16:55:52',0),
('2015_02_22_00_auth.sql','21CCCF8B01252E16CA3D6C9E3E8DAA4C9B28ED6E','ARCHIVED','2015-03-21 16:55:52',0),
('2015_03_01_00_auth.sql','911881E273207FF6182D1FDAC8C85FFAE8F1C852','ARCHIVED','2015-03-21 16:55:52',0),
('2015_03_10_00_auth.sql','2CC8502C11412EFEB5C11BE166761A8754A59009','ARCHIVED','2015-03-21 16:55:52',0),
('2015_03_15_00_auth.sql','1D8E107FBEFE5E7F47E09F45240DFF499B77CDED','ARCHIVED','2015-05-02 13:57:57',0),
('2015_03_20_00_auth.sql','B761760804EA73BD297F296C5C1919687DF7191C','ARCHIVED','2015-03-21 16:55:52',0),
('2015_03_20_01_auth.sql','5CCEDF20C8189FB1E8DF064A9F0DDC342841FBF0','ARCHIVED','2015-03-21 16:55:52',0),
('2015_03_20_02_auth.sql','85E4ACD9AA099C0C4AC034575F2BB07D348EAC72','ARCHIVED','2015-03-21 16:56:46',0),
('2015_03_26_00_auth.sql','34AC8543E6A9C6C832DE58EAB33618EEEF70B9F9','ARCHIVED','2015-05-02 13:57:57',0),
('2015_04_04_00_auth.sql','57146B35E54A2EC7869C945034AB078358020311','ARCHIVED','2015-05-02 13:57:57',0),
('2015_04_06_00_auth.sql','2A8049DC2923420A002D42FB6F02C2FFCC5CDD22','ARCHIVED','2015-05-02 13:57:57',0),
('2015_04_08_00_auth.sql','4D7D8EEF285C982BB676836602266501BEC26764','ARCHIVED','2015-05-02 13:57:57',0),
('2015_04_10_00_auth.sql','4AE68FD97A95CEE5143EA20FD33F5D557367AC1F','ARCHIVED','2015-05-02 13:57:57',0),
('2015_04_11_00_auth.sql','80A71C8921CFEBB547D264558B6DE27201685B84','ARCHIVED','2015-05-02 13:57:57',0),
('2015_04_11_01_auth.sql','3E88183E1A85D11BFD74CF9A32A725C44AE02EEC','ARCHIVED','2015-05-02 13:57:57',0),
('2015_04_21_00_auth.sql','1B3B48DBA06368B985C548D166C515C9DD598CB9','ARCHIVED','2015-05-02 13:57:57',0),
('2015_05_02_00_auth.sql','96AB595E0D2A088750E3F48B0AF0A8A14F3CFE1E','ARCHIVED','2015-05-02 13:57:57',0),
('2015_05_02_01_auth.sql','FB11FB834E488B0FD3AFDABCC1A3113092E7C2E5','ARCHIVED','2015-05-02 13:57:57',0),
('2015_07_02_00_auth.sql','E5EE3842AB9B01851E49B360FBAF6FFEEAB2A8DA','ARCHIVED','2015-07-10 19:30:56',0),
('2015_07_06_00_auth.sql','6D1ADBA496DC6E6D7B3BF887DA8D4D17D3FBACE0','ARCHIVED','2015-07-10 19:30:56',0),
('2015_07_08_00_auth.sql','CB54020AFD1E31742FD8BF9CE16879625E289788','ARCHIVED','2015-07-10 19:30:56',0),
('2015_07_08_01_auth.sql','74D281CB82E0DA36D628BDC7AC797AE5498DB461','ARCHIVED','2015-07-10 19:30:56',0),
('2015_07_16_00_auth.sql','A057E95B5553B6A57A1642FE3FEC8E2E62EDE3C6','ARCHIVED','2015-10-10 08:30:48',0),
('2015_07_29_00_auth.sql','0000FECBC413E96C7C45F303D162E263EFBA7116','ARCHIVED','2015-10-10 08:30:48',0),
('2015_08_26_00_auth.sql','3071C02A2EB7DCBF4CEE10279FEFAB7C29A43A3A','ARCHIVED','2015-10-10 08:30:48',0),
('2015_09_05_00_auth.sql','F765D82B37873FA67447347D5B83C99C159FB452','ARCHIVED','2015-10-10 08:30:48',0),
('2015_09_05_01_auth.sql','97A72DBCBF14D27A1863834A22296905FF276086','ARCHIVED','2015-10-10 08:30:48',0),
('2015_09_09_00_auth.sql','495A0CF1B1C49205D4A5D3C25A4E1EB95616D6B4','ARCHIVED','2015-10-10 08:30:48',0),
('2015_09_15_00_auth.sql','D1FEFDA4C98F30384DF4B64D5A53187303EB5786','ARCHIVED','2015-10-10 08:30:48',0),
('2015_10_09_00_auth.sql','B6D643D444C6AE711503F73B96B6252A852913D6','ARCHIVED','2015-10-10 08:30:48',0),
('2015_10_16_00_auth.sql','366AFFD1088762866091A81CE1EC64138B8B35F1','ARCHIVED','2015-11-08 00:46:02',0),
('2015_10_17_00_auth.sql','AC0D45E905033F42093852D2C4476663BDACCB3D','ARCHIVED','2015-10-17 12:39:12',0),
('2015_11_01_00_auth_2015_08_21_00.sql','C31A9E1D28E11B60BE8F8198637DD51F6D75123F','ARCHIVED','2015-08-21 00:00:00',0),
('2015_11_08_00_auth.sql','0ACDD35EC9745231BCFA701B78056DEF94D0CC53','ARCHIVED','2015-11-07 00:00:00',0),
('2015_11_21_00_auth.sql','575A1D697CC6C7C517F7CCB950988267C99CE7FA','ARCHIVED','2015-11-21 21:25:38',0),
('2015_12_07_00_auth.sql','24A07AC1F38E5D26A3599FC06D29E267418F69F3','ARCHIVED','2015-12-07 20:55:48',0),
('2016_01_13_00_auth.sql','114527BCCB0DE286CBE6FDA3029DD0523D1037FA','ARCHIVED','2016-01-13 21:39:13',0),
('2016_03_22_01_auth_2016_01_13_00_auth.sql','24615CC69B3CD7BB4699874647C35BA86E8A93FD','ARCHIVED','2016-03-22 22:55:13',0),
('2016_03_28_00_auth.sql','BA14D23D81FA24565F04A359090DE86C5E195209','ARCHIVED','2016-03-28 16:49:32',0),
('2016_04_11_00_auth.sql','0ACDD35EC9745231BCFA701B78056DEF94D0CC53','ARCHIVED','2016-04-11 00:00:00',0),
('2016_04_17_00_auth.sql','83399B64D1221B56F73A0FFB51889F11A70521BC','ARCHIVED','2016-04-17 00:22:05',0),
('2016_05_07_00_auth.sql','7E36DCC4F06FCDCDA7155AF3C5EDF8D3A720565F','ARCHIVED','2016-05-07 01:00:21',0),
('2016_05_19_00_auth.sql','FB52E6BF35682CE6FA667B552B551F4FBD72AC30','ARCHIVED','2016-05-19 22:18:06',0),
('2016_07_19_00_auth.sql','D5498F28A1E21F4AD0E0D7C2B96FCF7292C14C4D','ARCHIVED','2016-07-19 14:00:28',0),
('2016_07_19_01_auth.sql','EBFE5D7D7E7CFA0CDA76AC49A1E8D4FA461A12BE','ARCHIVED','2016-07-19 16:06:39',0),
('2016_07_23_00_auth.sql','1048F6A922ACD9BFC2E4518A71AF7037F79A85C4','ARCHIVED','2016-07-23 14:39:21',0),
('2016_07_23_01_auth.sql','5897C7D8B8DE15895286FBCD1535FC75E1B70F62','ARCHIVED','2016-07-23 17:35:11',0),
('2016_07_30_00_auth.sql','0FD4147840F7F02E2F1828A904B269F5B66097E0','ARCHIVED','2016-07-30 15:07:02',0),
('2016_08_07_00_auth.sql','D9DD23851822E32E1312FFABEE2DB721C8651443','ARCHIVED','2016-08-07 15:33:42',0),
('2016_08_11_00_auth.sql','0C79A86A4DFC53746BECF3D8A145482F94AE5FC9','ARCHIVED','2016-08-11 17:02:20',0),
('2016_08_13_00_auth.sql','ED2286C4FF3D80D0F4DEE3D3121BCC15544470BE','ARCHIVED','2016-08-13 01:11:49',0),
('2016_08_26_00_auth.sql','3C566371B6026EFEEA19CD215EC9F02C6DA9EAB3','ARCHIVED','2016-08-26 14:09:52',0),
('2016_08_27_00_auth.sql','65ABEF7ACBCEA974C744ED42F95FBBD29226917B','ARCHIVED','2016-08-27 07:02:45',0),
('2016_08_30_00_auth.sql','E16C19A938FE6370921658D2B713EE28A633FD56','ARCHIVED','2016-08-30 00:00:00',0),
('2016_09_02_00_auth.sql','08932DAC4BDE74D3C39A43DDE404522F23EDD035','ARCHIVED','2016-09-02 00:00:00',0),
('2016_09_03_00_auth_2016_05_11_00_auth.sql','401EFD3586772BDED66B4A944C20A1AC18A22D3A','ARCHIVED','2016-09-03 11:29:38',0),
('2016_09_03_01_auth.sql','08B5ABCB74BBF25A30D37AF639F0EA1B10640673','ARCHIVED','2016-09-03 13:24:32',0),
('2016_09_03_02_auth_2016_06_06_00_auth.sql','A0A8D73A952D0618833416513D53F73A70E7EA25','ARCHIVED','2016-06-06 00:00:00',0),
('2016_09_03_03_auth.sql','9BF1C03EE39B6DC7E817BA46BE7D12A41AFBFDF7','ARCHIVED','2016-09-03 15:56:50',0),
('2016_09_15_00_auth.sql','CD65F822AF1B5B7776E39804D0362F3E34AA6445','ARCHIVED','2016-09-15 16:30:36',0),
('2016_09_21_00_auth.sql','57219A16B88080240EED94CDD41FC2764B8A32C5','ARCHIVED','2016-09-21 17:08:43',0),
('2016_09_25_00_auth.sql','E811EFD8CE92ABEC5B8C02A09E643035939CF96D','ARCHIVED','2016-09-25 15:56:58',0),
('2016_10_01_00_auth.sql','7C444FF1B03BA3C83472BDA409854754D052D6FB','ARCHIVED','2016-10-01 13:32:43',0),
('2016_10_06_00_auth.sql','6A415F9813EFB5B95EB2AA2B326E1A6791E25EDB','ARCHIVED','2016-10-06 23:16:24',0),
('2016_10_12_00_auth.sql','671D57BBA183AC70B9580DEE19B7EC046AF2EA87','ARCHIVED','2016-10-12 00:01:05',0),
('2016_10_17_00_auth.sql','A0EF594CD73690D46A46031137DB0E895F079235','ARCHIVED','2016-10-16 16:33:05',0),
('2016_10_25_00_auth.sql','5743FB1AC3F564FE4192DCFA90260BAD5E501882','ARCHIVED','2016-10-25 19:27:02',0),
('2016_10_28_00_auth.sql','C1B9B1DD20B2183C6CB44CAED9B91BA7C63B8C49','ARCHIVED','2016-10-28 00:07:48',0),
('2016_11_04_00_auth.sql','3F4FE06DCE019EB3223B5A6E0F80E2239078967F','ARCHIVED','2016-11-04 20:25:23',0),
('2016_11_09_00_auth.sql','56432F8AEC2943A398A5B8B77843138B5B704257','ARCHIVED','2016-11-09 18:46:48',0),
('2016_11_17_00_auth.sql','18E8F8FC93CC38755AB571638960AAFB98C0F3F1','ARCHIVED','2016-11-17 23:47:51',0),
('2016_12_04_00_auth.sql','B1623681EAB651D2A091E3F4D4D4E476CF6D3AEA','ARCHIVED','2016-12-04 00:41:36',0),
('2016_12_11_00_auth.sql','24CA34537DB697962DDD69EEE4BB5E79D2A573DA','ARCHIVED','2016-12-11 18:18:59',0),
('2016_12_18_00_auth.sql','7AB53E033680CF7439F142EF83CD13E6F5D0ACB9','ARCHIVED','2016-12-18 12:15:48',0),
('2017_01_14_00_auth.sql','1B514D1364042DB4CE68929EB54A94F86983441D','ARCHIVED','2017-01-14 20:50:47',0),
('2017_01_26_00_auth.sql','723E1B69981A32A2F28A67C64902BA1AE7E98E48','ARCHIVED','2017-01-26 17:10:15',0),
('2017_01_29_00_auth.sql','B76C514678903F540302505AF66886F7D2C89E30','ARCHIVED','2017-01-29 00:00:00',0),
('2017_03_11_00_auth.sql','2F2F67E51439346B212C27B7224E4614C00E1AEB','ARCHIVED','2017-03-11 00:00:00',0),
('2017_03_17_00_auth.sql','4902E9B1B063F399F928C2DD7AFD60427738E227','ARCHIVED','2017-03-17 00:00:00',0),
('2017_04_17_00_auth.sql','86299FAB21D895E84272286309CC8EE80F9DA8C7','ARCHIVED','2017-04-17 00:00:00',0),
('2017_04_19_00_auth.sql','9903AAF50DF384F52E81F7E2892FE5271E000490','ARCHIVED','2017-04-18 23:16:18',0),
('2017_04_22_00_auth.sql','843663B18D28FBA1EB12548500EC93953881E5F0','ARCHIVED','2017-04-22 19:28:22',0),
('2017_04_27_00_auth.sql','308B797B47FA803D492C9C9A4C26DBEC546DBBD9','ARCHIVED','2017-04-28 09:10:11',0),
('2017_05_14_00_auth.sql','B7E76CCDCC9A2C8103427DA4C43C7B0366ECE8B4','ARCHIVED','2017-05-14 12:00:00',0),
('2017_06_12_01_auth.sql','661B4935E101AF188BEBF43203144104E89F8C54','ARCHIVED','2017-06-12 00:00:01',0),
('2017_06_12_02_auth.sql','166F059E411FAA4901BBBA09A41EF07B1CADC4B6','ARCHIVED','2017-06-12 00:00:02',0),
('2017_06_15_00_auth.sql','DD71F25C1E61FD5F836931B02703BE3BD1B4F156','ARCHIVED','2017-06-15 15:20:50',0),
('2017_06_17_00_auth.sql','4A172895CB9DA8EFE1270434D6ECB22D4F4DCB17','ARCHIVED','2017-06-17 00:00:00',0),
('2017_06_18_00_auth.sql','7200968BFC2D76499149937B19F2153FD2ABC397','ARCHIVED','2017-06-18 22:13:37',0),
('2017_06_25_00_auth.sql','A2DA6A64D4217992EF766915DEBD517DB0834E01','ARCHIVED','2017-06-25 00:54:10',0),
('2017_06_28_00_auth_master.sql','6E58300D4D4DAAEE89107ECB3CB7DA8529DA738F','ARCHIVED','2017-06-28 19:11:09',0),
('2017_06_28_00_auth_rbac.sql','D32EF80F57F629C23395D80F06E91D7E40719F83','ARCHIVED','2017-06-28 00:00:00',0),
('2017_06_30_00_auth.sql','C73BD277D211DBE1BB86BB1B443CA8F292D8ADEE','ARCHIVED','2017-06-30 16:18:51',0),
('2017_08_01_00_auth.sql','6ECE808AF52345177189E962C0606B769B6806A6','ARCHIVED','2017-08-01 00:00:00',0),
('2017_08_04_00_auth.sql','2E994A704C64FECE3CE0883ED0CAC5E5A0E3A36C','ARCHIVED','2017-08-04 23:46:32',0),
('2017_08_13_00_auth_2016_09_22_00_auth.sql','70047954E3556BFA430ADD5680EF8797F74A4B9E','ARCHIVED','2017-08-13 12:00:00',0),
('2017_09_22_00_auth.sql','9313CCE80A18212E6F0C78D83316DE8582AE8084','ARCHIVED','2017-09-22 18:05:17',0),
('2017_10_13_00_auth.sql','87674E0D166AC60E3725B445714427892E42C6FE','ARCHIVED','2017-10-13 00:00:00',0),
('2017_11_11_01_auth.sql','0D6EDB6B2FC8B9FBDF11ECD79B4B8E943328B6A9','ARCHIVED','2017-11-11 18:49:45',0),
('2017_12_17_00_auth.sql','2CD99730D4D32DBF0584CD5B1AA6F8F4AE3DA975','ARCHIVED','2017-12-17 00:00:00',0),
('2017_12_30_00_auth.sql','F360E9555AC68E28834E3FF807E4E37A090EF363','ARCHIVED','2017-12-30 00:23:32',0),
('2017_12_30_01_auth.sql','1E11C78BA6D1D8E8CED7423DF92D1D197D6061EE','ARCHIVED','2017-12-30 23:00:00',0),
('2017_12_31_00_auth.sql','1721ACBD35EB95FAE33B9E95F8C4E4B1FB70A5E4','ARCHIVED','2017-12-31 20:15:23',0),
('2018_01_02_00_auth.sql','CD9B826B9D95697DC412DEF780E814FA3991D6CD','ARCHIVED','2018-01-02 20:40:37',0),
('2018_01_09_00_auth.sql','A5D4EC8FCFAB4F2DCE70EDCAD1ACBFB484FD68D5','ARCHIVED','2018-01-09 00:00:00',0),
('2018_01_24_00_auth.sql','167B17D8A253D62A8112F8A7EB21C6E99CAEF1E4','ARCHIVED','2018-01-24 00:00:00',0),
('2018_02_18_00_auth.sql','8489DD3EFFE14A7486B593435F0BA2BC69B6EABF','ARCHIVED','2018-02-18 16:35:55',0),
('2018_02_19_00_auth.sql','07CE658C5EF88693D3C047EF8E724F94ADA74C15','ARCHIVED','2018-02-19 22:33:32',0),
('2018_02_28_00_auth.sql','E92EF4ABF7FA0C66649E1633DD0459F44C09EB83','ARCHIVED','2018-02-28 23:07:59',0),
('2018_03_08_00_auth.sql','624C58A07E0B4DDC4C1347E8BA8EFEEFD5B43DA7','ARCHIVED','2018-03-08 00:00:00',0),
('2018_03_14_00_auth.sql','2D71E93DF7419A30D0D21D8A80CF05698302575A','ARCHIVED','2018-03-14 23:07:59',0),
('2018_04_06_00_auth.sql','D8416F0C4751763202B1997C81423F6EE2FCF9A6','ARCHIVED','2018-04-06 18:00:32',0),
('2018_05_13_00_auth.sql','A9E20F2EB1E2FDBB982DB6B00DB7301852B27CD4','ARCHIVED','2018-05-13 20:22:32',0),
('2018_05_24_00_auth.sql','B98FD71AAA13810856729E034E6B8C9F8D5D4F6B','ARCHIVED','2018-05-24 22:32:49',0),
('2018_06_14_00_auth.sql','67EAB915BF0C7F2D410BE45F885A1A39D42C8C14','ARCHIVED','2018-06-14 23:06:59',0),
('2018_06_22_00_auth.sql','9DA24F70B8A365AFDEF58A9B578255CDEDFCA47C','ARCHIVED','2018-06-22 17:45:45',0),
('2018_06_23_00_auth.sql','BE35312C386A127D047E5A7CE0D14DB41D905F8E','ARCHIVED','2018-06-23 00:00:00',0),
('2018_06_29_00_auth.sql','03AAEA7E52848FA5522C3F0C6D9C38B988407480','ARCHIVED','2018-06-29 22:34:04',0),
('2018_08_30_00_auth.sql','22F69864361D3E72F800379338310172C0576D1C','ARCHIVED','2018-08-30 00:00:00',0),
('2018_09_06_00_auth.sql','309D21E0DF82ED8921F77EAFDE741F38AC32BB13','ARCHIVED','2018-09-06 00:00:00',0),
('2018_09_17_00_auth.sql','4DB671F0A4FA1A93AF28FB6426AF13DE72C7DA3D','ARCHIVED','2018-09-17 00:00:00',0),
('2018_12_09_00_auth_2017_01_06_00_auth.sql','6CCFE6A9774EC733C9863D36A0F15F3534189BBD','ARCHIVED','2017-01-06 00:00:00',0),
('2018_12_09_01_auth.sql','576C2A11BE671D8420FA3EB705E594E381ECCC56','ARCHIVED','2018-12-09 14:49:17',0),
('2019_04_27_00_auth.sql','84B1EB9CC9B09BAF55E6295D202EC57D99B1B60E','ARCHIVED','2019-04-27 18:07:18',0),
('2019_06_06_00_auth.sql','6DE8159E04BEE7BA0A4A81D72D160EB74934B6A5','ARCHIVED','2019-06-06 18:09:54',0),
('2019_06_08_00_auth.sql','EA5A78F5A26C17BC790481EA9B3772D3A6912459','ARCHIVED','2019-05-20 17:21:20',0),
('2019_06_08_01_auth.sql','8165B1B787E3ECF0C8C0AD2D641513270977ABB4','ARCHIVED','2019-06-04 16:51:31',0),
('2019_06_08_02_auth.sql','B39DCBD902290700A81C9D028F54B58601C19A99','ARCHIVED','2019-06-05 16:26:31',0),
('2019_06_08_03_auth.sql','F483B657015D39D4F63E3905C27C3AA48241AB03','ARCHIVED','2019-06-08 17:14:21',0),
('2019_06_16_00_auth.sql','B14AED4D3387B56FF8C8161D3671750AEEAE0F2E','ARCHIVED','2019-06-15 23:32:12',0),
('2019_06_21_00_auth.sql','C519239830204B68E710F698BC0C9E89B6D5FD24','ARCHIVED','2019-06-20 19:43:50',0),
('2019_07_14_00_auth.sql','94C2B877BD906538E1E008350BEA8D8B58E0A158','ARCHIVED','2019-07-14 19:22:08',0),
('2019_07_15_00_auth.sql','3649248104CFEC70553016273069A9AE744798E3','ARCHIVED','2019-07-15 19:22:08',0),
('2019_07_16_00_auth.sql','36CB53A9EBD64BFDCF7030083E36E534F1753773','ARCHIVED','2019-07-16 00:00:00',0),
('2019_07_17_00_auth.sql','4F983F039904894ACC483BE885676C5F0A18F06B','ARCHIVED','2019-07-17 00:00:00',0),
('2019_07_26_00_auth.sql','DC9D0651602AE78B1243B40555A1A7B8447D01B2','ARCHIVED','2019-07-26 18:21:34',0),
('2019_08_10_00_auth.sql','3568A1C9C6D62BBCD470C0623C1580E332D545D2','ARCHIVED','2022-01-02 21:18:52',0),
('2019_08_10_01_auth.sql','C58357260F0C70DA226A71F7E05DE2C49AAEFD74','ARCHIVED','2019-08-10 00:00:00',0),
('2019_08_11_00_auth.sql','04DCC2ABDA15BC7C015E8BFEA383C62A362B166F','ARCHIVED','2019-08-11 10:56:39',0),
('2019_08_18_00_auth.sql','0479A04B669A67D2E5A498CFB91507E742EFB34F','ARCHIVED','2019-08-17 11:51:02',0),
('2019_10_27_00_auth.sql','C943A651B5C9AC51BB7DF69821886F4B59F57153','ARCHIVED','2019-10-27 13:06:06',0),
('2019_11_13_00_auth.sql','EB680BA7D6B3A21A432687F452CDD86FB2DA677C','ARCHIVED','2019-11-13 11:49:55',0),
('2019_11_20_00_auth.sql','9BC11595D9CEA486AC1540A204DCE9D86A008D7D','ARCHIVED','2019-11-20 12:31:56',0),
('2019_11_23_00_auth.sql','098708CDC5614B4523AD3B17670939671E661443','ARCHIVED','2019-11-23 12:20:03',0),
('2019_12_04_00_auth.sql','4EB3D028DD80B18DA9B9250ADA4D22AA0D3C0447','ARCHIVED','2019-12-04 18:03:39',0),
('2019_12_07_00_auth.sql','F354DA31D5B300609C6AE8A25667CA4DE0A7349F','ARCHIVED','2019-12-07 12:57:23',0),
('2019_12_10_00_auth.sql','CC0DC6211FB2A1271EBF5D81F47B3EF1CED7A7AD','ARCHIVED','2019-12-10 17:50:44',0),
('2019_12_14_00_auth.sql','CF577A0B6F9747658CDECE3F690B05B89C5B4470','ARCHIVED','2019-12-14 11:17:56',0),
('2020_01_11_00_auth.sql','A0C4863741C4B93D343B7837FBA38D6023A237F9','ARCHIVED','2020-01-11 13:44:51',0),
('2020_01_12_00_auth.sql','5E4ECF243259B9866A877E2D3798D1D753738E24','ARCHIVED','2020-01-12 11:33:48',0),
('2020_02_17_00_auth.sql','456FA32A7B7C6ABA479F2B099822988A24A2344B','ARCHIVED','2020-02-17 23:28:22',0),
('2020_02_24_00_auth.sql','47E22129056EFD8B67754506231BCC4B0DDA6930','ARCHIVED','2020-02-24 17:19:33',0),
('2020_03_03_00_auth.sql','F473DFEABAC661704ECEA3D72E93A3280122CA30','ARCHIVED','2020-03-03 22:49:13',0),
('2020_03_20_00_auth.sql','0F72572D7792236D8F1E556D9EC62352A0A149CA','ARCHIVED','2020-03-20 10:01:23',0),
('2020_03_23_00_auth.sql','B90D27BB8E3CEDF65881BDA0C7CE6FBC5EF310E0','ARCHIVED','2020-03-23 17:57:46',0),
('2020_03_31_00_auth.sql','BA82A58E95730A397922B6723DA027986E6CD535','ARCHIVED','2020-03-31 17:00:16',0),
('2020_04_04_00_auth.sql','5F118989A9F8AFA3B2065AB9C2C0BB7D9A0EB97A','ARCHIVED','2020-04-04 13:23:53',0),
('2020_04_07_00_auth.sql','6D73A4E1EC5382F10C39F20E2E6E764510A8A5E6','ARCHIVED','2020-04-07 22:23:35',0),
('2020_04_18_00_auth.sql','BD962B50760771B60F2785027D6957EEF2009240','ARCHIVED','2020-04-18 14:09:28',0),
('2020_04_30_00_auth.sql','2FD304B8EF82D529D69287BF22EF061A267F827E','ARCHIVED','2020-04-30 00:39:29',0),
('2020_05_19_00_auth.sql','12D9F26538F63546B74793499E8A71BD885E8E5F','ARCHIVED','2020-05-19 12:00:00',0),
('2020_06_04_00_auth.sql','BA797B558196B1A07F8FF66E5288AD04659CF6AC','ARCHIVED','2020-06-04 09:57:07',0),
('2020_06_17_00_auth.sql','8BAB0BF5C90EBDE68685A9FB772EA90DD214E6D6','ARCHIVED','2020-06-17 09:56:25',0),
('2020_06_17_01_auth.sql','8FBF37B875B5C0E8A609FFB1A2C02F2920A3D3F4','ARCHIVED','2020-06-17 17:04:56',0),
('2020_06_20_00_auth.sql','85345FAF20B91DA7B157AE1E17DF5B6446C2E109','ARCHIVED','2020-06-11 10:48:00',0),
('2020_07_02_00_auth.sql','08D0F9D70AE625285172B3E02A3DAFE17D88E118','ARCHIVED','2020-07-02 10:29:25',0),
('2020_07_03_00_auth.sql','ED7175E51F248ADC5EF60E7CEA9627CC3191ED4C','ARCHIVED','2020-07-03 20:09:39',0),
('2020_07_23_00_auth.sql','5F47E1CEECA9F837C85C2DAC7ECD47AED321F502','ARCHIVED','2020-07-23 19:54:42',0),
('2020_07_24_00_auth.sql','06598162E9C84DDF8AA1F83D0410D056C3F7F69E','ARCHIVED','2020-07-24 00:44:34',0),
('2020_07_25_00_auth.sql','BE376B619ECB6FE827270D5022F311E20AD6E177','ARCHIVED','2020-07-25 00:00:49',0),
('2020_08_02_00_auth.sql','B0290F6558C59262D9DDD8071060A8803DD56930','ARCHIVED','2020-08-02 00:00:00',0),
('2020_08_03_00_auth.sql','492CA77C0FAEEEF3E0492121B3A92689373ECFA3','ARCHIVED','2020-08-03 09:24:47',0),
('2020_08_03_01_auth.sql','EC1063396CA20A2303D83238470D41EF4439EC72','ARCHIVED','2020-08-03 00:00:01',0),
('2020_08_06_00_auth.sql','5D3C5B25132DAFCA3933E9CBE14F5E8A290C4AFA','ARCHIVED','2020-08-06 20:26:11',0),
('2020_08_08_00_auth.sql','BC6A08BE42A6F2C30C9286CBDD47D57B718C4635','ARCHIVED','2020-08-08 00:16:57',0),
('2020_08_11_00_auth.sql','14C99177E43003D83A4D6F2227722F15FC15A1D0','ARCHIVED','2020-08-11 00:00:00',0),
('2020_08_14_00_auth.sql','DFB9B07A7846FC0E124EE4CC099E49FE5742FB66','ARCHIVED','2020-08-14 21:41:24',0),
('2020_08_26_00_auth.sql','D5EF787DECB41D898379588F101A0453B46F04D9','ARCHIVED','2020-08-26 21:00:34',0),
('2020_09_06_00_auth.sql','DC4B5D4C65EB138D5609F137799C3289B9CC2493','ARCHIVED','2020-09-06 00:00:00',0),
('2020_09_17_00_auth.sql','BBC0A8B2BBED38A57A83999909EB066753A893C5','ARCHIVED','2020-09-17 00:00:00',0),
('2020_09_25_00_auth.sql','3CCA78EF89223724BA6784A4F3783DED30416637','ARCHIVED','2020-09-25 19:52:40',0),
('2020_10_20_00_auth.sql','1835C5EFD5816DEF914F27E867C8C8D5E08B3F68','ARCHIVED','2020-10-20 21:36:49',0),
('2020_12_06_00_auth.sql','FA254400D3D7D53E9C350EABFEABFF4EC3AD40DA','ARCHIVED','2020-12-06 20:25:10',0),
('2020_12_07_00_auth.sql','23626805735CB9BEEEBD756D4A39AFBCDA6E366C','ARCHIVED','2020-12-07 21:12:53',0),
('2020_12_15_00_auth.sql','37DA3C4830ABA30C49370A8647F5B6B3E1821E57','ARCHIVED','2020-12-15 19:33:15',0),
('2020_12_22_00_auth.sql','1AED5AD7D93C30CF75E62EBEBCC64FFEDC58F00A','ARCHIVED','2020-12-22 22:00:39',0),
('2020_12_31_00_auth.sql','05C9C105D55C6588CDA0D75AE3B135B7E6B54C06','ARCHIVED','2020-12-31 12:58:21',0),
('2021_01_10_00_auth.sql','4430F5CC9A31DBBEA4E437E980E9F26AC919C016','ARCHIVED','2021-01-10 12:29:57',0),
('2021_01_13_00_auth.sql','F7C15519FFA0FE27EED859343B58714624A302E6','ARCHIVED','2021-01-13 11:19:52',0),
('2021_02_09_00_auth.sql','F00ABFF6E3C3F5ACE3444C9D70BADC764C8B3CE2','ARCHIVED','2021-02-09 17:22:24',0),
('2021_04_10_00_auth.sql','7B92AC4F76507940EF2257897F25304CF0F306EB','ARCHIVED','2021-04-10 19:42:42',0),
('2021_05_12_00_auth.sql','7F37DAD1777D62FDB00C19C0DF5E7DB742CCD5AD','ARCHIVED','2021-05-12 01:08:42',0),
('2021_06_20_00_auth.sql','7CA418D570DC1444C19AAD18F4A50FF187642310','ARCHIVED','2021-06-20 17:29:17',0),
('2021_07_04_00_auth.sql','3CF056F8F04E49C1E236060202AA8DA7E186B590','ARCHIVED','2021-07-04 22:23:24',0),
('2021_08_07_00_auth.sql','D615C2CACC999FF8804AEF56BAAA08D02217D671','ARCHIVED','2021-08-07 23:18:57',0),
('2021_08_18_00_auth.sql','162590897AC0020E68EB6845637901C3EB6509B4','ARCHIVED','2021-08-18 15:14:17',0),
('2021_08_19_00_auth.sql','DE008EDFB1FEBA49567E245A64BFE70DA72D9E7B','ARCHIVED','2021-08-19 10:58:58',0),
('2021_09_02_00_auth.sql','907344F4F0113A13D5E0A1D95E2C3E4C4150090C','ARCHIVED','2021-09-02 12:38:08',0),
('2021_09_10_00_auth.sql','DE94812ABC7B395C6C3405FB6718A8AF2C9F8FEC','ARCHIVED','2021-09-10 12:18:54',0),
('2021_10_07_00_auth.sql','45F2D92E28382F0CBE1F9B3A97693C0CC69E50BC','ARCHIVED','2021-10-07 10:32:05',0),
('2021_10_13_00_auth.sql','220E63385CACCBCEC36C57717DE369F2FCABCAAF','ARCHIVED','2021-10-13 21:15:05',0),
('2021_10_15_00_auth.sql','C8AA212AB2BB2DB5B3C2C9622A3874475AEFBD7B','ARCHIVED','2021-10-15 10:11:47',0),
('2021_10_15_01_auth.sql','72A0437F0ADEC59FF9D6839DF845C473F693CA5B','ARCHIVED','2021-10-16 00:15:25',0),
('2021_10_16_00_auth.sql','FDC45C7BEFBAFC9BCE6C77377B026A59AE52EE21','ARCHIVED','2021-10-16 11:24:39',0),
('2021_10_22_00_auth.sql','07D7397061A5A906357DC6E91FC33C74638EFDC3','ARCHIVED','2021-11-17 13:21:03',0),
('2021_10_23_00_auth.sql','97A8F2C2CEDB99C942D38F5B65DAD1DC11296E20','ARCHIVED','2021-10-23 00:00:00',0),
('2021_10_26_00_auth.sql','91E8B308267847569D9A669BC34794F154242ECF','ARCHIVED','2021-10-26 00:41:04',0),
('2021_11_05_00_auth.sql','4A4510436578B6486E8399602D3060376E96A8C7','ARCHIVED','2021-11-05 00:33:00',0),
('2021_11_06_00_auth.sql','3646F9356429CCE7C1CECC7D9BA7960E011C7B6B','ARCHIVED','2021-11-06 11:54:12',0),
('2021_11_10_00_auth.sql','EB3D26EFD3109BC17447B3BAC7573473F5103F65','ARCHIVED','2021-11-10 14:07:05',0),
('2021_11_12_00_auth.sql','012C088794362FE57BAEA0C3BD05356B40289028','ARCHIVED','2021-11-12 12:17:24',0),
('2021_11_17_00_auth.sql','298DA8468B30042B15FA17A90325C72879DF6D8E','ARCHIVED','2021-11-17 13:23:17',0),
('2021_11_19_00_auth.sql','BE4F77E254D76A59DBF28B2CEEA5CAF6777B650E','ARCHIVED','2021-11-19 00:37:56',0),
('2021_11_20_00_auth.sql','E476B6DAD9C47FC81E1DA5016DC79AB527F1847A','ARCHIVED','2021-11-20 18:40:53',0),
('2021_11_25_00_auth.sql','7A01CEB201CB825BFD565BBF5EED0162BEA733E7','ARCHIVED','2021-11-25 19:32:21',0),
('2021_12_02_00_auth.sql','ED40A45A8F5E5B1BB68216A3053D721B3BA3A556','ARCHIVED','2021-12-02 11:48:11',0),
('2021_12_04_00_auth.sql','00C4A37A60F53A5E893CAADAC882E5A28375A4D2','ARCHIVED','2021-12-04 12:49:04',0),
('2021_12_08_00_auth.sql','9B1A7C86F56159CA50A45B9CB4BC6422A3378231','ARCHIVED','2021-12-08 00:28:19',0),
('2021_12_16_00_auth.sql','EF5050D779CC6CEAAFB4C7E0CFA26824D92B675E','ARCHIVED','2021-12-16 12:21:11',0),
('2021_12_31_00_auth.sql','16AA1CFB93CC42DC9CC7C0C787C64D3CE9662EE5','ARCHIVED','2022-01-02 21:18:52',0),
('2021_12_31_01_auth.sql','336E62A8850A3E78A1D0BD3E81FFD5769184BDF8','ARCHIVED','2021-12-31 15:58:32',0),
('2022_01_02_00_auth.sql','F0AF198C5F7529508A5DB1F29D153256368AD1B4','ARCHIVED','2022-01-02 21:22:35',0),
('2022_01_08_00_auth.sql','3C9853058A77817DD62943D0332418D84CA6BDA1','ARCHIVED','2022-01-15 23:21:37',0),
('2022_01_15_00_auth.sql','11552D29BEDF73626FB8D932AB4362882964B4F0','ARCHIVED','2022-01-15 23:24:57',0),
('2022_01_22_00_auth.sql','24A9BB761E805608EFDD8F647BF733602B337018','ARCHIVED','2022-01-22 01:39:01',0),
('2022_02_25_00_auth.sql','1556FEDB9B46643634AE5BD0E38E7FF447FFC081','ARCHIVED','2022-02-25 12:39:15',0),
('2022_02_26_00_auth.sql','955F8E13B0D91CA06FEEAD4E6C75E5495DA6DDF3','ARCHIVED','2022-02-26 01:01:22',0),
('2022_03_01_00_auth.sql','53636BBB7DF4FFC2496456C1EEF2BD271D1C87E0','ARCHIVED','2022-03-01 16:07:38',0),
('2022_03_02_00_auth.sql','928C11D145B98E90FB82D2A871C2456C848AB6C1','ARCHIVED','2022-03-02 10:10:19',0),
('2022_03_03_00_auth.sql','408CCCF7D47FB5C876E976F883B4BDBFFEC5D146','ARCHIVED','2022-03-03 01:09:55',0),
('2022_03_06_00_auth.sql','2883FD8D2CB8B2FC3DF7D20D3216301262E7A7C3','ARCHIVED','2022-03-06 15:12:24',0),
('2022_03_08_00_auth.sql','E2C6B4E26FE55F5827C587CD668F6518EB2B51E8','ARCHIVED','2022-03-08 15:24:10',0),
('2022_03_12_00_auth.sql','1A476DB06BC1F096E6F15225078373B3AD094C1B','ARCHIVED','2022-03-12 05:52:02',0),
('2022_03_22_00_auth.sql','16A58234A1EF4F13ABD6EF78733BDBF5152AA70C','ARCHIVED','2022-03-22 00:32:54',0),
('2022_03_25_00_auth.sql','173D4F7B5417AF11DDDE6EC1A58ECFA6783C7FAF','ARCHIVED','2022-03-25 00:26:53',0),
('2022_03_30_00_auth.sql','37177AB41D7DF26CF4F908C0522EDEAF13094D7E','ARCHIVED','2022-03-30 00:37:34',0),
('2022_03_30_01_auth.sql','AACD3E4E8673F6D90677C97D5B0B0F292D0C1763','ARCHIVED','2022-03-30 04:28:42',0),
('2022_04_08_00_auth.sql','C0BE7634D6B84D860111AF5EEDF1D023875F3137','ARCHIVED','2022-04-08 21:01:16',0),
('2022_04_14_00_auth.sql','4D79D1C7282CA8F1626D957AF17E711BFF94334B','ARCHIVED','2022-04-14 04:39:49',0),
('2022_04_22_00_auth.sql','835EE2D6981AD7A7467490242D6A4B0E0B69E4F4','ARCHIVED','2022-04-22 20:04:53',0),
('2022_05_03_00_auth.sql','0874FBE9821F2659BA51B91E9D69B9E6CA6D2EC9','ARCHIVED','2022-05-03 11:07:21',0),
('2022_06_01_00_auth.sql','DCFC7EC6C52993769B568EAF87CA2DAA10359AEB','ARCHIVED','2022-06-02 00:52:17',0),
('2022_06_06_00_auth.sql','68D73F068598D37FD6FBC84362F1BA7BA4EC2709','ARCHIVED','2022-06-06 21:35:16',0),
('2022_06_07_00_auth.sql','76B4D21F13B0024445E5C0B48C630C1DF7E80966','ARCHIVED','2022-06-07 16:09:58',0),
('2022_06_08_00_auth.sql','250081465C76AC9668E3F66D386CE2AAC05379E9','ARCHIVED','2022-06-08 10:45:01',0),
('2022_06_09_00_auth.sql','29C2A4209FB977373440666F00B2E04F0E095247','ARCHIVED','2022-06-09 18:31:38',0),
('2022_06_15_00_auth.sql','137223C2750CC3559EFE11AFF1A780D5DA070193','ARCHIVED','2022-06-15 11:16:51',0),
('2022_06_18_00_auth.sql','63B75F9D79D83581AB3257C9EF86EDB626D8FDDA','ARCHIVED','2022-06-18 11:48:42',0),
('2022_06_27_00_auth.sql','CF613CCAAF8B6F08AAE1C48DBC4AF4D224291D8D','ARCHIVED','2022-06-27 21:13:58',0),
('2022_07_23_00_auth.sql','FEA7A8DA363F097A090F3BB39401C3FD7AE8E9B5','ARCHIVED','2022-07-25 18:40:38',0),
('2022_07_25_00_auth.sql','8F5BA8F7E010EDCA70F49FDE947B2F89476A2F95','ARCHIVED','2022-07-25 18:44:10',0),
('2022_08_02_00_auth.sql','4B97D20928B05086C7863497F4DDD408A51619BE','ARCHIVED','2022-08-02 18:28:31',0),
('2022_08_17_00_auth.sql','1A45DAE660690A7F4D0822C514116BF44A3185BB','ARCHIVED','2022-08-17 10:16:00',0),
('2022_08_19_00_auth.sql','332E7CC2E69D69BF274E5C61768FB80D1C217BDB','ARCHIVED','2022-08-19 09:52:06',0),
('2022_08_19_01_auth.sql','8B32826AE09C27B98C9480EF4D61205666F68318','ARCHIVED','2022-08-19 23:43:01',0),
('2022_08_21_00_auth.sql','5DEC0CB848F99D575B90356D82276749F2473B72','ARCHIVED','2022-08-21 00:02:03',0),
('2022_09_02_00_auth.sql','E2ED8B4B90829CFD283C9679AE265A9C9B2CF762','ARCHIVED','2022-09-02 15:52:22',0),
('2022_09_08_00_auth.sql','20B4503E316E042432AC25F7CEE9DCD9EDC631C6','ARCHIVED','2022-09-08 15:38:35',0),
('2022_09_23_00_auth.sql','F7DB1B903982D99295BC0D7D2BC205C5A2145F03','ARCHIVED','2022-09-23 03:44:55',0),
('2022_10_03_00_auth.sql','B956A37F71B42EB0289C2066A15D1F6C02F21E5A','ARCHIVED','2022-10-03 21:32:38',0),
('2022_11_20_00_auth.sql','37123D83589CFD96472D9187799C1F3FD67645DD','ARCHIVED','2022-11-20 11:05:20',0),
('2022_12_16_00_auth.sql','249B00480ACC8B67C908435748C202D8363C6EDE','ARCHIVED','2022-12-16 22:39:07',0),
('2022_12_17_00_auth.sql','0D3963AC2DBF74A4C8B88EA4A680C046FCCF8E70','ARCHIVED','2022-12-17 07:34:53',0),
('2022_12_17_01_auth.sql','5D1E2EA3C3CE087F7FB647CD0DE000979961863C','ARCHIVED','2022-12-17 13:09:19',0),
('2022_12_20_00_auth.sql','BA88146743B060A14937688C0DB94BF11C6CF1BA','ARCHIVED','2022-12-20 03:10:07',0),
('2022_12_21_00_auth.sql','B395CAE993D65E035AA621941D4C384E2E2E7DF5','ARCHIVED','2022-12-21 01:16:56',0),
('2022_12_22_00_auth.sql','BBF3CDD7927520F0381ECEF1F30152CBD5344D6A','ARCHIVED','2022-12-22 16:35:36',0),
('2023_01_17_00_auth.sql','EAEA99DF10DCC648C161D836FFA681D5B0F4CDC3','ARCHIVED','2023-01-17 18:41:32',0),
('2023_01_28_00_auth.sql','94A640018494B9203100178EC67A582987456B8B','ARCHIVED','2023-01-28 00:11:59',0),
('2023_01_28_01_auth.sql','4BDA614300858ADE6D58A119680724D867B0A355','ARCHIVED','2023-01-28 16:39:41',0),
('2023_02_01_00_auth.sql','9C1FB6820EF3A543AB7DE2E2913014AFF445F91E','ARCHIVED','2023-02-01 10:10:30',0),
('2023_02_02_00_auth.sql','8AC163759C83D887D5D7A48CFB8272FFBA71B801','ARCHIVED','2023-02-02 10:44:28',0),
('2023_02_03_00_auth.sql','0309A99757DE1FAE595C6C32586B2B8F8CA4C134','ARCHIVED','2023-02-03 01:13:52',0),
('2023_02_07_00_auth.sql','92D6C7A47B2F98ED93D62F6B7293D604C8F6BE16','ARCHIVED','2023-02-07 10:39:13',0),
('2023_02_09_00_auth.sql','F4B797776CA62D9A048D231C8117D51AA312932C','ARCHIVED','2023-02-09 00:19:27',0),
('2023_02_14_00_auth.sql','033F4460715121A8B6E9DD0F7456AE930DD18A7A','ARCHIVED','2023-02-14 10:02:49',0),
('2023_02_28_00_auth.sql','F57F70D6E1BBB1CB799E338C3358C265FD7F8689','ARCHIVED','2023-02-28 21:32:14',0),
('2023_03_08_00_auth.sql','2490CEA2EBDB0ECD3590F1D9328DD88266E179F3','ARCHIVED','2023-03-08 21:58:27',0),
('2023_03_11_00_auth.sql','6532C5E043692E7361689090DA19E6350705B591','ARCHIVED','2023-03-11 00:10:17',0),
('2023_03_22_00_auth.sql','C589D68CF88A62E03F2E797E03CF2F237371BD34','ARCHIVED','2023-03-21 18:12:28',0),
('2023_03_27_00_auth.sql','25B04268224275D0A90EF13E62460CBF61B90CEF','ARCHIVED','2023-03-27 21:22:59',0),
('2023_03_31_00_auth.sql','3F8CB31A261BCFE5C9A08B12945221CAA652AB24','ARCHIVED','2023-03-31 11:15:43',0),
('2023_03_31_01_auth.sql','A70E14B46537BC9208663B94EDF6CE51CB1B23BA','ARCHIVED','2023-03-31 23:16:09',0),
('2023_04_02_00_auth.sql','0238E0CE22D6422B19F648D026349A018CD4DB04','ARCHIVED','2023-04-02 01:02:26',0),
('2023_04_05_00_auth.sql','67317FC9DAA66EBF68468E60F99E1F6DD5B237E8','ARCHIVED','2023-04-05 10:39:51',0),
('2023_04_06_00_auth.sql','FECA06F32D077B1660D9FF8204D94F5C8E4065B4','ARCHIVED','2023-04-06 04:18:58',0),
('2023_04_12_00_auth.sql','E28F892FCC2A923683E5EEE24E98C618A9534318','ARCHIVED','2023-04-12 00:26:10',0),
('2023_04_25_00_auth.sql','AF297F37715F4A4C84E84182358C26CA83B0C655','ARCHIVED','2023-04-25 11:14:36',0),
('2023_04_28_00_auth.sql','779248686CB60F21CA7E9514E33B2D3E37C91B9E','ARCHIVED','2023-07-14 08:19:57',0),
('2023_05_04_00_auth.sql','1015EC7619C1F43B9FD70C8971F883D0CBF4D002','ARCHIVED','2023-05-04 16:02:32',0),
('2023_05_05_00_auth.sql','C0F435B417D238619DC390F52B27BA0E08DDE2CF','ARCHIVED','2023-05-05 00:55:38',0),
('2023_05_09_00_auth.sql','E14DC7567533284034ADCD74ED99486A4AD331AE','ARCHIVED','2023-05-09 01:07:29',0),
('2023_05_15_00_auth.sql','B2A9E5D5ECDC04C44136B4BAC7350AAF1522E916','ARCHIVED','2023-05-15 00:36:20',0),
('2023_05_23_00_auth.sql','C58C31ABA0AF08508B1946143746C44FB6ACB824','ARCHIVED','2023-05-23 09:23:42',0),
('2023_05_25_00_auth.sql','52C460A556EE08EF149E55E021AF0A9B5EC9AE13','ARCHIVED','2023-05-25 00:34:18',0),
('2023_05_27_00_auth.sql','C7B7718915274FC21BAE243D42D7419F67F93792','ARCHIVED','2023-05-27 12:10:20',0),
('2023_06_06_00_auth.sql','F327269C75DF6D09B3D7B33137681E0C1188120A','ARCHIVED','2023-06-06 00:50:17',0),
('2023_06_12_00_auth.sql','5BEE858205C3EDE75C5A5A1E46FBEE2257F97B83','ARCHIVED','2023-06-12 23:47:51',0),
('2023_07_12_00_auth.sql','E610FC5F0B1079070F69B5AAA6D6BDA5630B081F','ARCHIVED','2023-07-12 11:21:50',0),
('2023_07_13_00_auth.sql','BF718B6F8F2A324092D95BC1370120F0EE699BD2','ARCHIVED','2023-07-13 19:53:43',0),
('2023_07_14_00_auth.sql','B66CDB7EE7E554992BB2A9DAB3C16122411C81DF','ARCHIVED','2023-07-14 08:24:44',0),
('2023_07_14_01_auth.sql','8037C5101A08824DA6FE6B16E0004704DFC5B8FA','ARCHIVED','2023-07-14 19:35:41',0),
('2023_07_15_00_auth.sql','89D51F3E0EAAA957A7C0E4A4A7812505F61F12E6','ARCHIVED','2023-07-15 00:15:31',0),
('2023_07_19_00_auth.sql','8FE0EAB6C8DA5B060E95A9715F3D374340E361DD','ARCHIVED','2023-07-19 19:31:35',0),
('2023_07_22_00_auth.sql','38BDC8DE5697366E26588552830E34E420861008','ARCHIVED','2023-07-22 13:57:13',0),
('2023_07_28_00_auth.sql','1CC6C4E639ED9FD2EABFD0713C4D809C707E5E3F','ARCHIVED','2023-07-28 20:03:06',0),
('2023_08_03_00_auth.sql','57B92FF9D84AFE5F37A533F8F7187E26A708D8EE','ARCHIVED','2023-08-03 22:49:11',0),
('2023_08_09_00_auth.sql','3A0B9E91EB66D237785CD3F3CDFE5A6EAB33578E','ARCHIVED','2023-08-09 10:01:04',0),
('2023_08_31_00_auth.sql','3A2242F0755CCC7658F458847B12E308FE75A314','ARCHIVED','2023-08-31 19:06:27',0),
('2023_09_07_00_auth.sql','9127F7B6723477DE25886D451FE174ABF2039B94','ARCHIVED','2023-09-07 00:30:01',0),
('2023_09_08_00_auth.sql','AA4E52CC2344F503151C88284807E8B7319B7C69','ARCHIVED','2023-09-08 21:46:01',0),
('2023_09_13_00_auth.sql','49C44AE960C71C71DC9966D10D8DAA127976D22B','ARCHIVED','2023-09-13 00:30:28',0),
('2023_09_20_00_auth.sql','6B3EAEB21A617564907EE843FC43272F0C020760','ARCHIVED','2023-09-20 04:49:35',0),
('2023_09_23_00_auth.sql','B6250AE892CF5988FD4EB08EC35DE25096B52115','ARCHIVED','2023-09-23 01:57:24',0),
('2023_09_28_00_auth.sql','E69955264CD347921DDD1B52BC31E8C39EC41B21','ARCHIVED','2023-09-28 05:36:07',0),
('2023_10_06_00_auth.sql','3480687DEEB3E12ECC9632809A518425F9FA0FCC','ARCHIVED','2023-10-06 00:40:46',0),
('2023_10_17_00_auth.sql','EE4C430E9535EC3466E4D2FABA7F009F87AF18BD','ARCHIVED','2023-10-17 21:07:51',0),
('2023_10_25_00_auth.sql','86B16D5D78A8ED31FDD8553D223CF56F013B00DB','ARCHIVED','2023-10-25 00:06:14',0),
('2023_11_01_00_auth.sql','4EA6010E9035AFC80326FE56C642C7918254F2BE','ARCHIVED','2023-11-01 10:47:18',0),
('2023_11_09_00_auth.sql','C8A9223E6868593904634193ACBD421F40078FE5','ARCHIVED','2023-11-09 00:53:45',0),
('2023_11_09_01_auth.sql','BC9BC28D41608A78166B5A38F3A7F598FBDB879D','ARCHIVED','2023-11-09 18:21:59',0),
('2023_11_14_00_auth.sql','192D729737C5E3332D7B5B9B7F9DBDD9626D7B98','ARCHIVED','2023-11-14 11:36:05',0),
('2023_11_15_00_auth.sql','85CE6DCBE9391F0FB3819C7579067E2775D7C20E','ARCHIVED','2023-11-15 00:48:07',0),
('2023_11_15_01_auth.sql','622218EB74372055943D7B62AD30B52F959CC94B','ARCHIVED','2023-11-15 00:53:47',0),
('2023_11_16_00_auth.sql','2EF3FE83B74EFC10B8536E2EB6AFAE7074FC59BD','ARCHIVED','2023-11-16 23:19:09',0),
('2023_11_21_00_auth.sql','146E5E6EF94C5DB78343372A8FDB32B062B80040','ARCHIVED','2023-11-21 11:24:11',0),
('2023_11_24_00_auth.sql','AC1B5136CC97264A21933BD1074D02E88D819488','ARCHIVED','2023-11-24 19:37:38',0),
('2023_11_30_00_auth.sql','49E92311D7373965320CCEE3720D4EF9F1A28F97','ARCHIVED','2023-11-30 13:39:17',0),
('2023_12_05_00_auth.sql','25DC15C708E6A962DC322293D0CE5D52941F560A','ARCHIVED','2023-12-05 16:18:14',0),
('2023_12_12_00_auth.sql','EDC092787956178A08D15B9245EE4716ED0847B0','ARCHIVED','2023-12-12 05:47:47',0),
('2023_12_13_00_auth.sql','C3D6AA45BECD5A7F8A420FE0022AAF6A349C5E3F','ARCHIVED','2023-12-13 06:42:48',0),
('2023_12_19_00_auth.sql','EDC1C8E58EEF18F952A3509D40D27E17CAC49563','ARCHIVED','2024-02-08 00:48:00',0),
('2023_12_21_00_auth.sql','DB294EF35C00AA92C79786F7A0BFBCE739D4E193','ARCHIVED','2023-12-21 09:08:30',0),
('2023_12_24_00_auth.sql','F59B3A895750FD83177324B89BFCEBD8A43DD577','ARCHIVED','2023-12-24 06:24:58',0),
('2023_12_26_00_auth.sql','5C8716F7F6E2792E15A42BDA8F2D855A7DE95FC5','ARCHIVED','2023-12-26 13:38:58',0),
('2024_01_05_00_auth.sql','7F401D473B08BBE5212551E96A86F85107CE7C8E','ARCHIVED','2023-12-19 10:05:39',0),
('2024_01_10_00_auth.sql','75F06894D95986AEAB2933F141DB7693FABB0324','ARCHIVED','2024-01-10 11:14:55',0),
('2024_01_21_00_auth.sql','5F12B88EAADC5390AD42843290BD13CEF3BF2E0B','ARCHIVED','2024-01-21 21:21:50',0),
('2024_01_23_00_auth.sql','55E3C2CC1FAF02916EB47711CD2278443F7AA183','ARCHIVED','2024-01-23 09:40:35',0),
('2024_01_31_00_auth.sql','7328692BBD9B455D51ABE90B9C6571EA889EE26F','ARCHIVED','2024-01-31 11:58:00',0),
('2024_02_01_00_auth.sql','1822B9B3E28AB0E77CF253C6A96F78EB5020447A','ARCHIVED','2024-02-01 10:46:27',0),
('2024_02_07_00_auth.sql','F6A65673A7020B4C64083AFC1CAD4206BC960170','ARCHIVED','2024-02-07 12:26:24',0),
('2024_02_08_00_auth.sql','E62D51C3D536FDF79EBEDFE060EB9D232ACE1EDD','ARCHIVED','2024-02-08 00:56:26',0),
('2024_02_08_01_auth.sql','9972EE1527DFC182527FA3C1AC086B189574BDF0','ARCHIVED','2024-02-08 22:32:41',0),
('2024_02_24_00_auth.sql','BEB6F94703C4574088289DFFC8E7660D223E2841','ARCHIVED','2024-02-24 00:27:13',0),
('2024_03_05_00_auth.sql','61341FABF7243FBCBB6BDE35CECE1F7DFD988F26','ARCHIVED','2024-03-05 20:43:51',0),
('2024_03_21_00_auth.sql','5D4F3479B0F4E16E59B1CC9EB21E5CE5531555B9','ARCHIVED','2024-03-21 16:56:21',0),
('2024_03_22_00_auth.sql','4F184E4BF361195C560A569E57A6FF6429077849','ARCHIVED','2024-03-22 20:29:29',0),
('2024_03_25_00_auth.sql','B4EF57DE84195E0B886B070ACE58B66853FFC52C','ARCHIVED','2024-03-25 23:20:57',0),
('2024_03_29_00_auth.sql','F1F62C913F5DFB277DB3D1258022EC334EFC419B','ARCHIVED','2024-03-29 10:49:54',0),
('2024_04_08_00_auth.sql','B05516DB306A06982206180A2A18407D9E0012DE','ARCHIVED','2024-04-08 21:56:33',0),
('2024_04_12_00_auth.sql','3D2DCEA21AE5104EF192CACAAFBB5131AD355791','ARCHIVED','2024-04-12 12:07:49',0),
('2024_04_22_00_auth.sql','83566EA54235D588697D747D8130CD6D37445CC5','ARCHIVED','2024-04-22 23:05:46',0),
('2024_05_01_00_auth.sql','2A1C2B4E54706BDD1FDD57AFB943058BEE8D8852','ARCHIVED','2024-05-01 21:32:43',0),
('2024_05_08_00_auth.sql','F2EEE0D225CB82DBB3A478E0BF6A0116C9265355','ARCHIVED','2024-05-08 20:35:53',0),
('2024_05_10_00_auth.sql','8A6E48012413EA769601A8E4C9F82BEFBE1FCA5C','ARCHIVED','2024-05-10 00:50:46',0),
('2024_05_11_00_auth.sql','8D703BE97247DBC4A4935EAEA9CB681B0EEFBB3C','ARCHIVED','2024-05-11 03:06:52',0),
('2024_05_14_00_auth.sql','C36612C0215E255E1D4917876FD52C8F1F9BCDA7','ARCHIVED','2024-05-14 03:39:01',0),
('2024_05_16_00_auth.sql','5980F77073B6AD55ABCF0F9735408A4F35C97159','ARCHIVED','2024-05-16 08:13:11',0),
('2024_05_17_00_auth.sql','E02B96055C887BED76442B2C3C49C51659BCC602','ARCHIVED','2024-05-17 14:24:15',0),
('2024_05_18_00_auth.sql','C3392BDA5AAC304AD72BAC631DA1C9802D20EDAC','ARCHIVED','2024-05-18 01:52:01',0),
('2024_05_25_00_auth.sql','A34E299F5D75535D17C6295023910539897D1392','ARCHIVED','2024-05-25 12:10:08',0),
('2024_05_29_00_auth.sql','6F42C6565CB748E3C1231F4EA0A6D04F2F95C0A3','ARCHIVED','2024-05-29 19:12:53',0),
('2024_06_05_00_auth.sql','B6306773C94879872E0B3FDAFE12ECDEA4C9264F','ARCHIVED','2024-06-05 09:37:55',0),
('2024_06_15_00_auth.sql','FDF2F29F5AB0213C9C2AB937852F0BAE552CFDCE','ARCHIVED','2024-06-15 00:01:40',0),
('2024_06_17_00_auth.sql','3781820B8F3B238F89BC8E83EC164B767A63BBB3','ARCHIVED','2024-06-17 22:34:47',0),
('2024_06_26_00_auth.sql','428762D840B37F2569FC477E0B5B452C7E98B301','ARCHIVED','2024-06-26 13:59:17',0),
('2024_07_09_00_auth.sql','C58A8D47CAFA34055EEB079E72AA820EF7C55368','ARCHIVED','2024-07-09 12:00:23',0),
('2024_07_16_00_auth.sql','4161C07EACA71CE3D0269D2067563594D26DEC27','ARCHIVED','2024-07-16 19:02:24',0),
('2024_08_02_00_auth.sql','6BE2A6DA2F2BE21B18396F120427E973F1CAA58F','ARCHIVED','2024-08-02 00:45:10',0),
('2024_08_07_00_auth.sql','88070C3A95DE7242B3E3662D7B5B9648128DC187','ARCHIVED','2024-08-07 01:06:23',0),
('2024_08_09_00_auth.sql','854C24AAF0B3F673DAD8C0F3059DB266B0F34488','ARCHIVED','2024-08-09 15:40:42',0),
('2024_08_15_00_auth.sql','06E9AD907DC2B2CC0CF78414AB516BBA3ED0CE65','ARCHIVED','2024-08-15 19:40:50',0),
('2024_08_17_00_auth.sql','3584B5A910334447D6E948DBAA0EEC43C42FE631','ARCHIVED','2024-08-17 15:17:22',0),
('2024_08_18_00_auth.sql','5C1D0A3FE0245F4030FE446288AE533556EC6C9E','ARCHIVED','2024-08-17 23:01:21',0),
('2024_08_21_00_auth.sql','6F2844107F0501E7631C8196CC04E75853381319','ARCHIVED','2024-08-21 15:25:46',0),
('2024_08_22_00_auth.sql','D5466F5E9D1475323ED90553361D7F7B4CF83BF7','ARCHIVED','2024-08-22 23:35:36',0),
('2024_08_23_00_auth.sql','A591DA576EAEA3F48AB9E8269A2E4071B2C3C930','ARCHIVED','2024-08-23 17:35:52',0),
('2024_08_23_01_auth.sql','1ABD54E76B2D6712BF3DE06DD60A18C38BCF9CF1','ARCHIVED','2024-08-23 19:59:36',0),
('2024_08_24_00_auth.sql','6D2CE419F8E8512051B63D0F68B30BAA769F9D4A','ARCHIVED','2024-08-24 10:23:33',0),
('2024_08_28_00_auth.sql','F39CA1C18CAC207418C3D3703DA0F038471D308A','ARCHIVED','2024-08-28 10:50:31',0),
('2024_08_28_01_auth.sql','BC5D74553AF2D92606F55C1C462D2700FE73BD34','ARCHIVED','2024-08-28 14:55:05',0),
('2024_08_30_00_auth.sql','BD76942F1C29AAA2450E051E7CA552672B5E331B','ARCHIVED','2024-08-30 19:24:30',0),
('2024_08_30_01_auth.sql','0AAC95A9216114177AF0A3A7DE664D061FED21EA','ARCHIVED','2024-08-30 22:23:08',0),
('2024_08_31_00_auth.sql','D10F12D25D526A2C5E12FCEA2DEB55C342879F06','ARCHIVED','2024-08-31 10:32:16',0),
('2024_08_31_01_auth.sql','3ADC34DAE405697983EDDD32D0F3FC6F122CA819','ARCHIVED','2024-09-01 15:48:43',0),
('2024_09_03_00_auth.sql','BF65B550256CA64F0936D98A619E8A2A7E7A9B59','ARCHIVED','2024-09-03 00:47:42',0),
('2024_09_05_00_auth.sql','9CD84EB94AE50F14A392C216E7CA7BA33E92376E','ARCHIVED','2024-09-05 13:38:34',0),
('2024_09_05_01_auth.sql','42D5E703382C57C4ADD862CF215F1166625100E5','ARCHIVED','2024-09-05 23:42:10',0),
('2024_09_11_00_auth.sql','8B810B5EB20D769A50A2D01411BBD065732E4EE6','ARCHIVED','2024-09-11 12:23:18',0),
('2024_09_18_00_auth.sql','073B6E954B585CD81BFADD58CDAD166E85D2653A','ARCHIVED','2024-09-18 10:26:42',0),
('2024_09_18_01_auth.sql','6AE1437E24D4837EB2347ADAA80A4093CA9F6D67','ARCHIVED','2024-09-18 21:30:31',0),
('2024_09_23_00_auth.sql','CBAB00B40360D8942AD1E4EDBE0F0097F3F6FC9B','ARCHIVED','2024-09-23 22:48:10',0),
('2024_09_26_00_auth.sql','E37C3997FD7851EA360774AC568912846C448272','ARCHIVED','2024-09-26 18:27:26',0),
('2024_10_01_00_auth.sql','665EC51B03F52C373F713D96A1426054D7DF98C8','ARCHIVED','2024-10-01 23:39:44',0),
('2024_10_23_00_auth.sql','78203AE9051E866F103CC7B8A6EE09D5C25BCB9A','ARCHIVED','2024-10-23 15:48:13',0),
('2024_10_23_01_auth.sql','06257BB5FF23564549529C14822DD5780AA7F7C3','ARCHIVED','2024-10-23 22:30:54',0),
('2024_10_30_00_auth.sql','B4C930B0CE499704CEBF208A71871061DC27008C','ARCHIVED','2024-10-30 13:04:40',0),
('2024_11_01_00_auth.sql','62EF7FC9CD2DCD8D24CE1BCED3BF9E2917B6674B','ARCHIVED','2024-11-01 13:26:56',0),
('2024_11_11_00_auth.sql','F47CDFB857DB4105306739AF4FBBB3C92CA43363','ARCHIVED','2024-11-11 13:34:09',0),
('2024_11_12_00_auth.sql','5A236A557291758C0F2C46FDEC02692E7C53F751','ARCHIVED','2024-11-12 11:42:13',0),
('2024_11_14_00_auth.sql','646A438FAD5A83D80DCDDEDC71BB6CF21A1FE490','ARCHIVED','2024-11-14 10:29:52',0),
('2024_11_16_00_auth.sql','94794542B3320D76E4A3615DB2418EEF38BDFEA1','ARCHIVED','2024-11-16 21:57:39',0),
('2024_11_20_00_auth.sql','444C765DD16E9B70C1D1163155238E8EE481B17D','ARCHIVED','2024-11-20 20:39:53',0),
('2024_12_18_00_auth.sql','1F3145F30A79FEE13F5CD9817F54FAFA9A85DEE6','ARCHIVED','2024-12-18 22:04:44',0),
('2024_12_19_00_auth.sql','B01D54F8420CF680F0DDA903210028F0174E310D','ARCHIVED','2024-12-19 11:32:53',0),
('2024_12_21_00_auth.sql','9DA5E7911D231D46FE9630D20BDD4AEA0B3CF650','ARCHIVED','2024-12-21 01:03:37',0),
('2024_12_22_00_auth.sql','6FDF0ABE9952CC96BE04A6BAA0F1161900B4AB88','ARCHIVED','2024-12-22 02:56:17',0),
('2025_01_11_00_auth.sql','B32F963095657E8877F3C1EEBB09C8AED55EEECC','ARCHIVED','2025-01-11 10:51:47',0),
('2025_01_15_00_auth.sql','8EA1C0A88F6F1EC3DA67DA01CDCF056A530DBB5F','ARCHIVED','2025-01-15 00:44:53',0),
('2025_01_15_01_auth.sql','885A553B190CCD7A22791AF4EC3BC15C43DDC2D2','ARCHIVED','2025-01-15 10:27:39',0),
('2025_01_22_00_auth.sql','E08C40B02DB391DC1A478B6C714FDDDDB144F24F','ARCHIVED','2025-01-22 20:58:45',0),
('2025_01_29_00_auth.sql','7334CFE779D5F79AFAC8EA269950FC07E625810F','ARCHIVED','2025-01-29 12:57:32',0),
('2025_01_31_00_auth.sql','DF2640D25C15E41358C1ED46B4F86043583FC8FB','ARCHIVED','2025-01-31 11:51:23',0),
('2025_02_03_00_auth.sql','87033116EF72051499AF23FE14545D828F5A9B59','ARCHIVED','2025-02-03 22:51:31',0),
('2025_02_19_00_auth.sql','6D0EBB3E2DD1B26682A424EDDC090F515BCA5B32','ARCHIVED','2025-02-19 00:16:52',0),
('2025_02_21_00_auth.sql','E9EA49CEB396561D641A7C82251DCBF9DF3E9983','ARCHIVED','2025-02-21 00:53:17',0),
('2025_03_02_00_auth.sql','1CEAB7B308823D5FAA51360A1B2A7CA0E89A6081','ARCHIVED','2025-03-02 14:50:10',0),
('2025_03_04_00_auth.sql','AB20016BC7251E6DE80E2AC658F18F6076EA81AA','ARCHIVED','2025-03-04 20:01:43',0),
('2025_03_05_00_auth.sql','25DA7985BDEA177E1AE7C8DC82063D1C11F7BF92','ARCHIVED','2025-03-05 11:20:32',0),
('2025_03_08_00_auth.sql','DA9CEE1C87F8A1CF7FFDF684FD7DDFCC7B04D5AE','ARCHIVED','2025-03-08 01:37:14',0),
('2025_03_13_00_auth.sql','942D432EBC68783F76FF3A3CBE6F1FAF32121D18','ARCHIVED','2025-03-13 19:58:25',0),
('2025_03_26_00_auth.sql','AACB673BEED68EADC53D121E107E1C780DFE0B88','ARCHIVED','2025-03-26 10:32:59',0),
('2025_03_29_00_auth.sql','AB55F260FB970455392E1FD4D760965EE48F7074','ARCHIVED','2025-03-29 01:12:13',0),
('2025_03_31_00_auth.sql','0522AF5AE6CE2B2EB14265CC005CC209DB4834C0','ARCHIVED','2025-03-31 21:19:14',0),
('2025_04_09_00_auth.sql','7543CD6152ABDA64B5FC75FC28211A54F16B9E40','ARCHIVED','2025-04-09 10:06:12',0),
('2025_04_10_00_auth.sql','93EBDB49570AFD980449CE6858AFA588ED763FAB','ARCHIVED','2025-04-10 20:45:44',0),
('2025_04_12_00_auth.sql','A33D1A1E50EA4B6E93DD6BAB5AD624EDAEC39BDF','ARCHIVED','2025-04-12 00:54:47',0),
('2025_04_25_00_auth.sql','CD64B1560DE7A3715B561FC4E712C5E61C126A1D','ARCHIVED','2025-04-25 19:43:41',0),
('2025_04_30_00_auth.sql','B8708581D23575920082C18665E828C629F07DED','ARCHIVED','2025-04-30 13:15:42',0),
('2025_05_14_00_auth.sql','E4C40DFB18415ADB60223BA7518A2F0FCD491712','ARCHIVED','2025-05-14 10:24:56',0),
('2025_05_30_00_auth.sql','37191DD7967326918A3BE9EB919CEECBA42098A2','ARCHIVED','2025-05-30 11:42:16',0),
('2025_05_31_00_auth.sql','5EF8B1EBE4CF99E5D1C02BD6141FB35EA19FED6C','ARCHIVED','2025-05-31 19:45:56',0),
('2025_06_03_00_auth.sql','2ADB0D37ED7223C2EA94497B0F7B7C0BF91A72B8','ARCHIVED','2025-06-03 01:11:51',0),
('2025_06_05_00_auth.sql','E40328A6899D04BCDB6A36337BD243837AF92205','ARCHIVED','2025-06-05 00:26:43',0),
('2025_06_05_02_auth.sql','C2B67F688AC54CF6994F4709D0ECE692C968F346','ARCHIVED','2025-06-05 16:22:53',0),
('2025_06_18_00_auth.sql','AB5F6069BD37C93050022700F1C4B814D9D139C1','ARCHIVED','2025-06-17 23:13:05',0),
('2025_06_19_00_auth.sql','1C0ACAEEFC934F91F44C113E6CD9D7A40ED1C979','ARCHIVED','2025-06-18 22:51:15',0),
('2025_06_25_00_auth.sql','27DC7FB423FFB3788082CCFC18D5432650B09FB3','ARCHIVED','2025-06-25 01:15:04',0),
('2025_06_27_00_auth.sql','243C89DFED0058323EF9690D124C1F20036D461B','ARCHIVED','2025-06-27 14:22:49',0),
('2025_07_14_00_auth.sql','5F975A202CF84F2BFEA366E0BEDF8FA63035CD62','ARCHIVED','2025-07-14 23:10:54',0),
('2025_07_21_00_auth.sql','44AA781EE1B1C66E8433E50A2E20916EB1BEFE23','ARCHIVED','2025-07-21 22:51:05',0),
('2025_08_13_00_auth.sql','5F67141AB407AEC202E8048765256AB11C5621EA','ARCHIVED','2025-08-12 19:26:13',0),
('2025_08_16_00_auth.sql','DCAB779D0FC212FDF964D055BEC17AC1255A013C','ARCHIVED','2025-08-16 14:58:22',0),
('2025_08_19_00_auth.sql','A6FCCF57663965E7DDA3796C8C202D4AEBF5C76D','ARCHIVED','2025-08-19 22:09:06',0),
('2025_08_20_00_auth.sql','88263DAF5D8BF6B2B8F9D279135B9747E4931B51','ARCHIVED','2025-08-20 21:27:33',0),
('2025_08_23_00_auth.sql','4C543EB13488D5885EB41DBC1DF036125C92D999','ARCHIVED','2025-08-23 14:43:33',0),
('2025_08_27_00_auth.sql','E7F59ADBE2F6534B226990267061AEFBFA3843FB','ARCHIVED','2025-08-27 10:16:36',0),
('2025_08_29_00_auth.sql','222F1E2DE1D898F9A580E94574681B59D40E0402','ARCHIVED','2025-08-29 10:36:07',0),
('2025_09_03_00_auth.sql','E32EA92D13EBDB5A6DF5101BDA89D89B782EBBAA','ARCHIVED','2025-09-03 20:30:58',0),
('2025_09_04_00_auth.sql','B002D8EC5D883576ECC575DC545881837AB66FD3','ARCHIVED','2025-09-04 21:43:14',0),
('2025_09_12_00_auth.sql','B95D44F12BA980040BAEB982B01D359B55C2EA2B','ARCHIVED','2025-09-12 23:13:31',0),
('2025_09_20_00_auth.sql','752B003BBEBDDD3E1BBFB342AD154EB50D5E6DC9','ARCHIVED','2025-09-20 01:31:35',0),
('2025_10_10_00_auth.sql','D2CCA4D100F71481C1AD347EE00D025BF873B2F2','ARCHIVED','2025-10-10 00:02:43',0),
('2025_10_11_00_auth.sql','9D39A17F4B14666677A409232A73986076FC4108','ARCHIVED','2025-10-11 12:34:55',0),
('2025_10_15_00_auth.sql','AD32FF4A48BFC671ED2F17409D4283E2CD3577E1','ARCHIVED','2025-10-15 09:56:37',0),
('2025_10_22_00_auth.sql','A363CDF2B9EDED18DA077351CB2B0DC3A9E5E752','ARCHIVED','2025-10-22 10:32:36',0),
('2025_10_29_00_auth.sql','CA6DC3F6A070AD894AB0DF2B21168D1BD7445A38','RELEASED','2025-10-29 06:57:00',0),
('2025_10_30_00_auth.sql','BEBD6BC06B857C182BAD8A0DCAAF5B6AFEA2DFE7','RELEASED','2025-10-30 18:24:07',0);
/*!40000 ALTER TABLE `updates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `updates_include`
--

DROP TABLE IF EXISTS `updates_include`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `updates_include` (
  `path` varchar(200) NOT NULL COMMENT 'directory to include. $ means relative to the source directory.',
  `state` enum('RELEASED','ARCHIVED') NOT NULL DEFAULT 'RELEASED' COMMENT 'defines if the directory contains released or archived updates.',
  PRIMARY KEY (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='List of directories where we want to include sql updates.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updates_include`
--

LOCK TABLES `updates_include` WRITE;
/*!40000 ALTER TABLE `updates_include` DISABLE KEYS */;
INSERT INTO `updates_include` VALUES
('$/sql/custom/auth','RELEASED'),
('$/sql/old/10.x/auth','ARCHIVED'),
('$/sql/old/11.x/auth','ARCHIVED'),
('$/sql/old/6.x/auth','ARCHIVED'),
('$/sql/old/7/auth','ARCHIVED'),
('$/sql/old/8.x/auth','ARCHIVED'),
('$/sql/old/9.x/auth','ARCHIVED'),
('$/sql/updates/auth','RELEASED');
/*!40000 ALTER TABLE `updates_include` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uptime`
--

DROP TABLE IF EXISTS `uptime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `uptime` (
  `realmid` int(10) unsigned NOT NULL,
  `starttime` int(10) unsigned NOT NULL DEFAULT 0,
  `uptime` int(10) unsigned NOT NULL DEFAULT 0,
  `maxplayers` smallint(5) unsigned NOT NULL DEFAULT 0,
  `revision` varchar(255) NOT NULL DEFAULT 'Trinitycore',
  PRIMARY KEY (`realmid`,`starttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Uptime system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uptime`
--

LOCK TABLES `uptime` WRITE;
/*!40000 ALTER TABLE `uptime` DISABLE KEYS */;
INSERT INTO `uptime` VALUES
(1,1762116652,0,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762119987,10221,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762130478,622,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762131280,1821,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762134912,0,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762218614,1824,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762220052,0,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762220815,626,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762221724,6025,1,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762238594,66105,1,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762304928,0,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762304952,47421,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762352894,1223,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762354294,0,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762354492,622,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762355571,0,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762355775,0,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762356349,1223,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762358179,20425,2,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762379153,10824,1,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762390669,1222,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762392065,1225,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762393497,9623,1,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762403269,0,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762403636,4825,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762408830,24026,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762433388,52225,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762487009,4226,0,'TrinityCore rev. dda7d3ead9e0+ 2025-10-30 18:25:38 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762632881,0,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762633213,0,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762633543,624,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762637590,0,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762639151,1826,1,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762641404,2424,2,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762643910,33626,3,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762701526,2425,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762704157,115827,1,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762820565,12625,2,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762833337,16826,3,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762868883,137427,1,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1762929038,0,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1763268532,24624,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1763294957,0,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)'),
(1,1763294996,9023,0,'TrinityCore rev. 6a767c3bd65f 2025-11-06 19:42:17 +0100 (master branch) (Linux, x86_64, RelWithDebInfo, Static)');
/*!40000 ALTER TABLE `uptime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `vw_log_history`
--

DROP TABLE IF EXISTS `vw_log_history`;
/*!50001 DROP VIEW IF EXISTS `vw_log_history`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vw_log_history` AS SELECT
 1 AS `First Logged`,
  1 AS `Last Logged`,
  1 AS `Occurrences`,
  1 AS `Realm`,
  1 AS `type`,
  1 AS `level`,
  1 AS `string` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_rbac`
--

DROP TABLE IF EXISTS `vw_rbac`;
/*!50001 DROP VIEW IF EXISTS `vw_rbac`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vw_rbac` AS SELECT
 1 AS `Permission ID`,
  1 AS `Permission Group`,
  1 AS `Security Level`,
  1 AS `Permission` */;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'auth'
--

--
-- Final view structure for view `vw_log_history`
--

/*!50001 DROP VIEW IF EXISTS `vw_log_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`trinity`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_log_history` AS select from_unixtime(min(`logs`.`time`)) AS `First Logged`,from_unixtime(max(`logs`.`time`)) AS `Last Logged`,count(0) AS `Occurrences`,`realmlist`.`name` AS `Realm`,`logs`.`type` AS `type`,`logs`.`level` AS `level`,`logs`.`string` AS `string` from (`logs` left join `realmlist` on(`logs`.`realm` = `realmlist`.`id`)) group by `logs`.`string`,`logs`.`type`,`logs`.`realm` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_rbac`
--

/*!50001 DROP VIEW IF EXISTS `vw_rbac`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`trinity`@`localhost` SQL SECURITY INVOKER */
/*!50001 VIEW `vw_rbac` AS select `t1`.`linkedId` AS `Permission ID`,`t1`.`id` AS `Permission Group`,ifnull(`t2`.`secId`,'linked') AS `Security Level`,`t3`.`name` AS `Permission` from ((`rbac_linked_permissions` `t1` left join `rbac_default_permissions` `t2` on(`t1`.`id` = `t2`.`permissionId`)) left join `rbac_permissions` `t3` on(`t1`.`linkedId` = `t3`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-17  7:36:07
