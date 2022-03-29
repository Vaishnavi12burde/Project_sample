--Task 1
CREATE TABLE matches ( id int, city varchar, date date, player_of_match varchar, venue varchar, neutral_venue int, team1 varchar,  team2 varchar,  toss_winner varchar,  toss_decision varchar,  winner varchar, result_mode varchar,result_margin int, eliminator varchar, method_dl varchar, umpire1 varchar, umpire2 varchar ); 

--Task 2
copy matches from 'C:\Users\Public\IPL_matches.csv'with csv header; 

--task 3
CREATE TABLE deliveries ( id int,  inning int,  over int,  ball int,  batsman varchar,  non_striker varchar, bowler varchar,  batsman_runs int, extra_runs int,  total_runs int, wicket_ball int, dismissal_kind varchar, player_dismissed varchar, fielder varchar, extras_type varchar, batting_team varchar,bowling_team varchar); 

--Task 4 to Task 9
copy deliveries from 'C:\Users\Public\IPL_Ball.csv'with csv header;
select * from matches;
select * from deliveries;
select * from deliveries limit 20;
select * from matches limit 20;
select * from matches where date='02-05-2013';
select * from matches where result_margin >=101;
select * from matches where result = 'tie' order by date desc;

--Task 10
select city,count(id) from matches group by city;
select count (distinct city) from matches; 

--Task 11
create table deliveries_v02 as select *,  
    CASE WHEN total_runs >= 4 then 'boundary'  
         WHEN total_runs = 0 THEN 'dot' 
   else 'other' 
     END as ball_result  
   FROM deliveries; 

--Task 12  
select ball_result, count (*) from deliveries_v02 group by ball_result; 
 
--Task 13 
select batting_team, count(*) from deliveries_v02 where ball_result = 'boundary' group by batting_team order by count desc; 
 
--Task 14 
select bowling_team, count(*) from deliveries_v02 where ball_result = 'dot' group by bowling_team order by count desc; 
 
--Task 15 
select dismissal_kind, count (*) from deliveries where dismissal_kind <> 'NA' group by dismissal_kind order by count desc; 
 
--Task 16 
select bowler, sum(extra_runs) as total_extra_runs from deliveries group by bowler order by total_extra_runs desc limit 5; 
 
--Task 17 
create table  deliveries_v03 AS SELECT a.*, b.venue, b.match_date from  
deliveries_v02 as a  
left join (select max(venue) as venue, max(date) as match_date, id from matches group by id) as b 
on a.id = b.id; 
select * from deliveries_v03;
 
--Task 18 
select venue, sum(total_runs) as runs from deliveries_v03 group by venue order by runs desc; 
 
--Task 19 
select extract(year from match_date) as IPL_year, sum(total_runs) as runs from  deliveries_v03  
where venue = 'Eden Gardens' group by IPL_year order by runs desc; 
 
--Task 20 
select distinct team1 from matches; 
 
create table matches_corrected as select *, replace(team1, 'Rising Pune Supergiants', 'Rising Pune Supergiant') as team1_corr 
, replace(team2, 'Rising Pune Supergiants', 'Rising Pune Supergiant') as team2_corr from matches; 
 
select distinct team1_corr from matches_corrected; 
 
--Task 21 
create table deliveries_v04 as select concat(id,'-',inning,'-',over,'-',ball) as ball_id, * from deliveries_v03; 
 
--Task 22 
select * from deliveries_v04 limit 20; 
select count(distinct ball_id) from deliveries_v04; 
select count(*) from deliveries_v04; 
 
--Task 23 
drop table deliveries_v05; 
create table deliveries_v05 as select *, row_number() over (partition by ball_id) as r_num from deliveries_v04; 
 
--Task 24 
select count(*) from deliveries_v05; 
select sum(r_num) from deliveries_v05; 
select * from deliveries_v05 order by r_num  limit 20; 
select * from deliveries_v05 WHERE r_num=2; 
 
--Task 25 
SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2); 


   

