USE northwind;

-- 1. Pedidos por empresa en UK:
-- Desde las oficinas en UK nos han pedido con urgencia que realicemos una consulta a la base de datos con la 
-- que podamos conocer cuántos pedidos ha realizado cada empresa cliente de UK. Nos piden el ID del cliente y 
-- el nombre de la empresa y el número de pedidos.
-- Deberéis obtener una tabla similar a esta:

SELECT customer_id, company_name, COUNT(orders.order_id)
FROM customers 
NATURAL JOIN orders
WHERE country = "UK"
GROUP BY customer_id;


-- 2. Productos pedidos por empresa en UK por año:
-- Desde Reino Unido se quedaron muy contentas con nuestra rápida respuesta a su petición anterior y han 
-- decidido pedirnos una serie de consultas adicionales. La primera de ellas consiste en una query que nos 
-- sirva para conocer cuántos objetos ha pedido cada empresa cliente de UK durante cada año. Nos piden 
-- concretamente conocer el nombre de la empresa, el año, y la cantidad de objetos que han pedido. 
-- Para ello hará falta hacer 2 joins.
-- El resultado será una tabla similar a esta:

SELECT customers.company_name, YEAR (orders.order_date),  SUM(order_details.quantity) AS numObjectos
FROM orders 
CROSS JOIN customers
CROSS JOIN order_details
WHERE customers.customer_id = orders.customer_id AND order_details.order_id = orders.order_id 
GROUP BY customers.company_name, YEAR (orders.order_date)
HAVING COUNT(customers.country = "UK");


SELECT YEAR(order_date), company_name, SUM(quantity) AS NumObjetos
	FROM customers NATURAL JOIN orders NATURAL JOIN order_details
    WHERE country = "UK"
    GROUP BY YEAR(order_date), company_name;



-- 3. Mejorad la query anterior:
-- Lo siguiente que nos han pedido es la misma consulta anterior pero con la adición de la cantidad de dinero que han pedido por esa cantidad de objetos, teniendo en cuenta los descuentos, etc. Ojo que los descuentos en nuestra tabla nos salen en porcentajes, 15% nos sale como 0.15.
-- La tabla resultante será:

SELECT customers.company_name AS Empresa, YEAR (orders.order_date) AS Año,  SUM(order_details.quantity) AS NumObjectos , SUM(unit_price * (order_details.quantity)*(1-discount)) AS totalValor
FROM orders 
CROSS JOIN customers
CROSS JOIN order_details
WHERE customers.customer_id = orders.customer_id AND order_details.order_id = orders.order_id 
GROUP BY customers.company_name, YEAR (orders.order_date)
HAVING COUNT(customers.country = "UK");

    # el SELECT con CROSS JOIN nos saca también los clientes que no tiene pedidos.


SELECT YEAR(order_date), company_name, SUM(quantity) AS NumObjetos, SUM((unit_price * quantity)*(1-discount)) AS DineroTotal
	FROM customers NATURAL JOIN orders NATURAL JOIN order_details
    WHERE country = "UK"
    GROUP BY YEAR(order_date), company_name;
    
    # el SELECT con NATURAL JOIN no nos está sacando los clientes que no tiene pedidos.


-- 4. BONUS: Pedidos que han realizado cada compañía y su fecha:
-- Después de estas solicitudes desde UK y gracias a la utilidad de los resultados que se han obtenido, desde la central 
-- nos han pedido una consulta que indique el nombre de cada compañia cliente junto con cada pedido que han realizado y su fecha.
-- El resultado deberá ser:

SELECT customers.company_name, orders.order_id, orders.order_date
FROM customers
INNER JOIN orders 
ON customers.customer_id = orders.customer_id;

SELECT company_name, order_id, order_date
	FROM customers NATURAL JOIN orders;


-- 5. BONUS: Tipos de producto vendidos:
-- Ahora nos piden una lista con cada tipo de producto que se han vendido, 
-- sus categorías, nombre de la categoría y el nombre del producto, 
-- y el total de dinero por el que se ha vendido cada tipo de producto (teniendo en cuenta los descuentos).
-- Pista Necesitaréis usar 3 joins.

SELECT categories.category_id, category_name, product_name, SUM((order_details.unit_price * quantity)*(1-discount)) AS TotalporProducto
FROM products
INNER JOIN categories
ON products.category_id = categories. category_id
INNER JOIN order_details
ON products.unit_price = order_details.unit_price
 GROUP BY categories.category_id, category_name, product_name;

SELECT categories.category_id, category_name, product_name, SUM((order_details.unit_price * quantity)*(1-discount)) AS TotalporProducto
	FROM categories INNER JOIN products 
    ON categories.category_id = products.category_id
    INNER JOIN order_details
    ON order_details.product_id = products.product_id
    GROUP BY categories.category_id, category_name, product_name;

