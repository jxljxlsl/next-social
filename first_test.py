import hashlib
import math
import datetime

import MySQLdb
from flask import Flask, render_template, redirect, url_for, request, session, flash, send_from_directory, make_response
from flask_mysqldb import MySQL
from collections import defaultdict

from numpy import double
from werkzeug.exceptions import HTTPException, NotFound, BadRequestKeyError

app = Flask(__name__)
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '369369'
app.config['MYSQL_DB'] = 'next_social'

mysql = MySQL(app)


@app.route('/home', methods=['GET', 'POST'])
def home():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    feed_thread = ['one friend', 'one neighbor', 'all friends', 'all neighbors', 'entire block', 'entire hood']
    one_friend = []
    one_neighbor = []
    all_friends = []
    all_neighbors = []
    entire_block = []
    entire_hood = []
    messagetxt = []
    display_member_application = []
    friendship = []
    all_neighbor_auths = []
    members = []
    friend_application_list = []
    friend_app = []
    target_friends = None
    search_thread = []
    search_message = []
    red_point = True

    query1 = "select * from thread_visible t where t.mid = (" \
             "select m.mid from user u, next_social.member m " \
             "where u.unickname = %(unickname)s and u.uid = m.uid)"

    cur.execute(query1, {'unickname': username})
    thread_list = cur.fetchall()

    query_feed = "select a.recipient_tyoe from authentication a, thread t" \
                 " where t.tid = %(thread_tid)s and t.auth_id = a.auth_id"

    query_thread_output = "select title, textbody, author, unickname, t.tid, t.threadtime from thread t, next_social.member m, user u" \
                          " where t.author = m.mid and u.uid = m.uid and t.tid = %(thread_tid)s"

    query_message = "select message_id, thread.tid, mtextbody, mreplytime, unickname" \
                    " from message, thread, next_social.member as m, next_social.user as u" \
                    " where message.tid=thread.tid and message.mreplyid=m.mid " \
                    " and m.uid=u.uid and thread.tid = %(thread_tid)s;"

    # -------------All members in the block Display---------------------
    query_cur_member_aid = "select u.aid from user u where u.unickname = %(nickname)s"
    cur.execute(query_cur_member_aid, {'nickname': username})
    aid = cur.fetchone()[0]

    query_block_members = "select u.unickname from next_social.member m, user u where u.uid = m.uid " \
                          "and m.bid = (select bid from address where aid = %(target)s)"

    cur.execute(query_block_members, {'target': aid})
    for row in cur.fetchall():
        if row:
            members.append(row[0])

    # -------------All neighbors in the aid Display-----------
    query_apply1 = "select unickname from next_social.member as m, next_social.user as u, (select mid as all_neighbors from next_social.member m, user u where m.uid = u.uid and u.aid = %(memberAddress)s and u.unickname != %(unickname)s) as sub where m.uid=u.uid and sub.all_neighbors=m.mid"
    cur.execute(query_apply1, {'unickname': username, 'memberAddress': aid})
    all_neighbor_auth = cur.fetchall()
    for n in all_neighbor_auth:
        all_neighbor_auths.append(n)

    # --------------------Membership Status--------------
    query_member_pending = "select distinct(mpp.application_uid) from member_application mpp where mpp.application_uid " \
                           "= (select uid from user where user.unickname = %(unickname)s)"
    cur.execute(query_member_pending, {'unickname': username})
    status = cur.fetchone()

    # --------------------Check if has Membership ---------------
    query_mid = "select m.mid from next_social.member m, user u where unickname = %(unickname)s and u.uid = m.uid"
    cur.execute(query_mid, {'unickname': username})
    membership = cur.fetchone()  # mid

    if membership:
        for item in thread_list:
            # ------------------Message Display----------------
            cur.execute(query_message, {'thread_tid': item[0]})
            messageone = cur.fetchall()
            for m in messageone:
                messagetxt.append(m)

        # ------------------Feed display----------------
        for item in thread_list:
            cur.execute(query_feed, {'thread_tid': item[0]})
            feed_type = cur.fetchone()[0]

            cur.execute(query_thread_output, {'thread_tid': item[0]})
            thread = cur.fetchone()
            if feed_thread[0] == feed_type:
                one_friend.append(thread)

            elif feed_thread[1] == feed_type:
                one_neighbor.append(thread)

            elif feed_thread[2] == feed_type:
                all_friends.append(thread)

            elif feed_thread[3] == feed_type:
                all_neighbors.append(thread)

            elif feed_thread[4] == feed_type:
                entire_block.append(thread)

            elif feed_thread[5] == feed_type:
                entire_hood.append(thread)

        # ------------------Member Application Display----------------
        query_apply_member = "select u.unickname, user_app from user u," \
                             "(select mpp.application_uid as user_app, u.uid " \
                             "from member_application mpp, next_social.member m," \
                             " user u where mpp.mid = m.mid and m.uid = u.uid and u.unickname = %(unickname)s and flag = '0') as T1" \
                             " where T1.user_app = u.uid"
        cur.execute(query_apply_member, {'unickname': username})
        for row in cur.fetchall():
            display_member_application.append(row)

        # -------------------All friends----------------
        query_apply = "select unickname " \
                      "from next_social.member as m, next_social.user as u, " \
                      "(select mid_request from friendship, next_social.user as u, next_social.member as m " \
                      "where unickname = %(unickname)s and status = 'Y' and friendship.mid_reply=m.mid and m.uid=u.uid " \
                      "UNION " \
                      "select mid_reply from friendship, next_social.user as u, next_social.member as m " \
                      "where unickname = %(unickname)s and status = 'Y' and friendship.mid_request=m.mid and m.uid=u.uid) as sub " \
                      "where m.uid=u.uid and sub.mid_request=m.mid;"
        cur.execute(query_apply, {'unickname': username})
        for f in cur.fetchall():
            friendship.append(f[0])

        # -----------------All members in same hood ------------
        query_username_hid = "select h.hid from user u, next_social.member m, block b, hood h where u.uid = m.uid and u.unickname = %(unickname)s and m.bid = b.bid and b.hid = h.hid"
        cur.execute(query_username_hid, {'unickname': username})
        temp = cur.fetchone()
        hid = temp[0]

        query_members_hood = "select u.unickname from user u, next_social.member m, block b, hood h where u.uid = m.uid and m.bid = b.bid and b.hid = h.hid and h.hid = %(hid)s"
        cur.execute(query_members_hood, {'hid': hid})
        members_in_hood = []

        for row in cur.fetchall():
            if row[0] != username:
                members_in_hood.append(row[0])

        # -----------------Friend Application ------------------

        query_friend_app = "select f.mid_request from friendship f where f.status is NULL and f.mid_reply = %(mid)s"
        cur.execute(query_friend_app, {'mid': membership[0]})
        for row in cur.fetchall():
            friend_application_list.append(row[0])

        query_friend_app_names = "select u.unickname, m.mid from next_social.member m, user u where m.uid = u.uid and m.mid = %(mid)s"

        for m in friend_application_list:
            cur.execute(query_friend_app_names, {'mid': m})
            friend_app.append(cur.fetchall()[0])

        target_friends = set(list(members_in_hood)) - set(list(friendship))

        # -------------------------Search Feed--------------------------------
        if request.method == 'POST':
            if request.form['search']:
                tid_list = set()
                content = request.form['search']  # search content

                query_message = "select t.tid from thread t, message m where t.tid = m.tid and " \
                                "(m.mtextbody like %(content)s) and t.tid in (select t.tid from thread_visible t where t.mid = %(cur_user)s);"
                query_mid = "select m.mid from next_social.member m, user u where m.uid=u.uid and u.unickname = %(nickname)s"
                cur.execute(query_mid, {'nickname': username})
                cur_user_mid = cur.fetchone()[0]

                cur.execute(query_message, {'content': "%{}%".format(content), 'cur_user': cur_user_mid})
                for row in cur.fetchall():
                    tid_list.add(row[0])

                query_thread_only = "select distinct(t.tid) from thread t where t.textbody like %(content)s and t.tid in (select t.tid from thread_visible t where t.mid = %(cur_user)s)"
                cur.execute(query_thread_only, {'content': "%{}%".format(content), 'cur_user': cur_user_mid})
                for row in cur.fetchall():
                    tid_list.add(row[0])

                query_thread = "select distinct(t.tid) from thread t, message m where t.tid = m.tid and (t.textbody like %(content)s ) and t.tid in (select t.tid from thread_visible t where t.mid = %(cur_user)s)"
                cur.execute(query_thread, {'content': "%{}%".format(content), 'cur_user': cur_user_mid})

                for row in cur.fetchall():
                    tid_list.add(row[0])

                query_thread_output = "select title, textbody, author, unickname,t.tid,t.threadtime from thread t, next_social.member m, user u" \
                                      " where t.author = m.mid and u.uid = m.uid and t.tid = %(thread_tid)s"

                query_message = "select message_id, thread.tid, mtextbody, mreplytime, unickname" \
                                " from message, thread, next_social.member as m, next_social.user as u" \
                                " where message.tid=thread.tid and message.mreplyid=m.mid " \
                                " and m.uid=u.uid and thread.tid = %(thread_tid)s;"

                for item in tid_list:
                    cur.execute(query_thread_output, {'thread_tid': item})
                    search_thread.append(cur.fetchone())

                    cur.execute(query_message, {'thread_tid': item})
                    search_message.append(cur.fetchone())

        # ------------- check time ------------------
        query_search_time = "select threadtime from thread where tid in " \
                            "(select tid from thread_visible t where t.mid = " \
                            "(select m.mid from user u, next_social.member m " \
                            "where u.unickname = %(unickname)s and u.uid = m.uid) );"
        cur.execute(query_search_time, {'unickname': username})
        total_time = set()

        for row in cur.fetchall():
            total_time.add(row[0])

        query_check_user_logout = "select logout_time from logout where mid = " \
                                  "(select m.mid from user u, next_social.member m " \
                                  "where u.unickname = %(unickname)s and u.uid = m.uid)"
        cur.execute(query_check_user_logout, {'unickname': username})
        try:
            user_last_logout = cur.fetchone()[0]
            if total_time:
                if user_last_logout is None or max(total_time) < user_last_logout:
                    red_point = False
        except TypeError or UnboundLocalError:
            red_point = False



    # ----------------- Member Profile ------------------
    username = session.get('user')
    query_uid = "select uid from user where unickname = %(unickname)s;"
    cur.execute(query_uid, {'unickname': username})
    uid = cur.fetchone()[0]  # get username's uid

    query_search_profile = "select * from profile where uid = %(uid)s"
    cur.execute(query_search_profile, {'uid': uid})
    user_profile = cur.fetchone()

    # ----------------- Family ------------------

    query_search_family = "select * from family where uid = %(uid)s"
    cur.execute(query_search_family, {'uid': uid})
    user_family = cur.fetchone()

    # ----------------- Move Address ------------------
    query_address = "select aname from address;"
    cur.execute(query_address)
    address_name = cur.fetchall()
    address_list = []
    for row in address_name:
        address_list.append(row)

    query_aid = "select a.aname from user u,address a where u.unickname =%(unickname)s and u.aid = a.aid"
    cur.execute(query_aid, {'unickname': username})
    aid_address_name = cur.fetchone()[0]


    # ----------------Show Other Profile----------------

    return_dict = request.args.to_dict()
    if return_dict:
        choose_name = return_dict['choose_name']
        other_profile_age = return_dict['other_profile_age']
        other_profile_name = return_dict['other_profile_name']
    else:
        choose_name = None
        other_profile_age = None
        other_profile_name = None

    cur.close()


    return render_template('next_social.html', current_user=username, status=status, membership=membership,
                           hoods=target_friends, members=members, friendship=friendship, neighbors=all_neighbor_auths,
                           one_friend=one_friend, friend_alist=friend_app,
                           one_neighbor=one_neighbor, all_friends=all_friends,
                           all_neighbors=all_neighbors, entire_block=entire_block, entire_hood=entire_hood,
                           message=messagetxt, m_application=display_member_application, content_thread=search_thread,
                           content_message=search_message, profile=user_profile, family=user_family,
                           address_list=address_list,
                           other_profile_age=other_profile_age, other_profile_name=other_profile_name,
                           choose_name=choose_name, red_point=red_point,aid_address_name=aid_address_name)


# -------------------------Post Thread--------------------
@app.route("/newPost", methods=['GET', 'POST'])
def newPost():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))
    try:
        if request.method == 'POST':
            ttitle = request.form['title']
            ttextbody = request.form['content']
            auth = request.form['selectauth']
            subject = request.form['optionsubject']
            cur = mysql.connection.cursor()

            query_member = "select uid from next_social.member"
            cur.execute(query_member)
            query_get_uid = cur.fetchall()
            total_uid = set()
            for row in query_get_uid:
                total_uid.add(row[0])

            query_user_uid = "select uid from user where unickname=%(unickname)s"
            cur.execute(query_user_uid,{'unickname':username})
            query_user_uid = cur.fetchone()[0]

            if query_user_uid in total_uid:
                if ttextbody:
                    querynew1 = "SELECT MAX(CAST(SUBSTRING(tid, 2, LENGTH(tid) - 1) AS SIGNED)) FROM thread;"
                    cur.execute(querynew1)
                    latest_tid = cur.fetchone()
                    if latest_tid[0] is None:
                        latest = 't1'
                    else:
                        querynew2 = "SELECT CONCAT('t', (%(latest_tid)s)+1)"
                        cur.execute(querynew2, {'latest_tid': latest_tid})
                        latest = cur.fetchall()

                    querynew3 = "select m.mid from next_social.member m, user u " \
                                "where m.uid=u.uid and u.unickname = %(nickname)s;"
                    cur.execute(querynew3, {'nickname': username})
                    author = cur.fetchall()
                    query_insert_thread = "insert into `thread`(`tid`, `auth_id`, `sid`, `author`, `title`, `textbody`) " \
                                          "values (%(latest)s, %(auth)s, %(subject)s, %(author)s, %(ttitle)s, %(ttextbody)s);"

                    cur.execute(query_insert_thread,
                                {'latest': latest, 'auth': auth, 'subject': subject, 'author': author[0],
                                 'ttitle': ttitle, 'ttextbody': ttextbody})
                    mysql.connection.commit()

                    if auth == "auth1":
                        whetheronef = request.form['select_onefriend']
                        queryonefriend = "select m.mid from next_social.member m, user u " \
                                         "where m.uid=u.uid and u.unickname = %(nickname)s;"
                        cur.execute(queryonefriend, {'nickname': whetheronef})  # one friend mid to receive_mid
                        whoreceivef = cur.fetchall()
                        query_insert_onefriend_table = "insert into `one_friend_thread`(`tid`,`send_mid`,`receive_mid`) values " \
                                                       "(%(latest)s, %(nickname)s, %(receive_mid)s);"
                        cur.execute(query_insert_onefriend_table,
                                    {'latest': latest, 'nickname': author[0], 'receive_mid': whoreceivef[0][0]})

                        query_insert_thread_visible1 = "insert into `thread_visible` (`tid`,`mid`) values (%(latest)s, %(receive_mid)s)"
                        cur.execute(query_insert_thread_visible1, {'latest': latest, 'receive_mid': whoreceivef[0][0]})

                        query_insert_self1 = "insert into `thread_visible` (`tid`,`mid`) values (%(latest)s, %(receive_mid)s)"
                        cur.execute(query_insert_self1, {'latest': latest, 'receive_mid': author[0]})


                        mysql.connection.commit()

                    elif auth == "auth2":
                        whetheronen = request.form['select_oneneighbor']
                        queryoneneighbor = "select m.mid from next_social.member m, user u " \
                                           "where m.uid=u.uid and u.unickname = %(nickname)s;"
                        cur.execute(queryoneneighbor, {'nickname': whetheronen})  # one neighbor mid to receive_mid
                        whoreceiven = cur.fetchall()
                        query_insert_oneneighbor_table = "insert into `one_neighbor_thread`(`tid`,`send_mid`,`receive_mid`) values " \
                                                         "(%(latest)s, %(nickname)s, %(receive_mid)s);"
                        cur.execute(query_insert_oneneighbor_table,
                                    {'latest': latest, 'nickname': author[0], 'receive_mid': whoreceiven[0][0]})

                        query_insert_thread_visible2 = "insert into `thread_visible` (`tid`,`mid`) values (%(latest)s, %(receive_mid)s)"
                        cur.execute(query_insert_thread_visible2, {'latest': latest, 'receive_mid': whoreceiven[0][0]})

                        query_insert_self2 = "insert into `thread_visible` (`tid`,`mid`) values (%(latest)s, %(receive_mid)s)"
                        cur.execute(query_insert_self2, {'latest': latest, 'receive_mid': author[0]})

                        mysql.connection.commit()

                    else:
                        thread_author_query = "SET @thread_author = %(author_mid)s"
                        thread_tid_query = "SET @thread_tid = %(tid)s"
                        thread_auth_id = "SET @thread_auth_id = %(auth)s"

                        cur.execute(thread_author_query, {'author_mid': author})
                        cur.execute(thread_tid_query, {'tid': latest})
                        cur.execute(thread_auth_id, {'auth': auth})
                        cur.execute("call visible_set()")
                        mysql.connection.commit()
                else:
                    error = "Please fill in thread content"
    except HTTPException:
        return redirect(url_for('home'))

    return redirect(url_for('home'))


# -------------------------Apply Member-------------------
@app.route('/apply', methods=['GET', 'POST'])
def apply():
    current_member = session.get('user')
    if not current_member:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    query_cur_member_mid = "select u.uid, u.aid from user u where u.unickname = %(nickname)s"
    cur.execute(query_cur_member_mid, {'nickname': current_member})

    uid_mid = cur.fetchone()

    query_block_members = "select m.mid from next_social.member m where m.bid = (select bid from address where aid = %(target)s)"

    cur.execute(query_block_members, {'target': uid_mid[1]})
    mids = []

    for row in cur.fetchall():
        mids.append(row[0])

    if not mids:
        query_bid = "select bid from address where aid = %(target)s"
        cur.execute(query_bid, {'target': uid_mid[1]})
        bid = cur.fetchone()[0]
        mid = bid + 'm1'

        cur.execute("INSERT INTO next_social.member(mid, uid, bid) VALUES ('{}',{},'{}')".format(mid, uid_mid[0], bid))

    query_insert = "insert  into `member_application`(`mid`,`application_uid`) values (%(mid)s, %(uid)s)"

    for mid in mids:
        cur.execute(query_insert, {'mid': mid, 'uid': uid_mid[0]})

    mysql.connection.commit()

    cur.close()

    return redirect(url_for('home'))


@app.route('/decline', methods=['GET', 'POST'])
def decline():
    current_member = session.get('user')
    if not current_member:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()

    query_cur_member_mid = "select m.mid from next_social.member m, user u where m.uid=u.uid and u.unickname = %(nickname)s"
    cur.execute(query_cur_member_mid, {'nickname': current_member})
    cur_member_mid = cur.fetchone()

    query_apply = "update member_application set flag = 2 where application_uid = %(uid)s and mid = %(mid)s"

    if request.method == 'POST':
        uid = request.form['uid']
        cur.execute(query_apply, {'uid': uid, 'mid': cur_member_mid[0]})
        mysql.connection.commit()


        query_check = "select m.flag from member_application m where m.application_uid = %(uid)s"
        cur.execute(query_check, {'uid': uid})
        application_list = []

        for row in cur.fetchall():
            application_list.append(row[0][0])

        if '0' not in application_list:
            query_delete = "delete from member_application where application_uid = %(uid)s"
            cur.execute(query_delete,{'uid':uid})
            mysql.connection.commit()

    cur.close()

    return redirect(url_for('home'))


@app.route('/approve', methods=['GET', 'POST'])
def approve():
    current_member = session.get('user')
    if not current_member:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    query_cur_member_mid = "select m.mid from next_social.member m, user u where m.uid=u.uid and u.unickname = %(nickname)s"
    cur.execute(query_cur_member_mid, {'nickname': current_member})
    cur_member_mid = cur.fetchone()

    try:
        uid = request.form['uid']
        query_apply = "update member_application set flag = 1 where application_uid = %(uid)s and mid = %(mid)s"
        cur.execute(query_apply, {'uid': uid, 'mid': cur_member_mid[0]})
        mysql.connection.commit()

        query_bid = "select bid from user u, address a where u.uid = %(uid)s and u.aid = a.aid"
        cur.execute(query_bid, {'uid': uid})
        bid = cur.fetchone()

        query_latest_mid = "SELECT MAX(CAST(SUBSTRING(mid,4,LENGTH(mid)-1) AS SIGNED)) FROM next_social.member where bid = %(bid)s"
        cur.execute(query_latest_mid, {'bid': bid})
        latest_mid = cur.fetchone()

        mid_input = str(bid[0] + 'm' + str(int(latest_mid[0]) + 1))
        cur.execute(
            "INSERT INTO next_social.member(mid, uid, bid) VALUES ('{}',{},'{}')".format(mid_input, uid, bid[0]))
        mysql.connection.commit()




        return redirect(url_for('home'))

    except MySQLdb.OperationalError:
        error = "Duplicate. Please try again."

    except MySQLdb.IntegrityError:
        error = "Duplicate. Please try again."
    cur.close()

    return redirect(url_for('home'))


# -----------------------Send Friend Request--------------
@app.route('/invite', methods=['GET', 'POST'])
def invite():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    try:
        receive_username = request.form['select_friend']

        # -----Get send_mid-------
        query_cur_member_mid = "select m.mid from next_social.member m, user u where m.uid=u.uid and u.unickname = %(nickname)s"
        cur.execute(query_cur_member_mid, {'nickname': username})
        send_mid = cur.fetchone()[0]

        cur.execute(query_cur_member_mid, {'nickname': receive_username})
        receive_username = cur.fetchone()[0]

        # --------------------Send Request to Member--------------------------
        query_insert_friend_app = "insert into `friendship`(`mid_request`,`mid_reply`) values (%(send)s, %(receive)s)"
        cur.execute(query_insert_friend_app, {'send': send_mid, 'receive': receive_username})

        mysql.connection.commit()

    except HTTPException:
        return redirect(url_for('home'))

    return redirect(url_for('home'))


@app.route('/fdecline', methods=['GET', 'POST'])
def fdecline():
    current_member = session.get('user')
    if not current_member:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()

    query_cur_member_mid = "select m.mid from next_social.member m, user u where m.uid=u.uid and u.unickname = %(nickname)s"
    cur.execute(query_cur_member_mid, {'nickname': current_member})
    cur_member_mid = cur.fetchone()

    query_apply = "update friendship set `status` = 'N' where mid_request = %(mid_req)s and mid_reply = %(mid_rep)s"

    if request.method == 'POST':
        mid = request.form['mid']
        cur.execute(query_apply, {'mid_req': mid, 'mid_rep': cur_member_mid[0]})
        mysql.connection.commit()

    cur.close()

    return redirect(url_for('home'))


@app.route('/fapprove', methods=['GET', 'POST'])
def fapprove():
    current_member = session.get('user')
    if not current_member:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()

    query_cur_member_mid = "select m.mid from next_social.member m, user u where m.uid=u.uid and u.unickname = %(nickname)s"
    cur.execute(query_cur_member_mid, {'nickname': current_member})
    cur_member_mid = cur.fetchone()

    query_apply = "update friendship set `status` = 'Y' where mid_request = %(mid_req)s and mid_reply = %(mid_rep)s"

    if request.method == 'POST':
        mid = request.form['mid']
        cur.execute(query_apply, {'mid_req': mid, 'mid_rep': cur_member_mid[0]})
        mysql.connection.commit()

    cur.close()

    return redirect(url_for('home'))


# ----------------------Reply Message---------------------
@app.route("/newComment", methods=['GET', 'POST'])
def newComment():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()
    try:
        if request.method == 'POST':
            queryc1 = "select m.mid from next_social.member m, user u " \
                      "where m.uid=u.uid and u.unickname = %(nickname)s;"
            cur.execute(queryc1, {'nickname': username})
            mreplyid = cur.fetchall()  # login unickname
            mtextbody = request.form['comment']  # comment content
            tid = request.form['tid']  # reply which thread

            if mtextbody:
                message_reply_id_query = "SET @message_author = %(reply_mid)s;"
                message_thread_id_query = "SET @thread_tid = %(thread_id)s;"
                message_context_query = "SET @messagebody = %(context)s;"
                cur.execute(message_reply_id_query, {'reply_mid': mreplyid[0][0]})
                cur.execute(message_thread_id_query, {'thread_id': tid})
                cur.execute(message_context_query, {'context': mtextbody})
                cur.execute("call select_or_insert();")
                mysql.connection.commit()
    except HTTPException:
        return redirect(url_for('home'))

    return redirect(url_for('home'))


# ----------------------New Profile-----------------------
@app.route('/newProfile', methods=['GET', 'POST'])
def newProfile():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()
    if request.method == 'POST':
        new_age = request.form['create_age']  # new age
        new_name = request.form['create_name']  # new name
        if new_name and new_age:
            query_uid = "select uid from user where unickname = %(username)s;"
            cur.execute(query_uid, {'username': username})
            uid = cur.fetchone()
            query_insert = "insert into `profile` (`uid`, `page`, `pname`) values(%(uid)s, %(new_age)s, %(new_name)s)"
            cur.execute(query_insert, {'uid': uid, 'new_age': new_age, 'new_name': new_name})
            mysql.connection.commit()
    return redirect(url_for('home'))


# ----------------------Add family -----------------------
@app.route('/newFamily', methods=['GET', 'POST'])
def newFamily():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()
    if request.method == 'POST':
        new_member = request.form['create_member']  # new member
        new_relation = request.form['create_relation']  # new relation
        if new_member and new_relation:
            query_uid = "select uid from user where unickname = %(username)s;"
            cur.execute(query_uid, {'username': username})
            uid = cur.fetchone()
            query_insert = "insert into `family`(`uid`, `fmember`, `ftype`) values (%(uid)s, %(new_member)s, %(new_relation)s)"
            cur.execute(query_insert, {'uid': uid, 'new_member': new_member, 'new_relation': new_relation})
            mysql.connection.commit()
    return redirect(url_for('home'))


# ---------------------Edit Profile ----------------------
@app.route('/editProfile', methods=['GET', 'POST'])
def editProfile():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()
    if request.method == 'POST':
        new_age = request.form['create_age']  # new age
        new_name = request.form['create_name']  # new name
        if new_name and new_age:
            query_uid = "select uid from user where unickname = %(username)s;"
            cur.execute(query_uid, {'username': username})
            uid = cur.fetchone()

            query_delete = "delete from profile where uid = %(uid)s"  # delete former record
            cur.execute(query_delete, {'uid': uid})
            mysql.connection.commit()

            query_insert = "insert into `profile` (`uid`, `page`, `pname`) values(%(uid)s, %(new_age)s, %(new_name)s)"
            cur.execute(query_insert, {'uid': uid, 'new_age': new_age, 'new_name': new_name})
            mysql.connection.commit()
    return redirect(url_for('home'))


# ------------------------Edit Family -------------------
@app.route('/editFamily', methods=['GET', 'POST'])
def editFamily():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))
    cur = mysql.connection.cursor()
    if request.method == 'POST':
        new_member = request.form['create_member']  # new member
        new_relation = request.form['create_relation']  # new relation
        if new_member and new_relation:
            query_uid = "select uid from user where unickname = %(username)s;"
            cur.execute(query_uid, {'username': username})
            uid = cur.fetchone()

            query_delete = "delete from family where uid = %(uid)s;"
            cur.execute(query_delete, {'uid': uid})
            mysql.connection.commit()

            query_insert = "insert into `family`(`uid`, `fmember`, `ftype`) values (%(uid)s, %(new_member)s, %(new_relation)s)"
            cur.execute(query_insert, {'uid': uid, 'new_member': new_member, 'new_relation': new_relation})
            mysql.connection.commit()
    return redirect(url_for('home'))


# -----------------------Move-----------------------------
@app.route('/newMove', methods=['GET', 'POST'])
def newMove():
    username = session.get('user')
    if not username:
        return redirect(url_for('login'))
    try:
        if request.method == 'POST':
            select_address = request.form['select_oneaddress']  # the address user chooses
            cur = mysql.connection.cursor()

            if select_address:
                query_uid = "select uid from user where unickname = %(nickname)s"
                cur.execute(query_uid, {'nickname': username})
                cur_uid = cur.fetchall()  # login uid

                query_bid = "select bid from address, user where address.aid = user.aid and uid = %(nickname)s;"
                cur.execute(query_bid, {'nickname': cur_uid})
                query_bid = cur.fetchall()  # login old_bid

                query_new_aid = "select aid from address where aname = %(new_select_address)s"
                cur.execute(query_new_aid, {'new_select_address': select_address})
                future_aid = cur.fetchall()  # the move target address

                query_insert_move = "insert into `move`(`uid`,`old_bid`,`new_aid`) " \
                                    "values (%(cur_uid)s, %(query_bid)s, %(future_aid)s);"
                cur.execute(query_insert_move, {'cur_uid': cur_uid, 'query_bid': query_bid, 'future_aid': future_aid})
                mysql.connection.commit()

                query_update_user = "update user set aid = %(future_aid)s where uid = %(cur_uid)s;"
                cur.execute(query_update_user, {'future_aid': future_aid, 'cur_uid': cur_uid})

                query_search_mid = "select uid from next_social.member"
                cur.execute(query_search_mid)
                query_mid = cur.fetchall()
                total_user_in_member = set()
                for row in query_mid:
                    total_user_in_member.add(row[0])

                if cur_uid[0][0] in total_user_in_member:
                    query_update_member = "delete from next_social.member where uid = %(cur_uid)s;"
                    cur.execute(query_update_member, {'cur_uid': cur_uid})
                    mysql.connection.commit()
                mysql.connection.commit()

                query_check = "select m.flag from member_application m where m.application_uid = %(uid)s"
                cur.execute(query_check, {'uid': cur_uid})
                application_list = []

                for row in cur.fetchall():
                    application_list.append(row[0][0])

                if '0' not in application_list:
                    query_delete = "delete from member_application where application_uid = %(uid)s"
                    cur.execute(query_delete, {'uid': cur_uid})
                    mysql.connection.commit()

    except HTTPException:
        return redirect(url_for('home'))

    return redirect(url_for('home'))


# -----------------------Show other profile -------------
@app.route("/otherProfile", methods=['GET', 'POST'])
def otherProfile():
    if request.method == 'POST':
        whichprofile = request.form['sdfs']
        print(whichprofile, type(whichprofile))
        cur = mysql.connection.cursor()
        if whichprofile:
            select_search_uid = "select uid from user where unickname = %(unickname)s"
            cur.execute(select_search_uid, {'unickname': whichprofile})
            select_uid = cur.fetchall()

            select_profile_mid = "select uid from profile"
            cur.execute(select_profile_mid)
            query_mid = cur.fetchall()
            total_user_profile = set()
            for row in query_mid:
                total_user_profile.add(row[0])

            if select_uid[0][0] in total_user_profile:
                query_other_profile = "select page, pname from profile where uid = %(select_uid)s"
                cur.execute(query_other_profile, {'select_uid': select_uid})
                all_profile = cur.fetchall()
                other_profile = []
                for row in all_profile:
                    other_profile.append(row)

                return redirect(
                    url_for('home', other_profile_age=other_profile[0][0], other_profile_name=other_profile[0][1],
                            choose_name=whichprofile))
            else:
                return redirect(url_for('home', other_profile_age=None, other_profile_name=None))
        return redirect(url_for('home'))


# ---------------------------------------------
@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        cur = mysql.connection.cursor()
        hash_password = hashlib.sha1(("%s" % (str(password))).encode('utf-8'))
        hash_pass = hash_password.hexdigest()
        try:
            query = 'SELECT * FROM next_social.user_credential WHERE unickname = %(unickname)s'
            cur.execute(query, {'unickname': username})
            true_password = cur.fetchall()[0][1]

            if hash_pass != true_password:
                error = 'Invalid Credentials. Please try again.'
            else:
                session['user'] = username

                query_search_uid = "select uid from user where unickname = %(unickname)s"
                cur.execute(query_search_uid, {'unickname': username})
                cur_uid = cur.fetchone()[0]

                query_member = "select uid from next_social.member"
                cur.execute(query_member)
                query_get_uid = cur.fetchall()
                total_uid = set()
                for row in query_get_uid:
                    total_uid.add(row[0])

                if cur_uid in total_uid:
                    query_search_mid = "select m.mid from next_social.member m where m.uid = %(cur_uid)s"
                    cur.execute(query_search_mid, {'cur_uid': cur_uid})

                    user_mid = cur.fetchone()[0]

                    query_search_login = "select mid from logout"
                    cur.execute(query_search_login, {'username': username})
                    query_get_mid = cur.fetchall()
                    total_mid = set()
                    for row in query_get_mid:
                        total_mid.add(row[0])

                    if user_mid in total_mid:
                        cur_time = datetime.datetime.now()
                        query_update_login = "update logout set login_time = %(cur_time)s where mid = %(user_mid)s"
                        cur.execute(query_update_login, {'cur_time': cur_time, 'user_mid': user_mid})
                        cur.connection.commit()
                    else:
                        cur_time = datetime.datetime.now()
                        query_update_login = "insert into `logout`(`mid`,`logout_time`, `login_time`) values " \
                                             "(%(user_mid)s, NULL, %(cur_time)s)"
                        cur.execute(query_update_login, {'user_mid': user_mid, 'cur_time': cur_time})
                        cur.connection.commit()

                response = redirect(url_for('home'))
                return response

        except IndexError:
            error = "No such username exist. Please try again."
        except TypeError:
            error = "Type Error Detect! Stop Attacking!"

    return render_template('login.html', error=error)


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    error = None
    cur = mysql.connection.cursor()

    query_address = "select aname from address;"
    cur.execute(query_address)
    address_name = cur.fetchall()
    address_list = []
    for row in address_name:
        address_list.append(row)

    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        google_address = request.form['address']
        address = None

        try:
            select_address = request.form['select_oneaddress']
        except BadRequestKeyError:
            select_address = None

        aid = None

        if google_address:
            address = google_address
            i = 0
            while i < len(google_address) and google_address[i] != ',':
                i += 1

            address_la = float(google_address[1:i])
            address_lo = float(google_address[i + 1:-2])

            query_select_aid = "select aid from address where alongtitude =%(long)s and alatitude = %(la)s"

            cur.execute(query_select_aid, {'long': math.floor(address_la), 'la': math.floor(address_lo)})
            aid = cur.fetchone()[0]

        elif select_address:
            address = select_address
            query_select_aid = "select aid from address where aname = %(address_name)s"
            cur.execute(query_select_aid, {'address_name': address})
            aid = cur.fetchone()[0]


        if username and password and address:

            hash_password = hashlib.sha1(("%s" % (str(password))).encode('utf-8'))
            hash_pass = hash_password.hexdigest()

            try:
                query = "insert into `user_credential`(`unickname`, `password`) values " \
                        "(%(unickname)s, %(password)s)"
                cur.execute(query, {'unickname': username, 'password': hash_pass})
                mysql.connection.commit()

                session['user'] = username
                query_insert_user = "insert into `user`(`unickname`,`aid`) values (%(unickname)s, %(aid)s)"
                cur.execute(query_insert_user, {'unickname': username, 'aid': aid})
                mysql.connection.commit()

                response = redirect(url_for('login'))
                return response

            except MySQLdb.OperationalError:
                error = "Duplicate. Please try again."
        elif not username:
            error = "Username can't be empty, please fill username"
        elif not password:
            error = "Password can't be empty, please fill password"
        elif not address:
            error = "Address can't be empty, please either select address or pick a point on google map"


    return render_template('signup.html', error=error, address_list=address_list)


@app.route('/logout')
def logout():
    # print(datetime)

    username = session.get('user')
    cur = mysql.connection.cursor()

    query_search_uid = "select uid from user where unickname = %(unickname)s"
    cur.execute(query_search_uid, {'unickname': username})
    cur_uid = cur.fetchone()[0]

    query_member = "select uid from next_social.member"
    cur.execute(query_member)
    query_get_uid = cur.fetchall()
    total_uid = set()
    for row in query_get_uid:
        total_uid.add(row[0])

    if cur_uid in total_uid:
        query_mid = "select m.mid from next_social.member m, user u where unickname = %(unickname)s and u.uid = m.uid"
        cur.execute(query_mid, {'unickname': username})
        user_mid = cur.fetchone()
        cur_time = datetime.datetime.now()

        query_update_logout = "update logout set logout_time = %(cur_time)s where mid = %(user_mid)s"
        cur.execute(query_update_logout, {'cur_time': cur_time, 'user_mid': user_mid})
        cur.connection.commit()

    session.clear()
    return render_template('login.html')


if __name__ == "__main__":
    app.run(debug=True)
