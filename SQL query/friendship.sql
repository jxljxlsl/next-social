use next_social;

delimiter //
drop trigger if exists friend_application;
create trigger friend_application before insert on next_social.friendship
for each row
begin 
	declare hood longtext;
    
    SET hood = (	select hid
					from next_social.member m, block b
					where m.bid = b.bid and m.mid = NEW.mid_request);

if 
	NEW.mid_reply not in (	select mid
							from next_social.member m left join block b on m.bid = b.bid
							where b.hid = hood)
then
	signal sqlstate '45000' set message_text="Sorry, you are not in the same hood, can't send the request";
end if;
end; //
delimiter ;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- First step, send request to a member 
insert into friendship(`mid_request`,`mid_reply`) values
('b2m3','b3m1');

-- Second step, once the member accepts the request, update the table with status Y
update next_social.friendship
set `status` = NULL
where f_app_id = 22;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- List all friends of the member
select mid_request as friend
from friendship
where mid_reply = 'b3m1' and status = 'Y'
UNION
select mid_reply as friend
from friendship
where mid_request = 'b3m1' and status = 'Y';

-- List all neighbors of the member
SET @member_address = (	select u.aid
						from next_social.member m, user u
						where m.uid = u.uid and m.mid = 'b1m3');
                        
-- select mid as 'all neighbors'
-- from next_social.member m, user u
-- where m.uid = u.uid and u.aid = @member_address and m.mid != 'b1m3';

-- select *
-- from friendship;

-- select * from friendship f where f.status is NULL and f.mid_reply = 'b3m1';

