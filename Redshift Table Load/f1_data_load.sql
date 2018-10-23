/************************************************************************
You can run the the entire script in one go. However before running the 
script replace the IAM role ARN corresponding to your environment. If 
you do not replace the "arn:aws:iam::413094830157:role/myRedshiftRole"
string from this script, it will fail.
************************************************************************/

/****** DB setup with ReadOnly users and ETL Users and DB schema *****/
create group etlusers;
create group rousers;
create user labuser with password 'Welcome123' in group rousers;
create user etluser with password 'Welcome123' in group etlusers;

create schema demo_local authorization labuser;
create table demo_local.schema_creation(creation_date date default trunc(sysdate));

--drop table demo_local.f1_races;

CREATE TABLE demo_local.f1_races(
  raceid bigint primary key sortkey encode raw, 
  year bigint, 
  round bigint, 	
  circuitid bigint, 
  name varchar(50), 
  date varchar(20), 
  time varchar(20), 
  url varchar(200)
)
diststyle all;

-- Replace the IAM Role ARN corresponding to your AWS account.
copy demo_local.f1_races from 's3://awspsa-sampledata/f1data/races/' iam_role 'arn:aws:iam::413094830157:role/myRedshiftRole' gzip csv IGNOREHEADER 1 region as 'us-east-1';

select * from demo_local.f1_races order by raceID desc limit 10;


--drop table  demo_local.f1_results;
CREATE TABLE demo_local.f1_results(
  resultid bigint primary key, 
  raceid bigint encode raw, 
  driverid bigint, 
  constructorid bigint, 
  number bigint, 
  grid bigint, 
  position int, 
  positiontext varchar(2), 
  positionorder int  encode raw, 
  points decimal(5,2), 
  laps bigint, 
  time varchar(20), 
  milliseconds bigint, 
  fastestlap int, 
  rank int, 
  fastestlaptime varchar(20), 
  fastestlapspeed varchar(20), 
  statusid bigint
  )
  sortkey (raceId, positionOrder)
  ;
  
  -- Replace the IAM Role ARN corresponding to your AWS account.
  copy demo_local.f1_results from 's3://awspsa-sampledata/f1data/results/' iam_role 'arn:aws:iam::413094830157:role/myRedshiftRole' gzip csv IGNOREHEADER 1 region as 'us-east-1';
  
  select * from demo_local.f1_results order by raceId desc, rank limit 20;
  
  
  
  drop table demo_local.f1_constructors;
  CREATE TABLE demo_local.f1_constructors(
  constructorid bigint primary key sortkey encode raw, 
  constructorref varchar(20), 
  name varchar(50), 
  nationality varchar(20), 
  url varchar(100)
  )
  diststyle all;
  
  -- Replace the IAM Role ARN corresponding to your AWS account.
  copy demo_local.f1_constructors from 's3://awspsa-sampledata/f1data/constructors/' iam_role 'arn:aws:iam::413094830157:role/myRedshiftRole' gzip csv IGNOREHEADER 1 region as 'us-east-1';
  
  select * from demo_local.f1_constructors order by constructorid desc limit 20;
  
 
  
  drop table f1_driver;
  CREATE TABLE demo_local.f1_driver(
  driverid bigint primary key sortkey encode raw, 
  driverref varchar(20), 
  number int, 
  code varchar(3), 
  forename varchar(50), 
  surname varchar(50), 
  dob date, 
  nationality varchar(20), 
  url varchar(100)
  )
  diststyle all;
 
 -- Replace the IAM Role ARN corresponding to your AWS account.
 copy demo_local.f1_driver from 's3://awspsa-sampledata/f1data/driver/' iam_role 'arn:aws:iam::413094830157:role/myRedshiftRole' gzip csv IGNOREHEADER 1 region as 'us-east-1';

 select * from demo_local.f1_driver order by driverid desc limit 20;
  
  
drop table demo_local.f1_lap_times;
CREATE TABLE demo_local.f1_lap_times(
  raceid bigint encode raw , 
  driverid bigint, 
  lap bigint encode raw, 
  position bigint, 
  time varchar(20), 
  milliseconds bigint
  )
  sortkey (raceid, lap);
 
 -- Replace the IAM Role ARN corresponding to your AWS account.
 copy demo_local.f1_lap_times from 's3://awspsa-sampledata/f1data/lap_times/' iam_role 'arn:aws:iam::413094830157:role/myRedshiftRole' gzip csv IGNOREHEADER 1 region as 'us-east-1';

 select * from demo_local.f1_lap_times order by raceId desc, lap limit 20;
 
 

drop table demo_local.f1_pit_stops;
CREATE TABLE demo_local.f1_pit_stops(
  raceid bigint sortkey encode raw, 
  driverid bigint, 
  stop bigint, 
  lap bigint, 
  time varchar(20), 
  duration varchar(20), 
  milliseconds bigint)
  ;

-- Replace the IAM Role ARN corresponding to your AWS account.
 copy demo_local.f1_pit_stops from 's3://awspsa-sampledata/f1data/pit_stops/' iam_role 'arn:aws:iam::413094830157:role/myRedshiftRole' gzip csv IGNOREHEADER 1 region as 'us-east-1';

 select * from demo_local.f1_pit_stops order by raceId desc, lap limit 20;
