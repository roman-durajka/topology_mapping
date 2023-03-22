-- MariaDB dump 10.19  Distrib 10.11.2-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: relations
-- ------------------------------------------------------
-- Server version	10.11.2-MariaDB-1:10.11.2+maria~ubu2204

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
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `device_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inserted` timestamp NULL DEFAULT current_timestamp(),
  `hostname` varchar(128) NOT NULL,
  `sysName` varchar(128) DEFAULT NULL,
  `display` varchar(128) DEFAULT NULL,
  `ip` varbinary(16) DEFAULT NULL,
  `overwrite_ip` varchar(40) DEFAULT NULL,
  `community` varchar(255) DEFAULT NULL,
  `authlevel` enum('noAuthNoPriv','authNoPriv','authPriv') DEFAULT NULL,
  `authname` varchar(64) DEFAULT NULL,
  `authpass` varchar(64) DEFAULT NULL,
  `authalgo` varchar(10) DEFAULT NULL,
  `cryptopass` varchar(64) DEFAULT NULL,
  `cryptoalgo` varchar(10) DEFAULT NULL,
  `snmpver` varchar(4) NOT NULL DEFAULT 'v2c',
  `port` smallint(5) unsigned NOT NULL DEFAULT 161,
  `transport` varchar(16) NOT NULL DEFAULT 'udp',
  `timeout` int(11) DEFAULT NULL,
  `retries` int(11) DEFAULT NULL,
  `snmp_disable` tinyint(1) NOT NULL DEFAULT 0,
  `bgpLocalAs` int(10) unsigned DEFAULT NULL,
  `sysObjectID` varchar(128) DEFAULT NULL,
  `sysDescr` text DEFAULT NULL,
  `sysContact` text DEFAULT NULL,
  `version` text DEFAULT NULL,
  `hardware` text DEFAULT NULL,
  `features` text DEFAULT NULL,
  `location_id` int(10) unsigned DEFAULT NULL,
  `os` varchar(32) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `status_reason` varchar(50) NOT NULL,
  `ignore` tinyint(1) NOT NULL DEFAULT 0,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `uptime` bigint(20) DEFAULT NULL,
  `agent_uptime` int(10) unsigned NOT NULL DEFAULT 0,
  `last_polled` timestamp NULL DEFAULT NULL,
  `last_poll_attempted` timestamp NULL DEFAULT NULL,
  `last_polled_timetaken` double(5,2) DEFAULT NULL,
  `last_discovered_timetaken` double(5,2) DEFAULT NULL,
  `last_discovered` timestamp NULL DEFAULT NULL,
  `last_ping` timestamp NULL DEFAULT NULL,
  `last_ping_timetaken` double(8,2) DEFAULT NULL,
  `purpose` text DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT '',
  `serial` text DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `poller_group` int(11) NOT NULL DEFAULT 0,
  `override_sysLocation` tinyint(1) DEFAULT 0,
  `notes` text DEFAULT NULL,
  `port_association_mode` int(11) NOT NULL DEFAULT 1,
  `max_depth` int(11) NOT NULL DEFAULT 0,
  `disable_notify` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`device_id`),
  KEY `devices_sysname_index` (`sysName`),
  KEY `devices_os_index` (`os`),
  KEY `devices_status_index` (`status`),
  KEY `devices_last_polled_index` (`last_polled`),
  KEY `devices_last_poll_attempted_index` (`last_poll_attempted`),
  KEY `devices_hostname_sysname_display_index` (`hostname`,`sysName`,`display`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES
(41,'2023-02-14 13:53:53','172.16.0.1','r1',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.9.1.620','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\r\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team',NULL,'15.3(3)XB12, RELEASE SOFTWARE (fc2)','CISCO1841','ADVIPSERVICESK9',NULL,'ios',1,'',0,0,101350,0,'2023-02-14 14:16:15',NULL,3.92,109.04,'2023-02-14 14:15:18',NULL,1.39,NULL,'network','FCZ140890CV','cisco.svg',0,0,NULL,1,0,0),
(44,'2023-02-14 13:53:54','172.16.0.2','r2',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.9.1.620','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\r\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team',NULL,'15.3(3)XB12, RELEASE SOFTWARE (fc2)','CISCO1841','ADVIPSERVICESK9',NULL,'ios',1,'',0,0,101350,0,'2023-02-14 14:16:19',NULL,4.77,182.96,'2023-02-14 14:13:29',NULL,7.29,NULL,'network','FCZ104612C6','cisco.svg',0,0,NULL,1,0,0),
(45,'2023-02-14 13:53:54','172.16.0.6','r3',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.9.1.620','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\r\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team',NULL,'15.3(3)XB12, RELEASE SOFTWARE (fc2)','CISCO1841','ADVIPSERVICESK9',NULL,'ios',1,'',0,0,101354,0,'2023-02-14 14:16:20',NULL,6.19,202.42,'2023-02-14 14:10:26',NULL,8.89,NULL,'network','FCZ104612CA','cisco.svg',0,0,NULL,1,0,0),
(46,'2023-02-14 13:53:54','192.168.1.10','b301-08',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.311.1.1.3.1.1','Hardware: Intel64 Family 6 Model 60 Stepping 3 AT/AT COMPATIBLE - Software: Windows Version 6.3 (Build 19045 Multiprocessor Free)',NULL,NULL,'Intel x64','Multiprocessor',NULL,'windows',1,'',0,0,101722,0,'2023-02-14 14:16:17',NULL,2.09,22.34,'2023-02-14 14:07:04',NULL,0.95,NULL,'server',NULL,'windows.svg',0,0,NULL,1,0,0),
(48,'2023-02-14 13:55:17','192.168.2.10','b301-09',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.8072.3.2.10','Linux b301-09 5.17.0-kali3-amd64 #1 SMP PREEMPT Debian 5.17.11-1kali1 (2022-05-30) x86_64','Me <me@example.org>','5.17.0-kali3-amd64','Generic x86 64-bit',NULL,1,'linux',1,'',0,0,101690,0,'2023-02-14 14:16:36',NULL,2.08,9.27,'2023-02-14 14:06:41',NULL,0.99,NULL,'server',NULL,'linux.svg',0,0,NULL,1,0,0),
(49,'2023-02-14 13:56:38','192.168.99.102','sw2',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.9.1.1021','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\r\nCompiled Wed 13-May-15 23:32 by prod_rel_team',NULL,'15.0(2)SE8','WS-C3560V2-24PS-S','IPSERVICESK9',NULL,'ios',1,'',0,0,101297,0,'2023-02-14 14:15:55',NULL,4.51,11.54,'2023-02-14 14:06:32',NULL,0.99,NULL,'network','FDO1415Y0DL','cisco.svg',0,0,NULL,1,0,0),
(50,'2023-02-14 13:56:38','192.168.99.101','sw1',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.9.1.1021','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2012 by Cisco Systems, Inc.\r\nCompiled Sat 28-Jul-12 00:01 by prod_rel_team',NULL,'15.0(2)SE','WS-C3560V2-24PS-S','IPSERVICESK9',NULL,'ios',1,'',0,0,101298,0,'2023-02-14 14:15:55',NULL,4.75,15.93,'2023-02-14 14:06:21',NULL,1.28,NULL,'network','FDO1415Y0DM','cisco.svg',0,0,NULL,1,0,0),
(51,'2023-02-14 13:56:39','192.168.99.104','sw4',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.9.1.716','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE5, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\r\nCompiled Fri 25-Oct-13 13:34 by prod_rel_team',NULL,'15.0(2)SE5','WS-C2960-24TT-L','LANBASEK9',NULL,'ios',1,'',0,0,101323,0,'2023-02-14 14:15:57',NULL,4.54,15.83,'2023-02-14 14:06:05',NULL,1.00,NULL,'network','FOC1245Z2JD','cisco.svg',0,0,NULL,1,0,0),
(52,'2023-02-14 13:56:40','192.168.99.103','sw3',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.9.1.716','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\r\nCompiled Thu 14-May-15 02:39 by prod_rel_team',NULL,'15.0(2)SE8','WS-C2960-24TT-L','LANBASEK9',NULL,'ios',1,'',0,0,101325,0,'2023-02-14 14:15:58',NULL,4.21,11.12,'2023-02-14 14:05:49',NULL,1.85,NULL,'network','FOC1245Y15Q','cisco.svg',0,0,NULL,1,0,0),
(53,'2023-02-14 13:56:40','192.168.99.105','sw5',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,'v2c',161,'udp',NULL,NULL,0,NULL,'.1.3.6.1.4.1.9.1.1021','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\r\nCompiled Wed 13-May-15 23:32 by prod_rel_team',NULL,'15.0(2)SE8','WS-C3560V2-24PS-S','IPSERVICESK9',NULL,'ios',1,'',0,0,101286,0,'2023-02-14 14:15:57',NULL,4.28,22.15,'2023-02-14 13:57:08',NULL,0.92,NULL,'network','FDO1415Y0DS','cisco.svg',0,0,NULL,1,0,0);
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipv4_addresses`
--

DROP TABLE IF EXISTS `ipv4_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipv4_addresses` (
  `ipv4_address_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ipv4_address` varchar(32) NOT NULL,
  `ipv4_prefixlen` int(11) NOT NULL,
  `ipv4_network_id` varchar(32) NOT NULL,
  `port_id` int(10) unsigned NOT NULL,
  `context_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ipv4_address_id`),
  KEY `ipv4_addresses_port_id_index` (`port_id`)
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipv4_addresses`
--

LOCK TABLES `ipv4_addresses` WRITE;
/*!40000 ALTER TABLE `ipv4_addresses` DISABLE KEYS */;
INSERT INTO `ipv4_addresses` VALUES
(118,'127.0.0.1',8,'2',876,''),
(119,'192.168.1.10',24,'1',878,''),
(126,'172.16.0.1',30,'5',924,''),
(127,'172.16.0.5',30,'8',925,''),
(129,'192.168.1.1',24,'1',932,''),
(131,'192.168.1.100',24,'1',932,''),
(132,'192.168.2.2',24,'7',933,''),
(134,'192.168.2.100',24,'7',933,''),
(136,'192.168.99.1',24,'10',934,''),
(138,'192.168.99.100',24,'10',934,''),
(141,'172.16.0.2',30,'5',950,''),
(142,'172.16.0.9',30,'6',951,''),
(143,'192.168.1.2',24,'1',958,''),
(144,'192.168.2.1',24,'7',963,''),
(145,'192.168.99.2',24,'10',966,''),
(147,'8.8.8.8',24,'9',982,''),
(149,'172.16.0.6',30,'8',974,''),
(151,'172.16.0.10',30,'6',975,''),
(152,'127.0.0.1',8,'2',1018,''),
(153,'192.168.2.10',24,'7',1020,''),
(154,'192.168.31.109',24,'11',1019,''),
(155,'192.168.99.102',24,'10',1023,''),
(156,'192.168.99.101',24,'10',1053,''),
(157,'192.168.99.104',24,'10',1085,''),
(158,'192.168.99.103',24,'10',1190,''),
(159,'192.168.99.105',24,'10',1222,'');
/*!40000 ALTER TABLE `ipv4_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipv4_mac`
--

DROP TABLE IF EXISTS `ipv4_mac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipv4_mac` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `port_id` int(10) unsigned NOT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `mac_address` varchar(32) NOT NULL,
  `ipv4_address` varchar(32) NOT NULL,
  `context_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ipv4_mac_port_id_index` (`port_id`),
  KEY `ipv4_mac_mac_address_index` (`mac_address`)
) ENGINE=InnoDB AUTO_INCREMENT=452 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipv4_mac`
--

LOCK TABLES `ipv4_mac` WRITE;
/*!40000 ALTER TABLE `ipv4_mac` DISABLE KEYS */;
INSERT INTO `ipv4_mac` VALUES
(338,878,46,'ec447682dae0','192.168.1.1',''),
(339,878,46,'001a2f3eb128','192.168.1.2',''),
(340,878,46,'00000c07ac0a','192.168.1.100',''),
(341,878,46,'9c4e20ae3d40','192.168.1.101',''),
(342,878,46,'0023ead39c41','192.168.1.104',''),
(343,878,46,'9c4e20ae3f40','192.168.1.105',''),
(344,878,46,'ffffffffffff','192.168.1.255',''),
(345,878,46,'01005e000002','224.0.0.2',''),
(346,878,46,'01005e000016','224.0.0.22',''),
(347,878,46,'01005e0000fb','224.0.0.251',''),
(348,878,46,'01005e0000fc','224.0.0.252',''),
(349,878,46,'01005e7ffffa','239.255.255.250',''),
(362,932,41,'ec447682dae0','192.168.1.1',''),
(363,932,41,'001a2f3eb128','192.168.1.2',''),
(364,932,41,'00e04c681272','192.168.1.10',''),
(365,932,41,'00000c07ac0a','192.168.1.100',''),
(366,933,41,'001a2f3eb128','192.168.2.1',''),
(367,933,41,'ec447682dae0','192.168.2.2',''),
(368,933,41,'00e04c68114e','192.168.2.10',''),
(369,933,41,'00000c07ac14','192.168.2.100',''),
(370,934,41,'ec447682dae0','192.168.99.1',''),
(371,934,41,'001a2f3eb128','192.168.99.2',''),
(372,934,41,'68f728ee84dc','192.168.99.99',''),
(373,934,41,'00000c07ac63','192.168.99.100',''),
(386,958,44,'ec447682dae0','192.168.1.1',''),
(387,958,44,'001a2f3eb128','192.168.1.2',''),
(388,958,44,'00e04c681272','192.168.1.10',''),
(389,963,44,'001a2f3eb128','192.168.2.1',''),
(390,963,44,'ec447682dae0','192.168.2.2',''),
(391,963,44,'00e04c68114e','192.168.2.10',''),
(392,966,44,'ec447682dae0','192.168.99.1',''),
(393,966,44,'001a2f3eb128','192.168.99.2',''),
(394,966,44,'68f728ee84dc','192.168.99.99',''),
(395,966,44,'9c4e20ae3d41','192.168.99.101',''),
(396,966,44,'0023ea938ec2','192.168.99.103',''),
(397,966,44,'0023ead39c42','192.168.99.104',''),
(398,1019,48,'906cacec2094','192.168.31.1',''),
(399,1020,48,'001a2f3eb128','192.168.2.1',''),
(400,1020,48,'ec447682dae0','192.168.2.2',''),
(401,1020,48,'00000c07ac14','192.168.2.100',''),
(402,1023,49,'001a2f3eb128','192.168.1.10',''),
(403,1023,49,'68f728ee84dc','192.168.99.99',''),
(404,1023,49,'9c4e20ae3d41','192.168.99.101',''),
(405,1023,49,'9c4e20ae3bc2','192.168.99.102',''),
(406,1023,49,'0023ea938ec2','192.168.99.103',''),
(407,1023,49,'0023ead39c42','192.168.99.104',''),
(408,1023,49,'9c4e20ae3f41','192.168.99.105',''),
(409,1053,50,'ec447682dae0','192.168.1.10',''),
(410,1053,50,'ec447682dae0','192.168.1.99',''),
(411,1053,50,'001a2f3eb128','192.168.2.1',''),
(412,1053,50,'00000c07ac63','192.168.2.10',''),
(413,1053,50,'68f728ee84dc','192.168.99.99',''),
(414,1053,50,'9c4e20ae3d41','192.168.99.101',''),
(415,1053,50,'9c4e20ae3bc2','192.168.99.102',''),
(416,1053,50,'0023ea938ec2','192.168.99.103',''),
(417,1053,50,'0023ead39c42','192.168.99.104',''),
(418,1053,50,'9c4e20ae3f41','192.168.99.105',''),
(419,1189,52,'ec447682dae0','192.168.2.2',''),
(420,1189,52,'00e04c68114e','192.168.2.10',''),
(421,1190,52,'001a2f3eb128','192.168.1.10',''),
(422,1190,52,'00000c07ac63','192.168.2.1',''),
(423,1190,52,'68f728ee84dc','192.168.99.99',''),
(424,1190,52,'9c4e20ae3d41','192.168.99.101',''),
(425,1190,52,'9c4e20ae3bc2','192.168.99.102',''),
(426,1190,52,'0023ea938ec2','192.168.99.103',''),
(427,1190,52,'0023ead39c42','192.168.99.104',''),
(428,1190,52,'9c4e20ae3f41','192.168.99.105',''),
(429,1219,53,'00e04c681272','192.168.1.10',''),
(430,1220,53,'00e04c68114e','192.168.2.10',''),
(431,1222,53,'68f728ee84dc','192.168.99.99',''),
(432,1222,53,'9c4e20ae3d41','192.168.99.101',''),
(433,1222,53,'9c4e20ae3bc2','192.168.99.102',''),
(434,1222,53,'0023ea938ec2','192.168.99.103',''),
(435,1222,53,'0023ead39c42','192.168.99.104',''),
(436,1222,53,'9c4e20ae3f41','192.168.99.105',''),
(437,1082,51,'ec447682dae0','192.168.1.1',''),
(438,1082,51,'001a2f3eb128','192.168.1.2',''),
(439,1082,51,'00e04c681272','192.168.1.10',''),
(440,1084,51,'ec447682dae0','192.168.2.2',''),
(441,1084,51,'00e04c68114e','192.168.2.10',''),
(442,1085,51,'ec447682dae0','192.168.1.99',''),
(443,1085,51,'00000c07ac63','192.168.2.1',''),
(444,1085,51,'68f728ee84dc','192.168.99.99',''),
(445,1085,51,'9c4e20ae3d41','192.168.99.101',''),
(446,1085,51,'9c4e20ae3bc2','192.168.99.102',''),
(447,1085,51,'0023ea938ec2','192.168.99.103',''),
(448,1085,51,'0023ead39c42','192.168.99.104',''),
(449,1085,51,'9c4e20ae3f41','192.168.99.105',''),
(450,934,41,'9c4e20ae3d41','192.168.99.101',''),
(451,934,41,'0023ea938ec2','192.168.99.103','');
/*!40000 ALTER TABLE `ipv4_mac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipv4_networks`
--

DROP TABLE IF EXISTS `ipv4_networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipv4_networks` (
  `ipv4_network_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ipv4_network` varchar(64) NOT NULL,
  `context_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ipv4_network_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipv4_networks`
--

LOCK TABLES `ipv4_networks` WRITE;
/*!40000 ALTER TABLE `ipv4_networks` DISABLE KEYS */;
INSERT INTO `ipv4_networks` VALUES
(1,'192.168.1.0/24',''),
(2,'127.0.0.0/8',''),
(3,'172.17.0.0/16',''),
(4,'172.18.0.0/16',''),
(5,'172.16.0.0/30',''),
(6,'172.16.0.8/30',''),
(7,'192.168.2.0/24',''),
(8,'172.16.0.4/30',''),
(9,'8.8.8.8/32',''),
(10,'192.168.99.0/24',''),
(11,'192.168.31.0/24','');
/*!40000 ALTER TABLE `ipv4_networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `links`
--

DROP TABLE IF EXISTS `links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `links` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `local_port_id` int(10) unsigned DEFAULT NULL,
  `local_device_id` int(10) unsigned NOT NULL,
  `remote_port_id` int(10) unsigned DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `protocol` varchar(11) DEFAULT NULL,
  `remote_hostname` varchar(128) NOT NULL,
  `remote_device_id` int(10) unsigned NOT NULL,
  `remote_port` varchar(128) NOT NULL,
  `remote_platform` varchar(256) DEFAULT NULL,
  `remote_version` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `local_device_id` (`local_device_id`,`remote_device_id`),
  KEY `links_local_port_id_index` (`local_port_id`),
  KEY `links_remote_port_id_index` (`remote_port_id`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `links`
--

LOCK TABLES `links` WRITE;
/*!40000 ALTER TABLE `links` DISABLE KEYS */;
INSERT INTO `links` VALUES
(93,922,41,1110,1,'cdp','SW4',51,'FastEthernet0/13','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE5, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Fri 25-Oct-13 13:34 by prod_rel_team'),
(94,924,41,950,1,'cdp','R2',44,'Serial0/0/0','Cisco 1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team'),
(95,925,41,974,1,'cdp','R3',45,'Serial0/0/0','Cisco 1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team'),
(99,948,44,1204,1,'cdp','SW3',52,'FastEthernet0/14','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Thu 14-May-15 02:39 by prod_rel_team'),
(100,950,44,924,1,'cdp','R1',41,'Serial0/0/0','Cisco 1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team'),
(103,975,45,951,1,'cdp','R2',44,'Serial0/0/1','Cisco 1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team'),
(104,1035,49,1201,1,'cdp','SW3',52,'FastEthernet0/11','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Thu 14-May-15 02:39 by prod_rel_team'),
(105,1039,49,1069,1,'cdp','SW1',50,'FastEthernet0/15','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2012 by Cisco Systems, Inc.\nCompiled Sat 28-Jul-12 00:01 by prod_rel_team'),
(106,1040,49,1117,1,'cdp','SW4',51,'FastEthernet0/16','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE5, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Fri 25-Oct-13 13:34 by prod_rel_team'),
(107,1041,49,1071,1,'cdp','SW1',50,'FastEthernet0/17','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2012 by Cisco Systems, Inc.\nCompiled Sat 28-Jul-12 00:01 by prod_rel_team'),
(108,1064,50,1232,1,'cdp','SW5',53,'FastEthernet0/10','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Wed 13-May-15 23:32 by prod_rel_team'),
(109,1066,50,1104,1,'cdp','SW4',51,'FastEthernet0/10','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE5, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Fri 25-Oct-13 13:34 by prod_rel_team'),
(110,1104,51,1066,1,'cdp','SW1',50,'FastEthernet0/12','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2012 by Cisco Systems, Inc.\nCompiled Sat 28-Jul-12 00:01 by prod_rel_team'),
(111,1069,50,1039,1,'cdp','SW2',49,'FastEthernet0/15','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Wed 13-May-15 23:32 by prod_rel_team'),
(112,1106,51,1233,1,'cdp','SW5',53,'FastEthernet0/11','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Wed 13-May-15 23:32 by prod_rel_team'),
(113,1070,50,1206,1,'cdp','SW3',52,'FastEthernet0/16','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Thu 14-May-15 02:39 by prod_rel_team'),
(114,1071,50,1041,1,'cdp','SW2',49,'FastEthernet0/17','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Wed 13-May-15 23:32 by prod_rel_team'),
(115,1201,52,1035,1,'cdp','SW2',49,'FastEthernet0/11','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Wed 13-May-15 23:32 by prod_rel_team'),
(117,1205,52,1114,1,'cdp','SW4',51,'FastEthernet0/15','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE5, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Fri 25-Oct-13 13:34 by prod_rel_team'),
(118,1206,52,1070,1,'cdp','SW1',50,'FastEthernet0/16','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2012 by Cisco Systems, Inc.\nCompiled Sat 28-Jul-12 00:01 by prod_rel_team'),
(119,1232,53,1064,1,'cdp','SW1',50,'FastEthernet0/10','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2012 by Cisco Systems, Inc.\nCompiled Sat 28-Jul-12 00:01 by prod_rel_team'),
(120,1233,53,1106,1,'cdp','SW4',51,'FastEthernet0/11','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE5, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Fri 25-Oct-13 13:34 by prod_rel_team'),
(121,1110,51,922,1,'cdp','R1',41,'FastEthernet0/0','Cisco 1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team'),
(122,1114,51,1205,1,'cdp','SW3',52,'FastEthernet0/15','cisco WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Thu 14-May-15 02:39 by prod_rel_team'),
(123,1117,51,1040,1,'cdp','SW2',49,'FastEthernet0/16','cisco WS-C3560V2-24PS','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\nCompiled Wed 13-May-15 23:32 by prod_rel_team'),
(124,1204,52,948,1,'cdp','R2',44,'FastEthernet0/0','Cisco 1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team'),
(125,974,45,925,1,'cdp','R1',41,'Serial0/0/1','Cisco 1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team'),
(126,951,44,975,1,'cdp','R3',45,'Serial0/0/1','Cisco 1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)Technical Support: http://www.cisco.com/techsupport\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team'),
(127,1055,50,878,1,'lldp','b301-08',46,'eth0','Windows','11'),
(128,1025,49,1020,1,'lldp','b301-09',48,'eth0','Linux','1');
/*!40000 ALTER TABLE `links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ports`
--

DROP TABLE IF EXISTS `ports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ports` (
  `port_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned NOT NULL DEFAULT 0,
  `port_descr_type` varchar(255) DEFAULT NULL,
  `port_descr_descr` varchar(255) DEFAULT NULL,
  `port_descr_circuit` varchar(255) DEFAULT NULL,
  `port_descr_speed` varchar(32) DEFAULT NULL,
  `port_descr_notes` varchar(255) DEFAULT NULL,
  `ifDescr` varchar(255) DEFAULT NULL,
  `ifName` varchar(255) DEFAULT NULL,
  `portName` varchar(128) DEFAULT NULL,
  `ifIndex` bigint(20) DEFAULT 0,
  `ifSpeed` bigint(20) DEFAULT NULL,
  `ifSpeed_prev` bigint(20) DEFAULT NULL,
  `ifConnectorPresent` varchar(12) DEFAULT NULL,
  `ifPromiscuousMode` varchar(12) DEFAULT NULL,
  `ifOperStatus` varchar(16) DEFAULT NULL,
  `ifOperStatus_prev` varchar(16) DEFAULT NULL,
  `ifAdminStatus` varchar(16) DEFAULT NULL,
  `ifAdminStatus_prev` varchar(16) DEFAULT NULL,
  `ifDuplex` varchar(12) DEFAULT NULL,
  `ifMtu` int(11) DEFAULT NULL,
  `ifType` varchar(64) DEFAULT NULL,
  `ifAlias` varchar(255) DEFAULT NULL,
  `ifPhysAddress` varchar(64) DEFAULT NULL,
  `ifHardType` varchar(64) DEFAULT NULL,
  `ifLastChange` bigint(20) unsigned NOT NULL DEFAULT 0,
  `ifVlan` varchar(8) NOT NULL DEFAULT '',
  `ifTrunk` varchar(16) DEFAULT NULL,
  `ifVrf` int(11) NOT NULL DEFAULT 0,
  `counter_in` int(11) DEFAULT NULL,
  `counter_out` int(11) DEFAULT NULL,
  `ignore` tinyint(1) NOT NULL DEFAULT 0,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `detailed` tinyint(1) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `pagpOperationMode` varchar(32) DEFAULT NULL,
  `pagpPortState` varchar(16) DEFAULT NULL,
  `pagpPartnerDeviceId` varchar(48) DEFAULT NULL,
  `pagpPartnerLearnMethod` varchar(16) DEFAULT NULL,
  `pagpPartnerIfIndex` int(11) DEFAULT NULL,
  `pagpPartnerGroupIfIndex` int(11) DEFAULT NULL,
  `pagpPartnerDeviceName` varchar(128) DEFAULT NULL,
  `pagpEthcOperationMode` varchar(16) DEFAULT NULL,
  `pagpDeviceId` varchar(48) DEFAULT NULL,
  `pagpGroupIfIndex` int(11) DEFAULT NULL,
  `ifInUcastPkts` bigint(20) unsigned DEFAULT NULL,
  `ifInUcastPkts_prev` bigint(20) unsigned DEFAULT NULL,
  `ifInUcastPkts_delta` bigint(20) unsigned DEFAULT NULL,
  `ifInUcastPkts_rate` bigint(20) unsigned DEFAULT NULL,
  `ifOutUcastPkts` bigint(20) unsigned DEFAULT NULL,
  `ifOutUcastPkts_prev` bigint(20) unsigned DEFAULT NULL,
  `ifOutUcastPkts_delta` bigint(20) unsigned DEFAULT NULL,
  `ifOutUcastPkts_rate` bigint(20) unsigned DEFAULT NULL,
  `ifInErrors` bigint(20) unsigned DEFAULT NULL,
  `ifInErrors_prev` bigint(20) unsigned DEFAULT NULL,
  `ifInErrors_delta` bigint(20) unsigned DEFAULT NULL,
  `ifInErrors_rate` bigint(20) unsigned DEFAULT NULL,
  `ifOutErrors` bigint(20) unsigned DEFAULT NULL,
  `ifOutErrors_prev` bigint(20) unsigned DEFAULT NULL,
  `ifOutErrors_delta` bigint(20) unsigned DEFAULT NULL,
  `ifOutErrors_rate` bigint(20) unsigned DEFAULT NULL,
  `ifInOctets` bigint(20) unsigned DEFAULT NULL,
  `ifInOctets_prev` bigint(20) unsigned DEFAULT NULL,
  `ifInOctets_delta` bigint(20) unsigned DEFAULT NULL,
  `ifInOctets_rate` bigint(20) unsigned DEFAULT NULL,
  `ifOutOctets` bigint(20) unsigned DEFAULT NULL,
  `ifOutOctets_prev` bigint(20) unsigned DEFAULT NULL,
  `ifOutOctets_delta` bigint(20) unsigned DEFAULT NULL,
  `ifOutOctets_rate` bigint(20) unsigned DEFAULT NULL,
  `poll_time` int(10) unsigned DEFAULT NULL,
  `poll_prev` int(10) unsigned DEFAULT NULL,
  `poll_period` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`port_id`),
  UNIQUE KEY `ports_device_id_ifindex_unique` (`device_id`,`ifIndex`),
  KEY `ports_ifalias_port_descr_descr_portname_index` (`ifAlias`,`port_descr_descr`,`portName`),
  KEY `ports_ifdescr_ifname_index` (`ifDescr`,`ifName`)
) ENGINE=InnoDB AUTO_INCREMENT=1312 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ports`
--

LOCK TABLES `ports` WRITE;
/*!40000 ALTER TABLE `ports` DISABLE KEYS */;
INSERT INTO `ports` VALUES
(876,46,NULL,NULL,NULL,NULL,NULL,'Software Loopback Interface 1.','loopback_0',NULL,1,1073000000,1073000000,'false','false','up','up','up','up',NULL,1500,'softwareLoopback','Loopback Pseudo-Interface 1',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(877,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (IPv6).','ethernet_32774',NULL,2,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 7',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(878,46,NULL,NULL,NULL,NULL,NULL,'Realtek PCIe GbE Family Controller.','ethernet_32781',NULL,4,100000000,100000000,'true','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Ethernet 4','00e04c681272',NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5180104,5178127,1977,7,3538052,3536075,1977,7,0,0,0,0,0,0,0,0,402120094,401936883,183211,613,294480020,294289570,190450,637,1676384176,1676383877,299),
(879,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (PPPOE).','ppp_32768',NULL,5,0,0,'false','false','down','down','up','up',NULL,1494,'ppp','Lokálne pripojenie* 5',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(880,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (L2TP).','tunnel_32770',NULL,7,0,0,'false','false','down','down','up','up',NULL,1460,'tunnel','Lokálne pripojenie* 3',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(881,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (PPTP).','tunnel_32771',NULL,13,0,0,'false','false','down','down','up','up',NULL,1464,'tunnel','Lokálne pripojenie* 4',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(882,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (IP).','ethernet_32773',NULL,14,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 6',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(883,46,NULL,NULL,NULL,NULL,NULL,'Realtek PCIe GbE Family Controller #2.','ethernet_32782',NULL,18,1000000000,1000000000,'true','false','down','down','down','down',NULL,1500,'ethernetCsmacd','Ethernet 5','fcaa144b540a',NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,NULL),
(884,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (IKEv2).','tunnel_32769',NULL,21,0,0,'false','false','down','down','up','up',NULL,1480,'tunnel','Lokálne pripojenie* 2',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(885,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (Network Monitor).','ethernet_32775',NULL,22,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 8',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(886,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (SSTP).','tunnel_32768',NULL,23,0,0,'false','false','down','down','up','up',NULL,4091,'tunnel','Lokálne pripojenie* 1',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(887,46,NULL,NULL,NULL,NULL,NULL,'Realtek PCIe GbE Family Controller-WFP Native MAC Layer LightWeight Filter-0000.','ethernet_0',NULL,25,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Ethernet 4-WFP Native MAC Layer LightWeight Filter-0000','00e04c681272',NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5180104,5178127,1977,7,3538052,3536075,1977,7,0,0,0,0,0,0,0,0,402120094,401936883,183211,613,294480020,294289570,190450,637,1676384176,1676383877,299),
(888,46,'ethernet 4-npcap packet driver','NPCAP',NULL,NULL,'NPCAP','Realtek PCIe GbE Family Controller-Npcap Packet Driver (NPCAP)-0000.','ethernet_1',NULL,26,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Ethernet 4-Npcap Packet Driver (NPCAP)-0000','00e04c681272',NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5180104,5178127,1977,7,3538052,3536075,1977,7,0,0,0,0,0,0,0,0,402120094,401936883,183211,613,294480020,294289570,190450,637,1676384176,1676383877,299),
(889,46,NULL,NULL,NULL,NULL,NULL,'Realtek PCIe GbE Family Controller-WFP 802.3 MAC Layer LightWeight Filter-0000.','ethernet_4',NULL,29,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Ethernet 4-WFP 802.3 MAC Layer LightWeight Filter-0000','00e04c681272',NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5180104,5178127,1977,7,3538052,3536075,1977,7,0,0,0,0,0,0,0,0,402120094,401936883,183211,613,294480020,294289570,190450,637,1676384176,1676383877,299),
(890,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (IP)-WFP Native MAC Layer LightWeight Filter-0000.','ethernet_5',NULL,30,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 6-WFP Native MAC Layer LightWeight Filter-00',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(891,46,'lokálne pripojenie* 6-npcap packet driver','NPCAP',NULL,NULL,'NPCAP','WAN Miniport (IP)-Npcap Packet Driver (NPCAP)-0000.','ethernet_6',NULL,31,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 6-Npcap Packet Driver (NPCAP)-0000',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(892,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (IPv6)-WFP Native MAC Layer LightWeight Filter-0000.','ethernet_8',NULL,33,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 7-WFP Native MAC Layer LightWeight Filter-00',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(893,46,'lokálne pripojenie* 7-npcap packet driver','NPCAP',NULL,NULL,'NPCAP','WAN Miniport (IPv6)-Npcap Packet Driver (NPCAP)-0000.','ethernet_9',NULL,34,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 7-Npcap Packet Driver (NPCAP)-0000',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(894,46,NULL,NULL,NULL,NULL,NULL,'WAN Miniport (Network Monitor)-WFP Native MAC Layer LightWeight Filter-0000.','ethernet_11',NULL,36,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 8-WFP Native MAC Layer LightWeight Filter-00',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(895,46,'lokálne pripojenie* 8-npcap packet driver','NPCAP',NULL,NULL,'NPCAP','WAN Miniport (Network Monitor)-Npcap Packet Driver (NPCAP)-0000.','ethernet_12',NULL,37,0,0,'false','false','up','up','up','up',NULL,1500,'ethernetCsmacd','Lokálne pripojenie* 8-Npcap Packet Driver (NPCAP)-0000',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384176,1676383877,299),
(922,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0','Fa0/0',NULL,1,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/0','ec447682dae0',NULL,9859875,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3137885,3130164,7721,26,3965458,3958588,6870,23,0,0,0,0,0,0,0,0,310405161,309599872,805289,2684,364782781,364004509,778272,2594,1676384174,1676383874,300),
(923,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1','Fa0/1',NULL,2,100000000,100000000,'true','false','down','down','down','down','unknown',1500,'ethernetCsmacd','FastEthernet0/1','ec447682dae1',NULL,1724550,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,1487,1487,0,0,0,0,0,0,0,0,0,0,0,0,0,0,90382,90382,0,0,1676384174,1676383874,NULL),
(924,41,NULL,NULL,NULL,NULL,NULL,'Serial0/0/0','Se0/0/0',NULL,3,2000000,2000000,'true','false','up','up','up','up',NULL,1500,'propPointToPointSerial','Serial0/0/0',NULL,NULL,1755226,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384174,1676383874,300),
(925,41,NULL,NULL,NULL,NULL,NULL,'Serial0/0/1','Se0/0/1',NULL,4,2000000,2000000,'true','false','up','up','up','up',NULL,1500,'propPointToPointSerial','Serial0/0/1',NULL,NULL,263682,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384174,1676383874,300),
(926,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/0','Fa0/1/0',NULL,5,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/0','0017e0954b00',NULL,55530,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384174,1676383874,NULL),
(927,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/1','Fa0/1/1',NULL,6,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/1','0017e0954b01',NULL,55530,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384174,1676383874,NULL),
(928,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/2','Fa0/1/2',NULL,7,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/2','0017e0954b02',NULL,55530,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384174,1676383874,NULL),
(929,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/3','Fa0/1/3',NULL,8,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/3','0017e0954b03',NULL,55530,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384174,1676383874,NULL),
(930,41,NULL,NULL,NULL,NULL,NULL,'Null0','Nu0',NULL,9,10000000000,10000000000,'false','false','up','up','up','up',NULL,1500,'other','Null0',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384174,1676383874,300),
(931,41,NULL,NULL,NULL,NULL,NULL,'Vlan1','Vl1',NULL,10,100000000,100000000,'false','false','down','down','up','up','unknown',1500,'propVirtual','Vlan1','ec447682dae0',NULL,4794,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384174,1676383874,NULL),
(932,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0.10','Fa0/0.10',NULL,13,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'l2vlan','FastEthernet0/0.10','ec447682dae0',NULL,9859577,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1210211,1207631,2580,9,1941484,1940390,1094,4,0,0,0,0,0,0,0,0,84943225,84673909,269316,898,120026556,119918408,108148,360,1676384174,1676383874,300),
(933,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0.20','Fa0/0.20',NULL,14,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'l2vlan','FastEthernet0/0.20','ec447682dae0',NULL,9859577,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1697239,1696327,912,3,1891982,1888337,3645,12,0,0,0,0,0,0,0,0,201098249,200994385,103864,346,218055582,217687626,367956,1227,1676384174,1676383874,300),
(934,41,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0.99','Fa0/0.99',NULL,15,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'l2vlan','FastEthernet0/0.99','ec447682dae0',NULL,9859577,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,240926,236703,4223,14,122099,120001,2098,7,0,0,0,0,0,0,0,0,24256538,23827237,429301,1431,16561883,16264973,296910,990,1676384174,1676383874,300),
(948,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0','Fa0/0',NULL,1,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/0','001a2f3eb128',NULL,1176847,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2629288,2624669,4619,15,3454804,3449498,5306,18,0,0,0,0,0,0,0,0,267650135,267153059,497076,1657,324280927,323660671,620256,2068,1676384178,1676383878,300),
(949,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1','Fa0/1',NULL,2,100000000,100000000,'true','false','down','down','down','down','unknown',1500,'ethernetCsmacd','FastEthernet0/1','001a2f3eb129',NULL,994483,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,738,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,45437,0,NULL,NULL,1676384178,1676383878,NULL),
(950,44,NULL,NULL,NULL,NULL,NULL,'Serial0/0/0','Se0/0/0',NULL,3,0,0,'true','false','up','up','up','up',NULL,1500,'propPointToPointSerial','Serial0/0/0',NULL,NULL,1754740,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384178,1676383878,300),
(951,44,NULL,NULL,NULL,NULL,NULL,'Serial0/0/1','Se0/0/1',NULL,4,0,0,'true','false','up','up','up','up',NULL,1500,'propPointToPointSerial','Serial0/0/1',NULL,NULL,263379,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384178,1676383878,300),
(952,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/0','Fa0/1/0',NULL,5,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/0','002290d63517',NULL,93566,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384178,1676383878,NULL),
(953,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/1','Fa0/1/1',NULL,6,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/1','002290d63518',NULL,93566,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384178,1676383878,NULL),
(954,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/2','Fa0/1/2',NULL,7,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/2','002290d63519',NULL,93566,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384178,1676383878,NULL),
(955,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/3','Fa0/1/3',NULL,8,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/3','002290d6351a',NULL,93566,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384178,1676383878,NULL),
(956,44,NULL,NULL,NULL,NULL,NULL,'Null0','Nu0',NULL,9,10000000000,10000000000,'false','false','up','up','up','up',NULL,1500,'other','Null0',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384178,1676383878,300),
(957,44,NULL,NULL,NULL,NULL,NULL,'Vlan1','Vl1',NULL,10,100000000,100000000,'false','false','down','down','up','up','unknown',1500,'propVirtual','Vlan1','001a2f3eb128',NULL,3893,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384178,1676383878,NULL),
(958,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0.10','Fa0/0.10',NULL,13,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'l2vlan','FastEthernet0/0.10','001a2f3eb128',NULL,1176632,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2394963,2394961,2,0,3306543,3305064,1479,5,0,0,0,0,0,0,0,0,240319516,240306245,13271,44,291956089,291808133,147956,493,1676384178,1676383878,300),
(963,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0.20','Fa0/0.20',NULL,14,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'l2vlan','FastEthernet0/0.20','001a2f3eb128',NULL,1277275,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,225196,220640,4556,15,19855,18640,1215,4,0,0,0,0,0,0,0,0,23250783,22784251,466532,1555,2998130,2863882,134248,447,1676384178,1676383878,300),
(966,44,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0.99','Fa0/0.99',NULL,15,100000000,100000000,'false','false','up','up','up','up',NULL,1500,'l2vlan','FastEthernet0/0.99','001a2f3eb128',NULL,9812939,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,6770,6720,50,0,118137,115612,2525,8,0,0,0,0,0,0,0,0,2672077,2658506,13571,45,19901897,19579579,322318,1074,1676384178,1676383878,300),
(972,45,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/0','Fa0/0',NULL,1,100000000,100000000,'true','false','down','down','down','down','unknown',1500,'ethernetCsmacd','FastEthernet0/0','0019e87f38e4',NULL,104834,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384177,1676383878,NULL),
(973,45,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1','Fa0/1',NULL,2,100000000,100000000,'true','false','down','down','down','down','unknown',1500,'ethernetCsmacd','FastEthernet0/1','0019e87f38e5',NULL,104834,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384177,1676383878,NULL),
(974,45,NULL,NULL,NULL,NULL,NULL,'Serial0/0/0','Se0/0/0',NULL,3,0,0,'true','false','up','up','up','up',NULL,1500,'propPointToPointSerial','Serial0/0/0',NULL,NULL,263856,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384177,1676383878,299),
(975,45,NULL,NULL,NULL,NULL,NULL,'Serial0/0/1','Se0/0/1',NULL,4,0,0,'true','false','up','up','up','up',NULL,1500,'propPointToPointSerial','Serial0/0/1',NULL,NULL,264078,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384177,1676383878,299),
(976,45,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/0','Fa0/1/0',NULL,5,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/0','0011bb461039',NULL,105153,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384177,1676383878,NULL),
(977,45,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/1','Fa0/1/1',NULL,6,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/1','0011bb46103a',NULL,105153,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384177,1676383878,NULL),
(978,45,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/2','Fa0/1/2',NULL,7,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/2','0011bb46103b',NULL,105153,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384177,1676383878,NULL),
(979,45,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1/3','Fa0/1/3',NULL,8,100000000,100000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1/3','0011bb46103c',NULL,105153,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384177,1676383878,NULL),
(980,45,NULL,NULL,NULL,NULL,NULL,'Null0','Nu0',NULL,9,10000000000,10000000000,'false','false','up','up','up','up',NULL,1500,'other','Null0',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384177,1676383878,299),
(981,45,NULL,NULL,NULL,NULL,NULL,'Vlan1','Vl1',NULL,10,100000000,100000000,'false','false','down','down','up','up','unknown',1500,'propVirtual','Vlan1','0019e87f38e4',NULL,3939,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384177,1676383878,NULL),
(982,45,NULL,NULL,NULL,NULL,NULL,'Loopback0','Lo0',NULL,13,8000000000,8000000000,'false','false','up','up','up','up',NULL,1514,'softwareLoopback','Loopback0',NULL,NULL,107031,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384177,1676383878,299),
(1018,48,NULL,NULL,NULL,NULL,NULL,'lo','lo',NULL,1,10000000,10000000,'false','false','up','up','up','up',NULL,65536,'softwareLoopback','lo',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3311,3311,0,0,3311,3311,0,0,0,0,0,0,0,0,0,0,366916,366916,0,0,366916,366916,0,0,1676384196,1676383895,301),
(1019,48,NULL,NULL,NULL,NULL,NULL,'eth0','eth0',NULL,2,1000000000,1000000000,'true','false','down','up','up','up','fullDuplex',1500,'ethernetCsmacd','eth0','fcaa144b5414',NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2742,2732,10,0,1887,1876,11,0,0,0,0,0,0,0,0,0,489860,488080,1780,6,186469,185486,983,3,1676384196,1676383895,301),
(1020,48,NULL,NULL,NULL,NULL,NULL,'eth1','eth1',NULL,3,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','eth1','00e04c68114e',NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1792944,1788981,3963,13,1805898,1801325,4573,15,0,0,0,0,0,0,0,0,202513855,202125747,388108,1289,205716521,205263267,453254,1506,1676384196,1676383895,301),
(1021,49,NULL,NULL,NULL,NULL,NULL,'Vlan1','Vl1',NULL,1,1000000000,1000000000,'false','false','down','down','up','up',NULL,1500,'propVirtual','Vlan1','9c4e20ae3bc0',NULL,9041593,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2029,0,NULL,NULL,278,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,344956,0,NULL,NULL,83726,0,NULL,NULL,1676384154,1676383854,NULL),
(1022,49,NULL,NULL,NULL,NULL,NULL,'Vlan20','Vl20',NULL,20,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan20','9c4e20ae3bc1',NULL,481427,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24951,24659,292,1,80,80,0,0,0,0,0,0,0,0,0,0,2137319,2117253,20066,67,7106,7106,0,0,1676384154,1676383854,300),
(1023,49,NULL,NULL,NULL,NULL,NULL,'Vlan99','Vl99',NULL,99,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan99','9c4e20ae3bc2',NULL,924469,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,62634,61809,825,3,25277,24743,534,2,0,0,0,0,0,0,0,0,5302543,5230938,71605,239,4691936,4595960,95976,320,1676384154,1676383854,300),
(1024,49,NULL,NULL,NULL,NULL,NULL,'Port-channel1','Po1',NULL,5001,200000000,200000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Port-channel1','9c4e20ae3b91',NULL,9067138,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2124,2064,60,0,6136,5783,353,1,0,0,0,0,0,0,0,0,409536,398047,11489,38,3528899,3380528,148371,495,1676384154,1676383854,300),
(1025,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1','Fa0/1',NULL,10001,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/1','9c4e20ae3b83',NULL,998636,'20',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1802132,1797531,4601,15,1799909,1795906,4003,13,0,0,0,0,0,0,0,0,212959733,212485393,474340,1581,216371844,215931640,440204,1467,1676384154,1676383854,300),
(1026,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/2','Fa0/2',NULL,10002,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/2','9c4e20ae3b84',NULL,7438,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1027,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/3','Fa0/3',NULL,10003,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/3','9c4e20ae3b85',NULL,7438,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1028,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/4','Fa0/4',NULL,10004,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/4','9c4e20ae3b86',NULL,7438,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1029,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/5','Fa0/5',NULL,10005,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/5','9c4e20ae3b87',NULL,7438,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1030,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/6','Fa0/6',NULL,10006,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/6','9c4e20ae3b88',NULL,7438,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1031,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/7','Fa0/7',NULL,10007,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/7','9c4e20ae3b89',NULL,7438,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1032,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/8','Fa0/8',NULL,10008,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/8','9c4e20ae3b8a',NULL,7438,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1033,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/9','Fa0/9',NULL,10009,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/9','9c4e20ae3b8b',NULL,7438,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1034,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/10','Fa0/10',NULL,10010,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/10','9c4e20ae3b8c',NULL,7438,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1035,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/11','Fa0/11',NULL,10011,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/11','9c4e20ae3b8d',NULL,367977,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1847191,1842348,4843,16,1837500,1832322,5178,17,0,0,0,0,0,0,0,0,243681801,243061899,619902,2066,226984771,226387094,597677,1992,1676384154,1676383854,300),
(1036,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/12','Fa0/12',NULL,10012,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/12','9c4e20ae3b8e',NULL,7438,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1037,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/13','Fa0/13',NULL,10013,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/13','9c4e20ae3b8f',NULL,7438,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1038,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/14','Fa0/14',NULL,10014,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/14','9c4e20ae3b90',NULL,7438,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1039,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/15','Fa0/15',NULL,10015,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/15','9c4e20ae3b91',NULL,9065314,'',NULL,0,NULL,NULL,0,0,0,0,'automaticSilent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10133,10103,30,0,27770,27740,30,0,0,0,0,0,0,0,0,0,1772103,1766314,5789,19,23768979,23705520,63459,212,1676384154,1676383854,300),
(1040,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/16','Fa0/16',NULL,10016,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/16','9c4e20ae3b92',NULL,1532077,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,41954,41924,30,0,10149,10119,30,0,0,0,0,0,0,0,0,0,23874868,23764293,110575,369,2632239,2627374,4865,16,1676384154,1676383854,300),
(1041,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/17','Fa0/17',NULL,10017,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/17','9c4e20ae3b93',NULL,9065306,'',NULL,0,NULL,NULL,0,0,0,0,'automaticSilent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1099,1069,30,0,5046,4723,323,1,0,0,0,0,0,0,0,0,223823,218123,5700,19,1839251,1754339,84912,283,1676384154,1676383854,300),
(1042,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/18','Fa0/18',NULL,10018,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/18','9c4e20ae3b94',NULL,7439,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1043,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/19','Fa0/19',NULL,10019,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/19','9c4e20ae3b95',NULL,7439,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1044,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/20','Fa0/20',NULL,10020,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/20','9c4e20ae3b96',NULL,7439,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1045,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/21','Fa0/21',NULL,10021,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/21','9c4e20ae3b97',NULL,7439,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1046,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/22','Fa0/22',NULL,10022,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/22','9c4e20ae3b98',NULL,7439,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1047,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/23','Fa0/23',NULL,10023,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/23','9c4e20ae3b99',NULL,7439,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1048,49,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/24','Fa0/24',NULL,10024,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/24','9c4e20ae3b9a',NULL,7439,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1049,49,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/1','Gi0/1',NULL,10101,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/1','9c4e20ae3b81',NULL,7437,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1050,49,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/2','Gi0/2',NULL,10102,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/2','9c4e20ae3b82',NULL,7437,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383854,NULL),
(1051,49,NULL,NULL,NULL,NULL,NULL,'Null0','Nu0',NULL,10501,10000000000,10000000000,'false','false','up','up','up','up',NULL,1500,'other','Null0',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384154,1676383854,300),
(1052,50,NULL,NULL,NULL,NULL,NULL,'Vlan1','Vl1',NULL,1,1000000000,1000000000,'false','false','down','down','up','up',NULL,1500,'propVirtual','Vlan1','9c4e20ae3d40',NULL,9041724,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2040,0,NULL,NULL,831,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,397069,0,NULL,NULL,70888,0,NULL,NULL,1676384154,1676383855,NULL),
(1053,50,NULL,NULL,NULL,NULL,NULL,'Vlan99','Vl99',NULL,99,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan99','9c4e20ae3d41',NULL,797847,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,63648,62487,1161,4,36558,35693,865,3,0,0,0,0,0,0,0,0,5572391,5467504,104887,351,6151344,6009629,141715,474,1676384154,1676383855,299),
(1054,50,NULL,NULL,NULL,NULL,NULL,'Port-channel1','Po1',NULL,5001,200000000,200000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Port-channel1','9c4e20ae3d11',NULL,9067172,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,6138,5784,354,1,2124,2064,60,0,0,0,0,0,0,0,0,0,3529552,3381291,148261,496,410108,398619,11489,38,1676384154,1676383855,299),
(1055,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1','Fa0/1',NULL,10001,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/1','9c4e20ae3d03',NULL,5708,'10',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3537933,3535953,1980,7,5190490,5188480,2010,7,0,0,0,0,0,0,0,0,318691917,318493151,198766,665,428734886,428524781,210105,703,1676384154,1676383855,299),
(1056,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/2','Fa0/2',NULL,10002,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/2','9c4e20ae3d04',NULL,5407,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1057,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/3','Fa0/3',NULL,10003,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/3','9c4e20ae3d05',NULL,5407,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1058,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/4','Fa0/4',NULL,10004,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/4','9c4e20ae3d06',NULL,5407,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1059,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/5','Fa0/5',NULL,10005,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/5','9c4e20ae3d07',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1060,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/6','Fa0/6',NULL,10006,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/6','9c4e20ae3d08',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1061,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/7','Fa0/7',NULL,10007,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/7','9c4e20ae3d09',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1062,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/8','Fa0/8',NULL,10008,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/8','9c4e20ae3d0a',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1063,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/9','Fa0/9',NULL,10009,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/9','9c4e20ae3d0b',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1064,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/10','Fa0/10',NULL,10010,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/10','9c4e20ae3d0c',NULL,347363,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10118,10088,30,0,31726,31402,324,1,0,0,0,0,0,0,0,0,1717385,1712520,4865,16,25247430,25105897,141533,473,1676384154,1676383855,299),
(1065,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/11','Fa0/11',NULL,10011,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/11','9c4e20ae3d0d',NULL,5408,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1066,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/12','Fa0/12',NULL,10012,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/12','9c4e20ae3d0e',NULL,1532210,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,41954,41924,30,0,10153,10123,30,0,0,0,0,0,0,0,0,0,23882000,23771641,110359,369,2614584,2609724,4860,16,1676384154,1676383855,299),
(1067,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/13','Fa0/13',NULL,10013,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/13','9c4e20ae3d0f',NULL,5408,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1068,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/14','Fa0/14',NULL,10014,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/14','9c4e20ae3d10',NULL,5408,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1069,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/15','Fa0/15',NULL,10015,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/15','9c4e20ae3d11',NULL,9061480,'',NULL,0,NULL,NULL,0,0,0,0,'desirableSilent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27770,27740,30,0,10133,10103,30,0,0,0,0,0,0,0,0,0,23768979,23705736,63243,212,1772103,1766314,5789,19,1676384154,1676383855,299),
(1070,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/16','Fa0/16',NULL,10016,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/16','9c4e20ae3d12',NULL,347371,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5242690,5239504,3186,11,3579444,3576552,2892,10,0,0,0,0,0,0,0,0,468880343,468466428,413915,1384,341295910,340935259,360651,1206,1676384154,1676383855,299),
(1071,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/17','Fa0/17',NULL,10017,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/17','9c4e20ae3d13',NULL,9061512,'',NULL,0,NULL,NULL,0,0,0,0,'desirableSilent',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5047,4723,324,1,1099,1069,30,0,0,0,0,0,0,0,0,0,1839357,1754339,85018,284,223823,218123,5700,19,1676384154,1676383855,299),
(1072,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/18','Fa0/18',NULL,10018,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/18','9c4e20ae3d14',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1073,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/19','Fa0/19',NULL,10019,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/19','9c4e20ae3d15',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1074,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/20','Fa0/20',NULL,10020,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/20','9c4e20ae3d16',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1075,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/21','Fa0/21',NULL,10021,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/21','9c4e20ae3d17',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1076,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/22','Fa0/22',NULL,10022,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/22','9c4e20ae3d18',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1077,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/23','Fa0/23',NULL,10023,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/23','9c4e20ae3d19',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1078,50,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/24','Fa0/24',NULL,10024,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/24','9c4e20ae3d1a',NULL,5408,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1079,50,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/1','Gi0/1',NULL,10101,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/1','9c4e20ae3d01',NULL,5407,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1080,50,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/2','Gi0/2',NULL,10102,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/2','9c4e20ae3d02',NULL,5407,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384154,1676383855,NULL),
(1081,51,NULL,NULL,NULL,NULL,NULL,'Vlan1','Vl1',NULL,1,1000000000,1000000000,'false','false','down','down','up','up',NULL,1500,'propVirtual','Vlan1','0023ead39c40',NULL,831285,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2100,2100,0,0,455,455,0,0,0,0,0,0,0,0,0,0,346555,346555,0,0,99749,99749,0,0,1676384156,1676383855,NULL),
(1082,51,NULL,NULL,NULL,NULL,NULL,'Vlan10','Vl10',NULL,10,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan10','0023ead39c41',NULL,1537304,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24617,24283,334,1,67,67,0,0,0,0,0,0,0,0,0,0,2178085,2155457,22628,75,4334,4334,0,0,1676384156,1676383855,301),
(1083,50,NULL,NULL,NULL,NULL,NULL,'Null0','Nu0',NULL,10501,10000000000,10000000000,'false','false','up','up','up','up',NULL,1500,'other','Null0',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384154,1676383855,299),
(1084,51,NULL,NULL,NULL,NULL,NULL,'Vlan20','Vl20',NULL,20,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan20','0023ead39c43',NULL,1960714,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21277,20979,298,1,0,0,0,0,0,0,0,0,0,0,0,0,1884450,1863948,20502,68,0,0,0,0,1676384156,1676383855,301),
(1085,51,NULL,NULL,NULL,NULL,NULL,'Vlan99','Vl99',NULL,99,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan99','0023ead39c42',NULL,1537304,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,92931,91782,1149,4,52694,52135,559,2,0,0,0,0,0,0,0,0,7686565,7582745,103820,345,7209567,7100582,108985,362,1676384156,1676383855,301),
(1087,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1','Fa0/1',NULL,10001,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/1','0023ead39c01',NULL,10067845,'99',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,330064,323620,6444,21,310476,304229,6247,21,1,1,0,0,0,0,0,0,32260837,31620568,640269,2127,54501022,53461277,1039745,3454,1676384156,1676383855,301),
(1089,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/2','Fa0/2',NULL,10002,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/2','0023ead39c02',NULL,5664,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1091,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/3','Fa0/3',NULL,10003,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/3','0023ead39c03',NULL,5664,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1092,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/4','Fa0/4',NULL,10004,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/4','0023ead39c04',NULL,5664,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1093,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/5','Fa0/5',NULL,10005,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/5','0023ead39c05',NULL,5664,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1095,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/6','Fa0/6',NULL,10006,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/6','0023ead39c06',NULL,5664,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1097,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/7','Fa0/7',NULL,10007,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/7','0023ead39c07',NULL,5664,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1100,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/8','Fa0/8',NULL,10008,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/8','0023ead39c08',NULL,5664,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1102,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/9','Fa0/9',NULL,10009,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/9','0023ead39c09',NULL,5664,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1104,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/10','Fa0/10',NULL,10010,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/10','0023ead39c0a',NULL,1534407,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10153,10123,30,0,41954,41924,30,0,0,0,0,0,0,0,0,0,2614584,2609724,4860,16,23882496,23772318,110178,366,1676384156,1676383855,301),
(1106,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/11','Fa0/11',NULL,10011,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/11','0023ead39c0b',NULL,1534403,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,35280,34718,562,2,67491,66929,562,2,0,0,0,0,0,0,0,0,6405327,6305399,99928,332,26373217,26207496,165721,551,1676384156,1676383855,301),
(1108,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/12','Fa0/12',NULL,10012,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/12','0023ead39c0c',NULL,1533836,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1110,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/13','Fa0/13',NULL,10013,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/13','0023ead39c0d',NULL,9859354,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3916374,3909546,6828,23,3158666,3150884,7782,26,0,0,0,0,0,0,0,0,380905846,380098040,807806,2684,335784287,334906438,877849,2916,1676384156,1676383855,301),
(1112,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/14','Fa0/14',NULL,10014,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/14','0023ead39c0e',NULL,1533837,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1114,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/15','Fa0/15',NULL,10015,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/15','0023ead39c0f',NULL,1534418,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3109154,3101663,7491,25,3932881,3926366,6515,22,0,0,0,0,0,0,0,0,346524721,345458966,1065755,3541,374997601,374303402,694199,2306,1676384156,1676383855,301),
(1117,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/16','Fa0/16',NULL,10016,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/16','0023ead39c10',NULL,1534407,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,10149,10119,30,0,41954,41924,30,0,0,0,0,0,0,0,0,0,2632239,2627374,4865,16,23875364,23765186,110178,366,1676384156,1676383855,301),
(1119,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/17','Fa0/17',NULL,10017,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/17','0023ead39c11',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1121,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/18','Fa0/18',NULL,10018,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/18','0023ead39c12',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1123,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/19','Fa0/19',NULL,10019,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/19','0023ead39c13',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1125,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/20','Fa0/20',NULL,10020,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/20','0023ead39c14',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1128,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/21','Fa0/21',NULL,10021,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/21','0023ead39c15',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1132,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/22','Fa0/22',NULL,10022,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/22','0023ead39c16',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1134,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/23','Fa0/23',NULL,10023,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/23','0023ead39c17',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1137,51,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/24','Fa0/24',NULL,10024,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/24','0023ead39c18',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1138,51,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/1','Gi0/1',NULL,10101,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/1','0023ead39c19',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1141,51,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/2','Gi0/2',NULL,10102,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/2','0023ead39c1a',NULL,5665,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,NULL),
(1143,51,NULL,NULL,NULL,NULL,NULL,'Null0','Nu0',NULL,10501,10000000000,10000000000,'false','false','up','up','up','up',NULL,1500,'other','Null0',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383855,301),
(1188,52,NULL,NULL,NULL,NULL,NULL,'Vlan1','Vl1',NULL,1,1000000000,1000000000,'false','false','down','down','up','up',NULL,1500,'propVirtual','Vlan1','0023ea938ec0',NULL,932966,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2078,0,NULL,NULL,262,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,355938,0,NULL,NULL,79577,0,NULL,NULL,1676384157,1676383857,NULL),
(1189,52,NULL,NULL,NULL,NULL,NULL,'Vlan20','Vl20',NULL,20,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan20','0023ea938ec1',NULL,1018697,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,22983,22691,292,1,0,0,0,0,0,0,0,0,0,0,0,0,2016478,1996380,20098,67,0,0,0,0,1676384157,1676383857,300),
(1190,52,NULL,NULL,NULL,NULL,NULL,'Vlan99','Vl99',NULL,99,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan99','0023ea938ec2',NULL,944307,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,66348,65252,1096,4,25655,25139,516,2,0,0,0,0,0,0,0,0,5686258,5588820,97438,325,4699259,4607748,91511,305,1676384157,1676383857,300),
(1191,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1','Fa0/1',NULL,10001,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1','0023ea938e81',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1192,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/2','Fa0/2',NULL,10002,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/2','0023ea938e82',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1193,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/3','Fa0/3',NULL,10003,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/3','0023ea938e83',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1194,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/4','Fa0/4',NULL,10004,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/4','0023ea938e84',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1195,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/5','Fa0/5',NULL,10005,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/5','0023ea938e85',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1196,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/6','Fa0/6',NULL,10006,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/6','0023ea938e86',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1197,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/7','Fa0/7',NULL,10007,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/7','0023ea938e87',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1198,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/8','Fa0/8',NULL,10008,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/8','0023ea938e88',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1199,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/9','Fa0/9',NULL,10009,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/9','0023ea938e89',NULL,5699,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1200,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/10','Fa0/10',NULL,10010,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/10','0023ea938e8a',NULL,5699,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1201,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/11','Fa0/11',NULL,10011,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/11','0023ea938e8b',NULL,370387,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1837751,1832618,5133,17,1847439,1842639,4800,16,0,0,0,0,0,0,0,0,227048601,226460254,588347,1961,243707822,243093814,614008,2047,1676384157,1676383857,300),
(1202,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/12','Fa0/12',NULL,10012,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/12','0023ea938e8c',NULL,5700,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1203,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/13','Fa0/13',NULL,10013,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/13','0023ea938e8d',NULL,5700,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1204,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/14','Fa0/14',NULL,10014,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/14','0023ea938e8e',NULL,1177655,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3453442,3448196,5246,17,2644515,2639869,4646,15,0,0,0,0,0,0,0,0,338193157,337552937,640220,2134,290874132,290320919,553213,1844,1676384157,1676383857,300),
(1205,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/15','Fa0/15',NULL,10015,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/15','0023ea938e8f',NULL,1534510,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3933032,3926612,6420,21,3109307,3101915,7392,25,0,0,0,0,0,0,0,0,375012780,374328888,683892,2280,346563821,345525680,1038141,3460,1676384157,1676383857,300),
(1206,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/16','Fa0/16',NULL,10016,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/16','0023ea938e90',NULL,349648,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3579662,3576793,2869,10,5242909,5239748,3161,11,0,0,0,0,0,0,0,0,341354026,340997847,356179,1187,468902549,468492547,410002,1367,1676384157,1676383857,300),
(1207,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/17','Fa0/17',NULL,10017,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/17','0023ea938e91',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1208,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/18','Fa0/18',NULL,10018,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/18','0023ea938e92',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1209,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/19','Fa0/19',NULL,10019,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/19','0023ea938e93',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1210,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/20','Fa0/20',NULL,10020,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/20','0023ea938e94',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1211,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/21','Fa0/21',NULL,10021,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/21','0023ea938e95',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1212,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/22','Fa0/22',NULL,10022,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/22','0023ea938e96',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1213,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/23','Fa0/23',NULL,10023,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/23','0023ea938e97',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1214,52,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/24','Fa0/24',NULL,10024,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/24','0023ea938e98',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1215,52,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/1','Gi0/1',NULL,10101,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/1','0023ea938e99',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1216,52,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/2','Gi0/2',NULL,10102,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/2','0023ea938e9a',NULL,5700,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384157,1676383857,NULL),
(1217,52,NULL,NULL,NULL,NULL,NULL,'Null0','Nu0',NULL,10501,10000000000,10000000000,'false','false','up','up','up','up',NULL,1500,'other','Null0',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384157,1676383857,300),
(1218,53,NULL,NULL,NULL,NULL,NULL,'Vlan1','Vl1',NULL,1,1000000000,1000000000,'false','false','down','down','up','up',NULL,1500,'propVirtual','Vlan1','9c4e20ae3f40',NULL,839768,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2159,0,NULL,NULL,344,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,340509,0,NULL,NULL,95671,0,NULL,NULL,1676384156,1676383856,NULL),
(1219,53,NULL,NULL,NULL,NULL,NULL,'Vlan10','Vl10',NULL,10,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan10','9c4e20ae3f42',NULL,1961187,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,22084,21754,330,1,0,0,0,0,0,0,0,0,0,0,0,0,1950366,1928018,22348,74,0,0,0,0,1676384156,1676383856,300),
(1220,53,NULL,NULL,NULL,NULL,NULL,'Vlan20','Vl20',NULL,20,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan20','9c4e20ae3f43',NULL,1961267,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21259,20966,293,1,0,0,0,0,0,0,0,0,0,0,0,0,1882742,1862582,20160,67,0,0,0,0,1676384156,1676383856,300),
(1221,53,NULL,NULL,NULL,NULL,NULL,'Vlan30','Vl30',NULL,30,1000000000,1000000000,'false','false','down','down','up','up',NULL,1500,'propVirtual','Vlan30','9c4e20ae3f44',NULL,1957386,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1222,53,NULL,NULL,NULL,NULL,NULL,'Vlan99','Vl99',NULL,99,1000000000,1000000000,'false','false','up','up','up','up',NULL,1500,'propVirtual','Vlan99','9c4e20ae3f41',NULL,1533877,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,62271,61473,798,3,25109,24603,506,2,0,0,0,0,0,0,0,0,5282219,5214245,67974,227,4533391,4445261,88130,294,1676384156,1676383856,300),
(1223,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/1','Fa0/1',NULL,10001,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/1','9c4e20ae3f03',NULL,7430,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1224,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/2','Fa0/2',NULL,10002,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/2','9c4e20ae3f04',NULL,7430,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1225,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/3','Fa0/3',NULL,10003,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/3','9c4e20ae3f05',NULL,7430,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1226,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/4','Fa0/4',NULL,10004,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/4','9c4e20ae3f06',NULL,7430,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1227,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/5','Fa0/5',NULL,10005,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/5','9c4e20ae3f07',NULL,7430,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1228,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/6','Fa0/6',NULL,10006,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/6','9c4e20ae3f08',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1229,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/7','Fa0/7',NULL,10007,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/7','9c4e20ae3f09',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1230,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/8','Fa0/8',NULL,10008,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/8','9c4e20ae3f0a',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1231,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/9','Fa0/9',NULL,10009,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/9','9c4e20ae3f0b',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1232,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/10','Fa0/10',NULL,10010,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/10','9c4e20ae3f0c',NULL,345966,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,31727,31406,321,1,10118,10088,30,0,0,0,0,0,0,0,0,0,25248032,25107446,140586,469,1717385,1712520,4865,16,1676384156,1676383856,300),
(1233,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/11','Fa0/11',NULL,10011,100000000,100000000,'true','false','up','up','up','up','fullDuplex',1500,'ethernetCsmacd','FastEthernet0/11','9c4e20ae3f0d',NULL,1530803,'1','dot1Q',0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,67495,66945,550,2,35284,34734,550,2,0,0,0,0,0,0,0,0,26373619,26210737,162882,543,6405745,6308485,97260,324,1676384156,1676383856,300),
(1234,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/12','Fa0/12',NULL,10012,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/12','9c4e20ae3f0e',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1235,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/13','Fa0/13',NULL,10013,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/13','9c4e20ae3f0f',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1236,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/14','Fa0/14',NULL,10014,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/14','9c4e20ae3f10',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1237,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/15','Fa0/15',NULL,10015,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/15','9c4e20ae3f11',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1238,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/16','Fa0/16',NULL,10016,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/16','9c4e20ae3f12',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1239,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/17','Fa0/17',NULL,10017,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/17','9c4e20ae3f13',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1240,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/18','Fa0/18',NULL,10018,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/18','9c4e20ae3f14',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1241,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/19','Fa0/19',NULL,10019,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/19','9c4e20ae3f15',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1242,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/20','Fa0/20',NULL,10020,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/20','9c4e20ae3f16',NULL,7431,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1243,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/21','Fa0/21',NULL,10021,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/21','9c4e20ae3f17',NULL,7432,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1244,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/22','Fa0/22',NULL,10022,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/22','9c4e20ae3f18',NULL,7432,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1245,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/23','Fa0/23',NULL,10023,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/23','9c4e20ae3f19',NULL,7432,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1246,53,NULL,NULL,NULL,NULL,NULL,'FastEthernet0/24','Fa0/24',NULL,10024,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','FastEthernet0/24','9c4e20ae3f1a',NULL,7432,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1247,53,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/1','Gi0/1',NULL,10101,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/1','9c4e20ae3f01',NULL,7430,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1248,53,NULL,NULL,NULL,NULL,NULL,'GigabitEthernet0/2','Gi0/2',NULL,10102,10000000,10000000,'true','false','down','down','up','up','unknown',1500,'ethernetCsmacd','GigabitEthernet0/2','9c4e20ae3f02',NULL,7430,'1',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,0,0,NULL,NULL,1676384156,1676383856,NULL),
(1249,53,NULL,NULL,NULL,NULL,NULL,'Null0','Nu0',NULL,10501,10000000000,10000000000,'false','false','up','up','up','up',NULL,1500,'other','Null0',NULL,NULL,0,'',NULL,0,NULL,NULL,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1676384156,1676383856,300);
/*!40000 ALTER TABLE `ports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ports_fdb`
--

DROP TABLE IF EXISTS `ports_fdb`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ports_fdb` (
  `ports_fdb_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `port_id` int(10) unsigned NOT NULL,
  `mac_address` varchar(32) NOT NULL,
  `vlan_id` int(10) unsigned NOT NULL,
  `device_id` int(10) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ports_fdb_id`),
  KEY `ports_fdb_port_id_index` (`port_id`),
  KEY `ports_fdb_mac_address_index` (`mac_address`),
  KEY `ports_fdb_vlan_id_index` (`vlan_id`),
  KEY `ports_fdb_device_id_index` (`device_id`)
) ENGINE=InnoDB AUTO_INCREMENT=194 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ports_fdb`
--

LOCK TABLES `ports_fdb` WRITE;
/*!40000 ALTER TABLE `ports_fdb` DISABLE KEYS */;
INSERT INTO `ports_fdb` VALUES
(116,1070,'00000c07ac0a',335,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(117,1070,'001a2f3eb128',335,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(118,1070,'0023ea938e90',335,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(119,1055,'00e04c681272',335,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(120,1070,'ec447682dae0',335,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(121,1070,'00000c07ac14',338,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(122,1070,'001a2f3eb128',338,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(123,1070,'0023ea938e90',338,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(124,1070,'ec447682dae0',338,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(125,1070,'00000c07ac63',342,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(126,1070,'001a2f3eb128',342,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(127,1070,'0023ea938e90',342,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(128,1070,'68f728ee84dc',342,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(129,1070,'ec447682dae0',342,50,'2023-02-14 13:57:07','2023-02-14 14:06:21'),
(130,1035,'00000c07ac0a',334,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(131,1035,'001a2f3eb128',334,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(132,1035,'0023ea938e8b',334,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(133,1035,'00e04c681272',334,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(134,1035,'ec447682dae0',334,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(135,1035,'00000c07ac14',336,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(136,1035,'001a2f3eb128',336,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(137,1035,'0023ea938e8b',336,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(138,1025,'00e04c68114e',336,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(139,1035,'ec447682dae0',336,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(140,1035,'00000c07ac63',343,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(141,1035,'001a2f3eb128',343,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(142,1035,'0023ea938e8b',343,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(143,1035,'68f728ee84dc',343,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(144,1035,'ec447682dae0',343,49,'2023-02-14 13:57:08','2023-02-14 14:06:32'),
(145,1205,'00000c07ac0a',341,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(146,1204,'001a2f3eb128',341,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(147,1206,'00e04c681272',341,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(148,1205,'ec447682dae0',341,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(149,1205,'00000c07ac14',345,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(150,1204,'001a2f3eb128',345,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(151,1201,'00e04c68114e',345,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(152,1205,'ec447682dae0',345,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(153,1205,'00000c07ac63',358,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(154,1204,'001a2f3eb128',358,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(155,1205,'68f728ee84dc',358,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(156,1201,'9c4e20ae3bc2',358,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(157,1206,'9c4e20ae3d41',358,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(158,1205,'ec447682dae0',358,52,'2023-02-14 13:57:08','2023-02-14 14:05:49'),
(159,1233,'00000c07ac0a',344,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(160,1233,'001a2f3eb128',344,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(161,1233,'0023ead39c0b',344,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(162,1233,'00e04c681272',344,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(163,1233,'ec447682dae0',344,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(164,1233,'00000c07ac14',351,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(165,1233,'001a2f3eb128',351,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(166,1233,'0023ead39c0b',351,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(167,1233,'ec447682dae0',351,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(168,1233,'00000c07ac63',359,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(169,1233,'001a2f3eb128',359,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(170,1233,'0023ead39c0b',359,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(171,1233,'68f728ee84dc',359,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(172,1233,'ec447682dae0',359,53,'2023-02-14 13:57:08','2023-02-14 13:57:08'),
(173,1110,'00000c07ac0a',369,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(174,1114,'001a2f3eb128',369,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(175,1114,'0023ea938e8f',369,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(176,1114,'00e04c681272',369,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(177,1110,'ec447682dae0',369,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(178,1110,'00000c07ac14',370,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(179,1114,'001a2f3eb128',370,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(180,1114,'0023ea938e8f',370,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(181,1110,'ec447682dae0',370,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(182,1110,'00000c07ac63',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(183,1114,'001a2f3eb128',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(184,1114,'0023ea938e8f',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(185,1114,'0023ea938ec2',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(186,1087,'68f728ee84dc',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(187,1114,'9c4e20ae3bc2',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(188,1114,'9c4e20ae3d41',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(189,1106,'9c4e20ae3f41',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(190,1110,'ec447682dae0',371,51,'2023-02-14 13:57:10','2023-02-14 14:06:05'),
(191,1205,'0023ead39c0f',358,52,'2023-02-14 14:05:49','2023-02-14 14:05:49'),
(192,1114,'00e04c68114e',370,51,'2023-02-14 14:06:05','2023-02-14 14:06:05'),
(193,1070,'00e04c68114e',338,50,'2023-02-14 14:06:21','2023-02-14 14:06:21');
/*!40000 ALTER TABLE `ports_fdb` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `route` (
  `route_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `device_id` int(10) unsigned NOT NULL,
  `port_id` int(10) unsigned NOT NULL,
  `context_name` varchar(255) DEFAULT NULL,
  `inetCidrRouteIfIndex` bigint(20) NOT NULL,
  `inetCidrRouteType` int(10) unsigned NOT NULL,
  `inetCidrRouteProto` int(10) unsigned NOT NULL,
  `inetCidrRouteNextHopAS` int(10) unsigned NOT NULL,
  `inetCidrRouteMetric1` int(10) unsigned NOT NULL,
  `inetCidrRouteDestType` varchar(255) NOT NULL,
  `inetCidrRouteDest` varchar(255) NOT NULL,
  `inetCidrRouteNextHopType` varchar(255) NOT NULL,
  `inetCidrRouteNextHop` varchar(255) NOT NULL,
  `inetCidrRoutePolicy` varchar(255) NOT NULL,
  `inetCidrRoutePfxLen` int(10) unsigned NOT NULL,
  PRIMARY KEY (`route_id`)
) ENGINE=InnoDB AUTO_INCREMENT=686 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route`
--

LOCK TABLES `route` WRITE;
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` VALUES
(566,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,878,'',4,4,3,0,291,'ipv4','0.0.0.0','ipv4','192.168.1.100','ccitt.0',0),
(567,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,876,'',1,3,2,0,331,'ipv4','127.0.0.0','ipv4','127.0.0.1','ccitt.0',8),
(568,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,876,'',1,3,2,0,331,'ipv4','127.0.0.1','ipv4','127.0.0.1','ccitt.0',32),
(569,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,876,'',1,3,2,0,331,'ipv4','127.255.255.255','ipv4','127.0.0.1','ccitt.0',32),
(570,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,878,'',4,3,2,0,291,'ipv4','192.168.1.0','ipv4','192.168.1.10','ccitt.0',24),
(571,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,878,'',4,3,2,0,291,'ipv4','192.168.1.10','ipv4','192.168.1.10','ccitt.0',32),
(572,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,878,'',4,3,2,0,291,'ipv4','192.168.1.255','ipv4','192.168.1.10','ccitt.0',32),
(573,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,876,'',1,3,2,0,331,'ipv4','224.0.0.0','ipv4','127.0.0.1','ccitt.0',4),
(574,'2023-02-14 13:54:13','2023-02-14 13:54:13',46,876,'',1,3,2,0,331,'ipv4','255.255.255.255','ipv4','127.0.0.1','ccitt.0',32),
(591,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,925,'',4,4,13,0,65,'ipv4','8.8.8.8','ipv4','172.16.0.6','SNMPv2-SMI::zeroDotZero',32),
(592,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,924,'',3,3,2,0,0,'ipv4','172.16.0.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',30),
(593,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,924,'',3,3,2,0,0,'ipv4','172.16.0.1','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(594,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,925,'',4,3,2,0,0,'ipv4','172.16.0.4','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',30),
(595,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,925,'',4,3,2,0,0,'ipv4','172.16.0.5','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(596,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,932,'',13,4,13,0,782,'ipv4','172.16.0.8','ipv4','192.168.1.2','SNMPv2-SMI::zeroDotZero',30),
(597,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,933,'',14,4,13,0,782,'ipv4','172.16.0.8','ipv4','192.168.2.1','SNMPv2-SMI::zeroDotZero',30),
(598,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,934,'',15,4,13,0,782,'ipv4','172.16.0.8','ipv4','192.168.99.2','SNMPv2-SMI::zeroDotZero',30),
(599,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,932,'',13,3,2,0,0,'ipv4','192.168.1.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',24),
(600,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,932,'',13,3,2,0,0,'ipv4','192.168.1.1','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(601,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,933,'',14,3,2,0,0,'ipv4','192.168.2.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',24),
(602,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,933,'',14,3,2,0,0,'ipv4','192.168.2.2','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(603,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,934,'',15,3,2,0,0,'ipv4','192.168.99.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',24),
(604,'2023-02-14 13:54:20','2023-02-14 14:13:33',41,934,'',15,3,2,0,0,'ipv4','192.168.99.1','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(619,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,958,'',13,4,13,0,66,'ipv4','8.8.8.8','ipv4','192.168.1.1','SNMPv2-SMI::zeroDotZero',32),
(620,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,963,'',14,4,13,0,66,'ipv4','8.8.8.8','ipv4','192.168.2.2','SNMPv2-SMI::zeroDotZero',32),
(621,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,966,'',15,4,13,0,66,'ipv4','8.8.8.8','ipv4','192.168.99.1','SNMPv2-SMI::zeroDotZero',32),
(622,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,950,'',3,3,2,0,0,'ipv4','172.16.0.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',30),
(623,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,950,'',3,3,2,0,0,'ipv4','172.16.0.2','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(624,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,958,'',13,4,13,0,65,'ipv4','172.16.0.4','ipv4','192.168.1.1','SNMPv2-SMI::zeroDotZero',30),
(625,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,963,'',14,4,13,0,65,'ipv4','172.16.0.4','ipv4','192.168.2.2','SNMPv2-SMI::zeroDotZero',30),
(626,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,966,'',15,4,13,0,65,'ipv4','172.16.0.4','ipv4','192.168.99.1','SNMPv2-SMI::zeroDotZero',30),
(627,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,951,'',4,3,2,0,0,'ipv4','172.16.0.8','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',30),
(628,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,951,'',4,3,2,0,0,'ipv4','172.16.0.9','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(629,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,958,'',13,3,2,0,0,'ipv4','192.168.1.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',24),
(630,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,958,'',13,3,2,0,0,'ipv4','192.168.1.2','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(631,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,963,'',14,3,2,0,0,'ipv4','192.168.2.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',24),
(632,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,963,'',14,3,2,0,0,'ipv4','192.168.2.1','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(633,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,966,'',15,3,2,0,0,'ipv4','192.168.99.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',24),
(634,'2023-02-14 13:54:21','2023-02-14 14:10:30',44,966,'',15,3,2,0,0,'ipv4','192.168.99.2','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(648,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,982,'',13,3,2,0,0,'ipv4','8.8.8.0','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',24),
(649,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,982,'',13,3,2,0,0,'ipv4','8.8.8.8','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(650,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,974,'',3,4,13,0,845,'ipv4','172.16.0.0','ipv4','172.16.0.5','SNMPv2-SMI::zeroDotZero',30),
(651,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,974,'',3,3,2,0,0,'ipv4','172.16.0.4','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',30),
(652,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,974,'',3,3,2,0,0,'ipv4','172.16.0.6','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(653,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,975,'',4,3,2,0,0,'ipv4','172.16.0.8','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',30),
(654,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,975,'',4,3,2,0,0,'ipv4','172.16.0.10','ipv4','0.0.0.0','SNMPv2-SMI::zeroDotZero',32),
(655,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,974,'',3,4,13,0,782,'ipv4','192.168.1.0','ipv4','172.16.0.5','SNMPv2-SMI::zeroDotZero',24),
(656,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,975,'',4,4,13,0,782,'ipv4','192.168.1.0','ipv4','172.16.0.9','SNMPv2-SMI::zeroDotZero',24),
(657,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,974,'',3,4,13,0,782,'ipv4','192.168.2.0','ipv4','172.16.0.5','SNMPv2-SMI::zeroDotZero',24),
(658,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,975,'',4,4,13,0,782,'ipv4','192.168.2.0','ipv4','172.16.0.9','SNMPv2-SMI::zeroDotZero',24),
(659,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,974,'',3,4,13,0,782,'ipv4','192.168.99.0','ipv4','172.16.0.5','SNMPv2-SMI::zeroDotZero',24),
(660,'2023-02-14 13:54:22','2023-02-14 14:07:10',45,975,'',4,4,13,0,782,'ipv4','192.168.99.0','ipv4','172.16.0.9','SNMPv2-SMI::zeroDotZero',24),
(661,'2023-02-14 13:55:30','2023-02-14 14:06:41',48,1020,'',3,4,2,0,100,'ipv4','0.0.0.0','ipv4','192.168.2.1','zeroDotZero',0),
(662,'2023-02-14 13:55:30','2023-02-14 14:06:41',48,1019,'',2,4,2,0,101,'ipv4','0.0.0.0','ipv4','192.168.31.1','zeroDotZero',0),
(663,'2023-02-14 13:55:30','2023-02-14 14:06:41',48,1020,'',3,3,2,0,100,'ipv4','192.168.2.0','ipv4','0.0.0.0','zeroDotZero.3',24),
(664,'2023-02-14 13:55:30','2023-02-14 14:06:41',48,1019,'',2,3,2,0,101,'ipv4','192.168.31.0','ipv4','0.0.0.0','zeroDotZero.2',24),
(677,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,878,'',4,4,3,0,291,'ipv4','0.0.0.0','ipv4','192.168.1.100','ccitt.0',0),
(678,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,876,'',1,3,2,0,331,'ipv4','127.0.0.0','ipv4','127.0.0.1','ccitt.0',8),
(679,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,876,'',1,3,2,0,331,'ipv4','127.0.0.1','ipv4','127.0.0.1','ccitt.0',32),
(680,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,876,'',1,3,2,0,331,'ipv4','127.255.255.255','ipv4','127.0.0.1','ccitt.0',32),
(681,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,878,'',4,3,2,0,291,'ipv4','192.168.1.0','ipv4','192.168.1.10','ccitt.0',24),
(682,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,878,'',4,3,2,0,291,'ipv4','192.168.1.10','ipv4','192.168.1.10','ccitt.0',32),
(683,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,878,'',4,3,2,0,291,'ipv4','192.168.1.255','ipv4','192.168.1.10','ccitt.0',32),
(684,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,876,'',1,3,2,0,331,'ipv4','224.0.0.0','ipv4','127.0.0.1','ccitt.0',4),
(685,'2023-02-14 14:06:43','2023-02-14 14:06:43',46,876,'',1,3,2,0,331,'ipv4','255.255.255.255','ipv4','127.0.0.1','ccitt.0',32);
/*!40000 ALTER TABLE `route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vlans`
--

DROP TABLE IF EXISTS `vlans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vlans` (
  `vlan_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned DEFAULT NULL,
  `vlan_vlan` int(11) DEFAULT NULL,
  `vlan_domain` int(11) DEFAULT NULL,
  `vlan_name` varchar(64) DEFAULT NULL,
  `vlan_type` varchar(16) DEFAULT NULL,
  `vlan_mtu` int(11) DEFAULT NULL,
  PRIMARY KEY (`vlan_id`),
  KEY `device_id` (`device_id`,`vlan_vlan`)
) ENGINE=InnoDB AUTO_INCREMENT=376 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vlans`
--

LOCK TABLES `vlans` WRITE;
/*!40000 ALTER TABLE `vlans` DISABLE KEYS */;
INSERT INTO `vlans` VALUES
(42,10,1002,1,'fddi-default','fddi',NULL),
(43,10,1003,1,'token-ring-default','tokenRing',NULL),
(44,10,1004,1,'fddinet-default','fddiNet',NULL),
(45,10,1005,1,'trnet-default','trNet',NULL),
(46,10,1,1,'default','1',NULL),
(47,10,30,1,'VLAN0030','1',NULL),
(275,41,1,1,'VLAN 1',NULL,NULL),
(276,41,10,1,'VLAN 10',NULL,NULL),
(277,41,20,1,'VLAN 20',NULL,NULL),
(278,41,99,1,'VLAN 99',NULL,NULL),
(283,41,1,1,'default','ethernet',NULL),
(285,44,1,1,'VLAN 1',NULL,NULL),
(286,44,10,1,'VLAN 10',NULL,NULL),
(287,44,20,1,'VLAN 20',NULL,NULL),
(288,44,99,1,'VLAN 99',NULL,NULL),
(289,44,1,1,'default','ethernet',NULL),
(290,45,1,1,'default','ethernet',NULL),
(293,41,30,1,'VLAN0030','ethernet',NULL),
(295,44,20,1,'2nd_Day_in_paradise','ethernet',NULL),
(296,45,10,1,'VLAN0010','ethernet',NULL),
(299,41,1002,1,'fddi-default','fddi',NULL),
(300,41,1003,1,'token-ring-default','tokenRing',NULL),
(301,41,1004,1,'fddinet-default','fddiNet',NULL),
(302,41,1005,1,'trnet-default','trNet',NULL),
(307,44,30,1,'Internal','ethernet',NULL),
(308,45,20,1,'VLAN0020','ethernet',NULL),
(311,44,57,1,'MGMT','ethernet',NULL),
(312,45,30,1,'VLAN0030','ethernet',NULL),
(318,44,1002,1,'fddi-default','fddi',NULL),
(319,44,1003,1,'token-ring-default','tokenRing',NULL),
(320,44,1004,1,'fddinet-default','fddiNet',NULL),
(321,44,1005,1,'trnet-default','trNet',NULL),
(322,45,57,1,'VLAN0057','ethernet',NULL),
(324,45,1002,1,'fddi-default','fddi',NULL),
(325,45,1003,1,'token-ring-default','tokenRing',NULL),
(326,45,1004,1,'fddinet-default','fddiNet',NULL),
(327,45,1005,1,'trnet-default','trNet',NULL),
(332,49,1,1,'default','ethernet',NULL),
(333,50,1,1,'default','ethernet',NULL),
(334,49,10,1,'guests','ethernet',NULL),
(335,50,10,1,'stud','ethernet',NULL),
(336,49,20,1,'Vyroba','ethernet',NULL),
(337,52,1,1,'default','ethernet',NULL),
(338,50,20,1,'staf','ethernet',NULL),
(339,49,30,1,'VLAN0030','ethernet',NULL),
(340,53,1,1,'default','ethernet',NULL),
(341,52,10,1,'VLAN0010','ethernet',NULL),
(342,50,99,1,'mng','ethernet',NULL),
(343,49,99,1,'VLAN0099','ethernet',NULL),
(344,53,10,1,'VLAN0010','ethernet',NULL),
(345,52,20,1,'VLAN0020','ethernet',NULL),
(346,50,1002,1,'fddi-default','fddi',NULL),
(347,50,1003,1,'token-ring-default','tokenRing',NULL),
(348,50,1004,1,'fddinet-default','fddiNet',NULL),
(349,50,1005,1,'trnet-default','trNet',NULL),
(350,49,999,1,'Parking','ethernet',NULL),
(351,53,20,1,'VLAN0020','ethernet',NULL),
(352,52,30,1,'VLAN0030','ethernet',NULL),
(353,49,1002,1,'fddi-default','fddi',NULL),
(354,49,1003,1,'token-ring-default','tokenRing',NULL),
(355,49,1004,1,'fddinet-default','fddiNet',NULL),
(356,49,1005,1,'trnet-default','trNet',NULL),
(357,53,30,1,'VLAN0030','ethernet',NULL),
(358,52,99,1,'VLAN0099','ethernet',NULL),
(359,53,99,1,'VLAN0099','ethernet',NULL),
(360,52,1002,1,'fddi-default','fddi',NULL),
(361,52,1003,1,'token-ring-default','tokenRing',NULL),
(362,52,1004,1,'fddinet-default','fddiNet',NULL),
(363,52,1005,1,'trnet-default','trNet',NULL),
(364,53,1002,1,'fddi-default','fddi',NULL),
(365,53,1003,1,'token-ring-default','tokenRing',NULL),
(366,53,1004,1,'fddinet-default','fddiNet',NULL),
(367,53,1005,1,'trnet-default','trNet',NULL),
(368,51,1,1,'default','ethernet',NULL),
(369,51,10,1,'VLAN0010','ethernet',NULL),
(370,51,20,1,'VLAN0020','ethernet',NULL),
(371,51,99,1,'VLAN0099','ethernet',NULL),
(372,51,1002,1,'fddi-default','fddi',NULL),
(373,51,1003,1,'token-ring-default','tokenRing',NULL),
(374,51,1004,1,'fddinet-default','fddiNet',NULL),
(375,51,1005,1,'trnet-default','trNet',NULL);
/*!40000 ALTER TABLE `vlans` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-20 19:59:56
