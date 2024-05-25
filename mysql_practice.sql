

-- group by
select * from 
employee_demographics;


select gender, avg(age), max(age) from employee_demographics
group by gender;

select * from employee_salary;

-- order by

select * from employee_demographics order by first_name desc group by gender;

-- having clause 

select occupation, avg (salary) from 
employee_salary where occupation like '%manager%' 
group by occupation;


select occupation from 
employee_salary group by occupation;


-- limit 

select * from employee_demographics 
order by age desc limit 2,1; -- this selects 1 row which comes after the top 2 rows .

-- alias 

select gender , avg(age) as avg_age from employee_demographics group by gender
having avg(age)>40;


 -- joining 
 select * from employee_demographics ;
 select * from employee_salary;
 
 
 select * from employee_demographics ed inner join employee_salary es
 on ed.employee_id=es.employee_id;
 
  select * from employee_demographics ed left join employee_salary es
 on ed.employee_id=es.employee_id;
 
  select * from employee_demographics ed right join employee_salary es
 on ed.employee_id=es.employee_id;
 -- self join
 
  select * from employee_demographics ed join employee_salary es
 on ed.employee_id=es.employee_id;
 
  
select * from employee_salary emp1 join employee_salary emp2
 on emp1.employee_id +1=emp2.employee_id;

select
emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id as emp_santa,
emp2.first_name as first_name_santa,
emp2.last_name as last_name_santa
from
employee_salary emp1 join employee_salary emp2
 on emp1.employee_id +1=emp2.employee_id;

-- joining multiple tables togethjet 

select dem.employee_id, age , occupation from 
employee_demographics as dem 
Inner join
employee_salary as sal
on dem.employee_id= sal.employee_id;


select * from 
employee_demographics as dem 
Inner join
employee_salary as sal
on dem.employee_id= sal.employee_id
Inner join parks_departments pd on sal.dept_id= pd.department_id ;

-- String function 

select length('Uday') as length;

select first_name, length(first_name) 
from employee_demographics 
order by 2;  -- here 2 means column 2.alter

select upper("sky");
select lower("AKA");

select first_name , upper(first_name) from 
employee_demographics;

select trim('     sky     ');
select ltrim('     sky     '), rtrim('     sky     ');
select rtrim('     sky     ');


select first_name, left(first_name,4),
right(first_name,4), substring(first_name,3,2) -- here 3 is the start position and 2 is the no of characters to selct from pos 2 
, birth_date, substring(birth_date,3,2)as year
from employee_demographics; -- this selects only 4 characters from left and right.


select first_name, replace(first_name,'a','z')
from employee_demographics;


select locate('x','Alexander');


select first_name, last_name, 
concat(first_name,' ',last_name) as full_name
from employee_demographics;

-- case statement 

select first_name, last_name, age ,
case 
	when age <= 30 then 'Young'
    when age between 31 and 50 then 'Old'
    when age >50 then "Near death"
    
end as age_bracket
from employee_demographics; 

select * from employee_salary;
select occupation, avg (salary) from 
employee_salary where occupation like '%manager%' 
group by occupation;

select first_name, last_name, salary, 
case
	when salary<50000 then (salary+salary*0.05)
    when salary>=50000 then (salary+salary*0.07)
    end as new_salary,
case 
	when dept_id=6 then (salary*0.1)
    end as bonus
    from employee_salary;
    
    
-- sub queries 

select * from employee_demographics 
where employee_id in 
	(select employee_id from employee_salary
    where dept_id=1)
    ;
    

select gender , avg(age), max(age),min(age),count(age)
from employee_demographics 
group by gender; 


select gender , avg(`max(age)`) -- this is back tick not single inverted comma, it is used to select that particular column.
from (select gender , avg(age), max(age),min(age),count(age)
from employee_demographics 
group by gender)
as agg_table group by gender;

select dem.first_name, dem.last_name , gender , avg(salary) as avg_salary
from employee_demographics dem join employee_salary sal 
on dem.employee_id= sal.employee_id group by gender ,dem.first_name, dem.last_name;


-- window functions

select gender , (select avg(salary) from 
				employee_demographics dem join employee_salary sal 
				on dem.employee_id= sal.employee_id) as avg_salary
from employee_demographics dem join employee_salary sal 
on dem.employee_id= sal.employee_id; -- this method is done using normal sub quering . in order to avoid this subquering we use over().alter


select gender , avg(salary) over()
from employee_demographics dem join employee_salary sal 
on dem.employee_id= sal.employee_id; -- this gives the avg salary for the entire employee 



select gender , avg(salary) over(partition by gender)
from employee_demographics dem join employee_salary sal 
on dem.employee_id= sal.employee_id;-- this now partitions the avg by gender.



select dem.first_name, dem.last_name, gender, sum(salary)
over(partition by gender order by dem.employee_id) as rolling_total
from employee_demographics dem join employee_salary sal 
on dem.employee_id= sal.employee_id;


select dem.employee_id, dem.first_name, dem.last_name, salary,gender,
row_number() over(partition by gender order by salary desc) as row_num,
rank() over(partition by gender order by salary desc) as rank_num,
dense_rank() over(partition by gender order by salary desc) as Denserank_num
from employee_demographics dem join employee_salary sal 
on dem.employee_id= sal.employee_id;

-- CTE's ( advanced MySql). Common Table Expression.


with CTE_example as (
select gender , avg(salary) avg_sal,
 max(salary) max_sal
 ,min(salary) min_sal
 , count(salary) count_sal
from employee_demographics dem join employee_salary sal 
on dem.employee_id= sal.employee_id
group by gender )
select avg(avg_sal) from CTE_example; -- CTE is used for better understandability of the query , unlike subqueries.


with CTE_example1 as (
select employee_id, gender, birth_date
from employee_demographics where 
birth_date>'1985-01-01'),
CTE_example2 as (
select employee_id, salary
from employee_salary where 
salary>50000
)
select * from CTE_example1
join CTE_example2 on 
CTE_example1.employee_id=CTE_example2.employee_id; -- this is an example that we can have multiple CTE in one query. 


-- temporary tables 

create temporary table temp_table 
(
first_name varchar(20),
last_name varchar(20),
fav_movie varchar(50)
);

select * from temp_table;

insert into temp_table values
('Uday','Venkatesha','Breaking bad');


create temporary table salary_over_50k
select * from employee_salary where
salary>50000;

select * from salary_over_50k;


-- stored Procedures 
		-- this creates a procedure which performs certain action and it can be called whenever required without writing the whole query


create procedure large_salaries()
select * from employee_salary 
where salary>=50000;

call large_salaries(); -- this is how to call a procedure.


Delimiter $$   -- delimiter is used to tell that ; is not the end of the query and it all belongs to the same query.
create procedure large_salaries2()
begin
select * from employee_salary 
where salary>=50000;
select * from employee_salary 
where salary>=10000;
end $$
Delimiter ;

call large_salaries2();


Delimiter $$   -- delimiter is used to tell that ; is not the end of the query and it all belongs to the same query.
create procedure large_salaries3(id int)
begin
	select salary from employee_salary
	where employee_id=id;
end $$
Delimiter ;

-- call large_salaries3(1);


Delimiter $$
create procedure large_salaries4(id int)
begin
	select salary from 
    employee_salary 
    where employee_id=id;
    
end $$
Delimiter ;

call large_salaries4(1);


-- triggers and events 


Delimiter $$
create trigger employee_insert 
	after insert on employee_salary
    for each row 
    begin 
		insert into employee_demographics(employee_id, first_name , last_name )
        values( new.employee_id, new.first_name, new.last_name);
	
	end $$
    delimiter ;

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values (13, 'uday','Venkatesha','Data Scientist',1000000,null);

select * from employee_salary;
select * from employee_demographics;


-- events 


Delimiter $$
create event delete_retires
on schedule every 30 second
do
begin
	delete 
    from employee_demographics
    where age>=60;
end $$
delimiter ;

select * from employee_demographics;
















