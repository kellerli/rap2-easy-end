use mysql;

drop database if exists `rap2`;

create database if not exists rap2 default charset utf8 collate utf8_general_ci;
flush privileges;

use rap2;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `Interfaces`
-- ----------------------------
DROP TABLE IF EXISTS `Interfaces`;
CREATE TABLE `Interfaces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `url` varchar(256) NOT NULL,
  `method` enum('GET','POST','PUT','DELETE') NOT NULL,
  `description` text,
  `priority` bigint(20) NOT NULL DEFAULT '1',
  `creatorId` int(11) DEFAULT NULL,
  `lockerId` int(11) DEFAULT NULL,
  `moduleId` int(11) DEFAULT NULL,
  `repositoryId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `creatorId` (`creatorId`),
  KEY `lockerId` (`lockerId`),
  KEY `moduleId` (`moduleId`),
  KEY `repositoryId` (`repositoryId`),
  CONSTRAINT `Interfaces_ibfk_1` FOREIGN KEY (`creatorId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Interfaces_ibfk_2` FOREIGN KEY (`lockerId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Interfaces_ibfk_3` FOREIGN KEY (`moduleId`) REFERENCES `Modules` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Interfaces_ibfk_4` FOREIGN KEY (`repositoryId`) REFERENCES `Repositories` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Loggers`
-- ----------------------------
DROP TABLE IF EXISTS `Loggers`;
CREATE TABLE `Loggers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('create','update','delete','lock','unlock','join','exit') NOT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `organizationId` int(11) DEFAULT NULL,
  `repositoryId` int(11) DEFAULT NULL,
  `moduleId` int(11) DEFAULT NULL,
  `interfaceId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `creatorId` (`creatorId`),
  KEY `userId` (`userId`),
  KEY `organizationId` (`organizationId`),
  KEY `repositoryId` (`repositoryId`),
  KEY `moduleId` (`moduleId`),
  KEY `interfaceId` (`interfaceId`),
  CONSTRAINT `Loggers_ibfk_1` FOREIGN KEY (`creatorId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Loggers_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Loggers_ibfk_3` FOREIGN KEY (`organizationId`) REFERENCES `Organizations` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Loggers_ibfk_4` FOREIGN KEY (`repositoryId`) REFERENCES `Repositories` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Loggers_ibfk_5` FOREIGN KEY (`moduleId`) REFERENCES `Modules` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Loggers_ibfk_6` FOREIGN KEY (`interfaceId`) REFERENCES `Interfaces` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Modules`
-- ----------------------------
DROP TABLE IF EXISTS `Modules`;
CREATE TABLE `Modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `description` text NOT NULL,
  `priority` bigint(20) NOT NULL DEFAULT '1',
  `creatorId` int(11) DEFAULT NULL,
  `repositoryId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `creatorId` (`creatorId`),
  KEY `repositoryId` (`repositoryId`),
  CONSTRAINT `Modules_ibfk_1` FOREIGN KEY (`creatorId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Modules_ibfk_2` FOREIGN KEY (`repositoryId`) REFERENCES `Repositories` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Notifications`
-- ----------------------------
DROP TABLE IF EXISTS `Notifications`;
CREATE TABLE `Notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fromId` int(11) DEFAULT NULL,
  `toId` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `param1` varchar(128) DEFAULT NULL,
  `param2` varchar(128) DEFAULT NULL,
  `param3` varchar(128) DEFAULT NULL,
  `readed` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Organizations`
-- ----------------------------
DROP TABLE IF EXISTS `Organizations`;
CREATE TABLE `Organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `description` text,
  `logo` varchar(256) DEFAULT NULL,
  `visibility` tinyint(1) NOT NULL DEFAULT '1',
  `creatorId` int(11) DEFAULT NULL,
  `ownerId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `creatorId` (`creatorId`),
  KEY `ownerId` (`ownerId`),
  CONSTRAINT `Organizations_ibfk_1` FOREIGN KEY (`creatorId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Organizations_ibfk_2` FOREIGN KEY (`ownerId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Properties`
-- ----------------------------
DROP TABLE IF EXISTS `Properties`;
CREATE TABLE `Properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scope` enum('request','response') NOT NULL DEFAULT 'response',
  `type` enum('String','Number','Boolean','Object','Array','Function','RegExp') NOT NULL,
  `name` varchar(256) NOT NULL,
  `rule` varchar(128) DEFAULT NULL,
  `value` text,
  `description` text,
  `parentId` int(11) NOT NULL DEFAULT '-1',
  `priority` bigint(20) NOT NULL DEFAULT '1',
  `interfaceId` int(11) DEFAULT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `moduleId` int(11) DEFAULT NULL,
  `repositoryId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `interfaceId` (`interfaceId`),
  KEY `creatorId` (`creatorId`),
  KEY `moduleId` (`moduleId`),
  KEY `repositoryId` (`repositoryId`),
  CONSTRAINT `Properties_ibfk_1` FOREIGN KEY (`interfaceId`) REFERENCES `Interfaces` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Properties_ibfk_2` FOREIGN KEY (`creatorId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Properties_ibfk_3` FOREIGN KEY (`moduleId`) REFERENCES `Modules` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Properties_ibfk_4` FOREIGN KEY (`repositoryId`) REFERENCES `Repositories` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=811 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Repositories`
-- ----------------------------
DROP TABLE IF EXISTS `Repositories`;
CREATE TABLE `Repositories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `description` text,
  `logo` varchar(256) DEFAULT NULL,
  `visibility` tinyint(1) NOT NULL DEFAULT '1',
  `ownerId` int(11) DEFAULT NULL,
  `organizationId` int(11) DEFAULT NULL,
  `creatorId` int(11) DEFAULT NULL,
  `lockerId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ownerId` (`ownerId`),
  KEY `organizationId` (`organizationId`),
  KEY `creatorId` (`creatorId`),
  KEY `lockerId` (`lockerId`),
  CONSTRAINT `Repositories_ibfk_1` FOREIGN KEY (`ownerId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Repositories_ibfk_2` FOREIGN KEY (`organizationId`) REFERENCES `Organizations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Repositories_ibfk_3` FOREIGN KEY (`creatorId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `Repositories_ibfk_4` FOREIGN KEY (`lockerId`) REFERENCES `Users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Users`
-- ----------------------------
DROP TABLE IF EXISTS `Users`;
CREATE TABLE `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fullname` varchar(32) NOT NULL,
  `password` varchar(32) DEFAULT NULL,
  `email` varchar(128) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=100000012 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `foreign_room`
-- ----------------------------
DROP TABLE IF EXISTS `foreign_room`;
CREATE TABLE `foreign_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `repositoryId` bigint(20) DEFAULT NULL,
  `roomProjectId` bigint(20) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `organizations_members`
-- ----------------------------
DROP TABLE IF EXISTS `organizations_members`;
CREATE TABLE `organizations_members` (
  `userId` int(11) NOT NULL,
  `organizationId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`userId`,`organizationId`),
  UNIQUE KEY `organizations_members_userId_organizationId_unique` (`userId`,`organizationId`),
  KEY `organizationId` (`organizationId`),
  CONSTRAINT `organizations_members_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `organizations_members_ibfk_2` FOREIGN KEY (`organizationId`) REFERENCES `Organizations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `repositories_collaborators`
-- ----------------------------
DROP TABLE IF EXISTS `repositories_collaborators`;
CREATE TABLE `repositories_collaborators` (
  `repositoryId` int(11) NOT NULL,
  `collaboratorId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`repositoryId`,`collaboratorId`),
  UNIQUE KEY `repositories_collaborators_repositoryId_repositoryId_unique` (`repositoryId`),
  UNIQUE KEY `repositories_collaborators_collaboratorId_repositoryId_unique` (`collaboratorId`),
  CONSTRAINT `repositories_collaborators_ibfk_1` FOREIGN KEY (`repositoryId`) REFERENCES `Repositories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `repositories_collaborators_ibfk_2` FOREIGN KEY (`collaboratorId`) REFERENCES `Repositories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `repositories_members`
-- ----------------------------
DROP TABLE IF EXISTS `repositories_members`;
CREATE TABLE `repositories_members` (
  `repositoryId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  PRIMARY KEY (`repositoryId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `repositories_members_ibfk_1` FOREIGN KEY (`repositoryId`) REFERENCES `Repositories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `repositories_members_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;

/**

由于默认初始化的数据,对于强迫症的人来说,这个文件比较合适你.

进入容器(eg):
docker exec -it rap2-easy-end bash

vi clean_all_data.sql (复制该文本内容)
mysql -u root -p < clean_all_data.sql
输入密码(123456)

*/
