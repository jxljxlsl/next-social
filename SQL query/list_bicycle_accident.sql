use next_social;
ALTER TABLE move
MODIFY COLUMN alatitude INT;
-- Text case current user = 'b2m2'
SET @cur_user = 'b2m3';

-- Select all messages that contains'bicycle accidents' which current user can access
select t.tid, t.title as 'thread title', m.mtextbody as message, m.mreplyid as 'member reply'
from thread t, message m
where t.tid = m.tid and (m.mtextbody like '%know%') and
t.tid in (select t.tid
		from thread_visible t
		where t.mid = @cur_user);
        
-- Select all thread body that contains'bicycle accidents' which current user can access
select distinct t.tid, t.title as 'thread title', t.textbody as 'thread body'
from thread t, message m
where t.tid = m.tid and (t.textbody like '%know%' ) and
t.tid in (select t.tid
		from thread_visible t
		where t.mid = @cur_user);   

select *
from thread;


select *
from thread t, message m
where t.tid = m.tid;