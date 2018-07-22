use sakila;

/** Display the first and last name of all actors in the actor table **/
select 
	first_name, last_name
from
	actor;
    
/** Display the first and last name of all actors in a single column in upper case letters. Name the column 'Actor name**/

Select
	upper(concat(first_name, ' ', last_name)) as 'Actor Name'
From
	actor;

/** Find the ID Number, first name, and last name of an actor, of whom you only know the 
first name, "Joe." What is one query would you use to this information **/

select
	actor.actor_id, actor.first_name, actor.last_name
from
	actor
where 
	upper(actor.first_name) = 'JOE';
    
/** Find all actors whose last name contain the letters 'GEN':**/

Select
	*
from
	actor
where
	upper(actor.last_name) like '%G%'
		and upper(actor.last_name) like '%E%'
        and upper(actor.last_name) like '%N%';
        
/** Find all actors whose last names contain the letters LI. This time, 
order the rows by last name and first name, in that order **/

select
	actor.last_name, actor.first_name
from 
	actor
where
	upper(actor.last_name) like '%L%'
		and upper(actor.last_name) like '%I%';

/** Using 'IN', display the 'country_id' and 'country' columns of the following countries: 
Afghanistan, Bangladesh, and China: **/

select
	country.country_id, country.country
from
	country
where country.country in ("Afghanistan", "Bangladesh", "China");

/** Add a middle_name column to the table 'actor'. Position it first name and last name **/

alter table actor
add middle_name varchar(45) not null;

alter table actor modify column middle_name varchar(45) after first_name;

/* Change data type of the middle_name column to 'blobs'. */
 
 alter table actor modify column middle_name blob;
 
 /** Delete middle_name column **/
 alter table actor drop column middle_name;
 
/** 4a **/

select distinct	
	actor.last_name, count(actor.last_name)
from
	actor
group by actor.last_name;

/** 4b **/

select distinct
	actor.last_name, count(actor.last_name) as Count
from
	actor
group by actor.last_name
having count(actor.last_name) >= 2;

/** 4c **/

select
	actor.actor_id, first_name, actor.last_name
from
	actor
where
	upper(actor.first_name) = 'GROUCHO';
update actor
set
	actor.first_name = 'HARPO'
where
	actor.actor_id = 127;
    
/** 4d **/

update actor
set 
	first_name = 'GROUCHO'
where 
	first_name = 'HARPO';
    
/** 5a **/

create table address (
	address_id smallint(5) unsigned not null auto_increment,
    address varchar(50) not null,
    address2 varchar(50) default null, 
    district varchar(20) not null,
    city_id smallint(5) unsigned not null,
    phone varchar(20) not null,
    location geometry not null,
    last_update timestamp not null default current_timestamp on update current_timestamp,
    primary key (address_id),
    key idx_fk_city_id (city_id),
    spatial key idx_location (location),
    constraint fk_address_city foreign key (city_id) references city (city_id) on update cascade
)

/** 6a **/

select
	actor.first_name, actor.last_name, address.address
from
	actor
		left join
	address on actor.actor_id = address.address_id;
    
/** 6b **/

select
	staff.first_name, sum(payment.amount) as 'Total Per Person'
from
	staff
		left join
	payment on staff.staff_id = payment.staff_id
group by staff.first_name;

/** 6c **/

select
	film title, count(film.film_id)
from film
		join
	inventory on film.film_id = inventory.film_id
where
	inventory.film_id = 439;
    
/** 6e **/

select
	customer.last_name, sum(payment.amount)
from customer
		join
	payment on customer.customer_id = payment.customer_id
group by customer.last_name
order by customer.last_name asc;

/** 7a **/

select
	film.title, language.name
from
	language
		left join
	film on film.language_id = language.language_id
where
	(film.title like 'K%'
		or film.title like 'Q%')
        and language.name = 'English';

/** 7b **/

select
	film.title,
    actor.first_name,
    actor.last_name,
    film_actor.actor_id
from
	film_actor
		left join
	film on (film.film_id = film_actor.film_id)
		left join
	actor on (actor.actor_id = film_actor.actor_id)
where
	film.title = 'alone trip';
    
/** 7c **/

SELECT 
    customer.first_name,
    customer.last_name,
    customer.email,
    city.city,
    country.country
FROM
    address
        JOIN
    customer ON customer.address_id = address.address_id
        JOIN
    city ON city.city_id = address.city_id
        JOIN
    country ON country.country_id = city.country_id
WHERE
    country = 'CANADA';
    
/** 7d **/

SELECT 
    film.title, category.name
FROM
    film_category
        JOIN
    film ON film.film_id = film_category.film_id
        JOIN
    category ON category.category_id = film_category.category_id
WHERE
    category.name = 'Family';
    
/** 7e **/

SELECT 
    film.title, COUNT(film.title) AS count
FROM
    rental
        LEFT JOIN
    payment ON payment.customer_id = rental.customer_id
        LEFT JOIN
    inventory ON inventory.inventory_id = rental.inventory_id
        LEFT JOIN
    film ON film.film_id = inventory.film_id
GROUP BY film.title
ORDER BY count DESC;

/** 7f **/

SELECT 
    staff.store_id AS Store, SUM(payment.amount) AS 'Total Sum'
FROM
    staff
        LEFT JOIN
    payment ON payment.staff_id = staff.staff_id
GROUP BY staff.store_id;

/** 7g **/

SELECT 
    store.store_id AS 'Store ID', city.city, country.country
FROM
    address
        JOIN
    store ON store.address_id = address.address_id
        JOIN
    city ON city.city_id = address.city_id
        JOIN
    country ON country.country_id = city.country_id;
    
/** 7h **/

SELECT category.name as GENRES,  sum( payment.amount) as 'TOTAL SUM'

from rental 

left join payment on payment.rental_id = rental.rental_id

left join inventory on inventory.inventory_id = rental.inventory_id

left join film  on film.film_id = inventory.film_id

left join film_category on film_category.film_id = inventory.film_id

left join category on category.category_id = film_category.category_id

group by category.name

order by sum( payment.amount) desc

limit 5;

/** 8a **/

CREATE VIEW TOP_GENRES_BY_GROSS AS
    SELECT 
        category.name AS GENRES, SUM(payment.amount) AS 'TOTAL SUM'
    FROM
        rental
            LEFT JOIN
        payment ON payment.rental_id = rental.rental_id
            LEFT JOIN
        inventory ON inventory.inventory_id = rental.inventory_id
            LEFT JOIN
        film ON film.film_id = inventory.film_id
            LEFT JOIN
        film_category ON film_category.film_id = inventory.film_id
            LEFT JOIN
        category ON category.category_id = film_category.category_id
    GROUP BY category.name
    ORDER BY SUM(payment.amount) DESC
    LIMIT 5;
    
/** 8b **/

select*from top_genres_by_gross;

/**8c **/

drop view top_genres_by_gross;