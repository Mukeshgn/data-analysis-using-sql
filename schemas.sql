-- Food Data Analysis using sql

DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS raiders;
DROP TABLE IF EXISTS restaurants;


CREATE TABLE customers
	(
		customer_id INT PRIMARY KEY,
		customer_name VARCHAR(30),
		reg_date DATE
	);

CREATE TABLE restaurants
	(
		restaurant_id INT PRIMARY KEY,
		restaurant_name VARCHAR(60),
		city VARCHAR(25),
		rating INT

	);

CREATE TABLE orders
	(
		order_id INT PRIMARY KEY,
		customer_id INT, -- this is coming from customer table
		restaurant_id INT, -- this is coming from restaurant table
		order_item VARCHAR(60),
		order_date DATE,
		order_time TIME,
		order_status VARCHAR(25),
		total_amount FLOAT

	);

-- adding FK CONSTRAINT
ALTER TABLE orders
ADD CONSTRAINT fk_customers
FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_restaurants
FOREIGN KEY (restaurant_id) 
REFERENCES restaurants(restaurant_id);


CREATE TABLE raiders 
	(
		raider_id INT PRIMARY KEY,
		raider_name VARCHAR(55),
		sign_up DATE

	);



CREATE TABLE deliveries
	(
		delivery_id INT PRIMARY KEY,
		order_id INT, -- this is coming from orders table
		raider_id INT, --this is coming from raider table
		delivery_status VARCHAR(35),
		delivery_time TIME,
		CONSTRAINT fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
		CONSTRAINT fk_raider FOREIGN KEY (raider_id) REFERENCES raiders(raider_id)

	);

-- End of the Schemas
