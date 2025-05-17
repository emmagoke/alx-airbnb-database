-- Find the total number of bookings made by each user.
-- This query uses the COUNT function and GROUP BY clause to count bookings for each user.
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings_made
FROM
    users u
LEFT JOIN -- Use LEFT JOIN to include users who have made no bookings (total_bookings_made will be 0)
    booking b ON u.user_id = b.user_id
GROUP BY
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY
    total_bookings_made DESC, u.last_name, u.first_name;



-- Rank properties based on the total number of bookings they have received.
-- This query uses a window function (RANK) to assign a rank to each property
-- based on how many bookings it has. Properties with more bookings get a lower rank.
WITH PropertyBookingCounts AS (
    SELECT
        p.property_id,
        p.name AS property_name,
        COUNT(b.booking_id) AS number_of_bookings
    FROM
        properties p
    LEFT JOIN
        booking b ON p.property_id = b.property_id
    GROUP BY
        p.property_id, p.name
)
SELECT
    property_id,
    property_name,
    number_of_bookings,
    RANK() OVER (ORDER BY number_of_bookings DESC) AS property_rank_by_bookings,
    ROW_NUMBER() OVER (ORDER BY number_of_bookings DESC) AS property_row_number_by_bookings
FROM
    PropertyBookingCounts
ORDER BY
    property_rank_by_bookings, property_name;

