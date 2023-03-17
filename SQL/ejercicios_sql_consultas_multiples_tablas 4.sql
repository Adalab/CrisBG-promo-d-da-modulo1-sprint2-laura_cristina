/* Pair programming: 
Enunciado
Es el turno de las subqueries. En este ejercicios os planteamos una serie de queries que nos permitirán conocer información de la 
base de datos, que tendréis que solucionar usando subqueries.

Ejercicios
 1Extraed información de los productos "Beverages"
En este caso nuestro jefe nos pide que le devolvamos toda la información necesaria para identificar un tipo de producto. 
En concreto, tienen especial interés por los productos con categoría "Beverages". 
Devuelve el ID del producto, el nombre del producto y su ID de categoría.*/

-- Con lo que sabemos ahora las dos primeras hubieran sido las primeras opciones para resolverlo -- 
SELECT product_id, product_name, category_id
FROM products NATURAL JOIN categories
WHERE categories.category_name = "Beverages"; 

SELECT product_id, product_name, category_id
FROM products
WHERE category_id = 1;

-- Aquí resolvemos aplicando la lección subconsultas -- 

SELECT product_id, product_name, category_id
FROM products
	WHERE category_id IN (
						SELECT category_id 
                        FROM categories
                        WHERE category_name = "Beverages"); 

/*2. Extraed la lista de países donde viven los clientes, pero no hay ningún proveedor ubicado en ese país
Suponemos que si se trata de ofrecer un mejor tiempo de entrega a los clientes, entonces podría dirigirse a 
estos países para buscar proveedores adicionales.*/

SELECT country
FROM customers
WHERE country NOT IN (
			SELECT country
			FROM suppliers)
			GROUP BY country; 

/*3. Extraer los clientes que compraron mas de 20 articulos "Grandma's Boysenberry Spread"
Extraed el OrderId y el nombre del cliente que pidieron más de 20 artículos del producto "Grandma's Boysenberry Spread" 
(ProductID 6) en un solorder_detailso pedido.*/

SELECT order_id, customer_id
FROM orders
GROUP BY order_id
HAVING order_id IN  (
			SELECT order_id
			FROM order_details
			WHERE product_id = 6 and quantity > 20);

-- esta es una consulta intermedia para ver cuantos pedidos tenemos correspondiente al product_id = 6 mayores de 20 unidades
SELECT order_id, product_id, quantity
FROM order_details
WHERE product_id = 6 AND quantity > 20; 									

/*4. Extraed los 10 productos más caros
Nos siguen pidiendo más queries correlacionadas. En este caso queremos saber cuáles son los 10 productos más caros.*/ 

SELECT product_name, unit_price
FROM (SELECT *
	  FROM products) AS tabla2
      ORDER BY unit_price DESC
      LIMIT 10; 

/*5. BONUS - Qué producto es más popular
Extraed cuál es el producto que más ha sido comprado y la cantidad que se compró.*/

-- Pendiente de resolver

SELECT product_name, product_id
FROM products
WHERE product_id > ANY (
					SELECT SUM(quantity) AS MaxCantidad
					FROM order_details
					GROUP BY product_id);

SELECT product_name
FROM products
GROUP BY product_id
HAVING product_id >= ALL( 
					SELECT SUM(quantity) AS MaxCantidad
					FROM order_details
					GROUP BY product_id);



