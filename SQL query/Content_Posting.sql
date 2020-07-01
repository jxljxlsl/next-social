use next_social;

-- -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- -- Start new thread
-- SET @latest_tid = (SELECT MAX(CAST(SUBSTRING(tid,2,LENGTH(tid)-1) AS SIGNED)) FROM thread);
-- SET @latest = (SELECT CONCAT('t',@latest_tid+1));

-- insert  into `thread`(`tid`,`auth_id`,`sid`,`author`,`title`,`textbody`) values
-- (@latest, 'auth6','s1','b1m6','Sushi','I love Sushi');

-- update thread
-- set auth_id = 'auth3'
-- where tid = 't10';
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Reply message under the thread
-- Where tid = user reply on which thread in frontend


SET @thread_tid = 't10';
SET @message_author = 'b2m3';
SET @messagebody = 'OOOOOOO.com';

delimiter $$
DROP PROCEDURE IF EXISTS select_or_insert;
create procedure select_or_insert()
begin
	declare latest_mid INT;
	declare latest_message longtext;

if 
	@thread_tid in (SELECT DISTINCT tid from message)
then
	SET latest_mid = (SELECT MAX(CAST(SUBSTRING(message_id,2,LENGTH(message_id)-1) AS SIGNED)) FROM message where tid = @thread_tid);
	SET latest_message = (SELECT CONCAT('m',latest_mid+1));
	insert into `message`(`message_id`,`tid`,`mreplyid`,`mtextbody`) values
	(latest_message, @thread_tid, @message_author, @messagebody);

else
	insert into `message`(`message_id`,`tid`,`mreplyid`,`mtextbody`) values
	('m1',@thread_tid,@message_author,@messagebody);	
  END IF;
end $$

delimiter ;

call select_or_insert();

-- update message
-- set mreplyid = 'b5m2'
-- where tid = 't10';

-- select *
-- from message;


-- update message
-- set mreplytime = '2019-05-13 12:00:01'
-- where tid = 't8' and message_id = 'm1';

-- -- update message
-- -- set message.mtextbody = 'so well'
-- -- where message.message_id = 'm1' and message.tid = 't1';

-- select * from user_credential;
-- select aid from address where alongtitude =38 and alatitude = 25;

-- insert  into `message`(`message_id`,`tid`,`mreplyid`,`mtextbody`) values
-- ('m3','t10','b2m3','OOOOOOO.com');


-- select *
-- from user_credential;
-- delete from user_credential where unickname = '';

