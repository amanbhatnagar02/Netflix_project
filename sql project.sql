select count(*) from netflix1;
select * from netflix1;


select distinct type from netflix1;


-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

select type ,count(*) from netflix1
group by type

--2. Find the most common rating for movies and TV shows
 
 select type,rating
 from (
	select 
		type,
		rating , 
		count(*) ,
		rank()over(partition by type order by count(*) desc) as ranking 
	from netflix1
	group by 1,2 
)as t1
where
	ranking = 1


--3. List all movies released in a specific year (e.g., 2020)

select title,release_year from netflix1
where release_year = 2020 and type = 'Movie';

--4. Find the top 5 countries with the most content on Netflix

select 
 unnest(string_to_array(country,','))as new_country,
 count(show_id)as total_content
from netflix1
group by 1
order by 2 desc
limit 5;



--5. Identify the longest movie

select title ,duration 
from netflix1 
where type='Movie' and duration = (select max(duration) from netflix1);


--6. Find content added in the last 5 years

select max(release_year) from netflix1;

select title,release_year from netflix1 where release_year <='2016'

select * from netflix1 where  to_date(date_added,'Month DD , YYYY')>= Current_date-interval '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select title,director from netflix1 where director like '%Rajiv Chilaka%'


--8. List all TV shows with more than 5 seasons

select *
from netflix1
where type = 'TV Show' and split_part(duration,' ',1)::numeric >5 


--9. Count the number of content items in each genre

 select 
    unnest(string_to_array(listed_in ,','))as genre,
	count(show_id) as total_content

 from netflix1
 group by 1 

 
--10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select 
	extract(year from to_date(date_added ,'Month DD ,YYYY')) as year,
	count(*) as yearly_content ,
	round(
	count(*)::numeric/(select count(*) from netflix1 where country  = 'India')::numeric *100
	,2)AS AVG_CONTENT_PER_YEAR 
	from netflix1 
	WHERE country ='India'
	group by 1 ;
	
--11. List all movies that are documentaries

select title from netflix1 where type ='Movie' and listed_in ilike '%Documentaries%'


--12. Find all content without a director

select * from netflix1
where director is null;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!


select * from netflix1 where casts ilike '%Salman Khan%' and release_year >= extract(year from current_date)-10;
select current_date;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
unnest(string_to_array(casts,','))as actors,
count(*) as total_movies
from netflix1
where country ilike '%india'
group by 1
order by 2 desc
limit 10;


--15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

with new_table as(
select *,
	case 
		when description ilike '%kill%' or description ilike '%violence%' then 'good_content'
		else 'bad_film'
	end category
from netflix1
)
select 
	category,
	count(*) as total_content
from new_table
group by 1;
