-- Write a query using an INNER JOIN to retrieve all bookings and
-- the respective users who made those bookings.
select * from booking
INNER JOIN users
on booking.user_id = users.user_id

-- Write a query using aLEFT JOIN to retrieve all properties and their reviews,
-- including properties that have no reviews.
SELECT * from property
left join review
on property.property_id = review.property_id

-- Write a query using a FULL OUTER JOIN to retrieve all users and
-- all bookings, even if the user has no booking or a booking is not linked to a user.
SELECT * from users
full OUTER join booking
on users.user_id = booking.user_id
