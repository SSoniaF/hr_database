create table Education(
    edu_lvl_id serial primary key, 
    edu_lvl_nm varchar(50));

create table Job(
    job_id serial primary key, 
    job_nm varchar(100));    

create table Department(
    dep_id serial primary key, 
    dep_nm varchar(50));
    
create table Salary(
    sal_id serial primary key, 
    sal_amt int);
    
create table Location(
    loc_id serial primary key, 
    loc_nm varchar(50),
    addr varchar(100),
    city varchar(50),
    state varchar(2));
    
create table Employee(
    emp_id varchar(8) primary key unique,
    emp_nm varchar(50),
    email varchar(100),
    edu_lvl_id int,
    hire_dt date);
    
create table Job_Hist(
    emp_id varchar(8) references Employee(emp_id),
    job_id int references Job(job_id),
    start_dt date,
    end_dt date,
    dep_id int references Department(dep_id),
    mgr_id varchar(8) references Employee(emp_id),
    loc_id int references Location(loc_id),
    sal_id int references Salary(sal_id),
    constraint jh_pk primary key (emp_id, job_id, start_dt)
);
    
insert into Education (edu_lvl_nm)
select distinct(education_lvl) from proj_stg;  

select * from Education;

insert into Job (job_nm)
select distinct(job_title) from proj_stg;  

select * from Job;
    
insert into Department (dep_nm)
select distinct(department_nm) from proj_stg;  

select * from Department;

insert into Salary (sal_amt)
select distinct(salary) from proj_stg;  

select * from Salary;

insert into Location (loc_nm, addr, city, state)
select distinct location, address, city, state from proj_stg;  

select * from Location;

insert into Employee (emp_id, emp_nm, email, edu_lvl_id, hire_dt)
select distinct s.Emp_ID, s.Emp_NM, s.Email, ed.edu_lvl_id, s.hire_dt from proj_stg as s
join Education as ed 
on s.education_lvl = ed.edu_lvl_nm;

select * from Employee limit 5;

insert into Job_Hist (emp_id, job_id, start_dt, end_dt, dep_id, mgr_id, loc_id, sal_id)
select s.Emp_ID, j.job_id, s.start_dt, s.end_dt, d.dep_id, e.emp_id, l.loc_id, sl.sal_id
from proj_stg as s
join Job as j
on s.job_title = j.job_nm
join Department as d
on s.department_nm = d.dep_nm
left outer join Employee as e
on s.manager = e.emp_nm
join Location as l
on s.location = l.loc_nm
join Salary as sl
on s.salary = sl.sal_amt;

select * from Job_Hist limit 5;

select jh.emp_id, e.emp_nm, j.job_nm, d.dep_nm from Job_Hist as jh
join Employee as e
on jh.emp_id = e.emp_id
join Job as j
on jh.job_id = j.job_id
join Department as d
on jh.dep_id = d.dep_id
where jh.end_dt > current_date;

select * from Job;

insert into Job(job_nm)
values ('Web Programmer');

select * from Job;


update Job
set Job_nm = 'Web Developer'
where job_nm = 'Web Programmer';

select * from Job;

delete from Job
where job_nm = 'Web Developer';

select * from Job;

select d.dep_nm, count(jh.emp_id) from Job_Hist as jh
join Department as d
on jh.dep_id = d.dep_id
where jh.end_dt > current_date
group by d.dep_id;

select e.emp_nm, j.job_nm, d.dep_nm, f.emp_nm, jh.start_dt, jh.end_dt from Job_Hist as jh
join Employee as e
on jh.emp_id = e.emp_id
join Job as j
on jh.job_id = j.job_id
join Department as d
on jh.dep_id = d.dep_id
join Employee as f
on jh.mgr_id = f.emp_id
where e.emp_nm ='Toni Lembeck';


