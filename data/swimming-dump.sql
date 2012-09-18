-- phpMyAdmin SQL Dump
-- version 2.6.4-pl2
-- http://www.phpmyadmin.net
-- 
-- Host: mysql18.freehostia.com
-- Generation Time: Jul 11, 2011 at 08:52 PM
-- Server version: 5.1.50
-- PHP Version: 5.2.6-1+lenny9
-- 
-- Database: `enzarl7_swim`
-- 
CREATE DATABASE `enzarl7_swim` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE enzarl7_swim;

-- --------------------------------------------------------

-- 
-- Table structure for table `groups`
-- 

CREATE TABLE `groups` (
  `id` int(11) NOT NULL,
  `id_event` int(11) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `dt_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_group` (`id_event`,`id_user`),
  KEY `fk_groups_event` (`id_event`),
  KEY `fk_groups_user` (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table `groups`
-- 


-- --------------------------------------------------------

-- 
-- Table structure for table `location`
-- 

CREATE TABLE `location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `dt_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COMMENT='Location where event is help' AUTO_INCREMENT=9 ;

-- 
-- Dumping data for table `location`
-- 

INSERT INTO `location` VALUES (1, 'Seriate', '2011-03-31 21:10:57');
INSERT INTO `location` VALUES (2, 'Bonate Sotto', '2011-03-31 21:10:57');
INSERT INTO `location` VALUES (3, 'Ponte San Pietro', '2011-03-31 21:11:43');
INSERT INTO `location` VALUES (4, 'Trezzo Sull Adda', '2011-03-31 21:11:43');
INSERT INTO `location` VALUES (5, 'Sotto Il Monte', '2011-03-31 21:12:14');
INSERT INTO `location` VALUES (6, 'Grumello Del Monte', '2011-03-31 21:13:22');
INSERT INTO `location` VALUES (7, 'Bonate Sopra', '2011-03-31 21:12:40');
INSERT INTO `location` VALUES (8, 'Brembate', '2011-03-31 21:12:40');

-- --------------------------------------------------------

-- 
-- Table structure for table `planned_event`
-- 

CREATE TABLE `planned_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `id_activity` int(11) NOT NULL,
  `id_location` int(11) NOT NULL,
  `data` datetime NOT NULL,
  `dt_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_planned_event_1` (`id_activity`),
  KEY `fk_planned_event_2` (`id_location`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- 
-- Dumping data for table `planned_event`
-- 


-- --------------------------------------------------------

-- 
-- Table structure for table `session_connect`
-- 

CREATE TABLE `session_connect` (
  `id` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `hash_code` varchar(45) DEFAULT NULL,
  `dt_mod` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`id_user`),
  KEY `fk_session_connect_1` (`id_user`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table `session_connect`
-- 

INSERT INTO `session_connect` VALUES (2, '2011-05-12 22:55:07', 37, '37 pippo piIzbflOaDn1Q', '2011-05-12 20:55:07');
INSERT INTO `session_connect` VALUES (3, '2011-05-13 21:27:03', 39, '39 test2 teQQwcylHUKpA', '2011-05-13 19:27:03');
INSERT INTO `session_connect` VALUES (4, '2011-05-13 21:59:49', 37, 'picco', '2011-05-13 19:59:49');
INSERT INTO `session_connect` VALUES (0, '2011-05-17 21:32:35', 35, '35 enzo2 enbM9DiQm1gak', '2011-05-17 19:32:35');

-- --------------------------------------------------------

-- 
-- Table structure for table `type_activity`
-- 

CREATE TABLE `type_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `dt_mod` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COMMENT='tipo di attivita eseguita' AUTO_INCREMENT=5 ;

-- 
-- Dumping data for table `type_activity`
-- 

INSERT INTO `type_activity` VALUES (1, 'Piscina', '2011-03-31 20:57:57');
INSERT INTO `type_activity` VALUES (2, 'Corsa a piedi', '2011-03-31 20:57:57');
INSERT INTO `type_activity` VALUES (3, 'Mountain Byke', '2011-03-31 20:57:57');
INSERT INTO `type_activity` VALUES (4, 'Sesso sfrenato', '2011-03-31 20:57:57');

-- --------------------------------------------------------

-- 
-- Table structure for table `user_profile`
-- 

CREATE TABLE `user_profile` (
  `id` int(11) NOT NULL DEFAULT '0',
  `descrizione` varchar(200) NOT NULL DEFAULT '',
  `dt_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user_profile_1` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- 
-- Dumping data for table `user_profile`
-- 


-- --------------------------------------------------------

-- 
-- Table structure for table `users`
-- 

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `pwd` varchar(30) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `dt_mod` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `email` varchar(90) DEFAULT NULL,
  `email2` varchar(90) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user` (`user`)
) ENGINE=MyISAM AUTO_INCREMENT=43 DEFAULT CHARSET=latin1 AUTO_INCREMENT=43 ;

-- 
-- Dumping data for table `users`
-- 

INSERT INTO `users` VALUES (36, 'user2', '', 0, '2011-05-15 21:17:38', NULL, '');
INSERT INTO `users` VALUES (35, 'enzo2', 'enceytNlzdmaU', 1, '2011-05-02 21:36:42', NULL, '');
INSERT INTO `users` VALUES (38, 'test1', '', 1, '2011-05-15 21:17:17', NULL, '');
INSERT INTO `users` VALUES (39, 'test2', '', 1, '2011-05-13 19:28:00', NULL, '');
INSERT INTO `users` VALUES (40, 'test3', 'teH0wLIpW0gyQ', 0, '2011-05-11 19:48:25', NULL, '');
INSERT INTO `users` VALUES (21, 'enzo', '', 1, '2011-05-17 19:31:57', NULL, '');
INSERT INTO `users` VALUES (37, 'pippo', 'pilstH2iw/zY.', 1, '2011-05-03 20:28:58', NULL, '');
INSERT INTO `users` VALUES (41, 'provolone', 'test', 1, '2011-05-19 21:52:08', NULL, '');
INSERT INTO `users` VALUES (42, 'test4', 'teH0wLIpW0gyQ', 1, '2011-05-20 22:00:51', 'test.tost@libero.it', '');
