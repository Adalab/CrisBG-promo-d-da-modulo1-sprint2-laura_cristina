-- Pair programming Simplificando consultas con CTEs --

-- Actividades - 
/* 1. Extraer en una CTE todos los nombres de las compañias y los id de los clientes.
Para empezar nos han mandado hacer una CTE muy sencilla el id del cliente y el nombre de la compañia de la tabla Customers.*/ 

SELECT company_name, customer_id
FROM customers; 

/*2. Selecciona solo los de que vengan de "Germany"
Ampliemos un poco la query anterior. En este caso, queremos un resultado similar al anterior, pero solo queremos los que pertezcan a "Germany".*/

WITH filtro_pais AS (
				SELECT company_name, customer_id, country
				FROM customers) 
		SELECT * FROM filtro_pais
        WHERE country = 'Germany'; 

/*3. Extraed el id de las facturas y su fecha de cada cliente.
En este caso queremos extraer todas las facturas que se han emitido a un cliente, su fecha la compañia a la que pertenece.
📌 NOTA En este caso tendremos columnas con elementos repetidos(CustomerID, y Company Name).*/

SELECT order_id, order_date, customer_id, company_name
FROM orders NATURAL JOIN customers;


/*4. Contad el número de facturas por cliente
Mejoremos la query anterior. En este caso queremos saber el número de facturas emitidas por cada cliente.*/

/*5. Cuál la cantidad media pedida de todos los productos ProductID.
Necesitaréis extraer la suma de las cantidades por cada producto y calcular la media.*/