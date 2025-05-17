-- Write a query to find all properties where the average
-- rating is greater than 4.0 using a subquery.
WITH propertyAvgRating AS (
   select property_id, AVG(rating) AS average_rating FROM review
   GROUP BY property_id
)
SELECT * FROm property
INNER JOIN propertyAvgRating
ON property.property_id = propertyAvgRating.property_id
WHERE propertyAvgRating.average_rating > 4.0

-- Write a correlated subquery to find users who have made more than 3 bookings.
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (SELECT COUNT(*) FROM booking b WHERE b.user_id = u.user_id) AS total_bookings
FROM
    users u
WHERE
    (SELECT COUNT(*) FROM booking b WHERE b.user_id = u.user_id) > 3
ORDER BY
    u.last_name, u.first_name;
