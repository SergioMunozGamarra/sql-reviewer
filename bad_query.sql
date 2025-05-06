SELECT DISTINCT
    u.id,
    u.name,
    (SELECT COUNT(*) 
     FROM logs l 
     WHERE l.user_id = u.id 
       AND l.action LIKE '%login%') AS login_count,
    GROUP_CONCAT(o.product_name ORDER BY RAND()) AS random_products
FROM users u
    JOIN orders o ON u.id = o.user_id
    CROSS JOIN settings s
    LEFT JOIN profiles p ON p.user_id = u.id AND p.active = 1
WHERE
    (u.status = 'active' OR u.status = 'pending' OR u.status = 'banned')
    AND LOWER(u.email) LIKE '%@example.com%'
    AND EXTRACT(YEAR FROM u.created_at) BETWEEN 2000 AND 2025
GROUP BY u.id
HAVING
    login_count > 0
ORDER BY RAND(), u.name DESC;
