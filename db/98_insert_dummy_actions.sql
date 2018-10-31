--
-- Dumping data for table `action_fields`
--

LOCK TABLES `action_fields` WRITE;
/*!40000 ALTER TABLE `action_fields` DISABLE KEYS */;
INSERT INTO `action_fields` VALUES (1,1,'対象患者ID',1,'barcode',13,13,'\"^9\"',10,'1','2013-10-16 09:11:18',1,'2013-10-25 05:00:22',2,NULL,NULL),(2,2,'洗浄機器ID',1,'barcode',13,13,'\"^5\"',10,'2','2013-10-16 09:11:41',1,'2013-10-25 04:54:33',2,NULL,NULL),(3,2,'洗浄種別',1,'input',NULL,NULL,NULL,20,'3','2013-10-16 09:11:41',1,'2013-10-25 04:54:33',2,NULL,NULL),(4,1,'対象患者ID',1,'barcode',5,10,NULL,10,'1','2013-10-16 10:37:40',1,'2013-10-16 01:40:28',1,'2013-10-16 10:40:28',NULL),(5,1,'対象患者ID',1,'barcode',NULL,10,NULL,10,'4','2013-10-16 10:40:28',1,'2013-10-16 01:43:02',1,'2013-10-16 10:43:02',NULL),(6,1,'対象患者ID',1,'barcode',NULL,10,NULL,10,'6','2013-10-16 10:43:02',1,'2013-10-16 01:47:42',2,'2013-10-16 10:47:42',NULL);
/*!40000 ALTER TABLE `action_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
INSERT INTO `actions` VALUES (1,'利用開始',2,2,'スキャンしたスコープは既に”利用開始”されていますが、続けますか？','2013-10-16 09:11:18',1,'2013-10-25 05:00:22',1,NULL,NULL),(2,'洗浄・消毒終了',0,NULL,NULL,'2013-10-16 09:11:41',1,'2013-10-25 04:54:33',1,NULL,NULL);
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;

