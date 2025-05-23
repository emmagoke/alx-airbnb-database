-- Write a query using an INNER JOIN to retrieve all bookings and
-- the respective users who made those bookings.
SELECT * FROM booking
INNER JOIN users
ON booking.user_id = users.user_id

-- Write a query using aLEFT JOIN to retrieve all properties and their reviews,
-- including properties that have no reviews.
SELECT * FROM properties
LEFT JOIN review
ON properties.property_id = review.property_id
ORDER BY properties.property_id, review.review_id

-- Write a query using a FULL OUTER JOIN to retrieve all users and
-- all bookings, even if the user has no booking or a booking is not linked to a user.
SELECT * FROM users
FULL OUTER JOIN booking
ON users.user_id = booking.user_id
