USE northwind;

-- 1. Selecciona todos los campos de los productos, que pertenezcan a los proveedores con códigos: 1, 3, 7, 8 y 9, q
-- que tengan stock en el almacén, y al mismo tiempo que sus precios unitarios estén entre 50 y 100. 
-- Por último, ordena los resultados por código de proveedor de forma ascendente.

SELECT * FROM products 
WHERE units_in_stock > 0 
AND unit_price BETWEEN 50 AND 100 
AND supplier_id IN (1, 3, 7, 8, 9);

-- selecioné todas las columnas de la tabla products;
-- con atributos que tuvieran más de 50 unidades de producto en estoque;
-- de provedores con id igual a 1, 3, 7, 8 y 9.


-- 2. Devuelve el nombre y apellidos y el id de los empleados con códigos entre el 3 y el 6, además que hayan vendido a clientes 
-- que tengan códigos que comiencen con las letras de la A hasta la G. Por último, en esta búsqueda queremos filtrar solo por 
-- aquellos envíos que la fecha de pedido este comprendida entre el 22 y el 31 de Diciembre de cualquier año.

SELECT e.first_name, e.last_name, o.employee_id, customer_id, shipped_date -- (columnas para pruebas para mejor visualización)
FROM employees AS e
INNER JOIN orders AS o
ON e.employee_id = o.employee_id -- columnas comunes entre las dos tablas 
WHERE e.employee_id BETWEEN 3 AND 6 -- en la cláusula WHERE van las restriciones (condiciones o filtros)
AND customer_id REGEXP "^[A-G].*" -- sacar los nombres que empiecen con A a G y demas caracteres
AND DAY(shipped_date) BETWEEN 22 AND 31 
AND MONTH(shipped_date) = 12;


-- 3. Calcula el precio de venta de cada pedido una vez aplicado el descuento. Muestra el id del la orden, el id del producto,
--  el nombre del producto, el precio unitario, la cantidad, el descuento y el precio de venta después de haber aplicado el 
-- descuento.

SELECT o.order_id, o.product_id, p.product_name, o.unit_price, o.quantity, o.discount, 
(o.unit_price * o.quantity)*(1 - o.discount) AS PrecioVenta
FROM order_details AS o
NATURAL JOIN products;

-- calculé el precio de venta de los productos con el descuento unindo uniendo las tablas order_details and products a través 
-- de la columna común entre ellas.


-- 4. Usando una subconsulta, muestra los productos cuyos precios estén por encima del precio medio total de los productos 
-- de la BBDD.

SELECT product_name, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price)
					FROM products);

-- calculé el precio medio de todos los productos;
-- coloqué en la subconsulta con le operador menor que los precios de los productos.


-- 5. ¿Qué productos ha vendido cada empleado y cuál es la cantidad vendida de cada uno de ellos?


SELECT p.product_name AS Producto, e.first_name AS Nombre, e.last_name AS Apellido, COUNT(quantity) AS CantidadTotal
FROM products AS p
INNER JOIN order_details AS od
ON p.product_id = od.product_id
INNER JOIN orders AS o
ON od.order_id = o.order_id 
INNER JOIN employees AS e
WHERE o.employee_id = e.employee_id
GROUP BY e.employee_id, p.product_name
ORDER BY e.employee_id, Producto;



-- 6. Basándonos en la query anterior, ¿qué empleado es el que vende más productos? Soluciona este ejercicio con una subquery
-- BONUS ¿Podríais solucionar este mismo ejercicio con una CTE?


SELECT first_name , last_name, COUNT(product_name) AS ProductosVendidos -- creé la consulta con la empleada que más productos vendidos tiene
FROM (SELECT DISTINCT first_name, last_name, e.employee_id, product_name -- creé la subconsulta para unir las tablas de donde vienen las distintas informaciones necesarias 
							FROM employees AS e
							NATURAL JOIN orders AS o
							NATURAL JOIN order_details AS od
							JOIN  products AS p
							ON od.product_id = p.product_id) AS VentasEmpleados
GROUP BY employee_id -- agrupé por empleada
ORDER BY ProductosVendidos DESC -- ordené de forma decendente para que pusiera la que más vendió en primer lugar
LIMIT 1; -- limité a la primera entrada para que solo devolvera por pantalla la empleada que más productos ha vendido



WITH VentasEmpleados -- creé la tabla temporal VentasEmpleados
AS (SELECT DISTINCT first_name , last_name , e.employee_id , product_name
			FROM employees AS e
			NATURAL JOIN orders AS o
			NATURAL JOIN order_details AS od
			JOIN products AS p
				ON od.product_id = p.product_id)
                
SELECT first_name, last_name, COUNT(Product_name) AS ProductosVendidos
FROM VentasEmpleados -- usé la tabla temporal para buscar los datos sobre productos más vendidos
GROUP BY employee_id -- agrupé por empleados 
ORDER BY ProductosVendidos DESC -- ordené de forma decendente para que pusiera la que más vendió en primer lugar
LIMIT 1; -- limité a la primera entrada para que solo devolvera por pantalla la empleada que más productos ha vendido;  
                



