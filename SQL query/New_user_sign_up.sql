use next_social;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Joining - new user sign up, avoid duplicate username. Front-end: user input address name, nick name and other optional inputs

-- SET @AddressID = (SELECT a.aid 
--                   FROM address a
--                  WHERE a.aname = 'Academy_Court');

delimiter //
drop trigger if exists insert_new_2;
create trigger insert_new_2 before insert on next_social.user_credential
for each row
begin 
if 
	NEW.unickname in 
    (select unickname from next_social.user_credential)
then
	signal sqlstate '45000' set message_text="Duplicate Username, Please rename it";
end if;
end; //
delimiter ;

-- -- insert  into `user`(`unickname`,`aid`) values
-- -- ('Ban',@AddressID);

-- -- insert into `user_credential`(`unickname`,`password`) values
-- -- ('Ban','12345');

-- select *
-- from user_credential;
-- -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Test Case 2 - create profile

-- insert into `profile`(`uid`,`page`,`pname`) values
-- (26, 48, 'John Terry');
-- -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Test Case 3 - edit profile

-- update profile
-- set page = 46
-- where uid = 26;
-- -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- insert  into `member_application`(`mid`,`application_uid`) values 
-- ('b1m1',25),
-- ('b1m2',25),
-- ('b1m5',25),
-- ('b5m1',26);

-- select *
-- from thread;

-- delete from thread
-- where title = 'Database';

-- select *
-- from authentication;

-- select unickname 
-- from next_social.member as m, next_social.user as u,
-- (select mid as all_neighbors from next_social.member m, user u 
-- where m.uid = u.uid and u.aid = 'a10' and u.unickname != 'ted') as sub 
-- where m.uid=u.uid and sub.all_neighbors=m.mid;

-- -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Member Application

delimiter //
drop trigger if exists insert_new_member;
create trigger insert_new_member before insert on next_social.member
for each row
begin 

declare total_member INT;
declare total_approve INT;

SET total_member = (select count(*) from next_social.member m where m.bid = NEW.bid);
SET total_approve = (select count(*) as cnt from member_application mapp where mapp.application_uid = NEW.uid and flag = 1);

if 
	total_member >= 3 AND total_approve < 3
or
    total_member < 3 AND total_member < total_approve

then
	signal sqlstate '45000' set message_text="don't satisfy the member requirements. Can't become a member";

end if;
end; //
delimiter ;

insert into next_social.member(`mid`,`uid`,`bid`) values
	('b2m3',59,'b2');  
--     
    
    
-- insert into `member`(`mid`,`uid`,`bid`) values
-- 	('b1m7',25,'b1');  

-- -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Member Application
--     
-- select *
-- from next_social.member;

-- insert  into `user`(`unickname`,`aid`) values
-- ('Andrew',@AddressID);

select *
from member_application;



update member_application
set flag = 0
where mappid = 54;

-- delete from member_application where application_uid = '21';

-- select *
-- from user;

-- select m.mid from next_social.member m where m.bid = (select bid from address where aid = 'a13');

select *
from next_social.member;

-- select h.hid, u.unickname
-- from user u, next_social.member m, block b, hood h
-- where u.uid = m.uid and u.unickname = 'abby' and m.bid = b.bid and b.hid = h.hid;


-- select u.unickname from user u, next_social.member m, block b, hood h where u.uid = m.uid and m.bid = b.bid and b.hid = h.hid and h.hid = 'h1';

-- delete from next_social.member where mid = 'b1m6';

-- select *
-- from user;

select *
from next_social.member m, user u
where u.uid = m.uid;

-- select count(*) from user;

-- update user
-- set aid = @AddressID
-- where uid = 1;

