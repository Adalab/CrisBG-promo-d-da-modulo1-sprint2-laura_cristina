-- Enunciado
-- En esta lección de pair programming vamos a continuar trabajando sobre la base de datos Northwind.
-- El día de hoy vamos a realizar ejercicios en los que practicaremos las queries SQL a múltiples tablas 
-- usando los operadores LEFT JOIN, RIGHT JOIN, SELF JOIN. De esta manera podremos combinar los datos de diferentes tablas 
-- en las mismas bases de datos, para así realizar consultas mucho mas complejas.

-- Ejercicios

-- 1.Qué empresas tenemos en la BBDD Northwind:
-- Lo primero que queremos hacer es obtener una consulta SQL que nos devuelva el nombre de todas las empresas cliente, 
-- los ID de sus pedidos y las fechas.

SELECT company_name, order_id, order_date
	FROM orders NATURAL JOIN customers; 
    
SELECT customers.company_name, orders.order_id, orders.order_date
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id;

-- 2. Desde la oficina de Reino Unido (UK) nos solicitan información acerca del número de pedidos que ha 
-- realizado cada cliente del propio Reino Unido de cara a conocerlos mejor y poder adaptarse al mercado actual. 
-- Especificamente nos piden el nombre de cada compañía cliente junto con el número de pedidos.

SELECT company_name, COUNT(orders.order_id)
	FROM customers NATURAL JOIN orders
    WHERE country = "UK"
    GROUP BY customer_id; 

SELECT customers.company_name AS NombreClientes, COUNT(orders.order_id) AS NumeroPedidos
FROM orders
LEFT JOIN customers
ON (customers.customer_id = orders.customer_id) AND country = "UK"
GROUP BY customers.customer_id; 
-- En este segundo caso, también nos da los pedidos de los clientes de UK pero al hacer LEFT JOIN nos añade una columna null con el total de pedidos del resto de clientes.

SELECT customers.company_name AS NombreClientes, COUNT(orders.order_id) AS NumeroPedidos
FROM orders
LEFT JOIN customers
ON (customers.customer_id = orders.customer_id) 
GROUP BY customers.customer_id
	HAVING COUNT(customers.country) = "UK"; 

-- 3. Empresas de UK y sus pedidos:
-- También nos han pedido que obtengamos todos los nombres de las empresas cliente de Reino Unido (tengan pedidos o no) 
-- junto con los ID de todos los pedidos que han realizado, el nombre de contacto de cada empresa y la fecha del pedido.

SELECT orders.customer_id AS Pedidos, customers.company_name AS NombreClientes, orders.order_date AS Fecha
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
WHERE orders.ship_country = "UK";

SELECT company_name, contact_name, order_id, order_date
	FROM customers CROSS JOIN orders
    WHERE country = "UK"; 

-- 4. Empleadas que sean de la misma ciudad:
-- Ejercicio de SELF JOIN: Desde recursos humanos nos piden realizar una consulta que muestre por pantalla los datos de todas 
-- las empleadas y sus supervisoras. Concretamente nos piden: la ubicación, nombre, y apellido tanto de las empleadas como de las jefas. 
-- Investiga el resultado, ¿sabes decir quién es el director?

SELECT A.first_name AS Nombre, A.last_name AS Apellido, A.city AS Ciudad, B.first_name AS NombreSuperior, B.last_name AS ApellidoSuperior
FROM employees AS A, employees AS B
WHERE B.employee_id = A.reports_to; 

-- BONUS: FULL OUTER JOIN Pedidos y empresas con pedidos asociados o no:
-- Selecciona todos los pedidos, tengan empresa asociada o no, y todas las empresas tengan pedidos asociados o no. 
-- Muestra el ID del pedido, el nombre de la empresa y la fecha del pedido (si existe).

SELECT orders.order_id, customers.company_name, orders.order_date
FROM orders 
LEFT JOIN customers 
ON orders.customer_id = customers.customer_id
UNION  
SELECT orders.order_id, customers.company_name, orders.order_date
FROM orders
RIGHT JOIN customers
ON orders.customer_id = customers.customer_id;
