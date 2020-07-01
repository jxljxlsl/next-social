use next_social;

-- delete from thread_visible where tid = 't2';
SET @thread_author = 'b2m2';
SET @thread_tid = 't8';
SET @thread_auth_id = 'auth5';

delimiter $$
DROP PROCEDURE IF EXISTS visible_set;
create procedure visible_set()
begin
	
	insert into `thread_visible` (`tid`,`mid`) values
    (@thread_tid,@thread_author);
if 
	@thread_auth_id = 'auth1'
then
	insert into `one_friend_thread` (`tid`, `send_mid`, `receive_mid`) values
    (@thread_tid,@thread_author,@receive_mid);
	
	insert into `thread_visible` (`tid`,`mid`)
	select tid,receive_mid as mid
    from one_friend_thread
    where send_mid = @thread_author;


ELSEIF	
	@thread_auth_id = 'auth2'
then
	insert into `one_neighbor_thread` (`tid`, `send_mid`, `receive_mid`) values
    (@thread_tid,@thread_author, @receive_mid);
    
	insert into `thread_visible` (`tid`,`mid`)
	select tid,receive_mid as mid
    from one_neighbor_thread
    where send_mid = @thread_author;
    
ELSEIF
	@thread_auth_id = 'auth3'
then 
	insert into `thread_visible` (`tid`, `mid`)
	select t.tid, mid_request as friend
	from friendship, thread t
	where mid_reply = t.author and 
		mid_reply = @thread_author and status = 'Y' and t.tid = @thread_tid
	UNION
	select t.tid, mid_reply as friend
	from friendship, thread t
	where mid_request = t.author and 
		mid_request = @thread_author and status = 'Y' and t.tid = @thread_tid;

ELSEIF
	@thread_auth_id = 'auth4'
then
	insert into `thread_visible` (`tid`, `mid`)
	select tid, mid
	from (select author, tid from thread where tid = @thread_tid) as T2 
	cross join 
	(select m.mid
	from next_social.member m, user u
	where m.mid != @thread_author and 
			m.uid = u.uid and u.aid in (
			select aid 
			from next_social.member m, user u 
			where m.uid = u.uid and @thread_author = m.mid)) as T1;

ELSEIF
	@thread_auth_id = 'auth5'
then
	SET @target_bid = (	select m.bid
						from next_social.member m
						where m.mid =  @thread_author);
	insert into `thread_visible` (`tid`, `mid`)
	select t.tid, m.mid
	from next_social.member m, thread t
	where m.mid != @thread_author and m.bid = @target_bid and t.tid = @thread_tid;

ELSE
	insert into `thread_visible` (`tid`, `mid`)
	select tid, mid
	from (select author, tid from thread where tid = @thread_tid) as T1
	cross join
	(select m.mid
	from next_social.member m, block b
	where  m.mid != @thread_author and m.bid = b.bid 
		and b.hid = (   select b.hid
						from next_social.member m, block b
						where m.bid = b.bid and m.mid = @thread_author)) as T2;

  END IF;
end $$

delimiter ;

call visible_set();

select * from thread_visible t where t.mid = (	select m.mid
												from user u, next_social.member m
												where u.unickname = 'boy' and u.uid = m.uid);
-- select *
-- from authentication;

-- select *
-- from next_social.member m, user u
-- where m.uid = u.uid;

-- select *
-- from thread;
