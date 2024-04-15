drop database if exists HR_Analytics;
# creating a database named "HR_Analytics"
create database if not exists HR_Analytics; 
use HR_Analytics;
# creating table departments
create table Departments (
Emp_id int,
Dept_id int,
Dept_name varchar(30) not null);
# crating index function on department table 
CREATE INDEX idx_dept_id ON Departments(Dept_id);
# creating table employee
create table employee (
Emp_id int primary key,
First_name varchar(30) not null,
Last_name varchar(30) not null,
Age int,
Gender enum('Male','Female'),
Joining_date date,
Dept_id int,
Designation varchar(50) not null,
salary int,
foreign key (Dept_id) references Departments(Dept_id)
);
#creating table employee productivity and performance 
create table emp_productivity (
Emp_id int primary key,
Dept_id int,
projects_completed int,
productivity int,
satisfactiory_rate int,
foreign key (Dept_id) references Departments(Dept_id)
);
#importing values into the employee table , emp_productivity and department table by import mentod
select * from emp_productivity;
select * from employee;
select * from departments;
# alter table by adding constraint to check age of employee above 18
alter table employee
add constraint check_age check(age >= 18); 
-- aggregate functions
# count function - counting number of rows in the table employee
select count(*) from employee;
# SUM function - calculating the sum of salary of all employees in employee table 
select sum(salary) from employee;
# AVG function - Calculating the Average salary of all employees in employee table 
select avg(salary) from employee;
# MIN function - Calculating the minimum salary of employees in employee table 
select min(salary) from employee;
# MAX Function - Calculating the maximum salary of employees in employee table 
select max(salary) from employee;
#  Order by - Ordering the employee by thier age from highest to lowest 
select * from employee
order by age desc;  
# group by - list which department did max productivity by group by clause
Select Max(productivity) as max_productivity , Dept_id 
From emp_productivity
Group by Dept_id;
# Window functions
# row_number
Select Emp_id, First_name, Last_name, salary,Designation,
       row_number() over (order by salary desc) as rownumber
from employee;
# rank - Ranking the employees based on their salary from highest to lowest 
Select Emp_id, First_name, Last_name, salary,
       rank() over (order by salary desc) as ranknumber
from employee;
# join functions
-- List the name of employee and how many projects he completed and his productivity rate 
select e.Emp_id,e.first_name,e.Last_name,p.projects_completed,p.productivity
from employee e
inner join emp_productivity p
on e.Emp_id = p.Emp_id;
-- list the data by arranging employee name and their resepective departments
select e.Emp_id,e.First_name,e.Last_name,d.Dept_id,d.dept_name
from employee e
left join departments d
on e.Emp_id = d.Emp_id;
# multiple row subquery 
select Emp_id,dept_name
from departments
where dept_id in (select dept_id from
 employee);
# list the name of employees who is working in Sales department alone -- nested query
Select Emp_id,first_name, last_name
from employee
where dept_id in (
    select dept_id
    from departments
    where dept_name = 'Sales'
);
# co- related sub query 
# order the name of employees by thier department id 
select emp_id, first_name, last_name, salary, dept_id
from
    employee e
where
    salary > (select avg(salary)
        from employee
        where dept_id = e.dept_id)
order by dept_id;
    
# view 
# list the name of employees whose productivity is more than 70 percent
create view Higher_productivity as
select employee.Emp_id,employee.First_name,emp_productivity.dept_id,emp_productivity.productivity
from employee
    inner join emp_productivity on employee.Emp_id = emp_productivity.Emp_id
where 
    emp_productivity.productivity > 70;
select * from Higher_productivity;
# create a temporary table to list down the highest paid employees using CTE
with highest_paid_employees as (
  select Emp_id,First_name,Last_name,Designation,salary from employee where salary > 90000
)
select * from highest_paid_employees;
# stored procedures 
# create a procedure by creating the list of employees with thier designation by stored procedure
call list_by_designation();

-- create a trigger to check the age , whenever a new employee comes in trigger checks age > 18 if not it wont accept
delimiter //
create trigger age_check before insert
ON employee
for each row
if new.age < 18 then
signal sqlstate '50001' set message_text = 'Person must be older than 18.';
END IF; //
delimiter ;
-- inserting the value to the table where age is less than 18
insert into employee(Emp_id,First_name,Last_name,Age,Gender,Joining_date,Dept_id,Designation,salary)
values (150,'Alex','Hamilton',17,'Male','2021-04-04',1004,'sales',30000);
# case function
# Analyse the employee productivity based on thier productivity percentage:
select Emp_id,Dept_id,projects_completed,productivity,
    CASE
        when productivity > 70 then 'High Productive'
        when productivity > 60 then 'Medium Productive'
        else 'Low Productive'
    end as Productivity_Category
from
    emp_productivity;
 
 


  



     








    




