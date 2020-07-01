USE `next_social`;


-- insert  into `hood`(`hid`,`hoodname`,`hlongtitude_sw`,`hlatitude_sw`,`hlongtitude_ne`,`hlatitude_ne`) values 
-- ('h1','happy',31,28,40,40),
-- ('h2','bay',20,20,40,28),
-- ('h3','downtown',20,28,31,40);

-- insert  into `block`(`bid`,`hid`,`blockname`,`blongtitude_sw`,`blatitude_sw`,`blongtitude_ne`,`blatitude_ne`) values 
-- ('b1','h1','mini_block',31,28,40,40),
-- ('b2','h2','second_block',36,20,40,28),
-- ('b3','h2','third_block',31,20,36,28),
-- ('b4','h2','first_block',24,20,31,28),
-- ('b5','h2','fourth_block',20,20,24,28),
-- ('b6','h3','left_block',20,28,31,35),
-- ('b7','h3','right_block',20,35,31,40);
-- select title, textbody, author, unickname
--              from thread t, next_social.member m, user u
--              where t.author = m.mid and u.uid = m.uid;


-- insert  into `address`(`aid`,`bid`,`aname`,`alongtitude`,`alatitude`) values 
-- ('a1','b1','School_Laurels',33,35),
-- ('a2','b1','Cowley_Ride',37,35),
-- ('a3','b1','Flamingo_Court',34,31),
-- ('a4','b1','Hospital_West',37,32),
-- ('a5','b2','Padley_Wood_Lane',38,25),
-- ('a6','b3','Mountague_Place',33,27),
-- ('a7','b3','Hereford_Glade',35,22),
-- ('a8','b4','609_Bishop_Street',30,27),
-- ('a9','b4','500_Water_Street',27,24),
-- ('a10','b4','609_Fire_Street',25,21),
-- ('a11','b5','Jay_Street',23,26),
-- ('a12','b5','Academy_Court',21,23),
-- ('a13','b6','Rockland_Rd',22,34),
-- ('a14','b7','Roosevelt_Rd',24,36),
-- ('a15','b7','Catherine_Ave',27,38);


-- /*Data for the table `user` */
-- insert  into `user`(`uid`,`unickname`,`aid`,`uapt`,`uphoto`,`uemail`,`registeration_time`) values
-- (1,'abby','a1',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (2,'allie','a2',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (3,'bella','a4',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (4,'bob','a4',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (5,'ban','a4',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (6,'ben','a5',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (7,'jan','a5',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (8,'gus','a5',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (9,'boy','a5',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (10,'evie','a7',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (11,'amy','a8',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (12,'jack','a9',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (13,'jermy','a10',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (14,'leo','a10',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (15,'max','a11',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (16,'dan','a11',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (17,'nick','a13',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (18,'jacky','a13',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (19,'sam','a14',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (20,'ray','a15',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (21,'ted','a13',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (22,'teddy','a3',NULL,NULL,NULL,'2018-02-09 21:59:00'),
-- (23,'tom','a9',NULL,NULL,NULL,'2018-02-09 21:59:00');


-- insert  into `member`(`mid`,`uid`,`bid`,`mstart_time`) values 
-- ('b1m1',1,'b1','2018-02-09 22:59:00'),
-- ('b1m2',2,'b1','2018-02-09 22:59:00'),
-- ('b1m3',3,'b1','2018-02-09 22:59:00'),
-- ('b1m4',4,'b1','2018-02-09 22:59:00'),
-- ('b1m5',5,'b1','2018-02-09 22:59:00'),
-- ('b2m1',6,'b2','2018-02-09 22:59:00'),
-- ('b2m2',7,'b2','2018-02-09 22:59:00'),
-- ('b2m3',8,'b2','2018-02-09 22:59:00'),
-- ('b2m4',9,'b2','2018-02-09 22:59:00'),
-- ('b3m1',10,'b3','2018-02-09 22:59:00'),
-- ('b4m1',11,'b4','2018-02-09 22:59:00'),
-- ('b4m2',12,'b4','2018-02-09 23:59:00'),
-- ('b4m3',13,'b4','2018-02-09 23:59:00'),
-- ('b4m4',14,'b4','2018-02-09 23:09:00'),
-- ('b5m1',15,'b5','2018-02-10 21:59:00'),
-- ('b5m2',16,'b5','2018-02-09 21:59:00'),
-- ('b6m1',17,'b6','2018-02-10 21:59:00'),
-- ('b6m2',18,'b6','2018-02-09 21:59:00'),
-- ('b7m1',19,'b7','2018-02-11 21:59:00'),
-- ('b7m2',20,'b7','2018-02-09 21:59:00');


-- insert  into `subject`(`sid`,`subject_name`) values
-- -- ('s1','food'),
-- -- ('s2','travel'),
-- -- ('s3','sell'),
-- -- ('s4','pets'),
-- -- ('s5','music');
-- ('s6', 'others');

-- insert  into `authentication`(`auth_id`,`recipient_tyoe`) values 
-- ('auth1','one friend'),
-- ('auth2','one neighbor'),
-- ('auth3','all friends'),
-- ('auth4','all neighbors'),
-- ('auth5','entire block'),
-- ('auth6','entire hood');

-- insert  into `thread`(`tid`,`auth_id`,`sid`,`author`,`title`,`textbody`,`threadtime`) values 
-- ('t1','auth1','s2','b3m1','In the wild','Hello world','2018-03-20 21:59:00'),
-- ('t2','auth5','s4','b7m2','I have a car','Hello cat','2018-04-20 21:59:00'),
-- ('t3','auth4','s3','b2m4','I have a new furniture','Hello sofa','2018-05-20 21:59:00');


-- insert  into `message`(`message_id`,`tid`,`mreplyid`,`mtextbody`,`mreplytime`) values
-- ('m1','t1','b5m2','So good','2018-03-22 21:59:00'),
-- ('m1','t2','b7m1','So cool','2018-03-23 21:59:00'),
-- ('m2','t2','b7m2','So bad','2018-04-22 21:59:00'),
-- ('m1','t3','b2m2','So happy','2018-03-28 21:59:00'),
-- ('m2','t3','b2m3','So terrible','2018-05-22 21:59:00');

-- insert  into `friend_relation`(`fid`,`mid_1`,`mid_2`,`ftimestamp`) values
-- ('f1','b1m1','b1m3','2018-03-22 21:59:00'),
-- ('f2','b3m1','b5m2','2018-03-22 21:59:00');

-- insert  into `profile`(`uid`,`page`,`pname`) values
-- (5,20,'haha'),
-- (7,30,'gaga'),
-- (12,30,'keke'),
-- (16,20,'xixi'),
-- (19,20,'zaza');


-- insert  into `family`(`uid`,`fmember`,`ftimestamp`,`ftype`,`fphoto`) values 
-- (5,'Frek','2018-03-22 21:59:00','father',NULL),
-- (5,'Man','2018-03-22 21:59:00','momther',NULL),
-- (7,'Cujo','2018-03-22 21:59:00','son',NULL),
-- (13,'Suger','2018-03-22 21:59:00','cat',NULL),
-- (18,'Eliza','2018-03-22 21:59:00','grandma',NULL),
-- (18,'Alex','2018-03-22 21:59:00','aunt',NULL);

-- insert into `user_credential`(`unickname`,`password`) values
-- ('abby','12345'),
-- ('allie','23456'),
-- ('bella','12345'),
-- ('bob','12345'),
-- ('ban','12345'),
-- ('ben','12345'),
-- ('jan','12345'),
-- ('gus','12345'),
-- ('boy','12345'),
-- ('evie','12345'),
-- ('amy','12345'),
-- ('jack','12345'),
-- ('jermy','12345'),
-- ('leo','12345'),
-- ('max','12345'),
-- ('dan','12345'),
-- ('nick','12345'),
-- ('jacky','12345'),
-- ('sam','12345'),
-- ('ray','12345'),
-- ('ted','12345'),
-- ('teddy','12345'),
-- ('tom','12345'),
-- ('abbyyyyyy','12345'),
-- ('Andrew','12345');


insert into `logout` (`mid`, `logout_time`) values
('b2m4','2019-05-10 12:00:00');

