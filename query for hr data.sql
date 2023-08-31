SELECT * FROM hr_project.hr;
use hr_projects;
select * from hr;
alter table hr add column age int;
update hr
set age = timestampdiff(year,birthdate, curdate());
select 
	min(age) as youngest,
	max(age) as eldest
from hr;
select count(*) from hr where age<18;
select birthdate, age from hr;

-- questions
-- what is the gender breakdown of employees in company
select gender, count(*) AS count
from hr
where age >=18 And termdate= ''
group by gender;

-- what is the race/ethnicity breakdown of employees in the company
select race, count(*) as count
from hr
where age >=18 And termdate= ''
group by race
order by count(*) desc;
-- What is the age distribution of employees in the company
select 
	min(age) as youngest,
    max(age) as eldest
from hr
where age >=18 And termdate= '';
select 
	case 
		when age>= 18 and age<=24 then '18-24'
        when age>= 25 and age<=34 then '25-34'
        when age>= 35 and age<=44 then '35-44'
        when age>= 45 and age<=54 then '45-54'
        when age>= 55 and age<=64 then '55-64'
        else '65+'
	end as age_group,
    count(*) as count
    from hr
    where age >=18 And termdate= ''
    group by age_group
    order by age_group;
    select 
	case 
		when age>= 18 and age<=24 then '18-24'
        when age>= 25 and age<=34 then '25-34'
        when age>= 35 and age<=44 then '35-44'
        when age>= 45 and age<=54 then '45-54'
        when age>= 55 and age<=64 then '55-64'
        else '65+'
	end as age_group, gender, 
    count(*) as count
    from hr
    where age >=18 And termdate= ''
    group by age_group, gender
    order by age_group,gender;
    -- how many employees work at headquarter vs remote location
    select location, count(*) as count
    from hr
     where age >=18 And termdate= ''
     group by location;
     -- what is the average lenght of employment for employees who have been terminated
     select 
     round(avg(datediff(termdate, hire_date))/365,0) as avg_len_employ
     from hr
     where termdate <= curdate() and termdate!= '' and age>= 18;
     -- how does the gender distribution vary accros department and job tittles
     select department, gender, count(*) as count
     from hr
       where age >=18 And termdate= ''
       group by department, gender
       order by department;
   -- what is the distribution of job tittles accros the company
   select jobtitle,count(*) as count
   from hr
     where age >=18 And termdate= ''
     group by jobtitle
     order by jobtitle desc;
 -- which dept has the highest turnover rate-- 
 select department,
 total_count,
 terminated_count,
 terminated_count/total_count as termination_rate
 from (
 select department,
 count(*) as total_count,
 sum(case when termdate!= ''and termdate <= curdate() then 1 else 0 end) as terminated_count
 from hr
   where age >=18 
   group by department
   ) as subquery
   order by termination_rate desc;
   -- what is tge distribution of employees accross location by cities and states
   select location_state, count(*) as count
   from hr
     where age >=18 And termdate= ''
     group by location_state
     order by count desc;
 -- how has the companies employee count change over time based on hire and term date
 select 
 year,
 hires,
 terminations,
 hires - terminations as net_change, 
 round((hires - terminations)/hires*100,2) as net_change_percent
 from(
	select 
		year(hire_date) as year,
        count(*) as hires,
        sum( case when termdate!= ''and termdate <= curdate() then 1 else 0 end) as terminations
        from hr
        where age >=18
        group by year(hire_date)
        ) as subquery
        order by year asc;

-- what is the tenure distribution for each department
select department, round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate!= '' and age >=18
group by department;

