/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: characters
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
-- Table structure for table `account_data`
--

DROP TABLE IF EXISTS `account_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_data` (
  `accountId` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Account Identifier',
  `type` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `time` bigint(20) NOT NULL DEFAULT 0,
  `data` blob NOT NULL,
  PRIMARY KEY (`accountId`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_data`
--

LOCK TABLES `account_data` WRITE;
/*!40000 ALTER TABLE `account_data` DISABLE KEYS */;
INSERT INTO `account_data` VALUES
(2,0,1762826656,'SET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET wardrobeShowUncollected \"0\"\r\nSET profanityFilter \"0\"\r\nSET guildShowOffline \"0\"\r\nSET mountJournalGeneralFilters \"1\"\r\nSET alwaysShowActionBars \"1\"\r\nSET seenCharacterSelectAddGroupHelpTip \"1\"\r\nSET mountJournalTypeFilter \"31\"\r\nSET addFriendInfoShown \"1\"\r\nSET closedInfoFramesAccountWide \"R@A\"\r\nSET lootUnderMouse \"0\"\r\nSET actionedAdventureJournalEntries \"v\"\r\nSET perksActivitiesPendingCompletion \"v11#\'P#\'Q#\'R#(0\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET flaggedTutorials \"v11##C##G##_##Q##S##T##$##%##(##E##8##K##[##;##)##^##?##@##]##+##O##F##,##:##9##I##D##6##4##5##`##3##J##A##B##=##L##Y##0##V##<##N##-##.##\'##Z##H##>\"\r\nSET seenCharacterSelectNavBarCampsHelpTip \"1\"\r\nSET lastLockedDelvesCompanionAbilities \"107528 107529 107530 107531 107533 107535 107538 107541 107542 107543 107544 107545 107546 107547 107548 107549 107550 107552 107553 107554 107555 107556 107557 107558 107559 107560 107561 107562 107563 107564 107565 107566 107567 107568 107569 107570 107571 107572 \"\r\nSET playerColorOverrides \"v11\"\r\nSET mountJournalShowPlayer \"1\"\r\nSET petJournalFilters \"F\"\r\nSET timeMgrUseLocalTime \"1\"\r\nSET showNPETutorials \"0\"\r\nSET petJournalSort \"1\"\r\nSET AllowDangerousScripts \"1\"\r\nSET countdownForCooldowns \"1\"\r\nSET wardrobeSetsFilters \"B\"\r\n'),
(2,8,1762222427,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(2,10,1762222427,'2\0'),
(2,13,1762222427,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0\0'),
(3,0,1762642076,'SET cameraDistanceMaxZoomFactor \"2.6\"\r\nSET wholeChatWindowClickable \"0\"\r\nSET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET cameraPitchA \"39.299999\"\r\nSET profanityFilter \"0\"\r\nSET xpBarText \"1\"\r\nSET guildShowOffline \"0\"\r\nSET mountJournalGeneralFilters \"1\"\r\nSET perksActivitiesLastPoints \"650\"\r\nSET alwaysShowActionBars \"1\"\r\nSET lastRenownForMajorFaction2594 \"3\"\r\nSET seenCharacterSelectAddGroupHelpTip \"1\"\r\nSET lastRenownForDelvesSeason \"1\"\r\nSET mountJournalTypeFilter \"31\"\r\nSET autoQuestProgress \"0\"\r\nSET addFriendInfoShown \"1\"\r\nSET closedInfoFramesAccountWide \"Z{OB\"\r\nSET cameraDistanceA \"10.080000\"\r\nSET nameplateTargetRadialPosition \"1\"\r\nSET actionedAdventureJournalEntries \"v\"\r\nSET UnitNameFriendlySpecialNPCName \"0\"\r\nSET UnitNameOwn \"1\"\r\nSET chatStyle \"classic\"\r\nSET perksActivitiesPendingCompletion \"v11#\'N#\'P#\'Q#\'T#\'h#(0#*I#*J#*L#*N#*O#*T#*U#*X#*d#,5#,6#,7#,9#,A#,F\"\r\nSET combinedBags \"1\"\r\nSET statusTextDisplay \"BOTH\"\r\nSET VoicePushToTalkKeybind \"LCTRL\"\r\nSET VoiceCommunicationMode \"1\"\r\nSET showTutorials \"0\"\r\nSET lastSelectedDelvesTier \"4\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET flaggedTutorials \"v11##H##5##`##?##@##N##>##$##(##%##-##.##\'##Z##E##8##K##[##)##;##+##:##6##F##4##O##^##]##L##G##S##T##,##9\"\r\nSET seenCharacterSelectNavBarCampsHelpTip \"1\"\r\nSET lastRenownForMajorFaction2590 \"2\"\r\nSET lastLockedDelvesCompanionAbilities \"107528 107529 107530 107531 107533 107538 107542 107549 107553 107556 107563 107565 107570 107571 \"\r\nSET petJournalTab \"5\"\r\nSET Outline \"3\"\r\nSET showTargetOfTarget \"1\"\r\nSET playerColorOverrides \"v11\"\r\nSET cameraYawA \"21.825132\"\r\nSET toyBoxCollectedFilters \"B\"\r\nSET floatingCombatTextCombatDamage \"0\"\r\nSET showNPETutorials \"0\"\r\nSET UnitNameNPC \"1\"\r\nSET petJournalSort \"2\"\r\nSET countdownForCooldowns \"1\"\r\nSET statusText \"1\"\r\nSET threatShowNumeric \"1\"\r\nSET floatingCombatTextCombatHealing \"0\"\r\nSET whisperMode \"popout_and_inline\"\r\nSET wardrobeSetsFilters \"H\"\r\nSET perksActivitiesCurrentMonth \"24\"\r\n'),
(3,8,1762260959,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(3,10,1762259288,'2\0'),
(3,13,1762259288,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0\0'),
(8,0,1762399957,'SET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET closedInfoFramesAccountWide \"J@A\"\r\nSET perksActivitiesPendingCompletion \"v11\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET flaggedTutorials \"v11##$##4##:##E##%##(##K##8##[##)##;##+##,##?##@##F##D\"\r\nSET petJournalTab \"5\"\r\nSET playerColorOverrides \"v11\"\r\n'),
(8,8,1762363965,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(8,10,1762363965,'2\0'),
(8,13,1762363965,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 5 Natsu 43 0 0 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%(#,$ 0 2 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&(\'%(#,$ 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&(\'%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&(\'%(#,$ 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 1 -1 0 4 4 UIParent 0.0 6.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 1 8 7 UIParent -300.0 250.0 -1 $#3# 3 1 0 4 4 UIParent -410.7 -172.5 -1 %#3# 3 2 0 4 4 UIParent -224.7 -183.3 -1 %#&#3# 3 3 0 4 4 UIParent -630.5 -184.8 -1 \'#(#)#-#.#/#1$3# 3 4 0 7 1 TargetFrame -4.5 -14.0 -1 ,#-#.#/#0#1#2( 3 5 0 6 8 TalkingHeadFrame 4.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4$ 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 1 7 7 UIParent 0.0 45.0 -1 # 6 0 0 1 7 PlayerFrame -223.2 13.0 -1 ##$#%#&.(()( 6 1 0 7 7 UIParent -251.7 120.0 -1 ##$#%#\'+(()( 7 -1 0 4 4 UIParent 0.0 -309.0 -1 # 8 -1 1 6 6 UIParent 35.0 50.0 -1 #\'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 1 8 8 UIParent -9.0 85.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ## 20 0 1 7 7 UIParent 0.0 310.0 -1 ##$/%$&(\'%(-($)#+$,$-$ 20 1 1 7 7 UIParent 0.0 240.0 -1 ##$*%$&(\'%(-($)#+$,$-$ 20 2 1 7 7 UIParent 0.0 370.0 -1 ##$$%$&(\'((-($)#+$,$-$ 20 3 1 7 7 UIParent 420.0 430.0 -1 #$$$%#&(\'((-($)#*#+$,$-$\0'),
(19,10,1762394579,'2\0'),
(42,0,1762822336,'SET watchFrameState \"1\"\r\nSET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET UnitNameNonCombatCreatureName \"1\"\r\nSET watchFrameBaseAlpha \"1\"\r\nSET auctionHouseDurationDropdown \"3\"\r\nSET auctionDisplayOnCharacter \"1\"\r\nSET profanityFilter \"0\"\r\nSET xpBarText \"1\"\r\nSET alwaysShowActionBars \"1\"\r\nSET enableFloatingCombatText \"1\"\r\nSET removeChatDelay \"1\"\r\nSET deselectOnClick \"1\"\r\nSET addFriendInfoShown \"1\"\r\nSET transmogrifySourceFilters \"\"\r\nSET closedInfoFramesAccountWide \"J@CJ\"\r\nSET lootUnderMouse \"0\"\r\nSET actionedAdventureJournalEntries \"v\"\r\nSET UnitNameOwn \"1\"\r\nSET chatStyle \"classic\"\r\nSET perksActivitiesPendingCompletion \"v11\"\r\nSET spellActivationOverlayOpacity \"1\"\r\nSET showToastBroadcast \"1\"\r\nSET statusTextDisplay \"NUMERIC\"\r\nSET lockActionBars \"0\"\r\nSET showTutorials \"0\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET flaggedTutorials \"v11##$##%##(##-##\'##.##Z##E##K##:##D##0##I##9##J##V##8##A##B##[##)##F##?##@##>##+##;##3##Y##,##4##5\"\r\nSET showTargetOfTarget \"1\"\r\nSET playerColorOverrides \"v11\"\r\nSET mountJournalShowPlayer \"1\"\r\nSET petJournalFilters \"B\"\r\nSET autoDismountFlying \"1\"\r\nSET showNPETutorials \"0\"\r\nSET UnitNameNPC \"1\"\r\nSET petJournalSort \"1\"\r\nSET countdownForCooldowns \"1\"\r\nSET petJournalTypeFilters \"4\"\r\nSET statusText \"1\"\r\nSET threatShowNumeric \"1\"\r\nSET wardrobeSetsFilters \"B\"\r\nSET perksActivitiesCurrentMonth \"6\"\r\n'),
(42,8,1762820243,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(42,10,1762820243,'2\0'),
(42,13,1762822336,'1 29 0 100 1 1 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 3 new 43 0 0 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%(#,$ 0 2 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&(\'%(#,$ 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&(\'%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&(\'%(#,$ 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 6.0 -10.5 -1 $#3# 3 1 0 0 0 UIParent 234.5 -17.5 -1 %#3# 3 2 0 1 1 UIParent -463.0 -31.5 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 -7.0 -1 \'#(#)#-#.#/#1$3\' 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-#.#/#0#1#2( 3 5 1 5 5 UIParent 0.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4$ 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 1 7 7 UIParent 0.0 45.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#\'+(()( 7 -1 1 7 7 UIParent 0.0 45.0 -1 # 8 -1 0 3 3 UIParent 34.0 -459.0 -1 #($B%&&3 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 1 8 8 UIParent -9.0 85.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ## 20 0 1 7 7 UIParent 0.0 310.0 -1 ##$/%$&(\'%(-($)#+$,$-$ 20 1 1 7 7 UIParent 0.0 240.0 -1 ##$*%$&(\'%(-($)#+$,$-$ 20 2 1 7 7 UIParent 0.0 370.0 -1 ##$$%$&(\'((-($)#+$,$-$ 20 3 1 7 7 UIParent 420.0 430.0 -1 #$$$%#&(\'((-($)#*#+$,$-$\0'),
(46,0,1762879082,'SET showTimestamps \"%I:%M %p \"\r\nSET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET ShowQuestUnitCircles \"0\"\r\nSET alwaysShowActionBars \"1\"\r\nSET seenCharacterSelectAddGroupHelpTip \"1\"\r\nSET UnitNameInteractiveNPC \"0\"\r\nSET closedInfoFramesAccountWide \"Z@CB\"\r\nSET actionedAdventureJournalEntries \"v\"\r\nSET perksActivitiesPendingCompletion \"v11\"\r\nSET showTutorials \"0\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET flaggedTutorials \"v11##M##:##%##&##$##A##E##(##8##[##-##\'##.##Z##K##)##;##?##@##+##,##B##=##I##^##G##H##J##3##Y##0##V\"\r\nSET seenCharacterSelectNavBarCampsHelpTip \"1\"\r\nSET petJournalTab \"5\"\r\nSET showTargetOfTarget \"1\"\r\nSET playerColorOverrides \"v11\"\r\nSET countdownForCooldowns \"1\"\r\nSET UnitNameHostleNPC \"0\"\r\n'),
(46,8,1762644936,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(46,10,1762644936,'2\0'),
(46,13,1762829939,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 5 First 43 0 0 0 8 2 MainStatusTrackingBarContainer 0.0 4.0 -1 ##$$%/&(\'%)#+#,$ 0 1 0 6 0 MainMenuBar 0.0 4.0 -1 ##$$%/&(\'%(#,$ 0 2 0 0 0 UIParent 773.9 -1017.5 -1 ##$$%/&(\'%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&(\'%(#,$ 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&(\'%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&(\'%(#,$ 0 10 0 0 0 UIParent 773.9 -983.5 -1 ##$$&(\'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 3 5 ChatFrame1 9.0 -13.0 -1 $#3# 3 1 1 6 7 UIParent 300.0 250.0 -1 %#3# 3 2 1 6 7 UIParent 520.0 265.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 -7.0 -1 \'#(#)#-#.#/#1$3# 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-#.#/#0#1#2( 3 5 1 5 5 UIParent 0.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4$ 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 1 7 7 UIParent 0.0 45.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#\'+(()( 7 -1 1 7 7 UIParent 0.0 45.0 -1 # 8 -1 0 7 7 UIParent -801.4 34.0 -1 #\'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 1 8 8 UIParent -9.0 85.0 -1 # 12 -1 0 2 8 MinimapCluster 0.0 -4.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 0 8 2 MicroMenuContainer 0.0 4.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ## 20 0 1 7 7 UIParent 0.0 310.0 -1 ##$/%$&(\'%(-($)#+$,$-$ 20 1 1 7 7 UIParent 0.0 240.0 -1 ##$*%$&(\'%(-($)#+$,$-$ 20 2 1 7 7 UIParent 0.0 370.0 -1 ##$$%$&(\'((-($)#+$,$-$ 20 3 1 7 7 UIParent 420.0 430.0 -1 #$$$%#&(\'((-($)#*#+$,$-$\0'),
(47,0,1762664092,'SET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET closedInfoFramesAccountWide \"Z@CJ\"\r\nSET perksActivitiesPendingCompletion \"v11\"\r\nSET lockActionBars \"0\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET flaggedTutorials \"v11##$##%##-##\'##(##.##Z##E##K##[##8##)##;##+##,##<##:##F##^##]##D##?##@##I##L##J##9##3##A##B##=##Y\"\r\nSET seenCharacterSelectNavBarCampsHelpTip \"1\"\r\nSET petJournalTab \"5\"\r\nSET playerColorOverrides \"v11\"\r\n'),
(47,2,1762646102,'bind CTRL-1 MULTIACTIONBAR1BUTTON1\r\nbind CTRL-2 MULTIACTIONBAR1BUTTON2\r\nbind CTRL-3 MULTIACTIONBAR1BUTTON3\r\nbind CTRL-4 MULTIACTIONBAR1BUTTON4\r\nbind CTRL-5 MULTIACTIONBAR1BUTTON5\r\nbind CTRL-6 MULTIACTIONBAR1BUTTON6\r\nbind CTRL-7 MULTIACTIONBAR1BUTTON7\r\nbind CTRL-8 MULTIACTIONBAR1BUTTON8\r\nbind CTRL-9 MULTIACTIONBAR1BUTTON9\r\nbind CTRL-0 MULTIACTIONBAR1BUTTON10\r\nbind CTRL-= MULTIACTIONBAR1BUTTON12\r\nbind CTRL-- MULTIACTIONBAR1BUTTON11\r\nbind SHIFT-1 MULTIACTIONBAR2BUTTON1\r\nbind SHIFT-2 MULTIACTIONBAR2BUTTON2\r\nbind SHIFT-3 MULTIACTIONBAR2BUTTON3\r\nbind SHIFT-4 MULTIACTIONBAR2BUTTON4\r\nbind SHIFT-5 MULTIACTIONBAR2BUTTON5\r\nbind SHIFT-6 MULTIACTIONBAR2BUTTON6\r\nbind SHIFT-7 MULTIACTIONBAR2BUTTON7\r\nbind SHIFT-8 MULTIACTIONBAR2BUTTON8\r\nbind SHIFT-9 MULTIACTIONBAR2BUTTON9\r\nbind SHIFT-0 MULTIACTIONBAR2BUTTON10\r\nbind SHIFT-- MULTIACTIONBAR2BUTTON11\r\nbind SHIFT-= MULTIACTIONBAR2BUTTON12\r\n'),
(47,8,1762646102,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(47,10,1762646102,'2\0'),
(47,13,1762655077,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 1 43 0 0 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%(#,$ 0 2 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 5 0 1 1 UIParent -935.5 -2.0 -1 #$$$%/&(\'%(#,$ 0 6 0 0 0 UIParent 417.0 -114.0 -1 #$$$%/&(\'%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&(\'%(#,$ 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 1 8 7 UIParent -300.0 250.0 -1 $#3# 3 1 1 6 7 UIParent 300.0 250.0 -1 %#3# 3 2 1 6 7 UIParent 520.0 265.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 -7.0 -1 \'#(#)#-#.#/#1$3# 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-#.#/#0#1#2( 3 5 1 5 5 UIParent 0.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4$ 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 1 7 7 UIParent 0.0 45.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#\'+(()( 7 -1 1 7 7 UIParent 0.0 45.0 -1 # 8 -1 0 7 7 UIParent -719.0 34.0 -1 #\'$1%$&e 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 1 8 8 UIParent -9.0 85.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ## 20 0 1 7 7 UIParent 0.0 310.0 -1 ##$/%$&(\'%(-($)#+$,$-$ 20 1 1 7 7 UIParent 0.0 240.0 -1 ##$*%$&(\'%(-($)#+$,$-$ 20 2 1 7 7 UIParent 0.0 370.0 -1 ##$$%$&(\'((-($)#+$,$-$ 20 3 1 7 7 UIParent 420.0 430.0 -1 #$$$%#&(\'((-($)#*#+$,$-$\0'),
(48,0,1762842826,'SET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET UnitNameNonCombatCreatureName \"1\"\r\nSET watchFrameBaseAlpha \"1\"\r\nSET xpBarText \"1\"\r\nSET guildShowOffline \"0\"\r\nSET alwaysShowActionBars \"1\"\r\nSET seenCharacterSelectAddGroupHelpTip \"1\"\r\nSET autoQuestProgress \"0\"\r\nSET addFriendInfoShown \"1\"\r\nSET closedInfoFramesAccountWide \"J@CZ\"\r\nSET actionedAdventureJournalEntries \"v\"\r\nSET perksActivitiesPendingCompletion \"v11\"\r\nSET spellActivationOverlayOpacity \"1\"\r\nSET showTutorials \"0\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET flaggedTutorials \"v11##$##:##%##-##\'##(##.##Z##E##K##[##8##)##+##;##,##?##F##<##D##^##O##]##I##A##B##=##9##J##3##@##Y##0##V\"\r\nSET seenCharacterSelectNavBarCampsHelpTip \"1\"\r\nSET chatBubblesParty \"0\"\r\nSET petJournalTab \"5\"\r\nSET showTargetOfTarget \"1\"\r\nSET playerColorOverrides \"v11\"\r\nSET petJournalFilters \"B\"\r\nSET toyBoxCollectedFilters \"B\"\r\nSET timeMgrUseLocalTime \"1\"\r\nSET colorblindMode \"1\"\r\nSET autoDismountFlying \"1\"\r\nSET showNPETutorials \"0\"\r\nSET petJournalSort \"2\"\r\nSET threatShowNumeric \"1\"\r\n'),
(48,8,1762649105,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(48,10,1762647204,'2\0'),
(48,13,1762869151,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 4 Mine 43 0 0 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%(#,$ 0 2 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&(\'%(#,$ 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&(\'%(#,$ 0 5 1 1 4 UIParent 0.0 0.0 -1 ##$$%/&(\'%(#,$ 0 6 1 1 4 UIParent 0.0 -50.0 -1 ##$$%/&(\'%(#,$ 0 7 1 1 4 UIParent 0.0 -100.0 -1 ##$$%/&(\'%(#,$ 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&(\'% 1 -1 1 4 4 UIParent 0.0 0.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 1 0 0 UIParent 4.0 -4.0 -1 $#3# 3 1 1 0 0 UIParent 250.0 -4.0 -1 %#3# 3 2 1 0 0 UIParent 500.0 -240.0 -1 %#&#3# 3 3 1 0 2 CompactRaidFrameManager 0.0 -7.0 -1 \'#(#)#-#.#/#1$3# 3 4 1 0 2 CompactRaidFrameManager 0.0 -5.0 -1 ,#-#.#/#0#1#2( 3 5 1 5 5 UIParent 0.0 0.0 -1 &#*$3# 3 6 1 5 5 UIParent 0.0 0.0 -1 -#.#/#4$ 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 1 7 7 UIParent 0.0 45.0 -1 # 5 -1 1 7 7 UIParent 0.0 45.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#\'+(()( 7 -1 1 7 7 UIParent 0.0 45.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #\'$A%&&h 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 1 8 8 UIParent -9.0 85.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 1 7 7 StatusTrackingBarManager 0.0 0.0 -1 # 15 1 1 7 7 StatusTrackingBarManager 0.0 17.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ## 20 0 1 7 7 UIParent 0.0 310.0 -1 ##$/%$&(\'%(-($)#+$,$-$ 20 1 1 7 7 UIParent 0.0 240.0 -1 ##$*%$&(\'%(-($)#+$,$-$ 20 2 1 7 7 UIParent 0.0 370.0 -1 ##$$%$&(\'((-($)#+$,$-$ 20 3 1 7 7 UIParent 420.0 430.0 -1 #$$$%#&(\'((-($)#*#+$,$-$\0'),
(51,13,1762675818,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0\0'),
(53,0,1762834234,'SET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET threatPlaySounds \"0\"\r\nSET xpBarText \"1\"\r\nSET alwaysShowActionBars \"1\"\r\nSET addFriendInfoShown \"1\"\r\nSET closedInfoFramesAccountWide \"C\"\r\nSET actionedAdventureJournalEntries \"v\"\r\nSET UnitNameOwn \"1\"\r\nSET perksActivitiesPendingCompletion \"v11#\'P\"\r\nSET statusTextDisplay \"PERCENT\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET serviceTypeFilter \"7\"\r\nSET flaggedTutorials \"v11##A##B##3##@##=##Y##0##V##C##G##H##_##>##$##9##(##%##-##\'##.##Z##E##K##[##)##;##8##:##+##,##<##?##6##5##F##N##4##D##O##^##`##]##L##J##I\"\r\nSET petJournalTab \"5\"\r\nSET playerColorOverrides \"v11\"\r\nSET showNPETutorials \"0\"\r\nSET countdownForCooldowns \"1\"\r\nSET threatShowNumeric \"1\"\r\nSET perksActivitiesCurrentMonth \"4\"\r\n'),
(53,8,1762834234,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(53,10,1762834234,'2\0'),
(53,13,1762834234,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0\0'),
(56,0,1762835840,'SET showTimestamps \"%I:%M %p \"\r\nSET wholeChatWindowClickable \"0\"\r\nSET playerIdentityDefaultChoices \"v11##$#%h#%h#%h#%h\"\r\nSET wardrobeShowUncollected \"0\"\r\nSET findYourselfMode \"1\"\r\nSET profanityFilter \"0\"\r\nSET xpBarText \"1\"\r\nSET guildShowOffline \"0\"\r\nSET UnitNameEnemyMinionName \"0\"\r\nSET UnitNameFriendlyTotemName \"0\"\r\nSET UnitNameFriendlyPetName \"0\"\r\nSET alwaysShowActionBars \"1\"\r\nSET deselectOnClick \"1\"\r\nSET UnitNameInteractiveNPC \"0\"\r\nSET addFriendInfoShown \"1\"\r\nSET closedInfoFramesAccountWide \"B\"\r\nSET nameplateTargetRadialPosition \"1\"\r\nSET actionedAdventureJournalEntries \"v\"\r\nSET UnitNameFriendlyMinionName \"0\"\r\nSET showToastWindow \"0\"\r\nSET UnitNameOwn \"1\"\r\nSET perksActivitiesPendingCompletion \"v11\"\r\nSET combinedBags \"1\"\r\nSET UnitNameEnemyPlayerName \"0\"\r\nSET statusTextDisplay \"BOTH\"\r\nSET guildMemberNotify \"0\"\r\nSET showTutorials \"0\"\r\nSET UnitNameEnemyGuardianName \"0\"\r\nSET UnitNameEnemyTotemName \"0\"\r\nSET showCreateCharacterRealmConfirmDialog \"0\"\r\nSET flaggedTutorials \"v11##$##(##[##?##E##K##:##%##)##+##8##;##@##D##,##F##A##B##=##I##9##J##3##O##Y##0##V##<##6##5\"\r\nSET petJournalTab \"5\"\r\nSET playerColorOverrides \"v11\"\r\nSET heirloomCollectedFilters \"\"\r\nSET mountJournalShowPlayer \"1\"\r\nSET petJournalFilters \"D\"\r\nSET showToastOnline \"0\"\r\nSET toyBoxCollectedFilters \"B\"\r\nSET floatingCombatTextCombatDamage \"0\"\r\nSET UnitNameFriendlyGuardianName \"0\"\r\nSET showNPETutorials \"0\"\r\nSET showToastOffline \"0\"\r\nSET UnitNameEnemyPetName \"0\"\r\nSET countdownForCooldowns \"1\"\r\nSET statusText \"1\"\r\nSET threatShowNumeric \"1\"\r\nSET floatingCombatTextCombatHealing \"0\"\r\nSET whisperMode \"inline\"\r\nSET perksActivitiesCurrentMonth \"13\"\r\n'),
(56,2,1762834935,'bind A STRAFELEFT\r\nbind D STRAFERIGHT\r\nbind Q NONE\r\nbind E NONE\r\nbind CTRL-1 MULTIACTIONBAR1BUTTON1\r\nbind CTRL-2 MULTIACTIONBAR1BUTTON2\r\nbind CTRL-3 MULTIACTIONBAR1BUTTON3\r\nbind CTRL-4 MULTIACTIONBAR1BUTTON4\r\nbind CTRL-5 MULTIACTIONBAR1BUTTON5\r\nbind CTRL-6 MULTIACTIONBAR1BUTTON6\r\nbind CTRL-7 MULTIACTIONBAR1BUTTON7\r\nbind CTRL-8 MULTIACTIONBAR1BUTTON8\r\nbind CTRL-9 MULTIACTIONBAR1BUTTON9\r\nbind CTRL-0 MULTIACTIONBAR1BUTTON10\r\nbind CTRL-= MULTIACTIONBAR1BUTTON12\r\nbind CTRL-- MULTIACTIONBAR1BUTTON11\r\nbind SHIFT-1 MULTIACTIONBAR2BUTTON1\r\nbind SHIFT-2 MULTIACTIONBAR2BUTTON2\r\nbind SHIFT-3 MULTIACTIONBAR2BUTTON3\r\nbind SHIFT-4 MULTIACTIONBAR2BUTTON4\r\nbind SHIFT-5 MULTIACTIONBAR2BUTTON5\r\nbind SHIFT-6 MULTIACTIONBAR2BUTTON6\r\nbind SHIFT-7 MULTIACTIONBAR2BUTTON7\r\nbind SHIFT-8 MULTIACTIONBAR2BUTTON8\r\nbind SHIFT-9 MULTIACTIONBAR2BUTTON9\r\nbind SHIFT-0 MULTIACTIONBAR2BUTTON10\r\nbind SHIFT-- MULTIACTIONBAR2BUTTON11\r\nbind SHIFT-= MULTIACTIONBAR2BUTTON12\r\nmodifiedclick ALT MOUSEOVERCAST\r\n'),
(56,8,1762834935,'3\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(56,10,1762834935,'2\0'),
(56,13,1762834935,'1 29 0 100 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0\0');
/*!40000 ALTER TABLE `account_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_instance_times`
--

DROP TABLE IF EXISTS `account_instance_times`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_instance_times` (
  `accountId` int(10) unsigned NOT NULL,
  `instanceId` int(10) unsigned NOT NULL DEFAULT 0,
  `releaseTime` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`accountId`,`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_instance_times`
--

LOCK TABLES `account_instance_times` WRITE;
/*!40000 ALTER TABLE `account_instance_times` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_instance_times` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_tutorial`
--

DROP TABLE IF EXISTS `account_tutorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_tutorial` (
  `accountId` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Account Identifier',
  `tut0` int(10) unsigned NOT NULL DEFAULT 0,
  `tut1` int(10) unsigned NOT NULL DEFAULT 0,
  `tut2` int(10) unsigned NOT NULL DEFAULT 0,
  `tut3` int(10) unsigned NOT NULL DEFAULT 0,
  `tut4` int(10) unsigned NOT NULL DEFAULT 0,
  `tut5` int(10) unsigned NOT NULL DEFAULT 0,
  `tut6` int(10) unsigned NOT NULL DEFAULT 0,
  `tut7` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_tutorial`
--

LOCK TABLES `account_tutorial` WRITE;
/*!40000 ALTER TABLE `account_tutorial` DISABLE KEYS */;
INSERT INTO `account_tutorial` VALUES
(2,32839611,12845287,0,0,0,0,0,0),
(3,15794611,8388738,0,0,0,0,0,0),
(8,416350643,8388743,0,0,0,0,0,0),
(42,2096338875,14942439,0,0,0,0,0,0),
(46,2079365051,82051327,0,0,0,0,0,0),
(47,2079360955,115343847,0,0,0,0,0,0),
(48,2079365051,115607783,0,0,0,0,0,0),
(51,147916731,12583062,0,0,0,0,0,0),
(53,1563,4194434,0,0,0,0,0,0),
(56,9437619,8388738,0,0,0,0,0,0);
/*!40000 ALTER TABLE `account_tutorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arena_team`
--

DROP TABLE IF EXISTS `arena_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `arena_team` (
  `arenaTeamId` int(10) unsigned NOT NULL DEFAULT 0,
  `name` varchar(24) NOT NULL,
  `captainGuid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `type` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rating` smallint(5) unsigned NOT NULL DEFAULT 0,
  `seasonGames` smallint(5) unsigned NOT NULL DEFAULT 0,
  `seasonWins` smallint(5) unsigned NOT NULL DEFAULT 0,
  `weekGames` smallint(5) unsigned NOT NULL DEFAULT 0,
  `weekWins` smallint(5) unsigned NOT NULL DEFAULT 0,
  `rank` int(10) unsigned NOT NULL DEFAULT 0,
  `backgroundColor` int(10) unsigned NOT NULL DEFAULT 0,
  `emblemStyle` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `emblemColor` int(10) unsigned NOT NULL DEFAULT 0,
  `borderStyle` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `borderColor` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`arenaTeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arena_team`
--

LOCK TABLES `arena_team` WRITE;
/*!40000 ALTER TABLE `arena_team` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arena_team_member`
--

DROP TABLE IF EXISTS `arena_team_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `arena_team_member` (
  `arenaTeamId` int(10) unsigned NOT NULL DEFAULT 0,
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `weekGames` smallint(5) unsigned NOT NULL DEFAULT 0,
  `weekWins` smallint(5) unsigned NOT NULL DEFAULT 0,
  `seasonGames` smallint(5) unsigned NOT NULL DEFAULT 0,
  `seasonWins` smallint(5) unsigned NOT NULL DEFAULT 0,
  `personalRating` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`arenaTeamId`,`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arena_team_member`
--

LOCK TABLES `arena_team_member` WRITE;
/*!40000 ALTER TABLE `arena_team_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_team_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auction_bidders`
--

DROP TABLE IF EXISTS `auction_bidders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auction_bidders` (
  `auctionId` int(10) unsigned NOT NULL,
  `playerGuid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`auctionId`,`playerGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction_bidders`
--

LOCK TABLES `auction_bidders` WRITE;
/*!40000 ALTER TABLE `auction_bidders` DISABLE KEYS */;
/*!40000 ALTER TABLE `auction_bidders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auction_items`
--

DROP TABLE IF EXISTS `auction_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auction_items` (
  `auctionId` int(10) unsigned NOT NULL,
  `itemGuid` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`auctionId`,`itemGuid`),
  UNIQUE KEY `idx_itemGuid` (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction_items`
--

LOCK TABLES `auction_items` WRITE;
/*!40000 ALTER TABLE `auction_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `auction_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auctionhouse`
--

DROP TABLE IF EXISTS `auctionhouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auctionhouse` (
  `id` int(10) unsigned NOT NULL DEFAULT 0,
  `auctionHouseId` int(10) unsigned NOT NULL DEFAULT 0,
  `owner` bigint(20) unsigned NOT NULL DEFAULT 0,
  `bidder` bigint(20) unsigned NOT NULL DEFAULT 0,
  `minBid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `buyoutOrUnitPrice` bigint(20) unsigned NOT NULL DEFAULT 0,
  `deposit` bigint(20) unsigned NOT NULL DEFAULT 0,
  `bidAmount` bigint(20) unsigned NOT NULL DEFAULT 0,
  `startTime` bigint(20) NOT NULL DEFAULT 0,
  `endTime` bigint(20) NOT NULL DEFAULT 0,
  `serverFlags` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auctionhouse`
--

LOCK TABLES `auctionhouse` WRITE;
/*!40000 ALTER TABLE `auctionhouse` DISABLE KEYS */;
/*!40000 ALTER TABLE `auctionhouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blackmarket_auctions`
--

DROP TABLE IF EXISTS `blackmarket_auctions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `blackmarket_auctions` (
  `marketId` int(11) NOT NULL DEFAULT 0,
  `currentBid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `time` bigint(20) NOT NULL DEFAULT 0,
  `numBids` int(11) NOT NULL DEFAULT 0,
  `bidder` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`marketId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blackmarket_auctions`
--

LOCK TABLES `blackmarket_auctions` WRITE;
/*!40000 ALTER TABLE `blackmarket_auctions` DISABLE KEYS */;
/*!40000 ALTER TABLE `blackmarket_auctions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bugreport`
--

DROP TABLE IF EXISTS `bugreport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bugreport` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `type` longtext NOT NULL,
  `content` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Debug System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bugreport`
--

LOCK TABLES `bugreport` WRITE;
/*!40000 ALTER TABLE `bugreport` DISABLE KEYS */;
/*!40000 ALTER TABLE `bugreport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendar_events`
--

DROP TABLE IF EXISTS `calendar_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendar_events` (
  `EventID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `Owner` bigint(20) unsigned NOT NULL DEFAULT 0,
  `Title` varchar(255) NOT NULL DEFAULT '',
  `Description` varchar(255) NOT NULL DEFAULT '',
  `EventType` tinyint(3) unsigned NOT NULL DEFAULT 4,
  `TextureID` int(11) NOT NULL DEFAULT -1,
  `Date` bigint(20) NOT NULL DEFAULT 0,
  `Flags` int(10) unsigned NOT NULL DEFAULT 0,
  `LockDate` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`EventID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendar_events`
--

LOCK TABLES `calendar_events` WRITE;
/*!40000 ALTER TABLE `calendar_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendar_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendar_invites`
--

DROP TABLE IF EXISTS `calendar_invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendar_invites` (
  `InviteID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `EventID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `Invitee` bigint(20) unsigned NOT NULL DEFAULT 0,
  `Sender` bigint(20) unsigned NOT NULL DEFAULT 0,
  `Status` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ResponseTime` bigint(20) NOT NULL DEFAULT 0,
  `ModerationRank` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `Note` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`InviteID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendar_invites`
--

LOCK TABLES `calendar_invites` WRITE;
/*!40000 ALTER TABLE `calendar_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendar_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channels`
--

DROP TABLE IF EXISTS `channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `channels` (
  `name` varchar(128) NOT NULL,
  `team` int(10) unsigned NOT NULL,
  `announce` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `ownership` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `password` varchar(128) DEFAULT NULL,
  `bannedList` text DEFAULT NULL,
  `lastUsed` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`name`,`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Channel System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channels`
--

LOCK TABLES `channels` WRITE;
/*!40000 ALTER TABLE `channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_account_data`
--

DROP TABLE IF EXISTS `character_account_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_account_data` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `type` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `time` bigint(20) NOT NULL DEFAULT 0,
  `data` blob NOT NULL,
  PRIMARY KEY (`guid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_account_data`
--

LOCK TABLES `character_account_data` WRITE;
/*!40000 ALTER TABLE `character_account_data` DISABLE KEYS */;
INSERT INTO `character_account_data` VALUES
(3,1,1762642076,'SET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET nameplateSelectedScale \"1.15\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET NamePlateHorizontalScale \"1\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET nameplateLargeTopInset \"0.085\"\r\nSET nameplateOtherTopInset \"0.085\"\r\nSET nameplateSelectedAlpha \"1\"\r\nSET autoLootDefault \"1\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET nameplateMinScale \"1\"\r\nSET numReputationHeaders \"24\"\r\nSET nameplateShowAll \"1\"\r\nSET nameplateShowDebuffsOnFriendly \"0\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"13.076140\"\r\nSET EJLootClass \"2\"\r\nSET enableMultiActionBars \"15\"\r\nSET numCurrencyCategories \"21\"\r\nSET NamePlateClassificationScale \"1\"\r\nSET hardTrackedQuests \"v11\"\r\nSET NameplatePersonalHideDelaySeconds \"0.2\"\r\nSET EJSelectedTier \"505\"\r\nSET nameplateShowEnemyGuardians \"1\"\r\nSET cameraSavedVehicleDistance \"50.000000\"\r\nSET cameraSavedDistance \"30.000111\"\r\nSET nameplateTargetBehindMaxDistance \"30\"\r\nSET closedInfoFrames \"@@B@@@@@@@@@@@@@@@B@@@@@@@B\"\r\nSET nameplateShowEnemyTotems \"1\"\r\nSET nameplateMinAlpha \"0.90135484\"\r\nSET NamePlateVerticalScale \"1\"\r\nSET nameplateMinAlphaDistance \"-158489.31924611\"\r\nSET nameplateLargerScale \"1.1\"\r\nSET trackedAchievements \"v11\"\r\nSET nameplateShowEnemyPets \"1\"\r\nSET nameplateShowEnemyMinions \"1\"\r\n'),
(3,7,1762259289,'VERSION 9\n\nADDEDVERSION 27\n\nCHANNELS\n1 0 1 1\n2 0 2 1\n22 0 3 1\n42 0 4 1\nEND\n\nZONECHANNELS 0\n\nCOLORS\n\nSYSTEM 255 255 0 N\nSAY 255 255 255 N\nPARTY 170 170 255 N\nRAID 255 127 0 N\nGUILD 64 255 64 N\nOFFICER 64 192 64 N\nYELL 255 64 64 N\nWHISPER 255 128 255 N\nWHISPER_FOREIGN 255 128 255 N\nWHISPER_INFORM 255 128 255 N\nEMOTE 255 128 64 N\nTEXT_EMOTE 255 128 64 N\nMONSTER_SAY 255 255 159 N\nMONSTER_PARTY 170 170 255 N\nMONSTER_YELL 255 64 64 N\nMONSTER_WHISPER 255 181 235 N\nMONSTER_EMOTE 255 128 64 N\nCHANNEL 255 192 192 N\nCHANNEL_JOIN 192 128 128 N\nCHANNEL_LEAVE 192 128 128 N\nCHANNEL_LIST 192 128 128 N\nCHANNEL_NOTICE 192 192 192 N\nCHANNEL_NOTICE_USER 192 192 192 N\nAFK 255 128 255 N\nDND 255 128 255 N\nIGNORED 255 0 0 N\nSKILL 85 85 255 N\nLOOT 0 170 0 N\nMONEY 255 255 0 N\nOPENING 128 128 255 N\nTRADESKILLS 255 255 255 N\nPET_INFO 128 128 255 N\nCOMBAT_MISC_INFO 128 128 255 N\nCOMBAT_XP_GAIN 111 111 255 N\nCOMBAT_HONOR_GAIN 224 202 10 N\nCOMBAT_FACTION_CHANGE 128 128 255 N\nBG_SYSTEM_NEUTRAL 255 120 10 N\nBG_SYSTEM_ALLIANCE 0 174 239 N\nBG_SYSTEM_HORDE 255 0 0 N\nRAID_LEADER 255 72 9 N\nRAID_WARNING 255 72 0 N\nRAID_BOSS_EMOTE 255 221 0 N\nRAID_BOSS_WHISPER 255 221 0 N\nFILTERED 255 0 0 N\nRESTRICTED 255 0 0 N\nBATTLENET 255 255 255 N\nACHIEVEMENT 255 255 0 N\nGUILD_ACHIEVEMENT 64 255 64 N\nARENA_POINTS 255 255 255 N\nPARTY_LEADER 118 200 255 N\nTARGETICONS 255 255 0 N\nBN_WHISPER 0 255 246 N\nBN_WHISPER_INFORM 0 255 246 N\nBN_INLINE_TOAST_ALERT 130 197 255 N\nBN_INLINE_TOAST_BROADCAST 130 197 255 N\nBN_INLINE_TOAST_BROADCAST_INFORM 130 197 255 N\nBN_INLINE_TOAST_CONVERSATION 130 197 255 N\nBN_WHISPER_PLAYER_OFFLINE 255 255 0 N\nCURRENCY 0 170 0 N\nQUEST_BOSS_EMOTE 255 128 64 N\nPET_BATTLE_COMBAT_LOG 231 222 171 N\nPET_BATTLE_INFO 225 222 93 N\nINSTANCE_CHAT 255 127 0 N\nINSTANCE_CHAT_LEADER 255 72 9 N\nGUILD_ITEM_LOOTED 64 255 64 N\nCOMMUNITIES_CHANNEL 255 192 192 N\nVOICE_TEXT 158 255 252 N\nPING 170 170 255 N\nCHANNEL1 255 192 192 N\nCHANNEL2 255 192 192 N\nCHANNEL3 255 192 192 N\nCHANNEL4 255 192 192 N\nCHANNEL5 255 192 192 N\nCHANNEL6 255 192 192 N\nCHANNEL7 255 192 192 N\nCHANNEL8 255 192 192 N\nCHANNEL9 255 192 192 N\nCHANNEL10 255 192 192 N\nCHANNEL11 255 192 192 N\nCHANNEL12 255 192 192 N\nCHANNEL13 255 192 192 N\nCHANNEL14 255 192 192 N\nCHANNEL15 255 192 192 N\nCHANNEL16 255 192 192 N\nCHANNEL17 255 192 192 N\nCHANNEL18 255 192 192 N\nCHANNEL19 255 192 192 N\nCHANNEL20 255 192 192 N\nEND\n\nWINDOW 1\nNAME General\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 1\nSHOWN 1\nMESSAGES\nSYSTEM\nSYSTEM_NOMENU\nSAY\nEMOTE\nYELL\nWHISPER\nPARTY\nPARTY_LEADER\nRAID\nRAID_LEADER\nRAID_WARNING\nGUILD\nOFFICER\nMONSTER_SAY\nMONSTER_YELL\nMONSTER_EMOTE\nMONSTER_WHISPER\nMONSTER_BOSS_EMOTE\nMONSTER_BOSS_WHISPER\nERRORS\nAFK\nDND\nIGNORED\nBG_HORDE\nBG_ALLIANCE\nBG_NEUTRAL\nCOMBAT_FACTION_CHANGE\nSKILL\nLOOT\nMONEY\nCHANNEL\nACHIEVEMENT\nGUILD_ACHIEVEMENT\nBN_WHISPER\nBN_WHISPER_INFORM\nBN_CONVERSATION\nBN_INLINE_TOAST_ALERT\nCURRENCY\nBN_WHISPER_PLAYER_OFFLINE\nPET_BATTLE_INFO\nINSTANCE_CHAT\nINSTANCE_CHAT_LEADER\nGUILD_ITEM_LOOTED\nCOMBAT_HONOR_GAIN\nPING\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 2265597345795\n\nEND\n\nWINDOW 2\nNAME Combat Log\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 2\nSHOWN 0\nMESSAGES\nOPENING\nTRADESKILLS\nPET_INFO\nCOMBAT_XP_GAIN\nCOMBAT_HONOR_GAIN\nCOMBAT_MISC_INFO\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 3\nNAME Voice\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nVOICE_TEXT\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 4\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 5\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 6\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 7\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 8\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 9\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 10\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\n'),
(3,9,1762259289,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(3,11,1762259288,'2\0'),
(3,12,1762259289,'1\n0\n'),
(3,14,1762259288,'1 -1 -1 -1 -1 -1\0'),
(4,1,1762722464,'SET autoQuestPopUps \"v11\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET notifiedOfNewMail \"1\"\r\nSET numReputationHeaders \"24\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"30.150009\"\r\nSET EJLootClass \"8\"\r\nSET enableMultiActionBars \"3\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11$,W$+`$-a$/1$.o$-T$-h\"\r\nSET cameraSavedDistance \"16.499985\"\r\nSET closedInfoFrames \"@@B@@@@@@@@@@@@@@@@@@@@@@@B\"\r\nSET trackedAchievements \"v11\"\r\n'),
(4,7,1762363965,'VERSION 9\n\nADDEDVERSION 27\n\nCHANNELS\n1 0 1 1\n2 0 2 1\n22 0 3 1\n42 0 4 1\nEND\n\nZONECHANNELS 0\n\nCOLORS\n\nSYSTEM 255 255 0 N\nSAY 255 255 255 N\nPARTY 170 170 255 N\nRAID 255 127 0 N\nGUILD 64 255 64 N\nOFFICER 64 192 64 N\nYELL 255 64 64 N\nWHISPER 255 128 255 N\nWHISPER_FOREIGN 255 128 255 N\nWHISPER_INFORM 255 128 255 N\nEMOTE 255 128 64 N\nTEXT_EMOTE 255 128 64 N\nMONSTER_SAY 255 255 159 N\nMONSTER_PARTY 170 170 255 N\nMONSTER_YELL 255 64 64 N\nMONSTER_WHISPER 255 181 235 N\nMONSTER_EMOTE 255 128 64 N\nCHANNEL 255 192 192 N\nCHANNEL_JOIN 192 128 128 N\nCHANNEL_LEAVE 192 128 128 N\nCHANNEL_LIST 192 128 128 N\nCHANNEL_NOTICE 192 192 192 N\nCHANNEL_NOTICE_USER 192 192 192 N\nAFK 255 128 255 N\nDND 255 128 255 N\nIGNORED 255 0 0 N\nSKILL 85 85 255 N\nLOOT 0 170 0 N\nMONEY 255 255 0 N\nOPENING 128 128 255 N\nTRADESKILLS 255 255 255 N\nPET_INFO 128 128 255 N\nCOMBAT_MISC_INFO 128 128 255 N\nCOMBAT_XP_GAIN 111 111 255 N\nCOMBAT_HONOR_GAIN 224 202 10 N\nCOMBAT_FACTION_CHANGE 128 128 255 N\nBG_SYSTEM_NEUTRAL 255 120 10 N\nBG_SYSTEM_ALLIANCE 0 174 239 N\nBG_SYSTEM_HORDE 255 0 0 N\nRAID_LEADER 255 72 9 N\nRAID_WARNING 255 72 0 N\nRAID_BOSS_EMOTE 255 221 0 N\nRAID_BOSS_WHISPER 255 221 0 N\nFILTERED 255 0 0 N\nRESTRICTED 255 0 0 N\nBATTLENET 255 255 255 N\nACHIEVEMENT 255 255 0 N\nGUILD_ACHIEVEMENT 64 255 64 N\nARENA_POINTS 255 255 255 N\nPARTY_LEADER 118 200 255 N\nTARGETICONS 255 255 0 N\nBN_WHISPER 0 255 246 N\nBN_WHISPER_INFORM 0 255 246 N\nBN_INLINE_TOAST_ALERT 130 197 255 N\nBN_INLINE_TOAST_BROADCAST 130 197 255 N\nBN_INLINE_TOAST_BROADCAST_INFORM 130 197 255 N\nBN_INLINE_TOAST_CONVERSATION 130 197 255 N\nBN_WHISPER_PLAYER_OFFLINE 255 255 0 N\nCURRENCY 0 170 0 N\nQUEST_BOSS_EMOTE 255 128 64 N\nPET_BATTLE_COMBAT_LOG 231 222 171 N\nPET_BATTLE_INFO 225 222 93 N\nINSTANCE_CHAT 255 127 0 N\nINSTANCE_CHAT_LEADER 255 72 9 N\nGUILD_ITEM_LOOTED 64 255 64 N\nCOMMUNITIES_CHANNEL 255 192 192 N\nVOICE_TEXT 158 255 252 N\nPING 170 170 255 N\nCHANNEL1 255 192 192 N\nCHANNEL2 255 192 192 N\nCHANNEL3 255 192 192 N\nCHANNEL4 255 192 192 N\nCHANNEL5 255 192 192 N\nCHANNEL6 255 192 192 N\nCHANNEL7 255 192 192 N\nCHANNEL8 255 192 192 N\nCHANNEL9 255 192 192 N\nCHANNEL10 255 192 192 N\nCHANNEL11 255 192 192 N\nCHANNEL12 255 192 192 N\nCHANNEL13 255 192 192 N\nCHANNEL14 255 192 192 N\nCHANNEL15 255 192 192 N\nCHANNEL16 255 192 192 N\nCHANNEL17 255 192 192 N\nCHANNEL18 255 192 192 N\nCHANNEL19 255 192 192 N\nCHANNEL20 255 192 192 N\nEND\n\nWINDOW 1\nNAME General\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 1\nSHOWN 1\nMESSAGES\nSYSTEM\nSYSTEM_NOMENU\nSAY\nEMOTE\nYELL\nWHISPER\nPARTY\nPARTY_LEADER\nRAID\nRAID_LEADER\nRAID_WARNING\nGUILD\nOFFICER\nMONSTER_SAY\nMONSTER_YELL\nMONSTER_EMOTE\nMONSTER_WHISPER\nMONSTER_BOSS_EMOTE\nMONSTER_BOSS_WHISPER\nERRORS\nAFK\nDND\nIGNORED\nBG_HORDE\nBG_ALLIANCE\nBG_NEUTRAL\nCOMBAT_FACTION_CHANGE\nSKILL\nLOOT\nMONEY\nCHANNEL\nACHIEVEMENT\nGUILD_ACHIEVEMENT\nBN_WHISPER\nBN_WHISPER_INFORM\nBN_CONVERSATION\nBN_INLINE_TOAST_ALERT\nCURRENCY\nBN_WHISPER_PLAYER_OFFLINE\nPET_BATTLE_INFO\nINSTANCE_CHAT\nINSTANCE_CHAT_LEADER\nGUILD_ITEM_LOOTED\nCOMBAT_HONOR_GAIN\nPING\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 2265597345795\n\nEND\n\nWINDOW 2\nNAME Combat Log\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 2\nSHOWN 0\nMESSAGES\nOPENING\nTRADESKILLS\nPET_INFO\nCOMBAT_XP_GAIN\nCOMBAT_HONOR_GAIN\nCOMBAT_MISC_INFO\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 3\nNAME Voice\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nVOICE_TEXT\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 4\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 5\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 6\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 7\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 8\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 9\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 10\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\n'),
(4,9,1762363965,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(4,11,1762363965,'2\0'),
(4,12,1762363965,'1\n0\n4\n1 0 3 1\n4 0 3 2\nEND\n'),
(4,14,1762363965,'1 2 2 2 2 2\0'),
(6,1,1762826656,'SET autoQuestPopUps \"v11\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET autoLootDefault \"1\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"24\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"8.561500\"\r\nSET EJLootClass \"5\"\r\nSET enableMultiActionBars \"1\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11#(5$[{#-%$[|\"\r\nSET cameraSavedVehicleDistance \"49.999043\"\r\nSET cameraSavedDistance \"5.499990\"\r\nSET closedInfoFrames \"@@B@@@@@@@@@@@@@@@@@@@@@@@B\"\r\nSET trackedAchievements \"v11\"\r\n'),
(6,12,1762826656,'1\n0\n4\n1 0 3 1\n4 0 3 2\nEND\n'),
(7,1,1762902745,'SET latestSplashScreen \"85\"\r\nSET autoQuestPopUps \"v11\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET minimapZoom \"5\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET minimapInsideZoom \"3\"\r\nSET numReputationHeaders \"24\"\r\nSET nameplateShowAll \"1\"\r\nSET dragonRidingRacesFilter \"1\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"17.221813\"\r\nSET EJLootClass \"4\"\r\nSET enableMultiActionBars \"3\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11(HL#-*#>*#=t#S@&\'c\"\r\nSET cameraSavedDistance \"15.830020\"\r\nSET minimapTrackedInfov4 \"3104495\"\r\nSET closedInfoFrames \"@@B@@@@@@@@@@@@@@@@@@@@@@@B\"\r\nSET showTokenFrame \"1\"\r\nSET trackedAchievements \"v11\"\r\n'),
(7,7,1762644936,'VERSION 9\n\nADDEDVERSION 27\n\nCHANNELS\n1 0 1 1\n2 0 2 1\n22 0 3 1\n42 0 4 1\nEND\n\nZONECHANNELS 0\n\nCOLORS\n\nSYSTEM 255 255 0 N\nSAY 255 255 255 N\nPARTY 170 170 255 N\nRAID 255 127 0 N\nGUILD 64 255 64 N\nOFFICER 64 192 64 N\nYELL 255 64 64 N\nWHISPER 255 128 255 N\nWHISPER_FOREIGN 255 128 255 N\nWHISPER_INFORM 255 128 255 N\nEMOTE 255 128 64 N\nTEXT_EMOTE 255 128 64 N\nMONSTER_SAY 255 255 159 N\nMONSTER_PARTY 170 170 255 N\nMONSTER_YELL 255 64 64 N\nMONSTER_WHISPER 255 181 235 N\nMONSTER_EMOTE 255 128 64 N\nCHANNEL 255 192 192 N\nCHANNEL_JOIN 192 128 128 N\nCHANNEL_LEAVE 192 128 128 N\nCHANNEL_LIST 192 128 128 N\nCHANNEL_NOTICE 192 192 192 N\nCHANNEL_NOTICE_USER 192 192 192 N\nAFK 255 128 255 N\nDND 255 128 255 N\nIGNORED 255 0 0 N\nSKILL 85 85 255 N\nLOOT 0 170 0 N\nMONEY 255 255 0 N\nOPENING 128 128 255 N\nTRADESKILLS 255 255 255 N\nPET_INFO 128 128 255 N\nCOMBAT_MISC_INFO 128 128 255 N\nCOMBAT_XP_GAIN 111 111 255 N\nCOMBAT_HONOR_GAIN 224 202 10 N\nCOMBAT_FACTION_CHANGE 128 128 255 N\nBG_SYSTEM_NEUTRAL 255 120 10 N\nBG_SYSTEM_ALLIANCE 0 174 239 N\nBG_SYSTEM_HORDE 255 0 0 N\nRAID_LEADER 255 72 9 N\nRAID_WARNING 255 72 0 N\nRAID_BOSS_EMOTE 255 221 0 N\nRAID_BOSS_WHISPER 255 221 0 N\nFILTERED 255 0 0 N\nRESTRICTED 255 0 0 N\nBATTLENET 255 255 255 N\nACHIEVEMENT 255 255 0 N\nGUILD_ACHIEVEMENT 64 255 64 N\nARENA_POINTS 255 255 255 N\nPARTY_LEADER 118 200 255 N\nTARGETICONS 255 255 0 N\nBN_WHISPER 0 255 246 N\nBN_WHISPER_INFORM 0 255 246 N\nBN_INLINE_TOAST_ALERT 130 197 255 N\nBN_INLINE_TOAST_BROADCAST 130 197 255 N\nBN_INLINE_TOAST_BROADCAST_INFORM 130 197 255 N\nBN_INLINE_TOAST_CONVERSATION 130 197 255 N\nBN_WHISPER_PLAYER_OFFLINE 255 255 0 N\nCURRENCY 0 170 0 N\nQUEST_BOSS_EMOTE 255 128 64 N\nPET_BATTLE_COMBAT_LOG 231 222 171 N\nPET_BATTLE_INFO 225 222 93 N\nINSTANCE_CHAT 255 127 0 N\nINSTANCE_CHAT_LEADER 255 72 9 N\nGUILD_ITEM_LOOTED 64 255 64 N\nCOMMUNITIES_CHANNEL 255 192 192 N\nVOICE_TEXT 158 255 252 N\nPING 170 170 255 N\nCHANNEL1 255 192 192 N\nCHANNEL2 255 192 192 N\nCHANNEL3 255 192 192 N\nCHANNEL4 255 192 192 N\nCHANNEL5 255 192 192 N\nCHANNEL6 255 192 192 N\nCHANNEL7 255 192 192 N\nCHANNEL8 255 192 192 N\nCHANNEL9 255 192 192 N\nCHANNEL10 255 192 192 N\nCHANNEL11 255 192 192 N\nCHANNEL12 255 192 192 N\nCHANNEL13 255 192 192 N\nCHANNEL14 255 192 192 N\nCHANNEL15 255 192 192 N\nCHANNEL16 255 192 192 N\nCHANNEL17 255 192 192 N\nCHANNEL18 255 192 192 N\nCHANNEL19 255 192 192 N\nCHANNEL20 255 192 192 N\nEND\n\nWINDOW 1\nNAME General\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 1\nSHOWN 1\nMESSAGES\nSYSTEM\nSYSTEM_NOMENU\nSAY\nEMOTE\nYELL\nWHISPER\nPARTY\nPARTY_LEADER\nRAID\nRAID_LEADER\nRAID_WARNING\nGUILD\nOFFICER\nMONSTER_SAY\nMONSTER_YELL\nMONSTER_EMOTE\nMONSTER_WHISPER\nMONSTER_BOSS_EMOTE\nMONSTER_BOSS_WHISPER\nERRORS\nAFK\nDND\nIGNORED\nBG_HORDE\nBG_ALLIANCE\nBG_NEUTRAL\nCOMBAT_FACTION_CHANGE\nSKILL\nLOOT\nMONEY\nCHANNEL\nACHIEVEMENT\nGUILD_ACHIEVEMENT\nBN_WHISPER\nBN_WHISPER_INFORM\nBN_CONVERSATION\nBN_INLINE_TOAST_ALERT\nCURRENCY\nBN_WHISPER_PLAYER_OFFLINE\nPET_BATTLE_INFO\nINSTANCE_CHAT\nINSTANCE_CHAT_LEADER\nGUILD_ITEM_LOOTED\nCOMBAT_HONOR_GAIN\nPING\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 2265597345795\n\nEND\n\nWINDOW 2\nNAME Combat Log\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 2\nSHOWN 0\nMESSAGES\nOPENING\nTRADESKILLS\nPET_INFO\nCOMBAT_XP_GAIN\nCOMBAT_HONOR_GAIN\nCOMBAT_MISC_INFO\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 3\nNAME Voice\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nVOICE_TEXT\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 4\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 5\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 6\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 7\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 8\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 9\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 10\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\n'),
(7,9,1762644936,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(7,11,1762644936,'2\0'),
(7,12,1762879082,'1\n0\n2\n1 0 3 1\n4 0 3 2\nEND\n4\n1 0 3 1\n4 0 3 2\nEND\n'),
(7,14,1762644936,'1 2 2 2 2 2\0'),
(8,1,1762664092,'SET latestSplashScreen \"85\"\r\nSET autoQuestPopUps \"v11\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET minimapZoom \"5\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"24\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"15.938083\"\r\nSET EJLootClass \"2\"\r\nSET enableMultiActionBars \"19\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11%~B\"\r\nSET cameraSavedDistance \"17.500015\"\r\nSET minimapTrackedInfov4 \"3103343\"\r\nSET questLogOpen \"0\"\r\nSET closedInfoFrames \"@AbM@@@@@P@@@@@@@@B@G@@@@@B\"\r\nSET trackedAchievements \"v11\"\r\n'),
(8,7,1762646102,'VERSION 9\n\nADDEDVERSION 27\n\nCHANNELS\n1 0 1 1\n2 0 2 1\n22 0 3 1\n42 0 4 1\nEND\n\nZONECHANNELS 0\n\nCOLORS\n\nSYSTEM 255 255 0 N\nSAY 255 255 255 N\nPARTY 170 170 255 N\nRAID 255 127 0 N\nGUILD 64 255 64 N\nOFFICER 64 192 64 N\nYELL 255 64 64 N\nWHISPER 255 128 255 N\nWHISPER_FOREIGN 255 128 255 N\nWHISPER_INFORM 255 128 255 N\nEMOTE 255 128 64 N\nTEXT_EMOTE 255 128 64 N\nMONSTER_SAY 255 255 159 N\nMONSTER_PARTY 170 170 255 N\nMONSTER_YELL 255 64 64 N\nMONSTER_WHISPER 255 181 235 N\nMONSTER_EMOTE 255 128 64 N\nCHANNEL 255 192 192 N\nCHANNEL_JOIN 192 128 128 N\nCHANNEL_LEAVE 192 128 128 N\nCHANNEL_LIST 192 128 128 N\nCHANNEL_NOTICE 192 192 192 N\nCHANNEL_NOTICE_USER 192 192 192 N\nAFK 255 128 255 N\nDND 255 128 255 N\nIGNORED 255 0 0 N\nSKILL 85 85 255 N\nLOOT 0 170 0 N\nMONEY 255 255 0 N\nOPENING 128 128 255 N\nTRADESKILLS 255 255 255 N\nPET_INFO 128 128 255 N\nCOMBAT_MISC_INFO 128 128 255 N\nCOMBAT_XP_GAIN 111 111 255 N\nCOMBAT_HONOR_GAIN 224 202 10 N\nCOMBAT_FACTION_CHANGE 128 128 255 N\nBG_SYSTEM_NEUTRAL 255 120 10 N\nBG_SYSTEM_ALLIANCE 0 174 239 N\nBG_SYSTEM_HORDE 255 0 0 N\nRAID_LEADER 255 72 9 N\nRAID_WARNING 255 72 0 N\nRAID_BOSS_EMOTE 255 221 0 N\nRAID_BOSS_WHISPER 255 221 0 N\nFILTERED 255 0 0 N\nRESTRICTED 255 0 0 N\nBATTLENET 255 255 255 N\nACHIEVEMENT 255 255 0 N\nGUILD_ACHIEVEMENT 64 255 64 N\nARENA_POINTS 255 255 255 N\nPARTY_LEADER 118 200 255 N\nTARGETICONS 255 255 0 N\nBN_WHISPER 0 255 246 N\nBN_WHISPER_INFORM 0 255 246 N\nBN_INLINE_TOAST_ALERT 130 197 255 N\nBN_INLINE_TOAST_BROADCAST 130 197 255 N\nBN_INLINE_TOAST_BROADCAST_INFORM 130 197 255 N\nBN_INLINE_TOAST_CONVERSATION 130 197 255 N\nBN_WHISPER_PLAYER_OFFLINE 255 255 0 N\nCURRENCY 0 170 0 N\nQUEST_BOSS_EMOTE 255 128 64 N\nPET_BATTLE_COMBAT_LOG 231 222 171 N\nPET_BATTLE_INFO 225 222 93 N\nINSTANCE_CHAT 255 127 0 N\nINSTANCE_CHAT_LEADER 255 72 9 N\nGUILD_ITEM_LOOTED 64 255 64 N\nCOMMUNITIES_CHANNEL 255 192 192 N\nVOICE_TEXT 158 255 252 N\nPING 170 170 255 N\nCHANNEL1 255 192 192 N\nCHANNEL2 255 192 192 N\nCHANNEL3 255 192 192 N\nCHANNEL4 255 192 192 N\nCHANNEL5 255 192 192 N\nCHANNEL6 255 192 192 N\nCHANNEL7 255 192 192 N\nCHANNEL8 255 192 192 N\nCHANNEL9 255 192 192 N\nCHANNEL10 255 192 192 N\nCHANNEL11 255 192 192 N\nCHANNEL12 255 192 192 N\nCHANNEL13 255 192 192 N\nCHANNEL14 255 192 192 N\nCHANNEL15 255 192 192 N\nCHANNEL16 255 192 192 N\nCHANNEL17 255 192 192 N\nCHANNEL18 255 192 192 N\nCHANNEL19 255 192 192 N\nCHANNEL20 255 192 192 N\nEND\n\nWINDOW 1\nNAME General\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 1\nSHOWN 1\nMESSAGES\nSYSTEM\nSYSTEM_NOMENU\nSAY\nEMOTE\nYELL\nWHISPER\nPARTY\nPARTY_LEADER\nRAID\nRAID_LEADER\nRAID_WARNING\nGUILD\nOFFICER\nMONSTER_SAY\nMONSTER_YELL\nMONSTER_EMOTE\nMONSTER_WHISPER\nMONSTER_BOSS_EMOTE\nMONSTER_BOSS_WHISPER\nERRORS\nAFK\nDND\nIGNORED\nBG_HORDE\nBG_ALLIANCE\nBG_NEUTRAL\nCOMBAT_FACTION_CHANGE\nSKILL\nLOOT\nMONEY\nCHANNEL\nACHIEVEMENT\nGUILD_ACHIEVEMENT\nBN_WHISPER\nBN_WHISPER_INFORM\nBN_CONVERSATION\nBN_INLINE_TOAST_ALERT\nCURRENCY\nBN_WHISPER_PLAYER_OFFLINE\nPET_BATTLE_INFO\nINSTANCE_CHAT\nINSTANCE_CHAT_LEADER\nGUILD_ITEM_LOOTED\nCOMBAT_HONOR_GAIN\nPING\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 2265597345795\n\nEND\n\nWINDOW 2\nNAME Combat Log\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 2\nSHOWN 0\nMESSAGES\nOPENING\nTRADESKILLS\nPET_INFO\nCOMBAT_XP_GAIN\nCOMBAT_HONOR_GAIN\nCOMBAT_MISC_INFO\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 3\nNAME Voice\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nVOICE_TEXT\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 4\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 5\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 6\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 7\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 8\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 9\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 10\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\n'),
(8,9,1762646102,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(8,11,1762646102,'2\0'),
(8,12,1762655077,'1\n0\n2\n1 0 3 1\n4 0 3 2\nEND\n4\n1 0 3 1\n4 0 3 2\nEND\n'),
(8,14,1762655077,'1 2 2 2 2 2\0'),
(10,1,1762869151,'SET latestSplashScreen \"85\"\r\nSET autoQuestPopUps \"v11\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET autoLootDefault \"1\"\r\nSET minimapZoom \"5\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"24\"\r\nSET nameplateShowAll \"1\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"33.344093\"\r\nSET EJLootClass \"1\"\r\nSET enableMultiActionBars \"3\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11&_?(HL&\'c\"\r\nSET miniWorldMap \"0\"\r\nSET cameraSavedDistance \"10.550000\"\r\nSET closedInfoFrames \"PABL@@@@@@@@@@@@@@@@@@@@@@B\"\r\nSET trackedAchievements \"v11\"\r\n'),
(10,12,1762842826,'1\n0\n1\n1 0 3 1\n4 0 3 2\nEND\n'),
(10,14,1762842826,'1 1 2 1 1 1\0'),
(11,1,1762802494,'SET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"24\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"23.084801\"\r\nSET EJLootClass \"7\"\r\nSET enableMultiActionBars \"19\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11\"\r\nSET cameraSavedVehicleDistance \"49.999981\"\r\nSET cameraSavedDistance \"23.519930\"\r\nSET closedInfoFrames \"\"\r\nSET trackedAchievements \"v11\"\r\n'),
(11,7,1762667357,'VERSION 9\n\nADDEDVERSION 27\n\nCHANNELS\n1 0 1 1\n2 0 2 1\n22 0 3 1\n42 0 4 1\nEND\n\nZONECHANNELS 0\n\nCOLORS\n\nSYSTEM 255 255 0 N\nSAY 255 255 255 N\nPARTY 170 170 255 N\nRAID 255 127 0 N\nGUILD 64 255 64 N\nOFFICER 64 192 64 N\nYELL 255 64 64 N\nWHISPER 255 128 255 N\nWHISPER_FOREIGN 255 128 255 N\nWHISPER_INFORM 255 128 255 N\nEMOTE 255 128 64 N\nTEXT_EMOTE 255 128 64 N\nMONSTER_SAY 255 255 159 N\nMONSTER_PARTY 170 170 255 N\nMONSTER_YELL 255 64 64 N\nMONSTER_WHISPER 255 181 235 N\nMONSTER_EMOTE 255 128 64 N\nCHANNEL 255 192 192 N\nCHANNEL_JOIN 192 128 128 N\nCHANNEL_LEAVE 192 128 128 N\nCHANNEL_LIST 192 128 128 N\nCHANNEL_NOTICE 192 192 192 N\nCHANNEL_NOTICE_USER 192 192 192 N\nAFK 255 128 255 N\nDND 255 128 255 N\nIGNORED 255 0 0 N\nSKILL 85 85 255 N\nLOOT 0 170 0 N\nMONEY 255 255 0 N\nOPENING 128 128 255 N\nTRADESKILLS 255 255 255 N\nPET_INFO 128 128 255 N\nCOMBAT_MISC_INFO 128 128 255 N\nCOMBAT_XP_GAIN 111 111 255 N\nCOMBAT_HONOR_GAIN 224 202 10 N\nCOMBAT_FACTION_CHANGE 128 128 255 N\nBG_SYSTEM_NEUTRAL 255 120 10 N\nBG_SYSTEM_ALLIANCE 0 174 239 N\nBG_SYSTEM_HORDE 255 0 0 N\nRAID_LEADER 255 72 9 N\nRAID_WARNING 255 72 0 N\nRAID_BOSS_EMOTE 255 221 0 N\nRAID_BOSS_WHISPER 255 221 0 N\nFILTERED 255 0 0 N\nRESTRICTED 255 0 0 N\nBATTLENET 255 255 255 N\nACHIEVEMENT 255 255 0 N\nGUILD_ACHIEVEMENT 64 255 64 N\nARENA_POINTS 255 255 255 N\nPARTY_LEADER 118 200 255 N\nTARGETICONS 255 255 0 N\nBN_WHISPER 0 255 246 N\nBN_WHISPER_INFORM 0 255 246 N\nBN_INLINE_TOAST_ALERT 130 197 255 N\nBN_INLINE_TOAST_BROADCAST 130 197 255 N\nBN_INLINE_TOAST_BROADCAST_INFORM 130 197 255 N\nBN_INLINE_TOAST_CONVERSATION 130 197 255 N\nBN_WHISPER_PLAYER_OFFLINE 255 255 0 N\nCURRENCY 0 170 0 N\nQUEST_BOSS_EMOTE 255 128 64 N\nPET_BATTLE_COMBAT_LOG 231 222 171 N\nPET_BATTLE_INFO 225 222 93 N\nINSTANCE_CHAT 255 127 0 N\nINSTANCE_CHAT_LEADER 255 72 9 N\nGUILD_ITEM_LOOTED 64 255 64 N\nCOMMUNITIES_CHANNEL 255 192 192 N\nVOICE_TEXT 158 255 252 N\nPING 170 170 255 N\nCHANNEL1 255 192 192 N\nCHANNEL2 255 192 192 N\nCHANNEL3 255 192 192 N\nCHANNEL4 255 192 192 N\nCHANNEL5 255 192 192 N\nCHANNEL6 255 192 192 N\nCHANNEL7 255 192 192 N\nCHANNEL8 255 192 192 N\nCHANNEL9 255 192 192 N\nCHANNEL10 255 192 192 N\nCHANNEL11 255 192 192 N\nCHANNEL12 255 192 192 N\nCHANNEL13 255 192 192 N\nCHANNEL14 255 192 192 N\nCHANNEL15 255 192 192 N\nCHANNEL16 255 192 192 N\nCHANNEL17 255 192 192 N\nCHANNEL18 255 192 192 N\nCHANNEL19 255 192 192 N\nCHANNEL20 255 192 192 N\nEND\n\nWINDOW 1\nNAME General\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 1\nSHOWN 1\nMESSAGES\nSYSTEM\nSYSTEM_NOMENU\nSAY\nEMOTE\nYELL\nWHISPER\nPARTY\nPARTY_LEADER\nRAID\nRAID_LEADER\nRAID_WARNING\nGUILD\nOFFICER\nMONSTER_SAY\nMONSTER_YELL\nMONSTER_EMOTE\nMONSTER_WHISPER\nMONSTER_BOSS_EMOTE\nMONSTER_BOSS_WHISPER\nERRORS\nAFK\nDND\nIGNORED\nBG_HORDE\nBG_ALLIANCE\nBG_NEUTRAL\nCOMBAT_FACTION_CHANGE\nSKILL\nLOOT\nMONEY\nCHANNEL\nACHIEVEMENT\nGUILD_ACHIEVEMENT\nBN_WHISPER\nBN_WHISPER_INFORM\nBN_CONVERSATION\nBN_INLINE_TOAST_ALERT\nCURRENCY\nBN_WHISPER_PLAYER_OFFLINE\nPET_BATTLE_INFO\nINSTANCE_CHAT\nINSTANCE_CHAT_LEADER\nGUILD_ITEM_LOOTED\nCOMBAT_HONOR_GAIN\nPING\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 2265597345795\n\nEND\n\nWINDOW 2\nNAME Combat Log\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 2\nSHOWN 0\nMESSAGES\nOPENING\nTRADESKILLS\nPET_INFO\nCOMBAT_XP_GAIN\nCOMBAT_HONOR_GAIN\nCOMBAT_MISC_INFO\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 3\nNAME Voice\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nVOICE_TEXT\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 4\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 5\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 6\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 7\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 8\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 9\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 10\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\n'),
(11,9,1762667357,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(11,11,1762667357,'2\0'),
(11,12,1762667357,'1\n0\n'),
(11,14,1762667357,'1 2 2 2 2 2\0'),
(12,1,1762738532,'SET autoQuestPopUps \"v11\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET NamePlateHorizontalScale \"1\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET nameplateShowFriends \"1\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"24\"\r\nSET nameplateShowAll \"1\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"11.479942\"\r\nSET EJLootClass \"5\"\r\nSET enableMultiActionBars \"15\"\r\nSET numCurrencyCategories \"21\"\r\nSET NamePlateClassificationScale \"1\"\r\nSET hardTrackedQuests \"v11#,\"\r\nSET cameraSavedDistance \"6.499892\"\r\nSET closedInfoFrames \"@@B@@@@@@@@@@@@@@@@@@@@@@@B\"\r\nSET NamePlateVerticalScale \"1\"\r\nSET trackedAchievements \"v11\"\r\n'),
(12,14,1762675818,'1 -1 -1 -1 -1 -1\0'),
(13,1,1762822336,'SET latestSplashScreen \"86\"\r\nSET autoQuestPopUps \"v11\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"24\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"39.944172\"\r\nSET EJLootClass \"11\"\r\nSET enableMultiActionBars \"1\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11)KQ,g^&_?+k&\"\r\nSET maxLevelSpecsUsed \"A\"\r\nSET cameraSavedDistance \"13.500002\"\r\nSET closedInfoFrames \"@@B@@@@@@@@@@@@@@@@@@@@@@`B\"\r\nSET trackedAchievements \"v11\"\r\n'),
(13,7,1762820243,'VERSION 9\n\nADDEDVERSION 27\n\nCHANNELS\n1 0 1 1\n2 0 2 1\n22 0 3 1\n42 0 4 1\nEND\n\nZONECHANNELS 0\n\nCOLORS\n\nSYSTEM 255 255 0 N\nSAY 255 255 255 N\nPARTY 170 170 255 N\nRAID 255 127 0 N\nGUILD 64 255 64 N\nOFFICER 64 192 64 N\nYELL 255 64 64 N\nWHISPER 255 128 255 N\nWHISPER_FOREIGN 255 128 255 N\nWHISPER_INFORM 255 128 255 N\nEMOTE 255 128 64 N\nTEXT_EMOTE 255 128 64 N\nMONSTER_SAY 255 255 159 N\nMONSTER_PARTY 170 170 255 N\nMONSTER_YELL 255 64 64 N\nMONSTER_WHISPER 255 181 235 N\nMONSTER_EMOTE 255 128 64 N\nCHANNEL 255 192 192 N\nCHANNEL_JOIN 192 128 128 N\nCHANNEL_LEAVE 192 128 128 N\nCHANNEL_LIST 192 128 128 N\nCHANNEL_NOTICE 192 192 192 N\nCHANNEL_NOTICE_USER 192 192 192 N\nAFK 255 128 255 N\nDND 255 128 255 N\nIGNORED 255 0 0 N\nSKILL 85 85 255 N\nLOOT 0 170 0 N\nMONEY 255 255 0 N\nOPENING 128 128 255 N\nTRADESKILLS 255 255 255 N\nPET_INFO 128 128 255 N\nCOMBAT_MISC_INFO 128 128 255 N\nCOMBAT_XP_GAIN 111 111 255 N\nCOMBAT_HONOR_GAIN 224 202 10 N\nCOMBAT_FACTION_CHANGE 128 128 255 N\nBG_SYSTEM_NEUTRAL 255 120 10 N\nBG_SYSTEM_ALLIANCE 0 174 239 N\nBG_SYSTEM_HORDE 255 0 0 N\nRAID_LEADER 255 72 9 N\nRAID_WARNING 255 72 0 N\nRAID_BOSS_EMOTE 255 221 0 N\nRAID_BOSS_WHISPER 255 221 0 N\nFILTERED 255 0 0 N\nRESTRICTED 255 0 0 N\nBATTLENET 255 255 255 N\nACHIEVEMENT 255 255 0 N\nGUILD_ACHIEVEMENT 64 255 64 N\nARENA_POINTS 255 255 255 N\nPARTY_LEADER 118 200 255 N\nTARGETICONS 255 255 0 N\nBN_WHISPER 0 255 246 N\nBN_WHISPER_INFORM 0 255 246 N\nBN_INLINE_TOAST_ALERT 130 197 255 N\nBN_INLINE_TOAST_BROADCAST 130 197 255 N\nBN_INLINE_TOAST_BROADCAST_INFORM 130 197 255 N\nBN_INLINE_TOAST_CONVERSATION 130 197 255 N\nBN_WHISPER_PLAYER_OFFLINE 255 255 0 N\nCURRENCY 0 170 0 N\nQUEST_BOSS_EMOTE 255 128 64 N\nPET_BATTLE_COMBAT_LOG 231 222 171 N\nPET_BATTLE_INFO 225 222 93 N\nINSTANCE_CHAT 255 127 0 N\nINSTANCE_CHAT_LEADER 255 72 9 N\nGUILD_ITEM_LOOTED 64 255 64 N\nCOMMUNITIES_CHANNEL 255 192 192 N\nVOICE_TEXT 158 255 252 N\nPING 170 170 255 N\nCHANNEL1 255 192 192 N\nCHANNEL2 255 192 192 N\nCHANNEL3 255 192 192 N\nCHANNEL4 255 192 192 N\nCHANNEL5 255 192 192 N\nCHANNEL6 255 192 192 N\nCHANNEL7 255 192 192 N\nCHANNEL8 255 192 192 N\nCHANNEL9 255 192 192 N\nCHANNEL10 255 192 192 N\nCHANNEL11 255 192 192 N\nCHANNEL12 255 192 192 N\nCHANNEL13 255 192 192 N\nCHANNEL14 255 192 192 N\nCHANNEL15 255 192 192 N\nCHANNEL16 255 192 192 N\nCHANNEL17 255 192 192 N\nCHANNEL18 255 192 192 N\nCHANNEL19 255 192 192 N\nCHANNEL20 255 192 192 N\nEND\n\nWINDOW 1\nNAME General\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 1\nSHOWN 1\nMESSAGES\nSYSTEM\nSYSTEM_NOMENU\nSAY\nEMOTE\nYELL\nWHISPER\nPARTY\nPARTY_LEADER\nRAID\nRAID_LEADER\nRAID_WARNING\nGUILD\nOFFICER\nMONSTER_SAY\nMONSTER_YELL\nMONSTER_EMOTE\nMONSTER_WHISPER\nMONSTER_BOSS_EMOTE\nMONSTER_BOSS_WHISPER\nERRORS\nAFK\nDND\nIGNORED\nBG_HORDE\nBG_ALLIANCE\nBG_NEUTRAL\nCOMBAT_FACTION_CHANGE\nSKILL\nLOOT\nMONEY\nCHANNEL\nACHIEVEMENT\nGUILD_ACHIEVEMENT\nBN_WHISPER\nBN_WHISPER_INFORM\nBN_CONVERSATION\nBN_INLINE_TOAST_ALERT\nCURRENCY\nBN_WHISPER_PLAYER_OFFLINE\nPET_BATTLE_INFO\nINSTANCE_CHAT\nINSTANCE_CHAT_LEADER\nGUILD_ITEM_LOOTED\nCOMBAT_HONOR_GAIN\nPING\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 2265597345795\n\nEND\n\nWINDOW 2\nNAME Combat Log\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 2\nSHOWN 0\nMESSAGES\nOPENING\nTRADESKILLS\nPET_INFO\nCOMBAT_XP_GAIN\nCOMBAT_HONOR_GAIN\nCOMBAT_MISC_INFO\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 3\nNAME Voice\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nVOICE_TEXT\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 4\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 5\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 6\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 7\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 8\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 9\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 10\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\n'),
(13,9,1762820243,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(13,11,1762820243,'2\0'),
(13,12,1762822336,'1\n0\n0\n1 0 3 1\n4 0 3 2\nEND\n'),
(13,14,1762822336,'1 2 2 2 2 2\0'),
(14,1,1762829711,'SET latestSplashScreen \"74\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"23\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"13.159530\"\r\nSET EJLootClass \"13\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11*QN\"\r\nSET cameraSavedDistance \"24.550005\"\r\nSET closedInfoFrames \"@@B\"\r\nSET trackedAchievements \"v11\"\r\n'),
(14,9,1762829711,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(14,11,1762829711,'2\0'),
(14,12,1762829711,'1\n0\n'),
(14,14,1762829711,'1 -1 -1 -1 -1 -1\0'),
(15,1,1762834234,'SET autoQuestPopUps \"v11\"\r\nSET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"24\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"16.276155\"\r\nSET EJLootClass \"8\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11%p.\"\r\nSET closedInfoFrames \"@@B\"\r\nSET trackedAchievements \"v11\"\r\n'),
(15,7,1762834234,'VERSION 9\n\nADDEDVERSION 27\n\nCHANNELS\n1 0 1 1\n2 0 2 1\n22 0 3 1\n42 0 4 1\nEND\n\nZONECHANNELS 0\n\nCOLORS\n\nSYSTEM 255 255 0 N\nSAY 255 255 255 N\nPARTY 170 170 255 N\nRAID 255 127 0 N\nGUILD 64 255 64 N\nOFFICER 64 192 64 N\nYELL 255 64 64 N\nWHISPER 255 128 255 N\nWHISPER_FOREIGN 255 128 255 N\nWHISPER_INFORM 255 128 255 N\nEMOTE 255 128 64 N\nTEXT_EMOTE 255 128 64 N\nMONSTER_SAY 255 255 159 N\nMONSTER_PARTY 170 170 255 N\nMONSTER_YELL 255 64 64 N\nMONSTER_WHISPER 255 181 235 N\nMONSTER_EMOTE 255 128 64 N\nCHANNEL 255 192 192 N\nCHANNEL_JOIN 192 128 128 N\nCHANNEL_LEAVE 192 128 128 N\nCHANNEL_LIST 192 128 128 N\nCHANNEL_NOTICE 192 192 192 N\nCHANNEL_NOTICE_USER 192 192 192 N\nAFK 255 128 255 N\nDND 255 128 255 N\nIGNORED 255 0 0 N\nSKILL 85 85 255 N\nLOOT 0 170 0 N\nMONEY 255 255 0 N\nOPENING 128 128 255 N\nTRADESKILLS 255 255 255 N\nPET_INFO 128 128 255 N\nCOMBAT_MISC_INFO 128 128 255 N\nCOMBAT_XP_GAIN 111 111 255 N\nCOMBAT_HONOR_GAIN 224 202 10 N\nCOMBAT_FACTION_CHANGE 128 128 255 N\nBG_SYSTEM_NEUTRAL 255 120 10 N\nBG_SYSTEM_ALLIANCE 0 174 239 N\nBG_SYSTEM_HORDE 255 0 0 N\nRAID_LEADER 255 72 9 N\nRAID_WARNING 255 72 0 N\nRAID_BOSS_EMOTE 255 221 0 N\nRAID_BOSS_WHISPER 255 221 0 N\nFILTERED 255 0 0 N\nRESTRICTED 255 0 0 N\nBATTLENET 255 255 255 N\nACHIEVEMENT 255 255 0 N\nGUILD_ACHIEVEMENT 64 255 64 N\nARENA_POINTS 255 255 255 N\nPARTY_LEADER 118 200 255 N\nTARGETICONS 255 255 0 N\nBN_WHISPER 0 255 246 N\nBN_WHISPER_INFORM 0 255 246 N\nBN_INLINE_TOAST_ALERT 130 197 255 N\nBN_INLINE_TOAST_BROADCAST 130 197 255 N\nBN_INLINE_TOAST_BROADCAST_INFORM 130 197 255 N\nBN_INLINE_TOAST_CONVERSATION 130 197 255 N\nBN_WHISPER_PLAYER_OFFLINE 255 255 0 N\nCURRENCY 0 170 0 N\nQUEST_BOSS_EMOTE 255 128 64 N\nPET_BATTLE_COMBAT_LOG 231 222 171 N\nPET_BATTLE_INFO 225 222 93 N\nINSTANCE_CHAT 255 127 0 N\nINSTANCE_CHAT_LEADER 255 72 9 N\nGUILD_ITEM_LOOTED 64 255 64 N\nCOMMUNITIES_CHANNEL 255 192 192 N\nVOICE_TEXT 158 255 252 N\nPING 170 170 255 N\nCHANNEL1 255 192 192 N\nCHANNEL2 255 192 192 N\nCHANNEL3 255 192 192 N\nCHANNEL4 255 192 192 N\nCHANNEL5 255 192 192 N\nCHANNEL6 255 192 192 N\nCHANNEL7 255 192 192 N\nCHANNEL8 255 192 192 N\nCHANNEL9 255 192 192 N\nCHANNEL10 255 192 192 N\nCHANNEL11 255 192 192 N\nCHANNEL12 255 192 192 N\nCHANNEL13 255 192 192 N\nCHANNEL14 255 192 192 N\nCHANNEL15 255 192 192 N\nCHANNEL16 255 192 192 N\nCHANNEL17 255 192 192 N\nCHANNEL18 255 192 192 N\nCHANNEL19 255 192 192 N\nCHANNEL20 255 192 192 N\nEND\n\nWINDOW 1\nNAME General\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 1\nSHOWN 1\nMESSAGES\nSYSTEM\nSYSTEM_NOMENU\nSAY\nEMOTE\nYELL\nWHISPER\nPARTY\nPARTY_LEADER\nRAID\nRAID_LEADER\nRAID_WARNING\nGUILD\nOFFICER\nMONSTER_SAY\nMONSTER_YELL\nMONSTER_EMOTE\nMONSTER_WHISPER\nMONSTER_BOSS_EMOTE\nMONSTER_BOSS_WHISPER\nERRORS\nAFK\nDND\nIGNORED\nBG_HORDE\nBG_ALLIANCE\nBG_NEUTRAL\nCOMBAT_FACTION_CHANGE\nSKILL\nLOOT\nMONEY\nCHANNEL\nACHIEVEMENT\nGUILD_ACHIEVEMENT\nBN_WHISPER\nBN_WHISPER_INFORM\nBN_CONVERSATION\nBN_INLINE_TOAST_ALERT\nCURRENCY\nBN_WHISPER_PLAYER_OFFLINE\nPET_BATTLE_INFO\nINSTANCE_CHAT\nINSTANCE_CHAT_LEADER\nGUILD_ITEM_LOOTED\nCOMBAT_HONOR_GAIN\nPING\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 2265597345795\n\nEND\n\nWINDOW 2\nNAME Combat Log\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 2\nSHOWN 0\nMESSAGES\nOPENING\nTRADESKILLS\nPET_INFO\nCOMBAT_XP_GAIN\nCOMBAT_HONOR_GAIN\nCOMBAT_MISC_INFO\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 3\nNAME Voice\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nVOICE_TEXT\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 4\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 5\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 6\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 7\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 8\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 9\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 10\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\n'),
(15,9,1762834234,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(15,11,1762834234,'2\0'),
(15,12,1762834234,'1\n0\n'),
(15,14,1762834234,'1 -1 -1 -1 -1 -1\0'),
(16,1,1762835840,'SET collapsedCurrencyCategoryDefaults \"v11#%j##t##8#$K##\'#$U##9##%#%s##:#%^#$O##$#%c#$S##&\"\r\nSET enableMouseoverCast \"1\"\r\nSET trackedProfessionRecipes \"v11\"\r\nSET hardTrackedWorldQuests \"v11\"\r\nSET currencyCategoriesCollapsed \"v11##&##8#$O#%s#%^##%#$K##$#$S#%j##9#%c##\'##t##:#$U\"\r\nSET trackedPerksActivities \"v11\"\r\nSET trackedProfessionRecraftRecipes \"v11\"\r\nSET raidFramesDisplayClassColor \"1\"\r\nSET raidFramesHealthText \"perc\"\r\nSET autoLootDefault \"1\"\r\nSET trackedWorldQuests \"v11\"\r\nSET minimapShapeshiftTracking \"v11\"\r\nSET reputationsCollapsed \"v11#/%\"\r\nSET numReputationHeaders \"24\"\r\nSET nameplateShowFriendlyBuffs \"1\"\r\nSET collapsedReputationHeaderDefaults \"v11#/X#>|#6f#.m#-U#9]#0G#<|#={#2T#/Q#/%\"\r\nSET cameraSavedPitch \"15.357736\"\r\nSET raidOptionDisplayPets \"1\"\r\nSET EJLootClass \"2\"\r\nSET enableMultiActionBars \"7\"\r\nSET numCurrencyCategories \"21\"\r\nSET hardTrackedQuests \"v11)OS\"\r\nSET cameraSavedDistance \"16.550007\"\r\nSET raidFramesDisplayPowerBars \"1\"\r\nSET closedInfoFrames \"@@@@@@@@@@@@@@@@@@@@@@@@@@B\"\r\nSET trackedAchievements \"v11\"\r\n'),
(16,7,1762834935,'VERSION 9\n\nADDEDVERSION 27\n\nCHANNELS\n1 0 1 1\n2 0 2 1\n22 0 3 1\n42 0 4 1\nEND\n\nZONECHANNELS 0\n\nCOLORS\n\nSYSTEM 255 255 0 N\nSAY 255 255 255 N\nPARTY 170 170 255 N\nRAID 255 127 0 N\nGUILD 64 255 64 N\nOFFICER 64 192 64 N\nYELL 255 64 64 N\nWHISPER 255 128 255 N\nWHISPER_FOREIGN 255 128 255 N\nWHISPER_INFORM 255 128 255 N\nEMOTE 255 128 64 N\nTEXT_EMOTE 255 128 64 N\nMONSTER_SAY 255 255 159 N\nMONSTER_PARTY 170 170 255 N\nMONSTER_YELL 255 64 64 N\nMONSTER_WHISPER 255 181 235 N\nMONSTER_EMOTE 255 128 64 N\nCHANNEL 255 192 192 N\nCHANNEL_JOIN 192 128 128 N\nCHANNEL_LEAVE 192 128 128 N\nCHANNEL_LIST 192 128 128 N\nCHANNEL_NOTICE 192 192 192 N\nCHANNEL_NOTICE_USER 192 192 192 N\nAFK 255 128 255 N\nDND 255 128 255 N\nIGNORED 255 0 0 N\nSKILL 85 85 255 N\nLOOT 0 170 0 N\nMONEY 255 255 0 N\nOPENING 128 128 255 N\nTRADESKILLS 255 255 255 N\nPET_INFO 128 128 255 N\nCOMBAT_MISC_INFO 128 128 255 N\nCOMBAT_XP_GAIN 111 111 255 N\nCOMBAT_HONOR_GAIN 224 202 10 N\nCOMBAT_FACTION_CHANGE 128 128 255 N\nBG_SYSTEM_NEUTRAL 255 120 10 N\nBG_SYSTEM_ALLIANCE 0 174 239 N\nBG_SYSTEM_HORDE 255 0 0 N\nRAID_LEADER 255 72 9 N\nRAID_WARNING 255 72 0 N\nRAID_BOSS_EMOTE 255 221 0 N\nRAID_BOSS_WHISPER 255 221 0 N\nFILTERED 255 0 0 N\nRESTRICTED 255 0 0 N\nBATTLENET 255 255 255 N\nACHIEVEMENT 255 255 0 N\nGUILD_ACHIEVEMENT 64 255 64 N\nARENA_POINTS 255 255 255 N\nPARTY_LEADER 118 200 255 N\nTARGETICONS 255 255 0 N\nBN_WHISPER 0 255 246 N\nBN_WHISPER_INFORM 0 255 246 N\nBN_INLINE_TOAST_ALERT 130 197 255 N\nBN_INLINE_TOAST_BROADCAST 130 197 255 N\nBN_INLINE_TOAST_BROADCAST_INFORM 130 197 255 N\nBN_INLINE_TOAST_CONVERSATION 130 197 255 N\nBN_WHISPER_PLAYER_OFFLINE 255 255 0 N\nCURRENCY 0 170 0 N\nQUEST_BOSS_EMOTE 255 128 64 N\nPET_BATTLE_COMBAT_LOG 231 222 171 N\nPET_BATTLE_INFO 225 222 93 N\nINSTANCE_CHAT 255 127 0 N\nINSTANCE_CHAT_LEADER 255 72 9 N\nGUILD_ITEM_LOOTED 64 255 64 N\nCOMMUNITIES_CHANNEL 255 192 192 N\nVOICE_TEXT 158 255 252 N\nPING 170 170 255 N\nCHANNEL1 255 192 192 N\nCHANNEL2 255 192 192 N\nCHANNEL3 255 192 192 N\nCHANNEL4 255 192 192 N\nCHANNEL5 255 192 192 N\nCHANNEL6 255 192 192 N\nCHANNEL7 255 192 192 N\nCHANNEL8 255 192 192 N\nCHANNEL9 255 192 192 N\nCHANNEL10 255 192 192 N\nCHANNEL11 255 192 192 N\nCHANNEL12 255 192 192 N\nCHANNEL13 255 192 192 N\nCHANNEL14 255 192 192 N\nCHANNEL15 255 192 192 N\nCHANNEL16 255 192 192 N\nCHANNEL17 255 192 192 N\nCHANNEL18 255 192 192 N\nCHANNEL19 255 192 192 N\nCHANNEL20 255 192 192 N\nEND\n\nWINDOW 1\nNAME General\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 1\nSHOWN 1\nMESSAGES\nSYSTEM\nSYSTEM_NOMENU\nSAY\nEMOTE\nYELL\nWHISPER\nPARTY\nPARTY_LEADER\nRAID\nRAID_LEADER\nRAID_WARNING\nGUILD\nOFFICER\nMONSTER_SAY\nMONSTER_YELL\nMONSTER_EMOTE\nMONSTER_WHISPER\nMONSTER_BOSS_EMOTE\nMONSTER_BOSS_WHISPER\nERRORS\nAFK\nDND\nIGNORED\nBG_HORDE\nBG_ALLIANCE\nBG_NEUTRAL\nCOMBAT_FACTION_CHANGE\nSKILL\nLOOT\nMONEY\nCHANNEL\nACHIEVEMENT\nGUILD_ACHIEVEMENT\nBN_WHISPER\nBN_WHISPER_INFORM\nBN_CONVERSATION\nBN_INLINE_TOAST_ALERT\nCURRENCY\nBN_WHISPER_PLAYER_OFFLINE\nPET_BATTLE_INFO\nINSTANCE_CHAT\nINSTANCE_CHAT_LEADER\nGUILD_ITEM_LOOTED\nCOMBAT_HONOR_GAIN\nPING\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 2265597345795\n\nEND\n\nWINDOW 2\nNAME Combat Log\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 2\nSHOWN 0\nMESSAGES\nOPENING\nTRADESKILLS\nPET_INFO\nCOMBAT_XP_GAIN\nCOMBAT_HONOR_GAIN\nCOMBAT_MISC_INFO\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 3\nNAME Voice\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nVOICE_TEXT\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 4\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 5\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 6\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 7\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 8\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 9\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\nWINDOW 10\nSIZE 0\nCOLOR 0 0 0 40\nLOCKED 1\nUNINTERACTABLE 0\nDOCKED 0\nSHOWN 0\nMESSAGES\nEND\n\nCHANNELS\nEND\n\nZONECHANNELS 0\n\nEND\n\n'),
(16,9,1762834935,'3\n1\n15\r\n14126315937103613183\r\n8\r\n0\r\n1\r\n0\r\n100\r\n'),
(16,11,1762834935,'2\0'),
(16,12,1762834935,'1\n0\n'),
(16,14,1762834935,'1 -1 -1 -1 -1 -1\0');
/*!40000 ALTER TABLE `character_account_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_achievement`
--

DROP TABLE IF EXISTS `character_achievement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_achievement` (
  `guid` bigint(20) unsigned NOT NULL,
  `achievement` int(10) unsigned NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`achievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_achievement`
--

LOCK TABLES `character_achievement` WRITE;
/*!40000 ALTER TABLE `character_achievement` DISABLE KEYS */;
INSERT INTO `character_achievement` VALUES
(3,13149,1762259287),
(3,13166,1762259287),
(3,13167,1762259287),
(3,13169,1762259287),
(3,13170,1762259287),
(3,14221,1762262035),
(3,14223,1762262032),
(3,17730,1762259287),
(4,13149,1762363964),
(4,13166,1762363964),
(4,13167,1762363964),
(4,13169,1762363964),
(4,13170,1762363964),
(4,17730,1762363964),
(6,13149,1762386258),
(6,13166,1762386258),
(6,13167,1762386258),
(6,13169,1762386258),
(6,13170,1762386258),
(6,14221,1762388119),
(6,17730,1762386258),
(7,6,1762831456),
(7,842,1762883538),
(7,889,1762831456),
(7,891,1762831456),
(7,1998,1762837444),
(7,10050,1762831017),
(7,10051,1762831024),
(7,13149,1762644935),
(7,13166,1762644935),
(7,13167,1762644935),
(7,13169,1762644935),
(7,13170,1762644935),
(7,14221,1762645648),
(7,14223,1762645641),
(7,16520,1762833563),
(7,16681,1762833563),
(7,17730,1762644935),
(7,40172,1762831456),
(7,40173,1762883883),
(8,6,1762656608),
(8,776,1762658572),
(8,889,1762656608),
(8,891,1762656608),
(8,1017,1762651626),
(8,13149,1762646101),
(8,13166,1762646101),
(8,13167,1762646101),
(8,13169,1762646101),
(8,13170,1762646101),
(8,14221,1762651395),
(8,14223,1762653279),
(8,16520,1762664091),
(8,16681,1762664091),
(8,17730,1762646101),
(8,40172,1762656608),
(10,6,1762665611),
(10,842,1762846774),
(10,889,1762665611),
(10,891,1762665611),
(10,1017,1762844936),
(10,10050,1762661966),
(10,13149,1762649104),
(10,13166,1762649104),
(10,13167,1762649104),
(10,13169,1762649104),
(10,13170,1762649104),
(10,14221,1762650961),
(10,14223,1762662457),
(10,16520,1762828966),
(10,16681,1762828966),
(10,17730,1762649104),
(10,40172,1762665611),
(10,40173,1762846923),
(11,1017,1762667356),
(11,13149,1762667356),
(11,13166,1762667356),
(11,13167,1762667356),
(11,13169,1762667356),
(11,13170,1762667356),
(11,14221,1762668407),
(11,14223,1762668419),
(11,17730,1762667356),
(12,13149,1762675817),
(12,13166,1762675817),
(12,13167,1762675817),
(12,13169,1762675817),
(12,13170,1762675817),
(12,14221,1762738804),
(12,17730,1762675817),
(13,6,1762821250),
(13,7,1762821250),
(13,8,1762821250),
(13,9,1762821250),
(13,842,1762821461),
(13,889,1762821250),
(13,890,1762821250),
(13,891,1762821250),
(13,5180,1762821250),
(13,13065,1762821250),
(13,13066,1762821250),
(13,13067,1762821250),
(13,13068,1762821250),
(13,13073,1762821250),
(13,13149,1762820242),
(13,13152,1762822335),
(13,13155,1762822335),
(13,13166,1762820242),
(13,13167,1762820242),
(13,13169,1762820242),
(13,13170,1762820242),
(13,14782,1762821250),
(13,14783,1762821250),
(13,14884,1762821250),
(13,15805,1762821250),
(13,16520,1762822335),
(13,16681,1762822335),
(13,17730,1762820242),
(13,17788,1762822335),
(13,18394,1762822335),
(13,19459,1762821250),
(13,19467,1762821250),
(13,19470,1762821250),
(13,19510,1762821250),
(13,40172,1762821250),
(13,40173,1762821250),
(13,40174,1762821250),
(13,40175,1762821250),
(13,40176,1762821250),
(13,40177,1762821250),
(13,40178,1762821250),
(13,40179,1762821250),
(13,40180,1762821250),
(13,40181,1762821250),
(13,40182,1762821250),
(13,40857,1762821250),
(14,6,1762829710),
(14,889,1762829648),
(14,891,1762829648),
(14,13149,1762829710),
(14,13166,1762829710),
(14,13167,1762829710),
(14,13169,1762829710),
(14,13170,1762829710),
(14,16681,1762829710),
(14,17730,1762829710),
(14,40172,1762829710),
(14,40886,1762829648),
(15,13149,1762834233),
(15,13166,1762834233),
(15,13167,1762834233),
(15,13169,1762834233),
(15,13170,1762834233),
(15,17730,1762834233),
(16,13149,1762834934),
(16,13166,1762834934),
(16,13167,1762834934),
(16,13169,1762834934),
(16,13170,1762834934),
(16,17730,1762834934);
/*!40000 ALTER TABLE `character_achievement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_achievement_progress`
--

DROP TABLE IF EXISTS `character_achievement_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_achievement_progress` (
  `guid` bigint(20) unsigned NOT NULL,
  `criteria` int(10) unsigned NOT NULL,
  `counter` bigint(20) unsigned NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`criteria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_achievement_progress`
--

LOCK TABLES `character_achievement_progress` WRITE;
/*!40000 ALTER TABLE `character_achievement_progress` DISABLE KEYS */;
INSERT INTO `character_achievement_progress` VALUES
(3,167,1,1762259266),
(3,641,1,1762259266),
(3,655,1,1762259266),
(3,656,1,1762259266),
(3,753,1,1762259266),
(3,754,1,1762259266),
(3,755,1,1762259266),
(3,834,1,1762259266),
(3,2020,200,1762259287),
(3,3631,20,1762364045),
(3,4091,928,1762262052),
(3,4092,5575,1762364045),
(3,4093,200,1762260777),
(3,4224,6678,1762364045),
(3,4787,2,1762259266),
(3,4944,36,1762364441),
(3,4948,11,1762364441),
(3,4953,23,1762260775),
(3,4954,1,1762259401),
(3,4958,1,1762260310),
(3,5212,6,1762260703),
(3,5328,3100,1762259287),
(3,5329,3100,1762259287),
(3,5330,3100,1762259287),
(3,5331,4000,1762259287),
(3,5332,3100,1762259287),
(3,5529,37,1762364441),
(3,6789,5,1762642075),
(3,8819,500,1762259287),
(3,8820,500,1762259287),
(3,8821,500,1762259287),
(3,8822,500,1762259287),
(3,19395,3000,1762259287),
(3,19481,3100,1762259287),
(3,22926,3000,1762259287),
(3,23250,5,1762642075),
(3,25828,3000,1762259287),
(3,28981,3000,1762259287),
(3,30566,1,1762259287),
(3,30569,1,1762259287),
(3,30570,3,1762260958),
(3,30571,1,1762259287),
(3,30572,1,1762260404),
(3,30573,1,1762259287),
(3,30574,8,1762260958),
(3,30575,1,1762259287),
(3,30576,1,1762262032),
(3,30579,1,1762259287),
(3,35977,3000,1762259287),
(3,37604,3000,1762259287),
(3,41654,3000,1762259287),
(3,43157,1,1762259287),
(3,43205,1,1762259287),
(3,43206,1,1762259287),
(3,43211,1,1762259287),
(3,43215,1,1762259287),
(3,44103,2000,1762259287),
(3,44104,2000,1762259287),
(3,44106,3300,1762259287),
(3,44110,2800,1762259287),
(3,47940,1,1762262035),
(3,48159,1,1762262032),
(3,55295,100,1762259287),
(3,59075,1,1762259287),
(3,64511,6,1762260703),
(3,102751,3000,1762259287),
(3,102752,3000,1762259287),
(3,102753,3000,1762259287),
(3,102754,3000,1762259287),
(3,106462,3000,1762259287),
(3,106463,3000,1762259287),
(3,106464,3000,1762259287),
(3,106465,3000,1762259287),
(4,167,1,1762363952),
(4,653,1,1762363952),
(4,657,1,1762363952),
(4,753,1,1762363952),
(4,757,40,1762722463),
(4,1552,1,1762363965),
(4,1553,1,1762369281),
(4,1554,1,1762370029),
(4,1557,1,1762401635),
(4,1559,1,1762369653),
(4,1560,1,1762401946),
(4,1565,1,1762401831),
(4,1566,1,1762370184),
(4,1576,1,1762723986),
(4,1578,1,1762403057),
(4,1579,1,1762402190),
(4,1580,1,1762401659),
(4,1585,1,1762722863),
(4,1590,1,1762723094),
(4,1593,1,1762722650),
(4,1598,1,1762402231),
(4,2020,200,1762363964),
(4,2072,1914,1762400553),
(4,2104,1,1762724175),
(4,3356,105,1762724524),
(4,3631,29,1762722965),
(4,4092,6760,1762722814),
(4,4093,6,1762401505),
(4,4224,6766,1762722814),
(4,4742,3000,1762363964),
(4,4762,3500,1762363964),
(4,4944,161,1762724291),
(4,4946,121,1762724291),
(4,4948,18,1762723588),
(4,4951,18,1762365618),
(4,4953,125,1762724291),
(4,5008,1,1762400670),
(4,5212,8,1762402367),
(4,5289,4,1762367156),
(4,5305,7,1762724524),
(4,5328,3988,1762722965),
(4,5329,3988,1762722965),
(4,5330,3988,1762722965),
(4,5331,3988,1762722965),
(4,5332,7865,1762722965),
(4,5529,161,1762724291),
(4,5531,161,1762724291),
(4,6789,4,1762722463),
(4,8819,500,1762363964),
(4,8820,500,1762363964),
(4,8821,500,1762363964),
(4,8822,500,1762363964),
(4,16826,888,1762722965),
(4,19395,3000,1762363964),
(4,19481,3100,1762363964),
(4,22926,3000,1762363964),
(4,23250,4,1762722463),
(4,25828,3000,1762363964),
(4,28981,3000,1762363964),
(4,30566,1,1762363964),
(4,30569,2,1762722814),
(4,30570,2,1762364814),
(4,30571,2,1762402367),
(4,30573,1,1762363964),
(4,30574,1,1762363964),
(4,30579,3,1762722463),
(4,35977,3000,1762363964),
(4,37604,3000,1762363964),
(4,41654,3000,1762363964),
(4,43157,1,1762363964),
(4,43205,1,1762363964),
(4,43206,1,1762363964),
(4,43211,1,1762363964),
(4,43215,1,1762363964),
(4,44103,2000,1762363964),
(4,44104,2000,1762363964),
(4,44106,3300,1762363964),
(4,44110,2800,1762363964),
(4,55295,100,1762363964),
(4,59075,1,1762363964),
(4,64511,8,1762402367),
(4,102751,3000,1762363964),
(4,102752,3000,1762363964),
(4,102753,3000,1762363964),
(4,102754,3000,1762363964),
(4,106462,3000,1762363964),
(4,106463,3000,1762363964),
(4,106464,3000,1762363964),
(4,106465,3000,1762363964),
(6,111,1,1762389518),
(6,167,1,1762386226),
(6,653,1,1762386226),
(6,655,1,1762386226),
(6,657,1,1762386226),
(6,757,40,1762639636),
(6,1299,1,1762386259),
(6,1305,1,1762389144),
(6,1308,1,1762388811),
(6,1309,1,1762388817),
(6,2020,200,1762386258),
(6,2072,1623,1762388213),
(6,3631,24,1762827669),
(6,4091,481,1762827734),
(6,4092,13160,1762827669),
(6,4093,312,1762827560),
(6,4224,13896,1762827734),
(6,4299,1,1762387749),
(6,4944,97,1762827570),
(6,4948,43,1762827280),
(6,4949,10,1762386619),
(6,4953,43,1762827570),
(6,4957,1,1762387698),
(6,5212,8,1762389841),
(6,5305,2,1762388863),
(6,5328,8350,1762827669),
(6,5329,3260,1762388008),
(6,5330,3260,1762388008),
(6,5331,3260,1762388008),
(6,5332,3260,1762388008),
(6,5529,90,1762827527),
(6,5530,90,1762827527),
(6,5701,1,1762388961),
(6,6789,7,1762826655),
(6,7221,10,1762388965),
(6,8819,500,1762386258),
(6,8820,500,1762386258),
(6,8821,500,1762386258),
(6,8822,500,1762386258),
(6,14089,1,1762388516),
(6,16826,160,1762388008),
(6,19395,3000,1762386258),
(6,19481,3100,1762386258),
(6,22926,3000,1762386258),
(6,23250,7,1762826655),
(6,25828,3000,1762386258),
(6,28981,3000,1762386258),
(6,30566,1,1762388008),
(6,30569,1,1762386891),
(6,30572,3,1762389886),
(6,30573,1,1762386376),
(6,30574,3,1762639636),
(6,30579,1,1762386663),
(6,35977,3000,1762386258),
(6,37604,3000,1762386258),
(6,40126,1,1762388961),
(6,40129,1,1762388962),
(6,41654,3000,1762386258),
(6,43157,1,1762386258),
(6,43205,1,1762386258),
(6,43206,1,1762386258),
(6,43211,1,1762386258),
(6,43215,1,1762386258),
(6,44103,2000,1762386258),
(6,44104,2000,1762386258),
(6,44106,3300,1762386258),
(6,44110,2800,1762386258),
(6,47940,1,1762388119),
(6,55295,100,1762386258),
(6,59075,1,1762386258),
(6,64511,8,1762389841),
(6,102751,3000,1762386258),
(6,102752,3000,1762386258),
(6,102753,3000,1762386258),
(6,102754,3000,1762386258),
(6,106462,3000,1762386258),
(6,106463,3000,1762386258),
(6,106464,3000,1762386258),
(6,106465,3000,1762386258),
(7,72,1,1762837444),
(7,111,8,1762882359),
(7,167,1,1762644896),
(7,641,1,1762644896),
(7,651,1,1762644896),
(7,652,1,1762644896),
(7,653,1,1762644896),
(7,654,1,1762644896),
(7,655,1,1762644896),
(7,753,1,1762644896),
(7,1299,1,1762644936),
(7,1300,1,1762831313),
(7,1302,1,1762883538),
(7,1303,1,1762819669),
(7,1304,1,1762883392),
(7,1305,1,1762815375),
(7,1306,1,1762882056),
(7,1307,1,1762881786),
(7,1308,1,1762818723),
(7,1309,1,1762818733),
(7,1320,1,1762884884),
(7,1488,1,1762883538),
(7,1872,150,1762831456),
(7,2020,200,1762644935),
(7,2072,1514,1762902789),
(7,3631,43,1762884474),
(7,4091,2307,1762885047),
(7,4092,252180,1762884474),
(7,4093,1128,1762882021),
(7,4220,1,1762836793),
(7,4224,221605,1762884474),
(7,4299,5,1762882356),
(7,4370,3,1762883971),
(7,4386,3,1762883968),
(7,4944,337,1762884121),
(7,4946,4,1762883688),
(7,4948,73,1762884121),
(7,4949,92,1762883826),
(7,4951,29,1762883760),
(7,4953,138,1762882210),
(7,4957,1,1762646427),
(7,4958,4,1762883688),
(7,4984,1,1762837444),
(7,5008,1,1762833929),
(7,5212,15,1762883883),
(7,5305,6,1762902869),
(7,5328,13150,1762884474),
(7,5329,3595,1762884474),
(7,5330,3595,1762884474),
(7,5331,3595,1762884474),
(7,5332,3595,1762884474),
(7,5529,353,1762884121),
(7,5530,353,1762884121),
(7,5551,75,1762831024),
(7,5555,75,1762831017),
(7,5565,1,1762831024),
(7,5569,1,1762831017),
(7,5696,1,1762884600),
(7,5701,1,1762817184),
(7,6565,5,1762881039),
(7,6716,1,1762817862),
(7,6723,1,1762831362),
(7,6789,6,1762902744),
(7,6991,1,1762882250),
(7,7016,10,1762879977),
(7,7102,6,1762819202),
(7,7221,14,1762884625),
(7,7223,11,1762883069),
(7,8076,1,1762883965),
(7,8819,500,1762644935),
(7,8820,500,1762644935),
(7,8821,500,1762644935),
(7,8822,500,1762644935),
(7,13812,1,1762884410),
(7,14088,1,1762817593),
(7,14089,1,1762816173),
(7,16300,1,1762837444),
(7,16826,495,1762884474),
(7,17728,1,1762837444),
(7,19395,3000,1762644935),
(7,19481,3100,1762644935),
(7,22926,3000,1762644935),
(7,23250,6,1762902744),
(7,25828,3000,1762644935),
(7,28124,5,1762831017),
(7,28981,3000,1762644935),
(7,30566,4,1762880752),
(7,30569,3,1762883917),
(7,30570,2,1762884179),
(7,30571,3,1762880113),
(7,30572,4,1762880798),
(7,30573,2,1762818498),
(7,30574,9,1762902744),
(7,30579,4,1762902744),
(7,35977,3000,1762644935),
(7,37604,3000,1762644935),
(7,40050,28,1762883028),
(7,40053,45,1762884128),
(7,40082,1,1762831047),
(7,40086,1,1762831039),
(7,40126,17,1762837444),
(7,40129,1,1762817191),
(7,40811,1,1762884604),
(7,40813,1,1762884604),
(7,40814,1,1762884604),
(7,40815,1,1762884603),
(7,40816,1,1762884603),
(7,40817,1,1762884603),
(7,40818,1,1762884602),
(7,41654,3000,1762644935),
(7,43157,1,1762644935),
(7,43205,1,1762644935),
(7,43206,1,1762644935),
(7,43211,1,1762644935),
(7,43215,1,1762644935),
(7,44103,2000,1762644935),
(7,44104,2000,1762644935),
(7,44106,3300,1762644935),
(7,44110,2800,1762644935),
(7,47940,1,1762645648),
(7,48159,1,1762645641),
(7,48522,1,1762884601),
(7,55295,100,1762644935),
(7,55669,1,1762833563),
(7,56163,1,1762833563),
(7,59075,1,1762644935),
(7,64511,15,1762883883),
(7,67179,10,1762831456),
(7,67180,15,1762883883),
(7,102751,3000,1762644935),
(7,102752,3000,1762644935),
(7,102753,3000,1762644935),
(7,102754,3000,1762644935),
(7,105270,1,1762836555),
(7,106462,3000,1762644935),
(7,106463,3000,1762644935),
(7,106464,3000,1762644935),
(7,106465,3000,1762644935),
(8,111,1,1762647657),
(8,150,1,1762647657),
(8,167,1,1762646016),
(8,504,1,1762665297),
(8,505,1,1762661544),
(8,507,1,1762666335),
(8,517,1,1762665297),
(8,641,1,1762646016),
(8,655,1,1762646016),
(8,656,1,1762646016),
(8,753,1,1762646016),
(8,754,1,1762646016),
(8,755,1,1762646016),
(8,834,1,1762646016),
(8,1146,1,1762646152),
(8,1147,1,1762648770),
(8,1148,1,1762649633),
(8,1151,1,1762649633),
(8,1152,1,1762655286),
(8,1153,1,1762656218),
(8,1154,1,1762655715),
(8,1155,1,1762657383),
(8,1156,1,1762655229),
(8,1157,1,1762657597),
(8,1250,1,1762660197),
(8,1251,1,1762659817),
(8,1285,1,1762658572),
(8,1872,150,1762656608),
(8,2020,200,1762646101),
(8,2072,1519,1762665836),
(8,3356,25,1762661217),
(8,3631,46,1762666615),
(8,4091,1923,1762665678),
(8,4092,112390,1762666224),
(8,4093,1540,1762666498),
(8,4224,107231,1762666498),
(8,4787,2,1762646016),
(8,4944,421,1762666532),
(8,4946,31,1762666532),
(8,4948,72,1762666377),
(8,4953,303,1762666532),
(8,4958,46,1762666532),
(8,5008,1,1762651145),
(8,5212,14,1762666220),
(8,5289,9,1762666599),
(8,5305,8,1762661502),
(8,5328,3959,1762666224),
(8,5329,5523,1762666615),
(8,5330,5531,1762666615),
(8,5331,10694,1762666224),
(8,5332,3959,1762666224),
(8,5512,422,1762666532),
(8,5529,422,1762666532),
(8,6789,4,1762664091),
(8,8819,500,1762646101),
(8,8820,500,1762646101),
(8,8821,500,1762646101),
(8,8822,500,1762646101),
(8,14147,1,1762658572),
(8,14149,1,1762666335),
(8,15929,5,1762658021),
(8,16826,859,1762666224),
(8,19395,3000,1762646101),
(8,19481,3100,1762646101),
(8,19598,1,1762651626),
(8,22926,3000,1762646101),
(8,23250,4,1762664091),
(8,25828,3000,1762646101),
(8,28981,3000,1762646101),
(8,30566,4,1762657504),
(8,30569,3,1762658906),
(8,30570,3,1762658840),
(8,30571,5,1762666615),
(8,30572,1,1762647839),
(8,30573,3,1762658096),
(8,30574,7,1762664091),
(8,30575,3,1762665646),
(8,30577,1,1762657767),
(8,30579,4,1762665639),
(8,35977,3000,1762646101),
(8,37604,3000,1762646101),
(8,41654,3000,1762646101),
(8,43157,1,1762646101),
(8,43205,1,1762646101),
(8,43206,1,1762646101),
(8,43211,1,1762646101),
(8,43215,1,1762646101),
(8,44103,2000,1762646101),
(8,44104,2000,1762646101),
(8,44106,3300,1762646101),
(8,44110,2800,1762646101),
(8,47940,1,1762651395),
(8,48159,1,1762653279),
(8,55295,100,1762646101),
(8,55669,1,1762664091),
(8,56163,1,1762664091),
(8,59075,1,1762646101),
(8,64511,14,1762666220),
(8,67179,10,1762656608),
(8,102751,3000,1762646101),
(8,102752,3000,1762646101),
(8,102753,3000,1762646101),
(8,102754,3000,1762646101),
(8,106462,3000,1762646101),
(8,106463,3000,1762646101),
(8,106464,3000,1762646101),
(8,106465,3000,1762646101),
(10,111,3,1762846065),
(10,167,1,1762649086),
(10,653,1,1762649086),
(10,655,1,1762649086),
(10,656,1,1762649086),
(10,657,1,1762649086),
(10,834,1,1762649086),
(10,1299,1,1762649106),
(10,1300,1,1762665611),
(10,1302,1,1762846774),
(10,1303,1,1762663977),
(10,1304,1,1762846643),
(10,1305,1,1762651278),
(10,1306,1,1762845437),
(10,1307,1,1762845442),
(10,1308,1,1762662569),
(10,1309,1,1762662576),
(10,1320,1,1762847603),
(10,1488,1,1762846774),
(10,1872,150,1762665611),
(10,2020,200,1762649104),
(10,2045,2000,1762649104),
(10,2072,1497,1762651476),
(10,3631,48,1762847407),
(10,4091,3224,1762847958),
(10,4092,330575,1762847407),
(10,4093,1505,1762846381),
(10,4224,333661,1762847958),
(10,4944,353,1762847047),
(10,4946,2,1762846878),
(10,4948,59,1762846252),
(10,4949,81,1762847047),
(10,4951,30,1762846959),
(10,4953,180,1762846379),
(10,4957,1,1762650385),
(10,4958,2,1762846878),
(10,5008,1,1762667659),
(10,5212,15,1762846923),
(10,5289,2,1762848071),
(10,5305,10,1762850324),
(10,5328,13835,1762847407),
(10,5329,3533,1762847407),
(10,5330,3533,1762847407),
(10,5331,3533,1762847407),
(10,5332,3533,1762847407),
(10,5529,366,1762847047),
(10,5530,366,1762847047),
(10,5560,75,1762661966),
(10,5701,1,1762662952),
(10,5720,1,1762661966),
(10,6789,6,1762869150),
(10,7221,10,1762662965),
(10,8819,500,1762649104),
(10,8820,500,1762649104),
(10,8821,500,1762649104),
(10,8822,500,1762649104),
(10,14088,1,1762842925),
(10,14089,1,1762651376),
(10,16826,433,1762847407),
(10,19395,3000,1762649104),
(10,19481,3100,1762649104),
(10,19598,1,1762844936),
(10,22926,3000,1762649104),
(10,23250,6,1762869150),
(10,25828,3000,1762649104),
(10,28123,4,1762661966),
(10,28981,3000,1762649104),
(10,30566,3,1762843616),
(10,30569,5,1762850256),
(10,30570,2,1762850256),
(10,30571,3,1762668697),
(10,30572,3,1762850256),
(10,30573,2,1762843754),
(10,30574,8,1762850256),
(10,30579,4,1762847078),
(10,35977,3000,1762649104),
(10,37604,3000,1762649104),
(10,40058,5,1762843173),
(10,40126,1,1762662952),
(10,40129,1,1762662960),
(10,41654,3000,1762649104),
(10,43157,1,1762649104),
(10,43205,1,1762649104),
(10,43206,1,1762649104),
(10,43211,1,1762649104),
(10,43215,1,1762649104),
(10,44103,2000,1762649104),
(10,44104,2000,1762649104),
(10,44106,3300,1762649104),
(10,44110,2800,1762649104),
(10,47940,1,1762650961),
(10,48159,1,1762662457),
(10,55295,100,1762649104),
(10,55669,1,1762828966),
(10,56163,1,1762828966),
(10,59075,1,1762649104),
(10,64511,15,1762846923),
(10,67179,10,1762665611),
(10,67180,15,1762846923),
(10,102751,3000,1762649104),
(10,102752,3000,1762649104),
(10,102753,3000,1762649104),
(10,102754,3000,1762649104),
(10,105270,1,1762848201),
(10,106462,3000,1762649104),
(10,106463,3000,1762649104),
(10,106464,3000,1762649104),
(10,106465,3000,1762649104),
(11,111,1,1762668004),
(11,167,1,1762667343),
(11,641,1,1762667343),
(11,653,1,1762667343),
(11,655,1,1762667343),
(11,657,1,1762667343),
(11,754,1,1762667343),
(11,834,1,1762667343),
(11,2020,200,1762667356),
(11,3631,19,1762668475),
(11,4091,198,1762668413),
(11,4092,5575,1762668475),
(11,4093,166,1762668356),
(11,4224,5914,1762668475),
(11,4762,3500,1762667356),
(11,4944,44,1762802828),
(11,4948,24,1762802798),
(11,4953,18,1762668353),
(11,4954,1,1762667382),
(11,4955,1,1762802828),
(11,5212,7,1762802798),
(11,5328,3100,1762667356),
(11,5329,3100,1762667356),
(11,5330,3100,1762667356),
(11,5331,3100,1762667356),
(11,5332,4000,1762667356),
(11,5529,45,1762802828),
(11,6789,2,1762802493),
(11,8819,500,1762667356),
(11,8820,500,1762667356),
(11,8821,500,1762667356),
(11,8822,500,1762667356),
(11,19395,3000,1762667356),
(11,19481,3100,1762667356),
(11,19598,1,1762667356),
(11,22926,3000,1762667356),
(11,23250,2,1762802493),
(11,25828,3000,1762667356),
(11,28981,3000,1762667356),
(11,30566,1,1762667356),
(11,30569,1,1762667356),
(11,30570,3,1762802493),
(11,30571,1,1762667356),
(11,30573,1,1762667356),
(11,30574,8,1762802493),
(11,30576,1,1762668419),
(11,30579,1,1762667356),
(11,35977,3000,1762667356),
(11,37604,3000,1762667356),
(11,41654,3000,1762667356),
(11,43157,1,1762667356),
(11,43205,1,1762667356),
(11,43206,1,1762667356),
(11,43211,1,1762667356),
(11,43215,1,1762667356),
(11,44103,2000,1762667356),
(11,44104,2000,1762667356),
(11,44106,3300,1762667356),
(11,44110,2800,1762667356),
(11,47940,1,1762668407),
(11,48159,1,1762668419),
(11,55295,100,1762667356),
(11,59075,1,1762667356),
(11,64511,7,1762802798),
(11,102751,3000,1762667356),
(11,102752,3000,1762667356),
(11,102753,3000,1762667356),
(11,102754,3000,1762667356),
(11,106462,3000,1762667356),
(11,106463,3000,1762667356),
(11,106464,3000,1762667356),
(11,106465,3000,1762667356),
(12,167,1,1762675783),
(12,653,1,1762675783),
(12,655,1,1762675783),
(12,657,1,1762675783),
(12,757,20,1762738531),
(12,1299,1,1762675818),
(12,1308,1,1762677687),
(12,1309,1,1762738558),
(12,1320,1,1762738696),
(12,2020,200,1762675817),
(12,2072,1597,1762740626),
(12,3631,12,1762741435),
(12,4091,1691,1762738817),
(12,4092,5390,1762741435),
(12,4224,7081,1762741435),
(12,4944,83,1762740766),
(12,4948,75,1762740766),
(12,4949,6,1762676060),
(12,4957,1,1762676832),
(12,4958,1,1762739636),
(12,5212,7,1762741435),
(12,5305,2,1762738936),
(12,5328,6275,1762741435),
(12,5329,3260,1762741240),
(12,5330,3260,1762741240),
(12,5331,3260,1762741240),
(12,5332,3260,1762741240),
(12,5529,83,1762740766),
(12,5530,83,1762740766),
(12,6789,2,1762738531),
(12,8819,500,1762675817),
(12,8820,500,1762675817),
(12,8821,500,1762675817),
(12,8822,500,1762675817),
(12,9372,1,1762739636),
(12,14089,1,1762677195),
(12,16826,160,1762741240),
(12,19395,3000,1762675817),
(12,19481,3100,1762675817),
(12,22926,3000,1762675817),
(12,23250,2,1762738531),
(12,25828,3000,1762675817),
(12,28981,3000,1762675817),
(12,30566,2,1762741240),
(12,30569,2,1762676347),
(12,30570,1,1762675817),
(12,30571,2,1762676049),
(12,30572,1,1762740852),
(12,30573,2,1762675950),
(12,30574,2,1762739987),
(12,30579,2,1762676092),
(12,35977,3000,1762675817),
(12,37604,3000,1762675817),
(12,41654,3000,1762675817),
(12,43157,1,1762675817),
(12,43205,1,1762675817),
(12,43206,1,1762675817),
(12,43211,1,1762675817),
(12,43215,1,1762675817),
(12,44103,2000,1762675817),
(12,44104,2000,1762675817),
(12,44106,3300,1762675817),
(12,44110,2800,1762675817),
(12,47940,1,1762738804),
(12,55295,100,1762675817),
(12,59075,1,1762675817),
(12,64511,7,1762741435),
(12,102751,3000,1762675817),
(12,102752,3000,1762675817),
(12,102753,3000,1762675817),
(12,102754,3000,1762675817),
(12,106462,3000,1762675817),
(12,106463,3000,1762675817),
(12,106464,3000,1762675817),
(12,106465,3000,1762675817),
(13,167,1,1762820214),
(13,653,1,1762820214),
(13,655,1,1762820214),
(13,656,1,1762820214),
(13,657,1,1762820214),
(13,834,1,1762820214),
(13,920,1,1762823031),
(13,927,1,1762823033),
(13,928,1,1762823036),
(13,1262,1,1762823139),
(13,1299,1,1762820244),
(13,1300,1,1762821326),
(13,1302,1,1762821338),
(13,1303,1,1762821319),
(13,1304,1,1762821332),
(13,1305,1,1762821398),
(13,1306,1,1762821382),
(13,1307,1,1762821384),
(13,1308,1,1762821345),
(13,1309,1,1762821461),
(13,1314,1,1762822682),
(13,1319,1,1762822811),
(13,1335,1,1762823027),
(13,1361,1,1762823051),
(13,1444,1,1762822889),
(13,1446,1,1762822936),
(13,1447,1,1762822939),
(13,1450,1,1762822944),
(13,1488,1,1762821461),
(13,1566,1,1762826602),
(13,1872,375,1762821250),
(13,2020,200,1762820242),
(13,2045,2000,1762820242),
(13,2072,1477,1762822615),
(13,3356,15,1762823373),
(13,3631,14,1762827879),
(13,4092,44310,1762827879),
(13,4224,43223,1762827879),
(13,4787,1,1762826946),
(13,4944,48,1762827570),
(13,4946,41,1762827570),
(13,4948,20,1762825546),
(13,4949,7,1762825108),
(13,4953,20,1762827570),
(13,4957,1,1762825544),
(13,5008,1,1762825066),
(13,5212,82,1762821250),
(13,5305,1,1762823373),
(13,5328,6525,1762825917),
(13,5329,3260,1762825807),
(13,5330,3260,1762825807),
(13,5331,3260,1762825807),
(13,5332,3260,1762825807),
(13,5529,35,1762827570),
(13,5530,35,1762827570),
(13,5696,1,1762821552),
(13,6789,3,1762822335),
(13,8819,500,1762820242),
(13,8820,500,1762820242),
(13,8821,500,1762820242),
(13,8822,500,1762820242),
(13,14079,1,1762823029),
(13,14088,1,1762821388),
(13,14089,1,1762821320),
(13,14096,1,1762823016),
(13,14112,1,1762823040),
(13,14113,1,1762823043),
(13,16826,160,1762825807),
(13,19395,3000,1762820242),
(13,19481,3100,1762820242),
(13,22926,3000,1762820242),
(13,23250,3,1762822335),
(13,25828,3000,1762820242),
(13,28981,3000,1762820242),
(13,30566,2,1762825807),
(13,30569,2,1762825129),
(13,30570,1,1762820242),
(13,30571,1,1762820242),
(13,30572,1,1762825552),
(13,30574,2,1762825534),
(13,30579,2,1762820415),
(13,35977,3000,1762820242),
(13,37604,3000,1762820242),
(13,40811,1,1762821561),
(13,40813,1,1762821560),
(13,40814,1,1762821559),
(13,40815,1,1762821558),
(13,40816,1,1762821557),
(13,40817,1,1762821556),
(13,40818,1,1762821563),
(13,41480,82,1762821250),
(13,41481,82,1762821250),
(13,41482,82,1762821250),
(13,41483,82,1762821250),
(13,41484,3000,1762822335),
(13,41486,3000,1762822335),
(13,41488,3000,1762822335),
(13,41490,3000,1762822335),
(13,41494,82,1762821250),
(13,41654,3000,1762820242),
(13,43143,1,1762822335),
(13,43157,1,1762820242),
(13,43160,1,1762822335),
(13,43205,1,1762820242),
(13,43206,1,1762820242),
(13,43211,1,1762820242),
(13,43215,1,1762820242),
(13,44103,2000,1762820242),
(13,44104,2000,1762820242),
(13,44106,3300,1762820242),
(13,44110,2800,1762820242),
(13,48536,1,1762827152),
(13,55223,2,1762822335),
(13,55295,100,1762820242),
(13,55669,1,1762822335),
(13,56163,1,1762822335),
(13,59075,1,1762820242),
(13,59230,1,1762822335),
(13,60174,1,1762822335),
(13,64511,82,1762821250),
(13,64513,1,1762821250),
(13,66145,2,1762822335),
(13,67179,82,1762821250),
(13,67180,82,1762821250),
(13,67181,82,1762821250),
(13,67182,82,1762821250),
(13,67183,82,1762821250),
(13,67184,82,1762821250),
(13,67185,82,1762821250),
(13,67186,82,1762821250),
(13,67187,82,1762821250),
(13,67188,82,1762821250),
(13,67189,82,1762821250),
(13,69754,82,1762821250),
(13,102751,3000,1762820242),
(13,102752,3000,1762820242),
(13,102753,3000,1762820242),
(13,102754,3000,1762820242),
(13,106462,3000,1762820242),
(13,106463,3000,1762820242),
(13,106464,3000,1762820242),
(13,106465,3000,1762820242),
(13,107647,7,1762825108),
(14,167,1,1762829648),
(14,641,1,1762829648),
(14,653,1,1762829648),
(14,655,1,1762829648),
(14,657,1,1762829648),
(14,753,1,1762829648),
(14,754,1,1762829648),
(14,755,1,1762829648),
(14,834,1,1762829648),
(14,1872,150,1762829648),
(14,2020,200,1762829710),
(14,4787,1,1762829710),
(14,5212,10,1762829710),
(14,5328,3100,1762829710),
(14,5329,3100,1762829710),
(14,5330,3100,1762829710),
(14,5331,3100,1762829710),
(14,5332,3100,1762829710),
(14,6789,1,1762829710),
(14,8819,500,1762829710),
(14,8820,500,1762829710),
(14,8821,500,1762829710),
(14,8822,500,1762829710),
(14,19395,3000,1762829710),
(14,19481,3100,1762829710),
(14,22926,3000,1762829710),
(14,23250,1,1762829710),
(14,25828,3000,1762829710),
(14,28981,3000,1762829710),
(14,30565,1,1762829710),
(14,30566,1,1762829710),
(14,30569,1,1762829710),
(14,30570,1,1762829710),
(14,30572,1,1762829710),
(14,30573,1,1762829710),
(14,30579,1,1762829710),
(14,35977,3000,1762829710),
(14,37604,3000,1762829710),
(14,41654,3000,1762829710),
(14,43157,1,1762829710),
(14,43205,1,1762829710),
(14,43206,1,1762829710),
(14,43211,1,1762829710),
(14,43215,1,1762829710),
(14,44103,2000,1762829710),
(14,44104,2000,1762829710),
(14,44106,3300,1762829710),
(14,44110,2800,1762829710),
(14,55295,100,1762829710),
(14,56163,1,1762829710),
(14,59075,1,1762829710),
(14,64511,10,1762829710),
(14,67179,10,1762829710),
(14,69934,1,1762829648),
(14,102751,3000,1762829710),
(14,102752,3000,1762829710),
(14,102753,3000,1762829710),
(14,102754,3000,1762829710),
(14,106462,3000,1762829710),
(14,106463,3000,1762829710),
(14,106464,3000,1762829710),
(14,106465,3000,1762829710),
(15,167,1,1762834214),
(15,653,1,1762834214),
(15,657,1,1762834214),
(15,753,1,1762834214),
(15,757,5,1762834214),
(15,2020,200,1762834233),
(15,3631,1,1762834938),
(15,4092,120,1762834938),
(15,4224,120,1762834938),
(15,4742,3000,1762834233),
(15,4944,12,1762834933),
(15,4953,12,1762834933),
(15,5212,2,1762834933),
(15,5328,3162,1762834938),
(15,5329,3162,1762834938),
(15,5330,4250,1762834938),
(15,5331,3162,1762834938),
(15,5332,3162,1762834938),
(15,5512,10,1762834886),
(15,5529,10,1762834886),
(15,6789,1,1762834233),
(15,8819,500,1762834233),
(15,8820,500,1762834233),
(15,8821,500,1762834233),
(15,8822,500,1762834233),
(15,14148,1,1762834333),
(15,16826,62,1762834938),
(15,19395,3000,1762834233),
(15,19481,3100,1762834233),
(15,22926,3000,1762834233),
(15,23250,1,1762834233),
(15,25828,3000,1762834233),
(15,28981,3000,1762834233),
(15,30566,1,1762834233),
(15,30569,2,1762834938),
(15,30570,1,1762834233),
(15,30571,1,1762834233),
(15,30573,1,1762834233),
(15,30574,1,1762834233),
(15,30579,1,1762834233),
(15,35977,3000,1762834233),
(15,37604,3000,1762834233),
(15,41654,3000,1762834233),
(15,43157,1,1762834233),
(15,43205,1,1762834233),
(15,43206,1,1762834233),
(15,43211,1,1762834233),
(15,43215,1,1762834233),
(15,44103,2000,1762834233),
(15,44104,2000,1762834233),
(15,44106,3300,1762834233),
(15,44110,2800,1762834233),
(15,55295,100,1762834233),
(15,59075,1,1762834233),
(15,64511,2,1762834933),
(15,102751,3000,1762834233),
(15,102752,3000,1762834233),
(15,102753,3000,1762834233),
(15,102754,3000,1762834233),
(15,106462,3000,1762834233),
(15,106463,3000,1762834233),
(15,106464,3000,1762834233),
(15,106465,3000,1762834233),
(16,167,1,1762834846),
(16,641,1,1762834846),
(16,655,1,1762834846),
(16,656,1,1762834846),
(16,753,1,1762834846),
(16,754,1,1762834846),
(16,755,1,1762834846),
(16,834,1,1762834846),
(16,2020,200,1762834934),
(16,3631,15,1762836150),
(16,4092,3020,1762836150),
(16,4093,237,1762836040),
(16,4224,3257,1762836150),
(16,4762,3500,1762834934),
(16,4787,2,1762834846),
(16,4944,30,1762836038),
(16,4948,5,1762835485),
(16,4953,21,1762836038),
(16,4954,2,1762835282),
(16,4958,2,1762835947),
(16,5212,5,1762835969),
(16,5328,3100,1762834934),
(16,5329,3100,1762834934),
(16,5330,3100,1762834934),
(16,5331,3100,1762834934),
(16,5332,4000,1762834934),
(16,5529,30,1762836038),
(16,6789,2,1762835839),
(16,8819,500,1762834934),
(16,8820,500,1762834934),
(16,8821,500,1762834934),
(16,8822,500,1762834934),
(16,19395,3000,1762834934),
(16,19481,3100,1762834934),
(16,22926,3000,1762834934),
(16,23250,2,1762835839),
(16,25828,3000,1762834934),
(16,28981,3000,1762834934),
(16,30566,1,1762834934),
(16,30569,1,1762834934),
(16,30570,2,1762836060),
(16,30571,1,1762834934),
(16,30572,1,1762836014),
(16,30573,1,1762834934),
(16,30574,1,1762834934),
(16,30575,1,1762834934),
(16,30579,1,1762834934),
(16,35977,3000,1762834934),
(16,37604,3000,1762834934),
(16,41654,3000,1762834934),
(16,43157,1,1762834934),
(16,43205,1,1762834934),
(16,43206,1,1762834934),
(16,43211,1,1762834934),
(16,43215,1,1762834934),
(16,44103,2000,1762834934),
(16,44104,2000,1762834934),
(16,44106,3300,1762834934),
(16,44110,2800,1762834934),
(16,55295,100,1762834934),
(16,59075,1,1762834934),
(16,64511,5,1762835969),
(16,102751,3000,1762834934),
(16,102752,3000,1762834934),
(16,102753,3000,1762834934),
(16,102754,3000,1762834934),
(16,106462,3000,1762834934),
(16,106463,3000,1762834934),
(16,106464,3000,1762834934),
(16,106465,3000,1762834934);
/*!40000 ALTER TABLE `character_achievement_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_action`
--

DROP TABLE IF EXISTS `character_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_action` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `spec` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `traitConfigId` int(11) NOT NULL DEFAULT 0,
  `button` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `action` bigint(20) unsigned NOT NULL DEFAULT 0,
  `type` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`spec`,`traitConfigId`,`button`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_action`
--

LOCK TABLES `character_action` WRITE;
/*!40000 ALTER TABLE `character_action` DISABLE KEYS */;
INSERT INTO `character_action` VALUES
(3,4,0,0,35395,0),
(3,4,0,1,20271,0),
(3,4,0,2,53600,0),
(3,4,0,3,19750,0),
(3,4,0,4,853,0),
(3,4,0,5,26573,0),
(3,4,0,9,59752,0),
(3,4,0,10,1231411,0),
(4,4,0,0,116,0),
(4,4,0,1,319836,0),
(4,4,0,2,122,0),
(4,4,0,3,1953,0),
(4,4,0,4,66,0),
(4,4,0,5,190336,0),
(4,4,0,6,1449,0),
(4,4,0,7,2139,0),
(4,4,0,8,23654,128),
(4,4,0,9,59548,0),
(4,4,0,10,1231411,0),
(4,4,0,11,1459,0),
(4,4,0,83,4540,128),
(6,4,0,0,585,0),
(6,4,0,1,589,0),
(6,4,0,2,8092,0),
(6,4,0,3,17,0),
(6,4,0,4,8122,0),
(6,4,0,9,19236,0),
(6,4,0,10,2061,0),
(6,4,0,11,58984,0),
(6,4,0,70,1231411,0),
(6,4,0,71,21562,0),
(6,4,0,81,58984,0),
(7,2,0,0,1752,0),
(7,2,0,1,5938,0),
(7,2,0,2,196819,0),
(7,2,0,3,1766,0),
(7,2,0,4,31224,0),
(7,2,0,5,197835,0),
(7,2,0,6,36554,0),
(7,2,0,7,2094,0),
(7,2,0,8,121471,0),
(7,2,0,54,3382,128),
(7,2,0,55,5997,128),
(7,2,0,56,2454,128),
(7,2,0,57,118,128),
(7,2,0,58,4536,128),
(7,2,0,59,6948,128),
(7,2,0,60,66,48),
(7,2,0,61,185311,0),
(7,2,0,62,5277,0),
(7,2,0,63,1966,0),
(7,2,0,64,315496,0),
(7,2,0,65,408,0),
(7,2,0,66,1943,0),
(7,2,0,68,1804,0),
(7,2,0,69,58984,0),
(7,2,0,70,1231411,0),
(7,2,0,71,2983,0),
(7,2,0,72,1833,0),
(7,2,0,73,8676,0),
(7,2,0,74,6770,0),
(7,4,0,0,1752,0),
(7,4,0,1,196819,0),
(7,4,0,2,1766,0),
(7,4,0,3,185311,0),
(7,4,0,4,315496,0),
(7,4,0,5,315584,0),
(7,4,0,6,3408,0),
(7,4,0,53,6948,128),
(7,4,0,55,2550,0),
(7,4,0,56,818,0),
(7,4,0,57,58984,0),
(7,4,0,58,1231411,0),
(7,4,0,59,2983,0),
(7,4,0,68,5457,128),
(7,4,0,69,6888,128),
(7,4,0,70,961,128),
(7,4,0,71,118,128),
(7,4,0,72,1833,0),
(7,4,0,73,8676,0),
(7,4,0,81,58984,0),
(8,2,0,0,20271,0),
(8,2,0,1,184575,0),
(8,2,0,2,35395,0),
(8,2,0,4,53385,0),
(8,2,0,11,62124,0),
(8,2,0,48,24275,0),
(8,2,0,49,85256,0),
(8,2,0,50,853,0),
(8,2,0,59,7328,0),
(8,2,0,60,19750,0),
(8,2,0,61,85673,0),
(8,2,0,62,96231,0),
(8,2,0,69,190784,0),
(8,2,0,70,642,0),
(8,2,0,71,403876,0),
(8,2,0,144,5502,0),
(8,2,0,146,1231411,0),
(8,2,0,147,59752,0),
(8,2,0,155,84,96),
(8,4,0,0,20271,0),
(8,4,0,1,35395,0),
(8,4,0,2,26573,0),
(8,4,0,4,5502,0),
(8,4,0,11,62124,0),
(8,4,0,48,853,0),
(8,4,0,49,53600,0),
(8,4,0,50,642,0),
(8,4,0,58,59752,0),
(8,4,0,59,1231411,0),
(8,4,0,60,19750,0),
(8,4,0,61,85673,0),
(10,1,0,0,5176,0),
(10,1,0,1,8921,0),
(10,1,0,2,50769,0),
(10,1,0,3,285381,0),
(10,1,0,4,197628,0),
(10,1,0,48,22812,0),
(10,1,0,49,1126,0),
(10,1,0,53,1231411,0),
(10,1,0,56,2,80),
(10,1,0,57,125439,0),
(10,1,0,58,58984,0),
(10,1,0,59,6948,128),
(10,1,0,62,8936,0),
(10,1,0,64,339,0),
(10,1,0,66,5217,0),
(10,1,0,72,1822,0),
(10,1,0,73,5221,0),
(10,1,0,74,1079,0),
(10,1,0,75,22570,0),
(10,1,0,76,22568,0),
(10,1,0,77,1229376,0),
(10,1,0,78,106832,0),
(10,1,0,79,213764,0),
(10,1,0,82,1850,0),
(10,1,0,83,5215,0),
(10,4,0,0,5176,0),
(10,4,0,1,8921,0),
(10,4,0,2,213764,0),
(10,4,0,50,339,0),
(10,4,0,51,1126,0),
(10,4,0,55,1231411,0),
(10,4,0,57,159,128),
(10,4,0,58,58984,0),
(10,4,0,59,6948,128),
(10,4,0,61,8936,0),
(10,4,0,70,5457,128),
(10,4,0,72,5221,0),
(10,4,0,73,22568,0),
(10,4,0,74,22812,0),
(10,4,0,80,1850,0),
(10,4,0,84,8936,0),
(10,4,0,96,8936,0),
(10,4,0,97,33917,0),
(10,4,0,98,6795,0),
(10,4,0,99,22812,0),
(10,4,0,108,8921,0),
(10,4,0,109,8936,0),
(10,4,0,110,339,0),
(11,4,0,0,470411,0),
(11,4,0,1,188196,0),
(11,4,0,4,2484,0),
(11,4,0,11,59547,0),
(11,4,0,48,8004,0),
(11,4,0,60,73899,0),
(11,4,0,144,1231411,0),
(11,4,0,155,318038,0),
(12,4,0,0,585,0),
(12,4,0,1,589,0),
(12,4,0,2,2061,0),
(12,4,0,3,17,0),
(12,4,0,4,8092,0),
(12,4,0,5,21562,0),
(12,4,0,6,8122,0),
(12,4,0,9,58984,0),
(12,4,0,10,1231411,0),
(12,4,0,81,58984,0),
(13,0,0,0,8921,0),
(13,0,0,1,194153,0),
(13,0,0,2,5176,0),
(13,0,0,3,78674,0),
(13,0,0,4,191034,0),
(13,0,0,5,108238,0),
(13,0,0,6,102359,0),
(13,0,0,7,58984,0),
(13,0,0,8,22812,0),
(13,0,0,9,20484,0),
(13,0,0,10,1126,0),
(13,0,0,11,50769,0),
(13,0,0,60,319454,0),
(13,0,0,61,202770,0),
(13,0,0,62,274281,0),
(13,0,0,63,774,0),
(13,0,0,64,186,96),
(13,0,0,65,48438,0),
(13,0,0,66,132469,0),
(13,0,0,67,202347,0),
(13,0,0,68,202425,0),
(13,0,0,69,205636,0),
(13,0,0,70,102401,0),
(13,0,0,71,197628,0),
(13,0,0,72,106832,0),
(13,0,0,96,106832,0),
(13,0,0,97,22842,0),
(13,0,0,98,99,0),
(13,4,0,0,5176,0),
(13,4,0,1,8921,0),
(13,4,0,2,50769,0),
(13,4,0,3,1126,0),
(13,4,0,4,213764,0),
(13,4,0,5,8936,0),
(13,4,0,6,18960,0),
(13,4,0,7,20484,0),
(13,4,0,8,339,0),
(13,4,0,9,58984,0),
(13,4,0,10,1231411,0),
(13,4,0,72,5221,0),
(13,4,0,73,22812,0),
(13,4,0,74,5215,0),
(13,4,0,75,22568,0),
(13,4,0,76,8936,0),
(13,4,0,77,1850,0),
(13,4,0,81,58984,0),
(13,4,0,84,8936,0),
(13,4,0,96,6795,0),
(13,4,0,97,33917,0),
(13,4,0,98,22812,0),
(13,4,0,99,8936,0),
(13,4,0,108,8921,0),
(13,4,0,109,8936,0),
(13,4,0,110,339,0),
(14,4,0,0,361469,0),
(14,4,0,1,362969,0),
(14,4,0,2,357214,0),
(14,4,0,3,368970,0),
(14,4,0,10,358733,0),
(15,4,0,0,116,0),
(15,4,0,1,319836,0),
(15,4,0,9,20594,0),
(15,4,0,10,1231411,0),
(16,4,0,0,35395,0),
(16,4,0,1,53600,0),
(16,4,0,2,20271,0),
(16,4,0,3,19750,0),
(16,4,0,4,853,0),
(16,4,0,60,59542,0),
(16,4,0,71,1231411,0),
(16,4,0,83,4540,128);
/*!40000 ALTER TABLE `character_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_arena_stats`
--

DROP TABLE IF EXISTS `character_arena_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_arena_stats` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `slot` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `matchMakerRating` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_arena_stats`
--

LOCK TABLES `character_arena_stats` WRITE;
/*!40000 ALTER TABLE `character_arena_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_arena_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_aura`
--

DROP TABLE IF EXISTS `character_aura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_aura` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `casterGuid` binary(16) NOT NULL COMMENT 'Full Global Unique Identifier',
  `itemGuid` binary(16) NOT NULL,
  `spell` int(10) unsigned NOT NULL,
  `effectMask` int(10) unsigned NOT NULL,
  `recalculateMask` int(10) unsigned NOT NULL DEFAULT 0,
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `stackCount` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `maxDuration` int(11) NOT NULL DEFAULT 0,
  `remainTime` int(11) NOT NULL DEFAULT 0,
  `remainCharges` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `castItemId` int(10) unsigned NOT NULL DEFAULT 0,
  `castItemLevel` int(11) NOT NULL DEFAULT -1,
  PRIMARY KEY (`guid`,`casterGuid`,`itemGuid`,`spell`,`effectMask`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_aura`
--

LOCK TABLES `character_aura` WRITE;
/*!40000 ALTER TABLE `character_aura` DISABLE KEYS */;
INSERT INTO `character_aura` VALUES
(3,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',132334,1,1,0,1,180000,123528,0,0,-1),
(3,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(4,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(6,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',21562,3,3,0,1,3600000,2897888,0,0,-1),
(6,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',2383,15,15,0,1,-1,-1,0,0,-1),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',315584,1,1,0,1,3600000,2197551,0,0,-1),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','Ž\0\0\0\0\0\0\0\0\0\0\0\0',2367,1,1,0,1,3600000,2205347,0,2454,3),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0',673,1,1,0,1,3600000,2202119,0,5997,3),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',465,3,3,0,1,-1,-1,0,0,-1),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',23214,1,1,0,1,-1,-1,0,0,-1),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',86458,1,1,0,1,-1,-1,0,0,-1),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',122026,1,1,0,1,-1,-1,0,0,-1),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',344218,1,1,0,1,-1,-1,0,0,-1),
(10,'\n\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',1126,1,1,0,1,3600000,614847,0,0,-1),
(10,'\n\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(11,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(11,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',312605,1,1,0,1,-1,-1,0,0,-1),
(12,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',21562,3,3,0,1,3600000,2019514,0,0,-1),
(12,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(13,'\r\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',41513,1,1,0,1,-1,-1,0,0,-1),
(13,'\r\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',86461,3,3,0,1,-1,-1,0,0,-1),
(13,'\r\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',97709,1,1,0,1,-1,-1,0,0,-1),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',366646,1,1,0,1,-1,-1,0,0,-1),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',369731,1,1,0,1,-1,-1,0,0,-1),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',370112,1,1,0,1,-1,-1,0,0,-1),
(15,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(16,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,1,0,1,-1,-1,0,0,-1),
(16,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',305750,1,1,0,1,-1,-1,0,0,-1);
/*!40000 ALTER TABLE `character_aura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_aura_effect`
--

DROP TABLE IF EXISTS `character_aura_effect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_aura_effect` (
  `guid` bigint(20) unsigned NOT NULL,
  `casterGuid` binary(16) NOT NULL COMMENT 'Full Global Unique Identifier',
  `itemGuid` binary(16) NOT NULL,
  `spell` int(10) unsigned NOT NULL,
  `effectMask` int(10) unsigned NOT NULL,
  `effectIndex` tinyint(3) unsigned NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `baseAmount` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`casterGuid`,`itemGuid`,`spell`,`effectMask`,`effectIndex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_aura_effect`
--

LOCK TABLES `character_aura_effect` WRITE;
/*!40000 ALTER TABLE `character_aura_effect` DISABLE KEYS */;
INSERT INTO `character_aura_effect` VALUES
(3,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',132334,1,0,0,0),
(3,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(4,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(6,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',21562,3,0,5,5),
(6,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',21562,3,1,0,0),
(6,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',2383,15,0,0,0),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',2383,15,1,0,0),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',2383,15,2,0,0),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',2383,15,3,0,0),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',315584,1,0,1,1),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','Ž\0\0\0\0\0\0\0\0\0\0\0\0',2367,1,0,2,2),
(7,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0',673,1,0,1,1),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',465,3,0,-3,-3),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',465,3,1,-3,-3),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',23214,1,0,227,0),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',86458,1,0,100,100),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',122026,1,0,0,0),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(8,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',344218,1,0,-3,-3),
(10,'\n\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',1126,1,0,3,3),
(10,'\n\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(11,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(11,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',312605,1,0,0,0),
(12,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',21562,3,0,5,5),
(12,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',21562,3,1,0,0),
(12,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(13,'\r\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',41513,1,0,457,0),
(13,'\r\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',86461,3,0,100,100),
(13,'\r\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',86461,3,1,420,420),
(13,'\r\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',97709,1,0,0,0),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',366646,1,0,0,0),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',369731,1,0,0,0),
(14,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',370112,1,0,0,0),
(15,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(16,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',261764,1,0,0,0),
(16,'\0\0\0\0\0\0\0\0\0\0\0\0\0','\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0',305750,1,0,0,0);
/*!40000 ALTER TABLE `character_aura_effect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_aura_stored_location`
--

DROP TABLE IF EXISTS `character_aura_stored_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_aura_stored_location` (
  `Guid` bigint(20) unsigned NOT NULL COMMENT 'Global Unique Identifier of Player',
  `Spell` int(10) unsigned NOT NULL COMMENT 'Spell Identifier',
  `MapId` int(10) unsigned NOT NULL COMMENT 'Map Id',
  `PositionX` float NOT NULL COMMENT 'position x',
  `PositionY` float NOT NULL COMMENT 'position y',
  `PositionZ` float NOT NULL COMMENT 'position z',
  `Orientation` float NOT NULL COMMENT 'Orientation',
  PRIMARY KEY (`Guid`,`Spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_aura_stored_location`
--

LOCK TABLES `character_aura_stored_location` WRITE;
/*!40000 ALTER TABLE `character_aura_stored_location` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_aura_stored_location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_bank_tab_settings`
--

DROP TABLE IF EXISTS `character_bank_tab_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_bank_tab_settings` (
  `characterGuid` bigint(20) unsigned NOT NULL,
  `tabId` tinyint(3) unsigned NOT NULL,
  `name` varchar(16) DEFAULT NULL,
  `icon` varchar(64) DEFAULT NULL,
  `description` varchar(2048) DEFAULT NULL,
  `depositFlags` int(11) DEFAULT 0,
  PRIMARY KEY (`characterGuid`,`tabId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_bank_tab_settings`
--

LOCK TABLES `character_bank_tab_settings` WRITE;
/*!40000 ALTER TABLE `character_bank_tab_settings` DISABLE KEYS */;
INSERT INTO `character_bank_tab_settings` VALUES
(7,0,'Tab 1','','',0),
(10,0,'Tab 1','','',0);
/*!40000 ALTER TABLE `character_bank_tab_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_banned`
--

DROP TABLE IF EXISTS `character_banned`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_banned` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `bandate` bigint(20) NOT NULL DEFAULT 0,
  `unbandate` bigint(20) NOT NULL DEFAULT 0,
  `bannedby` varchar(50) NOT NULL,
  `banreason` varchar(255) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`guid`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ban List';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_banned`
--

LOCK TABLES `character_banned` WRITE;
/*!40000 ALTER TABLE `character_banned` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_banned` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_battleground_data`
--

DROP TABLE IF EXISTS `character_battleground_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_battleground_data` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `instanceId` int(10) unsigned NOT NULL COMMENT 'Instance Identifier',
  `team` smallint(5) unsigned NOT NULL,
  `joinX` float NOT NULL DEFAULT 0,
  `joinY` float NOT NULL DEFAULT 0,
  `joinZ` float NOT NULL DEFAULT 0,
  `joinO` float NOT NULL DEFAULT 0,
  `joinMapId` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Map Identifier',
  `taxiStart` int(10) unsigned NOT NULL DEFAULT 0,
  `taxiEnd` int(10) unsigned NOT NULL DEFAULT 0,
  `mountSpell` int(10) unsigned NOT NULL DEFAULT 0,
  `queueId` bigint(20) unsigned DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_battleground_data`
--

LOCK TABLES `character_battleground_data` WRITE;
/*!40000 ALTER TABLE `character_battleground_data` DISABLE KEYS */;
INSERT INTO `character_battleground_data` VALUES
(3,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(4,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(6,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(7,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(8,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(10,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(11,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(12,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(13,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(14,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(15,0,0,0,0,0,0,65535,0,0,0,2238289014803136512),
(16,0,0,0,0,0,0,65535,0,0,0,2238289014803136512);
/*!40000 ALTER TABLE `character_battleground_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_battleground_random`
--

DROP TABLE IF EXISTS `character_battleground_random`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_battleground_random` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_battleground_random`
--

LOCK TABLES `character_battleground_random` WRITE;
/*!40000 ALTER TABLE `character_battleground_random` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_battleground_random` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_cuf_profiles`
--

DROP TABLE IF EXISTS `character_cuf_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_cuf_profiles` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Character Guid',
  `id` tinyint(3) unsigned NOT NULL COMMENT 'Profile Id (0-4)',
  `name` varchar(12) NOT NULL COMMENT 'Profile Name',
  `frameHeight` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Profile Frame Height',
  `frameWidth` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Profile Frame Width',
  `sortBy` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Frame Sort By',
  `healthText` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Frame Health Text',
  `boolOptions` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Many Configurable Bool Options',
  `topPoint` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Frame top alignment',
  `bottomPoint` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Frame bottom alignment',
  `leftPoint` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Frame left alignment',
  `topOffset` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Frame position offset from top',
  `bottomOffset` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Frame position offset from bottom',
  `leftOffset` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Frame position offset from left',
  PRIMARY KEY (`guid`,`id`),
  KEY `index` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_cuf_profiles`
--

LOCK TABLES `character_cuf_profiles` WRITE;
/*!40000 ALTER TABLE `character_cuf_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_cuf_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_currency`
--

DROP TABLE IF EXISTS `character_currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_currency` (
  `CharacterGuid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `Currency` smallint(5) unsigned NOT NULL,
  `Quantity` int(10) unsigned NOT NULL,
  `WeeklyQuantity` int(10) unsigned NOT NULL,
  `TrackedQuantity` int(10) unsigned NOT NULL,
  `IncreasedCapQuantity` int(10) unsigned NOT NULL DEFAULT 0,
  `EarnedQuantity` int(10) unsigned NOT NULL DEFAULT 0,
  `Flags` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`CharacterGuid`,`Currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_currency`
--

LOCK TABLES `character_currency` WRITE;
/*!40000 ALTER TABLE `character_currency` DISABLE KEYS */;
INSERT INTO `character_currency` VALUES
(7,81,1,0,0,0,0,0);
/*!40000 ALTER TABLE `character_currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_customizations`
--

DROP TABLE IF EXISTS `character_customizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_customizations` (
  `guid` bigint(20) unsigned NOT NULL,
  `chrCustomizationOptionID` int(10) unsigned NOT NULL,
  `chrCustomizationChoiceID` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`chrCustomizationOptionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_customizations`
--

LOCK TABLES `character_customizations` WRITE;
/*!40000 ALTER TABLE `character_customizations` DISABLE KEYS */;
INSERT INTO `character_customizations` VALUES
(3,9,4957),
(3,10,15424),
(3,11,4990),
(3,12,5140),
(3,13,77),
(3,463,4131),
(3,525,5058),
(3,888,9911),
(3,889,9929),
(3,890,9924),
(3,6338,45086),
(3,8789,56651),
(4,133,7824),
(4,134,1967),
(4,135,1997),
(4,136,7814),
(4,137,2017),
(4,619,6978),
(4,689,7706),
(4,697,7765),
(4,699,7791),
(4,701,7796),
(4,778,8647),
(4,6359,45170),
(6,49,803),
(6,50,825),
(6,51,843),
(6,52,862),
(6,53,877),
(6,55,55366),
(6,56,894),
(6,57,901),
(6,377,55356),
(6,683,7619),
(6,708,7847),
(6,710,7854),
(6,712,7861),
(6,714,7869),
(6,724,7963),
(6,726,7996),
(6,732,8053),
(6,736,8072),
(6,744,8130),
(6,745,8177),
(6,6345,45114),
(7,40,699),
(7,41,720),
(7,42,742),
(7,43,761),
(7,44,8105),
(7,46,8166),
(7,47,782),
(7,48,789),
(7,376,769),
(7,682,7606),
(7,728,8019),
(7,730,8044),
(7,734,8066),
(7,738,8089),
(7,739,8095),
(7,740,8102),
(7,742,8116),
(7,6344,45110),
(7,8627,55375),
(8,14,88),
(8,15,107),
(8,16,139),
(8,17,32288),
(8,464,4168),
(8,501,4755),
(8,510,4908),
(8,516,4963),
(8,526,5061),
(8,970,15685),
(8,6339,45090),
(8,8790,56654),
(10,49,806),
(10,50,833),
(10,51,855),
(10,52,3607),
(10,53,876),
(10,55,55361),
(10,56,894),
(10,57,901),
(10,377,55356),
(10,683,7622),
(10,708,7846),
(10,710,7854),
(10,712,7864),
(10,714,7870),
(10,724,7963),
(10,726,7995),
(10,732,8053),
(10,736,8073),
(10,744,8130),
(10,745,8177),
(10,6345,45114),
(11,133,7826),
(11,134,1965),
(11,135,7781),
(11,136,2003),
(11,137,7785),
(11,619,6978),
(11,689,7707),
(11,697,7764),
(11,699,7791),
(11,701,7796),
(11,778,8645),
(11,6359,45170),
(12,49,809),
(12,50,827),
(12,51,850),
(12,52,864),
(12,53,877),
(12,55,55368),
(12,56,894),
(12,57,901),
(12,377,55356),
(12,683,7622),
(12,708,7847),
(12,710,7854),
(12,712,7864),
(12,714,7868),
(12,724,7963),
(12,726,7996),
(12,732,8052),
(12,736,8073),
(12,744,8130),
(12,745,8179),
(12,6345,45114),
(13,49,802),
(13,50,826),
(13,51,843),
(13,52,8163),
(13,53,880),
(13,55,8172),
(13,56,894),
(13,57,901),
(13,377,881),
(13,683,7622),
(13,708,7845),
(13,710,7854),
(13,712,7861),
(13,714,7868),
(13,724,7964),
(13,726,7995),
(13,732,8052),
(13,736,8071),
(13,744,8130),
(13,745,8290),
(13,6345,45114),
(14,1578,19366),
(14,1582,19382),
(14,1583,19405),
(14,1584,19388),
(14,1586,19479),
(14,1587,19484),
(14,1588,19493),
(14,1589,29783),
(14,1590,26864),
(14,1591,19509),
(14,1592,19513),
(14,1593,19516),
(14,1594,19534),
(14,1595,19541),
(14,1596,19548),
(14,1597,19556),
(14,1598,19570),
(14,1599,19559),
(14,1600,19571),
(14,1601,19573),
(14,1602,19555),
(14,1603,19576),
(14,1604,19581),
(14,1607,19585),
(14,1608,19594),
(14,1764,26878),
(14,1765,30060),
(14,1793,27638),
(14,1794,27644),
(14,1795,27670),
(14,1796,27689),
(14,1797,27705),
(14,1799,27715),
(14,1800,27721),
(14,1802,27736),
(14,1803,27737),
(14,1804,27751),
(14,1805,27759),
(14,1806,27764),
(14,1807,27766),
(14,1808,27770),
(14,1809,27796),
(14,1810,27797),
(14,1812,27803),
(14,1813,27821),
(14,1818,27992),
(14,1819,27999),
(14,1823,29876),
(14,1828,28116),
(14,1829,29884),
(14,1831,28180),
(14,1832,28232),
(14,1833,28240),
(14,1842,28269),
(14,1843,28271),
(14,1844,28273),
(14,1845,28275),
(14,1846,28278),
(14,1976,29794),
(14,1978,29840),
(14,1979,29846),
(14,1982,29888),
(14,1984,29976),
(14,1985,29977),
(14,1986,29979),
(14,1987,29978),
(14,1988,29981),
(14,1989,29982),
(14,1990,29980),
(14,2013,30029),
(14,2963,30706),
(14,2964,30707),
(15,30,528),
(15,31,556),
(15,32,7125),
(15,33,593),
(15,34,606),
(15,544,5542),
(15,600,6793),
(15,604,6818),
(15,610,6930),
(15,611,6960),
(15,936,15441),
(15,937,15451),
(15,6342,45102),
(16,133,1949),
(16,134,1965),
(16,135,1984),
(16,136,7812),
(16,137,2011),
(16,619,6978),
(16,689,7705),
(16,697,7764),
(16,699,7792),
(16,701,7796),
(16,778,8652),
(16,6359,45170);
/*!40000 ALTER TABLE `character_customizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_declinedname`
--

DROP TABLE IF EXISTS `character_declinedname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_declinedname` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `genitive` varchar(15) NOT NULL DEFAULT '',
  `dative` varchar(15) NOT NULL DEFAULT '',
  `accusative` varchar(15) NOT NULL DEFAULT '',
  `instrumental` varchar(15) NOT NULL DEFAULT '',
  `prepositional` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_declinedname`
--

LOCK TABLES `character_declinedname` WRITE;
/*!40000 ALTER TABLE `character_declinedname` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_declinedname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_equipmentsets`
--

DROP TABLE IF EXISTS `character_equipmentsets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_equipmentsets` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `setguid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `setindex` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `name` varchar(31) NOT NULL,
  `iconname` varchar(100) NOT NULL,
  `ignore_mask` int(10) unsigned NOT NULL DEFAULT 0,
  `AssignedSpecIndex` int(11) NOT NULL DEFAULT -1,
  `item0` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item1` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item2` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item3` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item4` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item5` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item6` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item7` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item8` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item9` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item10` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item11` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item12` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item13` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item14` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item15` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item16` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item17` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item18` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`setguid`),
  UNIQUE KEY `idx_set` (`guid`,`setguid`,`setindex`),
  KEY `Idx_setindex` (`setindex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_equipmentsets`
--

LOCK TABLES `character_equipmentsets` WRITE;
/*!40000 ALTER TABLE `character_equipmentsets` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_equipmentsets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_favorite_auctions`
--

DROP TABLE IF EXISTS `character_favorite_auctions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_favorite_auctions` (
  `guid` bigint(20) unsigned NOT NULL,
  `order` int(10) unsigned NOT NULL DEFAULT 0,
  `itemId` int(10) unsigned NOT NULL DEFAULT 0,
  `itemLevel` int(10) unsigned NOT NULL DEFAULT 0,
  `battlePetSpeciesId` int(10) unsigned NOT NULL DEFAULT 0,
  `suffixItemNameDescriptionId` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_favorite_auctions`
--

LOCK TABLES `character_favorite_auctions` WRITE;
/*!40000 ALTER TABLE `character_favorite_auctions` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_favorite_auctions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_fishingsteps`
--

DROP TABLE IF EXISTS `character_fishingsteps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_fishingsteps` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `fishingSteps` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_fishingsteps`
--

LOCK TABLES `character_fishingsteps` WRITE;
/*!40000 ALTER TABLE `character_fishingsteps` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_fishingsteps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_garrison`
--

DROP TABLE IF EXISTS `character_garrison`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_garrison` (
  `guid` bigint(20) unsigned NOT NULL,
  `siteLevelId` int(10) unsigned NOT NULL DEFAULT 0,
  `followerActivationsRemainingToday` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_garrison`
--

LOCK TABLES `character_garrison` WRITE;
/*!40000 ALTER TABLE `character_garrison` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_garrison_blueprints`
--

DROP TABLE IF EXISTS `character_garrison_blueprints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_garrison_blueprints` (
  `guid` bigint(20) unsigned NOT NULL,
  `buildingId` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`buildingId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_garrison_blueprints`
--

LOCK TABLES `character_garrison_blueprints` WRITE;
/*!40000 ALTER TABLE `character_garrison_blueprints` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_blueprints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_garrison_buildings`
--

DROP TABLE IF EXISTS `character_garrison_buildings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_garrison_buildings` (
  `guid` bigint(20) unsigned NOT NULL,
  `plotInstanceId` int(10) unsigned NOT NULL DEFAULT 0,
  `buildingId` int(10) unsigned NOT NULL DEFAULT 0,
  `timeBuilt` bigint(20) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`plotInstanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_garrison_buildings`
--

LOCK TABLES `character_garrison_buildings` WRITE;
/*!40000 ALTER TABLE `character_garrison_buildings` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_garrison_follower_abilities`
--

DROP TABLE IF EXISTS `character_garrison_follower_abilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_garrison_follower_abilities` (
  `dbId` bigint(20) unsigned NOT NULL,
  `abilityId` int(10) unsigned NOT NULL,
  `slot` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`dbId`,`abilityId`,`slot`),
  CONSTRAINT `fk_foll_dbid` FOREIGN KEY (`dbId`) REFERENCES `character_garrison_followers` (`dbId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_garrison_follower_abilities`
--

LOCK TABLES `character_garrison_follower_abilities` WRITE;
/*!40000 ALTER TABLE `character_garrison_follower_abilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_follower_abilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_garrison_followers`
--

DROP TABLE IF EXISTS `character_garrison_followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_garrison_followers` (
  `dbId` bigint(20) unsigned NOT NULL,
  `guid` bigint(20) unsigned NOT NULL,
  `followerId` int(10) unsigned NOT NULL,
  `quality` int(10) unsigned NOT NULL DEFAULT 2,
  `level` int(10) unsigned NOT NULL DEFAULT 90,
  `itemLevelWeapon` int(10) unsigned NOT NULL DEFAULT 600,
  `itemLevelArmor` int(10) unsigned NOT NULL DEFAULT 600,
  `xp` int(10) unsigned NOT NULL DEFAULT 0,
  `currentBuilding` int(10) unsigned NOT NULL DEFAULT 0,
  `currentMission` int(10) unsigned NOT NULL DEFAULT 0,
  `status` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`dbId`),
  UNIQUE KEY `idx_guid_id` (`guid`,`followerId`),
  CONSTRAINT `fk_foll_owner` FOREIGN KEY (`guid`) REFERENCES `characters` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_garrison_followers`
--

LOCK TABLES `character_garrison_followers` WRITE;
/*!40000 ALTER TABLE `character_garrison_followers` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_gifts`
--

DROP TABLE IF EXISTS `character_gifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_gifts` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item_guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `entry` int(10) unsigned NOT NULL DEFAULT 0,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`item_guid`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_gifts`
--

LOCK TABLES `character_gifts` WRITE;
/*!40000 ALTER TABLE `character_gifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_gifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_glyphs`
--

DROP TABLE IF EXISTS `character_glyphs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_glyphs` (
  `guid` bigint(20) unsigned NOT NULL,
  `talentGroup` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `glyphId` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`talentGroup`,`glyphId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_glyphs`
--

LOCK TABLES `character_glyphs` WRITE;
/*!40000 ALTER TABLE `character_glyphs` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_glyphs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_homebind`
--

DROP TABLE IF EXISTS `character_homebind`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_homebind` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `mapId` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Map Identifier',
  `zoneId` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Zone Identifier',
  `posX` float NOT NULL DEFAULT 0,
  `posY` float NOT NULL DEFAULT 0,
  `posZ` float NOT NULL DEFAULT 0,
  `orientation` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_homebind`
--

LOCK TABLES `character_homebind` WRITE;
/*!40000 ALTER TABLE `character_homebind` DISABLE KEYS */;
INSERT INTO `character_homebind` VALUES
(3,0,9,-8914.57,-133.909,80.5378,5.10444),
(4,530,3526,-3961.64,-13931.2,100.615,2.08364),
(6,1,186,9802.11,979.458,1313.89,1.72326),
(7,1,1659,10127.4,2227.19,1328.64,5.355),
(8,0,5154,-9081.25,824.704,108.459,3.50306),
(10,1,4659,7418.54,-280.026,7.66912,0.648325),
(11,530,3526,-3961.64,-13931.2,100.615,2.08364),
(12,1,188,10311.3,831.463,1326.57,5.48033),
(13,1,188,10311.3,831.463,1326.57,5.48033),
(14,2570,13806,5827.53,-2982.55,251.047,3.86788),
(15,0,132,-6230.42,330.232,383.105,0.501087),
(16,530,3526,-3961.64,-13931.2,100.615,2.08364);
/*!40000 ALTER TABLE `character_homebind` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_instance_lock`
--

DROP TABLE IF EXISTS `character_instance_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_instance_lock` (
  `guid` bigint(20) unsigned NOT NULL,
  `mapId` int(10) unsigned NOT NULL,
  `lockId` int(10) unsigned NOT NULL,
  `instanceId` int(10) unsigned DEFAULT NULL,
  `difficulty` tinyint(3) unsigned DEFAULT NULL,
  `data` text DEFAULT NULL,
  `completedEncountersMask` int(10) unsigned DEFAULT NULL,
  `entranceWorldSafeLocId` int(10) unsigned DEFAULT NULL,
  `expiryTime` bigint(20) unsigned DEFAULT NULL,
  `extended` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`guid`,`mapId`,`lockId`),
  UNIQUE KEY `uk_character_instanceId` (`guid`,`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_instance_lock`
--

LOCK TABLES `character_instance_lock` WRITE;
/*!40000 ALTER TABLE `character_instance_lock` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_instance_lock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_inventory`
--

DROP TABLE IF EXISTS `character_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_inventory` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `bag` bigint(20) unsigned NOT NULL DEFAULT 0,
  `slot` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `item` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Item Global Unique Identifier',
  PRIMARY KEY (`item`),
  UNIQUE KEY `uk_location` (`guid`,`bag`,`slot`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_inventory`
--

LOCK TABLES `character_inventory` WRITE;
/*!40000 ALTER TABLE `character_inventory` DISABLE KEYS */;
INSERT INTO `character_inventory` VALUES
(3,0,4,66),
(3,0,5,72),
(3,0,6,74),
(3,0,7,99),
(3,0,8,68),
(3,0,9,70),
(3,0,14,95),
(3,0,15,102),
(3,0,16,64),
(3,0,18,103),
(3,0,30,83),
(3,0,31,101),
(3,0,32,104),
(3,83,3,91),
(4,0,4,112),
(4,0,5,114),
(4,0,6,118),
(4,0,7,121),
(4,0,8,120),
(4,0,9,110),
(4,0,15,106),
(4,0,30,123),
(4,0,35,108),
(4,0,36,116),
(4,0,37,150),
(4,0,38,145),
(4,0,39,146),
(4,0,40,147),
(4,0,41,148),
(4,0,42,149),
(4,0,43,151),
(4,0,44,153),
(4,0,45,260),
(4,0,46,267),
(4,0,47,269),
(4,0,48,832),
(4,0,49,835),
(6,0,4,229),
(6,0,5,163),
(6,0,6,167),
(6,0,7,165),
(6,0,8,169),
(6,0,9,159),
(6,0,14,256),
(6,0,15,210),
(6,0,30,191),
(6,0,31,259),
(6,0,35,157),
(6,0,36,237),
(6,0,37,244),
(6,0,38,196),
(6,0,42,235),
(6,0,46,979),
(6,0,47,988),
(6,0,48,991),
(6,191,5,182),
(7,0,4,1062),
(7,0,5,1264),
(7,0,6,1322),
(7,0,7,1330),
(7,0,8,926),
(7,0,9,1338),
(7,0,14,1275),
(7,0,15,1313),
(7,0,16,1163),
(7,0,30,1263),
(7,0,31,907),
(7,0,32,303),
(7,0,35,275),
(7,0,36,914),
(7,0,37,937),
(7,0,38,304),
(7,0,39,1304),
(7,0,40,906),
(7,0,41,929),
(7,0,42,1026),
(7,0,43,1162),
(7,0,45,1332),
(7,0,49,1334),
(7,0,63,1161),
(7,303,0,1182),
(7,303,1,1318),
(7,303,2,941),
(7,303,3,1279),
(7,303,4,1281),
(7,303,5,1329),
(7,907,0,1063),
(7,907,1,1298),
(7,907,2,890),
(7,907,3,1167),
(7,907,4,1165),
(7,907,5,1166),
(8,0,3,620),
(8,0,4,613),
(8,0,5,621),
(8,0,6,649),
(8,0,7,648),
(8,0,8,632),
(8,0,9,619),
(8,0,14,408),
(8,0,15,611),
(8,0,30,407),
(8,0,31,618),
(8,0,35,315),
(8,0,36,443),
(8,0,37,469),
(8,0,38,629),
(8,0,39,414),
(8,0,40,704),
(8,0,41,705),
(8,407,2,679),
(8,618,0,412),
(8,618,1,410),
(10,0,4,512),
(10,0,5,497),
(10,0,6,1247),
(10,0,7,423),
(10,0,8,677),
(10,0,9,1214),
(10,0,14,694),
(10,0,15,1251),
(10,0,30,442),
(10,0,31,537),
(10,0,32,792),
(10,0,35,468),
(10,0,63,1254),
(10,442,0,421),
(10,442,1,538),
(10,792,2,650),
(10,792,3,651),
(10,1254,0,713),
(10,1254,1,655),
(10,1254,2,654),
(10,1254,3,666),
(11,0,4,766),
(11,0,5,756),
(11,0,6,764),
(11,0,7,786),
(11,0,8,760),
(11,0,9,762),
(11,0,15,789),
(11,0,16,754),
(11,0,18,790),
(11,0,30,779),
(11,0,31,788),
(11,0,32,791),
(11,0,35,781),
(12,0,4,801),
(12,0,5,816),
(12,0,6,820),
(12,0,7,805),
(12,0,8,810),
(12,0,9,818),
(12,0,14,881),
(12,0,15,848),
(12,0,30,819),
(12,0,35,797),
(12,0,36,836),
(12,0,37,837),
(12,0,38,841),
(12,0,39,795),
(12,0,40,865),
(12,0,41,869),
(12,0,42,884),
(12,0,43,886),
(13,0,4,953),
(13,0,5,955),
(13,0,6,951),
(13,0,7,947),
(13,0,9,949),
(13,0,15,943),
(13,0,30,958),
(13,0,31,961),
(13,0,32,959),
(13,0,33,960),
(13,0,35,945),
(13,0,36,956),
(13,0,37,963),
(13,0,38,964),
(13,0,39,973),
(13,0,40,966),
(13,0,41,967),
(13,0,42,970),
(13,0,43,965),
(14,0,0,1009),
(14,0,1,999),
(14,0,4,1013),
(14,0,6,1007),
(14,0,7,1017),
(14,0,8,1015),
(14,0,9,1011),
(14,0,10,995),
(14,0,11,997),
(14,0,12,1003),
(14,0,13,1005),
(14,0,14,1001),
(14,0,30,993),
(14,0,31,1019),
(14,0,32,1021),
(14,0,33,1023),
(14,0,35,1025),
(15,0,4,1092),
(15,0,5,1094),
(15,0,6,1098),
(15,0,7,1096),
(15,0,8,1100),
(15,0,9,1090),
(15,0,15,1086),
(15,0,35,1088),
(15,0,36,1136),
(16,0,4,1122),
(16,0,5,1128),
(16,0,6,1130),
(16,0,7,1158),
(16,0,8,1124),
(16,0,9,1126),
(16,0,14,1155),
(16,0,15,1116),
(16,0,16,1120),
(16,0,30,1143),
(16,0,35,1159),
(16,0,39,1149),
(16,0,40,1150),
(16,0,41,1151),
(16,0,42,1152),
(16,0,43,1153),
(16,0,44,1154),
(16,0,45,1141),
(16,0,46,1156),
(16,0,47,1132),
(16,0,48,1144),
(16,0,49,1146),
(16,0,50,1145);
/*!40000 ALTER TABLE `character_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_pet`
--

DROP TABLE IF EXISTS `character_pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_pet` (
  `id` int(10) unsigned NOT NULL DEFAULT 0,
  `entry` int(10) unsigned NOT NULL DEFAULT 0,
  `owner` bigint(20) unsigned NOT NULL DEFAULT 0,
  `modelid` int(10) unsigned DEFAULT 0,
  `CreatedBySpell` int(10) unsigned NOT NULL DEFAULT 0,
  `PetType` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `level` smallint(5) unsigned NOT NULL DEFAULT 1,
  `exp` int(10) unsigned NOT NULL DEFAULT 0,
  `Reactstate` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `name` varchar(21) NOT NULL DEFAULT 'Pet',
  `renamed` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `slot` smallint(6) NOT NULL DEFAULT -1,
  `curhealth` int(10) unsigned NOT NULL DEFAULT 1,
  `curmana` int(10) unsigned NOT NULL DEFAULT 0,
  `savetime` int(10) unsigned NOT NULL DEFAULT 0,
  `abdata` text DEFAULT NULL,
  `specialization` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `idx_slot` (`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pet System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_pet`
--

LOCK TABLES `character_pet` WRITE;
/*!40000 ALTER TABLE `character_pet` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_pet_declinedname`
--

DROP TABLE IF EXISTS `character_pet_declinedname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_pet_declinedname` (
  `id` int(10) unsigned NOT NULL DEFAULT 0,
  `owner` int(10) unsigned NOT NULL DEFAULT 0,
  `genitive` varchar(12) NOT NULL DEFAULT '',
  `dative` varchar(12) NOT NULL DEFAULT '',
  `accusative` varchar(12) NOT NULL DEFAULT '',
  `instrumental` varchar(12) NOT NULL DEFAULT '',
  `prepositional` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `owner_key` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_pet_declinedname`
--

LOCK TABLES `character_pet_declinedname` WRITE;
/*!40000 ALTER TABLE `character_pet_declinedname` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_pet_declinedname` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_player_data_element`
--

DROP TABLE IF EXISTS `character_player_data_element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_player_data_element` (
  `characterGuid` bigint(20) unsigned NOT NULL,
  `playerDataElementCharacterId` int(10) unsigned NOT NULL,
  `floatValue` float DEFAULT NULL,
  `int64Value` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`characterGuid`,`playerDataElementCharacterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_player_data_element`
--

LOCK TABLES `character_player_data_element` WRITE;
/*!40000 ALTER TABLE `character_player_data_element` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_player_data_element` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_player_data_flag`
--

DROP TABLE IF EXISTS `character_player_data_flag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_player_data_flag` (
  `characterGuid` bigint(20) unsigned NOT NULL,
  `storageIndex` int(10) unsigned NOT NULL,
  `mask` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`characterGuid`,`storageIndex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_player_data_flag`
--

LOCK TABLES `character_player_data_flag` WRITE;
/*!40000 ALTER TABLE `character_player_data_flag` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_player_data_flag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_pvp_talent`
--

DROP TABLE IF EXISTS `character_pvp_talent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_pvp_talent` (
  `guid` bigint(20) unsigned NOT NULL,
  `talentId0` int(10) unsigned NOT NULL,
  `talentId1` int(10) unsigned NOT NULL,
  `talentId2` int(10) unsigned NOT NULL,
  `talentId3` int(10) unsigned NOT NULL,
  `talentGroup` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`talentGroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_pvp_talent`
--

LOCK TABLES `character_pvp_talent` WRITE;
/*!40000 ALTER TABLE `character_pvp_talent` DISABLE KEYS */;
INSERT INTO `character_pvp_talent` VALUES
(1,0,0,0,0,0),
(1,0,0,0,0,1),
(1,0,0,0,0,2),
(1,0,0,0,0,3),
(1,0,0,0,0,4),
(2,0,0,0,0,0),
(2,0,0,0,0,1),
(2,0,0,0,0,2),
(2,0,0,0,0,3),
(2,0,0,0,0,4),
(3,0,0,0,0,0),
(3,0,0,0,0,1),
(3,0,0,0,0,2),
(3,0,0,0,0,3),
(3,0,0,0,0,4),
(4,0,0,0,0,0),
(4,0,0,0,0,1),
(4,0,0,0,0,2),
(4,0,0,0,0,3),
(4,0,0,0,0,4),
(5,0,0,0,0,0),
(5,0,0,0,0,1),
(5,0,0,0,0,2),
(5,0,0,0,0,3),
(5,0,0,0,0,4),
(6,0,0,0,0,0),
(6,0,0,0,0,1),
(6,0,0,0,0,2),
(6,0,0,0,0,3),
(6,0,0,0,0,4),
(7,0,0,0,0,0),
(7,0,0,0,0,1),
(7,0,0,0,0,2),
(7,0,0,0,0,3),
(7,0,0,0,0,4),
(8,0,0,0,0,0),
(8,0,0,0,0,1),
(8,0,0,0,0,2),
(8,0,0,0,0,3),
(8,0,0,0,0,4),
(9,0,0,0,0,0),
(9,0,0,0,0,1),
(9,0,0,0,0,2),
(9,0,0,0,0,3),
(9,0,0,0,0,4),
(10,0,0,0,0,0),
(10,0,0,0,0,1),
(10,0,0,0,0,2),
(10,0,0,0,0,3),
(10,0,0,0,0,4),
(11,0,0,0,0,0),
(11,0,0,0,0,1),
(11,0,0,0,0,2),
(11,0,0,0,0,3),
(11,0,0,0,0,4),
(12,0,0,0,0,0),
(12,0,0,0,0,1),
(12,0,0,0,0,2),
(12,0,0,0,0,3),
(12,0,0,0,0,4),
(13,0,3058,3731,5407,0),
(13,0,0,0,0,1),
(13,0,0,0,0,2),
(13,0,0,0,0,3),
(13,0,0,0,0,4),
(14,0,0,0,0,0),
(14,0,0,0,0,1),
(14,0,0,0,0,2),
(14,0,0,0,0,3),
(14,0,0,0,0,4),
(15,0,0,0,0,0),
(15,0,0,0,0,1),
(15,0,0,0,0,2),
(15,0,0,0,0,3),
(15,0,0,0,0,4),
(16,0,0,0,0,0),
(16,0,0,0,0,1),
(16,0,0,0,0,2),
(16,0,0,0,0,3),
(16,0,0,0,0,4);
/*!40000 ALTER TABLE `character_pvp_talent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus`
--

DROP TABLE IF EXISTS `character_queststatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `quest` int(10) unsigned NOT NULL DEFAULT 0,
  `status` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `explored` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `acceptTime` bigint(20) NOT NULL DEFAULT 0,
  `endTime` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`quest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus`
--

LOCK TABLES `character_queststatus` WRITE;
/*!40000 ALTER TABLE `character_queststatus` DISABLE KEYS */;
INSERT INTO `character_queststatus` VALUES
(4,9454,3,0,1762370049,0),
(4,9538,3,0,1762370110,0),
(4,9628,3,0,1762722969,0),
(4,9641,3,0,1762722497,0),
(4,9648,3,0,1762724458,0),
(4,9748,3,0,1762722511,0),
(4,9779,3,0,1762722506,0),
(6,483,3,0,1762826900,0),
(6,932,3,0,1762827670,0),
(6,13945,3,0,1762826903,0),
(6,13946,3,0,1762827679,0),
(7,937,3,0,1762882135,0),
(7,2499,3,0,1762883287,0),
(7,2518,3,0,1762882141,0),
(7,4493,1,0,1762884453,0),
(7,26383,1,0,1762884467,0),
(7,31555,3,0,1762816224,0),
(7,46727,3,0,1762836574,0),
(8,25792,3,0,1762666620,0),
(10,26383,1,0,1762848146,0),
(10,31555,3,0,1762844524,0),
(10,46727,3,0,1762847501,0),
(12,929,3,0,1762742430,0),
(13,31555,3,0,1762825969,0),
(13,55660,1,0,1762821250,0),
(13,75891,3,0,1762827888,0),
(13,84224,1,0,1762821250,0),
(14,64864,3,0,1762829841,0),
(15,24470,3,0,1762834938,0),
(16,56034,3,0,1762836156,0);
/*!40000 ALTER TABLE `character_queststatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_daily`
--

DROP TABLE IF EXISTS `character_queststatus_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_daily` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Quest Identifier',
  `time` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`quest`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_daily`
--

LOCK TABLES `character_queststatus_daily` WRITE;
/*!40000 ALTER TABLE `character_queststatus_daily` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_daily` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_monthly`
--

DROP TABLE IF EXISTS `character_queststatus_monthly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_monthly` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Quest Identifier',
  PRIMARY KEY (`guid`,`quest`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_monthly`
--

LOCK TABLES `character_queststatus_monthly` WRITE;
/*!40000 ALTER TABLE `character_queststatus_monthly` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_monthly` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_objectives`
--

DROP TABLE IF EXISTS `character_queststatus_objectives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_objectives` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `quest` int(10) unsigned NOT NULL DEFAULT 0,
  `objective` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `data` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`quest`,`objective`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_objectives`
--

LOCK TABLES `character_queststatus_objectives` WRITE;
/*!40000 ALTER TABLE `character_queststatus_objectives` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_objectives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_objectives_criteria`
--

DROP TABLE IF EXISTS `character_queststatus_objectives_criteria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_objectives_criteria` (
  `guid` bigint(20) unsigned NOT NULL,
  `questObjectiveId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`questObjectiveId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_objectives_criteria`
--

LOCK TABLES `character_queststatus_objectives_criteria` WRITE;
/*!40000 ALTER TABLE `character_queststatus_objectives_criteria` DISABLE KEYS */;
INSERT INTO `character_queststatus_objectives_criteria` VALUES
(2,388875),
(2,396763),
(3,388875),
(3,396763),
(11,388875),
(11,396763);
/*!40000 ALTER TABLE `character_queststatus_objectives_criteria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_objectives_criteria_progress`
--

DROP TABLE IF EXISTS `character_queststatus_objectives_criteria_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_objectives_criteria_progress` (
  `guid` bigint(20) unsigned NOT NULL,
  `criteriaId` int(10) unsigned NOT NULL,
  `counter` bigint(20) unsigned NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`criteriaId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_objectives_criteria_progress`
--

LOCK TABLES `character_queststatus_objectives_criteria_progress` WRITE;
/*!40000 ALTER TABLE `character_queststatus_objectives_criteria_progress` DISABLE KEYS */;
INSERT INTO `character_queststatus_objectives_criteria_progress` VALUES
(2,47930,1,1762228239),
(2,47933,1,1762228216),
(3,47930,1,1762262035),
(3,47933,1,1762262032),
(11,47930,1,1762668407),
(11,47933,1,1762668419);
/*!40000 ALTER TABLE `character_queststatus_objectives_criteria_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_objectives_spawn_tracking`
--

DROP TABLE IF EXISTS `character_queststatus_objectives_spawn_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_objectives_spawn_tracking` (
  `guid` bigint(20) unsigned NOT NULL,
  `quest` int(10) unsigned NOT NULL,
  `objective` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `spawnTrackingId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`quest`,`objective`,`spawnTrackingId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_objectives_spawn_tracking`
--

LOCK TABLES `character_queststatus_objectives_spawn_tracking` WRITE;
/*!40000 ALTER TABLE `character_queststatus_objectives_spawn_tracking` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_objectives_spawn_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_rewarded`
--

DROP TABLE IF EXISTS `character_queststatus_rewarded`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_rewarded` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Quest Identifier',
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`guid`,`quest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_rewarded`
--

LOCK TABLES `character_queststatus_rewarded` WRITE;
/*!40000 ALTER TABLE `character_queststatus_rewarded` DISABLE KEYS */;
INSERT INTO `character_queststatus_rewarded` VALUES
(3,54951,1),
(3,54952,1),
(3,55122,1),
(3,55173,1),
(3,55174,1),
(3,55184,1),
(3,55186,1),
(3,55193,1),
(3,55194,1),
(3,55879,1),
(3,55965,1),
(3,56034,1),
(3,56051,1),
(3,56775,1),
(3,58208,1),
(3,58209,1),
(3,58882,1),
(3,58883,1),
(3,59254,1),
(3,59610,1),
(4,9279,1),
(4,9280,1),
(4,9283,1),
(4,9290,1),
(4,9293,1),
(4,9294,1),
(4,9314,1),
(4,9371,1),
(4,9409,1),
(4,9452,1),
(4,9453,1),
(4,9559,1),
(4,9581,1),
(4,9603,1),
(4,9604,1),
(4,9605,1),
(4,9606,1),
(4,9616,1),
(4,9620,1),
(4,9623,1),
(4,9625,1),
(4,9663,1),
(4,9666,1),
(4,9668,1),
(4,9671,1),
(4,9753,1),
(4,9799,1),
(4,10302,1),
(4,10304,1),
(6,475,1),
(6,476,1),
(6,488,1),
(6,489,1),
(6,929,1),
(6,2159,1),
(6,2438,1),
(6,2459,1),
(6,6341,1),
(6,6342,1),
(6,6343,1),
(6,6344,1),
(6,28713,1),
(6,28714,1),
(6,28715,1),
(6,28723,1),
(6,28724,1),
(6,28725,1),
(6,28726,1),
(6,28727,1),
(6,28728,1),
(6,28729,1),
(6,28730,1),
(6,28731,1),
(7,475,1),
(7,476,1),
(7,483,1),
(7,486,1),
(7,487,1),
(7,488,1),
(7,489,1),
(7,918,1),
(7,919,1),
(7,922,1),
(7,923,1),
(7,929,1),
(7,930,1),
(7,932,1),
(7,933,1),
(7,935,1),
(7,997,1),
(7,2159,1),
(7,2438,1),
(7,2459,1),
(7,2541,1),
(7,2561,1),
(7,6341,1),
(7,6342,1),
(7,6343,1),
(7,6344,1),
(7,7383,1),
(7,13945,1),
(7,13946,1),
(7,14005,1),
(7,14039,1),
(7,28713,1),
(7,28714,1),
(7,28715,1),
(7,28723,1),
(7,28724,1),
(7,28725,1),
(7,28726,1),
(7,28727,1),
(7,28728,1),
(7,28729,1),
(7,28730,1),
(7,28731,1),
(8,11,1),
(8,35,1),
(8,37,1),
(8,40,1),
(8,45,1),
(8,46,1),
(8,47,1),
(8,52,1),
(8,54,1),
(8,59,1),
(8,60,1),
(8,62,1),
(8,71,1),
(8,76,1),
(8,83,1),
(8,123,1),
(8,147,1),
(8,176,1),
(8,184,1),
(8,239,1),
(8,313,1),
(8,315,1),
(8,384,1),
(8,412,1),
(8,1097,1),
(8,5545,1),
(8,25667,1),
(8,25668,1),
(8,25724,1),
(8,26152,1),
(8,26378,1),
(8,26380,1),
(8,26389,1),
(8,26390,1),
(8,26391,1),
(8,26393,1),
(8,26394,1),
(8,26395,1),
(8,26396,1),
(8,28762,1),
(8,28770,1),
(8,28785,1),
(8,28793,1),
(8,28809,1),
(8,28819,1),
(8,37112,1),
(10,475,1),
(10,476,1),
(10,483,1),
(10,486,1),
(10,487,1),
(10,488,1),
(10,489,1),
(10,918,1),
(10,919,1),
(10,922,1),
(10,923,1),
(10,929,1),
(10,930,1),
(10,931,1),
(10,932,1),
(10,933,1),
(10,935,1),
(10,937,1),
(10,997,1),
(10,2159,1),
(10,2399,1),
(10,2438,1),
(10,2459,1),
(10,2499,1),
(10,2518,1),
(10,2541,1),
(10,2561,1),
(10,6341,1),
(10,6342,1),
(10,6343,1),
(10,6344,1),
(10,7383,1),
(10,13945,1),
(10,13946,1),
(10,14005,1),
(10,14039,1),
(10,28713,1),
(10,28714,1),
(10,28715,1),
(10,28723,1),
(10,28724,1),
(10,28725,1),
(10,28726,1),
(10,28727,1),
(10,28728,1),
(10,28729,1),
(10,28730,1),
(10,28731,1),
(11,54951,1),
(11,54952,1),
(11,55122,1),
(11,55173,1),
(11,55174,1),
(11,55184,1),
(11,55186,1),
(11,55193,1),
(11,55194,1),
(11,55879,1),
(11,55965,1),
(11,56034,1),
(11,56775,1),
(11,58208,1),
(11,58209,1),
(11,58882,1),
(11,58883,1),
(11,59254,1),
(11,59610,1),
(12,28713,1),
(12,28714,1),
(12,28715,1),
(12,28723,1),
(12,28724,1),
(12,28725,1),
(12,28726,1),
(12,28727,1),
(12,28728,1),
(12,28729,1),
(12,28730,1),
(12,28731,1),
(13,929,1),
(13,28713,1),
(13,28714,1),
(13,28715,1),
(13,28723,1),
(13,28724,1),
(13,28725,1),
(13,28726,1),
(13,28727,1),
(13,28728,1),
(13,28729,1),
(13,28730,1),
(13,28731,1),
(13,75890,1),
(15,24469,1),
(16,54951,1),
(16,54952,1),
(16,55122,1),
(16,55173,1),
(16,55174,1),
(16,55184,1),
(16,55186,1),
(16,55193,1),
(16,56051,1),
(16,56775,1),
(16,58208,1),
(16,58209,1),
(16,58882,1),
(16,58883,1),
(16,59254,1);
/*!40000 ALTER TABLE `character_queststatus_rewarded` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_seasonal`
--

DROP TABLE IF EXISTS `character_queststatus_seasonal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_seasonal` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Quest Identifier',
  `event` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Event Identifier',
  `completedTime` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`quest`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_seasonal`
--

LOCK TABLES `character_queststatus_seasonal` WRITE;
/*!40000 ALTER TABLE `character_queststatus_seasonal` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_seasonal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_queststatus_weekly`
--

DROP TABLE IF EXISTS `character_queststatus_weekly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_queststatus_weekly` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Quest Identifier',
  PRIMARY KEY (`guid`,`quest`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_queststatus_weekly`
--

LOCK TABLES `character_queststatus_weekly` WRITE;
/*!40000 ALTER TABLE `character_queststatus_weekly` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_weekly` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_reputation`
--

DROP TABLE IF EXISTS `character_reputation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_reputation` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `faction` smallint(5) unsigned NOT NULL DEFAULT 0,
  `standing` int(11) NOT NULL DEFAULT 0,
  `flags` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`faction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_reputation`
--

LOCK TABLES `character_reputation` WRITE;
/*!40000 ALTER TABLE `character_reputation` DISABLE KEYS */;
INSERT INTO `character_reputation` VALUES
(3,21,0,64),
(3,46,0,4),
(3,47,0,273),
(3,54,0,273),
(3,59,0,16),
(3,67,0,14),
(3,68,0,6),
(3,69,0,273),
(3,70,0,2),
(3,72,0,17),
(3,76,0,6),
(3,81,0,6),
(3,83,0,4),
(3,86,0,4),
(3,87,0,2),
(3,92,0,2),
(3,93,0,2),
(3,169,0,12),
(3,270,0,16),
(3,289,0,4),
(3,349,0,0),
(3,369,0,64),
(3,469,0,25),
(3,470,0,64),
(3,509,0,16),
(3,510,0,2),
(3,529,0,0),
(3,530,0,6),
(3,549,0,4),
(3,550,0,4),
(3,551,0,4),
(3,569,0,4),
(3,570,0,4),
(3,571,0,4),
(3,574,0,4),
(3,576,0,0),
(3,577,0,64),
(3,589,0,0),
(3,609,0,16),
(3,729,0,6),
(3,730,0,16),
(3,749,0,0),
(3,809,0,16),
(3,889,0,6),
(3,890,0,16),
(3,891,0,24),
(3,892,0,14),
(3,909,0,16),
(3,910,0,2),
(3,911,0,6),
(3,922,0,6),
(3,930,0,273),
(3,932,0,80),
(3,933,0,16),
(3,934,0,80),
(3,935,0,16),
(3,936,0,28),
(3,941,0,6),
(3,942,0,16),
(3,946,0,16),
(3,947,0,2),
(3,948,0,8),
(3,949,0,26),
(3,952,0,0),
(3,967,0,16),
(3,970,0,0),
(3,978,0,16),
(3,980,0,4120),
(3,989,0,16),
(3,990,0,16),
(3,1005,0,20),
(3,1011,0,16),
(3,1012,0,16),
(3,1015,0,2),
(3,1031,0,16),
(3,1037,0,136),
(3,1038,0,16),
(3,1050,0,16),
(3,1052,0,2),
(3,1064,0,6),
(3,1067,0,2),
(3,1068,0,16),
(3,1072,0,0),
(3,1073,0,16),
(3,1077,0,16),
(3,1085,0,6),
(3,1090,0,16),
(3,1091,0,16),
(3,1094,0,16),
(3,1097,0,4104),
(3,1098,0,16),
(3,1104,0,16),
(3,1105,0,16),
(3,1106,0,16),
(3,1117,0,12),
(3,1118,0,4104),
(3,1119,0,2),
(3,1124,0,6),
(3,1126,0,16),
(3,1133,0,6),
(3,1134,0,273),
(3,1135,0,16),
(3,1136,0,4),
(3,1137,0,4),
(3,1154,0,4),
(3,1155,0,4),
(3,1156,0,16),
(3,1158,0,16),
(3,1162,0,4104),
(3,1168,0,528),
(3,1169,0,4120),
(3,1171,0,66),
(3,1172,0,2),
(3,1173,0,16),
(3,1174,0,16),
(3,1177,0,0),
(3,1178,0,6),
(3,1204,0,16),
(3,1216,0,0),
(3,1228,0,2),
(3,1242,0,16),
(3,1245,0,4104),
(3,1269,0,16),
(3,1270,0,16),
(3,1271,0,16),
(3,1272,0,152),
(3,1273,0,18),
(3,1275,0,18),
(3,1276,0,18),
(3,1277,0,18),
(3,1278,0,18),
(3,1279,0,18),
(3,1280,0,18),
(3,1281,0,18),
(3,1282,0,18),
(3,1283,0,18),
(3,1302,0,152),
(3,1337,0,16),
(3,1341,0,16),
(3,1345,0,16),
(3,1351,0,0),
(3,1352,0,6),
(3,1353,0,273),
(3,1357,0,6),
(3,1358,0,18),
(3,1359,0,16),
(3,1374,0,2),
(3,1375,0,2),
(3,1376,0,144),
(3,1387,0,144),
(3,1388,0,2),
(3,1416,0,0),
(3,1419,0,18),
(3,1433,0,20),
(3,1435,0,16),
(3,1440,0,18),
(3,1444,0,4120),
(3,1445,0,2),
(3,1492,0,16),
(3,1515,0,16),
(3,1520,0,0),
(3,1679,0,0),
(3,1681,0,18),
(3,1682,0,16),
(3,1690,0,2),
(3,1691,0,18),
(3,1708,0,2),
(3,1710,0,16),
(3,1711,0,16),
(3,1712,0,1028),
(3,1713,0,1028),
(3,1714,0,1028),
(3,1715,0,1028),
(3,1716,0,1028),
(3,1717,0,1028),
(3,1718,0,1028),
(3,1731,0,16),
(3,1732,0,4),
(3,1733,0,18),
(3,1735,0,0),
(3,1736,0,18),
(3,1737,0,18),
(3,1738,0,18),
(3,1739,0,2),
(3,1740,0,2),
(3,1741,0,18),
(3,1815,0,4),
(3,1828,0,16),
(3,1834,0,4120),
(3,1847,0,16),
(3,1848,0,2),
(3,1849,0,16),
(3,1850,0,16),
(3,1859,0,16),
(3,1860,0,22),
(3,1861,0,22),
(3,1862,0,22),
(3,1883,0,16),
(3,1888,0,6),
(3,1894,0,16),
(3,1899,0,16),
(3,1900,0,16),
(3,1919,0,22),
(3,1947,0,20),
(3,1948,0,16),
(3,1975,0,18),
(3,1984,0,2),
(3,1989,0,4),
(3,2010,0,2),
(3,2011,0,18),
(3,2018,0,16),
(3,2045,0,16),
(3,2063,0,0),
(3,2085,0,80),
(3,2086,0,80),
(3,2087,0,80),
(3,2088,0,80),
(3,2089,0,80),
(3,2090,0,80),
(3,2091,0,80),
(3,2097,0,18),
(3,2098,0,18),
(3,2099,0,18),
(3,2100,0,18),
(3,2101,0,18),
(3,2102,0,18),
(3,2103,0,6),
(3,2104,0,4104),
(3,2111,0,6),
(3,2120,0,20),
(3,2135,0,18),
(3,2156,0,2),
(3,2157,0,2),
(3,2158,0,20),
(3,2159,0,16),
(3,2160,0,16),
(3,2161,0,16),
(3,2162,0,16),
(3,2163,0,16),
(3,2164,0,16),
(3,2165,0,16),
(3,2166,0,80),
(3,2167,0,80),
(3,2170,0,16),
(3,2233,0,6),
(3,2264,0,20),
(3,2265,0,20),
(3,2370,0,6),
(3,2371,0,18),
(3,2372,0,2),
(3,2373,0,20),
(3,2374,0,84),
(3,2375,0,6),
(3,2376,0,6),
(3,2377,0,6),
(3,2378,0,70),
(3,2379,0,80),
(3,2380,0,66),
(3,2381,0,80),
(3,2382,0,84),
(3,2383,0,80),
(3,2384,0,80),
(3,2385,0,66),
(3,2386,0,80),
(3,2387,0,80),
(3,2388,0,2),
(3,2389,0,2),
(3,2390,0,2),
(3,2391,0,16),
(3,2392,0,80),
(3,2395,0,16),
(3,2396,0,22),
(3,2397,0,22),
(3,2398,0,22),
(3,2400,0,16),
(3,2401,0,80),
(3,2407,0,16),
(3,2410,0,16),
(3,2413,0,16),
(3,2414,0,4104),
(3,2415,0,16),
(3,2416,0,80),
(3,2417,0,16),
(3,2418,0,80),
(3,2422,0,20),
(3,2427,0,6),
(3,2431,0,0),
(3,2432,0,18),
(3,2439,0,0),
(3,2440,0,80),
(3,2441,0,80),
(3,2442,0,80),
(3,2444,0,80),
(3,2445,0,152),
(3,2446,0,18),
(3,2447,0,18),
(3,2448,0,18),
(3,2449,0,18),
(3,2450,0,18),
(3,2451,0,18),
(3,2452,0,18),
(3,2453,0,18),
(3,2454,0,18),
(3,2455,0,18),
(3,2456,0,18),
(3,2457,0,18),
(3,2458,0,18),
(3,2459,0,18),
(3,2460,0,18),
(3,2461,0,18),
(3,2462,0,18),
(3,2463,0,22),
(3,2464,0,18),
(3,2465,0,16),
(3,2469,0,18),
(3,2470,0,16),
(3,2471,0,80),
(3,2472,0,18),
(3,2473,0,80),
(3,2474,0,80),
(3,2478,0,16),
(3,2479,0,80),
(3,2503,0,16),
(3,2504,0,80),
(3,2506,0,4120),
(3,2507,0,152),
(3,2508,0,80),
(3,2509,0,2068),
(3,2510,0,152),
(3,2511,0,16),
(3,2512,0,2068),
(3,2513,0,2068),
(3,2517,0,18),
(3,2518,0,18),
(3,2520,0,2054),
(3,2521,0,2132),
(3,2522,0,2068),
(3,2523,0,2),
(3,2524,0,272),
(3,2526,0,0),
(3,2542,0,2054),
(3,2544,0,18),
(3,2550,0,18),
(3,2551,0,80),
(3,2552,0,80),
(3,2553,0,18),
(3,2554,0,2052),
(3,2555,0,2054),
(3,2564,0,16),
(3,2565,0,80),
(3,2568,0,18),
(3,2569,0,24),
(3,2570,0,16),
(3,2574,0,16),
(3,2575,0,64),
(3,2590,0,16),
(3,2593,0,16),
(3,2594,0,16),
(3,2596,0,80),
(3,2600,0,4248),
(3,2601,0,18),
(3,2604,0,80),
(3,2605,0,18),
(3,2607,0,18),
(3,2611,0,80),
(3,2612,0,80),
(3,2613,0,80),
(3,2615,0,18),
(3,2640,0,18),
(3,2644,0,0),
(3,2645,0,2068),
(3,2647,0,80),
(3,2648,0,80),
(3,2649,0,80),
(3,2653,0,152),
(3,2658,0,16),
(3,2659,0,80),
(3,2667,0,80),
(3,2668,0,80),
(3,2669,0,16),
(3,2670,0,80),
(3,2671,0,16),
(3,2672,0,80),
(3,2673,0,16),
(3,2674,0,80),
(3,2675,0,16),
(3,2676,0,80),
(3,2677,0,16),
(3,2683,0,0),
(3,2684,0,80),
(3,2685,0,16),
(3,2688,0,16),
(3,2689,0,80),
(3,2693,0,4248),
(3,2695,0,20),
(3,2697,0,4),
(3,2722,0,0),
(3,2736,0,16),
(3,2739,0,0),
(4,21,0,64),
(4,46,0,4),
(4,47,888,273),
(4,54,888,273),
(4,59,0,16),
(4,67,0,14),
(4,68,0,6),
(4,69,888,273),
(4,70,0,2),
(4,72,888,273),
(4,76,0,6),
(4,81,0,6),
(4,83,0,4),
(4,86,0,4),
(4,87,0,2),
(4,92,0,2),
(4,93,0,2),
(4,169,0,12),
(4,270,0,16),
(4,289,0,4),
(4,349,0,0),
(4,369,0,64),
(4,469,0,25),
(4,470,0,64),
(4,509,0,16),
(4,510,0,2),
(4,529,0,0),
(4,530,0,6),
(4,549,0,4),
(4,550,0,4),
(4,551,0,4),
(4,569,0,4),
(4,570,0,4),
(4,571,0,4),
(4,574,0,4),
(4,576,0,0),
(4,577,0,64),
(4,589,0,0),
(4,609,0,16),
(4,729,0,6),
(4,730,0,16),
(4,749,0,0),
(4,809,0,16),
(4,889,0,6),
(4,890,0,16),
(4,891,0,24),
(4,892,0,14),
(4,909,0,16),
(4,910,0,2),
(4,911,0,6),
(4,922,0,6),
(4,930,3865,17),
(4,932,0,80),
(4,933,0,16),
(4,934,0,80),
(4,935,0,16),
(4,936,0,28),
(4,941,0,6),
(4,942,0,16),
(4,946,0,16),
(4,947,0,2),
(4,948,0,8),
(4,949,0,26),
(4,952,0,0),
(4,967,0,16),
(4,970,0,0),
(4,978,0,16),
(4,980,0,4120),
(4,989,0,16),
(4,990,0,16),
(4,1005,0,20),
(4,1011,0,16),
(4,1012,0,16),
(4,1015,0,2),
(4,1031,0,16),
(4,1037,0,136),
(4,1038,0,16),
(4,1050,0,16),
(4,1052,0,2),
(4,1064,0,6),
(4,1067,0,2),
(4,1068,0,16),
(4,1072,0,0),
(4,1073,0,16),
(4,1077,0,16),
(4,1085,0,6),
(4,1090,0,16),
(4,1091,0,16),
(4,1094,0,16),
(4,1097,0,4104),
(4,1098,0,16),
(4,1104,0,16),
(4,1105,0,16),
(4,1106,0,16),
(4,1117,0,12),
(4,1118,0,4104),
(4,1119,0,2),
(4,1124,0,6),
(4,1126,0,16),
(4,1133,0,6),
(4,1134,888,273),
(4,1135,0,16),
(4,1136,0,4),
(4,1137,0,4),
(4,1154,0,4),
(4,1155,0,4),
(4,1156,0,16),
(4,1158,0,16),
(4,1162,0,4104),
(4,1168,0,528),
(4,1169,0,4120),
(4,1171,0,66),
(4,1172,0,2),
(4,1173,0,16),
(4,1174,0,16),
(4,1177,0,0),
(4,1178,0,6),
(4,1204,0,16),
(4,1216,0,0),
(4,1228,0,2),
(4,1242,0,16),
(4,1245,0,4104),
(4,1269,0,16),
(4,1270,0,16),
(4,1271,0,16),
(4,1272,0,152),
(4,1273,0,18),
(4,1275,0,18),
(4,1276,0,18),
(4,1277,0,18),
(4,1278,0,18),
(4,1279,0,18),
(4,1280,0,18),
(4,1281,0,18),
(4,1282,0,18),
(4,1283,0,18),
(4,1302,0,152),
(4,1337,0,16),
(4,1341,0,16),
(4,1345,0,16),
(4,1351,0,0),
(4,1352,0,6),
(4,1353,0,273),
(4,1357,0,6),
(4,1358,0,18),
(4,1359,0,16),
(4,1374,0,2),
(4,1375,0,2),
(4,1376,0,144),
(4,1387,0,144),
(4,1388,0,2),
(4,1416,0,0),
(4,1419,0,18),
(4,1433,0,20),
(4,1435,0,16),
(4,1440,0,18),
(4,1444,0,4120),
(4,1445,0,2),
(4,1492,0,16),
(4,1515,0,16),
(4,1520,0,0),
(4,1679,0,0),
(4,1681,0,18),
(4,1682,0,16),
(4,1690,0,2),
(4,1691,0,18),
(4,1708,0,2),
(4,1710,0,16),
(4,1711,0,16),
(4,1712,0,1028),
(4,1713,0,1028),
(4,1714,0,1028),
(4,1715,0,1028),
(4,1716,0,1028),
(4,1717,0,1028),
(4,1718,0,1028),
(4,1731,0,16),
(4,1732,0,4),
(4,1733,0,18),
(4,1735,0,0),
(4,1736,0,18),
(4,1737,0,18),
(4,1738,0,18),
(4,1739,0,2),
(4,1740,0,2),
(4,1741,0,18),
(4,1815,0,4),
(4,1828,0,16),
(4,1834,0,4120),
(4,1847,0,16),
(4,1848,0,2),
(4,1849,0,16),
(4,1850,0,16),
(4,1859,0,16),
(4,1860,0,22),
(4,1861,0,22),
(4,1862,0,22),
(4,1883,0,16),
(4,1888,0,6),
(4,1894,0,16),
(4,1899,0,16),
(4,1900,0,16),
(4,1919,0,22),
(4,1947,0,20),
(4,1948,0,16),
(4,1975,0,18),
(4,1984,0,2),
(4,1989,0,4),
(4,2010,0,2),
(4,2011,0,18),
(4,2018,0,16),
(4,2045,0,16),
(4,2063,0,0),
(4,2085,0,80),
(4,2086,0,80),
(4,2087,0,80),
(4,2088,0,80),
(4,2089,0,80),
(4,2090,0,80),
(4,2091,0,80),
(4,2097,0,18),
(4,2098,0,18),
(4,2099,0,18),
(4,2100,0,18),
(4,2101,0,18),
(4,2102,0,18),
(4,2103,0,6),
(4,2104,0,4104),
(4,2111,0,6),
(4,2120,0,20),
(4,2135,0,18),
(4,2156,0,2),
(4,2157,0,2),
(4,2158,0,20),
(4,2159,0,16),
(4,2160,0,16),
(4,2161,0,16),
(4,2162,0,16),
(4,2163,0,16),
(4,2164,0,16),
(4,2165,0,16),
(4,2166,0,80),
(4,2167,0,80),
(4,2170,0,16),
(4,2233,0,6),
(4,2264,0,20),
(4,2265,0,20),
(4,2370,0,6),
(4,2371,0,18),
(4,2372,0,2),
(4,2373,0,20),
(4,2374,0,84),
(4,2375,0,6),
(4,2376,0,6),
(4,2377,0,6),
(4,2378,0,70),
(4,2379,0,80),
(4,2380,0,66),
(4,2381,0,80),
(4,2382,0,84),
(4,2383,0,80),
(4,2384,0,80),
(4,2385,0,66),
(4,2386,0,80),
(4,2387,0,80),
(4,2388,0,2),
(4,2389,0,2),
(4,2390,0,2),
(4,2391,0,16),
(4,2392,0,80),
(4,2395,0,16),
(4,2396,0,22),
(4,2397,0,22),
(4,2398,0,22),
(4,2400,0,16),
(4,2401,0,80),
(4,2407,0,16),
(4,2410,0,16),
(4,2413,0,16),
(4,2414,0,4104),
(4,2415,0,16),
(4,2416,0,80),
(4,2417,0,16),
(4,2418,0,80),
(4,2422,0,20),
(4,2427,0,6),
(4,2431,0,0),
(4,2432,0,18),
(4,2439,0,0),
(4,2440,0,80),
(4,2441,0,80),
(4,2442,0,80),
(4,2444,0,80),
(4,2445,0,152),
(4,2446,0,18),
(4,2447,0,18),
(4,2448,0,18),
(4,2449,0,18),
(4,2450,0,18),
(4,2451,0,18),
(4,2452,0,18),
(4,2453,0,18),
(4,2454,0,18),
(4,2455,0,18),
(4,2456,0,18),
(4,2457,0,18),
(4,2458,0,18),
(4,2459,0,18),
(4,2460,0,18),
(4,2461,0,18),
(4,2462,0,18),
(4,2463,0,22),
(4,2464,0,18),
(4,2465,0,16),
(4,2469,0,18),
(4,2470,0,16),
(4,2471,0,80),
(4,2472,0,18),
(4,2473,0,80),
(4,2474,0,80),
(4,2478,0,16),
(4,2479,0,80),
(4,2503,0,16),
(4,2504,0,80),
(4,2506,0,4120),
(4,2507,0,152),
(4,2508,0,80),
(4,2509,0,2068),
(4,2510,0,152),
(4,2511,0,16),
(4,2512,0,2068),
(4,2513,0,2068),
(4,2517,0,18),
(4,2518,0,18),
(4,2520,0,2054),
(4,2521,0,2132),
(4,2522,0,2068),
(4,2523,0,2),
(4,2524,0,272),
(4,2526,0,0),
(4,2542,0,2054),
(4,2544,0,18),
(4,2550,0,18),
(4,2551,0,80),
(4,2552,0,80),
(4,2553,0,18),
(4,2554,0,2052),
(4,2555,0,2054),
(4,2564,0,16),
(4,2565,0,80),
(4,2568,0,18),
(4,2569,0,24),
(4,2570,0,16),
(4,2574,0,16),
(4,2575,0,64),
(4,2590,0,16),
(4,2593,0,16),
(4,2594,0,16),
(4,2596,0,80),
(4,2600,0,4248),
(4,2601,0,18),
(4,2604,0,80),
(4,2605,0,18),
(4,2607,0,18),
(4,2611,0,80),
(4,2612,0,80),
(4,2613,0,80),
(4,2615,0,18),
(4,2640,0,18),
(4,2644,0,0),
(4,2645,0,2068),
(4,2647,0,80),
(4,2648,0,80),
(4,2649,0,80),
(4,2653,0,152),
(4,2658,0,16),
(4,2659,0,80),
(4,2667,0,80),
(4,2668,0,80),
(4,2669,0,16),
(4,2670,0,80),
(4,2671,0,16),
(4,2672,0,80),
(4,2673,0,16),
(4,2674,0,80),
(4,2675,0,16),
(4,2676,0,80),
(4,2677,0,16),
(4,2683,0,0),
(4,2684,0,80),
(4,2685,0,16),
(4,2688,0,16),
(4,2689,0,80),
(4,2693,0,4248),
(4,2695,0,276),
(4,2697,0,4),
(4,2722,0,0),
(4,2736,0,16),
(4,2739,0,0),
(6,21,0,64),
(6,46,0,4),
(6,47,160,273),
(6,54,160,273),
(6,59,0,16),
(6,67,0,14),
(6,68,0,6),
(6,69,4350,17),
(6,70,0,2),
(6,72,160,273),
(6,76,0,6),
(6,81,0,6),
(6,83,0,4),
(6,86,0,4),
(6,87,0,2),
(6,92,0,2),
(6,93,0,2),
(6,169,0,12),
(6,270,0,16),
(6,289,0,4),
(6,349,0,0),
(6,369,0,64),
(6,469,0,25),
(6,470,0,64),
(6,509,0,16),
(6,510,0,2),
(6,529,0,0),
(6,530,0,6),
(6,549,0,4),
(6,550,0,4),
(6,551,0,4),
(6,569,0,4),
(6,570,0,4),
(6,571,0,4),
(6,574,0,4),
(6,576,0,0),
(6,577,0,64),
(6,589,0,0),
(6,609,0,16),
(6,729,0,6),
(6,730,0,16),
(6,749,0,0),
(6,809,0,16),
(6,889,0,6),
(6,890,0,16),
(6,891,0,24),
(6,892,0,14),
(6,909,0,16),
(6,910,0,2),
(6,911,0,6),
(6,922,0,6),
(6,930,160,273),
(6,932,0,80),
(6,933,0,16),
(6,934,0,80),
(6,935,0,16),
(6,936,0,28),
(6,941,0,6),
(6,942,0,16),
(6,946,0,16),
(6,947,0,2),
(6,948,0,8),
(6,949,0,26),
(6,952,0,0),
(6,967,0,16),
(6,970,0,0),
(6,978,0,16),
(6,980,0,4120),
(6,989,0,16),
(6,990,0,16),
(6,1005,0,20),
(6,1011,0,16),
(6,1012,0,16),
(6,1015,0,2),
(6,1031,0,16),
(6,1037,0,136),
(6,1038,0,16),
(6,1050,0,16),
(6,1052,0,2),
(6,1064,0,6),
(6,1067,0,2),
(6,1068,0,16),
(6,1072,0,0),
(6,1073,0,16),
(6,1077,0,16),
(6,1085,0,6),
(6,1090,0,16),
(6,1091,0,16),
(6,1094,0,16),
(6,1097,0,4104),
(6,1098,0,16),
(6,1104,0,16),
(6,1105,0,16),
(6,1106,0,16),
(6,1117,0,12),
(6,1118,0,4104),
(6,1119,0,2),
(6,1124,0,6),
(6,1126,0,16),
(6,1133,0,6),
(6,1134,160,273),
(6,1135,0,16),
(6,1136,0,4),
(6,1137,0,4),
(6,1154,0,4),
(6,1155,0,4),
(6,1156,0,16),
(6,1158,0,16),
(6,1162,0,4104),
(6,1168,0,528),
(6,1169,0,4120),
(6,1171,0,66),
(6,1172,0,2),
(6,1173,0,16),
(6,1174,0,16),
(6,1177,0,0),
(6,1178,0,6),
(6,1204,0,16),
(6,1216,0,0),
(6,1228,0,2),
(6,1242,0,16),
(6,1245,0,4104),
(6,1269,0,16),
(6,1270,0,16),
(6,1271,0,16),
(6,1272,0,152),
(6,1273,0,18),
(6,1275,0,18),
(6,1276,0,18),
(6,1277,0,18),
(6,1278,0,18),
(6,1279,0,18),
(6,1280,0,18),
(6,1281,0,18),
(6,1282,0,18),
(6,1283,0,18),
(6,1302,0,152),
(6,1337,0,16),
(6,1341,0,16),
(6,1345,0,16),
(6,1351,0,0),
(6,1352,0,6),
(6,1353,0,273),
(6,1357,0,6),
(6,1358,0,18),
(6,1359,0,16),
(6,1374,0,2),
(6,1375,0,2),
(6,1376,0,144),
(6,1387,0,144),
(6,1388,0,2),
(6,1416,0,0),
(6,1419,0,18),
(6,1433,0,20),
(6,1435,0,16),
(6,1440,0,18),
(6,1444,0,4120),
(6,1445,0,2),
(6,1492,0,16),
(6,1515,0,16),
(6,1520,0,0),
(6,1679,0,0),
(6,1681,0,18),
(6,1682,0,16),
(6,1690,0,2),
(6,1691,0,18),
(6,1708,0,2),
(6,1710,0,16),
(6,1711,0,16),
(6,1712,0,1028),
(6,1713,0,1028),
(6,1714,0,1028),
(6,1715,0,1028),
(6,1716,0,1028),
(6,1717,0,1028),
(6,1718,0,1028),
(6,1731,0,16),
(6,1732,0,4),
(6,1733,0,18),
(6,1735,0,0),
(6,1736,0,18),
(6,1737,0,18),
(6,1738,0,18),
(6,1739,0,2),
(6,1740,0,2),
(6,1741,0,18),
(6,1815,0,4),
(6,1828,0,16),
(6,1834,0,4120),
(6,1847,0,16),
(6,1848,0,2),
(6,1849,0,16),
(6,1850,0,16),
(6,1859,0,16),
(6,1860,0,22),
(6,1861,0,22),
(6,1862,0,22),
(6,1883,0,16),
(6,1888,0,6),
(6,1894,0,16),
(6,1899,0,16),
(6,1900,0,16),
(6,1919,0,22),
(6,1947,0,20),
(6,1948,0,16),
(6,1975,0,18),
(6,1984,0,2),
(6,1989,0,4),
(6,2010,0,2),
(6,2011,0,18),
(6,2018,0,16),
(6,2045,0,16),
(6,2063,0,0),
(6,2085,0,80),
(6,2086,0,80),
(6,2087,0,80),
(6,2088,0,80),
(6,2089,0,80),
(6,2090,0,80),
(6,2091,0,80),
(6,2097,0,18),
(6,2098,0,18),
(6,2099,0,18),
(6,2100,0,18),
(6,2101,0,18),
(6,2102,0,18),
(6,2103,0,6),
(6,2104,0,4104),
(6,2111,0,6),
(6,2120,0,20),
(6,2135,0,18),
(6,2156,0,2),
(6,2157,0,2),
(6,2158,0,20),
(6,2159,0,16),
(6,2160,0,16),
(6,2161,0,16),
(6,2162,0,16),
(6,2163,0,16),
(6,2164,0,16),
(6,2165,0,16),
(6,2166,0,80),
(6,2167,0,80),
(6,2170,0,16),
(6,2233,0,6),
(6,2264,0,20),
(6,2265,0,20),
(6,2370,0,6),
(6,2371,0,18),
(6,2372,0,2),
(6,2373,0,20),
(6,2374,0,84),
(6,2375,0,6),
(6,2376,0,6),
(6,2377,0,6),
(6,2378,0,70),
(6,2379,0,80),
(6,2380,0,66),
(6,2381,0,80),
(6,2382,0,84),
(6,2383,0,80),
(6,2384,0,80),
(6,2385,0,66),
(6,2386,0,80),
(6,2387,0,80),
(6,2388,0,2),
(6,2389,0,2),
(6,2390,0,2),
(6,2391,0,16),
(6,2392,0,80),
(6,2395,0,16),
(6,2396,0,22),
(6,2397,0,22),
(6,2398,0,22),
(6,2400,0,16),
(6,2401,0,80),
(6,2407,0,16),
(6,2410,0,16),
(6,2413,0,16),
(6,2414,0,4104),
(6,2415,0,16),
(6,2416,0,80),
(6,2417,0,16),
(6,2418,0,80),
(6,2422,0,20),
(6,2427,0,6),
(6,2431,0,0),
(6,2432,0,18),
(6,2439,0,0),
(6,2440,0,80),
(6,2441,0,80),
(6,2442,0,80),
(6,2444,0,80),
(6,2445,0,152),
(6,2446,0,18),
(6,2447,0,18),
(6,2448,0,18),
(6,2449,0,18),
(6,2450,0,18),
(6,2451,0,18),
(6,2452,0,18),
(6,2453,0,18),
(6,2454,0,18),
(6,2455,0,18),
(6,2456,0,18),
(6,2457,0,18),
(6,2458,0,18),
(6,2459,0,18),
(6,2460,0,18),
(6,2461,0,18),
(6,2462,0,18),
(6,2463,0,22),
(6,2464,0,18),
(6,2465,0,16),
(6,2469,0,18),
(6,2470,0,16),
(6,2471,0,80),
(6,2472,0,18),
(6,2473,0,80),
(6,2474,0,80),
(6,2478,0,16),
(6,2479,0,80),
(6,2503,0,16),
(6,2504,0,80),
(6,2506,0,4120),
(6,2507,0,152),
(6,2508,0,80),
(6,2509,0,2068),
(6,2510,0,152),
(6,2511,0,16),
(6,2512,0,2068),
(6,2513,0,2068),
(6,2517,0,18),
(6,2518,0,18),
(6,2520,0,2054),
(6,2521,0,2132),
(6,2522,0,2068),
(6,2523,0,2),
(6,2524,0,272),
(6,2526,0,0),
(6,2542,0,2054),
(6,2544,0,18),
(6,2550,0,18),
(6,2551,0,80),
(6,2552,0,80),
(6,2553,0,18),
(6,2554,0,2052),
(6,2555,0,2054),
(6,2564,0,16),
(6,2565,0,80),
(6,2568,0,18),
(6,2569,0,24),
(6,2570,0,16),
(6,2574,0,16),
(6,2575,0,64),
(6,2590,0,16),
(6,2593,0,16),
(6,2594,0,16),
(6,2596,0,80),
(6,2600,0,4248),
(6,2601,0,18),
(6,2604,0,80),
(6,2605,0,18),
(6,2607,0,18),
(6,2611,0,80),
(6,2612,0,80),
(6,2613,0,80),
(6,2615,0,18),
(6,2640,0,18),
(6,2644,0,0),
(6,2645,0,2068),
(6,2647,0,80),
(6,2648,0,80),
(6,2649,0,80),
(6,2653,0,152),
(6,2658,0,16),
(6,2659,0,80),
(6,2667,0,80),
(6,2668,0,80),
(6,2669,0,16),
(6,2670,0,80),
(6,2671,0,16),
(6,2672,0,80),
(6,2673,0,16),
(6,2674,0,80),
(6,2675,0,16),
(6,2676,0,80),
(6,2677,0,16),
(6,2683,0,0),
(6,2684,0,80),
(6,2685,0,16),
(6,2688,0,16),
(6,2689,0,80),
(6,2693,0,4248),
(6,2695,0,276),
(6,2697,0,4),
(6,2722,0,0),
(6,2736,0,16),
(6,2739,0,0),
(7,21,0,64),
(7,46,0,4),
(7,47,495,273),
(7,54,495,273),
(7,59,0,16),
(7,67,0,14),
(7,68,0,6),
(7,69,9150,17),
(7,70,0,2),
(7,72,495,273),
(7,76,0,6),
(7,81,0,6),
(7,83,0,4),
(7,86,0,4),
(7,87,0,2),
(7,92,0,2),
(7,93,0,2),
(7,169,0,12),
(7,270,0,16),
(7,289,0,4),
(7,349,0,0),
(7,369,0,64),
(7,469,0,25),
(7,470,0,64),
(7,509,0,16),
(7,510,0,2),
(7,529,0,0),
(7,530,0,6),
(7,549,0,4),
(7,550,0,4),
(7,551,0,4),
(7,569,0,4),
(7,570,0,4),
(7,571,0,4),
(7,574,0,4),
(7,576,0,0),
(7,577,0,64),
(7,589,0,0),
(7,609,0,16),
(7,729,0,6),
(7,730,0,16),
(7,749,0,0),
(7,809,0,16),
(7,889,0,6),
(7,890,0,16),
(7,891,0,24),
(7,892,0,14),
(7,909,0,16),
(7,910,0,2),
(7,911,0,6),
(7,922,0,6),
(7,930,495,273),
(7,932,0,80),
(7,933,0,16),
(7,934,0,80),
(7,935,0,16),
(7,936,0,28),
(7,941,0,6),
(7,942,0,16),
(7,946,0,16),
(7,947,0,2),
(7,948,0,8),
(7,949,0,26),
(7,952,0,0),
(7,967,0,16),
(7,970,0,0),
(7,978,0,16),
(7,980,0,4120),
(7,989,0,16),
(7,990,0,16),
(7,1005,0,20),
(7,1011,0,16),
(7,1012,0,16),
(7,1015,0,2),
(7,1031,0,16),
(7,1037,0,136),
(7,1038,0,16),
(7,1050,0,16),
(7,1052,0,2),
(7,1064,0,6),
(7,1067,0,2),
(7,1068,0,16),
(7,1072,0,0),
(7,1073,0,16),
(7,1077,0,16),
(7,1085,0,6),
(7,1090,0,16),
(7,1091,0,16),
(7,1094,0,16),
(7,1097,0,4104),
(7,1098,0,16),
(7,1104,0,16),
(7,1105,0,16),
(7,1106,0,16),
(7,1117,0,12),
(7,1118,0,4104),
(7,1119,0,2),
(7,1124,0,6),
(7,1126,0,16),
(7,1133,0,6),
(7,1134,495,273),
(7,1135,0,16),
(7,1136,0,4),
(7,1137,0,4),
(7,1154,0,4),
(7,1155,0,4),
(7,1156,0,16),
(7,1158,0,16),
(7,1162,0,4104),
(7,1168,0,528),
(7,1169,0,4120),
(7,1171,0,66),
(7,1172,0,2),
(7,1173,0,16),
(7,1174,0,16),
(7,1177,0,0),
(7,1178,0,6),
(7,1204,0,16),
(7,1216,0,0),
(7,1228,0,2),
(7,1242,0,16),
(7,1245,0,4104),
(7,1269,0,16),
(7,1270,0,16),
(7,1271,0,16),
(7,1272,0,152),
(7,1273,0,18),
(7,1275,0,18),
(7,1276,0,18),
(7,1277,0,18),
(7,1278,0,18),
(7,1279,0,18),
(7,1280,0,18),
(7,1281,0,18),
(7,1282,0,18),
(7,1283,0,18),
(7,1302,0,152),
(7,1337,0,16),
(7,1341,0,16),
(7,1345,0,16),
(7,1351,0,0),
(7,1352,0,6),
(7,1353,0,273),
(7,1357,0,6),
(7,1358,0,18),
(7,1359,0,16),
(7,1374,0,2),
(7,1375,0,2),
(7,1376,0,144),
(7,1387,0,144),
(7,1388,0,2),
(7,1416,0,0),
(7,1419,0,18),
(7,1433,0,20),
(7,1435,0,16),
(7,1440,0,18),
(7,1444,0,4120),
(7,1445,0,2),
(7,1492,0,16),
(7,1515,0,16),
(7,1520,0,0),
(7,1679,0,0),
(7,1681,0,18),
(7,1682,0,16),
(7,1690,0,2),
(7,1691,0,18),
(7,1708,0,2),
(7,1710,0,16),
(7,1711,0,16),
(7,1712,0,1028),
(7,1713,0,1028),
(7,1714,0,1028),
(7,1715,0,1028),
(7,1716,0,1028),
(7,1717,0,1028),
(7,1718,0,1028),
(7,1731,0,16),
(7,1732,0,4),
(7,1733,0,18),
(7,1735,0,0),
(7,1736,0,18),
(7,1737,0,18),
(7,1738,0,18),
(7,1739,0,2),
(7,1740,0,2),
(7,1741,0,18),
(7,1815,0,4),
(7,1828,0,16),
(7,1834,0,4120),
(7,1847,0,16),
(7,1848,0,2),
(7,1849,0,16),
(7,1850,0,16),
(7,1859,0,16),
(7,1860,0,22),
(7,1861,0,22),
(7,1862,0,22),
(7,1883,0,16),
(7,1888,0,6),
(7,1894,0,16),
(7,1899,0,16),
(7,1900,0,16),
(7,1919,0,22),
(7,1947,0,20),
(7,1948,0,16),
(7,1975,0,18),
(7,1984,0,2),
(7,1989,0,4),
(7,2010,0,2),
(7,2011,0,18),
(7,2018,0,16),
(7,2045,0,16),
(7,2063,0,0),
(7,2085,0,80),
(7,2086,0,80),
(7,2087,0,80),
(7,2088,0,80),
(7,2089,0,80),
(7,2090,0,80),
(7,2091,0,80),
(7,2097,0,18),
(7,2098,0,18),
(7,2099,0,18),
(7,2100,0,18),
(7,2101,0,18),
(7,2102,0,18),
(7,2103,0,6),
(7,2104,0,4104),
(7,2111,0,6),
(7,2120,0,20),
(7,2135,0,18),
(7,2156,0,2),
(7,2157,0,2),
(7,2158,0,20),
(7,2159,0,16),
(7,2160,0,16),
(7,2161,0,16),
(7,2162,0,16),
(7,2163,0,16),
(7,2164,0,16),
(7,2165,0,16),
(7,2166,0,80),
(7,2167,0,80),
(7,2170,0,16),
(7,2233,0,6),
(7,2264,0,20),
(7,2265,0,20),
(7,2370,0,6),
(7,2371,0,18),
(7,2372,0,2),
(7,2373,0,20),
(7,2374,0,84),
(7,2375,0,6),
(7,2376,0,6),
(7,2377,0,6),
(7,2378,0,70),
(7,2379,0,80),
(7,2380,0,66),
(7,2381,0,80),
(7,2382,0,84),
(7,2383,0,80),
(7,2384,0,80),
(7,2385,0,66),
(7,2386,0,80),
(7,2387,0,80),
(7,2388,0,2),
(7,2389,0,2),
(7,2390,0,2),
(7,2391,0,16),
(7,2392,0,80),
(7,2395,0,16),
(7,2396,0,22),
(7,2397,0,22),
(7,2398,0,22),
(7,2400,0,16),
(7,2401,0,80),
(7,2407,0,16),
(7,2410,0,16),
(7,2413,0,16),
(7,2414,0,4104),
(7,2415,0,16),
(7,2416,0,80),
(7,2417,0,16),
(7,2418,0,80),
(7,2422,0,20),
(7,2427,0,6),
(7,2431,0,0),
(7,2432,0,18),
(7,2439,0,0),
(7,2440,0,80),
(7,2441,0,80),
(7,2442,0,80),
(7,2444,0,80),
(7,2445,0,152),
(7,2446,0,18),
(7,2447,0,18),
(7,2448,0,18),
(7,2449,0,18),
(7,2450,0,18),
(7,2451,0,18),
(7,2452,0,18),
(7,2453,0,18),
(7,2454,0,18),
(7,2455,0,18),
(7,2456,0,18),
(7,2457,0,18),
(7,2458,0,18),
(7,2459,0,18),
(7,2460,0,18),
(7,2461,0,18),
(7,2462,0,18),
(7,2463,0,22),
(7,2464,0,18),
(7,2465,0,16),
(7,2469,0,18),
(7,2470,0,16),
(7,2471,0,80),
(7,2472,0,18),
(7,2473,0,80),
(7,2474,0,80),
(7,2478,0,16),
(7,2479,0,80),
(7,2503,0,16),
(7,2504,0,80),
(7,2506,0,4120),
(7,2507,0,152),
(7,2508,0,80),
(7,2509,0,2068),
(7,2510,0,152),
(7,2511,0,16),
(7,2512,0,2068),
(7,2513,0,2068),
(7,2517,0,18),
(7,2518,0,18),
(7,2520,0,2054),
(7,2521,0,2132),
(7,2522,0,2068),
(7,2523,0,2),
(7,2524,0,272),
(7,2526,0,0),
(7,2542,0,2054),
(7,2544,0,18),
(7,2550,0,18),
(7,2551,0,80),
(7,2552,0,80),
(7,2553,0,18),
(7,2554,0,2052),
(7,2555,0,2054),
(7,2564,0,16),
(7,2565,0,80),
(7,2568,0,18),
(7,2569,0,24),
(7,2570,0,16),
(7,2574,0,16),
(7,2575,0,64),
(7,2590,0,16),
(7,2593,0,16),
(7,2594,0,16),
(7,2596,0,80),
(7,2600,0,4248),
(7,2601,0,18),
(7,2604,0,80),
(7,2605,0,18),
(7,2607,0,18),
(7,2611,0,80),
(7,2612,0,80),
(7,2613,0,80),
(7,2615,0,18),
(7,2640,0,18),
(7,2644,0,0),
(7,2645,0,2068),
(7,2647,0,80),
(7,2648,0,80),
(7,2649,0,80),
(7,2653,0,152),
(7,2658,0,16),
(7,2659,0,80),
(7,2667,0,80),
(7,2668,0,80),
(7,2669,0,16),
(7,2670,0,80),
(7,2671,0,16),
(7,2672,0,80),
(7,2673,0,16),
(7,2674,0,80),
(7,2675,0,16),
(7,2676,0,80),
(7,2677,0,16),
(7,2683,0,0),
(7,2684,0,80),
(7,2685,0,16),
(7,2688,0,16),
(7,2689,0,80),
(7,2693,0,4248),
(7,2695,0,276),
(7,2697,0,4),
(7,2722,0,0),
(7,2736,0,16),
(7,2739,0,0),
(8,21,0,64),
(8,46,0,4),
(8,47,2431,273),
(8,54,2423,273),
(8,59,0,16),
(8,67,0,14),
(8,68,0,6),
(8,69,859,273),
(8,70,0,2),
(8,72,6694,17),
(8,76,0,6),
(8,81,0,6),
(8,83,0,4),
(8,86,0,4),
(8,87,0,2),
(8,92,0,2),
(8,93,0,2),
(8,169,0,12),
(8,270,0,16),
(8,289,0,4),
(8,349,0,0),
(8,369,0,64),
(8,469,0,25),
(8,470,0,64),
(8,509,0,16),
(8,510,0,2),
(8,529,0,0),
(8,530,0,6),
(8,549,0,4),
(8,550,0,4),
(8,551,0,4),
(8,569,0,4),
(8,570,0,4),
(8,571,0,4),
(8,574,0,4),
(8,576,0,0),
(8,577,0,64),
(8,589,0,0),
(8,609,0,16),
(8,729,0,6),
(8,730,0,16),
(8,749,0,0),
(8,809,0,16),
(8,889,0,6),
(8,890,0,16),
(8,891,0,24),
(8,892,0,14),
(8,909,0,16),
(8,910,0,2),
(8,911,0,6),
(8,922,0,6),
(8,930,859,273),
(8,932,0,80),
(8,933,0,16),
(8,934,0,80),
(8,935,0,16),
(8,936,0,28),
(8,941,0,6),
(8,942,0,16),
(8,946,0,16),
(8,947,0,2),
(8,948,0,8),
(8,949,0,26),
(8,952,0,0),
(8,967,0,16),
(8,970,0,0),
(8,978,0,16),
(8,980,0,4120),
(8,989,0,16),
(8,990,0,16),
(8,1005,0,20),
(8,1011,0,16),
(8,1012,0,16),
(8,1015,0,2),
(8,1031,0,16),
(8,1037,0,136),
(8,1038,0,16),
(8,1050,0,16),
(8,1052,0,2),
(8,1064,0,6),
(8,1067,0,2),
(8,1068,0,16),
(8,1072,0,0),
(8,1073,0,16),
(8,1077,0,16),
(8,1085,0,6),
(8,1090,0,16),
(8,1091,0,16),
(8,1094,0,16),
(8,1097,0,4104),
(8,1098,0,16),
(8,1104,0,16),
(8,1105,0,16),
(8,1106,0,16),
(8,1117,0,12),
(8,1118,0,4104),
(8,1119,0,2),
(8,1124,0,6),
(8,1126,0,16),
(8,1133,0,6),
(8,1134,859,273),
(8,1135,0,16),
(8,1136,0,4),
(8,1137,0,4),
(8,1154,0,4),
(8,1155,0,4),
(8,1156,0,16),
(8,1158,0,16),
(8,1162,0,4104),
(8,1168,0,528),
(8,1169,0,4120),
(8,1171,0,66),
(8,1172,0,2),
(8,1173,0,16),
(8,1174,0,16),
(8,1177,0,0),
(8,1178,0,6),
(8,1204,0,16),
(8,1216,0,0),
(8,1228,0,2),
(8,1242,0,16),
(8,1245,0,4104),
(8,1269,0,16),
(8,1270,0,16),
(8,1271,0,16),
(8,1272,0,152),
(8,1273,0,18),
(8,1275,0,18),
(8,1276,0,18),
(8,1277,0,18),
(8,1278,0,18),
(8,1279,0,18),
(8,1280,0,18),
(8,1281,0,18),
(8,1282,0,18),
(8,1283,0,18),
(8,1302,0,152),
(8,1337,0,16),
(8,1341,0,16),
(8,1345,0,16),
(8,1351,0,0),
(8,1352,0,6),
(8,1353,0,273),
(8,1357,0,6),
(8,1358,0,18),
(8,1359,0,16),
(8,1374,0,2),
(8,1375,0,2),
(8,1376,0,144),
(8,1387,0,144),
(8,1388,0,2),
(8,1416,0,0),
(8,1419,0,18),
(8,1433,0,20),
(8,1435,0,16),
(8,1440,0,18),
(8,1444,0,4120),
(8,1445,0,2),
(8,1492,0,16),
(8,1515,0,16),
(8,1520,0,0),
(8,1679,0,0),
(8,1681,0,18),
(8,1682,0,16),
(8,1690,0,2),
(8,1691,0,18),
(8,1708,0,2),
(8,1710,0,16),
(8,1711,0,16),
(8,1712,0,1028),
(8,1713,0,1028),
(8,1714,0,1028),
(8,1715,0,1028),
(8,1716,0,1028),
(8,1717,0,1028),
(8,1718,0,1028),
(8,1731,0,16),
(8,1732,0,4),
(8,1733,0,18),
(8,1735,0,0),
(8,1736,0,18),
(8,1737,0,18),
(8,1738,0,18),
(8,1739,0,2),
(8,1740,0,2),
(8,1741,0,18),
(8,1815,0,4),
(8,1828,0,16),
(8,1834,0,4120),
(8,1847,0,16),
(8,1848,0,2),
(8,1849,0,16),
(8,1850,0,16),
(8,1859,0,16),
(8,1860,0,22),
(8,1861,0,22),
(8,1862,0,22),
(8,1883,0,16),
(8,1888,0,6),
(8,1894,0,16),
(8,1899,0,16),
(8,1900,0,16),
(8,1919,0,22),
(8,1947,0,20),
(8,1948,0,16),
(8,1975,0,18),
(8,1984,0,2),
(8,1989,0,4),
(8,2010,0,2),
(8,2011,0,18),
(8,2018,0,16),
(8,2045,0,16),
(8,2063,0,0),
(8,2085,0,80),
(8,2086,0,80),
(8,2087,0,80),
(8,2088,0,80),
(8,2089,0,80),
(8,2090,0,80),
(8,2091,0,80),
(8,2097,0,18),
(8,2098,0,18),
(8,2099,0,18),
(8,2100,0,18),
(8,2101,0,18),
(8,2102,0,18),
(8,2103,0,6),
(8,2104,0,4104),
(8,2111,0,6),
(8,2120,0,20),
(8,2135,0,18),
(8,2156,0,2),
(8,2157,0,2),
(8,2158,0,20),
(8,2159,0,16),
(8,2160,0,17),
(8,2161,0,16),
(8,2162,0,16),
(8,2163,0,16),
(8,2164,0,16),
(8,2165,0,16),
(8,2166,0,80),
(8,2167,0,80),
(8,2170,0,16),
(8,2233,0,6),
(8,2264,0,20),
(8,2265,0,20),
(8,2370,0,6),
(8,2371,0,18),
(8,2372,0,2),
(8,2373,0,20),
(8,2374,0,84),
(8,2375,0,6),
(8,2376,0,6),
(8,2377,0,6),
(8,2378,0,70),
(8,2379,0,80),
(8,2380,0,66),
(8,2381,0,80),
(8,2382,0,84),
(8,2383,0,80),
(8,2384,0,80),
(8,2385,0,66),
(8,2386,0,80),
(8,2387,0,80),
(8,2388,0,2),
(8,2389,0,2),
(8,2390,0,2),
(8,2391,0,16),
(8,2392,0,80),
(8,2395,0,16),
(8,2396,0,22),
(8,2397,0,22),
(8,2398,0,22),
(8,2400,0,16),
(8,2401,0,80),
(8,2407,0,16),
(8,2410,0,16),
(8,2413,0,16),
(8,2414,0,4104),
(8,2415,0,16),
(8,2416,0,80),
(8,2417,0,16),
(8,2418,0,80),
(8,2422,0,20),
(8,2427,0,6),
(8,2431,0,0),
(8,2432,0,18),
(8,2439,0,0),
(8,2440,0,80),
(8,2441,0,80),
(8,2442,0,80),
(8,2444,0,80),
(8,2445,0,152),
(8,2446,0,18),
(8,2447,0,18),
(8,2448,0,18),
(8,2449,0,18),
(8,2450,0,18),
(8,2451,0,18),
(8,2452,0,18),
(8,2453,0,18),
(8,2454,0,18),
(8,2455,0,18),
(8,2456,0,18),
(8,2457,0,18),
(8,2458,0,18),
(8,2459,0,18),
(8,2460,0,18),
(8,2461,0,18),
(8,2462,0,18),
(8,2463,0,22),
(8,2464,0,18),
(8,2465,0,16),
(8,2469,0,18),
(8,2470,0,16),
(8,2471,0,80),
(8,2472,0,18),
(8,2473,0,80),
(8,2474,0,80),
(8,2478,0,16),
(8,2479,0,80),
(8,2503,0,16),
(8,2504,0,80),
(8,2506,0,4120),
(8,2507,0,152),
(8,2508,0,80),
(8,2509,0,2068),
(8,2510,0,152),
(8,2511,0,16),
(8,2512,0,2068),
(8,2513,0,2068),
(8,2517,0,18),
(8,2518,0,18),
(8,2520,0,2054),
(8,2521,0,2132),
(8,2522,0,2068),
(8,2523,0,2),
(8,2524,0,272),
(8,2526,0,0),
(8,2542,0,2054),
(8,2544,0,18),
(8,2550,0,18),
(8,2551,0,80),
(8,2552,0,80),
(8,2553,0,18),
(8,2554,0,2052),
(8,2555,0,2054),
(8,2564,0,16),
(8,2565,0,80),
(8,2568,0,18),
(8,2569,0,24),
(8,2570,0,16),
(8,2574,0,16),
(8,2575,0,64),
(8,2590,0,16),
(8,2593,0,16),
(8,2594,0,16),
(8,2596,0,80),
(8,2600,0,4248),
(8,2601,0,18),
(8,2604,0,80),
(8,2605,0,18),
(8,2607,0,18),
(8,2611,0,80),
(8,2612,0,80),
(8,2613,0,80),
(8,2615,0,18),
(8,2640,0,18),
(8,2644,0,0),
(8,2645,0,2068),
(8,2647,0,80),
(8,2648,0,80),
(8,2649,0,80),
(8,2653,0,152),
(8,2658,0,16),
(8,2659,0,80),
(8,2667,0,80),
(8,2668,0,80),
(8,2669,0,16),
(8,2670,0,80),
(8,2671,0,16),
(8,2672,0,80),
(8,2673,0,16),
(8,2674,0,80),
(8,2675,0,16),
(8,2676,0,80),
(8,2677,0,16),
(8,2683,0,0),
(8,2684,0,80),
(8,2685,0,16),
(8,2688,0,16),
(8,2689,0,80),
(8,2693,0,4248),
(8,2695,0,20),
(8,2697,0,4),
(8,2722,0,0),
(8,2736,0,16),
(8,2739,0,0),
(10,21,0,64),
(10,46,0,4),
(10,47,433,273),
(10,54,433,273),
(10,59,0,16),
(10,67,0,14),
(10,68,0,6),
(10,69,9835,17),
(10,70,0,2),
(10,72,433,273),
(10,76,0,6),
(10,81,0,6),
(10,83,0,4),
(10,86,0,4),
(10,87,0,2),
(10,92,0,2),
(10,93,0,2),
(10,169,0,12),
(10,270,0,16),
(10,289,0,4),
(10,349,0,0),
(10,369,0,64),
(10,469,0,25),
(10,470,0,64),
(10,509,0,16),
(10,510,0,2),
(10,529,0,0),
(10,530,0,6),
(10,549,0,4),
(10,550,0,4),
(10,551,0,4),
(10,569,0,4),
(10,570,0,4),
(10,571,0,4),
(10,574,0,4),
(10,576,0,0),
(10,577,0,64),
(10,589,0,0),
(10,609,0,16),
(10,729,0,6),
(10,730,0,16),
(10,749,0,0),
(10,809,0,16),
(10,889,0,6),
(10,890,0,16),
(10,891,0,24),
(10,892,0,14),
(10,909,0,16),
(10,910,0,2),
(10,911,0,6),
(10,922,0,6),
(10,930,433,273),
(10,932,0,80),
(10,933,0,16),
(10,934,0,80),
(10,935,0,16),
(10,936,0,28),
(10,941,0,6),
(10,942,0,16),
(10,946,0,16),
(10,947,0,2),
(10,948,0,8),
(10,949,0,26),
(10,952,0,0),
(10,967,0,16),
(10,970,0,0),
(10,978,0,16),
(10,980,0,4120),
(10,989,0,16),
(10,990,0,16),
(10,1005,0,20),
(10,1011,0,16),
(10,1012,0,16),
(10,1015,0,2),
(10,1031,0,16),
(10,1037,0,136),
(10,1038,0,16),
(10,1050,0,16),
(10,1052,0,2),
(10,1064,0,6),
(10,1067,0,2),
(10,1068,0,16),
(10,1072,0,0),
(10,1073,0,16),
(10,1077,0,16),
(10,1085,0,6),
(10,1090,0,16),
(10,1091,0,16),
(10,1094,0,16),
(10,1097,0,4104),
(10,1098,0,16),
(10,1104,0,16),
(10,1105,0,16),
(10,1106,0,16),
(10,1117,0,12),
(10,1118,0,4104),
(10,1119,0,2),
(10,1124,0,6),
(10,1126,0,16),
(10,1133,0,6),
(10,1134,433,273),
(10,1135,0,16),
(10,1136,0,4),
(10,1137,0,4),
(10,1154,0,4),
(10,1155,0,4),
(10,1156,0,16),
(10,1158,0,16),
(10,1162,0,4104),
(10,1168,0,528),
(10,1169,0,4120),
(10,1171,0,66),
(10,1172,0,2),
(10,1173,0,16),
(10,1174,0,16),
(10,1177,0,0),
(10,1178,0,6),
(10,1204,0,16),
(10,1216,0,0),
(10,1228,0,2),
(10,1242,0,16),
(10,1245,0,4104),
(10,1269,0,16),
(10,1270,0,16),
(10,1271,0,16),
(10,1272,0,152),
(10,1273,0,18),
(10,1275,0,18),
(10,1276,0,18),
(10,1277,0,18),
(10,1278,0,18),
(10,1279,0,18),
(10,1280,0,18),
(10,1281,0,18),
(10,1282,0,18),
(10,1283,0,18),
(10,1302,0,152),
(10,1337,0,16),
(10,1341,0,16),
(10,1345,0,16),
(10,1351,0,0),
(10,1352,0,6),
(10,1353,0,273),
(10,1357,0,6),
(10,1358,0,18),
(10,1359,0,16),
(10,1374,0,2),
(10,1375,0,2),
(10,1376,0,144),
(10,1387,0,144),
(10,1388,0,2),
(10,1416,0,0),
(10,1419,0,18),
(10,1433,0,20),
(10,1435,0,16),
(10,1440,0,18),
(10,1444,0,4120),
(10,1445,0,2),
(10,1492,0,16),
(10,1515,0,16),
(10,1520,0,0),
(10,1679,0,0),
(10,1681,0,18),
(10,1682,0,16),
(10,1690,0,2),
(10,1691,0,18),
(10,1708,0,2),
(10,1710,0,16),
(10,1711,0,16),
(10,1712,0,1028),
(10,1713,0,1028),
(10,1714,0,1028),
(10,1715,0,1028),
(10,1716,0,1028),
(10,1717,0,1028),
(10,1718,0,1028),
(10,1731,0,16),
(10,1732,0,4),
(10,1733,0,18),
(10,1735,0,0),
(10,1736,0,18),
(10,1737,0,18),
(10,1738,0,18),
(10,1739,0,2),
(10,1740,0,2),
(10,1741,0,18),
(10,1815,0,4),
(10,1828,0,16),
(10,1834,0,4120),
(10,1847,0,16),
(10,1848,0,2),
(10,1849,0,16),
(10,1850,0,16),
(10,1859,0,16),
(10,1860,0,22),
(10,1861,0,22),
(10,1862,0,22),
(10,1883,0,16),
(10,1888,0,6),
(10,1894,0,16),
(10,1899,0,16),
(10,1900,0,16),
(10,1919,0,22),
(10,1947,0,20),
(10,1948,0,16),
(10,1975,0,18),
(10,1984,0,2),
(10,1989,0,4),
(10,2010,0,2),
(10,2011,0,18),
(10,2018,0,16),
(10,2045,0,16),
(10,2063,0,0),
(10,2085,0,80),
(10,2086,0,80),
(10,2087,0,80),
(10,2088,0,80),
(10,2089,0,80),
(10,2090,0,80),
(10,2091,0,80),
(10,2097,0,18),
(10,2098,0,18),
(10,2099,0,18),
(10,2100,0,18),
(10,2101,0,18),
(10,2102,0,18),
(10,2103,0,6),
(10,2104,0,4104),
(10,2111,0,6),
(10,2120,0,20),
(10,2135,0,18),
(10,2156,0,2),
(10,2157,0,2),
(10,2158,0,20),
(10,2159,0,16),
(10,2160,0,16),
(10,2161,0,16),
(10,2162,0,16),
(10,2163,0,16),
(10,2164,0,16),
(10,2165,0,16),
(10,2166,0,80),
(10,2167,0,80),
(10,2170,0,16),
(10,2233,0,6),
(10,2264,0,20),
(10,2265,0,20),
(10,2370,0,6),
(10,2371,0,18),
(10,2372,0,2),
(10,2373,0,20),
(10,2374,0,84),
(10,2375,0,6),
(10,2376,0,6),
(10,2377,0,6),
(10,2378,0,70),
(10,2379,0,80),
(10,2380,0,66),
(10,2381,0,80),
(10,2382,0,84),
(10,2383,0,80),
(10,2384,0,80),
(10,2385,0,66),
(10,2386,0,80),
(10,2387,0,80),
(10,2388,0,2),
(10,2389,0,2),
(10,2390,0,2),
(10,2391,0,16),
(10,2392,0,80),
(10,2395,0,16),
(10,2396,0,22),
(10,2397,0,22),
(10,2398,0,22),
(10,2400,0,16),
(10,2401,0,80),
(10,2407,0,16),
(10,2410,0,16),
(10,2413,0,16),
(10,2414,0,4104),
(10,2415,0,16),
(10,2416,0,80),
(10,2417,0,16),
(10,2418,0,80),
(10,2422,0,20),
(10,2427,0,6),
(10,2431,0,0),
(10,2432,0,18),
(10,2439,0,0),
(10,2440,0,80),
(10,2441,0,80),
(10,2442,0,80),
(10,2444,0,80),
(10,2445,0,152),
(10,2446,0,18),
(10,2447,0,18),
(10,2448,0,18),
(10,2449,0,18),
(10,2450,0,18),
(10,2451,0,18),
(10,2452,0,18),
(10,2453,0,18),
(10,2454,0,18),
(10,2455,0,18),
(10,2456,0,18),
(10,2457,0,18),
(10,2458,0,18),
(10,2459,0,18),
(10,2460,0,18),
(10,2461,0,18),
(10,2462,0,18),
(10,2463,0,22),
(10,2464,0,18),
(10,2465,0,16),
(10,2469,0,18),
(10,2470,0,16),
(10,2471,0,80),
(10,2472,0,18),
(10,2473,0,80),
(10,2474,0,80),
(10,2478,0,16),
(10,2479,0,80),
(10,2503,0,16),
(10,2504,0,80),
(10,2506,0,4120),
(10,2507,0,152),
(10,2508,0,80),
(10,2509,0,2068),
(10,2510,0,152),
(10,2511,0,16),
(10,2512,0,2068),
(10,2513,0,2068),
(10,2517,0,18),
(10,2518,0,18),
(10,2520,0,2054),
(10,2521,0,2132),
(10,2522,0,2068),
(10,2523,0,2),
(10,2524,0,272),
(10,2526,0,0),
(10,2542,0,2054),
(10,2544,0,18),
(10,2550,0,18),
(10,2551,0,80),
(10,2552,0,80),
(10,2553,0,18),
(10,2554,0,2052),
(10,2555,0,2054),
(10,2564,0,16),
(10,2565,0,80),
(10,2568,0,18),
(10,2569,0,24),
(10,2570,0,16),
(10,2574,0,16),
(10,2575,0,64),
(10,2590,0,16),
(10,2593,0,16),
(10,2594,0,16),
(10,2596,0,80),
(10,2600,0,4248),
(10,2601,0,18),
(10,2604,0,80),
(10,2605,0,18),
(10,2607,0,18),
(10,2611,0,80),
(10,2612,0,80),
(10,2613,0,80),
(10,2615,0,18),
(10,2640,0,18),
(10,2644,0,0),
(10,2645,0,2068),
(10,2647,0,80),
(10,2648,0,80),
(10,2649,0,80),
(10,2653,0,152),
(10,2658,0,16),
(10,2659,0,80),
(10,2667,0,80),
(10,2668,0,80),
(10,2669,0,16),
(10,2670,0,80),
(10,2671,0,16),
(10,2672,0,80),
(10,2673,0,16),
(10,2674,0,80),
(10,2675,0,16),
(10,2676,0,80),
(10,2677,0,16),
(10,2683,0,0),
(10,2684,0,80),
(10,2685,0,16),
(10,2688,0,16),
(10,2689,0,80),
(10,2693,0,4248),
(10,2695,0,276),
(10,2697,0,4),
(10,2722,0,0),
(10,2736,0,16),
(10,2739,0,0),
(11,21,0,64),
(11,46,0,4),
(11,47,0,273),
(11,54,0,273),
(11,59,0,16),
(11,67,0,14),
(11,68,0,6),
(11,69,0,273),
(11,70,0,2),
(11,72,0,273),
(11,76,0,6),
(11,81,0,6),
(11,83,0,4),
(11,86,0,4),
(11,87,0,2),
(11,92,0,2),
(11,93,0,2),
(11,169,0,12),
(11,270,0,16),
(11,289,0,4),
(11,349,0,0),
(11,369,0,64),
(11,469,0,25),
(11,470,0,64),
(11,509,0,16),
(11,510,0,2),
(11,529,0,0),
(11,530,0,6),
(11,549,0,4),
(11,550,0,4),
(11,551,0,4),
(11,569,0,4),
(11,570,0,4),
(11,571,0,4),
(11,574,0,4),
(11,576,0,0),
(11,577,0,64),
(11,589,0,0),
(11,609,0,16),
(11,729,0,6),
(11,730,0,16),
(11,749,0,0),
(11,809,0,16),
(11,889,0,6),
(11,890,0,16),
(11,891,0,24),
(11,892,0,14),
(11,909,0,16),
(11,910,0,2),
(11,911,0,6),
(11,922,0,6),
(11,930,0,17),
(11,932,0,80),
(11,933,0,16),
(11,934,0,80),
(11,935,0,16),
(11,936,0,28),
(11,941,0,6),
(11,942,0,16),
(11,946,0,16),
(11,947,0,2),
(11,948,0,8),
(11,949,0,26),
(11,952,0,0),
(11,967,0,16),
(11,970,0,0),
(11,978,0,16),
(11,980,0,4120),
(11,989,0,16),
(11,990,0,16),
(11,1005,0,20),
(11,1011,0,16),
(11,1012,0,16),
(11,1015,0,2),
(11,1031,0,16),
(11,1037,0,136),
(11,1038,0,16),
(11,1050,0,16),
(11,1052,0,2),
(11,1064,0,6),
(11,1067,0,2),
(11,1068,0,16),
(11,1072,0,0),
(11,1073,0,16),
(11,1077,0,16),
(11,1085,0,6),
(11,1090,0,16),
(11,1091,0,16),
(11,1094,0,16),
(11,1097,0,4104),
(11,1098,0,16),
(11,1104,0,16),
(11,1105,0,16),
(11,1106,0,16),
(11,1117,0,12),
(11,1118,0,4104),
(11,1119,0,2),
(11,1124,0,6),
(11,1126,0,16),
(11,1133,0,6),
(11,1134,0,273),
(11,1135,0,16),
(11,1136,0,4),
(11,1137,0,4),
(11,1154,0,4),
(11,1155,0,4),
(11,1156,0,16),
(11,1158,0,16),
(11,1162,0,4104),
(11,1168,0,528),
(11,1169,0,4120),
(11,1171,0,66),
(11,1172,0,2),
(11,1173,0,16),
(11,1174,0,16),
(11,1177,0,0),
(11,1178,0,6),
(11,1204,0,16),
(11,1216,0,0),
(11,1228,0,2),
(11,1242,0,16),
(11,1245,0,4104),
(11,1269,0,16),
(11,1270,0,16),
(11,1271,0,16),
(11,1272,0,152),
(11,1273,0,18),
(11,1275,0,18),
(11,1276,0,18),
(11,1277,0,18),
(11,1278,0,18),
(11,1279,0,18),
(11,1280,0,18),
(11,1281,0,18),
(11,1282,0,18),
(11,1283,0,18),
(11,1302,0,152),
(11,1337,0,16),
(11,1341,0,16),
(11,1345,0,16),
(11,1351,0,0),
(11,1352,0,6),
(11,1353,0,273),
(11,1357,0,6),
(11,1358,0,18),
(11,1359,0,16),
(11,1374,0,2),
(11,1375,0,2),
(11,1376,0,144),
(11,1387,0,144),
(11,1388,0,2),
(11,1416,0,0),
(11,1419,0,18),
(11,1433,0,20),
(11,1435,0,16),
(11,1440,0,18),
(11,1444,0,4120),
(11,1445,0,2),
(11,1492,0,16),
(11,1515,0,16),
(11,1520,0,0),
(11,1679,0,0),
(11,1681,0,18),
(11,1682,0,16),
(11,1690,0,2),
(11,1691,0,18),
(11,1708,0,2),
(11,1710,0,16),
(11,1711,0,16),
(11,1712,0,1028),
(11,1713,0,1028),
(11,1714,0,1028),
(11,1715,0,1028),
(11,1716,0,1028),
(11,1717,0,1028),
(11,1718,0,1028),
(11,1731,0,16),
(11,1732,0,4),
(11,1733,0,18),
(11,1735,0,0),
(11,1736,0,18),
(11,1737,0,18),
(11,1738,0,18),
(11,1739,0,2),
(11,1740,0,2),
(11,1741,0,18),
(11,1815,0,4),
(11,1828,0,16),
(11,1834,0,4120),
(11,1847,0,16),
(11,1848,0,2),
(11,1849,0,16),
(11,1850,0,16),
(11,1859,0,16),
(11,1860,0,22),
(11,1861,0,22),
(11,1862,0,22),
(11,1883,0,16),
(11,1888,0,6),
(11,1894,0,16),
(11,1899,0,16),
(11,1900,0,16),
(11,1919,0,22),
(11,1947,0,20),
(11,1948,0,16),
(11,1975,0,18),
(11,1984,0,2),
(11,1989,0,4),
(11,2010,0,2),
(11,2011,0,18),
(11,2018,0,16),
(11,2045,0,16),
(11,2063,0,0),
(11,2085,0,80),
(11,2086,0,80),
(11,2087,0,80),
(11,2088,0,80),
(11,2089,0,80),
(11,2090,0,80),
(11,2091,0,80),
(11,2097,0,18),
(11,2098,0,18),
(11,2099,0,18),
(11,2100,0,18),
(11,2101,0,18),
(11,2102,0,18),
(11,2103,0,6),
(11,2104,0,4104),
(11,2111,0,6),
(11,2120,0,20),
(11,2135,0,18),
(11,2156,0,2),
(11,2157,0,2),
(11,2158,0,20),
(11,2159,0,16),
(11,2160,0,16),
(11,2161,0,16),
(11,2162,0,16),
(11,2163,0,16),
(11,2164,0,16),
(11,2165,0,16),
(11,2166,0,80),
(11,2167,0,80),
(11,2170,0,16),
(11,2233,0,6),
(11,2264,0,20),
(11,2265,0,20),
(11,2370,0,6),
(11,2371,0,18),
(11,2372,0,2),
(11,2373,0,20),
(11,2374,0,84),
(11,2375,0,6),
(11,2376,0,6),
(11,2377,0,6),
(11,2378,0,70),
(11,2379,0,80),
(11,2380,0,66),
(11,2381,0,80),
(11,2382,0,84),
(11,2383,0,80),
(11,2384,0,80),
(11,2385,0,66),
(11,2386,0,80),
(11,2387,0,80),
(11,2388,0,2),
(11,2389,0,2),
(11,2390,0,2),
(11,2391,0,16),
(11,2392,0,80),
(11,2395,0,16),
(11,2396,0,22),
(11,2397,0,22),
(11,2398,0,22),
(11,2400,0,16),
(11,2401,0,80),
(11,2407,0,16),
(11,2410,0,16),
(11,2413,0,16),
(11,2414,0,4104),
(11,2415,0,16),
(11,2416,0,80),
(11,2417,0,16),
(11,2418,0,80),
(11,2422,0,20),
(11,2427,0,6),
(11,2431,0,0),
(11,2432,0,18),
(11,2439,0,0),
(11,2440,0,80),
(11,2441,0,80),
(11,2442,0,80),
(11,2444,0,80),
(11,2445,0,152),
(11,2446,0,18),
(11,2447,0,18),
(11,2448,0,18),
(11,2449,0,18),
(11,2450,0,18),
(11,2451,0,18),
(11,2452,0,18),
(11,2453,0,18),
(11,2454,0,18),
(11,2455,0,18),
(11,2456,0,18),
(11,2457,0,18),
(11,2458,0,18),
(11,2459,0,18),
(11,2460,0,18),
(11,2461,0,18),
(11,2462,0,18),
(11,2463,0,22),
(11,2464,0,18),
(11,2465,0,16),
(11,2469,0,18),
(11,2470,0,16),
(11,2471,0,80),
(11,2472,0,18),
(11,2473,0,80),
(11,2474,0,80),
(11,2478,0,16),
(11,2479,0,80),
(11,2503,0,16),
(11,2504,0,80),
(11,2506,0,4120),
(11,2507,0,152),
(11,2508,0,80),
(11,2509,0,2068),
(11,2510,0,152),
(11,2511,0,16),
(11,2512,0,2068),
(11,2513,0,2068),
(11,2517,0,18),
(11,2518,0,18),
(11,2520,0,2054),
(11,2521,0,2132),
(11,2522,0,2068),
(11,2523,0,2),
(11,2524,0,272),
(11,2526,0,0),
(11,2542,0,2054),
(11,2544,0,18),
(11,2550,0,18),
(11,2551,0,80),
(11,2552,0,80),
(11,2553,0,18),
(11,2554,0,2052),
(11,2555,0,2054),
(11,2564,0,16),
(11,2565,0,80),
(11,2568,0,18),
(11,2569,0,24),
(11,2570,0,16),
(11,2574,0,16),
(11,2575,0,64),
(11,2590,0,16),
(11,2593,0,16),
(11,2594,0,16),
(11,2596,0,80),
(11,2600,0,4248),
(11,2601,0,18),
(11,2604,0,80),
(11,2605,0,18),
(11,2607,0,18),
(11,2611,0,80),
(11,2612,0,80),
(11,2613,0,80),
(11,2615,0,18),
(11,2640,0,18),
(11,2644,0,0),
(11,2645,0,2068),
(11,2647,0,80),
(11,2648,0,80),
(11,2649,0,80),
(11,2653,0,152),
(11,2658,0,16),
(11,2659,0,80),
(11,2667,0,80),
(11,2668,0,80),
(11,2669,0,16),
(11,2670,0,80),
(11,2671,0,16),
(11,2672,0,80),
(11,2673,0,16),
(11,2674,0,80),
(11,2675,0,16),
(11,2676,0,80),
(11,2677,0,16),
(11,2683,0,0),
(11,2684,0,80),
(11,2685,0,16),
(11,2688,0,16),
(11,2689,0,80),
(11,2693,0,4248),
(11,2695,0,276),
(11,2697,0,4),
(11,2722,0,0),
(11,2736,0,16),
(11,2739,0,0),
(12,21,0,64),
(12,46,0,4),
(12,47,160,273),
(12,54,160,273),
(12,59,0,16),
(12,67,0,14),
(12,68,0,6),
(12,69,2275,17),
(12,70,0,2),
(12,72,160,273),
(12,76,0,6),
(12,81,0,6),
(12,83,0,4),
(12,86,0,4),
(12,87,0,2),
(12,92,0,2),
(12,93,0,2),
(12,169,0,12),
(12,270,0,16),
(12,289,0,4),
(12,349,0,0),
(12,369,0,64),
(12,469,0,25),
(12,470,0,64),
(12,509,0,16),
(12,510,0,2),
(12,529,0,0),
(12,530,0,6),
(12,549,0,4),
(12,550,0,4),
(12,551,0,4),
(12,569,0,4),
(12,570,0,4),
(12,571,0,4),
(12,574,0,4),
(12,576,0,0),
(12,577,0,64),
(12,589,0,0),
(12,609,0,16),
(12,729,0,6),
(12,730,0,16),
(12,749,0,0),
(12,809,0,16),
(12,889,0,6),
(12,890,0,16),
(12,891,0,24),
(12,892,0,14),
(12,909,0,16),
(12,910,0,2),
(12,911,0,6),
(12,922,0,6),
(12,930,160,273),
(12,932,0,80),
(12,933,0,16),
(12,934,0,80),
(12,935,0,16),
(12,936,0,28),
(12,941,0,6),
(12,942,0,16),
(12,946,0,16),
(12,947,0,2),
(12,948,0,8),
(12,949,0,26),
(12,952,0,0),
(12,967,0,16),
(12,970,0,0),
(12,978,0,16),
(12,980,0,4120),
(12,989,0,16),
(12,990,0,16),
(12,1005,0,20),
(12,1011,0,16),
(12,1012,0,16),
(12,1015,0,2),
(12,1031,0,16),
(12,1037,0,136),
(12,1038,0,16),
(12,1050,0,16),
(12,1052,0,2),
(12,1064,0,6),
(12,1067,0,2),
(12,1068,0,16),
(12,1072,0,0),
(12,1073,0,16),
(12,1077,0,16),
(12,1085,0,6),
(12,1090,0,16),
(12,1091,0,16),
(12,1094,0,16),
(12,1097,0,4104),
(12,1098,0,16),
(12,1104,0,16),
(12,1105,0,16),
(12,1106,0,16),
(12,1117,0,12),
(12,1118,0,4104),
(12,1119,0,2),
(12,1124,0,6),
(12,1126,0,16),
(12,1133,0,6),
(12,1134,160,273),
(12,1135,0,16),
(12,1136,0,4),
(12,1137,0,4),
(12,1154,0,4),
(12,1155,0,4),
(12,1156,0,16),
(12,1158,0,16),
(12,1162,0,4104),
(12,1168,0,528),
(12,1169,0,4120),
(12,1171,0,66),
(12,1172,0,2),
(12,1173,0,16),
(12,1174,0,16),
(12,1177,0,0),
(12,1178,0,6),
(12,1204,0,16),
(12,1216,0,0),
(12,1228,0,2),
(12,1242,0,16),
(12,1245,0,4104),
(12,1269,0,16),
(12,1270,0,16),
(12,1271,0,16),
(12,1272,0,152),
(12,1273,0,18),
(12,1275,0,18),
(12,1276,0,18),
(12,1277,0,18),
(12,1278,0,18),
(12,1279,0,18),
(12,1280,0,18),
(12,1281,0,18),
(12,1282,0,18),
(12,1283,0,18),
(12,1302,0,152),
(12,1337,0,16),
(12,1341,0,16),
(12,1345,0,16),
(12,1351,0,0),
(12,1352,0,6),
(12,1353,0,273),
(12,1357,0,6),
(12,1358,0,18),
(12,1359,0,16),
(12,1374,0,2),
(12,1375,0,2),
(12,1376,0,144),
(12,1387,0,144),
(12,1388,0,2),
(12,1416,0,0),
(12,1419,0,18),
(12,1433,0,20),
(12,1435,0,16),
(12,1440,0,18),
(12,1444,0,4120),
(12,1445,0,2),
(12,1492,0,16),
(12,1515,0,16),
(12,1520,0,0),
(12,1679,0,0),
(12,1681,0,18),
(12,1682,0,16),
(12,1690,0,2),
(12,1691,0,18),
(12,1708,0,2),
(12,1710,0,16),
(12,1711,0,16),
(12,1712,0,1028),
(12,1713,0,1028),
(12,1714,0,1028),
(12,1715,0,1028),
(12,1716,0,1028),
(12,1717,0,1028),
(12,1718,0,1028),
(12,1731,0,16),
(12,1732,0,4),
(12,1733,0,18),
(12,1735,0,0),
(12,1736,0,18),
(12,1737,0,18),
(12,1738,0,18),
(12,1739,0,2),
(12,1740,0,2),
(12,1741,0,18),
(12,1815,0,4),
(12,1828,0,16),
(12,1834,0,4120),
(12,1847,0,16),
(12,1848,0,2),
(12,1849,0,16),
(12,1850,0,16),
(12,1859,0,16),
(12,1860,0,22),
(12,1861,0,22),
(12,1862,0,22),
(12,1883,0,16),
(12,1888,0,6),
(12,1894,0,16),
(12,1899,0,16),
(12,1900,0,16),
(12,1919,0,22),
(12,1947,0,20),
(12,1948,0,16),
(12,1975,0,18),
(12,1984,0,2),
(12,1989,0,4),
(12,2010,0,2),
(12,2011,0,18),
(12,2018,0,16),
(12,2045,0,16),
(12,2063,0,0),
(12,2085,0,80),
(12,2086,0,80),
(12,2087,0,80),
(12,2088,0,80),
(12,2089,0,80),
(12,2090,0,80),
(12,2091,0,80),
(12,2097,0,18),
(12,2098,0,18),
(12,2099,0,18),
(12,2100,0,18),
(12,2101,0,18),
(12,2102,0,18),
(12,2103,0,6),
(12,2104,0,4104),
(12,2111,0,6),
(12,2120,0,20),
(12,2135,0,18),
(12,2156,0,2),
(12,2157,0,2),
(12,2158,0,20),
(12,2159,0,16),
(12,2160,0,16),
(12,2161,0,16),
(12,2162,0,16),
(12,2163,0,16),
(12,2164,0,16),
(12,2165,0,16),
(12,2166,0,80),
(12,2167,0,80),
(12,2170,0,16),
(12,2233,0,6),
(12,2264,0,20),
(12,2265,0,20),
(12,2370,0,6),
(12,2371,0,18),
(12,2372,0,2),
(12,2373,0,20),
(12,2374,0,84),
(12,2375,0,6),
(12,2376,0,6),
(12,2377,0,6),
(12,2378,0,70),
(12,2379,0,80),
(12,2380,0,66),
(12,2381,0,80),
(12,2382,0,84),
(12,2383,0,80),
(12,2384,0,80),
(12,2385,0,66),
(12,2386,0,80),
(12,2387,0,80),
(12,2388,0,2),
(12,2389,0,2),
(12,2390,0,2),
(12,2391,0,16),
(12,2392,0,80),
(12,2395,0,16),
(12,2396,0,22),
(12,2397,0,22),
(12,2398,0,22),
(12,2400,0,16),
(12,2401,0,80),
(12,2407,0,16),
(12,2410,0,16),
(12,2413,0,16),
(12,2414,0,4104),
(12,2415,0,16),
(12,2416,0,80),
(12,2417,0,16),
(12,2418,0,80),
(12,2422,0,20),
(12,2427,0,6),
(12,2431,0,0),
(12,2432,0,18),
(12,2439,0,0),
(12,2440,0,80),
(12,2441,0,80),
(12,2442,0,80),
(12,2444,0,80),
(12,2445,0,152),
(12,2446,0,18),
(12,2447,0,18),
(12,2448,0,18),
(12,2449,0,18),
(12,2450,0,18),
(12,2451,0,18),
(12,2452,0,18),
(12,2453,0,18),
(12,2454,0,18),
(12,2455,0,18),
(12,2456,0,18),
(12,2457,0,18),
(12,2458,0,18),
(12,2459,0,18),
(12,2460,0,18),
(12,2461,0,18),
(12,2462,0,18),
(12,2463,0,22),
(12,2464,0,18),
(12,2465,0,16),
(12,2469,0,18),
(12,2470,0,16),
(12,2471,0,80),
(12,2472,0,18),
(12,2473,0,80),
(12,2474,0,80),
(12,2478,0,16),
(12,2479,0,80),
(12,2503,0,16),
(12,2504,0,80),
(12,2506,0,4120),
(12,2507,0,152),
(12,2508,0,80),
(12,2509,0,2068),
(12,2510,0,152),
(12,2511,0,16),
(12,2512,0,2068),
(12,2513,0,2068),
(12,2517,0,18),
(12,2518,0,18),
(12,2520,0,2054),
(12,2521,0,2132),
(12,2522,0,2068),
(12,2523,0,2),
(12,2524,0,272),
(12,2526,0,0),
(12,2542,0,2054),
(12,2544,0,18),
(12,2550,0,18),
(12,2551,0,80),
(12,2552,0,80),
(12,2553,0,18),
(12,2554,0,2052),
(12,2555,0,2054),
(12,2564,0,16),
(12,2565,0,80),
(12,2568,0,18),
(12,2569,0,24),
(12,2570,0,16),
(12,2574,0,16),
(12,2575,0,64),
(12,2590,0,16),
(12,2593,0,16),
(12,2594,0,16),
(12,2596,0,80),
(12,2600,0,4248),
(12,2601,0,18),
(12,2604,0,80),
(12,2605,0,18),
(12,2607,0,18),
(12,2611,0,80),
(12,2612,0,80),
(12,2613,0,80),
(12,2615,0,18),
(12,2640,0,18),
(12,2644,0,0),
(12,2645,0,2068),
(12,2647,0,80),
(12,2648,0,80),
(12,2649,0,80),
(12,2653,0,152),
(12,2658,0,16),
(12,2659,0,80),
(12,2667,0,80),
(12,2668,0,80),
(12,2669,0,16),
(12,2670,0,80),
(12,2671,0,16),
(12,2672,0,80),
(12,2673,0,16),
(12,2674,0,80),
(12,2675,0,16),
(12,2676,0,80),
(12,2677,0,16),
(12,2683,0,0),
(12,2684,0,80),
(12,2685,0,16),
(12,2688,0,16),
(12,2689,0,80),
(12,2693,0,4248),
(12,2695,0,276),
(12,2697,0,4),
(12,2722,0,0),
(12,2736,0,16),
(12,2739,0,0),
(13,21,0,64),
(13,46,0,4),
(13,47,160,273),
(13,54,160,273),
(13,59,0,16),
(13,67,0,14),
(13,68,0,6),
(13,69,2525,17),
(13,70,0,2),
(13,72,160,273),
(13,76,0,6),
(13,81,0,6),
(13,83,0,4),
(13,86,0,4),
(13,87,0,2),
(13,92,0,2),
(13,93,0,2),
(13,169,0,12),
(13,270,0,16),
(13,289,0,4),
(13,349,0,0),
(13,369,0,64),
(13,469,0,25),
(13,470,0,64),
(13,509,0,16),
(13,510,0,2),
(13,529,0,0),
(13,530,0,6),
(13,549,0,4),
(13,550,0,4),
(13,551,0,4),
(13,569,0,4),
(13,570,0,4),
(13,571,0,4),
(13,574,0,4),
(13,576,0,0),
(13,577,0,64),
(13,589,0,0),
(13,609,0,16),
(13,729,0,6),
(13,730,0,16),
(13,749,0,0),
(13,809,0,16),
(13,889,0,6),
(13,890,0,16),
(13,891,0,24),
(13,892,0,14),
(13,909,0,16),
(13,910,0,2),
(13,911,0,6),
(13,922,0,6),
(13,930,160,273),
(13,932,0,80),
(13,933,0,16),
(13,934,0,80),
(13,935,0,16),
(13,936,0,28),
(13,941,0,6),
(13,942,0,16),
(13,946,0,16),
(13,947,0,2),
(13,948,0,8),
(13,949,0,26),
(13,952,0,0),
(13,967,0,16),
(13,970,0,0),
(13,978,0,16),
(13,980,0,4120),
(13,989,0,16),
(13,990,0,16),
(13,1005,0,20),
(13,1011,0,16),
(13,1012,0,16),
(13,1015,0,2),
(13,1031,0,16),
(13,1037,0,136),
(13,1038,0,16),
(13,1050,0,16),
(13,1052,0,2),
(13,1064,0,6),
(13,1067,0,2),
(13,1068,0,16),
(13,1072,0,0),
(13,1073,0,16),
(13,1077,0,16),
(13,1085,0,6),
(13,1090,0,16),
(13,1091,0,16),
(13,1094,0,16),
(13,1097,0,4104),
(13,1098,0,16),
(13,1104,0,16),
(13,1105,0,16),
(13,1106,0,16),
(13,1117,0,12),
(13,1118,0,4104),
(13,1119,0,2),
(13,1124,0,6),
(13,1126,0,16),
(13,1133,0,6),
(13,1134,160,273),
(13,1135,0,16),
(13,1136,0,4),
(13,1137,0,4),
(13,1154,0,4),
(13,1155,0,4),
(13,1156,0,16),
(13,1158,0,16),
(13,1162,0,4104),
(13,1168,0,528),
(13,1169,0,4120),
(13,1171,0,66),
(13,1172,0,2),
(13,1173,0,16),
(13,1174,0,16),
(13,1177,0,0),
(13,1178,0,6),
(13,1204,0,16),
(13,1216,0,0),
(13,1228,0,2),
(13,1242,0,16),
(13,1245,0,4104),
(13,1269,0,16),
(13,1270,0,16),
(13,1271,0,16),
(13,1272,0,152),
(13,1273,0,18),
(13,1275,0,18),
(13,1276,0,18),
(13,1277,0,18),
(13,1278,0,18),
(13,1279,0,18),
(13,1280,0,18),
(13,1281,0,18),
(13,1282,0,18),
(13,1283,0,18),
(13,1302,0,152),
(13,1337,0,16),
(13,1341,0,16),
(13,1345,0,16),
(13,1351,0,0),
(13,1352,0,6),
(13,1353,0,273),
(13,1357,0,6),
(13,1358,0,18),
(13,1359,0,16),
(13,1374,0,2),
(13,1375,0,2),
(13,1376,0,144),
(13,1387,0,144),
(13,1388,0,2),
(13,1416,0,0),
(13,1419,0,18),
(13,1433,0,20),
(13,1435,0,16),
(13,1440,0,18),
(13,1444,0,4120),
(13,1445,0,2),
(13,1492,0,16),
(13,1515,0,16),
(13,1520,0,0),
(13,1679,0,0),
(13,1681,0,18),
(13,1682,0,16),
(13,1690,0,2),
(13,1691,0,18),
(13,1708,0,2),
(13,1710,0,16),
(13,1711,0,16),
(13,1712,0,1028),
(13,1713,0,1028),
(13,1714,0,1028),
(13,1715,0,1028),
(13,1716,0,1028),
(13,1717,0,1028),
(13,1718,0,1028),
(13,1731,0,16),
(13,1732,0,4),
(13,1733,0,18),
(13,1735,0,0),
(13,1736,0,18),
(13,1737,0,18),
(13,1738,0,18),
(13,1739,0,2),
(13,1740,0,2),
(13,1741,0,18),
(13,1815,0,4),
(13,1828,0,16),
(13,1834,0,4120),
(13,1847,0,16),
(13,1848,0,2),
(13,1849,0,16),
(13,1850,0,16),
(13,1859,0,16),
(13,1860,0,22),
(13,1861,0,22),
(13,1862,0,22),
(13,1883,0,16),
(13,1888,0,6),
(13,1894,0,16),
(13,1899,0,16),
(13,1900,0,16),
(13,1919,0,22),
(13,1947,0,20),
(13,1948,0,16),
(13,1975,0,18),
(13,1984,0,2),
(13,1989,0,4),
(13,2010,0,2),
(13,2011,0,18),
(13,2018,0,16),
(13,2045,0,16),
(13,2063,0,0),
(13,2085,0,80),
(13,2086,0,80),
(13,2087,0,80),
(13,2088,0,80),
(13,2089,0,80),
(13,2090,0,80),
(13,2091,0,80),
(13,2097,0,18),
(13,2098,0,18),
(13,2099,0,18),
(13,2100,0,18),
(13,2101,0,18),
(13,2102,0,18),
(13,2103,0,6),
(13,2104,0,4104),
(13,2111,0,6),
(13,2120,0,20),
(13,2135,0,18),
(13,2156,0,2),
(13,2157,0,2),
(13,2158,0,20),
(13,2159,0,16),
(13,2160,0,16),
(13,2161,0,16),
(13,2162,0,16),
(13,2163,0,16),
(13,2164,0,16),
(13,2165,0,16),
(13,2166,0,80),
(13,2167,0,80),
(13,2170,0,16),
(13,2233,0,6),
(13,2264,0,20),
(13,2265,0,20),
(13,2370,0,6),
(13,2371,0,18),
(13,2372,0,2),
(13,2373,0,20),
(13,2374,0,84),
(13,2375,0,6),
(13,2376,0,6),
(13,2377,0,6),
(13,2378,0,70),
(13,2379,0,80),
(13,2380,0,66),
(13,2381,0,80),
(13,2382,0,84),
(13,2383,0,80),
(13,2384,0,80),
(13,2385,0,66),
(13,2386,0,80),
(13,2387,0,80),
(13,2388,0,2),
(13,2389,0,2),
(13,2390,0,2),
(13,2391,0,16),
(13,2392,0,80),
(13,2395,0,16),
(13,2396,0,22),
(13,2397,0,22),
(13,2398,0,22),
(13,2400,0,16),
(13,2401,0,80),
(13,2407,0,16),
(13,2410,0,16),
(13,2413,0,16),
(13,2414,0,4104),
(13,2415,0,16),
(13,2416,0,80),
(13,2417,0,16),
(13,2418,0,80),
(13,2422,0,20),
(13,2427,0,6),
(13,2431,0,0),
(13,2432,0,18),
(13,2439,0,0),
(13,2440,0,80),
(13,2441,0,80),
(13,2442,0,80),
(13,2444,0,80),
(13,2445,0,152),
(13,2446,0,18),
(13,2447,0,18),
(13,2448,0,18),
(13,2449,0,18),
(13,2450,0,18),
(13,2451,0,18),
(13,2452,0,18),
(13,2453,0,18),
(13,2454,0,18),
(13,2455,0,18),
(13,2456,0,18),
(13,2457,0,18),
(13,2458,0,18),
(13,2459,0,18),
(13,2460,0,18),
(13,2461,0,18),
(13,2462,0,18),
(13,2463,0,22),
(13,2464,0,18),
(13,2465,0,16),
(13,2469,0,18),
(13,2470,0,16),
(13,2471,0,80),
(13,2472,0,18),
(13,2473,0,80),
(13,2474,0,80),
(13,2478,0,16),
(13,2479,0,80),
(13,2503,0,16),
(13,2504,0,80),
(13,2506,0,4120),
(13,2507,0,152),
(13,2508,0,80),
(13,2509,0,2068),
(13,2510,0,152),
(13,2511,0,16),
(13,2512,0,2068),
(13,2513,0,2068),
(13,2517,0,18),
(13,2518,0,18),
(13,2520,0,2054),
(13,2521,0,2132),
(13,2522,0,2068),
(13,2523,0,2),
(13,2524,0,273),
(13,2526,0,0),
(13,2542,0,2054),
(13,2544,0,18),
(13,2550,0,18),
(13,2551,0,80),
(13,2552,0,80),
(13,2553,0,18),
(13,2554,0,2052),
(13,2555,0,2054),
(13,2564,0,16),
(13,2565,0,80),
(13,2568,0,18),
(13,2569,0,24),
(13,2570,0,16),
(13,2574,0,16),
(13,2575,0,64),
(13,2590,0,16),
(13,2593,0,16),
(13,2594,0,16),
(13,2596,0,80),
(13,2600,0,4248),
(13,2601,0,18),
(13,2604,0,80),
(13,2605,0,18),
(13,2607,0,18),
(13,2611,0,80),
(13,2612,0,80),
(13,2613,0,80),
(13,2615,0,18),
(13,2640,0,18),
(13,2644,0,0),
(13,2645,0,2068),
(13,2647,0,80),
(13,2648,0,80),
(13,2649,0,80),
(13,2653,0,152),
(13,2658,0,16),
(13,2659,0,80),
(13,2667,0,80),
(13,2668,0,80),
(13,2669,0,16),
(13,2670,0,80),
(13,2671,0,16),
(13,2672,0,80),
(13,2673,0,16),
(13,2674,0,80),
(13,2675,0,16),
(13,2676,0,80),
(13,2677,0,16),
(13,2683,0,0),
(13,2684,0,80),
(13,2685,0,16),
(13,2688,0,16),
(13,2689,0,80),
(13,2693,0,4248),
(13,2695,0,276),
(13,2697,0,4),
(13,2722,0,0),
(13,2736,0,16),
(13,2739,0,0),
(14,21,0,64),
(14,46,0,4),
(14,47,0,273),
(14,54,0,273),
(14,59,0,16),
(14,67,0,14),
(14,68,0,6),
(14,69,0,273),
(14,70,0,2),
(14,72,0,273),
(14,76,0,6),
(14,81,0,6),
(14,83,0,4),
(14,86,0,4),
(14,87,0,2),
(14,92,0,2),
(14,93,0,2),
(14,169,0,12),
(14,270,0,16),
(14,289,0,4),
(14,349,0,0),
(14,369,0,64),
(14,469,0,25),
(14,470,0,64),
(14,509,0,16),
(14,510,0,2),
(14,529,0,0),
(14,530,0,6),
(14,549,0,4),
(14,550,0,4),
(14,551,0,4),
(14,569,0,4),
(14,570,0,4),
(14,571,0,4),
(14,574,0,4),
(14,576,0,0),
(14,577,0,64),
(14,589,0,0),
(14,609,0,16),
(14,729,0,6),
(14,730,0,16),
(14,749,0,0),
(14,809,0,16),
(14,889,0,6),
(14,890,0,16),
(14,891,0,24),
(14,892,0,14),
(14,909,0,16),
(14,910,0,0),
(14,911,0,6),
(14,922,0,6),
(14,930,0,273),
(14,932,0,80),
(14,933,0,16),
(14,934,0,80),
(14,935,0,16),
(14,936,0,28),
(14,941,0,6),
(14,942,0,16),
(14,946,0,16),
(14,947,0,0),
(14,948,0,0),
(14,949,0,24),
(14,952,0,0),
(14,967,0,16),
(14,970,0,0),
(14,978,0,16),
(14,980,0,4120),
(14,989,0,16),
(14,990,0,16),
(14,1005,0,20),
(14,1011,0,16),
(14,1012,0,16),
(14,1015,0,2),
(14,1031,0,16),
(14,1037,0,136),
(14,1038,0,16),
(14,1050,0,16),
(14,1052,0,0),
(14,1064,0,6),
(14,1067,0,0),
(14,1068,0,16),
(14,1072,0,0),
(14,1073,0,16),
(14,1077,0,16),
(14,1085,0,6),
(14,1090,0,16),
(14,1091,0,16),
(14,1094,0,16),
(14,1097,0,4104),
(14,1098,0,16),
(14,1104,0,16),
(14,1105,0,16),
(14,1106,0,16),
(14,1117,0,12),
(14,1118,0,4104),
(14,1119,0,0),
(14,1124,0,6),
(14,1126,0,16),
(14,1133,0,6),
(14,1134,0,273),
(14,1135,0,16),
(14,1136,0,4),
(14,1137,0,4),
(14,1154,0,4),
(14,1155,0,4),
(14,1156,0,16),
(14,1158,0,16),
(14,1162,0,4104),
(14,1168,0,528),
(14,1169,0,4120),
(14,1171,0,64),
(14,1172,0,0),
(14,1173,0,16),
(14,1174,0,16),
(14,1177,0,0),
(14,1178,0,6),
(14,1204,0,16),
(14,1216,0,0),
(14,1228,0,2),
(14,1242,0,16),
(14,1245,0,4104),
(14,1269,0,16),
(14,1270,0,16),
(14,1271,0,16),
(14,1272,0,152),
(14,1273,0,16),
(14,1275,0,16),
(14,1276,0,16),
(14,1277,0,16),
(14,1278,0,16),
(14,1279,0,16),
(14,1280,0,16),
(14,1281,0,16),
(14,1282,0,16),
(14,1283,0,16),
(14,1302,0,152),
(14,1337,0,16),
(14,1341,0,16),
(14,1345,0,16),
(14,1351,0,0),
(14,1352,0,6),
(14,1353,0,273),
(14,1357,0,4),
(14,1358,0,16),
(14,1359,0,16),
(14,1374,0,0),
(14,1375,0,2),
(14,1376,0,144),
(14,1387,0,144),
(14,1388,0,2),
(14,1416,0,0),
(14,1419,0,16),
(14,1433,0,20),
(14,1435,0,16),
(14,1440,0,16),
(14,1444,0,4120),
(14,1445,0,2),
(14,1492,0,16),
(14,1515,0,16),
(14,1520,0,0),
(14,1679,0,0),
(14,1681,0,18),
(14,1682,0,16),
(14,1690,0,0),
(14,1691,0,16),
(14,1708,0,2),
(14,1710,0,16),
(14,1711,0,16),
(14,1712,0,1028),
(14,1713,0,1028),
(14,1714,0,1028),
(14,1715,0,1028),
(14,1716,0,1028),
(14,1717,0,1028),
(14,1718,0,1028),
(14,1731,0,16),
(14,1732,0,4),
(14,1733,0,16),
(14,1735,0,0),
(14,1736,0,16),
(14,1737,0,16),
(14,1738,0,16),
(14,1739,0,0),
(14,1740,0,0),
(14,1741,0,16),
(14,1815,0,4),
(14,1828,0,16),
(14,1834,0,4120),
(14,1847,0,16),
(14,1848,0,2),
(14,1849,0,16),
(14,1850,0,16),
(14,1859,0,16),
(14,1860,0,20),
(14,1861,0,20),
(14,1862,0,20),
(14,1883,0,16),
(14,1888,0,6),
(14,1894,0,16),
(14,1899,0,16),
(14,1900,0,16),
(14,1919,0,20),
(14,1947,0,0),
(14,1948,0,16),
(14,1975,0,16),
(14,1984,0,0),
(14,1989,0,4),
(14,2010,0,0),
(14,2011,0,16),
(14,2018,0,16),
(14,2045,0,16),
(14,2063,0,0),
(14,2085,0,80),
(14,2086,0,80),
(14,2087,0,80),
(14,2088,0,80),
(14,2089,0,80),
(14,2090,0,80),
(14,2091,0,80),
(14,2097,0,16),
(14,2098,0,16),
(14,2099,0,16),
(14,2100,0,16),
(14,2101,0,16),
(14,2102,0,16),
(14,2103,0,6),
(14,2104,0,4104),
(14,2111,0,6),
(14,2120,0,20),
(14,2135,0,16),
(14,2156,0,2),
(14,2157,0,2),
(14,2158,0,20),
(14,2159,0,16),
(14,2160,0,16),
(14,2161,0,16),
(14,2162,0,16),
(14,2163,0,16),
(14,2164,0,16),
(14,2165,0,16),
(14,2166,0,80),
(14,2167,0,80),
(14,2170,0,16),
(14,2233,0,4),
(14,2264,0,20),
(14,2265,0,20),
(14,2370,0,4),
(14,2371,0,16),
(14,2372,0,0),
(14,2373,0,20),
(14,2374,0,84),
(14,2375,0,4),
(14,2376,0,4),
(14,2377,0,4),
(14,2378,0,70),
(14,2379,0,80),
(14,2380,0,66),
(14,2381,0,80),
(14,2382,0,84),
(14,2383,0,80),
(14,2384,0,80),
(14,2385,0,66),
(14,2386,0,80),
(14,2387,0,80),
(14,2388,0,0),
(14,2389,0,0),
(14,2390,0,0),
(14,2391,0,16),
(14,2392,0,80),
(14,2395,0,16),
(14,2396,0,20),
(14,2397,0,20),
(14,2398,0,20),
(14,2400,0,16),
(14,2401,0,80),
(14,2407,0,16),
(14,2410,0,16),
(14,2413,0,16),
(14,2414,0,4104),
(14,2415,0,16),
(14,2416,0,80),
(14,2417,0,16),
(14,2418,0,80),
(14,2422,0,20),
(14,2427,0,4),
(14,2431,0,0),
(14,2432,0,16),
(14,2439,0,0),
(14,2440,0,80),
(14,2441,0,80),
(14,2442,0,80),
(14,2444,0,80),
(14,2445,0,152),
(14,2446,0,16),
(14,2447,0,16),
(14,2448,0,16),
(14,2449,0,16),
(14,2450,0,16),
(14,2451,0,16),
(14,2452,0,16),
(14,2453,0,16),
(14,2454,0,16),
(14,2455,0,16),
(14,2456,0,16),
(14,2457,0,16),
(14,2458,0,16),
(14,2459,0,16),
(14,2460,0,16),
(14,2461,0,16),
(14,2462,0,16),
(14,2463,0,20),
(14,2464,0,16),
(14,2465,0,16),
(14,2469,0,16),
(14,2470,0,16),
(14,2471,0,80),
(14,2472,0,16),
(14,2473,0,80),
(14,2474,0,80),
(14,2478,0,16),
(14,2479,0,80),
(14,2503,0,16),
(14,2504,0,80),
(14,2506,0,4120),
(14,2507,0,152),
(14,2508,0,80),
(14,2509,0,2068),
(14,2510,0,152),
(14,2511,0,16),
(14,2512,0,2068),
(14,2513,0,2068),
(14,2517,0,16),
(14,2518,0,16),
(14,2520,0,2054),
(14,2521,0,2132),
(14,2522,0,2068),
(14,2523,0,2),
(14,2524,0,273),
(14,2526,0,0),
(14,2542,0,2054),
(14,2544,0,16),
(14,2550,0,16),
(14,2551,0,80),
(14,2552,0,80),
(14,2553,0,16),
(14,2554,0,2052),
(14,2555,0,2054),
(14,2564,0,16),
(14,2565,0,80),
(14,2568,0,16),
(14,2569,0,24),
(14,2570,0,16),
(14,2574,0,16),
(14,2575,0,64),
(14,2590,0,16),
(14,2593,0,16),
(14,2594,0,16),
(14,2596,0,80),
(14,2600,0,4248),
(14,2601,0,16),
(14,2604,0,80),
(14,2605,0,16),
(14,2607,0,16),
(14,2611,0,80),
(14,2612,0,80),
(14,2613,0,80),
(14,2615,0,16),
(14,2640,0,16),
(14,2644,0,0),
(14,2645,0,2068),
(14,2647,0,80),
(14,2648,0,80),
(14,2649,0,80),
(14,2653,0,152),
(14,2658,0,16),
(14,2659,0,80),
(14,2667,0,80),
(14,2668,0,80),
(14,2669,0,16),
(14,2670,0,80),
(14,2671,0,16),
(14,2672,0,80),
(14,2673,0,16),
(14,2674,0,80),
(14,2675,0,16),
(14,2676,0,80),
(14,2677,0,16),
(14,2683,0,0),
(14,2684,0,80),
(14,2685,0,16),
(14,2688,0,16),
(14,2689,0,80),
(14,2693,0,4248),
(14,2695,0,276),
(14,2697,0,4),
(14,2722,0,0),
(14,2736,0,16),
(14,2739,0,0),
(15,21,0,64),
(15,46,0,4),
(15,47,250,17),
(15,54,62,273),
(15,59,0,16),
(15,67,0,14),
(15,68,0,6),
(15,69,62,273),
(15,70,0,2),
(15,72,62,273),
(15,76,0,6),
(15,81,0,6),
(15,83,0,4),
(15,86,0,4),
(15,87,0,2),
(15,92,0,2),
(15,93,0,2),
(15,169,0,12),
(15,270,0,16),
(15,289,0,4),
(15,349,0,0),
(15,369,0,64),
(15,469,0,25),
(15,470,0,64),
(15,509,0,16),
(15,510,0,2),
(15,529,0,0),
(15,530,0,6),
(15,549,0,4),
(15,550,0,4),
(15,551,0,4),
(15,569,0,4),
(15,570,0,4),
(15,571,0,4),
(15,574,0,4),
(15,576,0,0),
(15,577,0,64),
(15,589,0,0),
(15,609,0,16),
(15,729,0,6),
(15,730,0,16),
(15,749,0,0),
(15,809,0,16),
(15,889,0,6),
(15,890,0,16),
(15,891,0,24),
(15,892,0,14),
(15,909,0,16),
(15,910,0,0),
(15,911,0,6),
(15,922,0,6),
(15,930,62,273),
(15,932,0,80),
(15,933,0,16),
(15,934,0,80),
(15,935,0,16),
(15,936,0,28),
(15,941,0,6),
(15,942,0,16),
(15,946,0,16),
(15,947,0,0),
(15,948,0,8),
(15,949,0,24),
(15,952,0,0),
(15,967,0,16),
(15,970,0,0),
(15,978,0,16),
(15,980,0,4120),
(15,989,0,16),
(15,990,0,16),
(15,1005,0,20),
(15,1011,0,16),
(15,1012,0,16),
(15,1015,0,2),
(15,1031,0,16),
(15,1037,0,136),
(15,1038,0,16),
(15,1050,0,16),
(15,1052,0,0),
(15,1064,0,6),
(15,1067,0,0),
(15,1068,0,16),
(15,1072,0,0),
(15,1073,0,16),
(15,1077,0,16),
(15,1085,0,6),
(15,1090,0,16),
(15,1091,0,16),
(15,1094,0,16),
(15,1097,0,4104),
(15,1098,0,16),
(15,1104,0,16),
(15,1105,0,16),
(15,1106,0,16),
(15,1117,0,12),
(15,1118,0,4104),
(15,1119,0,0),
(15,1124,0,6),
(15,1126,0,16),
(15,1133,0,6),
(15,1134,62,273),
(15,1135,0,16),
(15,1136,0,4),
(15,1137,0,4),
(15,1154,0,4),
(15,1155,0,4),
(15,1156,0,16),
(15,1158,0,16),
(15,1162,0,4104),
(15,1168,0,528),
(15,1169,0,4120),
(15,1171,0,64),
(15,1172,0,0),
(15,1173,0,16),
(15,1174,0,16),
(15,1177,0,0),
(15,1178,0,6),
(15,1204,0,16),
(15,1216,0,0),
(15,1228,0,2),
(15,1242,0,16),
(15,1245,0,4104),
(15,1269,0,16),
(15,1270,0,16),
(15,1271,0,16),
(15,1272,0,152),
(15,1273,0,16),
(15,1275,0,16),
(15,1276,0,16),
(15,1277,0,16),
(15,1278,0,16),
(15,1279,0,16),
(15,1280,0,16),
(15,1281,0,16),
(15,1282,0,16),
(15,1283,0,16),
(15,1302,0,152),
(15,1337,0,16),
(15,1341,0,16),
(15,1345,0,16),
(15,1351,0,0),
(15,1352,0,6),
(15,1353,0,273),
(15,1357,0,4),
(15,1358,0,16),
(15,1359,0,16),
(15,1374,0,0),
(15,1375,0,2),
(15,1376,0,144),
(15,1387,0,144),
(15,1388,0,2),
(15,1416,0,0),
(15,1419,0,16),
(15,1433,0,20),
(15,1435,0,16),
(15,1440,0,16),
(15,1444,0,4120),
(15,1445,0,2),
(15,1492,0,16),
(15,1515,0,16),
(15,1520,0,0),
(15,1679,0,0),
(15,1681,0,18),
(15,1682,0,16),
(15,1690,0,0),
(15,1691,0,16),
(15,1708,0,2),
(15,1710,0,16),
(15,1711,0,16),
(15,1712,0,1028),
(15,1713,0,1028),
(15,1714,0,1028),
(15,1715,0,1028),
(15,1716,0,1028),
(15,1717,0,1028),
(15,1718,0,1028),
(15,1731,0,16),
(15,1732,0,4),
(15,1733,0,16),
(15,1735,0,0),
(15,1736,0,16),
(15,1737,0,16),
(15,1738,0,16),
(15,1739,0,0),
(15,1740,0,0),
(15,1741,0,16),
(15,1815,0,4),
(15,1828,0,16),
(15,1834,0,4120),
(15,1847,0,16),
(15,1848,0,2),
(15,1849,0,16),
(15,1850,0,16),
(15,1859,0,16),
(15,1860,0,20),
(15,1861,0,20),
(15,1862,0,20),
(15,1883,0,16),
(15,1888,0,6),
(15,1894,0,16),
(15,1899,0,16),
(15,1900,0,16),
(15,1919,0,20),
(15,1947,0,20),
(15,1948,0,16),
(15,1975,0,16),
(15,1984,0,0),
(15,1989,0,4),
(15,2010,0,0),
(15,2011,0,16),
(15,2018,0,16),
(15,2045,0,16),
(15,2063,0,0),
(15,2085,0,80),
(15,2086,0,80),
(15,2087,0,80),
(15,2088,0,80),
(15,2089,0,80),
(15,2090,0,80),
(15,2091,0,80),
(15,2097,0,16),
(15,2098,0,16),
(15,2099,0,16),
(15,2100,0,16),
(15,2101,0,16),
(15,2102,0,16),
(15,2103,0,6),
(15,2104,0,4104),
(15,2111,0,6),
(15,2120,0,20),
(15,2135,0,16),
(15,2156,0,2),
(15,2157,0,2),
(15,2158,0,20),
(15,2159,0,16),
(15,2160,0,16),
(15,2161,0,16),
(15,2162,0,16),
(15,2163,0,16),
(15,2164,0,16),
(15,2165,0,16),
(15,2166,0,80),
(15,2167,0,80),
(15,2170,0,16),
(15,2233,0,4),
(15,2264,0,20),
(15,2265,0,20),
(15,2370,0,4),
(15,2371,0,16),
(15,2372,0,0),
(15,2373,0,20),
(15,2374,0,84),
(15,2375,0,4),
(15,2376,0,4),
(15,2377,0,4),
(15,2378,0,70),
(15,2379,0,80),
(15,2380,0,66),
(15,2381,0,80),
(15,2382,0,84),
(15,2383,0,80),
(15,2384,0,80),
(15,2385,0,66),
(15,2386,0,80),
(15,2387,0,80),
(15,2388,0,0),
(15,2389,0,0),
(15,2390,0,0),
(15,2391,0,16),
(15,2392,0,80),
(15,2395,0,16),
(15,2396,0,20),
(15,2397,0,20),
(15,2398,0,20),
(15,2400,0,16),
(15,2401,0,80),
(15,2407,0,16),
(15,2410,0,16),
(15,2413,0,16),
(15,2414,0,4104),
(15,2415,0,16),
(15,2416,0,80),
(15,2417,0,16),
(15,2418,0,80),
(15,2422,0,20),
(15,2427,0,4),
(15,2431,0,0),
(15,2432,0,16),
(15,2439,0,0),
(15,2440,0,80),
(15,2441,0,80),
(15,2442,0,80),
(15,2444,0,80),
(15,2445,0,152),
(15,2446,0,16),
(15,2447,0,16),
(15,2448,0,16),
(15,2449,0,16),
(15,2450,0,16),
(15,2451,0,16),
(15,2452,0,16),
(15,2453,0,16),
(15,2454,0,16),
(15,2455,0,16),
(15,2456,0,16),
(15,2457,0,16),
(15,2458,0,16),
(15,2459,0,16),
(15,2460,0,16),
(15,2461,0,16),
(15,2462,0,16),
(15,2463,0,20),
(15,2464,0,16),
(15,2465,0,16),
(15,2469,0,16),
(15,2470,0,16),
(15,2471,0,80),
(15,2472,0,16),
(15,2473,0,80),
(15,2474,0,80),
(15,2478,0,16),
(15,2479,0,80),
(15,2503,0,16),
(15,2504,0,80),
(15,2506,0,4120),
(15,2507,0,152),
(15,2508,0,80),
(15,2509,0,2068),
(15,2510,0,152),
(15,2511,0,16),
(15,2512,0,2068),
(15,2513,0,2068),
(15,2517,0,16),
(15,2518,0,16),
(15,2520,0,2054),
(15,2521,0,2132),
(15,2522,0,2068),
(15,2523,0,2),
(15,2524,0,272),
(15,2526,0,0),
(15,2542,0,2054),
(15,2544,0,16),
(15,2550,0,16),
(15,2551,0,80),
(15,2552,0,80),
(15,2553,0,16),
(15,2554,0,2052),
(15,2555,0,2054),
(15,2564,0,16),
(15,2565,0,80),
(15,2568,0,16),
(15,2569,0,24),
(15,2570,0,16),
(15,2574,0,16),
(15,2575,0,64),
(15,2590,0,16),
(15,2593,0,16),
(15,2594,0,16),
(15,2596,0,80),
(15,2600,0,4248),
(15,2601,0,16),
(15,2604,0,80),
(15,2605,0,16),
(15,2607,0,16),
(15,2611,0,80),
(15,2612,0,80),
(15,2613,0,80),
(15,2615,0,16),
(15,2640,0,16),
(15,2644,0,0),
(15,2645,0,2068),
(15,2647,0,80),
(15,2648,0,80),
(15,2649,0,80),
(15,2653,0,152),
(15,2658,0,16),
(15,2659,0,80),
(15,2667,0,80),
(15,2668,0,80),
(15,2669,0,16),
(15,2670,0,80),
(15,2671,0,16),
(15,2672,0,80),
(15,2673,0,16),
(15,2674,0,80),
(15,2675,0,16),
(15,2676,0,80),
(15,2677,0,16),
(15,2683,0,0),
(15,2684,0,80),
(15,2685,0,16),
(15,2688,0,16),
(15,2689,0,80),
(15,2693,0,4248),
(15,2695,0,276),
(15,2697,0,4),
(15,2722,0,0),
(15,2736,0,16),
(15,2739,0,0),
(16,21,0,64),
(16,46,0,4),
(16,47,0,273),
(16,54,0,273),
(16,59,0,16),
(16,67,0,14),
(16,68,0,6),
(16,69,0,273),
(16,70,0,2),
(16,72,0,273),
(16,76,0,6),
(16,81,0,6),
(16,83,0,4),
(16,86,0,4),
(16,87,0,2),
(16,92,0,2),
(16,93,0,2),
(16,169,0,12),
(16,270,0,16),
(16,289,0,4),
(16,349,0,0),
(16,369,0,64),
(16,469,0,25),
(16,470,0,64),
(16,509,0,16),
(16,510,0,2),
(16,529,0,0),
(16,530,0,6),
(16,549,0,4),
(16,550,0,4),
(16,551,0,4),
(16,569,0,4),
(16,570,0,4),
(16,571,0,4),
(16,574,0,4),
(16,576,0,0),
(16,577,0,64),
(16,589,0,0),
(16,609,0,16),
(16,729,0,6),
(16,730,0,16),
(16,749,0,0),
(16,809,0,16),
(16,889,0,6),
(16,890,0,16),
(16,891,0,24),
(16,892,0,14),
(16,909,0,16),
(16,910,0,2),
(16,911,0,6),
(16,922,0,6),
(16,930,0,17),
(16,932,0,80),
(16,933,0,16),
(16,934,0,80),
(16,935,0,16),
(16,936,0,28),
(16,941,0,6),
(16,942,0,16),
(16,946,0,16),
(16,947,0,2),
(16,948,0,8),
(16,949,0,26),
(16,952,0,0),
(16,967,0,16),
(16,970,0,0),
(16,978,0,16),
(16,980,0,4120),
(16,989,0,16),
(16,990,0,16),
(16,1005,0,20),
(16,1011,0,16),
(16,1012,0,16),
(16,1015,0,2),
(16,1031,0,16),
(16,1037,0,136),
(16,1038,0,16),
(16,1050,0,16),
(16,1052,0,2),
(16,1064,0,6),
(16,1067,0,2),
(16,1068,0,16),
(16,1072,0,0),
(16,1073,0,16),
(16,1077,0,16),
(16,1085,0,6),
(16,1090,0,16),
(16,1091,0,16),
(16,1094,0,16),
(16,1097,0,4104),
(16,1098,0,16),
(16,1104,0,16),
(16,1105,0,16),
(16,1106,0,16),
(16,1117,0,12),
(16,1118,0,4104),
(16,1119,0,2),
(16,1124,0,6),
(16,1126,0,16),
(16,1133,0,6),
(16,1134,0,273),
(16,1135,0,16),
(16,1136,0,4),
(16,1137,0,4),
(16,1154,0,4),
(16,1155,0,4),
(16,1156,0,16),
(16,1158,0,16),
(16,1162,0,4104),
(16,1168,0,528),
(16,1169,0,4120),
(16,1171,0,66),
(16,1172,0,2),
(16,1173,0,16),
(16,1174,0,16),
(16,1177,0,0),
(16,1178,0,6),
(16,1204,0,16),
(16,1216,0,0),
(16,1228,0,2),
(16,1242,0,16),
(16,1245,0,4104),
(16,1269,0,16),
(16,1270,0,16),
(16,1271,0,16),
(16,1272,0,152),
(16,1273,0,18),
(16,1275,0,18),
(16,1276,0,18),
(16,1277,0,18),
(16,1278,0,18),
(16,1279,0,18),
(16,1280,0,18),
(16,1281,0,18),
(16,1282,0,18),
(16,1283,0,18),
(16,1302,0,152),
(16,1337,0,16),
(16,1341,0,16),
(16,1345,0,16),
(16,1351,0,0),
(16,1352,0,6),
(16,1353,0,273),
(16,1357,0,6),
(16,1358,0,18),
(16,1359,0,16),
(16,1374,0,2),
(16,1375,0,2),
(16,1376,0,144),
(16,1387,0,144),
(16,1388,0,2),
(16,1416,0,0),
(16,1419,0,18),
(16,1433,0,20),
(16,1435,0,16),
(16,1440,0,18),
(16,1444,0,4120),
(16,1445,0,2),
(16,1492,0,16),
(16,1515,0,16),
(16,1520,0,0),
(16,1679,0,0),
(16,1681,0,18),
(16,1682,0,16),
(16,1690,0,2),
(16,1691,0,18),
(16,1708,0,2),
(16,1710,0,16),
(16,1711,0,16),
(16,1712,0,1028),
(16,1713,0,1028),
(16,1714,0,1028),
(16,1715,0,1028),
(16,1716,0,1028),
(16,1717,0,1028),
(16,1718,0,1028),
(16,1731,0,16),
(16,1732,0,4),
(16,1733,0,18),
(16,1735,0,0),
(16,1736,0,18),
(16,1737,0,18),
(16,1738,0,18),
(16,1739,0,2),
(16,1740,0,2),
(16,1741,0,18),
(16,1815,0,4),
(16,1828,0,16),
(16,1834,0,4120),
(16,1847,0,16),
(16,1848,0,2),
(16,1849,0,16),
(16,1850,0,16),
(16,1859,0,16),
(16,1860,0,22),
(16,1861,0,22),
(16,1862,0,22),
(16,1883,0,16),
(16,1888,0,6),
(16,1894,0,16),
(16,1899,0,16),
(16,1900,0,16),
(16,1919,0,22),
(16,1947,0,20),
(16,1948,0,16),
(16,1975,0,18),
(16,1984,0,2),
(16,1989,0,4),
(16,2010,0,2),
(16,2011,0,18),
(16,2018,0,16),
(16,2045,0,16),
(16,2063,0,0),
(16,2085,0,80),
(16,2086,0,80),
(16,2087,0,80),
(16,2088,0,80),
(16,2089,0,80),
(16,2090,0,80),
(16,2091,0,80),
(16,2097,0,18),
(16,2098,0,18),
(16,2099,0,18),
(16,2100,0,18),
(16,2101,0,18),
(16,2102,0,18),
(16,2103,0,6),
(16,2104,0,4104),
(16,2111,0,6),
(16,2120,0,20),
(16,2135,0,18),
(16,2156,0,2),
(16,2157,0,2),
(16,2158,0,20),
(16,2159,0,16),
(16,2160,0,16),
(16,2161,0,16),
(16,2162,0,16),
(16,2163,0,16),
(16,2164,0,16),
(16,2165,0,16),
(16,2166,0,80),
(16,2167,0,80),
(16,2170,0,16),
(16,2233,0,6),
(16,2264,0,20),
(16,2265,0,20),
(16,2370,0,6),
(16,2371,0,18),
(16,2372,0,2),
(16,2373,0,20),
(16,2374,0,84),
(16,2375,0,6),
(16,2376,0,6),
(16,2377,0,6),
(16,2378,0,70),
(16,2379,0,80),
(16,2380,0,66),
(16,2381,0,80),
(16,2382,0,84),
(16,2383,0,80),
(16,2384,0,80),
(16,2385,0,66),
(16,2386,0,80),
(16,2387,0,80),
(16,2388,0,2),
(16,2389,0,2),
(16,2390,0,2),
(16,2391,0,16),
(16,2392,0,80),
(16,2395,0,16),
(16,2396,0,22),
(16,2397,0,22),
(16,2398,0,22),
(16,2400,0,16),
(16,2401,0,80),
(16,2407,0,16),
(16,2410,0,16),
(16,2413,0,16),
(16,2414,0,4104),
(16,2415,0,16),
(16,2416,0,80),
(16,2417,0,16),
(16,2418,0,80),
(16,2422,0,20),
(16,2427,0,6),
(16,2431,0,0),
(16,2432,0,18),
(16,2439,0,0),
(16,2440,0,80),
(16,2441,0,80),
(16,2442,0,80),
(16,2444,0,80),
(16,2445,0,152),
(16,2446,0,18),
(16,2447,0,18),
(16,2448,0,18),
(16,2449,0,18),
(16,2450,0,18),
(16,2451,0,18),
(16,2452,0,18),
(16,2453,0,18),
(16,2454,0,18),
(16,2455,0,18),
(16,2456,0,18),
(16,2457,0,18),
(16,2458,0,18),
(16,2459,0,18),
(16,2460,0,18),
(16,2461,0,18),
(16,2462,0,18),
(16,2463,0,22),
(16,2464,0,18),
(16,2465,0,16),
(16,2469,0,18),
(16,2470,0,16),
(16,2471,0,80),
(16,2472,0,18),
(16,2473,0,80),
(16,2474,0,80),
(16,2478,0,16),
(16,2479,0,80),
(16,2503,0,16),
(16,2504,0,80),
(16,2506,0,4120),
(16,2507,0,152),
(16,2508,0,80),
(16,2509,0,2068),
(16,2510,0,152),
(16,2511,0,16),
(16,2512,0,2068),
(16,2513,0,2068),
(16,2517,0,18),
(16,2518,0,18),
(16,2520,0,2054),
(16,2521,0,2132),
(16,2522,0,2068),
(16,2523,0,2),
(16,2524,0,272),
(16,2526,0,0),
(16,2542,0,2054),
(16,2544,0,18),
(16,2550,0,18),
(16,2551,0,80),
(16,2552,0,80),
(16,2553,0,18),
(16,2554,0,2052),
(16,2555,0,2054),
(16,2564,0,16),
(16,2565,0,80),
(16,2568,0,18),
(16,2569,0,24),
(16,2570,0,16),
(16,2574,0,16),
(16,2575,0,64),
(16,2590,0,16),
(16,2593,0,16),
(16,2594,0,16),
(16,2596,0,80),
(16,2600,0,4248),
(16,2601,0,18),
(16,2604,0,80),
(16,2605,0,18),
(16,2607,0,18),
(16,2611,0,80),
(16,2612,0,80),
(16,2613,0,80),
(16,2615,0,18),
(16,2640,0,18),
(16,2644,0,0),
(16,2645,0,2068),
(16,2647,0,80),
(16,2648,0,80),
(16,2649,0,80),
(16,2653,0,152),
(16,2658,0,16),
(16,2659,0,80),
(16,2667,0,80),
(16,2668,0,80),
(16,2669,0,16),
(16,2670,0,80),
(16,2671,0,16),
(16,2672,0,80),
(16,2673,0,16),
(16,2674,0,80),
(16,2675,0,16),
(16,2676,0,80),
(16,2677,0,16),
(16,2683,0,0),
(16,2684,0,80),
(16,2685,0,16),
(16,2688,0,16),
(16,2689,0,80),
(16,2693,0,4248),
(16,2695,0,276),
(16,2697,0,4),
(16,2722,0,0),
(16,2736,0,16),
(16,2739,0,0);
/*!40000 ALTER TABLE `character_reputation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_skills`
--

DROP TABLE IF EXISTS `character_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_skills` (
  `guid` bigint(20) unsigned NOT NULL COMMENT 'Global Unique Identifier',
  `skill` smallint(5) unsigned NOT NULL,
  `value` smallint(5) unsigned NOT NULL,
  `max` smallint(5) unsigned NOT NULL,
  `professionSlot` tinyint(4) NOT NULL DEFAULT -1,
  PRIMARY KEY (`guid`,`skill`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_skills`
--

LOCK TABLES `character_skills` WRITE;
/*!40000 ALTER TABLE `character_skills` DISABLE KEYS */;
INSERT INTO `character_skills` VALUES
(3,43,1,30,-1),
(3,44,1,30,-1),
(3,54,1,30,-1),
(3,55,1,30,-1),
(3,95,1,30,-1),
(3,98,300,300,-1),
(3,160,1,30,-1),
(3,162,1,30,-1),
(3,172,1,30,-1),
(3,183,30,30,-1),
(3,229,1,30,-1),
(3,293,1,1,-1),
(3,413,1,1,-1),
(3,414,1,1,-1),
(3,415,1,1,-1),
(3,433,1,1,-1),
(3,754,30,30,-1),
(3,777,1,30,-1),
(3,800,30,30,-1),
(3,810,1,30,-1),
(3,934,1,30,-1),
(3,1830,1,75,-1),
(3,2727,1,30,-1),
(3,2817,30,30,-1),
(3,2902,1,30,-1),
(4,43,1,40,-1),
(4,95,1,40,-1),
(4,98,300,300,-1),
(4,136,1,40,-1),
(4,162,1,40,-1),
(4,173,1,40,-1),
(4,183,40,40,-1),
(4,228,40,40,-1),
(4,415,1,1,-1),
(4,759,300,300,-1),
(4,760,40,40,-1),
(4,777,1,40,-1),
(4,810,1,40,-1),
(4,904,40,40,-1),
(4,934,1,40,-1),
(4,1830,1,75,-1),
(4,2727,1,40,-1),
(4,2817,40,40,-1),
(4,2902,1,40,-1),
(6,54,1,40,-1),
(6,95,1,40,-1),
(6,98,300,300,-1),
(6,113,300,300,-1),
(6,126,40,40,-1),
(6,136,1,40,-1),
(6,162,1,40,-1),
(6,173,1,40,-1),
(6,183,40,40,-1),
(6,185,1,75,-1),
(6,228,40,40,-1),
(6,415,1,1,-1),
(6,777,1,40,-1),
(6,804,40,40,-1),
(6,810,1,40,-1),
(6,934,1,40,-1),
(6,1830,1,75,-1),
(6,2545,1,75,-1),
(6,2548,1,300,-1),
(6,2727,1,40,-1),
(6,2817,40,40,-1),
(6,2902,1,40,-1),
(7,43,1,75,-1),
(7,44,1,75,-1),
(7,45,1,75,-1),
(7,46,1,75,-1),
(7,54,1,75,-1),
(7,95,1,75,-1),
(7,98,300,300,-1),
(7,113,300,300,-1),
(7,118,75,75,-1),
(7,126,75,75,-1),
(7,162,1,75,-1),
(7,171,1,75,1),
(7,173,1,75,-1),
(7,182,1,75,0),
(7,183,75,75,-1),
(7,185,1,75,-1),
(7,226,1,75,-1),
(7,356,1,75,-1),
(7,414,1,1,-1),
(7,415,1,1,-1),
(7,473,1,75,-1),
(7,777,1,75,-1),
(7,794,1,700,-1),
(7,810,1,75,-1),
(7,921,75,75,-1),
(7,934,1,75,-1),
(7,1830,1,75,-1),
(7,2482,1,75,-1),
(7,2485,28,300,-1),
(7,2545,1,75,-1),
(7,2548,17,300,-1),
(7,2553,1,75,-1),
(7,2556,45,300,-1),
(7,2585,1,150,-1),
(7,2586,1,100,-1),
(7,2587,1,100,-1),
(7,2588,1,75,-1),
(7,2589,1,75,-1),
(7,2590,1,75,-1),
(7,2591,1,75,-1),
(7,2592,1,300,-1),
(7,2727,1,75,-1),
(7,2754,1,200,-1),
(7,2817,75,75,-1),
(7,2902,1,75,-1),
(8,43,1,70,-1),
(8,44,1,70,-1),
(8,54,1,70,-1),
(8,55,1,70,-1),
(8,95,1,70,-1),
(8,98,300,300,-1),
(8,160,1,70,-1),
(8,162,1,70,-1),
(8,172,1,70,-1),
(8,183,70,70,-1),
(8,229,1,70,-1),
(8,293,1,1,-1),
(8,413,1,1,-1),
(8,414,1,1,-1),
(8,415,1,1,-1),
(8,433,1,1,-1),
(8,754,70,70,-1),
(8,777,1,70,-1),
(8,800,70,70,-1),
(8,810,1,70,-1),
(8,934,1,70,-1),
(8,1830,1,75,-1),
(8,2727,1,70,-1),
(8,2817,70,70,-1),
(8,2902,1,70,-1),
(10,54,1,75,-1),
(10,95,1,75,-1),
(10,98,300,300,-1),
(10,113,300,300,-1),
(10,126,75,75,-1),
(10,136,1,75,-1),
(10,160,1,75,-1),
(10,162,1,75,-1),
(10,173,1,75,-1),
(10,183,75,75,-1),
(10,185,1,75,-1),
(10,229,1,75,-1),
(10,393,1,75,0),
(10,414,1,1,-1),
(10,415,1,1,-1),
(10,473,1,75,-1),
(10,777,1,75,-1),
(10,798,75,75,-1),
(10,810,1,75,-1),
(10,934,1,75,-1),
(10,1830,1,75,-1),
(10,2545,1,75,-1),
(10,2548,1,300,-1),
(10,2564,5,300,-1),
(10,2727,1,75,-1),
(10,2817,75,75,-1),
(10,2902,1,75,-1),
(11,44,1,35,-1),
(11,54,1,35,-1),
(11,95,1,35,-1),
(11,98,300,300,-1),
(11,136,1,35,-1),
(11,160,1,35,-1),
(11,162,1,35,-1),
(11,172,1,35,-1),
(11,173,1,35,-1),
(11,183,35,35,-1),
(11,413,1,1,-1),
(11,414,1,1,-1),
(11,415,1,1,-1),
(11,433,1,1,-1),
(11,473,1,35,-1),
(11,759,300,300,-1),
(11,760,35,35,-1),
(11,777,1,35,-1),
(11,810,1,35,-1),
(11,924,35,35,-1),
(11,934,1,35,-1),
(11,1830,1,75,-1),
(11,2727,1,35,-1),
(11,2817,35,35,-1),
(11,2902,1,35,-1),
(12,54,1,35,-1),
(12,95,1,35,-1),
(12,98,300,300,-1),
(12,113,300,300,-1),
(12,126,35,35,-1),
(12,136,1,35,-1),
(12,162,1,35,-1),
(12,173,1,35,-1),
(12,183,35,35,-1),
(12,228,35,35,-1),
(12,415,1,1,-1),
(12,777,1,35,-1),
(12,804,35,35,-1),
(12,810,1,35,-1),
(12,934,1,35,-1),
(12,1830,1,75,-1),
(12,2727,1,35,-1),
(12,2817,35,35,-1),
(12,2902,1,35,-1),
(13,54,1,410,-1),
(13,95,1,410,-1),
(13,98,300,300,-1),
(13,113,300,300,-1),
(13,126,410,410,-1),
(13,136,1,410,-1),
(13,160,1,410,-1),
(13,162,1,410,-1),
(13,173,1,410,-1),
(13,183,410,410,-1),
(13,229,1,410,-1),
(13,356,1,75,-1),
(13,414,1,1,-1),
(13,415,1,1,-1),
(13,473,1,410,-1),
(13,777,1,410,-1),
(13,798,410,410,-1),
(13,810,1,410,-1),
(13,934,1,410,-1),
(13,1830,1,75,-1),
(13,2585,1,150,-1),
(13,2586,1,100,-1),
(13,2587,1,100,-1),
(13,2588,1,75,-1),
(13,2589,1,75,-1),
(13,2590,1,75,-1),
(13,2591,1,75,-1),
(13,2592,1,300,-1),
(13,2727,1,410,-1),
(13,2817,410,410,-1),
(13,2902,1,410,-1),
(14,43,1,50,-1),
(14,44,1,50,-1),
(14,54,1,50,-1),
(14,55,1,50,-1),
(14,95,1,50,-1),
(14,98,300,300,-1),
(14,136,1,50,-1),
(14,138,300,300,-1),
(14,160,1,50,-1),
(14,162,1,50,-1),
(14,172,1,50,-1),
(14,173,1,50,-1),
(14,183,50,50,-1),
(14,413,1,1,-1),
(14,414,1,1,-1),
(14,415,1,1,-1),
(14,473,1,50,-1),
(14,777,1,50,-1),
(14,810,1,50,-1),
(14,934,1,50,-1),
(14,1830,1,75,-1),
(14,2727,1,50,-1),
(14,2808,50,50,-1),
(14,2810,50,50,-1),
(14,2817,50,50,-1),
(14,2902,1,50,-1),
(15,43,1,10,-1),
(15,95,1,10,-1),
(15,98,300,300,-1),
(15,101,10,10,-1),
(15,111,300,300,-1),
(15,136,1,10,-1),
(15,162,1,10,-1),
(15,173,1,10,-1),
(15,183,10,10,-1),
(15,228,10,10,-1),
(15,415,1,1,-1),
(15,777,1,10,-1),
(15,810,1,10,-1),
(15,904,10,10,-1),
(15,934,1,10,-1),
(15,1830,1,75,-1),
(15,2727,1,10,-1),
(15,2817,10,10,-1),
(15,2902,1,10,-1),
(16,43,1,25,-1),
(16,44,1,25,-1),
(16,54,1,25,-1),
(16,55,1,25,-1),
(16,95,1,25,-1),
(16,98,300,300,-1),
(16,160,1,25,-1),
(16,162,1,25,-1),
(16,172,1,25,-1),
(16,183,25,25,-1),
(16,229,1,25,-1),
(16,293,1,1,-1),
(16,413,1,1,-1),
(16,414,1,1,-1),
(16,415,1,1,-1),
(16,433,1,1,-1),
(16,759,300,300,-1),
(16,760,25,25,-1),
(16,777,1,25,-1),
(16,800,25,25,-1),
(16,810,1,25,-1),
(16,934,1,25,-1),
(16,1830,1,75,-1),
(16,2727,1,25,-1),
(16,2817,25,25,-1),
(16,2902,1,25,-1);
/*!40000 ALTER TABLE `character_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_social`
--

DROP TABLE IF EXISTS `character_social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_social` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Character Global Unique Identifier',
  `friend` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Friend Global Unique Identifier',
  `flags` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Friend Flags',
  `note` varchar(48) NOT NULL DEFAULT '' COMMENT 'Friend Note',
  PRIMARY KEY (`guid`,`friend`,`flags`),
  KEY `friend` (`friend`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_social`
--

LOCK TABLES `character_social` WRITE;
/*!40000 ALTER TABLE `character_social` DISABLE KEYS */;
INSERT INTO `character_social` VALUES
(3,4,1,''),
(6,13,1,'');
/*!40000 ALTER TABLE `character_social` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_spell`
--

DROP TABLE IF EXISTS `character_spell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_spell` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `spell` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Spell Identifier',
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `disabled` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_spell`
--

LOCK TABLES `character_spell` WRITE;
/*!40000 ALTER TABLE `character_spell` DISABLE KEYS */;
INSERT INTO `character_spell` VALUES
(6,2550,1,0),
(6,37836,1,0),
(6,88006,1,0),
(6,88015,1,0),
(6,264632,1,0),
(6,264638,1,0),
(7,2259,1,0),
(7,2331,1,0),
(7,2366,1,0),
(7,2539,1,0),
(7,2550,1,0),
(7,3170,1,0),
(7,6412,1,0),
(7,7620,1,0),
(7,7751,1,0),
(7,7752,1,0),
(7,37836,1,0),
(7,80477,1,0),
(7,88006,1,0),
(7,88015,1,0),
(7,158762,1,0),
(7,264211,1,0),
(7,264243,1,0),
(7,264632,1,0),
(7,264638,1,0),
(7,265819,1,0),
(7,265825,1,0),
(7,271616,1,0),
(7,271656,1,0),
(7,271658,1,0),
(7,271660,1,0),
(7,271662,1,0),
(7,271664,1,0),
(7,271672,1,0),
(7,271675,1,0),
(7,310675,1,0),
(8,125610,1,0),
(10,2550,1,0),
(10,8613,1,0),
(10,37836,1,0),
(10,88006,1,0),
(10,88015,1,0),
(10,125610,1,0),
(10,264632,1,0),
(10,264638,1,0),
(10,265855,1,0),
(11,125610,1,0),
(13,7620,1,0),
(13,41513,1,0),
(13,271616,1,0),
(13,271656,1,0),
(13,271658,1,0),
(13,271660,1,0),
(13,271662,1,0),
(13,271664,1,0),
(13,271672,1,0),
(13,271675,1,0);
/*!40000 ALTER TABLE `character_spell` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_spell_charges`
--

DROP TABLE IF EXISTS `character_spell_charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_spell_charges` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier, Low part',
  `categoryId` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'SpellCategory.dbc Identifier',
  `rechargeStart` bigint(20) NOT NULL DEFAULT 0,
  `rechargeEnd` bigint(20) NOT NULL DEFAULT 0,
  KEY `idx_guid` (`guid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_spell_charges`
--

LOCK TABLES `character_spell_charges` WRITE;
/*!40000 ALTER TABLE `character_spell_charges` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_spell_charges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_spell_cooldown`
--

DROP TABLE IF EXISTS `character_spell_cooldown`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_spell_cooldown` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier, Low part',
  `spell` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Spell Identifier',
  `item` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Item Identifier',
  `time` bigint(20) NOT NULL DEFAULT 0,
  `categoryId` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Spell category Id',
  `categoryEnd` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_spell_cooldown`
--

LOCK TABLES `character_spell_cooldown` WRITE;
/*!40000 ALTER TABLE `character_spell_cooldown` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_spell_cooldown` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_spell_favorite`
--

DROP TABLE IF EXISTS `character_spell_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_spell_favorite` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `spell` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Spell Identifier',
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_spell_favorite`
--

LOCK TABLES `character_spell_favorite` WRITE;
/*!40000 ALTER TABLE `character_spell_favorite` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_spell_favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_stats`
--

DROP TABLE IF EXISTS `character_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_stats` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier, Low part',
  `maxhealth` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower1` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower2` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower3` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower4` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower5` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower6` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower7` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower8` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower9` int(10) unsigned NOT NULL DEFAULT 0,
  `maxpower10` int(10) unsigned NOT NULL DEFAULT 0,
  `strength` int(10) unsigned NOT NULL DEFAULT 0,
  `agility` int(10) unsigned NOT NULL DEFAULT 0,
  `stamina` int(10) unsigned NOT NULL DEFAULT 0,
  `intellect` int(10) unsigned NOT NULL DEFAULT 0,
  `armor` int(10) unsigned NOT NULL DEFAULT 0,
  `resHoly` int(10) unsigned NOT NULL DEFAULT 0,
  `resFire` int(10) unsigned NOT NULL DEFAULT 0,
  `resNature` int(10) unsigned NOT NULL DEFAULT 0,
  `resFrost` int(10) unsigned NOT NULL DEFAULT 0,
  `resShadow` int(10) unsigned NOT NULL DEFAULT 0,
  `resArcane` int(10) unsigned NOT NULL DEFAULT 0,
  `blockPct` float unsigned NOT NULL DEFAULT 0,
  `dodgePct` float unsigned NOT NULL DEFAULT 0,
  `parryPct` float unsigned NOT NULL DEFAULT 0,
  `critPct` float unsigned NOT NULL DEFAULT 0,
  `rangedCritPct` float unsigned NOT NULL DEFAULT 0,
  `spellCritPct` float unsigned NOT NULL DEFAULT 0,
  `attackPower` int(10) unsigned NOT NULL DEFAULT 0,
  `rangedAttackPower` int(10) unsigned NOT NULL DEFAULT 0,
  `spellPower` int(10) unsigned NOT NULL DEFAULT 0,
  `resilience` int(10) unsigned NOT NULL DEFAULT 0,
  `mastery` float NOT NULL DEFAULT 0,
  `versatility` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_stats`
--

LOCK TABLES `character_stats` WRITE;
/*!40000 ALTER TABLE `character_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_talent`
--

DROP TABLE IF EXISTS `character_talent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_talent` (
  `guid` bigint(20) unsigned NOT NULL,
  `talentId` int(10) unsigned NOT NULL,
  `talentGroup` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`talentId`,`talentGroup`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_talent`
--

LOCK TABLES `character_talent` WRITE;
/*!40000 ALTER TABLE `character_talent` DISABLE KEYS */;
INSERT INTO `character_talent` VALUES
(13,18570,0),
(13,18571,0),
(13,18576,0),
(13,18577,0),
(13,18580,0),
(13,19283,0),
(13,21193,0),
(13,21648,0),
(13,21655,0),
(13,21702,0),
(13,21706,0),
(13,21778,0),
(13,22157,0),
(13,22159,0),
(13,22163,0),
(13,22165,0),
(13,22385,0),
(13,22386,0),
(13,22387,0),
(13,22389,0);
/*!40000 ALTER TABLE `character_talent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_trait_config`
--

DROP TABLE IF EXISTS `character_trait_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_trait_config` (
  `guid` bigint(20) unsigned NOT NULL,
  `traitConfigId` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `chrSpecializationId` int(11) DEFAULT NULL,
  `combatConfigFlags` int(11) DEFAULT NULL,
  `localIdentifier` int(11) DEFAULT NULL,
  `skillLineId` int(11) DEFAULT NULL,
  `traitSystemId` int(11) DEFAULT NULL,
  `variationId` int(11) DEFAULT NULL,
  `name` varchar(260) NOT NULL DEFAULT '',
  PRIMARY KEY (`guid`,`traitConfigId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_trait_config`
--

LOCK TABLES `character_trait_config` WRITE;
/*!40000 ALTER TABLE `character_trait_config` DISABLE KEYS */;
INSERT INTO `character_trait_config` VALUES
(3,1762238604,1,65,1,1,NULL,NULL,NULL,'Holy'),
(3,1762238605,1,66,1,1,NULL,NULL,NULL,'Protection'),
(3,1762238606,1,70,1,1,NULL,NULL,NULL,'Retribution'),
(4,1762358189,1,62,1,1,NULL,NULL,NULL,'Arcane'),
(4,1762358190,1,63,1,1,NULL,NULL,NULL,'Fire'),
(4,1762358191,1,64,1,1,NULL,NULL,NULL,'Frost'),
(6,1762379162,1,256,1,1,NULL,NULL,NULL,'Discipline'),
(6,1762379163,1,257,1,1,NULL,NULL,NULL,'Holy'),
(6,1762379164,1,258,1,1,NULL,NULL,NULL,'Shadow'),
(7,1762643920,1,259,1,1,NULL,NULL,NULL,'Assassination'),
(7,1762643921,1,260,1,1,NULL,NULL,NULL,'Outlaw'),
(7,1762643922,1,261,1,1,NULL,NULL,NULL,'Subtlety'),
(8,1762643923,1,65,1,1,NULL,NULL,NULL,'Holy'),
(8,1762643924,1,66,1,1,NULL,NULL,NULL,'Protection'),
(8,1762643925,1,70,1,1,NULL,NULL,NULL,'Retribution'),
(10,1762643929,1,102,1,1,NULL,NULL,NULL,'Balance'),
(10,1762643930,1,103,1,1,NULL,NULL,NULL,'Feral'),
(10,1762643931,1,104,1,1,NULL,NULL,NULL,'Guardian'),
(10,1762643932,1,105,1,1,NULL,NULL,NULL,'Restoration'),
(11,1762643933,1,262,1,1,NULL,NULL,NULL,'Elemental'),
(11,1762643934,1,263,1,1,NULL,NULL,NULL,'Enhancement'),
(11,1762643935,1,264,1,1,NULL,NULL,NULL,'Restoration'),
(12,1762643936,1,256,1,1,NULL,NULL,NULL,'Discipline'),
(12,1762643937,1,257,1,1,NULL,NULL,NULL,'Holy'),
(12,1762643938,1,258,1,1,NULL,NULL,NULL,'Shadow'),
(13,1762704167,1,102,1,1,NULL,NULL,NULL,'Balance'),
(13,1762704168,1,103,1,1,NULL,NULL,NULL,'Feral'),
(13,1762704169,1,104,1,1,NULL,NULL,NULL,'Guardian'),
(13,1762704170,1,105,1,1,NULL,NULL,NULL,'Restoration'),
(14,1762820576,1,1467,1,1,NULL,NULL,NULL,'Devastation'),
(14,1762820577,1,1468,1,1,NULL,NULL,NULL,'Preservation'),
(14,1762820578,1,1473,1,1,NULL,NULL,NULL,'Augmentation'),
(15,1762833348,1,62,1,1,NULL,NULL,NULL,'Arcane'),
(15,1762833349,1,63,1,1,NULL,NULL,NULL,'Fire'),
(15,1762833350,1,64,1,1,NULL,NULL,NULL,'Frost'),
(16,1762833351,1,65,1,1,NULL,NULL,NULL,'Holy'),
(16,1762833352,1,66,1,1,NULL,NULL,NULL,'Protection'),
(16,1762833353,1,70,1,1,NULL,NULL,NULL,'Retribution');
/*!40000 ALTER TABLE `character_trait_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_trait_entry`
--

DROP TABLE IF EXISTS `character_trait_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_trait_entry` (
  `guid` bigint(20) unsigned NOT NULL,
  `traitConfigId` int(11) NOT NULL,
  `traitNodeId` int(11) NOT NULL,
  `traitNodeEntryId` int(11) NOT NULL,
  `rank` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`traitConfigId`,`traitNodeId`,`traitNodeEntryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_trait_entry`
--

LOCK TABLES `character_trait_entry` WRITE;
/*!40000 ALTER TABLE `character_trait_entry` DISABLE KEYS */;
INSERT INTO `character_trait_entry` VALUES
(3,1762238604,81597,102583,0),
(3,1762238604,81600,102587,0),
(3,1762238604,81632,102625,0),
(3,1762238605,81597,102583,0),
(3,1762238605,81600,102587,0),
(3,1762238605,81632,102625,0),
(3,1762238606,81510,102479,0),
(3,1762238606,81600,102587,0),
(3,1762238606,81603,102590,0),
(4,1762358189,62121,80180,0),
(4,1762358190,62119,80178,0),
(4,1762358191,62117,80176,0),
(6,1762379162,82713,103865,0),
(6,1762379162,82717,103869,0),
(6,1762379163,82717,103869,0),
(6,1762379163,82718,103870,0),
(6,1762379164,82712,103864,0),
(6,1762379164,82713,103865,0),
(7,1762643920,90740,112630,0),
(7,1762643921,90684,112572,0),
(7,1762643922,90684,112572,1),
(7,1762643922,90690,112578,1),
(7,1762643922,90697,112585,0),
(7,1762643922,90726,112614,1),
(7,1762643922,90739,112629,1),
(7,1762643922,90740,112630,1),
(7,1762643922,90764,112657,1),
(8,1762643923,81597,102583,0),
(8,1762643923,81600,102587,0),
(8,1762643923,81632,102625,0),
(8,1762643924,81597,102583,0),
(8,1762643924,81600,102587,0),
(8,1762643924,81632,102625,0),
(8,1762643925,81510,102479,0),
(8,1762643925,81526,102498,1),
(8,1762643925,81527,102499,1),
(8,1762643925,81600,102587,0),
(8,1762643925,81602,102589,1),
(8,1762643925,81603,102590,0),
(8,1762643925,81604,102591,1),
(8,1762643925,81632,102625,1),
(10,1762643929,82201,103279,0),
(10,1762643929,82202,103280,0),
(10,1762643929,82208,103286,0),
(10,1762643930,82119,103183,1),
(10,1762643930,82120,103184,1),
(10,1762643930,82124,103188,1),
(10,1762643930,82199,103277,0),
(10,1762643930,82221,103299,1),
(10,1762643930,82222,103300,0),
(10,1762643930,82223,103301,0),
(10,1762643930,82225,103303,1),
(10,1762643930,91044,112967,1),
(10,1762643931,82218,103296,0),
(10,1762643931,82220,103298,0),
(10,1762643931,82223,103301,0),
(10,1762643932,82205,103283,0),
(10,1762643932,82217,103295,0),
(10,1762643932,82241,103320,0),
(10,1762643932,104084,128590,0),
(11,1762643933,103583,127856,0),
(11,1762643933,103598,127873,0),
(11,1762643934,103583,127856,0),
(11,1762643934,103616,127893,0),
(11,1762643935,103588,127861,0),
(11,1762643935,103598,127873,0),
(12,1762643936,82713,103865,0),
(12,1762643936,82717,103869,0),
(12,1762643937,82717,103869,0),
(12,1762643937,82718,103870,0),
(12,1762643938,82712,103864,0),
(12,1762643938,82713,103865,0),
(13,1762704167,82201,103279,0),
(13,1762704167,82202,103280,0),
(13,1762704167,82208,103286,0),
(13,1762704168,82199,103277,0),
(13,1762704168,82222,103300,0),
(13,1762704168,82223,103301,0),
(13,1762704169,82218,103296,0),
(13,1762704169,82220,103298,0),
(13,1762704169,82223,103301,0),
(13,1762704170,82205,103283,0),
(13,1762704170,82217,103295,0),
(13,1762704170,82241,103320,0),
(13,1762704170,104084,128590,0),
(14,1762820576,93305,115614,0),
(14,1762820576,93312,115621,0),
(14,1762820577,93306,115615,0),
(14,1762820577,93341,115655,0),
(14,1762820578,93304,115613,0),
(14,1762820578,93305,115614,0),
(15,1762833348,62121,80180,0),
(15,1762833349,62119,80178,0),
(15,1762833350,62117,80176,0),
(16,1762833351,81597,102583,0),
(16,1762833351,81600,102587,0),
(16,1762833351,81632,102625,0),
(16,1762833352,81597,102583,0),
(16,1762833352,81600,102587,0),
(16,1762833352,81632,102625,0),
(16,1762833353,81510,102479,0),
(16,1762833353,81600,102587,0),
(16,1762833353,81603,102590,0);
/*!40000 ALTER TABLE `character_trait_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `character_transmog_outfits`
--

DROP TABLE IF EXISTS `character_transmog_outfits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `character_transmog_outfits` (
  `guid` bigint(20) NOT NULL DEFAULT 0,
  `setguid` bigint(20) NOT NULL AUTO_INCREMENT,
  `setindex` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `name` varchar(128) NOT NULL,
  `iconname` varchar(256) NOT NULL,
  `ignore_mask` int(11) NOT NULL DEFAULT 0,
  `appearance0` int(11) NOT NULL DEFAULT 0,
  `appearance1` int(11) NOT NULL DEFAULT 0,
  `appearance2` int(11) NOT NULL DEFAULT 0,
  `appearance3` int(11) NOT NULL DEFAULT 0,
  `appearance4` int(11) NOT NULL DEFAULT 0,
  `appearance5` int(11) NOT NULL DEFAULT 0,
  `appearance6` int(11) NOT NULL DEFAULT 0,
  `appearance7` int(11) NOT NULL DEFAULT 0,
  `appearance8` int(11) NOT NULL DEFAULT 0,
  `appearance9` int(11) NOT NULL DEFAULT 0,
  `appearance10` int(11) NOT NULL DEFAULT 0,
  `appearance11` int(11) NOT NULL DEFAULT 0,
  `appearance12` int(11) NOT NULL DEFAULT 0,
  `appearance13` int(11) NOT NULL DEFAULT 0,
  `appearance14` int(11) NOT NULL DEFAULT 0,
  `appearance15` int(11) NOT NULL DEFAULT 0,
  `appearance16` int(11) NOT NULL DEFAULT 0,
  `appearance17` int(11) NOT NULL DEFAULT 0,
  `appearance18` int(11) NOT NULL DEFAULT 0,
  `mainHandEnchant` int(11) NOT NULL DEFAULT 0,
  `offHandEnchant` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`setguid`),
  UNIQUE KEY `idx_set` (`guid`,`setguid`,`setindex`),
  KEY `Idx_setindex` (`setindex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `character_transmog_outfits`
--

LOCK TABLES `character_transmog_outfits` WRITE;
/*!40000 ALTER TABLE `character_transmog_outfits` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_transmog_outfits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `characters`
--

DROP TABLE IF EXISTS `characters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `characters` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `account` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Account Identifier',
  `name` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `slot` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `race` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `class` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `gender` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `level` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `xp` int(10) unsigned NOT NULL DEFAULT 0,
  `money` bigint(20) unsigned NOT NULL DEFAULT 0,
  `inventorySlots` tinyint(3) unsigned NOT NULL DEFAULT 16,
  `inventoryBagFlags` int(10) unsigned NOT NULL DEFAULT 0,
  `bagSlotFlags1` int(10) unsigned NOT NULL DEFAULT 0,
  `bagSlotFlags2` int(10) unsigned NOT NULL DEFAULT 0,
  `bagSlotFlags3` int(10) unsigned NOT NULL DEFAULT 0,
  `bagSlotFlags4` int(10) unsigned NOT NULL DEFAULT 0,
  `bagSlotFlags5` int(10) unsigned NOT NULL DEFAULT 0,
  `bankSlots` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `bankTabs` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `bankBagFlags` int(10) unsigned NOT NULL DEFAULT 0,
  `restState` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `playerFlags` int(10) unsigned NOT NULL DEFAULT 0,
  `playerFlagsEx` int(10) unsigned NOT NULL DEFAULT 0,
  `position_x` float NOT NULL DEFAULT 0,
  `position_y` float NOT NULL DEFAULT 0,
  `position_z` float NOT NULL DEFAULT 0,
  `map` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Map Identifier',
  `instance_id` int(10) unsigned NOT NULL DEFAULT 0,
  `dungeonDifficulty` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `raidDifficulty` tinyint(3) unsigned NOT NULL DEFAULT 14,
  `legacyRaidDifficulty` tinyint(3) unsigned NOT NULL DEFAULT 3,
  `orientation` float NOT NULL DEFAULT 0,
  `taximask` text NOT NULL,
  `online` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `createTime` bigint(20) NOT NULL DEFAULT 0,
  `createMode` tinyint(4) NOT NULL DEFAULT 0,
  `cinematic` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `totaltime` int(10) unsigned NOT NULL DEFAULT 0,
  `leveltime` int(10) unsigned NOT NULL DEFAULT 0,
  `logout_time` bigint(20) NOT NULL DEFAULT 0,
  `is_logout_resting` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rest_bonus` float NOT NULL DEFAULT 0,
  `resettalents_cost` int(10) unsigned NOT NULL DEFAULT 0,
  `resettalents_time` bigint(20) NOT NULL DEFAULT 0,
  `numRespecs` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `primarySpecialization` int(10) unsigned NOT NULL DEFAULT 0,
  `trans_x` float NOT NULL DEFAULT 0,
  `trans_y` float NOT NULL DEFAULT 0,
  `trans_z` float NOT NULL DEFAULT 0,
  `trans_o` float NOT NULL DEFAULT 0,
  `transguid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `extra_flags` smallint(5) unsigned NOT NULL DEFAULT 0,
  `summonedPetNumber` int(10) unsigned NOT NULL DEFAULT 0,
  `at_login` smallint(5) unsigned NOT NULL DEFAULT 0,
  `zone` smallint(5) unsigned NOT NULL DEFAULT 0,
  `death_expire_time` bigint(20) NOT NULL DEFAULT 0,
  `taxi_path` text DEFAULT NULL,
  `totalKills` int(10) unsigned NOT NULL DEFAULT 0,
  `todayKills` smallint(5) unsigned NOT NULL DEFAULT 0,
  `yesterdayKills` smallint(5) unsigned NOT NULL DEFAULT 0,
  `chosenTitle` int(10) unsigned NOT NULL DEFAULT 0,
  `watchedFaction` int(10) unsigned NOT NULL DEFAULT 0,
  `drunk` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `health` int(10) unsigned NOT NULL DEFAULT 0,
  `power1` int(10) unsigned NOT NULL DEFAULT 0,
  `power2` int(10) unsigned NOT NULL DEFAULT 0,
  `power3` int(10) unsigned NOT NULL DEFAULT 0,
  `power4` int(10) unsigned NOT NULL DEFAULT 0,
  `power5` int(10) unsigned NOT NULL DEFAULT 0,
  `power6` int(10) unsigned NOT NULL DEFAULT 0,
  `power7` int(10) unsigned NOT NULL DEFAULT 0,
  `power8` int(10) unsigned NOT NULL DEFAULT 0,
  `power9` int(10) unsigned NOT NULL DEFAULT 0,
  `power10` int(10) unsigned NOT NULL DEFAULT 0,
  `latency` int(10) unsigned NOT NULL DEFAULT 0,
  `activeTalentGroup` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `lootSpecId` int(10) unsigned NOT NULL DEFAULT 0,
  `exploredZones` longtext DEFAULT NULL,
  `equipmentCache` longtext DEFAULT NULL,
  `knownTitles` longtext DEFAULT NULL,
  `actionBars` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `deleteInfos_Account` int(10) unsigned DEFAULT NULL,
  `deleteInfos_Name` varchar(12) DEFAULT NULL,
  `deleteDate` bigint(20) DEFAULT NULL,
  `honor` int(10) unsigned NOT NULL DEFAULT 0,
  `honorLevel` int(10) unsigned NOT NULL DEFAULT 1,
  `honorRestState` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `honorRestBonus` float NOT NULL DEFAULT 0,
  `lastLoginBuild` int(10) unsigned NOT NULL DEFAULT 0,
  `personalTabardEmblemStyle` int(11) NOT NULL DEFAULT -1,
  `personalTabardEmblemColor` int(11) NOT NULL DEFAULT -1,
  `personalTabardBorderStyle` int(11) NOT NULL DEFAULT -1,
  `personalTabardBorderColor` int(11) NOT NULL DEFAULT -1,
  `personalTabardBackgroundColor` int(11) NOT NULL DEFAULT -1,
  PRIMARY KEY (`guid`),
  UNIQUE KEY `idx_name` (`name`),
  KEY `idx_account` (`account`),
  KEY `idx_online` (`online`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters`
--

LOCK TABLES `characters` WRITE;
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` VALUES
(3,3,'Azar',1,1,2,0,6,2963,6678,16,0,0,0,0,0,0,0,0,0,1,0,0,195.235,-2288.71,80.823,2175,0,1,14,3,2.04551,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762259266,1,1,4063,2647,1762642132,0,407.307,0,0,0,1451,0,0,0,0,0,4,0,0,10424,0,'',0,0,0,0,4294967295,0,194,330,0,0,0,0,0,0,0,0,0,134,4,0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2147483648 1 16384 320 0 8 4194304 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 191628 0 4 0 6 191629 0 4 0 7 191630 0 4 0 8 170773 0 4 0 9 191632 0 4 0 10 191633 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 23109 0 1 0 13 187189 0 4 0 14 18730 0 6 0 0 0 0 0 0 19 677576 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 18 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',15,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(4,8,'Natsume',1,11,8,1,8,3976,6661,16,0,0,0,0,0,0,0,0,0,1,32,0,-3879.1,-11636.4,-137.715,530,0,1,14,3,2.81032,'34 0 0 6 0 0 1 0 0 0 0 48 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762363952,0,1,10330,3066,1762724628,1,555.457,0,0,0,1449,0,0,0,0,0,4,0,0,3557,0,'',0,0,0,0,4294967295,0,190,360,0,0,0,0,0,0,0,0,0,30,4,0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4026531840 536870913 4086378499 1280 0 0 0 0 0 0 0 256 268533760 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 191556 0 1 0 6 191557 0 1 0 7 191558 0 1 0 8 12132 0 1 0 9 191560 0 1 0 10 191561 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 17 5010 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',3,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(6,2,'Oni',1,4,5,1,8,4241,13896,16,0,0,0,0,0,0,0,0,0,1,33,0,9818.54,959.299,1308.8,1,0,1,14,3,0.196883,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762386226,0,1,5333,1756,1762827807,1,4164.1,0,0,0,1452,0,0,0,0,0,4,0,0,141,0,'',0,0,0,0,4294967295,0,222,360,0,0,0,0,0,0,0,0,0,47,4,0,'1216 0 0 0 0 0 268435456 0 0 65536 0 0 0 0 0 0 0 131072 0 16384 0 0 256 0 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 20 28178 0 1 0 6 191563 0 1 0 7 191564 0 1 0 8 191565 0 1 0 9 191566 0 1 0 10 191567 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 23101 0 1 0 17 3405 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',0,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(7,46,'Lorric',1,4,4,0,15,8163,211811,16,0,0,0,0,0,0,0,1,0,1,32,0,9968.8,2622.09,1316.08,1,0,1,14,3,4.93126,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762644896,0,1,22976,1483,1762903033,1,402.427,0,0,0,261,0,0,0,0,0,4,0,0,1657,0,'',0,0,0,0,4294967295,0,652,100,0,0,0,0,0,0,0,0,0,76,2,0,'98240 0 0 0 0 0 268435456 0 0 65536 0 0 0 0 0 8388608 0 131072 0 16384 32 0 16128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 0 0 0 4096 0 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 9536 0 2 0 6 65093 0 2 0 7 683 0 2 0 8 945 0 2 0 9 67027 0 2 0 10 2101 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 23040 0 1 0 13 3550 0 15 0 13 22139 0 15 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 18 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',3,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(8,47,'Midnight',2,1,2,1,14,5838,107231,16,0,0,0,0,0,0,0,0,0,2,16777216,0,-5651.09,-492.71,396.669,0,0,1,14,3,5.66383,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 160 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762646016,0,1,19402,427,1762666648,0,0.253395,0,0,0,70,0,0,0,0,0,4,0,0,1,1762647957,'',0,0,0,0,4294967295,0,528,550,0,0,0,0,0,0,0,0,0,32,2,0,'0 0 0 1619001344 3221487752 15728654 17301536 0 4096 0 0 0 0 0 0 0 0 49232 1073741824 0 6400 66048 0 0 0 64 2048 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 512 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 536870912 0 0 536870912 65682 18874368 0 8388608 0 128 0 0 0 0 0 0 1073741824 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4096 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 67108864 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 10840 0 0 0 5 1727 0 4 0 6 12036 0 4 0 7 68841 0 4 0 8 3533 0 4 0 9 2230 0 4 0 10 68843 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 68792 0 1 0 17 1627 0 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',19,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(10,48,'Niwa',1,4,11,1,15,8082,323661,16,0,0,0,0,0,0,0,1,0,1,16777248,0,10077,2284.85,1332.61,1,0,1,14,3,2.11085,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762649086,0,1,16980,2311,1762869654,1,452.011,0,0,0,103,0,0,0,0,0,4,0,0,1657,0,'',0,0,0,0,4294967295,0,652,595,0,100,0,0,0,0,0,0,0,81,1,0,'131008 0 0 0 0 0 268435456 0 0 65536 0 0 0 0 0 8388608 0 131072 0 16384 32 0 7936 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 0 0 0 4096 0 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 7826 0 2 0 6 3251 0 2 0 7 4265 0 2 0 8 191687 0 2 0 9 67027 0 2 0 10 11876 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 70666 0 1 0 17 1716 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 18 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',3,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(11,47,'Midnightsin',1,11,7,1,7,43,5914,16,0,0,0,0,0,0,0,0,0,2,16777216,0,77.1723,-2134.68,-30.1426,2175,0,1,14,3,2.55417,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762667343,1,1,1578,57,1762802856,0,0.33371,0,0,0,1444,0,0,0,0,0,4,0,0,10424,0,'',0,0,0,0,4294967295,0,184,345,0,0,0,0,0,0,0,0,0,35,4,0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2147483648 1 16384 320 0 8 4194304 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 191729 0 3 0 6 191724 0 3 0 7 191725 0 3 0 8 168558 0 3 0 9 191727 0 3 0 10 191728 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13 187189 0 4 0 14 18730 0 6 0 0 0 0 0 0 19 677576 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 18 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',19,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(12,51,'Kathris',1,4,5,1,7,395,7081,16,0,0,0,0,0,0,0,0,0,2,32,0,9811.46,956.551,1308.79,1,0,1,14,3,0.253633,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762675783,0,1,5900,1026,1762742461,1,0.52565,0,0,0,1452,0,0,0,0,0,4,0,0,141,0,'',0,0,0,0,4294967295,0,208,345,0,0,0,0,0,0,0,0,0,50,4,0,'192 0 0 0 0 0 268435456 0 0 65536 0 0 0 0 0 0 0 131072 0 16384 0 0 10496 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 0 0 0 4096 0 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 191562 0 1 0 6 5838 0 1 0 7 7646 0 1 0 8 191565 0 1 0 9 11108 0 1 0 10 14528 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 70683 0 1 0 21 19782 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',15,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(13,42,'Materia',2,4,11,1,82,0,43223,16,0,0,0,0,0,0,0,0,0,2,32,0,-8451.63,670.194,123.874,0,0,1,14,3,3.91366,'98 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 16 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 2 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762820214,0,1,7688,7399,1762828685,1,0,0,0,0,102,0,0,0,0,0,4,0,0,1519,0,'',0,0,0,0,4294967295,0,1729160,2500000,0,100,0,0,0,0,0,0,0,71,0,102,'61120 536871040 8388608 18688 5 0 268435456 40 0 65536 0 0 0 0 2214600704 8388616 13385728 131072 384 16448 32 536936448 268451072 46080 3254779904 0 0 34113792 0 33 0 0 16384 0 0 0 536870912 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 256 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 512 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2097152 16777256 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 536870912 144 0 671088640 159383552 0 16512 0 0 0 0 0 0 0 64 0 65536 0 0 0 32768 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 67108864 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16384 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1073741824 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8192 0 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 191689 0 2 0 6 191685 0 2 0 7 191686 0 2 0 8 191687 0 2 0 0 0 0 0 0 10 194063 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 17 5010 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 18 0 0 0 0 18 0 0 0 0 18 0 0 0 0 0 0 0 0 0 ','',1,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(14,42,'Spyro',1,52,13,0,10,0,0,16,0,0,0,0,0,0,0,0,0,2,0,0,5819.37,-3030.85,250.084,2570,0,1,14,3,1.40911,'0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762829648,0,1,1040,1040,1762830750,0,0.226636,0,0,0,1465,0,0,0,0,0,0,0,0,13769,0,'',0,0,0,0,4294967295,0,292,400,0,5,0,0,0,0,0,0,0,37,4,0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 33554432 ','1 664393 0 3 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 657319 0 3 0 0 0 0 0 0 7 657321 0 3 0 8 657322 0 3 0 9 657323 0 3 0 10 657324 0 3 0 11 0 0 0 0 11 0 0 0 0 12 0 0 0 0 12 0 0 0 0 16 658244 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 18 0 0 0 0 18 0 0 0 0 18 0 0 0 0 0 0 0 0 0 ','',0,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(15,53,'Assblaster',1,3,8,0,2,340,120,16,0,0,0,0,0,0,0,0,0,2,0,0,-6231.09,328.352,382.953,0,0,1,14,3,4.30712,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762834214,0,1,847,147,1762835081,0,0.00204514,0,0,0,1449,0,0,0,0,0,4,0,0,6176,0,'',0,0,0,0,4294967295,0,114,270,0,0,0,0,0,0,0,0,0,17,4,0,'0 0 0 0 0 0 1048576 0 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 191556 0 1 0 6 191557 0 1 0 7 191558 0 1 0 8 191559 0 1 0 9 191560 0 1 0 10 191561 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 17 472 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',0,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1),
(16,56,'Krys',1,11,2,1,5,2157,3257,16,1,0,0,0,0,0,0,0,0,2,0,0,102.929,-2421.31,90.0738,2175,0,1,14,3,0.643282,'34 0 0 6 0 0 1 0 0 0 0 32 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 16 0 0 0 140 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,1762834846,1,1,1162,208,1762836178,0,0.0685444,0,0,0,1451,0,0,0,0,0,4,0,0,10424,0,'',0,0,0,0,4294967295,0,182,310,0,0,0,0,0,0,0,0,0,70,4,0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2147483648 1 16384 0 0 8 4194304 ','0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5 191628 0 4 0 6 191629 0 4 0 7 191630 0 4 0 8 170773 0 4 0 9 191632 0 4 0 10 191633 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 16 23109 0 1 0 21 5194 0 4 0 14 18730 0 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ','',7,NULL,NULL,NULL,0,1,2,0,110205,-1,-1,-1,-1,-1);
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `corpse`
--

DROP TABLE IF EXISTS `corpse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `corpse` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Character Global Unique Identifier',
  `posX` float NOT NULL DEFAULT 0,
  `posY` float NOT NULL DEFAULT 0,
  `posZ` float NOT NULL DEFAULT 0,
  `orientation` float NOT NULL DEFAULT 0,
  `mapId` smallint(5) unsigned NOT NULL DEFAULT 0 COMMENT 'Map Identifier',
  `displayId` int(10) unsigned NOT NULL DEFAULT 0,
  `itemCache` text NOT NULL,
  `race` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `class` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `gender` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `flags` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `dynFlags` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `time` int(10) unsigned NOT NULL DEFAULT 0,
  `corpseType` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `instanceId` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Instance Identifier',
  PRIMARY KEY (`guid`),
  KEY `idx_type` (`corpseType`),
  KEY `idx_instance` (`instanceId`),
  KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Death System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `corpse`
--

LOCK TABLES `corpse` WRITE;
/*!40000 ALTER TABLE `corpse` DISABLE KEYS */;
/*!40000 ALTER TABLE `corpse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `corpse_customizations`
--

DROP TABLE IF EXISTS `corpse_customizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `corpse_customizations` (
  `ownerGuid` bigint(20) unsigned NOT NULL,
  `chrCustomizationOptionID` int(10) unsigned NOT NULL,
  `chrCustomizationChoiceID` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`ownerGuid`,`chrCustomizationOptionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `corpse_customizations`
--

LOCK TABLES `corpse_customizations` WRITE;
/*!40000 ALTER TABLE `corpse_customizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `corpse_customizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `corpse_phases`
--

DROP TABLE IF EXISTS `corpse_phases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `corpse_phases` (
  `OwnerGuid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `PhaseId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`OwnerGuid`,`PhaseId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `corpse_phases`
--

LOCK TABLES `corpse_phases` WRITE;
/*!40000 ALTER TABLE `corpse_phases` DISABLE KEYS */;
/*!40000 ALTER TABLE `corpse_phases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_event_condition_save`
--

DROP TABLE IF EXISTS `game_event_condition_save`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_event_condition_save` (
  `eventEntry` tinyint(3) unsigned NOT NULL,
  `condition_id` int(10) unsigned NOT NULL DEFAULT 0,
  `done` float DEFAULT 0,
  PRIMARY KEY (`eventEntry`,`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_event_condition_save`
--

LOCK TABLES `game_event_condition_save` WRITE;
/*!40000 ALTER TABLE `game_event_condition_save` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_event_condition_save` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_event_save`
--

DROP TABLE IF EXISTS `game_event_save`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_event_save` (
  `eventEntry` tinyint(3) unsigned NOT NULL,
  `state` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `next_start` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`eventEntry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_event_save`
--

LOCK TABLES `game_event_save` WRITE;
/*!40000 ALTER TABLE `game_event_save` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_event_save` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gm_bug`
--

DROP TABLE IF EXISTS `gm_bug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gm_bug` (
  `id` int(10) unsigned NOT NULL,
  `playerGuid` bigint(20) unsigned NOT NULL,
  `note` text NOT NULL,
  `createTime` bigint(20) NOT NULL DEFAULT 0,
  `mapId` smallint(5) unsigned NOT NULL DEFAULT 0,
  `posX` float NOT NULL DEFAULT 0,
  `posY` float NOT NULL DEFAULT 0,
  `posZ` float NOT NULL DEFAULT 0,
  `facing` float NOT NULL DEFAULT 0,
  `closedBy` bigint(20) NOT NULL DEFAULT 0,
  `assignedTo` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'GUID of admin to whom ticket is assigned',
  `comment` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gm_bug`
--

LOCK TABLES `gm_bug` WRITE;
/*!40000 ALTER TABLE `gm_bug` DISABLE KEYS */;
/*!40000 ALTER TABLE `gm_bug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gm_complaint`
--

DROP TABLE IF EXISTS `gm_complaint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gm_complaint` (
  `id` int(10) unsigned NOT NULL,
  `playerGuid` bigint(20) unsigned NOT NULL,
  `note` text NOT NULL,
  `createTime` bigint(20) NOT NULL DEFAULT 0,
  `mapId` smallint(5) unsigned NOT NULL DEFAULT 0,
  `posX` float NOT NULL DEFAULT 0,
  `posY` float NOT NULL DEFAULT 0,
  `posZ` float NOT NULL DEFAULT 0,
  `facing` float NOT NULL DEFAULT 0,
  `targetCharacterGuid` bigint(20) unsigned NOT NULL,
  `reportType` int(11) NOT NULL DEFAULT 0,
  `reportMajorCategory` int(11) NOT NULL DEFAULT 0,
  `reportMinorCategoryFlags` int(11) NOT NULL DEFAULT 0,
  `reportLineIndex` int(11) NOT NULL,
  `closedBy` bigint(20) NOT NULL DEFAULT 0,
  `assignedTo` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'GUID of admin to whom ticket is assigned',
  `comment` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gm_complaint`
--

LOCK TABLES `gm_complaint` WRITE;
/*!40000 ALTER TABLE `gm_complaint` DISABLE KEYS */;
/*!40000 ALTER TABLE `gm_complaint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gm_complaint_chatlog`
--

DROP TABLE IF EXISTS `gm_complaint_chatlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gm_complaint_chatlog` (
  `complaintId` int(10) unsigned NOT NULL,
  `lineId` int(10) unsigned NOT NULL,
  `timestamp` bigint(20) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`complaintId`,`lineId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gm_complaint_chatlog`
--

LOCK TABLES `gm_complaint_chatlog` WRITE;
/*!40000 ALTER TABLE `gm_complaint_chatlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `gm_complaint_chatlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gm_suggestion`
--

DROP TABLE IF EXISTS `gm_suggestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gm_suggestion` (
  `id` int(10) unsigned NOT NULL,
  `playerGuid` bigint(20) unsigned NOT NULL,
  `note` text NOT NULL,
  `createTime` bigint(20) NOT NULL DEFAULT 0,
  `mapId` smallint(5) unsigned NOT NULL DEFAULT 0,
  `posX` float NOT NULL DEFAULT 0,
  `posY` float NOT NULL DEFAULT 0,
  `posZ` float NOT NULL DEFAULT 0,
  `facing` float NOT NULL DEFAULT 0,
  `closedBy` bigint(20) NOT NULL DEFAULT 0,
  `assignedTo` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'GUID of admin to whom ticket is assigned',
  `comment` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gm_suggestion`
--

LOCK TABLES `gm_suggestion` WRITE;
/*!40000 ALTER TABLE `gm_suggestion` DISABLE KEYS */;
/*!40000 ALTER TABLE `gm_suggestion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_member`
--

DROP TABLE IF EXISTS `group_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_member` (
  `guid` int(10) unsigned NOT NULL,
  `memberGuid` bigint(20) unsigned NOT NULL,
  `memberFlags` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `subgroup` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `roles` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`memberGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_member`
--

LOCK TABLES `group_member` WRITE;
/*!40000 ALTER TABLE `group_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups` (
  `guid` int(10) unsigned NOT NULL,
  `leaderGuid` bigint(20) unsigned NOT NULL,
  `lootMethod` tinyint(3) unsigned NOT NULL,
  `looterGuid` bigint(20) unsigned NOT NULL,
  `lootThreshold` tinyint(3) unsigned NOT NULL,
  `icon1` binary(16) NOT NULL,
  `icon2` binary(16) NOT NULL,
  `icon3` binary(16) NOT NULL,
  `icon4` binary(16) NOT NULL,
  `icon5` binary(16) NOT NULL,
  `icon6` binary(16) NOT NULL,
  `icon7` binary(16) NOT NULL,
  `icon8` binary(16) NOT NULL,
  `groupType` smallint(5) unsigned NOT NULL,
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `raidDifficulty` tinyint(3) unsigned NOT NULL DEFAULT 14,
  `legacyRaidDifficulty` tinyint(3) unsigned NOT NULL DEFAULT 3,
  `masterLooterGuid` bigint(20) unsigned NOT NULL,
  `pingRestriction` tinyint(4) NOT NULL,
  PRIMARY KEY (`guid`),
  KEY `leaderGuid` (`leaderGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild`
--

DROP TABLE IF EXISTS `guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild` (
  `guildid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `name` varchar(24) NOT NULL DEFAULT '',
  `leaderguid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `EmblemStyle` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `EmblemColor` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `BorderStyle` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `BorderColor` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `BackgroundColor` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `info` varchar(500) NOT NULL DEFAULT '',
  `motd` varchar(256) NOT NULL DEFAULT '',
  `createdate` int(10) unsigned NOT NULL DEFAULT 0,
  `BankMoney` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Guild System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild`
--

LOCK TABLES `guild` WRITE;
/*!40000 ALTER TABLE `guild` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_achievement`
--

DROP TABLE IF EXISTS `guild_achievement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_achievement` (
  `guildId` bigint(20) unsigned NOT NULL,
  `achievement` int(10) unsigned NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT 0,
  `guids` text NOT NULL,
  PRIMARY KEY (`guildId`,`achievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_achievement`
--

LOCK TABLES `guild_achievement` WRITE;
/*!40000 ALTER TABLE `guild_achievement` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_achievement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_achievement_progress`
--

DROP TABLE IF EXISTS `guild_achievement_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_achievement_progress` (
  `guildId` bigint(20) unsigned NOT NULL,
  `criteria` int(10) unsigned NOT NULL,
  `counter` bigint(20) unsigned NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT 0,
  `completedGuid` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guildId`,`criteria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_achievement_progress`
--

LOCK TABLES `guild_achievement_progress` WRITE;
/*!40000 ALTER TABLE `guild_achievement_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_achievement_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_bank_eventlog`
--

DROP TABLE IF EXISTS `guild_bank_eventlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_bank_eventlog` (
  `guildid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Guild Identificator',
  `LogGuid` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Log record identificator - auxiliary column',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Guild bank TabId',
  `EventType` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Event type',
  `PlayerGuid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ItemOrMoney` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ItemStackCount` smallint(5) unsigned NOT NULL DEFAULT 0,
  `DestTabId` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Destination Tab Id',
  `TimeStamp` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`,`TabId`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_PlayerGuid` (`PlayerGuid`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_bank_eventlog`
--

LOCK TABLES `guild_bank_eventlog` WRITE;
/*!40000 ALTER TABLE `guild_bank_eventlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_bank_eventlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_bank_item`
--

DROP TABLE IF EXISTS `guild_bank_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_bank_item` (
  `guildid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `SlotId` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `item_guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guildid`,`TabId`,`SlotId`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_item_guid` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_bank_item`
--

LOCK TABLES `guild_bank_item` WRITE;
/*!40000 ALTER TABLE `guild_bank_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_bank_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_bank_right`
--

DROP TABLE IF EXISTS `guild_bank_right`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_bank_right` (
  `guildid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rid` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `gbright` tinyint(4) NOT NULL DEFAULT 0,
  `SlotPerDay` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guildid`,`TabId`,`rid`),
  KEY `guildid_key` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_bank_right`
--

LOCK TABLES `guild_bank_right` WRITE;
/*!40000 ALTER TABLE `guild_bank_right` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_bank_right` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_bank_tab`
--

DROP TABLE IF EXISTS `guild_bank_tab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_bank_tab` (
  `guildid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `TabName` varchar(16) NOT NULL DEFAULT '',
  `TabIcon` varchar(100) NOT NULL DEFAULT '',
  `TabText` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`guildid`,`TabId`),
  KEY `guildid_key` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_bank_tab`
--

LOCK TABLES `guild_bank_tab` WRITE;
/*!40000 ALTER TABLE `guild_bank_tab` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_bank_tab` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_eventlog`
--

DROP TABLE IF EXISTS `guild_eventlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_eventlog` (
  `guildid` bigint(20) unsigned NOT NULL COMMENT 'Guild Identificator',
  `LogGuid` int(10) unsigned NOT NULL COMMENT 'Log record identificator - auxiliary column',
  `EventType` tinyint(3) unsigned NOT NULL COMMENT 'Event type',
  `PlayerGuid1` bigint(20) unsigned NOT NULL COMMENT 'Player 1',
  `PlayerGuid2` bigint(20) unsigned NOT NULL COMMENT 'Player 2',
  `NewRank` tinyint(3) unsigned NOT NULL COMMENT 'New rank(in case promotion/demotion)',
  `TimeStamp` bigint(20) NOT NULL COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`),
  KEY `Idx_PlayerGuid1` (`PlayerGuid1`),
  KEY `Idx_PlayerGuid2` (`PlayerGuid2`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Guild Eventlog';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_eventlog`
--

LOCK TABLES `guild_eventlog` WRITE;
/*!40000 ALTER TABLE `guild_eventlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_eventlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_member`
--

DROP TABLE IF EXISTS `guild_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_member` (
  `guildid` bigint(20) unsigned NOT NULL COMMENT 'Guild Identificator',
  `guid` bigint(20) unsigned NOT NULL,
  `rank` tinyint(3) unsigned NOT NULL,
  `pnote` varchar(31) NOT NULL DEFAULT '',
  `offnote` varchar(31) NOT NULL DEFAULT '',
  UNIQUE KEY `guid_key` (`guid`),
  KEY `guildid_key` (`guildid`),
  KEY `guildid_rank_key` (`guildid`,`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Guild System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_member`
--

LOCK TABLES `guild_member` WRITE;
/*!40000 ALTER TABLE `guild_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_member_withdraw`
--

DROP TABLE IF EXISTS `guild_member_withdraw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_member_withdraw` (
  `guid` bigint(20) unsigned NOT NULL,
  `tab0` int(10) unsigned NOT NULL DEFAULT 0,
  `tab1` int(10) unsigned NOT NULL DEFAULT 0,
  `tab2` int(10) unsigned NOT NULL DEFAULT 0,
  `tab3` int(10) unsigned NOT NULL DEFAULT 0,
  `tab4` int(10) unsigned NOT NULL DEFAULT 0,
  `tab5` int(10) unsigned NOT NULL DEFAULT 0,
  `tab6` int(10) unsigned NOT NULL DEFAULT 0,
  `tab7` int(10) unsigned NOT NULL DEFAULT 0,
  `money` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Guild Member Daily Withdraws';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_member_withdraw`
--

LOCK TABLES `guild_member_withdraw` WRITE;
/*!40000 ALTER TABLE `guild_member_withdraw` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_member_withdraw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_newslog`
--

DROP TABLE IF EXISTS `guild_newslog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_newslog` (
  `guildid` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Guild Identificator',
  `LogGuid` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Log record identificator - auxiliary column',
  `EventType` tinyint(3) unsigned NOT NULL DEFAULT 0 COMMENT 'Event type',
  `PlayerGuid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `Flags` int(10) unsigned NOT NULL DEFAULT 0,
  `Value` int(10) unsigned NOT NULL DEFAULT 0,
  `TimeStamp` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_PlayerGuid` (`PlayerGuid`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_newslog`
--

LOCK TABLES `guild_newslog` WRITE;
/*!40000 ALTER TABLE `guild_newslog` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_newslog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guild_rank`
--

DROP TABLE IF EXISTS `guild_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `guild_rank` (
  `guildid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `rid` tinyint(3) unsigned NOT NULL,
  `RankOrder` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rname` varchar(20) NOT NULL DEFAULT '',
  `rights` int(10) unsigned NOT NULL DEFAULT 0,
  `BankMoneyPerDay` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guildid`,`rid`),
  KEY `Idx_rid` (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Guild System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guild_rank`
--

LOCK TABLES `guild_rank` WRITE;
/*!40000 ALTER TABLE `guild_rank` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instance`
--

DROP TABLE IF EXISTS `instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance` (
  `instanceId` int(10) unsigned NOT NULL,
  `data` text DEFAULT NULL,
  `completedEncountersMask` int(10) unsigned DEFAULT NULL,
  `entranceWorldSafeLocId` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instance`
--

LOCK TABLES `instance` WRITE;
/*!40000 ALTER TABLE `instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance`
--

DROP TABLE IF EXISTS `item_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `itemEntry` int(10) unsigned NOT NULL DEFAULT 0,
  `owner_guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `creatorGuid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `giftCreatorGuid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `count` int(10) unsigned NOT NULL DEFAULT 1,
  `duration` int(11) NOT NULL DEFAULT 0,
  `charges` tinytext DEFAULT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT 0,
  `enchantments` text NOT NULL,
  `randomBonusListId` int(10) unsigned NOT NULL DEFAULT 0,
  `durability` smallint(5) unsigned NOT NULL DEFAULT 0,
  `playedTime` int(10) unsigned NOT NULL DEFAULT 0,
  `createTime` bigint(20) NOT NULL DEFAULT 0,
  `text` text DEFAULT NULL,
  `battlePetSpeciesId` int(10) unsigned NOT NULL DEFAULT 0,
  `battlePetBreedData` int(10) unsigned NOT NULL DEFAULT 0,
  `battlePetLevel` smallint(5) unsigned NOT NULL DEFAULT 0,
  `battlePetDisplayId` int(10) unsigned NOT NULL DEFAULT 0,
  `context` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `bonusListIDs` text DEFAULT NULL,
  PRIMARY KEY (`guid`),
  KEY `idx_owner_guid` (`owner_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Item System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance`
--

LOCK TABLES `item_instance` WRITE;
/*!40000 ALTER TABLE `item_instance` DISABLE KEYS */;
INSERT INTO `item_instance` VALUES
(64,2362,3,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762259266,'',0,0,0,0,75,''),
(66,187722,3,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,0,1762259266,'',0,0,0,0,75,''),
(68,187725,3,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762259266,'',0,0,0,0,75,''),
(70,187724,3,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762259266,'',0,0,0,0,75,''),
(72,187726,3,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762259266,'',0,0,0,0,75,''),
(74,187723,3,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762259266,'',0,0,0,0,75,''),
(83,174780,3,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,553,0,'',0,0,0,0,11,''),
(91,117,3,0,0,4,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,740,1762260027,'',0,0,0,0,11,''),
(95,11847,3,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1117,1762260404,'',0,0,0,0,0,'6713 '),
(99,175180,3,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,30,1232,1762260519,'',0,0,0,0,11,'6500 '),
(101,176398,3,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1491,0,'',0,0,0,0,0,''),
(102,175173,3,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,1522,1762260809,'',0,0,0,0,11,'6500 '),
(103,168100,3,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2692,1762262032,'',0,0,0,0,14,''),
(104,175239,3,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2719,0,'',0,0,0,0,11,''),
(106,3661,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762363952,'',0,0,0,0,75,''),
(108,6948,4,0,0,1,0,'0 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762363952,'',0,0,0,0,75,''),
(110,187762,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762363952,'',0,0,0,0,75,''),
(112,187761,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,0,1762363952,'',0,0,0,0,75,''),
(114,187760,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762363952,'',0,0,0,0,75,''),
(116,187759,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,0,1762363952,'',0,0,0,0,75,''),
(118,187758,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762363952,'',0,0,0,0,75,''),
(120,187757,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762363952,'',0,0,0,0,75,''),
(121,24130,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,850,1762364814,'',0,0,0,0,11,'6713 '),
(123,23389,4,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1350,0,'',0,0,0,0,11,''),
(145,6889,4,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4299,1762369674,'',0,0,0,0,0,''),
(146,1430,4,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,4487,1762369862,'',0,0,0,0,0,'6656 '),
(147,8178,4,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,45,4488,1762369863,'',0,0,0,0,0,'6655 '),
(148,2070,4,0,0,1,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4490,1762369865,'',0,0,0,0,0,''),
(149,2770,4,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4491,1762369866,'',0,0,0,0,0,''),
(150,6256,4,0,0,1,0,'0 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4561,1762369936,'',0,0,0,0,11,''),
(151,6529,4,0,0,1,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4561,1762369936,'',0,0,0,0,11,''),
(153,23818,4,0,0,1,0,'-1 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4735,1762370110,'',0,0,0,0,0,''),
(157,6948,6,0,0,1,0,'0 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762386226,'',0,0,0,0,75,''),
(159,187768,6,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762386226,'',0,0,0,0,75,''),
(163,187766,6,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762386226,'',0,0,0,0,75,''),
(165,187765,6,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,0,1762386226,'',0,0,0,0,75,''),
(167,187764,6,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762386226,'',0,0,0,0,75,''),
(169,187763,6,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762386226,'',0,0,0,0,75,''),
(182,2589,6,0,0,24,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,257,1762386515,'',0,0,0,0,0,''),
(191,46753,6,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,401,0,'',0,0,0,0,11,''),
(196,1288,6,0,0,7,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,794,1762387052,'',0,0,0,0,0,''),
(210,5393,6,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,1119,1762387383,'',0,0,0,0,11,'6713 '),
(229,11189,6,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,1744,1762388008,'',0,0,0,0,11,'6713 '),
(235,6889,6,0,0,3,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2235,1762388499,'',0,0,0,0,0,''),
(237,159,6,0,0,8,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2284,1762388548,'',0,0,0,0,11,''),
(244,3013,6,0,0,1,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2924,1762389188,'',0,0,0,0,0,''),
(256,1376,6,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3398,1762389662,'',0,0,0,0,0,'6656 '),
(259,60239,6,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3515,0,'',0,0,0,0,11,''),
(260,159,4,0,0,5,0,'-1 ',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,5289,1762400392,'',0,0,0,0,11,''),
(267,24144,4,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,6806,1762401909,'',0,0,0,0,11,'6713 '),
(269,26012,4,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,7264,1762402367,'',0,0,0,0,11,'4790 '),
(275,6948,7,0,0,1,0,'0 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762644896,'',0,0,0,0,75,''),
(303,46753,7,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,473,0,'',0,0,0,0,11,''),
(304,961,7,0,0,2,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,478,1762645413,'',0,0,0,0,11,''),
(315,6948,8,0,0,1,0,'0 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762646016,'',0,0,0,0,75,''),
(407,57247,8,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1738,0,'',0,0,0,0,11,''),
(408,11475,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1738,1762647839,'',0,0,0,0,11,'6713 '),
(410,5580,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,35,1984,1762648085,'',0,0,0,0,11,'6713 '),
(412,6078,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,2705,1762648806,'',0,0,0,0,11,'6713 '),
(414,159,8,0,0,20,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2754,1762648855,'',0,0,0,0,11,''),
(421,6948,10,0,0,1,0,'0 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762649086,'',0,0,0,0,75,''),
(423,187778,10,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,13,0,1762649086,'',0,0,0,0,75,''),
(442,46753,10,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,494,0,'',0,0,0,0,11,''),
(443,3013,8,0,0,3,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3527,1762649628,'',0,0,0,0,0,''),
(468,5393,10,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,17,1046,1762650150,'',0,0,0,0,11,'6713 '),
(469,1181,8,0,0,5,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4063,1762650164,'',0,0,0,0,0,''),
(497,6058,10,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,9,1388,1762650492,'',0,0,0,0,11,'6713 '),
(512,4907,10,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,27,1683,1762650787,'',0,0,0,0,11,'6713 '),
(537,60239,10,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2241,0,'',0,0,0,0,11,''),
(538,159,10,0,0,6,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2301,1762651405,'',0,0,0,0,11,''),
(611,57248,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,45,11027,1762657502,'',0,0,0,0,11,'4790 '),
(613,57525,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,60,11029,1762657504,'',0,0,0,0,11,'4790 '),
(618,57251,8,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,11246,0,'',0,0,0,0,11,''),
(619,1360,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,11246,1762657721,'',0,0,0,0,11,'4790 '),
(620,2575,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,11260,1762657735,'',0,0,0,0,11,''),
(621,57406,8,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,11260,1762657735,'',0,0,0,0,11,'4790 '),
(629,159,8,0,0,7,0,'-1 ',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,11546,1762658021,'',0,0,0,0,0,''),
(632,57520,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,11621,1762658096,'',0,0,0,0,11,'4790 '),
(648,57527,8,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,30,12364,1762658840,'',0,0,0,0,11,'4790 '),
(649,6084,8,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,45,12431,1762658906,'',0,0,0,0,11,'4790 '),
(650,7005,10,0,0,1,0,'0 0 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3211,1762662457,'',0,0,0,0,14,''),
(651,2901,10,0,0,1,0,'0 0 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3214,1762662460,'',0,0,0,0,14,''),
(654,2589,10,0,0,71,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3889,1762663135,'',0,0,0,0,0,''),
(655,774,10,0,0,5,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3890,1762663136,'',0,0,0,0,0,''),
(666,2318,10,0,0,5,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,5081,1762664327,'',0,0,0,0,0,''),
(677,5419,10,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,18,5889,1762665135,'',0,0,0,0,11,'6713 '),
(679,2889,8,0,0,1,0,'-1 0 ',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,18001,1762665246,'',0,0,0,0,11,''),
(694,15475,10,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,6661,1762665907,'',0,0,0,0,0,''),
(704,57546,8,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,19370,1762666615,'',0,0,0,0,11,'6713 '),
(705,56009,8,0,0,1,0,'0 ',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,19375,1762666620,'',0,0,0,0,0,''),
(713,818,10,0,0,2,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,7394,1762666640,'',0,0,0,0,0,''),
(754,2362,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,36,0,1762667343,'',0,0,0,0,75,''),
(756,187721,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,18,0,1762667343,'',0,0,0,0,75,''),
(760,187719,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,18,0,1762667343,'',0,0,0,0,75,''),
(762,187718,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,18,0,1762667343,'',0,0,0,0,75,''),
(764,187717,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,36,0,1762667343,'',0,0,0,0,75,''),
(766,187716,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,50,0,1762667343,'',0,0,0,0,75,''),
(779,174780,11,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,264,0,'',0,0,0,0,11,''),
(781,117,11,0,0,4,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,401,1762667757,'',0,0,0,0,11,''),
(786,175182,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,30,742,1762668098,'',0,0,0,0,11,'6500 '),
(788,176398,11,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1001,0,'',0,0,0,0,0,''),
(789,175173,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,1021,1762668377,'',0,0,0,0,11,'6500 '),
(790,168100,11,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1063,1762668419,'',0,0,0,0,14,''),
(791,175239,11,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1084,0,'',0,0,0,0,11,''),
(792,60240,10,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,9451,0,'',0,0,0,0,11,''),
(795,3661,12,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762675783,'',0,0,0,0,75,''),
(797,6948,12,0,0,1,0,'0 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762675783,'',0,0,0,0,75,''),
(801,187767,12,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,54,0,1762675783,'',0,0,0,0,75,''),
(805,187765,12,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,0,1762675783,'',0,0,0,0,75,''),
(810,11187,12,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,133,1762675950,'',0,0,0,0,11,'6713 '),
(816,3370,12,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,227,1762676044,'',0,0,0,0,0,'6656 '),
(818,11190,12,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,275,1762676092,'',0,0,0,0,11,'6713 '),
(819,46753,12,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,395,0,'',0,0,0,0,11,''),
(820,10655,12,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,530,1762676347,'',0,0,0,0,11,'6713 '),
(831,24132,4,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762722487,'',0,0,0,0,0,''),
(832,24318,4,0,0,1,0,'-1 ',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,8213,1762722511,'',0,0,0,0,0,''),
(835,26006,4,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,45,8516,1762722814,'',0,0,0,0,11,'4790 '),
(836,32714,12,0,0,6,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2900,1762739461,'',0,0,0,0,0,''),
(837,7101,12,0,0,20,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2912,1762739473,'',0,0,0,0,0,''),
(841,1288,12,0,0,10,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,2990,1762739551,'',0,0,0,0,0,''),
(848,10544,12,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,35,3426,1762739987,'',0,0,0,0,11,'6713 '),
(865,7101,12,0,0,7,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3799,1762740360,'',0,0,0,0,0,''),
(869,1417,12,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,45,3998,1762740559,'',0,0,0,0,0,'6657 '),
(881,5405,12,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4291,1762740852,'',0,0,0,0,11,'6713 '),
(884,11189,12,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,4679,1762741240,'',0,0,0,0,11,'6713 '),
(886,5619,12,0,0,1,0,'-1 ',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,5869,1762742430,'',0,0,0,0,0,''),
(890,5465,7,0,0,10,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3550,1762815465,'',0,0,0,0,0,''),
(906,5457,7,0,0,4,0,'-1 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3959,1762815874,'',0,0,0,0,11,''),
(907,60239,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3959,0,'',0,0,0,0,11,''),
(914,159,7,0,0,7,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4736,1762816651,'',0,0,0,0,0,''),
(926,5419,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,6583,1762818498,'',0,0,0,0,11,'6713 '),
(929,6888,7,0,0,3,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,7014,1762818929,'',0,0,0,0,13,''),
(937,4536,7,0,0,15,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,7380,1762819295,'',0,0,0,0,0,''),
(941,3013,7,0,0,2,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,7532,1762819447,'',0,0,0,0,0,''),
(943,3661,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762820214,'',0,0,0,0,75,''),
(945,6948,13,0,0,1,0,'0 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762820214,'',0,0,0,0,75,''),
(947,187778,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,0,1762820214,'',0,0,0,0,75,''),
(949,187777,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762820214,'',0,0,0,0,75,''),
(951,187776,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762820214,'',0,0,0,0,75,''),
(953,187775,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,0,1762820214,'',0,0,0,0,75,''),
(955,187774,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762820214,'',0,0,0,0,75,''),
(956,5394,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,173,1762820415,'',0,0,0,0,11,'6713 '),
(958,21876,13,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,3824,0,'',0,0,0,0,0,''),
(959,21876,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,0,''),
(960,21876,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,0,''),
(961,21876,13,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,0,''),
(963,961,13,0,0,3,0,'-1 ',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4132,1762825129,'',0,0,0,0,11,''),
(964,5398,13,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,4132,1762825129,'',0,0,0,0,11,'6713 '),
(965,46753,13,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4374,0,'',0,0,0,0,11,''),
(966,5393,13,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,4537,1762825534,'',0,0,0,0,11,'6713 '),
(967,5405,13,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,4555,1762825552,'',0,0,0,0,11,'6713 '),
(970,4907,13,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,4810,1762825807,'',0,0,0,0,11,'6713 '),
(973,5863,13,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,5888,1762826885,'',0,0,0,0,0,''),
(979,14091,6,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,60,4944,1762827418,'',0,0,0,0,0,'6654 '),
(988,118,6,0,0,1,0,'-1 ',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,5057,1762827531,'',0,0,0,0,0,''),
(991,46716,6,0,0,1,0,'0 ',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,5205,1762827679,'',0,0,0,0,0,''),
(993,188213,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,75,''),
(995,188812,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762829648,'',0,0,0,0,75,'11083 '),
(997,188813,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762829648,'',0,0,0,0,75,'11083 '),
(999,188814,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762829648,'',0,0,0,0,75,'11083 '),
(1001,188815,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762829648,'',0,0,0,0,75,'11083 '),
(1003,188816,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762829648,'',0,0,0,0,75,'11083 '),
(1005,188817,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762829648,'',0,0,0,0,75,'11083 '),
(1007,188819,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,85,0,1762829648,'',0,0,0,0,75,'11083 '),
(1009,188820,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,70,0,1762829648,'',0,0,0,0,75,'11083 '),
(1011,188821,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762829648,'',0,0,0,0,75,'11083 '),
(1013,188822,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,115,0,1762829648,'',0,0,0,0,75,'11083 '),
(1015,188823,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762829648,'',0,0,0,0,75,'11083 '),
(1017,188824,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,0,1762829648,'',0,0,0,0,75,'11083 '),
(1019,188213,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,75,''),
(1021,188213,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,75,''),
(1023,188213,14,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,75,''),
(1025,6948,14,0,0,1,0,'0 ',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762829648,'',0,0,0,0,75,''),
(1026,4604,7,0,0,10,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,9260,1762830575,'',0,0,0,0,11,''),
(1062,15010,7,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,60,10916,1762832231,'',0,0,0,0,0,'6654 '),
(1063,774,7,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,10917,1762832232,'',0,0,0,0,0,''),
(1086,35,15,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762834214,'',0,0,0,0,75,''),
(1088,6948,15,0,0,1,0,'0 ',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,1762834214,'',0,0,0,0,75,''),
(1090,187762,15,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762834214,'',0,0,0,0,75,''),
(1092,187761,15,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,0,1762834214,'',0,0,0,0,75,''),
(1094,187760,15,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762834214,'',0,0,0,0,75,''),
(1096,187759,15,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,0,1762834214,'',0,0,0,0,75,''),
(1098,187758,15,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762834214,'',0,0,0,0,75,''),
(1100,187757,15,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762834214,'',0,0,0,0,75,''),
(1107,6342,7,0,0,1,0,'-1 0 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,12891,1762834548,'',0,0,0,0,0,''),
(1116,36,16,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,35,0,1762834846,'',0,0,0,0,75,''),
(1120,2362,16,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762834846,'',0,0,0,0,75,''),
(1122,187722,16,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,55,0,1762834846,'',0,0,0,0,75,''),
(1124,187725,16,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762834846,'',0,0,0,0,75,''),
(1126,187724,16,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762834846,'',0,0,0,0,75,''),
(1128,187726,16,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,0,1762834846,'',0,0,0,0,75,''),
(1130,187723,16,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,0,1762834846,'',0,0,0,0,75,''),
(1132,187727,16,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,0,1762834846,'',0,0,0,0,75,''),
(1136,66922,15,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,705,1762834938,'',0,0,0,0,11,'6713 '),
(1141,174794,16,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,30,413,1762835347,'',0,0,0,0,0,'6499 '),
(1143,174780,16,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,478,0,'',0,0,0,0,11,''),
(1144,4865,16,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,528,1762835462,'',0,0,0,0,0,''),
(1145,5118,16,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,528,1762835462,'',0,0,0,0,0,''),
(1146,3299,16,0,0,3,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,535,1762835469,'',0,0,0,0,0,''),
(1149,117,16,0,0,4,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,569,1762835503,'',0,0,0,0,11,''),
(1150,1367,16,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,916,1762835931,'',0,0,0,0,0,'6656 '),
(1151,1370,16,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,941,1762835956,'',0,0,0,0,0,'6656 '),
(1152,174814,16,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,60,941,1762835956,'',0,0,0,0,0,'6499 '),
(1153,2652,16,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,941,1762835956,'',0,0,0,0,0,'6656 '),
(1154,771,16,0,0,2,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,985,1762836000,'',0,0,0,0,0,''),
(1155,11847,16,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,999,1762836014,'',0,0,0,0,0,'6713 '),
(1156,174790,16,0,0,1,0,'',2097152,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,999,1762836014,'',0,0,0,0,0,''),
(1158,175180,16,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,30,1045,1762836060,'',0,0,0,0,11,'6500 '),
(1159,170557,16,0,0,1,0,'0 ',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,1141,1762836156,'',0,0,0,0,0,''),
(1161,242709,7,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,0,''),
(1162,2209,7,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,15055,1762836712,'',0,0,0,0,14,''),
(1163,2209,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,40,15056,1762836713,'',0,0,0,0,14,''),
(1165,118,7,0,0,2,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,15509,1762837166,'',0,0,0,0,13,''),
(1166,2454,7,0,0,3,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,15512,1762837169,'',0,0,0,0,13,''),
(1167,5997,7,0,0,8,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,15514,1762837171,'',0,0,0,0,13,''),
(1182,765,7,0,0,5,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,16212,1762837869,'',0,0,0,0,0,''),
(1214,9755,10,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,18,11107,1762843361,'',0,0,0,0,0,''),
(1247,54872,10,0,0,1,0,'',1,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,45,14178,1762846432,'',0,0,0,0,11,'4790 '),
(1251,156992,10,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,45,14910,1762847164,'',0,0,0,0,11,'4790 '),
(1254,242709,10,0,0,1,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,0,0,'',0,0,0,0,0,''),
(1263,60240,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,17723,0,'',0,0,0,0,11,''),
(1264,54868,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,20,17723,1762880113,'',0,0,0,0,11,'6713 '),
(1275,6555,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,18244,1762880634,'',0,0,0,0,0,''),
(1279,785,7,0,0,5,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,18593,1762880983,'',0,0,0,0,0,''),
(1281,2447,7,0,0,13,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,18712,1762881102,'',0,0,0,0,0,''),
(1298,3382,7,0,0,5,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,20076,1762882466,'',0,0,0,0,13,''),
(1304,3371,7,0,0,33,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,20116,1762882506,'',0,0,0,0,14,''),
(1313,5605,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,30,20895,1762883285,'',0,0,0,0,11,'6713 '),
(1318,2449,7,0,0,6,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,21443,1762883833,'',0,0,0,0,0,''),
(1322,49449,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,45,21527,1762883917,'',0,0,0,0,11,'4790 '),
(1329,2452,7,0,0,2,0,'',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,21739,1762884129,'',0,0,0,0,0,''),
(1330,54874,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,30,21789,1762884179,'',0,0,0,0,11,'4790 '),
(1332,6256,7,0,0,1,0,'0 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,22218,1762884608,'',0,0,0,0,14,''),
(1334,6529,7,0,0,4,0,'-1 ',0,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,0,22223,1762884613,'',0,0,0,0,14,''),
(1338,844,7,0,0,1,0,'',2097153,'0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ',0,25,22590,1762884980,'',0,0,0,0,14,'');
/*!40000 ALTER TABLE `item_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_artifact`
--

DROP TABLE IF EXISTS `item_instance_artifact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_artifact` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `xp` bigint(20) unsigned NOT NULL DEFAULT 0,
  `artifactAppearanceId` int(10) unsigned NOT NULL DEFAULT 0,
  `artifactTierId` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_artifact`
--

LOCK TABLES `item_instance_artifact` WRITE;
/*!40000 ALTER TABLE `item_instance_artifact` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance_artifact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_artifact_powers`
--

DROP TABLE IF EXISTS `item_instance_artifact_powers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_artifact_powers` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `artifactPowerId` int(10) unsigned NOT NULL,
  `purchasedRank` tinyint(3) unsigned DEFAULT 0,
  PRIMARY KEY (`itemGuid`,`artifactPowerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_artifact_powers`
--

LOCK TABLES `item_instance_artifact_powers` WRITE;
/*!40000 ALTER TABLE `item_instance_artifact_powers` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance_artifact_powers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_azerite`
--

DROP TABLE IF EXISTS `item_instance_azerite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_azerite` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `xp` bigint(20) unsigned NOT NULL DEFAULT 0,
  `level` int(10) unsigned NOT NULL DEFAULT 1,
  `knowledgeLevel` int(10) unsigned NOT NULL DEFAULT 0,
  `selectedAzeriteEssences1specId` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences1azeriteEssenceId1` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences1azeriteEssenceId2` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences1azeriteEssenceId3` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences1azeriteEssenceId4` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences2specId` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences2azeriteEssenceId1` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences2azeriteEssenceId2` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences2azeriteEssenceId3` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences2azeriteEssenceId4` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences3specId` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences3azeriteEssenceId1` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences3azeriteEssenceId2` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences3azeriteEssenceId3` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences3azeriteEssenceId4` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences4specId` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences4azeriteEssenceId1` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences4azeriteEssenceId2` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences4azeriteEssenceId3` int(10) unsigned DEFAULT 0,
  `selectedAzeriteEssences4azeriteEssenceId4` int(10) unsigned DEFAULT 0,
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_azerite`
--

LOCK TABLES `item_instance_azerite` WRITE;
/*!40000 ALTER TABLE `item_instance_azerite` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance_azerite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_azerite_empowered`
--

DROP TABLE IF EXISTS `item_instance_azerite_empowered`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_azerite_empowered` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `azeritePowerId1` int(11) NOT NULL,
  `azeritePowerId2` int(11) NOT NULL,
  `azeritePowerId3` int(11) NOT NULL,
  `azeritePowerId4` int(11) NOT NULL,
  `azeritePowerId5` int(11) NOT NULL,
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_azerite_empowered`
--

LOCK TABLES `item_instance_azerite_empowered` WRITE;
/*!40000 ALTER TABLE `item_instance_azerite_empowered` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance_azerite_empowered` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_azerite_milestone_power`
--

DROP TABLE IF EXISTS `item_instance_azerite_milestone_power`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_azerite_milestone_power` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `azeriteItemMilestonePowerId` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`itemGuid`,`azeriteItemMilestonePowerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_azerite_milestone_power`
--

LOCK TABLES `item_instance_azerite_milestone_power` WRITE;
/*!40000 ALTER TABLE `item_instance_azerite_milestone_power` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance_azerite_milestone_power` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_azerite_unlocked_essence`
--

DROP TABLE IF EXISTS `item_instance_azerite_unlocked_essence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_azerite_unlocked_essence` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `azeriteEssenceId` int(10) unsigned NOT NULL DEFAULT 0,
  `rank` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`itemGuid`,`azeriteEssenceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_azerite_unlocked_essence`
--

LOCK TABLES `item_instance_azerite_unlocked_essence` WRITE;
/*!40000 ALTER TABLE `item_instance_azerite_unlocked_essence` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance_azerite_unlocked_essence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_gems`
--

DROP TABLE IF EXISTS `item_instance_gems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_gems` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `gemItemId1` int(10) unsigned NOT NULL DEFAULT 0,
  `gemBonuses1` text DEFAULT NULL,
  `gemContext1` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `gemScalingLevel1` int(10) unsigned NOT NULL DEFAULT 0,
  `gemItemId2` int(10) unsigned NOT NULL DEFAULT 0,
  `gemBonuses2` text DEFAULT NULL,
  `gemContext2` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `gemScalingLevel2` int(10) unsigned NOT NULL DEFAULT 0,
  `gemItemId3` int(10) unsigned NOT NULL DEFAULT 0,
  `gemBonuses3` text DEFAULT NULL,
  `gemContext3` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `gemScalingLevel3` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_gems`
--

LOCK TABLES `item_instance_gems` WRITE;
/*!40000 ALTER TABLE `item_instance_gems` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance_gems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_modifiers`
--

DROP TABLE IF EXISTS `item_instance_modifiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_modifiers` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `fixedScalingLevel` int(10) unsigned DEFAULT 0,
  `artifactKnowledgeLevel` int(10) unsigned DEFAULT 0,
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_modifiers`
--

LOCK TABLES `item_instance_modifiers` WRITE;
/*!40000 ALTER TABLE `item_instance_modifiers` DISABLE KEYS */;
INSERT INTO `item_instance_modifiers` VALUES
(95,5,0),
(99,5,0),
(102,6,0),
(121,2,0),
(146,5,0),
(147,5,0),
(210,4,0),
(229,5,0),
(256,7,0),
(267,7,0),
(269,7,0),
(408,5,0),
(410,5,0),
(412,6,0),
(468,4,0),
(497,5,0),
(512,5,0),
(611,10,0),
(613,10,0),
(619,10,0),
(621,10,0),
(632,11,0),
(648,11,0),
(649,11,0),
(677,9,0),
(704,14,0),
(786,5,0),
(789,6,0),
(810,1,0),
(816,2,0),
(818,2,0),
(820,3,0),
(835,8,0),
(848,5,0),
(869,5,0),
(881,5,0),
(884,6,0),
(926,8,0),
(956,1,0),
(964,82,0),
(966,82,0),
(967,82,0),
(970,82,0),
(979,8,0),
(1062,10,0),
(1136,2,0),
(1141,2,0),
(1150,4,0),
(1151,4,0),
(1152,4,0),
(1153,4,0),
(1155,5,0),
(1158,5,0),
(1247,14,0),
(1251,15,0),
(1264,12,0),
(1313,13,0),
(1322,15,0),
(1330,15,0);
/*!40000 ALTER TABLE `item_instance_modifiers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_instance_transmog`
--

DROP TABLE IF EXISTS `item_instance_transmog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_instance_transmog` (
  `itemGuid` bigint(20) unsigned NOT NULL,
  `itemModifiedAppearanceAllSpecs` int(11) NOT NULL DEFAULT 0,
  `itemModifiedAppearanceSpec1` int(11) NOT NULL DEFAULT 0,
  `itemModifiedAppearanceSpec2` int(11) NOT NULL DEFAULT 0,
  `itemModifiedAppearanceSpec3` int(11) NOT NULL DEFAULT 0,
  `itemModifiedAppearanceSpec4` int(11) NOT NULL DEFAULT 0,
  `itemModifiedAppearanceSpec5` int(11) NOT NULL DEFAULT 0,
  `spellItemEnchantmentAllSpecs` int(11) NOT NULL DEFAULT 0,
  `spellItemEnchantmentSpec1` int(11) NOT NULL DEFAULT 0,
  `spellItemEnchantmentSpec2` int(11) NOT NULL DEFAULT 0,
  `spellItemEnchantmentSpec3` int(11) NOT NULL DEFAULT 0,
  `spellItemEnchantmentSpec4` int(11) NOT NULL DEFAULT 0,
  `spellItemEnchantmentSpec5` int(11) NOT NULL DEFAULT 0,
  `secondaryItemModifiedAppearanceAllSpecs` int(11) NOT NULL DEFAULT 0,
  `secondaryItemModifiedAppearanceSpec1` int(11) NOT NULL DEFAULT 0,
  `secondaryItemModifiedAppearanceSpec2` int(11) NOT NULL DEFAULT 0,
  `secondaryItemModifiedAppearanceSpec3` int(11) NOT NULL DEFAULT 0,
  `secondaryItemModifiedAppearanceSpec4` int(11) NOT NULL DEFAULT 0,
  `secondaryItemModifiedAppearanceSpec5` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_instance_transmog`
--

LOCK TABLES `item_instance_transmog` WRITE;
/*!40000 ALTER TABLE `item_instance_transmog` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance_transmog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_loot_items`
--

DROP TABLE IF EXISTS `item_loot_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_loot_items` (
  `container_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'guid of container (item_instance.guid)',
  `item_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'item or currency',
  `item_id` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'loot item entry (item_instance.itemEntry)',
  `item_count` int(11) NOT NULL DEFAULT 0 COMMENT 'stack size',
  `item_index` int(10) unsigned NOT NULL DEFAULT 0,
  `follow_rules` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'follow loot rules',
  `ffa` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'free-for-all',
  `blocked` tinyint(1) NOT NULL DEFAULT 0,
  `counted` tinyint(1) NOT NULL DEFAULT 0,
  `under_threshold` tinyint(1) NOT NULL DEFAULT 0,
  `needs_quest` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'quest drop',
  `rnd_bonus` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'random bonus list added when originally rolled',
  `context` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `bonus_list_ids` text DEFAULT NULL COMMENT 'Space separated list of bonus list ids',
  PRIMARY KEY (`container_id`,`item_type`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_loot_items`
--

LOCK TABLES `item_loot_items` WRITE;
/*!40000 ALTER TABLE `item_loot_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_loot_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_loot_money`
--

DROP TABLE IF EXISTS `item_loot_money`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_loot_money` (
  `container_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'guid of container (item_instance.guid)',
  `money` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'money loot (in copper)',
  PRIMARY KEY (`container_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_loot_money`
--

LOCK TABLES `item_loot_money` WRITE;
/*!40000 ALTER TABLE `item_loot_money` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_loot_money` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_refund_instance`
--

DROP TABLE IF EXISTS `item_refund_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_refund_instance` (
  `item_guid` bigint(20) unsigned NOT NULL COMMENT 'Item GUID',
  `player_guid` bigint(20) unsigned NOT NULL COMMENT 'Player GUID',
  `paidMoney` bigint(20) unsigned NOT NULL DEFAULT 0,
  `paidExtendedCost` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`item_guid`,`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Item Refund System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_refund_instance`
--

LOCK TABLES `item_refund_instance` WRITE;
/*!40000 ALTER TABLE `item_refund_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_refund_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_soulbound_trade_data`
--

DROP TABLE IF EXISTS `item_soulbound_trade_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_soulbound_trade_data` (
  `itemGuid` bigint(20) unsigned NOT NULL COMMENT 'Item GUID',
  `allowedPlayers` text NOT NULL COMMENT 'Space separated GUID list of players who can receive this item in trade',
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Item Refund System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_soulbound_trade_data`
--

LOCK TABLES `item_soulbound_trade_data` WRITE;
/*!40000 ALTER TABLE `item_soulbound_trade_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_soulbound_trade_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lfg_data`
--

DROP TABLE IF EXISTS `lfg_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lfg_data` (
  `guid` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `dungeon` int(10) unsigned NOT NULL DEFAULT 0,
  `state` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='LFG Data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lfg_data`
--

LOCK TABLES `lfg_data` WRITE;
/*!40000 ALTER TABLE `lfg_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `lfg_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail`
--

DROP TABLE IF EXISTS `mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mail` (
  `id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Identifier',
  `messageType` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `stationery` tinyint(4) NOT NULL DEFAULT 41,
  `mailTemplateId` smallint(5) unsigned NOT NULL DEFAULT 0,
  `sender` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Character Global Unique Identifier',
  `receiver` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Character Global Unique Identifier',
  `subject` longtext DEFAULT NULL,
  `body` longtext DEFAULT NULL,
  `has_items` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `expire_time` bigint(20) NOT NULL DEFAULT 0,
  `deliver_time` bigint(20) NOT NULL DEFAULT 0,
  `money` bigint(20) unsigned NOT NULL DEFAULT 0,
  `cod` bigint(20) unsigned NOT NULL DEFAULT 0,
  `checked` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Mail System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail`
--

LOCK TABLES `mail` WRITE;
/*!40000 ALTER TABLE `mail` DISABLE KEYS */;
INSERT INTO `mail` VALUES
(1,3,41,180,17703,4,'','',1,1765314487,1762722487,0,0,16),
(2,2,62,0,1,7,'6342:0:3:1:1:0:0:0:0:0:0:0:','',1,1765515150,1762923150,0,0,4);
/*!40000 ALTER TABLE `mail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_items`
--

DROP TABLE IF EXISTS `mail_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mail_items` (
  `mail_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `item_guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `receiver` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Character Global Unique Identifier',
  PRIMARY KEY (`item_guid`),
  KEY `idx_receiver` (`receiver`),
  KEY `idx_mail_id` (`mail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_items`
--

LOCK TABLES `mail_items` WRITE;
/*!40000 ALTER TABLE `mail_items` DISABLE KEYS */;
INSERT INTO `mail_items` VALUES
(1,831,4),
(2,1107,7);
/*!40000 ALTER TABLE `mail_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_aura`
--

DROP TABLE IF EXISTS `pet_aura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_aura` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Global Unique Identifier',
  `casterGuid` binary(16) NOT NULL COMMENT 'Full Global Unique Identifier',
  `spell` int(10) unsigned NOT NULL,
  `effectMask` int(10) unsigned NOT NULL,
  `recalculateMask` int(10) unsigned NOT NULL DEFAULT 0,
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `stackCount` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `maxDuration` int(11) NOT NULL DEFAULT 0,
  `remainTime` int(11) NOT NULL DEFAULT 0,
  `remainCharges` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`spell`,`effectMask`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pet System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_aura`
--

LOCK TABLES `pet_aura` WRITE;
/*!40000 ALTER TABLE `pet_aura` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_aura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_aura_effect`
--

DROP TABLE IF EXISTS `pet_aura_effect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_aura_effect` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Global Unique Identifier',
  `casterGuid` binary(16) NOT NULL COMMENT 'Full Global Unique Identifier',
  `spell` int(10) unsigned NOT NULL,
  `effectMask` int(10) unsigned NOT NULL,
  `effectIndex` tinyint(3) unsigned NOT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `baseAmount` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`casterGuid`,`spell`,`effectMask`,`effectIndex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pet System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_aura_effect`
--

LOCK TABLES `pet_aura_effect` WRITE;
/*!40000 ALTER TABLE `pet_aura_effect` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_aura_effect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_spell`
--

DROP TABLE IF EXISTS `pet_spell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_spell` (
  `guid` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier',
  `spell` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Spell Identifier',
  `active` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pet System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_spell`
--

LOCK TABLES `pet_spell` WRITE;
/*!40000 ALTER TABLE `pet_spell` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_spell` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_spell_charges`
--

DROP TABLE IF EXISTS `pet_spell_charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_spell_charges` (
  `guid` int(10) unsigned NOT NULL,
  `categoryId` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'SpellCategory.dbc Identifier',
  `rechargeStart` bigint(20) NOT NULL DEFAULT 0,
  `rechargeEnd` bigint(20) NOT NULL DEFAULT 0,
  KEY `idx_guid` (`guid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_spell_charges`
--

LOCK TABLES `pet_spell_charges` WRITE;
/*!40000 ALTER TABLE `pet_spell_charges` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_spell_charges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pet_spell_cooldown`
--

DROP TABLE IF EXISTS `pet_spell_cooldown`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet_spell_cooldown` (
  `guid` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Global Unique Identifier, Low part',
  `spell` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Spell Identifier',
  `time` bigint(20) NOT NULL DEFAULT 0,
  `categoryId` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Spell category Id',
  `categoryEnd` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet_spell_cooldown`
--

LOCK TABLES `pet_spell_cooldown` WRITE;
/*!40000 ALTER TABLE `pet_spell_cooldown` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_spell_cooldown` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `petition`
--

DROP TABLE IF EXISTS `petition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `petition` (
  `ownerguid` bigint(20) unsigned NOT NULL,
  `petitionguid` bigint(20) unsigned DEFAULT 0,
  `name` varchar(24) NOT NULL,
  PRIMARY KEY (`ownerguid`),
  UNIQUE KEY `index_ownerguid_petitionguid` (`ownerguid`,`petitionguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Guild System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `petition`
--

LOCK TABLES `petition` WRITE;
/*!40000 ALTER TABLE `petition` DISABLE KEYS */;
INSERT INTO `petition` VALUES
(13,973,'De');
/*!40000 ALTER TABLE `petition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `petition_sign`
--

DROP TABLE IF EXISTS `petition_sign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `petition_sign` (
  `ownerguid` bigint(20) unsigned NOT NULL,
  `petitionguid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `playerguid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `player_account` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`petitionguid`,`playerguid`),
  KEY `Idx_playerguid` (`playerguid`),
  KEY `Idx_ownerguid` (`ownerguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Guild System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `petition_sign`
--

LOCK TABLES `petition_sign` WRITE;
/*!40000 ALTER TABLE `petition_sign` DISABLE KEYS */;
/*!40000 ALTER TABLE `petition_sign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pool_quest_save`
--

DROP TABLE IF EXISTS `pool_quest_save`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pool_quest_save` (
  `pool_id` int(10) unsigned NOT NULL DEFAULT 0,
  `quest_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`pool_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pool_quest_save`
--

LOCK TABLES `pool_quest_save` WRITE;
/*!40000 ALTER TABLE `pool_quest_save` DISABLE KEYS */;
INSERT INTO `pool_quest_save` VALUES
(348,24636),
(349,14102),
(350,13905),
(351,13915),
(352,11377),
(353,11667),
(354,13424),
(356,11378),
(357,11385),
(359,12737),
(360,12705),
(361,12732),
(362,12759),
(363,14152),
(364,14076),
(365,14144),
(366,14141),
(367,14108),
(5662,13673),
(5663,13762),
(5664,13769),
(5665,13774),
(5666,13778),
(5667,13783),
(5668,13670),
(5669,13616),
(5670,13741),
(5671,13747),
(5672,13757),
(5673,13753),
(5674,13107),
(5675,13114),
(5676,13833),
(5677,12959),
(5678,24585),
(5707,13198),
(5708,13156),
(5709,13201),
(5710,13191),
(40000,25159),
(40001,25155),
(40002,29358),
(40003,26235),
(40004,29333),
(40005,29343),
(40006,29323),
(40007,28059),
(40007,28130),
(40008,27966),
(40008,27967),
(40009,27973),
(40009,27975),
(40010,27944),
(40010,27948),
(40011,28686),
(40011,28687),
(40012,28680),
(40012,28684),
(40013,28696),
(40013,28700),
(40014,28689),
(40014,28690),
(40015,29357),
(40016,26192),
(40017,26414),
(40018,29352),
(40019,26572),
(40020,29354),
(40021,29319);
/*!40000 ALTER TABLE `pool_quest_save` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pvpstats_battlegrounds`
--

DROP TABLE IF EXISTS `pvpstats_battlegrounds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pvpstats_battlegrounds` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `winner_faction` tinyint(4) NOT NULL,
  `bracket_id` tinyint(3) unsigned NOT NULL,
  `type` int(10) unsigned NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pvpstats_battlegrounds`
--

LOCK TABLES `pvpstats_battlegrounds` WRITE;
/*!40000 ALTER TABLE `pvpstats_battlegrounds` DISABLE KEYS */;
/*!40000 ALTER TABLE `pvpstats_battlegrounds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pvpstats_players`
--

DROP TABLE IF EXISTS `pvpstats_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pvpstats_players` (
  `battleground_id` bigint(20) unsigned NOT NULL,
  `character_guid` bigint(20) unsigned NOT NULL,
  `winner` bit(1) NOT NULL,
  `score_killing_blows` int(10) unsigned NOT NULL,
  `score_deaths` int(10) unsigned NOT NULL,
  `score_honorable_kills` int(10) unsigned NOT NULL,
  `score_bonus_honor` int(10) unsigned NOT NULL,
  `score_damage_done` int(10) unsigned NOT NULL,
  `score_healing_done` int(10) unsigned NOT NULL,
  `attr_1` int(10) unsigned NOT NULL DEFAULT 0,
  `attr_2` int(10) unsigned NOT NULL DEFAULT 0,
  `attr_3` int(10) unsigned NOT NULL DEFAULT 0,
  `attr_4` int(10) unsigned NOT NULL DEFAULT 0,
  `attr_5` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`battleground_id`,`character_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pvpstats_players`
--

LOCK TABLES `pvpstats_players` WRITE;
/*!40000 ALTER TABLE `pvpstats_players` DISABLE KEYS */;
/*!40000 ALTER TABLE `pvpstats_players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quest_tracker`
--

DROP TABLE IF EXISTS `quest_tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `quest_tracker` (
  `id` int(10) unsigned NOT NULL DEFAULT 0,
  `character_guid` bigint(20) unsigned NOT NULL DEFAULT 0,
  `quest_accept_time` datetime NOT NULL,
  `quest_complete_time` datetime DEFAULT NULL,
  `quest_abandon_time` datetime DEFAULT NULL,
  `completed_by_gm` tinyint(1) NOT NULL DEFAULT 0,
  `core_hash` varchar(120) NOT NULL DEFAULT '0',
  `core_revision` varchar(120) NOT NULL DEFAULT '0',
  UNIQUE KEY `idx_latest_quest_for_character` (`id`,`character_guid`,`quest_accept_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quest_tracker`
--

LOCK TABLES `quest_tracker` WRITE;
/*!40000 ALTER TABLE `quest_tracker` DISABLE KEYS */;
/*!40000 ALTER TABLE `quest_tracker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserved_name`
--

DROP TABLE IF EXISTS `reserved_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserved_name` (
  `name` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player Reserved Names';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserved_name`
--

LOCK TABLES `reserved_name` WRITE;
/*!40000 ALTER TABLE `reserved_name` DISABLE KEYS */;
/*!40000 ALTER TABLE `reserved_name` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respawn`
--

DROP TABLE IF EXISTS `respawn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `respawn` (
  `type` smallint(5) unsigned NOT NULL,
  `spawnId` bigint(20) unsigned NOT NULL,
  `respawnTime` bigint(20) NOT NULL,
  `mapId` smallint(5) unsigned NOT NULL,
  `instanceId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`type`,`spawnId`,`instanceId`),
  KEY `idx_instance` (`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stored respawn times';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respawn`
--

LOCK TABLES `respawn` WRITE;
/*!40000 ALTER TABLE `respawn` DISABLE KEYS */;
INSERT INTO `respawn` VALUES
(0,1050165,1762835287,2175,0),
(0,1050166,1762835271,2175,0);
/*!40000 ALTER TABLE `respawn` ENABLE KEYS */;
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
('2014_10_20_00_characters.sql','A5882DA0979CF4DAE33DA011EBAA006C24BE7230','ARCHIVED','2015-03-21 15:55:55',0),
('2014_10_23_00_characters.sql','E2AC4758133EE19B7F08464A445802154D1261C8','ARCHIVED','2015-03-21 15:55:55',0),
('2014_10_23_01_characters.sql','20029E6323D9773B32C34D84FFED1711CC60F09F','ARCHIVED','2015-03-21 15:55:55',0),
('2014_10_23_02_characters.sql','8A7A16886EE71E7ACDDB3DDA6D0ECAC2FD2FDCA8','ARCHIVED','2015-03-21 15:55:55',0),
('2014_10_24_00_characters.sql','D008FE81AE844FCA686439D6ECC5108FB0DD1EB9','ARCHIVED','2015-03-21 15:55:55',0),
('2014_10_25_00_characters.sql','A39C7BE46686B54776BDAB9D7A882D91EDEC51A4','ARCHIVED','2015-03-21 15:55:55',0),
('2014_10_26_00_characters.sql','C787954CC35FE34B4101FDE6527F14C027F4947C','ARCHIVED','2015-03-21 15:55:55',0),
('2014_11_12_00_characters.sql','B160BB2313F1BD5F3B076A5A9279DC10D4796E34','ARCHIVED','2015-03-21 15:55:55',0),
('2014_12_23_00_characters.sql','3D9D648B2387B357F4BD090B33F80682F7924882','ARCHIVED','2015-03-21 15:55:55',0),
('2014_12_28_00_characters.sql','5362922FF4483A336311D73082A5727309CD9219','ARCHIVED','2015-03-21 15:55:55',0),
('2014_12_31_00_characters.sql','498DDF2DD936CF156D74A8208DC93DCE9FCAB5AA','ARCHIVED','2015-03-21 15:55:55',0),
('2015_01_02_00_characters.sql','E5940BE836F253982E07930120422E598D08BDE1','ARCHIVED','2015-03-21 15:55:55',0),
('2015_01_10_00_characters.sql','30796056C8623699B2FE1BF626A19D38262E9284','ARCHIVED','2015-03-21 15:55:55',0),
('2015_01_16_00_characters.sql','96642760A54C8D799AAFE438049A63AA521656F2','ARCHIVED','2015-03-21 15:55:55',0),
('2015_01_27_00_characters.sql','EB710E3EB9F2CAFD84AB62CDC84E898403A80A4F','ARCHIVED','2015-03-21 15:55:55',0),
('2015_02_13_00_characters.sql','405BEB4ED207DC6076442A37EE2AFB1F21E274A0','ARCHIVED','2015-03-21 15:55:55',0),
('2015_02_13_01_characters.sql','35F582D4F33BF55D1685A1BA89273ED895FD09C5','ARCHIVED','2015-03-21 15:55:55',0),
('2015_02_17_00_characters.sql','8D21FC5A55BF8B55D6DCDCE5F02CF2B640230E94','ARCHIVED','2015-03-21 15:55:55',0),
('2015_03_10_00_characters.sql','E565B89B145C340067742DFF2DEF1B74F5F1BD4E','ARCHIVED','2015-03-21 15:55:55',0),
('2015_03_20_00_characters.sql','B761760804EA73BD297F296C5C1919687DF7191C','ARCHIVED','2015-03-21 15:55:55',0),
('2015_03_20_01_characters.sql','20BD68468C57FCF7E665B4DA185DCD52FACE8B3F','ARCHIVED','2015-03-21 15:55:55',0),
('2015_03_20_02_characters.sql','0296995DCD3676BA9AE6024CA7C91C5F39D927A3','ARCHIVED','2015-03-21 15:56:46',0),
('2015_03_29_00_characters.sql','95D6A46BB746A8BD3EE3FE2086DF1A07F7C33B92','ARCHIVED','2015-05-02 15:43:06',0),
('2015_04_21_00_characters.sql','F2032B9BF4EDA7EDE5065554724ED392FD91657D','ARCHIVED','2015-05-02 15:43:06',0),
('2015_04_28_00_characters.sql','949F62DB3A3461D420A1230ECF7A6A3ED6435703','ARCHIVED','2015-05-02 15:43:06',0),
('2015_05_08_00_characters.sql','0F14B7821618D1C872625B6EDDAA9A667B211167','ARCHIVED','2015-07-10 19:32:17',0),
('2015_05_22_00_characters.sql','65B82152413FAB23BE413656E59A486A74447FF7','ARCHIVED','2015-07-10 19:32:17',0),
('2015_07_08_00_characters.sql','DAB25360ACB5244C8F8E6214CF6BD97160588A5B','ARCHIVED','2015-07-10 19:32:17',0),
('2015_07_11_00_characters.sql','B421B6C0E57BD0FD587071358863D9DABF4BA849','ARCHIVED','2015-07-13 21:50:02',0),
('2015_07_12_00_characters.sql','E98E7FD61EF6426E7EDE8ED9AD8C15D8D7132589','ARCHIVED','2015-07-13 21:50:02',0),
('2015_07_28_00_characters.sql','0711BC3A658D189EF71B0CB68DCFF2E9B781C4A0','ARCHIVED','2015-07-29 16:23:56',0),
('2015_08_08_00_characters.sql','EA12BB2DC24FAF2300A96D0888A45BBEA158D5DC','ARCHIVED','2015-08-08 16:34:07',0),
('2015_08_12_00_characters.sql','4FD7F89FE5DA51D4E0C33E520719986AA3EBD31B','ARCHIVED','2015-08-12 12:35:20',0),
('2015_09_05_00_characters.sql','4C22BB29365BE4B6B95E64DAD84B63CA002304EA','ARCHIVED','2015-09-05 12:35:20',0),
('2015_09_09_00_characters.sql','AFC32E693BC17CFD9A17919FE5317B8FE337ACAD','ARCHIVED','2015-09-09 12:35:20',0),
('2015_09_10_00_characters.sql','4555A7F35C107E54C13D74D20F141039ED42943E','ARCHIVED','2015-09-10 22:50:42',0),
('2015_10_16_00_characters.sql','E3A3FFF0CB42F04A8DCF0CE4362143C16E2083AF','ARCHIVED','2015-10-15 21:54:11',0),
('2015_11_06_00_characters_2015_10_12_00.sql','D6F9927BDED72AD0A81D6EC2C6500CBC34A39FA2','ARCHIVED','2015-11-06 23:43:27',0),
('2015_11_08_00_characters.sql','0ACDD35EC9745231BCFA701B78056DEF94D0CC53','ARCHIVED','2015-11-08 00:51:45',0),
('2015_11_23_00_characters.sql','9FC828E9E48E8E2E9B99A5A0073D6614C5BFC6B5','ARCHIVED','2015-11-22 23:27:34',0),
('2016_01_05_00_characters.sql','0EAD24977F40DE2476B4567DA2B477867CC0DA1A','ARCHIVED','2016-01-04 23:07:40',0),
('2016_04_05_00_characters_2016_02_10_00_characters.sql','F1B4DA202819CABC7319A4470A2D224A34609E97','ARCHIVED','2016-04-05 20:34:41',0),
('2016_04_11_00_characters.sql','0ACDD35EC9745231BCFA701B78056DEF94D0CC53','ARCHIVED','2016-04-11 02:24:14',0),
('2016_04_11_01_characters.sql','CA90F6D99C1EEA7B25BD58BC8368A8D78234BBEF','ARCHIVED','2016-04-11 18:14:18',0),
('2016_05_07_00_characters.sql','D1DB5557B21A552C935564D829B4E98B98149077','ARCHIVED','2016-05-07 00:00:00',0),
('2016_05_26_00_characters.sql','4179ADC32B96FD8D7D4CF5509A470B1ACE00BE85','ARCHIVED','2016-05-26 17:06:16',0),
('2016_07_16_00_characters.sql','EF267FCB92B383FFB33C700508EAF3FBC1F8AC23','ARCHIVED','2016-07-16 14:45:12',0),
('2016_07_19_00_characters.sql','AA2C516FA81B451071EA82F58F447E9D13E5D1BD','ARCHIVED','2016-07-19 14:36:25',0),
('2016_07_19_01_characters.sql','E9AF46AF4C7CC2E2779E44254AEEDF880D020166','ARCHIVED','2016-07-19 14:36:25',0),
('2016_07_19_02_characters.sql','5B1B334449996F3639C9226F587129E03DC4BF6D','ARCHIVED','2016-07-19 14:36:26',0),
('2016_07_19_03_characters.sql','7787C8A67D720492FED4BF60ADB22D3CDE1C536D','ARCHIVED','2016-07-19 14:36:26',0),
('2016_07_19_04_characters.sql','6D4B536094367AC9EF7CDFF41A4F96EB00B25EE5','ARCHIVED','2016-07-19 14:36:26',0),
('2016_07_19_05_characters.sql','12639268DC5F78CE900B59D5C646B10D70842928','ARCHIVED','2016-07-19 14:36:27',0),
('2016_07_19_06_characters.sql','9F5A4B533E6BFBAA718DE5160E1FDCB8471A88BF','ARCHIVED','2016-07-19 14:36:28',0),
('2016_07_19_07_characters.sql','1E8273FFD4340CBD7BB71D2406E23E9EF7230CFA','ARCHIVED','2016-07-19 14:36:29',0),
('2016_07_19_08_characters.sql','FB41FD2F8A7114FEE154021A9D47488C4B12E2A9','ARCHIVED','2016-07-19 14:36:29',0),
('2016_08_15_00_characters.sql','BF0B5F453384210CD77C54E262A19B888AAA4095','ARCHIVED','2016-08-14 18:14:32',0),
('2016_08_25_00_characters.sql','4AD506C3FCE54238EF452AC07EC562BD41A9D50C','ARCHIVED','2016-08-25 22:54:11',0),
('2016_10_17_00_characters.sql','A0EF594CD73690D46A46031137DB0E895F079235','ARCHIVED','2016-10-16 16:33:05',0),
('2016_10_25_00_characters.sql','CC894484561CE138C10B69D34F7831CEDFAF496B','ARCHIVED','2016-10-25 17:19:35',0),
('2016_11_06_00_characters.sql','C7EC8B65C1BE7722C53BAB79C52C1549054178C0','ARCHIVED','2016-11-06 23:05:44',0),
('2016_12_09_00_characters.sql','2A68E4187CE7F7294CBC3804AC39F48B2727E64E','ARCHIVED','2016-12-09 18:38:46',0),
('2016_12_26_00_characters.sql','D265DE655DDBFC13E2FA1EB021A435A21189B6E4','ARCHIVED','2016-12-26 18:45:15',0),
('2017_01_22_00_characters.sql','62B08B5FB1DA7B207C74DC000C42517A2D6F6BCC','ARCHIVED','2017-01-22 02:06:31',0),
('2017_01_29_00_characters.sql','E7475DCC13A0910FF23BF0EFB731629950A73A0D','ARCHIVED','2017-01-29 15:00:00',0),
('2017_02_26_00_characters_2016_09_13_00_characters.sql','2EF7AD507D097ABC74FF1E98A65BEC03B12E51C6','ARCHIVED','2017-02-26 19:57:47',0),
('2017_04_15_00_characters.sql','F118BA33CD7DDF2EE5673C6749C2965EFFF53C23','ARCHIVED','2017-04-15 12:10:50',0),
('2017_04_19_00_characters.sql','5A36FD9015ED024BC085F995F72DC81B47CD1093','ARCHIVED','2017-04-18 23:16:18',0),
('2017_05_08_00_characters.sql','86B5603EEBE1DE0EA56DBB264257967CFE583F46','ARCHIVED','2017-05-08 23:54:40',0),
('2017_05_14_00_characters.sql','3452261F366BFE76BB59C0AAA674FA1513042899','ARCHIVED','2017-05-14 17:29:04',0),
('2017_05_24_00_characters.sql','02701BF57589CD41456A748AEF425CBB2D3E6AD7','ARCHIVED','2017-05-24 22:00:00',0),
('2017_06_04_00_characters.sql','BC80D2B7515CC6E01701070D2DA466727F36DB5E','ARCHIVED','2017-06-04 14:43:26',0),
('2017_08_20_00_characters.sql','8C5BBF6AEAA6C7DE2F40A7D3878C8187A4729F13','ARCHIVED','2017-08-20 17:00:00',0),
('2017_08_20_01_characters.sql','2F50D5E6BF3888B8C5270D79228A1D0601FAFF1D','ARCHIVED','2017-08-20 17:52:21',0),
('2017_10_29_00_characters.sql','8CFC473E7E87E58C317A72016BF69E9050D3BC83','ARCHIVED','2017-04-19 00:07:40',0),
('2018_02_03_00_characters.sql','73E9BFD848D7A22F2A7DD89CF64E30E3A8689512','ARCHIVED','2018-02-03 23:52:42',0),
('2018_02_08_00_characters.sql','75FA162A9B85D678B26F972371265F1EC2C75187','ARCHIVED','2018-02-08 22:23:28',0),
('2018_02_19_00_characters.sql','75A0FFAFD0633921708DB0F72F9CC9796ACB960B','ARCHIVED','2018-02-19 22:33:32',0),
('2018_03_04_00_characters.sql','2A4CD2EE2547E718490706FADC78BF36F0DED8D6','ARCHIVED','2018-03-04 18:15:24',0),
('2018_04_28_00_characters.sql','CBD0FDC0F32DE3F456F7CE3D9CAD6933CD6A50F5','ARCHIVED','2018-04-28 12:44:09',0),
('2018_07_28_00_characters.sql','31F66AE7831251A8915625EC7F10FA138AB8B654','ARCHIVED','2018-07-28 18:30:19',0),
('2018_07_31_00_characters.sql','7DA8D4A4534520B23E6F5BBD5B8EE205B799C798','ARCHIVED','2018-07-31 20:54:39',0),
('2018_12_09_00_characters.sql','7FE9641C93ED762597C08F1E9B6649C9EC2F0E47','ARCHIVED','2018-09-18 23:34:29',0),
('2018_12_09_01_characters.sql','C80B936AAD94C58A0F33382CED08CFB4E0B6AC34','ARCHIVED','2018-10-10 22:05:28',0),
('2018_12_09_02_characters.sql','DBBA0C06985CE8AC4E6E7E94BD6B2673E9ADFAE2','ARCHIVED','2018-12-02 17:32:31',0),
('2019_06_08_00_characters.sql','6C5AF52AEF03BC019B96E7A07592C22660F9327B','ARCHIVED','2019-06-03 20:04:47',0),
('2019_06_08_01_characters.sql','55076AFAF4B55DB4E34029C269EE0C84315C31BA','ARCHIVED','2019-06-04 22:11:47',0),
('2019_06_25_00_characters.sql','B8CBF79DEE02B40B01424327D31E52C70335BEC6','ARCHIVED','2019-06-25 22:40:37',0),
('2019_07_15_00_characters.sql','E1C77F604FB2A2FE8B32258CD0C9EC71BEA4F0FF','ARCHIVED','2019-06-25 22:40:37',0),
('2019_10_26_00_characters.sql','F1090ACDEB876A7BB5ED8829373F6305A217949A','ARCHIVED','2019-10-25 23:04:42',0),
('2019_10_26_01_characters.sql','59D5860930D02AB77D2AAA704C564957A9143760','ARCHIVED','2019-10-26 22:04:46',0),
('2019_11_03_00_characters.sql','DC789597F85B890E9A7901B4443DAD9CAEE2A02A','ARCHIVED','2019-11-03 14:13:27',0),
('2019_11_12_00_characters.sql','D4C642B4D48DAE9F56329BDE51C258323A132A91','ARCHIVED','2019-11-12 16:31:29',0),
('2019_11_22_00_characters.sql','95DFA71DBD75542C098CD86E9C0051C9690902F0','ARCHIVED','2019-11-20 15:10:12',0),
('2019_11_30_00_characters.sql','D0678E62B651AECA60C2DD6989BF80BD999AD12B','ARCHIVED','2019-11-29 22:42:01',0),
('2019_12_05_00_characters.sql','EA381C9634A5646A3168F15DF4E06A708A622762','ARCHIVED','2019-12-05 20:56:58',0),
('2020_02_17_00_characters.sql','E1519A81D35F19B48B3C75A83A270CB4BA0B84F2','ARCHIVED','2020-02-17 21:55:17',0),
('2020_04_20_00_characters.sql','977B5E0C894E0A7E80B2A9626F17CA636A69BD22','ARCHIVED','2020-04-20 19:08:18',0),
('2020_04_24_00_characters.sql','85E2E0395A9457A53D73A9E0A7BB39B7E4C429BF','ARCHIVED','2020-04-24 22:04:59',0),
('2020_04_25_00_characters_2017_04_03_00_characters.sql','00FA3EFADAF807AC96619A3FE47216E21C3FCB19','ARCHIVED','2020-04-25 00:00:00',0),
('2020_04_26_00_characters_2017_04_12_00_characters.sql','86AA94DA9B1EA283101100886C10F648C0CE6494','ARCHIVED','2020-04-26 00:00:00',0),
('2020_04_26_01_characters_2017_04_12_01_characters.sql','5A8A1215E3A2356722F52CD7A64BBE03D21FBEA3','ARCHIVED','2020-04-26 00:00:00',0),
('2020_06_12_00_characters.sql','DF16C99EFACA4DFADDDF35644AAC63F9B4AA2BD6','ARCHIVED','2020-06-11 16:24:56',0),
('2020_06_17_00_characters.sql','C3EE0D751E4B97CDF15F3BE27AAAE3646514A358','ARCHIVED','2020-06-17 17:04:56',0),
('2020_08_14_00_characters.sql','355685FF86EE64E2ED9D4B7D1311D53A9C2E0FA5','ARCHIVED','2020-08-14 21:41:24',0),
('2020_10_20_00_characters.sql','744F2A36865761920CE98A6DDE3A3BADF44D1E77','ARCHIVED','2020-10-20 21:36:49',0),
('2020_11_16_00_characters.sql','33D5C7539E239132923D01F4B6EAD5F3EF3EEB69','ARCHIVED','2020-11-16 19:16:31',0),
('2020_12_13_00_characters.sql','6AC743240033DED2C402ECB894A59D79EF607920','ARCHIVED','2020-12-13 18:36:58',0),
('2021_03_27_00_characters_aura_stored_location.sql','BF772ABC2DF186AF0A5DC56D5E824A2F4813BA69','ARCHIVED','2021-03-27 15:53:04',0),
('2021_04_05_00_characters.sql','33D656995E0F3578FFE1A658ED1692CA5310AB30','ARCHIVED','2021-04-05 23:44:54',0),
('2021_05_10_00_characters.sql','0A406242BC18BDA5A65CDE3E2AFEE760D79F819F','ARCHIVED','2021-05-10 23:30:34',0),
('2021_05_11_00_characters.sql','C3F0337CE8363F970AB4FDB9D23BBB7C650A0B0E','ARCHIVED','2021-05-11 15:39:26',0),
('2021_07_04_00_characters.sql','E0E7AD664DDB553E96B457DD9ED8976665E94007','ARCHIVED','2021-07-04 22:23:24',0),
('2021_08_11_00_characters.sql','2137A52A45B045104B97D39626CE3C0214625B17','ARCHIVED','2021-08-11 21:48:57',0),
('2021_08_18_00_characters.sql','5BA1326EE8EC907CDE82E6E8BCB38EA2E661F10A','ARCHIVED','2021-08-18 15:14:17',0),
('2021_10_02_00_characters.sql','31CEACE4E9A4BE58A659A2BDE4A7C51D2DB8AC41','ARCHIVED','2021-10-02 21:21:37',0),
('2021_10_02_01_characters.sql','F97B956F3B5F909294CA399F75B5795A07C4D8EC','ARCHIVED','2021-10-02 21:47:38',0),
('2021_10_15_00_characters.sql','906FECD65CBA7C406969F45FDF28DDEF8AAF8715','ARCHIVED','2021-10-15 10:11:47',0),
('2021_10_16_00_characters.sql','B5A31BB6FBC34512767475EDF13099DEC948EBB7','ARCHIVED','2021-10-16 01:12:20',0),
('2021_11_02_00_characters.sql','A3C0A6DA70CC70803C80685E4E2ED6255156520A','ARCHIVED','2021-11-02 18:11:13',0),
('2021_11_04_00_characters.sql','ED533235ADAD174F91A6B8E51D1046243B78B46D','ARCHIVED','2021-11-04 21:53:04',0),
('2021_11_17_00_characters.sql','03A0AB8ECD8BE5D818D41A8A610097C94A9C7DB9','ARCHIVED','2021-11-17 13:23:17',0),
('2021_12_16_00_characters_2019_07_14_00_characters.sql','DC1A3D3311FCF9106B4D91F8D2C5B893AD66C093','ARCHIVED','2021-12-16 01:06:53',0),
('2021_12_16_01_characters_2019_07_16_00_characters.sql','76AE193EFA3129FA1702BF7B6FA7C4127B543BDF','ARCHIVED','2021-12-16 20:16:25',0),
('2021_12_23_00_characters.sql','7F2BD7CA61CD28D74AD9CA9F06FD7E542837ED3F','ARCHIVED','2021-12-23 19:16:29',0),
('2021_12_31_00_characters.sql','7ECEEB66056C46F89E581ACBB5EC222CB2D8A365','ARCHIVED','2021-12-31 13:53:23',0),
('2021_12_31_01_characters.sql','336E62A8850A3E78A1D0BD3E81FFD5769184BDF8','ARCHIVED','2021-12-31 15:58:32',0),
('2021_12_31_02_characters.sql','C66A367F0AD7A9D6837238C21E91298413BD960C','ARCHIVED','2021-12-31 16:10:30',0),
('2022_01_02_00_characters.sql','5169A5BBACB42E6CEDE405D3C4843FD386CDF92E','ARCHIVED','2022-01-02 21:22:35',0),
('2022_01_09_00_characters.sql','3AC51F589821C17027CBA861EF762A709430CDB3','ARCHIVED','2022-01-09 21:29:45',0),
('2022_01_15_00_characters.sql','884EFB6592DC8A765E0C0BF8BF907B4E4733BB0C','ARCHIVED','2022-01-15 23:24:58',0),
('2022_01_31_00_characters.sql','19551474AA6079F0616B565F254914C5DD9ED1A1','ARCHIVED','2022-01-31 14:32:49',0),
('2022_01_31_01_characters.sql','E0A1FA670F4621AEB594D7ACBA4921CB298F54FF','ARCHIVED','2022-01-31 20:47:59',0),
('2022_01_31_02_characters.sql','6E3A3F02276287DD540BC4C17E246DFB850260D8','ARCHIVED','2022-01-31 21:43:38',0),
('2022_02_28_00_characters_2020_09_27_00_characters.sql','2292A1ED0E7F46DEC41384F75FA6D9461464EEB8','ARCHIVED','2022-02-28 12:43:58',0),
('2022_03_06_00_characters.sql','474AAF9D03E6A56017899C968DC9875368301934','ARCHIVED','2022-03-06 15:12:24',0),
('2022_03_11_00_characters_2021_07_18_00_characters.sql','0BA579ED21F4E75AC2B4797421B5029568B3F6E2','ARCHIVED','2022-03-11 18:56:07',0),
('2022_06_01_00_characters.sql','582AC6E256F8365F83AB70BA165CCC8B218E19FF','ARCHIVED','2022-06-01 21:16:56',0),
('2022_07_03_00_characters.sql','D3F04078C0846BCF7C8330AC20C39B8C3AEE7002','ARCHIVED','2022-07-03 23:37:24',0),
('2022_07_14_00_characters.sql','2EAD57D77FC39F6678F2D2A7D9C24046E6B836D8','ARCHIVED','2022-07-14 21:44:35',0),
('2022_07_25_00_characters.sql','3159BB2F3C346A7881920AB2B1F8108247CF13EE','ARCHIVED','2022-07-25 18:44:10',0),
('2022_08_19_00_characters.sql','1C076A24F2B48F32E8EF835C01F8907CA9E86491','ARCHIVED','2022-08-19 23:43:01',0),
('2022_08_21_00_characters.sql','1D75688392FBDA18CD8494F32CF682DCB49642EC','ARCHIVED','2022-08-21 00:02:03',0),
('2022_09_18_00_characters.sql','A7DF0C1F0E074F3E63A6CDD0AF873A1F3DC33B29','ARCHIVED','2022-09-18 21:48:42',0),
('2022_10_03_00_characters.sql','7B062787230D9158A622EB4AFE7FA6D18AB47BB3','ARCHIVED','2022-10-03 22:32:58',0),
('2022_10_03_01_characters.sql','7CF58BD9CC366301CC992017028568C8774C4BC2','ARCHIVED','2022-10-03 22:36:38',0),
('2022_10_03_02_characters.sql','33135AB3132943F15F4849A16EC5EFEA402F24F6','ARCHIVED','2022-10-03 22:38:27',0),
('2022_11_20_00_characters.sql','4EB8BB24CAF16B0962DF3EF92C77BE05E234CFA6','ARCHIVED','2022-11-20 11:05:20',0),
('2022_12_16_00_characters.sql','36D6220143109ECD37219CC4A84773B31EAE9E50','ARCHIVED','2022-12-16 22:52:19',0),
('2022_12_17_00_characters.sql','3E005BD6B9C60653749B0B3C19CBC497092B9CCB','ARCHIVED','2022-12-17 18:26:43',0),
('2022_12_20_00_characters.sql','75A37A085AF1B953926E4352E439C7916B290924','ARCHIVED','2022-12-20 03:10:07',0),
('2022_12_30_00_characters.sql','5F90C2BFFBB8F6CE0A3327A2CAABCD5CA3C2BA60','ARCHIVED','2022-12-30 22:50:16',0),
('2023_01_28_00_characters.sql','0280F79FD6EC93FFB3CC67B6499CEDA49D582BFC','ARCHIVED','2023-01-28 00:11:03',0),
('2023_01_29_00_characters.sql','24FA9E0F616BF77AC588A25A8A8699903A19A5FE','ARCHIVED','2023-01-29 16:31:12',0),
('2023_02_03_00_characters.sql','A04BA4386B3D5C60407D22CA4BF9A4A6258AA39D','ARCHIVED','2023-02-03 01:13:52',0),
('2023_02_08_00_characters.sql','C9DF607CCE99540F613F5E25E17090176C995C7C','ARCHIVED','2023-02-08 21:41:17',0),
('2023_04_02_00_characters.sql','AAC1B81AFE4716CF4DAB6BCF01D22F421BFAD253','ARCHIVED','2023-04-02 01:02:26',0),
('2023_05_04_00_characters.sql','9AC370E51507F5BD368707E90D8F6BF0FF16CA09','ARCHIVED','2023-05-04 16:17:31',0),
('2023_05_19_00_characters.sql','5E0C9338554BAA481566EDFF3FE2FCEFF1B67DA9','ARCHIVED','2023-05-19 18:40:42',0),
('2023_07_14_00_characters.sql','BB44A95A9C4B0C16878A5316AC38E702A8AACDE2','ARCHIVED','2023-07-14 08:24:44',0),
('2023_08_26_00_characters.sql','FA50838609AB5E645FB2DCAC970BD5706F9EFAAF','ARCHIVED','2023-08-26 12:18:22',0),
('2023_09_14_00_characters.sql','DAC56929C724C2971A4476400F2439CBDFAF3C5C','ARCHIVED','2023-09-13 22:20:22',0),
('2023_09_30_00_characters.sql','4326C642870633873F163085D278DB9B7449D9C3','ARCHIVED','2023-09-30 16:34:19',0),
('2023_10_06_00_characters.sql','FFAFF1F0916BB9DC58345466E0BB1A15A4611836','ARCHIVED','2023-10-06 00:40:46',0),
('2023_11_02_00_characters.sql','1A76A843F204901C8598DA5682029E815477E427','ARCHIVED','2023-11-02 18:59:41',0),
('2023_11_09_00_characters.sql','1A3D7CA6890353DA55793FE8D925CC8C54965A69','ARCHIVED','2023-11-09 00:56:31',0),
('2023_11_15_00_characters.sql','441E0F17DE3E3945307AC400DF86FCDF06C61653','ARCHIVED','2023-11-15 00:53:47',0),
('2024_02_08_00_characters.sql','743A11042AA17CDBD5F3D510D24509A10838DB5A','ARCHIVED','2024-02-08 00:56:26',0),
('2024_04_09_00_characters.sql','07AC79B4E489B1CD073852EC57D12939C2A1D4B1','ARCHIVED','2024-04-09 12:54:11',0),
('2024_04_12_00_characters.sql','043E023F998DA77170C9D2D0162CAA340290B215','ARCHIVED','2024-04-12 00:23:51',0),
('2024_04_28_00_characters.sql','F80F476704BE535B5DCB0BCEBDD56024FCFBBAA2','ARCHIVED','2024-04-28 19:26:58',0),
('2024_05_11_00_characters.sql','A65765D87C1BA181561A6517040DC1A3A8103B71','ARCHIVED','2024-05-11 03:06:52',0),
('2024_07_31_00_characters.sql','F7E7AE0B8077CB9A1EA0AE4F49693BB05A742AC3','ARCHIVED','2024-07-31 16:18:36',0),
('2024_08_04_00_characters.sql','7D153C59998416E6EA1455086730A2321AD0F2A8','ARCHIVED','2024-08-04 17:58:59',0),
('2024_08_05_00_characters.sql','7E4AE28F9EC370A1B22DBD8DD718EE027A321F33','ARCHIVED','2024-08-05 11:19:40',0),
('2024_08_26_00_characters.sql','68EEBE1D639D59B24F5121008C2D103CA67FFC9A','ARCHIVED','2024-08-26 00:49:08',0),
('2024_09_03_00_characters.sql','71ECC73A3F324EB64DA19B0CC4DF72A85E022BDC','ARCHIVED','2024-09-03 00:47:42',0),
('2024_09_23_00_characters.sql','D8491BCEE728F40D55D47E3A4BC5A5F083EBD02E','ARCHIVED','2024-09-23 22:48:10',0),
('2024_10_03_00_characters.sql','408249A6992999A36EB94089D184972E8E0767A3','ARCHIVED','2024-10-03 11:10:18',0),
('2024_11_04_00_characters.sql','F7980E0CEE728FF866703693690F76F932E7C764','ARCHIVED','2024-11-04 17:14:03',0),
('2024_11_16_00_characters.sql','9D9D87FB8DEB99F074EB499A5BD230FD9C993669','ARCHIVED','2024-11-16 21:57:39',0),
('2024_12_13_00_characters.sql','4A00C51BA33639F5555AAE40EC672AE47126F7B6','ARCHIVED','2024-12-13 00:17:03',0),
('2024_12_22_00_characters.sql','A2F24564430C5BCC96C279E843FA3548B1F831EE','ARCHIVED','2024-12-22 02:56:17',0),
('2025_01_04_00_characters.sql','403E8B642A67765A04A0A4D5BC0752288208079C','ARCHIVED','2025-01-04 16:31:39',0),
('2025_03_29_00_characters.sql','6A49C236D0B8CCD8A5B6B51F60E116B3380772D7','ARCHIVED','2025-03-29 01:12:13',0),
('2025_05_31_00_characters.sql','C240EB5C4008B6AA0514802A18D7DD875680DE82','ARCHIVED','2025-05-31 19:45:56',0),
('2025_06_27_00_characters.sql','35088BA5BA4BD3B7FAAD6FD4FAE38E52A5B71CD8','ARCHIVED','2025-06-27 14:22:08',0),
('2025_07_21_00_characters.sql','056A99B9AA90186E5B3177BF54C86607B6518BE9','ARCHIVED','2025-07-21 22:51:05',0),
('2025_08_13_00_characters.sql','0A559553A1DD9FC973AB01C3B1A9284B07CFBB36','ARCHIVED','2025-08-12 20:17:45',0),
('2025_08_16_00_characters.sql','8DF6284B6C7BEDAB599F7E4802FF8BCD80613A92','ARCHIVED','2025-08-16 14:58:22',0),
('2025_08_19_00_characters.sql','EC197D88883CDA2B885675FE096DD56CCB143608','ARCHIVED','2025-08-19 01:03:26',0),
('2025_09_09_00_characters.sql','CF3F0738623248620204175B049AAF0833262222','ARCHIVED','2025-09-09 14:11:21',0),
('2025_10_10_00_characters.sql','F1EF875805AF1E87A413387F5449FE37D5205E94','ARCHIVED','2025-10-09 23:58:44',0),
('2025_10_29_00_characters.sql','DC6A5D66E866352AC243869B627D282EE6A8B4F2','RELEASED','2025-10-29 06:57:00',0);
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
('$/sql/custom/characters','RELEASED'),
('$/sql/old/10.x/characters','ARCHIVED'),
('$/sql/old/11.x/characters','ARCHIVED'),
('$/sql/old/6.x/characters','ARCHIVED'),
('$/sql/old/7/characters','ARCHIVED'),
('$/sql/old/8.x/characters','ARCHIVED'),
('$/sql/old/9.x/characters','ARCHIVED'),
('$/sql/updates/characters','RELEASED');
/*!40000 ALTER TABLE `updates_include` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warden_action`
--

DROP TABLE IF EXISTS `warden_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `warden_action` (
  `wardenId` smallint(5) unsigned NOT NULL,
  `action` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`wardenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warden_action`
--

LOCK TABLES `warden_action` WRITE;
/*!40000 ALTER TABLE `warden_action` DISABLE KEYS */;
/*!40000 ALTER TABLE `warden_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `world_state_value`
--

DROP TABLE IF EXISTS `world_state_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `world_state_value` (
  `Id` int(11) NOT NULL,
  `Value` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `world_state_value`
--

LOCK TABLES `world_state_value` WRITE;
/*!40000 ALTER TABLE `world_state_value` DISABLE KEYS */;
INSERT INTO `world_state_value` VALUES
(17042,10),
(17043,10);
/*!40000 ALTER TABLE `world_state_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `world_variable`
--

DROP TABLE IF EXISTS `world_variable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `world_variable` (
  `ID` varchar(64) NOT NULL,
  `Value` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `world_variable`
--

LOCK TABLES `world_variable` WRITE;
/*!40000 ALTER TABLE `world_variable` DISABLE KEYS */;
INSERT INTO `world_variable` VALUES
('NextBGRandomDailyResetTime',1763359200),
('NextCurrencyResetTime',1763877600),
('NextDailyQuestResetTime',1763348400),
('NextGuildDailyResetTime',1763359200),
('NextGuildWeeklyResetTime',5),
('NextMonthlyQuestResetTime',1764558000),
('NextOldCalendarEventDeletionTime',1763359200),
('NextWeeklyQuestResetTime',1763521200),
('PersistentCharacterCleanFlags',0);
/*!40000 ALTER TABLE `world_variable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'characters'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-17  7:35:56
