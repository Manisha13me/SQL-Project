select*from protfolio.data1;
select*from protfolio.data2;

-- number of rows into our dataset
select count(*) from protfolio.data1;
select count(*) from protfolio.data2;

-- dataset for jharkhand and bihar
select * from protfolio.data1 where state in ('Jharkhand' ,'Bihar');

-- population of India
select sum(population) as Population from protfolio.data2;

-- avg growth 
select state,avg(growth)*100 avg_growth from protfolio.data1 group by state;

-- avg sex ratio
select state,round(avg(sex_ratio),0) avg_sex_ratio from protfolio.data1 group by state order by avg_sex_ratio desc;

-- avg literacy rate
 select state,round(avg(literacy),0) avg_literacy_ratio from protfolio.data1 
group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc ;

-- top 3 state showing highest growth ratio
select state,avg(growth)*100 avg_growth from protfolio.data1 group by state order by avg_growth desc limit 3;

-- bottom 3 state showing lowest sex ratio
select state,round(avg(sex_ratio),0) avg_sex_ratio from protfolio.data1 group by state order by avg_sex_ratio asc;

-- top and bottom 3 states in literacy state
create table topstates(
state varchar(255),
topstates float
);

insert into topstates
select state,round(avg(literacy),0) avg_literacy_ratio from protfolio.data1 
group by state order by avg_literacy_ratio desc;

select * from topstates order by topstates.topstates desc;
select * from topstates order by topstates.topstates asc;

-- states starting with letter a
select distinct state from protfolio.data1 where lower(state) like 'a%' or lower(state) like 'b%';
select distinct state from protfolio.data1 where lower(state) like 'a%' and lower(state) like '%m';

-- joining both table
-- total males and females
select d.state, sum(d.males) as total_males, sum(d.females) as total_females from (
select c.district, c.state,round(c.population/(c.Sex_Ratio+1),0) as males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) as females from 
(select a.state, a.district, a.Sex_Ratio/1000 as Sex_ratio, b.Population from data1 a
inner join data2 b
on a.district = b.district) c) d
group by d.state;
--  female / males = sex ratio ....... 1
-- females + males = population ...... 2
-- females = population - males ...... 3
-- (population - males) = (sex_ratio) * males
-- populatio = males (sex_ratio+1)
-- males = population/(sex_ratio+1) .....males
-- females = population-(population/(sex_ratio+1)) .... females
-- = population(1-1/(sex_ratio+1)
-- = (population(sex_ratio))/ (sex_ratio + 1)



-- total literact rate
-- total literate people/ population-literacy ratio

select a.district, a.state, a.literacy as literacy_ratio,b.population from data1 a inner join data2 b 
on a.district=b.district;


-- total literate people = literacy ratio*population
-- total illterate people = (1- literacy _ratio)*population

select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from protfolio.data1 a 
inner join protfolio.data2 b on a.district=b.district) d) c
group by c.state;


