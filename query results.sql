-- Retrieve the total number of orders placed.
select count(order_id) from orders


-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(p.price * od.quantity), 2) as revenue
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id


-- Identify the highest-priced pizza.
SELECT 
    price, pizza_id
FROM
    pizzas
ORDER BY price DESC
LIMIT 1


-- Identify the most common pizza size ordered.
SELECT 
    COUNT(size), size
FROM
    pizzas
GROUP BY size
ORDER BY COUNT(size) DESC


-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) AS quantity
FROM
    pizzzaaaaatype pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.﻿pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY quantity DESC
LIMIT 5


------------------------------------------------------------------------------------------------------


-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS quantity
FROM
    pizzzaaaaatype pt
        JOIN
    pizzas p ON pt.﻿pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY quantity


-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time), COUNT(order_Id)
FROM
    orders
GROUP BY (HOUR(time))


-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    pt.category, COUNT(order_id)
FROM
    pizzzaaaaatype pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.﻿pizza_type_id
        JOIN
    order_Details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY COUNT(order_id) DESC


-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    AVG(quantity)
FROM
    (SELECT 
        o.date, SUM(od.quantity) AS quantity
    FROM
        orders o
    JOIN order_details od ON od.order_id = o.order_id
    GROUP BY o.date) AS subquery


-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name, ROUND(SUM(p.price * od.quantity), 0) AS revenue
FROM
    pizzzaaaaatype pt
        JOIN
    pizzas p ON pt.﻿pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3

---------------------------------------------------------------------------

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pt.category,
    (ROUND(SUM(p.price * od.quantity) / (SELECT 
                    ROUND(SUM(p.price * od.quantity), 2) AS revenue
                FROM
                    order_details od
                        JOIN
                    pizzas p ON p.pizza_id = od.pizza_id),
            4)) * 100 AS revenue
FROM
    pizzzaaaaatype pt
        JOIN
    pizzas p ON pt.﻿pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC
 

-- Analyze the cumulative revenue generated over time.
select date, round(sum(revenue) over(order by date),2) as cum_revenue
from
(select o.date, ROUND(SUM(p.price * od.quantity), 2) as revenue
from order_details od 
join pizzas p on od.pizza_id= p.pizza_id
join orders o on o.order_id= od.order_id
group by o.date) as sales


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category, name, revenue from
(select category, name, revenue, rank() over(partition by category order by revenue desc) as rn 
from
(select pt.name, pt.category, sum(p.price * od.quantity) as revenue
from pizzzaaaaatype pt
join pizzas p on pt.﻿pizza_type_id = p.pizza_type_id
join order_details od on od.pizza_id = p.pizza_id
group by pt.name, pt.category) as a) as b
where rn<=3

