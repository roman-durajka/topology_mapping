-- MariaDB dump 10.19  Distrib 10.11.2-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: updated
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
  `device_id` int(11) NOT NULL,
  `device_name` varchar(128) NOT NULL,
  `os` varchar(32) NOT NULL,
  `model` varchar(128) NOT NULL,
  `device_descr` varchar(256) DEFAULT NULL,
  `type` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES
(41,'r1','ios','CISCO1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\r\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team',NULL),
(44,'r2','ios','CISCO1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\r\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team',NULL),
(45,'r3','ios','CISCO1841','Cisco IOS Software, 1841 Software (C1841-ADVIPSERVICESK9-M), Version 15.3(3)XB12, RELEASE SOFTWARE (fc2)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\r\nCompiled Tue 19-Nov-13 06:41 by prod_rel_team',NULL),
(46,'b301-08','windows','Intel x64','Hardware: Intel64 Family 6 Model 60 Stepping 3 AT/AT COMPATIBLE - Software: Windows Version 6.3 (Build 19045 Multiprocessor Free)',NULL),
(48,'b301-09','linux','Generic x86 64-bit','Linux b301-09 5.17.0-kali3-amd64 #1 SMP PREEMPT Debian 5.17.11-1kali1 (2022-05-30) x86_64',NULL),
(49,'sw2','ios','WS-C3560V2-24PS-S','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\r\nCompiled Wed 13-May-15 23:32 by prod_rel_team',NULL),
(50,'sw1','ios','WS-C3560V2-24PS-S','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2012 by Cisco Systems, Inc.\r\nCompiled Sat 28-Jul-12 00:01 by prod_rel_team',NULL),
(51,'sw4','ios','WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE5, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2013 by Cisco Systems, Inc.\r\nCompiled Fri 25-Oct-13 13:34 by prod_rel_team',NULL),
(52,'sw3','ios','WS-C2960-24TT-L','Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\r\nCompiled Thu 14-May-15 02:39 by prod_rel_team',NULL),
(53,'sw5','ios','WS-C3560V2-24PS-S','Cisco IOS Software, C3560 Software (C3560-IPSERVICESK9-M), Version 15.0(2)SE8, RELEASE SOFTWARE (fc1)\r\nTechnical Support: http://www.cisco.com/techsupport\r\nCopyright (c) 1986-2015 by Cisco Systems, Inc.\r\nCompiled Wed 13-May-15 23:32 by prod_rel_team',NULL);
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipv4_addresses`
--

DROP TABLE IF EXISTS `ipv4_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipv4_addresses` (
  `ipv4_address_id` int(11) NOT NULL,
  `port_id` int(11) NOT NULL,
  `ipv4_network_id` int(11) NOT NULL,
  `ipv4_address` varchar(17) NOT NULL,
  PRIMARY KEY (`ipv4_address_id`),
  KEY `IX_Relationship9` (`port_id`),
  KEY `IX_Relationship10` (`ipv4_network_id`),
  CONSTRAINT `Relationship10` FOREIGN KEY (`ipv4_network_id`) REFERENCES `ipv4_networks` (`ipv4_network_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Relationship9` FOREIGN KEY (`port_id`) REFERENCES `ports` (`port_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipv4_addresses`
--

LOCK TABLES `ipv4_addresses` WRITE;
/*!40000 ALTER TABLE `ipv4_addresses` DISABLE KEYS */;
INSERT INTO `ipv4_addresses` VALUES
(1,876,2,'127.0.0.1'),
(2,878,1,'192.168.1.10'),
(3,924,5,'172.16.0.1'),
(4,925,8,'172.16.0.5'),
(5,932,1,'192.168.1.1'),
(6,932,1,'192.168.1.100'),
(7,933,7,'192.168.2.2'),
(8,933,7,'192.168.2.100'),
(9,934,10,'192.168.99.1'),
(10,934,10,'192.168.99.100'),
(11,950,5,'172.16.0.2'),
(12,951,6,'172.16.0.9'),
(13,958,1,'192.168.1.2'),
(14,963,7,'192.168.2.1'),
(15,966,10,'192.168.99.2'),
(16,982,9,'8.8.8.8'),
(17,974,8,'172.16.0.6'),
(18,975,6,'172.16.0.10'),
(19,1018,2,'127.0.0.1'),
(20,1020,7,'192.168.2.10'),
(21,1019,11,'192.168.31.109'),
(22,1023,10,'192.168.99.102'),
(23,1053,10,'192.168.99.101'),
(24,1085,10,'192.168.99.104'),
(25,1190,10,'192.168.99.103'),
(26,1222,10,'192.168.99.105');
/*!40000 ALTER TABLE `ipv4_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ipv4_networks`
--

DROP TABLE IF EXISTS `ipv4_networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipv4_networks` (
  `ipv4_network_id` int(11) NOT NULL,
  `network_address` varchar(17) NOT NULL,
  `network_prefixlen` varchar(2) NOT NULL,
  PRIMARY KEY (`ipv4_network_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ipv4_networks`
--

LOCK TABLES `ipv4_networks` WRITE;
/*!40000 ALTER TABLE `ipv4_networks` DISABLE KEYS */;
INSERT INTO `ipv4_networks` VALUES
(1,'192.168.1.0','24'),
(2,'127.0.0.0','8'),
(3,'172.17.0.0','16'),
(4,'172.18.0.0','16'),
(5,'172.16.0.0','30'),
(6,'172.16.0.8','30'),
(7,'192.168.2.0','24'),
(8,'172.16.0.4','30'),
(9,'8.8.8.8','32'),
(10,'192.168.99.0','24'),
(11,'192.168.31.0','24');
/*!40000 ALTER TABLE `ipv4_networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mac_table`
--

DROP TABLE IF EXISTS `mac_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mac_table` (
  `entry_id` int(11) NOT NULL,
  `port_id` int(11) NOT NULL,
  `vlan_id` varchar(32) NOT NULL,
  `mac_address` varchar(17) NOT NULL,
  PRIMARY KEY (`entry_id`),
  KEY `IX_Relationship2` (`port_id`),
  CONSTRAINT `Relationship2` FOREIGN KEY (`port_id`) REFERENCES `ports` (`port_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mac_table`
--

LOCK TABLES `mac_table` WRITE;
/*!40000 ALTER TABLE `mac_table` DISABLE KEYS */;
INSERT INTO `mac_table` VALUES
(1,1070,'10','00000c07ac0a'),
(2,1070,'10','001a2f3eb128'),
(3,1070,'10','0023ea938e90'),
(4,1055,'10','00e04c681272'),
(5,1070,'10','ec447682dae0'),
(6,1070,'20','00000c07ac14'),
(7,1070,'20','001a2f3eb128'),
(8,1070,'20','0023ea938e90'),
(9,1070,'20','ec447682dae0'),
(10,1070,'99','00000c07ac63'),
(11,1070,'99','001a2f3eb128'),
(12,1070,'99','0023ea938e90'),
(13,1070,'99','68f728ee84dc'),
(14,1070,'99','ec447682dae0'),
(15,1035,'10','00000c07ac0a'),
(16,1035,'10','001a2f3eb128'),
(17,1035,'10','0023ea938e8b'),
(18,1035,'10','00e04c681272'),
(19,1035,'10','ec447682dae0'),
(20,1035,'20','00000c07ac14'),
(21,1035,'20','001a2f3eb128'),
(22,1035,'20','0023ea938e8b'),
(23,1025,'20','00e04c68114e'),
(24,1035,'20','ec447682dae0'),
(25,1035,'99','00000c07ac63'),
(26,1035,'99','001a2f3eb128'),
(27,1035,'99','0023ea938e8b'),
(28,1035,'99','68f728ee84dc'),
(29,1035,'99','ec447682dae0'),
(30,1205,'10','00000c07ac0a'),
(31,1204,'10','001a2f3eb128'),
(32,1206,'10','00e04c681272'),
(33,1205,'10','ec447682dae0'),
(34,1205,'20','00000c07ac14'),
(35,1204,'20','001a2f3eb128'),
(36,1201,'20','00e04c68114e'),
(37,1205,'20','ec447682dae0'),
(38,1205,'99','00000c07ac63'),
(39,1204,'99','001a2f3eb128'),
(40,1205,'99','68f728ee84dc'),
(41,1201,'99','9c4e20ae3bc2'),
(42,1206,'99','9c4e20ae3d41'),
(43,1205,'99','ec447682dae0'),
(44,1233,'10','00000c07ac0a'),
(45,1233,'10','001a2f3eb128'),
(46,1233,'10','0023ead39c0b'),
(47,1233,'10','00e04c681272'),
(48,1233,'10','ec447682dae0'),
(49,1233,'20','00000c07ac14'),
(50,1233,'20','001a2f3eb128'),
(51,1233,'20','0023ead39c0b'),
(52,1233,'20','ec447682dae0'),
(53,1233,'99','00000c07ac63'),
(54,1233,'99','001a2f3eb128'),
(55,1233,'99','0023ead39c0b'),
(56,1233,'99','68f728ee84dc'),
(57,1233,'99','ec447682dae0'),
(58,1110,'10','00000c07ac0a'),
(59,1114,'10','001a2f3eb128'),
(60,1114,'10','0023ea938e8f'),
(61,1114,'10','00e04c681272'),
(62,1110,'10','ec447682dae0'),
(63,1110,'20','00000c07ac14'),
(64,1114,'20','001a2f3eb128'),
(65,1114,'20','0023ea938e8f'),
(66,1110,'20','ec447682dae0'),
(67,1110,'99','00000c07ac63'),
(68,1114,'99','001a2f3eb128'),
(69,1114,'99','0023ea938e8f'),
(70,1114,'99','0023ea938ec2'),
(71,1087,'99','68f728ee84dc'),
(72,1114,'99','9c4e20ae3bc2'),
(73,1114,'99','9c4e20ae3d41'),
(74,1106,'99','9c4e20ae3f41'),
(75,1110,'99','ec447682dae0'),
(76,1205,'99','0023ead39c0f'),
(77,1114,'20','00e04c68114e'),
(78,1070,'20','00e04c68114e');
/*!40000 ALTER TABLE `mac_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `neighbors`
--

DROP TABLE IF EXISTS `neighbors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `neighbors` (
  `relation_id` int(11) NOT NULL,
  `local_port_id` int(11) NOT NULL,
  `remote_port_id` int(11) NOT NULL,
  `active` int(11) NOT NULL,
  `protocol` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`relation_id`),
  KEY `IX_Relationship6` (`local_port_id`),
  KEY `IX_Relationship8` (`remote_port_id`),
  CONSTRAINT `Relationship6` FOREIGN KEY (`local_port_id`) REFERENCES `ports` (`port_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Relationship8` FOREIGN KEY (`remote_port_id`) REFERENCES `ports` (`port_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `neighbors`
--

LOCK TABLES `neighbors` WRITE;
/*!40000 ALTER TABLE `neighbors` DISABLE KEYS */;
INSERT INTO `neighbors` VALUES
(1,922,1110,1,'cdp'),
(2,924,950,1,'cdp'),
(3,925,974,1,'cdp'),
(4,948,1204,1,'cdp'),
(5,950,924,1,'cdp'),
(6,975,951,1,'cdp'),
(7,1035,1201,1,'cdp'),
(8,1039,1069,1,'cdp'),
(9,1040,1117,1,'cdp'),
(10,1041,1071,1,'cdp'),
(11,1064,1232,1,'cdp'),
(12,1066,1104,1,'cdp'),
(13,1104,1066,1,'cdp'),
(14,1069,1039,1,'cdp'),
(15,1106,1233,1,'cdp'),
(16,1070,1206,1,'cdp'),
(17,1071,1041,1,'cdp'),
(18,1201,1035,1,'cdp'),
(19,1205,1114,1,'cdp'),
(20,1206,1070,1,'cdp'),
(21,1232,1064,1,'cdp'),
(22,1233,1106,1,'cdp'),
(23,1110,922,1,'cdp'),
(24,1114,1205,1,'cdp'),
(25,1117,1040,1,'cdp'),
(26,1204,948,1,'cdp'),
(27,974,925,1,'cdp'),
(28,951,975,1,'cdp'),
(29,1055,878,1,'lldp'),
(30,1025,1020,1,'lldp');
/*!40000 ALTER TABLE `neighbors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ports`
--

DROP TABLE IF EXISTS `ports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ports` (
  `port_id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `if_name` varchar(256) NOT NULL,
  `oper_status` varchar(4) NOT NULL,
  `if_type` varchar(32) NOT NULL,
  `is_trunk` int(11) NOT NULL,
  `mac_address` varchar(17) DEFAULT NULL,
  `vlan_id` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`port_id`),
  KEY `IX_Relationship1` (`device_id`),
  CONSTRAINT `Relationship1` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ports`
--

LOCK TABLES `ports` WRITE;
/*!40000 ALTER TABLE `ports` DISABLE KEYS */;
INSERT INTO `ports` VALUES
(876,46,'loopback_0','up','softwareLoopback',0,NULL,NULL),
(877,46,'ethernet_32774','up','ethernetCsmacd',0,NULL,NULL),
(878,46,'ethernet_32781','up','ethernetCsmacd',0,'00e04c681272',NULL),
(879,46,'ppp_32768','down','ppp',0,NULL,NULL),
(880,46,'tunnel_32770','down','tunnel',0,NULL,NULL),
(881,46,'tunnel_32771','down','tunnel',0,NULL,NULL),
(882,46,'ethernet_32773','up','ethernetCsmacd',0,NULL,NULL),
(883,46,'ethernet_32782','down','ethernetCsmacd',0,'fcaa144b540a',NULL),
(884,46,'tunnel_32769','down','tunnel',0,NULL,NULL),
(885,46,'ethernet_32775','up','ethernetCsmacd',0,NULL,NULL),
(886,46,'tunnel_32768','down','tunnel',0,NULL,NULL),
(887,46,'ethernet_0','up','ethernetCsmacd',0,'00e04c681272',NULL),
(888,46,'ethernet_1','up','ethernetCsmacd',0,'00e04c681272',NULL),
(889,46,'ethernet_4','up','ethernetCsmacd',0,'00e04c681272',NULL),
(890,46,'ethernet_5','up','ethernetCsmacd',0,NULL,NULL),
(891,46,'ethernet_6','up','ethernetCsmacd',0,NULL,NULL),
(892,46,'ethernet_8','up','ethernetCsmacd',0,NULL,NULL),
(893,46,'ethernet_9','up','ethernetCsmacd',0,NULL,NULL),
(894,46,'ethernet_11','up','ethernetCsmacd',0,NULL,NULL),
(895,46,'ethernet_12','up','ethernetCsmacd',0,NULL,NULL),
(922,41,'Fa0/0','up','ethernetCsmacd',0,'ec447682dae0',NULL),
(923,41,'Fa0/1','down','ethernetCsmacd',0,'ec447682dae1',NULL),
(924,41,'Se0/0/0','up','propPointToPointSerial',0,NULL,NULL),
(925,41,'Se0/0/1','up','propPointToPointSerial',0,NULL,NULL),
(926,41,'Fa0/1/0','down','ethernetCsmacd',0,'0017e0954b00','1'),
(927,41,'Fa0/1/1','down','ethernetCsmacd',0,'0017e0954b01','1'),
(928,41,'Fa0/1/2','down','ethernetCsmacd',0,'0017e0954b02','1'),
(929,41,'Fa0/1/3','down','ethernetCsmacd',0,'0017e0954b03','1'),
(930,41,'Nu0','up','other',0,NULL,NULL),
(931,41,'Vl1','down','propVirtual',0,'ec447682dae0',NULL),
(932,41,'Fa0/0.10','up','l2vlan',0,'ec447682dae0',NULL),
(933,41,'Fa0/0.20','up','l2vlan',0,'ec447682dae0',NULL),
(934,41,'Fa0/0.99','up','l2vlan',0,'ec447682dae0',NULL),
(948,44,'Fa0/0','up','ethernetCsmacd',0,'001a2f3eb128',NULL),
(949,44,'Fa0/1','down','ethernetCsmacd',0,'001a2f3eb129',NULL),
(950,44,'Se0/0/0','up','propPointToPointSerial',0,NULL,NULL),
(951,44,'Se0/0/1','up','propPointToPointSerial',0,NULL,NULL),
(952,44,'Fa0/1/0','down','ethernetCsmacd',0,'002290d63517','1'),
(953,44,'Fa0/1/1','down','ethernetCsmacd',0,'002290d63518','1'),
(954,44,'Fa0/1/2','down','ethernetCsmacd',0,'002290d63519','1'),
(955,44,'Fa0/1/3','down','ethernetCsmacd',0,'002290d6351a','1'),
(956,44,'Nu0','up','other',0,NULL,NULL),
(957,44,'Vl1','down','propVirtual',0,'001a2f3eb128',NULL),
(958,44,'Fa0/0.10','up','l2vlan',0,'001a2f3eb128',NULL),
(963,44,'Fa0/0.20','up','l2vlan',0,'001a2f3eb128',NULL),
(966,44,'Fa0/0.99','up','l2vlan',0,'001a2f3eb128',NULL),
(972,45,'Fa0/0','down','ethernetCsmacd',0,'0019e87f38e4',NULL),
(973,45,'Fa0/1','down','ethernetCsmacd',0,'0019e87f38e5',NULL),
(974,45,'Se0/0/0','up','propPointToPointSerial',0,NULL,NULL),
(975,45,'Se0/0/1','up','propPointToPointSerial',0,NULL,NULL),
(976,45,'Fa0/1/0','down','ethernetCsmacd',0,'0011bb461039','1'),
(977,45,'Fa0/1/1','down','ethernetCsmacd',0,'0011bb46103a','1'),
(978,45,'Fa0/1/2','down','ethernetCsmacd',0,'0011bb46103b','1'),
(979,45,'Fa0/1/3','down','ethernetCsmacd',0,'0011bb46103c','1'),
(980,45,'Nu0','up','other',0,NULL,NULL),
(981,45,'Vl1','down','propVirtual',0,'0019e87f38e4',NULL),
(982,45,'Lo0','up','softwareLoopback',0,NULL,NULL),
(1018,48,'lo','up','softwareLoopback',0,NULL,NULL),
(1019,48,'eth0','down','ethernetCsmacd',0,'fcaa144b5414',NULL),
(1020,48,'eth1','up','ethernetCsmacd',0,'00e04c68114e',NULL),
(1021,49,'Vl1','down','propVirtual',0,'9c4e20ae3bc0',NULL),
(1022,49,'Vl20','up','propVirtual',0,'9c4e20ae3bc1',NULL),
(1023,49,'Vl99','up','propVirtual',0,'9c4e20ae3bc2',NULL),
(1024,49,'Po1','up','propVirtual',1,'9c4e20ae3b91','1'),
(1025,49,'Fa0/1','up','ethernetCsmacd',0,'9c4e20ae3b83','20'),
(1026,49,'Fa0/2','down','ethernetCsmacd',0,'9c4e20ae3b84','1'),
(1027,49,'Fa0/3','down','ethernetCsmacd',0,'9c4e20ae3b85','1'),
(1028,49,'Fa0/4','down','ethernetCsmacd',0,'9c4e20ae3b86','1'),
(1029,49,'Fa0/5','down','ethernetCsmacd',0,'9c4e20ae3b87','1'),
(1030,49,'Fa0/6','down','ethernetCsmacd',0,'9c4e20ae3b88','1'),
(1031,49,'Fa0/7','down','ethernetCsmacd',0,'9c4e20ae3b89','1'),
(1032,49,'Fa0/8','down','ethernetCsmacd',0,'9c4e20ae3b8a','1'),
(1033,49,'Fa0/9','down','ethernetCsmacd',0,'9c4e20ae3b8b','1'),
(1034,49,'Fa0/10','down','ethernetCsmacd',0,'9c4e20ae3b8c',NULL),
(1035,49,'Fa0/11','up','ethernetCsmacd',1,'9c4e20ae3b8d','1'),
(1036,49,'Fa0/12','down','ethernetCsmacd',0,'9c4e20ae3b8e',NULL),
(1037,49,'Fa0/13','down','ethernetCsmacd',0,'9c4e20ae3b8f',NULL),
(1038,49,'Fa0/14','down','ethernetCsmacd',0,'9c4e20ae3b90',NULL),
(1039,49,'Fa0/15','up','ethernetCsmacd',0,'9c4e20ae3b91',NULL),
(1040,49,'Fa0/16','up','ethernetCsmacd',1,'9c4e20ae3b92','1'),
(1041,49,'Fa0/17','up','ethernetCsmacd',0,'9c4e20ae3b93',NULL),
(1042,49,'Fa0/18','down','ethernetCsmacd',0,'9c4e20ae3b94','1'),
(1043,49,'Fa0/19','down','ethernetCsmacd',0,'9c4e20ae3b95','1'),
(1044,49,'Fa0/20','down','ethernetCsmacd',0,'9c4e20ae3b96','1'),
(1045,49,'Fa0/21','down','ethernetCsmacd',0,'9c4e20ae3b97','1'),
(1046,49,'Fa0/22','down','ethernetCsmacd',0,'9c4e20ae3b98','1'),
(1047,49,'Fa0/23','down','ethernetCsmacd',0,'9c4e20ae3b99','1'),
(1048,49,'Fa0/24','down','ethernetCsmacd',0,'9c4e20ae3b9a','1'),
(1049,49,'Gi0/1','down','ethernetCsmacd',0,'9c4e20ae3b81','1'),
(1050,49,'Gi0/2','down','ethernetCsmacd',0,'9c4e20ae3b82','1'),
(1051,49,'Nu0','up','other',0,NULL,NULL),
(1052,50,'Vl1','down','propVirtual',0,'9c4e20ae3d40',NULL),
(1053,50,'Vl99','up','propVirtual',0,'9c4e20ae3d41',NULL),
(1054,50,'Po1','up','propVirtual',1,'9c4e20ae3d11','1'),
(1055,50,'Fa0/1','up','ethernetCsmacd',0,'9c4e20ae3d03','10'),
(1056,50,'Fa0/2','down','ethernetCsmacd',0,'9c4e20ae3d04','1'),
(1057,50,'Fa0/3','down','ethernetCsmacd',0,'9c4e20ae3d05','1'),
(1058,50,'Fa0/4','down','ethernetCsmacd',0,'9c4e20ae3d06','1'),
(1059,50,'Fa0/5','down','ethernetCsmacd',0,'9c4e20ae3d07','1'),
(1060,50,'Fa0/6','down','ethernetCsmacd',0,'9c4e20ae3d08','1'),
(1061,50,'Fa0/7','down','ethernetCsmacd',0,'9c4e20ae3d09','1'),
(1062,50,'Fa0/8','down','ethernetCsmacd',0,'9c4e20ae3d0a','1'),
(1063,50,'Fa0/9','down','ethernetCsmacd',0,'9c4e20ae3d0b','1'),
(1064,50,'Fa0/10','up','ethernetCsmacd',1,'9c4e20ae3d0c','1'),
(1065,50,'Fa0/11','down','ethernetCsmacd',0,'9c4e20ae3d0d',NULL),
(1066,50,'Fa0/12','up','ethernetCsmacd',1,'9c4e20ae3d0e','1'),
(1067,50,'Fa0/13','down','ethernetCsmacd',0,'9c4e20ae3d0f',NULL),
(1068,50,'Fa0/14','down','ethernetCsmacd',0,'9c4e20ae3d10',NULL),
(1069,50,'Fa0/15','up','ethernetCsmacd',0,'9c4e20ae3d11',NULL),
(1070,50,'Fa0/16','up','ethernetCsmacd',1,'9c4e20ae3d12','1'),
(1071,50,'Fa0/17','up','ethernetCsmacd',0,'9c4e20ae3d13',NULL),
(1072,50,'Fa0/18','down','ethernetCsmacd',0,'9c4e20ae3d14','1'),
(1073,50,'Fa0/19','down','ethernetCsmacd',0,'9c4e20ae3d15','1'),
(1074,50,'Fa0/20','down','ethernetCsmacd',0,'9c4e20ae3d16','1'),
(1075,50,'Fa0/21','down','ethernetCsmacd',0,'9c4e20ae3d17','1'),
(1076,50,'Fa0/22','down','ethernetCsmacd',0,'9c4e20ae3d18','1'),
(1077,50,'Fa0/23','down','ethernetCsmacd',0,'9c4e20ae3d19','1'),
(1078,50,'Fa0/24','down','ethernetCsmacd',0,'9c4e20ae3d1a','1'),
(1079,50,'Gi0/1','down','ethernetCsmacd',0,'9c4e20ae3d01','1'),
(1080,50,'Gi0/2','down','ethernetCsmacd',0,'9c4e20ae3d02','1'),
(1081,51,'Vl1','down','propVirtual',0,'0023ead39c40',NULL),
(1082,51,'Vl10','up','propVirtual',0,'0023ead39c41',NULL),
(1083,50,'Nu0','up','other',0,NULL,NULL),
(1084,51,'Vl20','up','propVirtual',0,'0023ead39c43',NULL),
(1085,51,'Vl99','up','propVirtual',0,'0023ead39c42',NULL),
(1087,51,'Fa0/1','up','ethernetCsmacd',0,'0023ead39c01','99'),
(1089,51,'Fa0/2','down','ethernetCsmacd',0,'0023ead39c02','1'),
(1091,51,'Fa0/3','down','ethernetCsmacd',0,'0023ead39c03','1'),
(1092,51,'Fa0/4','down','ethernetCsmacd',0,'0023ead39c04','1'),
(1093,51,'Fa0/5','down','ethernetCsmacd',0,'0023ead39c05','1'),
(1095,51,'Fa0/6','down','ethernetCsmacd',0,'0023ead39c06','1'),
(1097,51,'Fa0/7','down','ethernetCsmacd',0,'0023ead39c07','1'),
(1100,51,'Fa0/8','down','ethernetCsmacd',0,'0023ead39c08','1'),
(1102,51,'Fa0/9','down','ethernetCsmacd',0,'0023ead39c09','1'),
(1104,51,'Fa0/10','up','ethernetCsmacd',1,'0023ead39c0a','1'),
(1106,51,'Fa0/11','up','ethernetCsmacd',1,'0023ead39c0b','1'),
(1108,51,'Fa0/12','down','ethernetCsmacd',0,'0023ead39c0c',NULL),
(1110,51,'Fa0/13','up','ethernetCsmacd',1,'0023ead39c0d','1'),
(1112,51,'Fa0/14','down','ethernetCsmacd',0,'0023ead39c0e',NULL),
(1114,51,'Fa0/15','up','ethernetCsmacd',1,'0023ead39c0f','1'),
(1117,51,'Fa0/16','up','ethernetCsmacd',1,'0023ead39c10','1'),
(1119,51,'Fa0/17','down','ethernetCsmacd',0,'0023ead39c11','1'),
(1121,51,'Fa0/18','down','ethernetCsmacd',0,'0023ead39c12','1'),
(1123,51,'Fa0/19','down','ethernetCsmacd',0,'0023ead39c13','1'),
(1125,51,'Fa0/20','down','ethernetCsmacd',0,'0023ead39c14','1'),
(1128,51,'Fa0/21','down','ethernetCsmacd',0,'0023ead39c15','1'),
(1132,51,'Fa0/22','down','ethernetCsmacd',0,'0023ead39c16','1'),
(1134,51,'Fa0/23','down','ethernetCsmacd',0,'0023ead39c17','1'),
(1137,51,'Fa0/24','down','ethernetCsmacd',0,'0023ead39c18','1'),
(1138,51,'Gi0/1','down','ethernetCsmacd',0,'0023ead39c19','1'),
(1141,51,'Gi0/2','down','ethernetCsmacd',0,'0023ead39c1a','1'),
(1143,51,'Nu0','up','other',0,NULL,NULL),
(1188,52,'Vl1','down','propVirtual',0,'0023ea938ec0',NULL),
(1189,52,'Vl20','up','propVirtual',0,'0023ea938ec1',NULL),
(1190,52,'Vl99','up','propVirtual',0,'0023ea938ec2',NULL),
(1191,52,'Fa0/1','down','ethernetCsmacd',0,'0023ea938e81','1'),
(1192,52,'Fa0/2','down','ethernetCsmacd',0,'0023ea938e82','1'),
(1193,52,'Fa0/3','down','ethernetCsmacd',0,'0023ea938e83','1'),
(1194,52,'Fa0/4','down','ethernetCsmacd',0,'0023ea938e84','1'),
(1195,52,'Fa0/5','down','ethernetCsmacd',0,'0023ea938e85','1'),
(1196,52,'Fa0/6','down','ethernetCsmacd',0,'0023ea938e86','1'),
(1197,52,'Fa0/7','down','ethernetCsmacd',0,'0023ea938e87','1'),
(1198,52,'Fa0/8','down','ethernetCsmacd',0,'0023ea938e88','1'),
(1199,52,'Fa0/9','down','ethernetCsmacd',0,'0023ea938e89','1'),
(1200,52,'Fa0/10','down','ethernetCsmacd',0,'0023ea938e8a',NULL),
(1201,52,'Fa0/11','up','ethernetCsmacd',1,'0023ea938e8b','1'),
(1202,52,'Fa0/12','down','ethernetCsmacd',0,'0023ea938e8c',NULL),
(1203,52,'Fa0/13','down','ethernetCsmacd',0,'0023ea938e8d',NULL),
(1204,52,'Fa0/14','up','ethernetCsmacd',1,'0023ea938e8e','1'),
(1205,52,'Fa0/15','up','ethernetCsmacd',1,'0023ea938e8f','1'),
(1206,52,'Fa0/16','up','ethernetCsmacd',1,'0023ea938e90','1'),
(1207,52,'Fa0/17','down','ethernetCsmacd',0,'0023ea938e91','1'),
(1208,52,'Fa0/18','down','ethernetCsmacd',0,'0023ea938e92','1'),
(1209,52,'Fa0/19','down','ethernetCsmacd',0,'0023ea938e93','1'),
(1210,52,'Fa0/20','down','ethernetCsmacd',0,'0023ea938e94','1'),
(1211,52,'Fa0/21','down','ethernetCsmacd',0,'0023ea938e95','1'),
(1212,52,'Fa0/22','down','ethernetCsmacd',0,'0023ea938e96','1'),
(1213,52,'Fa0/23','down','ethernetCsmacd',0,'0023ea938e97','1'),
(1214,52,'Fa0/24','down','ethernetCsmacd',0,'0023ea938e98','1'),
(1215,52,'Gi0/1','down','ethernetCsmacd',0,'0023ea938e99','1'),
(1216,52,'Gi0/2','down','ethernetCsmacd',0,'0023ea938e9a','1'),
(1217,52,'Nu0','up','other',0,NULL,NULL),
(1218,53,'Vl1','down','propVirtual',0,'9c4e20ae3f40',NULL),
(1219,53,'Vl10','up','propVirtual',0,'9c4e20ae3f42',NULL),
(1220,53,'Vl20','up','propVirtual',0,'9c4e20ae3f43',NULL),
(1221,53,'Vl30','down','propVirtual',0,'9c4e20ae3f44',NULL),
(1222,53,'Vl99','up','propVirtual',0,'9c4e20ae3f41',NULL),
(1223,53,'Fa0/1','down','ethernetCsmacd',0,'9c4e20ae3f03','1'),
(1224,53,'Fa0/2','down','ethernetCsmacd',0,'9c4e20ae3f04','1'),
(1225,53,'Fa0/3','down','ethernetCsmacd',0,'9c4e20ae3f05','1'),
(1226,53,'Fa0/4','down','ethernetCsmacd',0,'9c4e20ae3f06','1'),
(1227,53,'Fa0/5','down','ethernetCsmacd',0,'9c4e20ae3f07','1'),
(1228,53,'Fa0/6','down','ethernetCsmacd',0,'9c4e20ae3f08','1'),
(1229,53,'Fa0/7','down','ethernetCsmacd',0,'9c4e20ae3f09','1'),
(1230,53,'Fa0/8','down','ethernetCsmacd',0,'9c4e20ae3f0a','1'),
(1231,53,'Fa0/9','down','ethernetCsmacd',0,'9c4e20ae3f0b','1'),
(1232,53,'Fa0/10','up','ethernetCsmacd',1,'9c4e20ae3f0c','1'),
(1233,53,'Fa0/11','up','ethernetCsmacd',1,'9c4e20ae3f0d','1'),
(1234,53,'Fa0/12','down','ethernetCsmacd',0,'9c4e20ae3f0e','1'),
(1235,53,'Fa0/13','down','ethernetCsmacd',0,'9c4e20ae3f0f','1'),
(1236,53,'Fa0/14','down','ethernetCsmacd',0,'9c4e20ae3f10','1'),
(1237,53,'Fa0/15','down','ethernetCsmacd',0,'9c4e20ae3f11','1'),
(1238,53,'Fa0/16','down','ethernetCsmacd',0,'9c4e20ae3f12','1'),
(1239,53,'Fa0/17','down','ethernetCsmacd',0,'9c4e20ae3f13','1'),
(1240,53,'Fa0/18','down','ethernetCsmacd',0,'9c4e20ae3f14','1'),
(1241,53,'Fa0/19','down','ethernetCsmacd',0,'9c4e20ae3f15','1'),
(1242,53,'Fa0/20','down','ethernetCsmacd',0,'9c4e20ae3f16','1'),
(1243,53,'Fa0/21','down','ethernetCsmacd',0,'9c4e20ae3f17','1'),
(1244,53,'Fa0/22','down','ethernetCsmacd',0,'9c4e20ae3f18','1'),
(1245,53,'Fa0/23','down','ethernetCsmacd',0,'9c4e20ae3f19','1'),
(1246,53,'Fa0/24','down','ethernetCsmacd',0,'9c4e20ae3f1a','1'),
(1247,53,'Gi0/1','down','ethernetCsmacd',0,'9c4e20ae3f01','1'),
(1248,53,'Gi0/2','down','ethernetCsmacd',0,'9c4e20ae3f02','1'),
(1249,53,'Nu0','up','other',0,NULL,NULL);
/*!40000 ALTER TABLE `ports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routing_table`
--

DROP TABLE IF EXISTS `routing_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `routing_table` (
  `route_id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `destination` varchar(15) NOT NULL,
  `destination_prefixlen` varchar(2) NOT NULL,
  `nexthop` varchar(15) NOT NULL,
  PRIMARY KEY (`route_id`),
  KEY `IX_Relationship11` (`device_id`),
  CONSTRAINT `Relationship11` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routing_table`
--

LOCK TABLES `routing_table` WRITE;
/*!40000 ALTER TABLE `routing_table` DISABLE KEYS */;
INSERT INTO `routing_table` VALUES
(1,46,'0.0.0.0','0','192.168.1.100'),
(2,46,'127.0.0.0','8','127.0.0.1'),
(3,46,'127.0.0.1','32','127.0.0.1'),
(4,46,'127.255.255.255','32','127.0.0.1'),
(5,46,'192.168.1.0','24','192.168.1.10'),
(6,46,'192.168.1.10','32','192.168.1.10'),
(7,46,'192.168.1.255','32','192.168.1.10'),
(8,46,'224.0.0.0','4','127.0.0.1'),
(9,46,'255.255.255.255','32','127.0.0.1'),
(10,41,'8.8.8.8','32','172.16.0.6'),
(11,41,'172.16.0.0','30','0.0.0.0'),
(12,41,'172.16.0.1','32','0.0.0.0'),
(13,41,'172.16.0.4','30','0.0.0.0'),
(14,41,'172.16.0.5','32','0.0.0.0'),
(15,41,'172.16.0.8','30','192.168.1.2'),
(16,41,'172.16.0.8','30','192.168.2.1'),
(17,41,'172.16.0.8','30','192.168.99.2'),
(18,41,'192.168.1.0','24','0.0.0.0'),
(19,41,'192.168.1.1','32','0.0.0.0'),
(20,41,'192.168.2.0','24','0.0.0.0'),
(21,41,'192.168.2.2','32','0.0.0.0'),
(22,41,'192.168.99.0','24','0.0.0.0'),
(23,41,'192.168.99.1','32','0.0.0.0'),
(24,44,'8.8.8.8','32','192.168.1.1'),
(25,44,'8.8.8.8','32','192.168.2.2'),
(26,44,'8.8.8.8','32','192.168.99.1'),
(27,44,'172.16.0.0','30','0.0.0.0'),
(28,44,'172.16.0.2','32','0.0.0.0'),
(29,44,'172.16.0.4','30','192.168.1.1'),
(30,44,'172.16.0.4','30','192.168.2.2'),
(31,44,'172.16.0.4','30','192.168.99.1'),
(32,44,'172.16.0.8','30','0.0.0.0'),
(33,44,'172.16.0.9','32','0.0.0.0'),
(34,44,'192.168.1.0','24','0.0.0.0'),
(35,44,'192.168.1.2','32','0.0.0.0'),
(36,44,'192.168.2.0','24','0.0.0.0'),
(37,44,'192.168.2.1','32','0.0.0.0'),
(38,44,'192.168.99.0','24','0.0.0.0'),
(39,44,'192.168.99.2','32','0.0.0.0'),
(40,45,'8.8.8.0','24','0.0.0.0'),
(41,45,'8.8.8.8','32','0.0.0.0'),
(42,45,'172.16.0.0','30','172.16.0.5'),
(43,45,'172.16.0.4','30','0.0.0.0'),
(44,45,'172.16.0.6','32','0.0.0.0'),
(45,45,'172.16.0.8','30','0.0.0.0'),
(46,45,'172.16.0.10','32','0.0.0.0'),
(47,45,'192.168.1.0','24','172.16.0.5'),
(48,45,'192.168.1.0','24','172.16.0.9'),
(49,45,'192.168.2.0','24','172.16.0.5'),
(50,45,'192.168.2.0','24','172.16.0.9'),
(51,45,'192.168.99.0','24','172.16.0.5'),
(52,45,'192.168.99.0','24','172.16.0.9'),
(53,48,'0.0.0.0','0','192.168.2.1'),
(54,48,'0.0.0.0','0','192.168.31.1'),
(55,48,'192.168.2.0','24','0.0.0.0'),
(56,48,'192.168.31.0','24','0.0.0.0'),
(69,46,'0.0.0.0','0','192.168.1.100'),
(70,46,'127.0.0.0','8','127.0.0.1'),
(71,46,'127.0.0.1','32','127.0.0.1'),
(72,46,'127.255.255.255','32','127.0.0.1'),
(73,46,'192.168.1.0','24','192.168.1.10'),
(74,46,'192.168.1.10','32','192.168.1.10'),
(75,46,'192.168.1.255','32','192.168.1.10'),
(76,46,'224.0.0.0','4','127.0.0.1'),
(77,46,'255.255.255.255','32','127.0.0.1');
/*!40000 ALTER TABLE `routing_table` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-28 19:29:36
