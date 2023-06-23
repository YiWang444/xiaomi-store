-- MySQL dump 10.13  Distrib 8.0.33, for macos13 (arm64)
--
-- Host: 127.0.0.1    Database: storeDB
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `carousel`
--

DROP TABLE IF EXISTS `carousel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carousel` (
  `carousel_id` int NOT NULL AUTO_INCREMENT COMMENT '轮播ID',
  `img_path` char(200) NOT NULL COMMENT '轮播图图片路径',
  `describes` char(50) DEFAULT NULL COMMENT '轮播图描述',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`carousel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='轮播图表格';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carousel`
--

LOCK TABLES `carousel` WRITE;
/*!40000 ALTER TABLE `carousel` DISABLE KEYS */;
INSERT INTO `carousel` VALUES (1,'https://${path}/store_system/carousel/cms_1.jpg',NULL,0,1,'2023-06-17 00:00:55','2023-06-18 21:19:59'),(2,'https://${path}/store_system/carousel/cms_2.jpg',NULL,0,1,'2023-06-17 00:00:55','2023-06-18 21:19:59'),(3,'https://${path}/store_system/carousel/cms_3.jpg',NULL,0,1,'2023-06-17 00:00:55','2023-06-18 21:19:59'),(4,'https://${path}/store_system/carousel/cms_4.jpg',NULL,0,1,'2023-06-18 21:19:59','2023-06-18 21:19:59');
/*!40000 ALTER TABLE `carousel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `category_name` char(20) NOT NULL COMMENT '分类名称',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'手机',0,1,'2023-06-16 10:28:09','2023-06-16 10:28:09');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collect`
--

DROP TABLE IF EXISTS `collect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collect` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `FK_collect_user_id` (`user_id`),
  KEY `FK_collect_id` (`product_id`),
  CONSTRAINT `FK_collect_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `FK_collect_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collect`
--

LOCK TABLES `collect` WRITE;
/*!40000 ALTER TABLE `collect` DISABLE KEYS */;
INSERT INTO `collect` VALUES (6,1,2,0,0,'2023-06-18 15:46:43','2023-06-18 15:46:43');
/*!40000 ALTER TABLE `collect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion`
--

DROP TABLE IF EXISTS `discussion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussion` (
  `discussion_id` bigint NOT NULL AUTO_INCREMENT COMMENT '讨论 ID',
  `discussion_content` text NOT NULL COMMENT '讨论内容',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `user_id` int NOT NULL COMMENT '用户ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  PRIMARY KEY (`discussion_id`),
  KEY `FK_discussion_product_id` (`product_id`),
  KEY `FK_discussion_user_id` (`user_id`),
  CONSTRAINT `FK_discussion_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `FK_discussion_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='讨论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion`
--

LOCK TABLES `discussion` WRITE;
/*!40000 ALTER TABLE `discussion` DISABLE KEYS */;
INSERT INTO `discussion` VALUES (23,'chinaFa',0,1,'2023-06-23 00:41:03','2023-06-23 00:41:03',1,1),(24,'ee[嘻嘻][嘻嘻]',0,0,'2023-06-23 13:47:06','2023-06-23 13:47:06',1,1),(25,'heng[闭嘴][闭嘴]',0,0,'2023-06-23 13:51:25','2023-06-23 13:51:25',1,1),(26,'t1',0,0,'2023-06-23 15:02:47','2023-06-23 15:02:47',1,1),(27,'t2',0,0,'2023-06-23 15:02:50','2023-06-23 15:02:50',1,1),(28,'t3',0,0,'2023-06-23 15:02:51','2023-06-23 15:02:51',1,1),(29,'t4',0,0,'2023-06-23 15:02:53','2023-06-23 15:02:53',1,1),(30,'t5',0,0,'2023-06-23 15:02:56','2023-06-23 15:02:56',1,1),(31,'t6',0,0,'2023-06-23 15:02:58','2023-06-23 15:02:58',1,1),(32,'t7',0,0,'2023-06-23 15:02:59','2023-06-23 15:02:59',1,1),(33,'t8',0,0,'2023-06-23 15:03:01','2023-06-23 15:03:01',1,1),(34,'t9',0,0,'2023-06-23 15:03:03','2023-06-23 15:03:03',1,1),(35,'t10',0,0,'2023-06-23 15:03:06','2023-06-23 15:03:06',1,1),(36,'啊啊啊',0,0,'2023-06-23 16:03:08','2023-06-23 16:03:08',1,1),(37,'[嘻嘻][嘻嘻][嘻嘻]',0,0,'2023-06-23 16:25:48','2023-06-23 16:25:48',1,1),(38,'000[哈哈]',0,0,'2023-06-23 16:26:41','2023-06-23 16:26:41',1,1),(39,'[挖鼻][挖鼻][挖鼻][挖鼻]',0,0,'2023-06-23 16:28:15','2023-06-23 16:28:15',1,1),(40,'[哼][哼][哼]',0,0,'2023-06-23 16:30:24','2023-06-23 16:30:24',1,1),(41,'aaaaa[哈哈]',0,0,'2023-06-23 16:32:18','2023-06-23 16:32:18',1,1),(42,'[怒][怒][怒]',0,0,'2023-06-23 16:34:43','2023-06-23 16:34:43',1,1),(43,'[害羞][害羞][害羞]',0,0,'2023-06-23 16:36:22','2023-06-23 16:36:22',1,1),(44,'[嘻嘻][嘻嘻][嘻嘻]',0,0,'2023-06-23 16:39:25','2023-06-23 16:39:25',1,1),(45,'qqqqq',0,0,'2023-06-23 16:44:09','2023-06-23 16:44:09',1,1),(46,'[挖鼻][挖鼻][挖鼻]',0,0,'2023-06-23 16:45:33','2023-06-23 16:45:33',1,1),(47,'qqq',0,0,'2023-06-23 16:46:56','2023-06-23 16:46:56',1,1),(48,'嘻嘻笑',0,0,'2023-06-23 16:49:25','2023-06-23 16:49:25',1,1),(49,'oxx',0,0,'2023-06-23 16:52:08','2023-06-23 16:52:08',1,1),(50,'ppp[哈哈][哈哈][哈哈]',0,0,'2023-06-23 17:24:17','2023-06-23 17:24:17',1,2),(51,'[挤眼][挤眼]',0,0,'2023-06-23 17:42:16','2023-06-23 17:42:16',1,1),(52,'父评论',0,0,'2023-06-23 19:39:52','2023-06-23 19:39:52',1,1),(53,'父评论内容',0,0,'2023-06-23 19:40:50','2023-06-23 19:40:50',1,1);
/*!40000 ALTER TABLE `discussion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion_sub`
--

DROP TABLE IF EXISTS `discussion_sub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussion_sub` (
  `discussion_sub_id` bigint NOT NULL AUTO_INCREMENT COMMENT '讨论 ID',
  `discussion_content` text NOT NULL COMMENT '讨论内容',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `user_id` int NOT NULL COMMENT '用户ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `parent_id` bigint NOT NULL COMMENT '关联一级评论的唯一标识',
  `touch_id` int NOT NULL COMMENT '@的人',
  PRIMARY KEY (`discussion_sub_id`),
  KEY `FK_discussion_sub_product_id` (`product_id`),
  KEY `FK_discussion_sub_user_id` (`user_id`),
  KEY `FK_discussion_sub_parent_id` (`parent_id`),
  KEY `FK_discussion_sub_discussion_user_id` (`touch_id`),
  CONSTRAINT `FK_discussion_sub_discussion_user_id` FOREIGN KEY (`touch_id`) REFERENCES `discussion` (`user_id`),
  CONSTRAINT `FK_discussion_sub_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `discussion` (`discussion_id`),
  CONSTRAINT `FK_discussion_sub_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `FK_discussion_sub_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='讨论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion_sub`
--

LOCK TABLES `discussion_sub` WRITE;
/*!40000 ALTER TABLE `discussion_sub` DISABLE KEYS */;
INSERT INTO `discussion_sub` VALUES (131,'chinaChild',0,1,'2023-06-23 13:54:02','2023-06-23 13:54:02',1,1,23,1),(132,'qqqChild',0,1,'2023-06-23 13:54:02','2023-06-23 13:54:02',2,1,23,1),(133,'wwwChild',0,1,'2023-06-23 13:54:02','2023-06-23 13:54:02',10,1,23,1),(149,'woshiyi',0,0,'2023-06-23 16:30:33','2023-06-23 16:30:33',1,1,40,1),(150,'ssss',0,0,'2023-06-23 16:32:23','2023-06-23 16:32:23',1,1,41,1),(151,'444',0,0,'2023-06-23 16:34:49','2023-06-23 16:34:49',1,1,42,1),(152,'[微笑][微笑]',0,0,'2023-06-23 16:36:27','2023-06-23 16:36:27',1,1,43,1),(153,'[哈哈][哈哈][哈哈]',0,0,'2023-06-23 16:39:32','2023-06-23 16:39:32',1,1,44,1),(154,'wwwww',0,0,'2023-06-23 16:44:19','2023-06-23 16:44:19',1,1,45,1),(155,'qqq',0,0,'2023-06-23 16:45:39','2023-06-23 16:45:39',1,1,46,1),(156,'cccc',0,0,'2023-06-23 16:47:17','2023-06-23 16:47:17',1,1,47,1),(157,'啊啊啊',0,0,'2023-06-23 16:49:40','2023-06-23 16:49:40',1,1,48,1),(158,'ccc',0,0,'2023-06-23 16:52:22','2023-06-23 16:52:22',1,1,49,1),(159,'二级评论内容',0,0,'2023-06-23 19:45:47','2023-06-23 19:45:47',1,1,52,1),(160,'二级评论内容',0,0,'2023-06-23 19:46:18','2023-06-23 19:46:18',1,1,52,1);
/*!40000 ALTER TABLE `discussion_sub` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_id` bigint NOT NULL COMMENT '唯一订单号',
  `user_id` int NOT NULL COMMENT '用户ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `product_num` int NOT NULL COMMENT '商品数量',
  `product_price` int NOT NULL COMMENT '商品单价',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `FK_order_id` (`product_id`),
  KEY `FK_order_user_id` (`user_id`),
  CONSTRAINT `FK_order_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `FK_order_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (3,8358660979384451072,1,1,2,100,0,0,'2023-06-18 14:38:07','2023-06-18 14:38:07'),(4,8358660979384451072,1,2,3,200,0,0,'2023-06-18 14:38:07','2023-06-18 14:38:07'),(5,8358665674094608384,1,3,2,100,0,0,'2023-06-18 14:56:46','2023-06-18 14:56:46'),(6,8358665674094608384,1,2,3,200,0,0,'2023-06-18 14:56:46','2023-06-18 14:56:46'),(7,8358677217892040704,1,1,4,1000,0,0,'2023-06-18 15:42:38','2023-06-18 15:42:38'),(8,8358677217892040704,1,2,1,1599,0,0,'2023-06-18 15:42:38','2023-06-18 15:42:38'),(9,8358677217892040704,1,3,1,1799,0,0,'2023-06-18 15:42:38','2023-06-18 15:42:38'),(10,8360526269024632832,1,2,1,1599,0,0,'2023-06-23 18:10:06','2023-06-23 18:10:06'),(11,8360526269024632832,1,1,51,1000,0,0,'2023-06-23 18:10:06','2023-06-23 18:10:06'),(12,8360526552148541440,1,1,3,1000,0,0,'2023-06-23 18:11:14','2023-06-23 18:11:14'),(13,8360536748444811264,1,3,2,100,0,0,'2023-06-23 18:51:45','2023-06-23 18:51:45'),(14,8360536748444811264,1,2,3,200,0,0,'2023-06-23 18:51:45','2023-06-23 18:51:45');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `product_id` int NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `product_name` char(100) NOT NULL COMMENT '商品名称',
  `product_title` char(30) NOT NULL COMMENT '商品标题',
  `product_intro` text NOT NULL COMMENT '商品简介',
  `product_price` double NOT NULL COMMENT '商品标价',
  `product_num` int NOT NULL COMMENT '商品库存',
  `product_sales` int NOT NULL COMMENT '商品销量',
  `product_picture` char(200) DEFAULT NULL COMMENT '商品图片路径',
  `product_picture_desc` text COMMENT '商品图片描述',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `category_id` int NOT NULL COMMENT '分类ID',
  `product_selling_price` double DEFAULT NULL COMMENT '商品优惠价格',
  PRIMARY KEY (`product_id`),
  KEY `FK_product_category` (`category_id`),
  CONSTRAINT `FK_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Redmi K30','120Hz流速屏，全速热爱','120Hz高帧率流速屏/ 索尼6400万前后六摄 / 6.67\'小孔径全面屏 / 最高可选8GB+256GB大存储 / 高通骁龙730G处理器 / 3D四曲面玻璃机身 / 4500mAh+27W快充 / 多功能NFC',2000,16,100,'https://${path}/store_system/product/Redmi-k30.png',NULL,0,1,'2023-06-16 10:28:15','2023-06-23 18:11:14',1,1000),(2,'Redmi K30 5G','双模5G,120Hz流速屏','双模5G / 三路并发 / 高通骁龙765G / 7nm 5G低功耗处理器 / 120Hz高帧率流速屏 / 6.67\'小孔径全面屏 / 索尼6400万前后六摄 / 最高可选8GB+256GB大存储 / 4500mAh+30W快充 / 3D四曲面玻璃机身 / 多功能NFC',2599,-7,99,'public/imgs/phone/Redmi-k30-5G.png',NULL,0,1,'2023-06-16 10:28:15','2023-06-23 18:51:45',1,1599),(3,'小米CC9 Pro','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,15,0,'public/imgs/phone/Mi-CC9.png',NULL,0,1,'2023-06-16 10:28:15','2023-06-23 18:51:45',1,1799),(4,'小米test','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,0,NULL,NULL,0,1,'2023-06-16 21:47:37','2023-06-16 21:47:37',1,1799),(5,'2','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,0,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 15:37:15',1,1799),(6,'3','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,0,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 15:37:15',1,1799),(7,'4','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,200,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 16:03:20',1,1799),(8,'5','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,300,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 16:03:20',1,1799),(9,'6','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,400,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 16:03:20',1,1799),(10,'7','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,30,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 16:03:20',1,1799),(11,'8','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,40,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 16:03:20',1,1799),(12,'9','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,70,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 16:03:20',1,1799),(13,'11','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,90,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 16:03:20',1,1799),(14,'12','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,0,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 15:37:15',1,1799),(15,'13','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,0,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 15:37:15',1,1799),(16,'14','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,0,NULL,NULL,0,1,'2023-06-17 15:37:15','2023-06-17 15:37:15',1,1799),(17,'15','1亿像素,五摄四闪','1亿像素主摄 / 全场景五摄像头 / 四闪光灯 / 3200万自拍 / 10 倍混合光学变焦，50倍数字变焦 / 5260mAh ⼤电量 / 标配 30W疾速快充 / ⼩米⾸款超薄屏下指纹 / 德国莱茵低蓝光认证 / 多功能NFC / 红外万能遥控 / 1216超线性扬声器',2799,20,0,NULL,NULL,0,1,'2023-06-17 15:37:16','2023-06-17 15:37:16',1,1799);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_picture`
--

DROP TABLE IF EXISTS `product_picture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_picture` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `product_picture` char(200) DEFAULT NULL,
  `intro` text,
  PRIMARY KEY (`id`),
  KEY `FK_product_id` (`product_id`),
  CONSTRAINT `FK_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_picture`
--

LOCK TABLES `product_picture` WRITE;
/*!40000 ALTER TABLE `product_picture` DISABLE KEYS */;
INSERT INTO `product_picture` VALUES (1,1,'https://${path}/store_system/product/Redmi-k30-1.png',NULL),(2,1,'https://${path}/store_system/product/Redmi-k30-2.png',NULL),(3,1,'https://${path}/store_system/product/Redmi-k30-3.png',NULL),(4,1,'https://${path}/store_system/product/Redmi-k30-4.png',NULL),(23,1,'https://${path}/store_system/product/Redmi-k30-5.png',NULL);
/*!40000 ALTER TABLE `product_picture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_cart`
--

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_cart` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `num` int NOT NULL COMMENT '商品数量',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `checked` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否被选中',
  PRIMARY KEY (`id`),
  KEY `FK_user_id` (`user_id`),
  KEY `FK_shoppingCart_id` (`product_id`),
  CONSTRAINT `FK_shoppingCart_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `FK_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_cart`
--

LOCK TABLES `shopping_cart` WRITE;
/*!40000 ALTER TABLE `shopping_cart` DISABLE KEYS */;
INSERT INTO `shopping_cart` VALUES (16,1,1,11,0,0,'2023-06-23 18:28:32','2023-06-23 18:30:56',0);
/*!40000 ALTER TABLE `shopping_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` char(40) NOT NULL COMMENT '用户名',
  `password` char(40) NOT NULL COMMENT '密码',
  `telephone` char(11) DEFAULT NULL COMMENT '电话号码',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `version` int NOT NULL DEFAULT '1' COMMENT '乐观锁版本号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `user_img` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'张三','asd123','',0,0,'2023-06-15 22:54:43','2023-06-23 19:21:40','https://${path}/store_system/user/a4d31c15e9d3282a39b4b38db83f3537.jpg'),(2,'qqqqqq','qqqqqq',NULL,0,0,'2023-06-18 00:34:44','2023-06-21 14:53:12','https://${path}/store_system/user/%E5%A4%B4%E5%83%8F2.jpg'),(10,'wwwww','wwwww',NULL,0,1,'2023-06-21 14:53:30','2023-06-21 14:53:30',NULL),(11,'zhagsn','123456',NULL,0,0,'2023-06-23 18:27:21','2023-06-23 18:27:21',NULL);
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

-- Dump completed on 2023-06-23 20:23:58
