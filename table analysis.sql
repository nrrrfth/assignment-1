CREATE TABLE sales_order
(
	order_id integer,
	order_created timestamp,
	voucher_code text,
	customer_id integer,
	shipped_to varchar,
	items integer,
	total_price numeric
)

select * from sales_order

CREATE TABLE sales_order_item
(
	order_id integer,
	order_item_id integer,
	status_id integer,
	product_id integer,
	price numeric
)

select * from sales_order_item

CREATE TABLE sales_order_source
(
	order_id integer,
	tanggal date,
	sumber text
)

select * from sales_order_source

CREATE TABLE status_order_item
(
	status_id integer,
	status text
)

select * from status_order_item

CREATE TABLE sales_order_item
(
	order_id integer,
	order_item_id integer,
	status_id integer,
	product_id integer,
	price numeric
)

select * from sales_order_item
CREATE TABLE sales_product
(
	product_id integer,
	gender text,
	brand_id integer,
	main_category_category_subcategory text,
	price numeric
)
select * from sales_product

CREATE TABLE brand_details
(
	brand_id integer,
	brand_name text
)
select * from brand_details