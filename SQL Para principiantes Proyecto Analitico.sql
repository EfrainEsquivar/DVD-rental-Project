/* 1. ¿Cuál es el precio de alquiler promedio para cada género de película? */
/*
SELECT
	category.name AS genero,
	AVG(amount) AS precio_alquiler_promedio
FROM category LEFT JOIN film_category ON category.category_id = film_category.category_id
			  LEFT JOIN inventory ON film_category.film_id = inventory.film_id
			  LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
			  LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY 1
ORDER BY 2 DESC
*/

/* 2. ¿Cuántos clientes hay? y ¿cuál es el valor de todas las ventas en los siguientes
países: Perú, México, Brasil, Chile, Colombia? */
/*
SELECT
	country.country AS pais,
	SUM(amount) AS total_venta_por_pais
FROM country LEFT JOIN city ON country.country_id = city.country_id
			 LEFT JOIN address ON city.city_id = address.city_id
			 LEFT JOIN customer ON address.address_id = customer.address_id
			 LEFT JOIN payment ON customer.customer_id = payment.customer_id
WHERE country = 'Peru' OR country = 'Mexico' OR country = 'Brazil' OR country = 'Chile' OR country = 'Colombia'
GROUP BY 1
ORDER BY 2 DESC
*/

/* 3. ¿Cuántos clientes distintos han alquilado una película en cada género? */
/*
WITH T1 AS (
SELECT
	customer.customer_id,
	category.name AS genero,
	COUNT(*) 
FROM customer LEFT JOIN rental ON customer.customer_id = rental.customer_id
			  LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
			  LEFT JOIN film ON inventory.film_id = film.film_id
			  LEFT JOIN film_category ON film.film_id = film_category.film_id
		      LEFT JOIN category ON film_category.category_id = category.category_id
GROUP BY 1,2
HAVING COUNT(category.name)>=1
ORDER BY 1 DESC, 2 ASC
)

SELECT customer_id FROM T1 
     GROUP BY customer_id 
     HAVING COUNT(*)=16
	 ORDER BY 1
*/

/* 4. ¿Cuántas películas se devolvieron a tiempo, o tarde? 
Tips: Deberás calcular la cantidad de días entre la fecha de alquiler y la fecha de 
devolución para cada alquiler. Deberás comparar esa cantidad de días con la duración
de un alquiler en la columna llamada: “rental duration” */

SELECT
	rental_id,
	film.film_id,
	film.rental_duration,
	title,
	rental_date,
	return_date,
	DATE_PART('day', return_date - rental_date) AS dias_en_renta
FROM rental LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
			LEFT JOIN film ON inventory.film_id = film.film_id
			/* Vamos a comparar rental_durarion de dias_en_renta para obtener si es un alquiler atrasado.
			Si rental_duration >= dias_en_renta, devuelta a tiempo
			Si rental_duration < dias_en_renta, devuelta con atraso */
/* WHERE rental_duration >= DATE_PART('day', return_date - rental_date) */
/* WHERE rental_duration < DATE_PART('day', return_date - rental_date) */
 WHERE return_date IS NULL
GROUP BY 1,2
ORDER BY 2 DESC

			 

