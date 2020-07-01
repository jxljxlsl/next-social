use next_social;

-- Set new variables for cur_user
SET @cur_user = ('b2m4');
SET @cur_user_logout = (select logout_time from logout l where l.mid = @cur_user);

-- select feed type: all friends or one friend
SET @feed_type_one_friend = (select auth_id from authentication where recipient_tyoe = 'one friend');
SET @feed_type_all_friends = (select auth_id from authentication where recipient_tyoe = 'all friends');

-- Select all friends
select mid_request as friend
from friendship
where mid_reply = @cur_user and status = 'Y'
UNION
select mid_reply as friend
from friendship
where mid_request = @cur_user and status = 'Y';

-- Select all new threads in friend feed after log out
select t.tid, t.auth_id, t.sid, t.author, t.title, t.textbody, t.threadtime
from thread t
where (t.auth_id = @feed_type_one_friend or t.auth_id = @feed_type_all_friends) and
t.threadtime >= @cur_user_logout and
t.author in (select mid_request as friend
					from friendship
					where mid_reply = @cur_user and status = 'Y'
					UNION
					select mid_reply as friend
					from friendship
					where mid_request = @cur_user and status = 'Y');

-- Select all new messages in friend feed after log out
select t.tid, t.auth_id, t.sid, t.author, t.title, t.textbody, t.threadtime
from thread t, message m
where t.tid = m.tid and
(t.auth_id = @feed_type_one_friend or t.auth_id = @feed_type_all_friends) and
		t.threadtime < @cur_user_logout and
        m.mreplytime > @cur_user_logout and 
		t.author in (select mid_request as friend
					from friendship
					where mid_reply = @cur_user and status = 'Y'
					UNION
					select mid_reply as friend
					from friendship
					where mid_request = @cur_user and status = 'Y');
