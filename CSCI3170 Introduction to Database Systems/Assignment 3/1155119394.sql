/*

	Student ID: 1155119394
	Name: CHAN King Yeung

 */

/* Query 1 */
Spool result1.lst
select l.lid, l.league_name, r.region_name, l.year
from leagues l, regions r
where l.rid = r.rid and l.season in ('Spring', 'Summer')
order by l.lid;
Spool off

/* Query 2 */
Spool result2.lst
select t.tid, t.team_name, t.average_age
from teams t, leagues l
where t.tid = l.champion_tid and l.season = 'Autumn' and l.year >= 2015
group by t.tid, t.team_name, t.average_age
having count(*) > 1
order by t.tid;
Spool off

/* Query 3 */
create or replace view list1 (champion_tid, season, n) as
select champion_tid, season, count(*) as n
from leagues
group by champion_tid, season;

create or replace view list2 (season, x_n) as
select season, max(n) as x_n
from list1
group by season;

create or replace view list3 (tid, team_name, average_age, season, w_num) as
select t.tid, t.team_name, t.average_age, l.season, count(*) as w_num
from teams t, leagues l
where t.tid = l.champion_tid
group by t.tid, t.team_name, t.average_age, l.season;

Spool result3.lst
select l3.tid, l3.team_name, l3.average_age, l3.season, l3.w_num
from list2 l2, list3 l3
where l2.season = l3.season and l2.x_n = l3.w_num
order by l3.tid, l3.season;
Spool off

drop view list1;
drop view list2;
drop view list3;

/* Query 4 */
create or replace view list1 (sid, sponsor_name, l_num) as
select s.sid, s.sponsor_name, count(*) as l_num
from sponsors s, support sp, leagues l
where s.sid = sp.sid and sp.lid = l.lid
group by s.sid, s.sponsor_name
order by s.sid;

Spool result4.lst
select *
from list1
where rownum <= 5;
Spool off

drop view list1;

/* Query 5 */
Spool result5.lst
select l.lid, l.league_name
from leagues l, support sp, sponsors s, teams t
where l.lid = sp.lid and sp.sid = s.sid and t.tid = l.champion_tid and l.season in ('Autumn', 'Winter') and s.market_value > 50 and t.average_age < 30
order by l.lid desc;
Spool off

/* Query 6 */
create or replace view list1 (sid, total) as
select sid, sum(sponsorship) as total
from support
group by sid;

create or replace view list2 (sid, market_value, football_ranking, rid) as
select s.sid, s.market_value, r.football_ranking, r.rid
from sponsors s, support sp, leagues l, regions r
where s.sid = sp.sid and sp.lid = l.lid and l.rid = r.rid and s.market_value > 40 and r.football_ranking < 10
group by s.sid, s.market_value, r.football_ranking, r.rid;

create or replace view list3 (sid, hot, rid) as
select l2.sid, l1.total / (sqrt(l2.market_value) * log(2, sqrt(l2.football_ranking) + 1)) as hot, rid
from list1 l1, list2 l2
where l1.sid = l2.sid;

Spool result6.lst
select sid, hot
from list3 l3
where hot = (select max(hot) from list3 where sid = l3.sid)
order by sid desc;
Spool off

drop view list1;
drop view list2;
drop view list3;

/* Query 7 */
create or replace view list1 (sid, total) as
select sid, sum(sponsorship) as total
from support
group by sid;

create or replace view list2 (sid, market_value, football_ranking, rid) as
select s.sid, s.market_value, r.football_ranking, r.rid
from sponsors s, support sp, leagues l, regions r
where s.sid = sp.sid and sp.lid = l.lid and l.rid = r.rid
group by s.sid, s.market_value, r.football_ranking, r.rid;

create or replace view list3 (sid, hot, rid) as
select l2.sid, l1.total / (sqrt(l2.market_value) * log(2, sqrt(l2.football_ranking) + 1)) as hot, rid
from list1 l1, list2 l2
where l1.sid = l2.sid;

create or replace view list4 (sid, hot, rid) as
select *
from list3
where sid in (4, 5, 6, 7)
order by rid;

create or replace view list5 (rid, hot_4, hot_5, hot_6, hot_7) as
select rid, coalesce(hot_4, 0), coalesce(hot_5, 0), coalesce(hot_6, 0), coalesce(hot_7, 0)
from (select g.rid, g.hot_4, g.hot_5, g.hot_6, h.hot as hot_7
      from (select e.rid, e.hot_4, e.hot_5, f.hot as hot_6
            from (select c.rid, c.hot_4, d.hot as hot_5
                  from (select a.rid, b.hot as hot_4
                        from (select distinct rid from regions) a
                        left join (select * from list4 where sid = 4) b
                        on a.rid = b.rid) c
                  left join (select * from list4 where sid = 5) d
                  on c.rid = d.rid) e
            left join (select * from list4 where sid = 6) f
            on e.rid = f.rid) g
      left join (select * from list4 where sid = 7) h
      on g.rid = h.rid
      order by g.rid desc);

Spool result7.lst
select rid, nullif(hot_4, 0) as hot_4, nullif(hot_5, 0) as hot_5, nullif(hot_6, 0) as hot_6, nullif(hot_7, 0) as hot_7, greatest(hot_4, hot_5, hot_6, hot_7) as hot_higt
from list5;
Spool off

drop view list1;
drop view list2;
drop view list3;
drop view list4;
drop view list5;

/* Query 8 */
create or replace view list1 (champion_tid, league_name) as
select champion_tid, league_name
from leagues
group by champion_tid, league_name;

create or replace view list2 (champion_tid, win) as
select champion_tid, count(*) as win
from list1
group by champion_tid;

create or replace view list3 (champion_tid, win) as
select *
from list2
where win = (select max(win)
             from list2);

Spool result8.lst
select s.sid, s.sponsor_name
from leagues l, list3 l3, support sp, sponsors s
where l.champion_tid = l3.champion_tid and l.lid = sp.lid and sp.sid = s.sid
group by s.sid, s.sponsor_name
order by s.sid;
Spool off

drop view list1;
drop view list2;
drop view list3;
