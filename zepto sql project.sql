DROP TABLE IF EXISTS zepto;
create table zepto(
sku_id serial primary key,
category varchar(150),
name varchar(150) not null,
mrp numeric(8,2),
discountpercemt numeric(5,2),
avlqty int,
discselling_price numeric(8,2),
wt_in_grams int,
out_of_stock boolean,
qty int); 

select * from zepto;


--DATA EXPLORATION

--Rename column name
alter table zepto
rename column "discountpercemt" to "discountpercent";
--count of rows
select count(*) from zepto;
--sample date 
select * from zepto
limit 10;
--null values
select * from zepto
where category is null
or name is null
or mrp is null
or discountpercent is null
or avlqty is null
or discselling_price is null
or wt_in_grams is null
or out_of_stock is null
or qty is null;

--different product categories
select distinct category from zepto
group by category;

--product in stock vs out of stock
select out_of_stock, count(sku_id)
from zepto
group by out_of_stock;

--product name present multiple times
select name, count(sku_id) as no_of_skus
from zepto
group by name 
order by no_of_skus desc;

--DATA CLEANING

--product with price 0
select * from zepto
where mrp= 0 or discselling_price= 0;

delete from zepto
where mrp= 0;

--convert paise to rupees
update zepto
set mrp= mrp/100.00,
discselling_price=discselling_price/100.00;

 select * from zepto;

 --BUSINESS QUESTIONS
 --1.Find the top 10 best-value products based on the discount percentage.
 select distinct name,mrp,discountpercent from zepto
 order by discountpercent desc
 limit 10;
 
 --2.What are the products with high mrp but out of stock.
 select distinct name,mrp,out_of_stock from zepto
 where out_of_stock= true
 order by mrp desc;
 
 --3.Calculate the estimated revenue for each category.
 select category, sum(discselling_price * avlqty) as total_revenue
 from zepto
 group by category
 order by total_revenue desc;
 
 --4.Find all product where mrp is greater than 500 and discount is less than 10%.
 select distinct name,mrp,discountpercent from zepto
 where mrp>=500 and discountpercent<=10; 
 
 --5.Identify top 5 categories offering the highest avg discount percentage.
select category,round(avg(discountpercent),2) as avg_discount from zepto
group by category
order by avg_discount desc
limit 5;

 --6.Find the price per gram for the products above 100g and sort by best value.
select distinct name,wt_in_grams,discselling_price,
round(discselling_price/wt_in_grams,2) as price_per_gram
from zepto
where wt_in_grams>=100
order by price_per_gram ;

 --7.Group the products into category like low, medium, bulk.
 select distinct name, wt_in_grams ,
case when wt_in_grams<1000 then 'low'
     when wt_in_grams<5000 then 'medium'
 else 'bulk'
 end category_by_wt
 from zepto;
 
 --8.What is the total inventory weight per category.
 select category,sum(wt_in_grams * avlqty) as total_wt
 from zepto
 group by category
 order by total_wt desc;