
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 
INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');
---
CREATE TABLE users(userid integer,signup_date date); 
INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');
---
CREATE TABLE sales(userid integer,created_date date,product_id integer)
INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);

---

CREATE TABLE product(product_id integer,product_name text,price integer);
INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);
select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

---1 what is the total ammount of each consumer spent on zamato
select a.userid,sum(b.price) total_amount_spent from sales a inner join product b on a.product_id = b.product_id
group by a.userid

select a.userid , sum(b.price) total_amount_spent 
from sales a inner join product b on a.product_id = b.product_id group by userid

---2 how many days has each customer visited zamato?
select userid,count(distinct created_date) from sales group by userid

---3 what was 1st product purches by each customer
select * from
(select * , rank() over (partition by userid order by created_date) rnk from sales) a where rnk = 1

---4 what is the most purched item on the menu and how many times was it purched by all customer

select product_id , count(product_id) most_purches from sales group by product_id 

---5 which item was the most popular for each customer?
select * from
(select *, rank() over (partition by userid order by ordered desc) rnk from
(select userid, product_id, count(product_id) ordered from sales group by userid,product_id)a)b
where rnk = 1

---6 which item was purched first by the customer after they become the member

select*from
(select *, rank() over (partition by userid order by created_date ) rnk from
(select userid , product_id , created_date from sales )a)b
where rnk = 1

----8 total amount spent after member

select*from 
(select *, rank() over (partition by userid order by userid )  rnk from
(select a.userid,sum(b.price) total_amount_spent  from sales a inner join product b on a.product_id = b.product_id
group by a.userid)c)d
where rnk = 1

---9 if buying each product generates point for eg 5rs= 2 zomato points each product has different purches point 
for eg- P1 5rs=1 zomato points for P2 10rs=5 zomato points and for P3 5rs=1 zomato points , calculate total points earned by each customer

select userid , sum(total_points) total_points_earned from
(select e.* , amt/point as total_points from
(select d.* , case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as point from
(select c.userid,c.product_id,sum(price) amt  from
(select a.*, b.price from sales a inner join product b on a.product_id = b.product_id)c
group by userid,product_id)d)e)f group by userid

--- 10 rank all the transaction of the customer

select * , rank() over (partition by userid order by created_date) rnk from sales