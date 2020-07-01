use next_social;

-- Set new variables for cur_user
SET @cur_user = ('b2m4');

SET @cur_user_logout = (select logout_time from logout l where l.mid = @cur_user);


SET @target_bid = (	select m.bid
					from next_social.member m
					where m.mid = @cur_user);

-- all members in same block
select m.mid
from next_social.member m
where m.bid = @target_bid;

-- select feed type: entire block
SET @feed_type = (select auth_id from authentication where recipient_tyoe = 'entire block');

-- select all thread related with entire block
select t.tid
from thread t
where t.auth_id = @feed_type and t.author in (select m.mid
					from next_social.member m
					where m.bid = @target_bid);

-- case 1, new thread after log out time - show all thread after log out time
select *
from thread t
where t.threadtime >= @cur_user_logout and
t.auth_id = @feed_type and t.author in (select m.mid
					from next_social.member m
					where m.bid = @target_bid);
                    
-- case 2, select all old thread that contains new messages
select t.tid, t.auth_id, t.sid, t.author, t.title, t.textbody, t.threadtime
from thread t, message m
where 	t.tid = m.tid and 
		m.mreplytime >= @cur_user_logout and 
		t.threadtime < @cur_user_logout and
		t.auth_id = @feed_type and t.author in 
								(select m.mid
								from next_social.member m
								where m.bid = @target_bid);