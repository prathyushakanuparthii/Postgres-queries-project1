create table project1(
Date date,
Fy varchar(20),
customer_name varchar(100),
Dia varchar(20),
Dia_group varchar(20),
Grade varchar(20),
Type varchar(30),
length varchar(30),
Quantity decimal(4,2),
Rate decimal(8,2));

select*from project1;

drop table project1;

/* identifying the null values */
select* from project1 where quantity is null;
update project1 set quantity = 5.91 where quantity is null;
select avg(quantity) as mean_values from project1;

/*null values in rate */
select * from project1 where rate is null;
select avg(rate) as mean_vales from project1;
update project1 set rate = 48521.1 where rate is null;

/* identifying the outliers quantity */
with Quartiles as(
select percentile_cont(0.25) within group(order by quantity) as Q1,
	percentile_cont(0.75) within group(order by quantity) as Q3 from project1)
	select
	Q1 - 1.5 * (Q3 - Q1) as lower_bound,
	Q3 + 1.5 * (Q3 - Q1) as upper_bound,
	Q3 - Q1 as IQR
	from Quartiles;
/* count of ouliers */
select count(*) from project1 where quantity < -5.54 or quantity > 14.54;
/*updating the outliers with mean values using winsorization techniques */
update project1 set quantity = 3.9 where quantity < -5.54;
update project1 set quantity = 3.9 where quantity > 14.54;

/* identifying the outliers in rate column */
with quartiles as(
select percentile_cont(0.25) within group (order by rate) as Q1,
	percentile_cont(0.75) within group(order by rate) as Q3 from project1)
	select
	Q1 - 1.5*( Q3 - Q1) as lower_bound,
	Q3 + 1.5 * (Q3 - Q1) as upper_bound,
	Q3 - Q1 as IQR
	from quartiles;
/* identifying outliers */
select rate from project1 
where rate < 20375 or rate > 77375;
/*  count of the outliers */
select count(*) rate from project1 where rate < 20375 or rate > 77375;
select percentile_cont(0.5) within group(order by rate) as median_values from project1;
/* updating the outliers with median values */
update project1 set rate = 45700 where rate < 20375;
update project1 set rate = 45700 where rate > 77375;
/*univariate for quantity 
univariate means single variable, for that we have to calculate the aggregated function like mean,
median and standard deviation. */

select avg(quantity) as mean_values from project1;

select percentile_cont(0.5) within group(order by quantity) as median_values from project1;

select stddev(quantity) as standard_deviantion_values from project1;

SELECT quantity,count(*) AS frequency
FROM project1
GROUP BY quantity;

/*bivariate for quantity 
bi variate means it involves to examine and interpret the 
data based on the relationship b/w two variables. corelation coefficiency,regression analysis, scatterplot */

select quantity, rate from project1;
SELECT corr(quantity,  rate) AS correlation_value
FROM project1;

SELECT
  quantity,
  rate,
  COUNT(*) AS frequency
FROM project1
GROUP BY quantity, rate;

/*quantity */
select avg(quantity) as mean_values from project1;

select percentile_cont(0.5) within group(order by quantity) as median_values from project1;

select quantity as mode_values,
count(quantity) as mode_frequency from project1
group by quantity
order by count(quantity)desc
limit 1;

select variance(quantity) as variance_values from project1;

select stddev(quantity) as standard_deviation_values from project1;

select max(quantity) - min(quantity) from project1;

select(sum(power(quantity - avg_quantity,3))) / (count(quantity) * power(stddev_pop(quantity),3))
as skewness_values from project1,
lateral(select avg(quantity) as avg_quantity from project1) as avg_subquery;


select(sum(power(quantity - avg_quantity,4))) / (count(quantity) * power(stddev_pop(quantity),4))
as kurtosis_values from project1,
lateral(select avg(quantity) as avg_quantity from project1) as subquery;

/* rate */
select avg(rate) as mean_values from project1;

select percentile_cont(0.5) within group (order by rate) as median_values from project1;

select rate as mode_values , count(rate) as mode_frequency from project1
group by rate
order by count(rate) desc
limit 1;

select stddev(rate) as standard_deviation_values from project1;

select variance(rate) as variance from project1;

select max(rate) - min(rate) from project1;

select(sum(power(rate - avg_rate,3))) / (count(rate) * power(stddev_pop(rate),3)) 
as skewness_values from project1,
lateral(select avg(rate) as avg_rate from project1) as avg_subquery;


select(sum(power(rate - avg_rate,4))) / (count(rate) * power(stddev_pop(rate),4))
as kurtosis_values from project1,
lateral(select avg(rate) as avg_rate from project1) as avg_subquery;














