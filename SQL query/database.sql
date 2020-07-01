/*
SQLyog Community v13.1.5  (64 bit)
MySQL - 5.7.25 : Database - next_social
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`next_social` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `next_social`;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `user` */
DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `unickname` char(100) NOT NULL,
  `aid` char(100) NOT NULL,
  `uapt` char(100) DEFAULT NULL,
  `uphoto` char(100) DEFAULT NULL,
  `uemail` char(100) DEFAULT NULL,
  `registeration_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`uid`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`aid`) REFERENCES `address` (`aid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_ibfk_2` FOREIGN KEY (`unickname`) REFERENCES `user_credential` (`unickname`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ALTER TABLE USER
-- ADD CONSTRAINT `user_ibfk_2` FOREIGN KEY (`unickname`) REFERENCES `user_credential` (`unickname`) ON DELETE CASCADE ON UPDATE CASCADE;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `user_credential` */

DROP TABLE IF EXISTS `user_credential`;

CREATE TABLE `user_credential` (
  `unickname` char(100) NOT NULL,
  `password` char(100) NOT NULL,
  
  PRIMARY KEY (`unickname`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `profile` */

DROP TABLE IF EXISTS `profile`;

CREATE TABLE `profile` (
  `uid` int(11) NOT NULL,
  `page` char(100),
  `pname` char(100),
  PRIMARY KEY (`uid`),
  CONSTRAINT `profile_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `profile` */

-- insert  into `profile`(`uid`,`page`,`pname`) values
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `family` */

DROP TABLE IF EXISTS `family`;

CREATE TABLE `family` (
  `uid` int(11) NOT NULL,
  `fmember` char(100) NOT NULL,
  `ftimestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ftype` char(100) NOT NULL,
  `fphoto` char(100),

  PRIMARY KEY (`uid`,`fmember`,`ftimestamp`),
  CONSTRAINT `family_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `family` */

-- insert  into `family`(`uid`,`fmember`,`ftimestamp`,`ftype`,`fphoto`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `member_application` */

DROP TABLE IF EXISTS `member_application`;

CREATE TABLE `member_application` (
  `mappid` int(11) NOT NULL AUTO_INCREMENT,
  `mid` char(100) NOT NULL,
  `application_uid` int(11) NOT NULL,
  `approve_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`mappid`),
  CONSTRAINT `member_application_ibfk_1` FOREIGN KEY (`application_uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `member_application_ibfk_2` FOREIGN KEY (`mid`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;


alter table member_application
ADD `flag` char(100) DEFAULT (0);

/*Data for the table `member_application` */

-- insert  into `member_application`(`mappid`,`mid`,`application_uid`,`approve_time`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `member` */

DROP TABLE IF EXISTS `member`;

CREATE TABLE `member` (
  `mid` char(100) NOT NULL,
  `uid` int(11) NOT NULL,
  `bid` char(100) NOT NULL,
  `mstart_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`mid`),
  CONSTRAINT `member_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `member_ibfk_2` FOREIGN KEY (`bid`) REFERENCES `block` (`bid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `member` */

-- insert  into `member`(`mid`,`uid`,`bid`,`mstart_time`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `friendship` */
-- Alter table friend_application rename to friendship;

DROP TABLE IF EXISTS `friendship`;

CREATE TABLE `friendship` (
  `f_app_id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mid_request` char(100) NOT NULL,
  `mid_reply` char(100) NOT NULL,
  `status` char(100) DEFAULT NULL,

  PRIMARY KEY (`f_app_id`),
  CONSTRAINT `friendship_ibfk_1` FOREIGN KEY (`mid_request`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `friendship_ibfk_2` FOREIGN KEY (`mid_reply`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `friendship` */

-- insert  into `friendship`(`timestamp`,`uid_request`,`uid_reply`,`status`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `friend_relation` */

-- DROP TABLE IF EXISTS `friend_relation`;

-- CREATE TABLE `friend_relation` (
--   `fid` char(100) NOT NULL,
--   `mid_1` char(100) NOT NULL,
--   `mid_2` char(100) NOT NULL,
--   `ftimestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

--   PRIMARY KEY (`fid`),
--   CONSTRAINT `friend_relation_ibfk_1` FOREIGN KEY (`mid_1`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE,
--   CONSTRAINT `friend_relation_ibfk_2` FOREIGN KEY (`mid_2`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE

-- ) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `friend_relation` */

-- insert  into `friend_relation`(`fid`,`mid_1`,`mid_2`,`ftimestamp`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `hood` */

DROP TABLE IF EXISTS `hood`;

CREATE TABLE `hood` (
  `hid` char(100) NOT NULL,
  `hoodname` char(100) NOT NULL,
  `hlongtitude_sw` double NOT NULL,
  `hlatitude_sw` double NOT NULL,
  `hlongtitude_ne` double NOT NULL,
  `hlatitude_ne` double NOT NULL,
  
  PRIMARY KEY (`hid`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `hood` */

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `block` */

DROP TABLE IF EXISTS `block`;

CREATE TABLE `block` (
  `bid` char(100) NOT NULL,
  `hid` char(100) NOT NULL,
  `blockname` char(100) NOT NULL,
  `blongtitude_sw` double NOT NULL,
  `blatitude_sw` double NOT NULL,
  `blongtitude_ne` double NOT NULL,
  `blatitude_ne` double NOT NULL,
  
  PRIMARY KEY (`bid`),
  CONSTRAINT `block_ibfk_1` FOREIGN KEY (`hid`) REFERENCES `hood` (`hid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `block` */

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `address` */

DROP TABLE IF EXISTS `address`;

CREATE TABLE `address` (
  `aid` char(100) NOT NULL,
  `bid` char(100) NOT NULL,
  `aname` char(100) NOT NULL,
  `alongtitude` double NOT NULL,
  `alatitude` double NOT NULL,
  
  PRIMARY KEY (`aid`),
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`bid`) REFERENCES `block` (`bid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `address` */

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `thread` */

DROP TABLE IF EXISTS `thread`;

CREATE TABLE `thread` (
  `tid` char(100) NOT NULL,
  `auth_id` char(100) NOT NULL,
  `sid` char(100) NOT NULL,
  `author` char(100) NOT NULL,
  `title` char(100) NOT NULL,
  `textbody` char(100) NOT NULL,
  `threadtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  
  PRIMARY KEY (`tid`),
  CONSTRAINT `thread_ibfk_1` FOREIGN KEY (`auth_id`) REFERENCES `authentication` (`auth_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `thread_ibfk_2` FOREIGN KEY (`sid`) REFERENCES `subject` (`sid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `thread_ibfk_3` FOREIGN KEY (`author`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE


) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `thread` */

-- insert  into `thread`(`tid`,`auth_id`,`sid`,`author`,`title`,`textbody`,`threadtime`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `message` */

DROP TABLE IF EXISTS `message`;

CREATE TABLE `message` (
  `message_id` char(100) NOT NULL,
  `tid` char(100) NOT NULL,
  `mreplyid` char(100) NOT NULL,
  `mtextbody` char(100) NULL,
  `mreplytime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  
  PRIMARY KEY (`message_id`,`tid`),
  CONSTRAINT `message_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `thread` (`tid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `message_ibfk_2` FOREIGN KEY (`mreplyid`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE


) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `message` */

-- insert  into `message`(`message_id`,`tid`,`mreplyid`,`mtextbody`,`mreplytime`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `authentication` */

DROP TABLE IF EXISTS `authentication`;

CREATE TABLE `authentication` (
  `auth_id` char(100) NOT NULL,
  `recipient_tyoe` char(100) NOT NULL,
  
  PRIMARY KEY (`auth_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `authentication` */

-- insert  into `authentication`(`auth_id`,`recipient_ty0e`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `subject` */

DROP TABLE IF EXISTS `subject`;

CREATE TABLE `subject` (
  `sid` char(100) NOT NULL,
  `subject_name` char(100) NOT NULL,
  
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `subject` */
-- insert  into `subject`(`sid`,`subject_name`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `logout` */

DROP TABLE IF EXISTS `logout`;

CREATE TABLE `logout` (
  `mid` char(100) NOT NULL,
  `logout_time`  timestamp,
  `login_time`  timestamp,

  
  PRIMARY KEY (`mid`),
  CONSTRAINT `logout_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `logout` */

-- insert  into `logout`(`mid`,`logout_time`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `move` */

DROP TABLE IF EXISTS `move`;

CREATE TABLE `move` (
  `moveid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `old_bid` char(100) NOT NULL,
  `new_aid` char(100) NOT NULL,
  `apply_timestamp`  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`moveid`),
  CONSTRAINT `move_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `move_ibfk_2` FOREIGN KEY (`old_bid`) REFERENCES `block` (`bid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `move_ibfk_3` FOREIGN KEY (`new_aid`) REFERENCES `address` (`aid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `move` */

-- insert  into `move`(`moveid`,`uid`,`old_bid`,`new_bid`,`apply_timestamp`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `one_friend_thread` */

DROP TABLE IF EXISTS `one_friend_thread`;

CREATE TABLE `one_friend_thread` (
  `tid` char(100) NOT NULL,
  `send_mid` char(100) NOT NULL,
  `receive_mid` char(100) NOT NULL,
  `send_timestamp`  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`tid`),
  CONSTRAINT `one_friend_thread_ibfk_1` FOREIGN KEY (`send_mid`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `one_friend_thread_ibfk_2` FOREIGN KEY (`receive_mid`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `one_friend_thread_ibfk_3` FOREIGN KEY (`tid`) REFERENCES `thread` (`tid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `one_friend_thread_ibfk_1` */

-- insert  into `one_friend_thread_ibfk_1`(`tid`,`send_mid`,`receive_mid`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `one_neighbor_thread` */

DROP TABLE IF EXISTS `one_neighbor_thread`;

CREATE TABLE `one_neighbor_thread` (
  `tid` char(100) NOT NULL,
  `send_mid` char(100) NOT NULL,
  `receive_mid` char(100) NOT NULL,
  `send_timestamp`  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  PRIMARY KEY (`tid`),
  CONSTRAINT `one_neighbor_thread_ibfk_1` FOREIGN KEY (`send_mid`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `one_neighbor_thread_ibfk_2` FOREIGN KEY (`receive_mid`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `one_neighbor_thread_ibfk_3` FOREIGN KEY (`tid`) REFERENCES `thread` (`tid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `one_neighbor_thread_ibfk_1` */

-- insert  into `one_neighbor_thread_ibfk_1`(`tid`,`send_mid`,`receive_mid`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Table structure for table `thread_visible` */

DROP TABLE IF EXISTS `thread_visible`;

CREATE TABLE `thread_visible` (
  `tid` char(100) NOT NULL,
  `mid` char(100) NOT NULL,
  
  PRIMARY KEY (`tid`,`mid`),
  CONSTRAINT `thread_visible_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `thread` (`tid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `thread_visible_ibfk_2` FOREIGN KEY (`mid`) REFERENCES `member` (`mid`) ON DELETE CASCADE ON UPDATE CASCADE

) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

/*Data for the table `thread_visible` */

-- insert  into `thread_visible`(`tid`,`mid`) values 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
