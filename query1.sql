select * from sales_order
select * from brand_details
select * from sales_order_item
select * from status_order_item
select * from sales_product
select * from sales_order_source

-- TASK 2

-- no 1 jumlah item completed per hari
SELECT DATE(order_created) AS tanggal, COUNT(*) AS jumlah_item
FROM sales_order
JOIN sales_order_item ON sales_order.order_id = sales_order_item.order_id
JOIN status_order_item ON sales_order_item.status_id = status_order_item.status_id
WHERE status = 'Completed'
GROUP BY DATE(order_created)
ORDER BY tanggal ASC

-- no 2 persentase customer yg mengorder barang lebih dari 1 pesanan

SELECT ROUND(COUNT(DISTINCT CASE WHEN jumlah_pesanan > 1 THEN customer_id END) * 100.0 / COUNT(DISTINCT customer_id)) AS persentase_pelanggan
FROM (
    SELECT customer_id, COUNT(*) AS jumlah_pesanan
    FROM sales_order
	JOIN sales_order_item ON sales_order.order_id = sales_order_item.order_id
	JOIN status_order_item ON sales_order_item.status_id = status_order_item.status_id
	GROUP BY customer_id
) AS subquery

-- no 3 perbandingan customer berdasarkan gender
SELECT gender, COUNT(*) AS jumlah_pesanan
FROM sales_product 
JOIN brand_details ON sales_product.brand_id = brand_details.brand_id
GROUP BY gender
ORDER BY jumlah_pesanan DESC

-- no 4 perbandingan customer yang melakukan order barang dengan voucher dan tanpa voucher
SELECT  CASE WHEN voucher_code IS NOT NULL THEN 'Dengan Voucher' ELSE 'Tanpa Voucher' END AS kategori,
		COUNT(*) AS jumlah_pesanan,
		ROUND(COUNT(*) * 100.0/SUM(COUNT(*)) OVER (),2) AS persentase
FROM sales_order
JOIN sales_order_item ON sales_order.order_id = sales_order_item.order_id
JOIN status_order_item ON sales_order_item.status_id = status_order_item.status_id
GROUP BY kategori
ORDER BY jumlah_pesanan DESC

-- brand yg memiliki penjualan tertinggi

-- no 5 penjualan tertinggi
SELECT brand_details, SUM(price) AS total_penjualan
FROM sales_product
JOIN brand_details ON sales_product.brand_id = brand_details.brand_id
GROUP BY brand_details
ORDER BY total_penjualan DESC
LIMIT 10

-- no 5 penjualan terendah
SELECT brand_details, SUM(price) AS total_penjualan
FROM sales_product
JOIN brand_details ON sales_product.brand_id = brand_details.brand_id
GROUP BY brand_details
ORDER BY total_penjualan ASC
LIMIT 10

--kategori produk yg memiliki penjualan tertinggi dan terendah

-- no 6 10 kategori product yang memiliki penjualan tertinggi
SELECT product_id, main_category_category_subcategory, SUM(price) AS total_penjualan
FROM sales_product
JOIN brand_details ON sales_product.brand_id = brand_details.brand_id
GROUP BY product_id, main_category_category_subcategory
ORDER BY total_penjualan ASC
LIMIT 10

-- no 6 10 kategori product yang memiliki penjualan terendah
SELECT product_id, main_category_category_subcategory, SUM(price) AS total_penjualan
FROM sales_product
JOIN brand_details ON sales_product.brand_id = brand_details.brand_id
GROUP BY product_id, main_category_category_subcategory
ORDER BY total_penjualan ASC
LIMIT 10

-- no 7 jumlah source terbanyak
SELECT sumber, COUNT(*) AS jumlah_sumber
FROM sales_order_source
GROUP BY sumber
ORDER BY jumlah_sumber DESC;

-- no 8 jam tersibuk pesanan
SELECT EXTRACT(HOUR FROM order_created) AS jam,
       COUNT(*) AS jumlah_pesanan
FROM sales_order
JOIN sales_order_item ON sales_order.order_id = sales_order_item.order_id
JOIN status_order_item ON sales_order_item.status_id = status_order_item.status_id
GROUP BY EXTRACT(HOUR FROM order_created)
ORDER BY jam, jumlah_pesanan ASC

-- no 9 perbandingan status pesanan customer 
SELECT round (COUNT(DISTINCT CASE WHEN status = 'Cancelled' THEN customer_id END) * 100.0 / COUNT(DISTINCT customer_id)) AS persentase_cancelled,
	   round (COUNT(DISTINCT CASE WHEN status = 'Completed' THEN customer_id END) * 100.0 / COUNT(DISTINCT customer_id)) AS persentase_completed,
	   round (COUNT(DISTINCT CASE WHEN status = 'Refunded' THEN customer_id END) * 100.0 / COUNT(DISTINCT customer_id)) AS persentase_refunded
FROM (
	SELECT customer_id, status
	FROM sales_order
	JOIN sales_order_item ON sales_order.order_id = sales_order_item.order_id
	JOIN status_order_item ON sales_order_item.status_id = status_order_item.status_id
	GROUP BY customer_id, status
) AS subquery

-- no 10 daerah pengiriman dengan total penjualan tertinggi
SELECT shipped_to, SUM(total_price) AS total_penjualan
FROM sales_order
JOIN sales_order_item ON sales_order.order_id = sales_order_item.order_id
JOIN status_order_item ON sales_order_item.status_id = status_order_item.status_id
WHERE status = 'Completed'
GROUP BY total_price, shipped_to
ORDER BY total_price DESC
LIMIT 5