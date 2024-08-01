SELECT *
FROM users
LIMIT 20;

SELECT email, birthday
FROM users
WHERE birthday BETWEEN '1980-01-01' AND '1989-12-31'
ORDER BY birthday;

SELECT email, created_at
FROM users
WHERE created_at < '2017-05-01'
ORDER BY created_at;

SELECT email
FROM users
WHERE test = 'bears';

SELECT email
FROM users
WHERE campaign LIKE 'BBB%';

SELECT email
FROM users
WHERE campaign LIKE '%-2';

-- Define segments based on account creation date and total spending
WITH customer_segments AS (
    SELECT 
        email,
        created_at,
        last_purchase_date,
        total_spent,
        CASE
            WHEN created_at >= '2020-01-01' THEN 'New'
            WHEN created_at BETWEEN '2017-01-01' AND '2019-12-31' THEN 'Established'
            ELSE 'Old'
        END AS account_segment,
        CASE
            WHEN total_spent >= 1000 THEN 'High Value'
            WHEN total_spent BETWEEN 500 AND 999 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS spending_segment
    FROM users
    LEFT JOIN purchases ON users.email = purchases.user_email
    GROUP BY email, created_at, last_purchase_date, total_spent
)

-- Retrieve customers with additional filtering
SELECT 
    email,
    created_at,
    last_purchase_date,
    total_spent,
    account_segment,
    spending_segment
FROM customer_segments
WHERE last_purchase_date >= '2023-01-01'
AND spending_segment = 'High Value'
ORDER BY account_segment, total_spent DESC;
