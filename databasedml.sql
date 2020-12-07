--Question 1
select airline
from public.route
where (source_airport_id IN (
 select id
 from public.airport
 where altitude > 10000
 ) AND destination_airport_id IN (
 select id
 from public.airport
 where altitude > 10000
 )
)
group by airline;

--Question 2
with toAthens_SRC_ID as (
 select source_airport_id
 from public.route
 where destination_airport_id = 3941
), fromMSP_DST_ID as (
 select destination_airport_id
 from public.route
 where source_airport_id = 3858
)
select name, city, country
from public.airport
where (
 (id IN (select * from toAthens_SRC_ID))
 AND
 (id IN (select * from fromMSP_DST_ID))
)
group by name, city, country;

--Question 3
with MinneapolisAirports as (
 select id
 from public.airport
 where city = 'Minneapolis'
), MSPAsSource as (
 select airline_id
 from public.route
 where (
  source_airport_id IN (select * from MinneapolisAirports)
 )
)
select name
from public.airline
where (
 (id IN (select * from MSPAsSource))
 AND
 (country != 'ALASKA')
)
group by name;

--Question 4
create view noWayHome as
with name_SRC_DST (sourceName, DestinationName, Source1, dest1) as (
 select source_airport, destination_airport, source_airport_id, destination_airport_id
 from public.route
), returnTrip (farEnd, home) as (
 select source_airport_id, destination_airport_id
 from public.route
), joinedTrips as (
 select *
 from name_SRC_DST
 join returnTrip
  on dest1 = farEnd
), roundTrips as (
 select sourceName, destinationName, source1, dest1
 from joinedTrips
 where (
  Source1 = home
 )
)
select sourceName, DestinationName
from name_SRC_DST
except
 select sourceName, DestinationName
 from roundTrips
group by sourceName, DestinationName;

--Question 5
select destinationName, count(destinationName) as howmany
from noWayHome
group by destinationName
order by howmany desc;

--Answer 5, AMS
