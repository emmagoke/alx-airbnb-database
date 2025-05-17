# Query Performance Analysis and Refactoring

The query provided in performance.sql aims to retrieve a comprehensive set of details for all bookings, including information about the user who made the booking, the property booked, and any associated payment. It also includes property location details by joining location, zipCodeDetails, state, and country tables.

## Initial Query (from `performance.sql`)

```text
SELECT
    -- Booking details
    b.booking_id, b.start_date, b.end_date, b.total_price AS booking_total_price, b.num_guests AS booking_num_guests, b.status AS booking_status, b.created_at AS booking_created_at, b.updated_at AS booking_updated_at,
    -- User details
    u.user_id, u.first_name AS user_first_name, u.last_name AS user_last_name, u.email AS user_email, u.role AS user_role,
    -- Property details
    p.property_id, p.name AS property_name, p.description AS property_description, p.price_per_night AS property_price_per_night, p.max_guests AS property_max_guests, p.num_bedrooms AS property_num_bedrooms, p.num_bathrooms AS property_num_bathrooms,
    -- Property Location details
    prop_loc.street_address AS property_street_address, prop_loc.city AS property_city, s.name AS property_state, c.name AS property_country,
    -- Payment details
    pay.payment_id, pay.amount AS payment_amount, pay.payment_date, pay.payment_method, pay.transaction_id, pay.status AS payment_status
FROM
    booking b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payment pay ON b.booking_id = pay.booking_id
LEFT JOIN location prop_loc ON p.location_id = prop_loc.location_id
LEFT JOIN zipCodeDetails zcd ON prop_loc.zip_code_id = zcd.zip_code_id
LEFT JOIN state s ON zcd.state_id = s.state_id
LEFT JOIN country c ON s.country_id = c.country_id
ORDER BY b.created_at DESC;

```

## Analyzing Performance with `EXPLAIN` and `EXPLAIN ANALYZE`

```text

EXPLAIN ANALYZE
SELECT
    -- Booking details
    b.booking_id, b.start_date, b.end_date, b.total_price AS booking_total_price, b.num_guests AS booking_num_guests, b.status AS booking_status, b.created_at AS booking_created_at, b.updated_at AS booking_updated_at,
    -- User details
    u.user_id, u.first_name AS user_first_name, u.last_name AS user_last_name, u.email AS user_email, u.role AS user_role,
    -- Property details
    p.property_id, p.name AS property_name, p.description AS property_description, p.price_per_night AS property_price_per_night, p.max_guests AS property_max_guests, p.num_bedrooms AS property_num_bedrooms, p.num_bathrooms AS property_num_bathrooms,
    -- Property Location details
    prop_loc.street_address AS property_street_address, prop_loc.city AS property_city, s.name AS property_state, c.name AS property_country,
    -- Payment details
    pay.payment_id, pay.amount AS payment_amount, pay.payment_date, pay.payment_method, pay.transaction_id, pay.status AS payment_status
FROM
    booking b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN property p ON b.property_id = p.property_id
LEFT JOIN payment pay ON b.booking_id = pay.booking_id
LEFT JOIN location prop_loc ON p.location_id = prop_loc.location_id
LEFT JOIN zipCodeDetails zcd ON prop_loc.zip_code_id = zcd.zip_code_id
LEFT JOIN state s ON zcd.state_id = s.state_id
LEFT JOIN country c ON s.country_id = c.country_id
ORDER BY b.created_at DESC;
```

```text
EXPLAIN ANALYZE
SELECT
    -- Booking details
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total_price,
    b.num_guests AS booking_num_guests,
    b.status AS booking_status,
    b.created_at AS booking_created_at,
    b.updated_at AS booking_updated_at,

    -- User details (who made the booking)
    u.user_id,
    u.first_name AS user_first_name,
    u.last_name AS user_last_name,
    u.email AS user_email,
    u.role AS user_role,

    -- Property details
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    p.price_per_night AS property_price_per_night,
    p.max_guests AS property_max_guests,
    p.num_bedrooms AS property_num_bedrooms,
    p.num_bathrooms AS property_num_bathrooms,
    prop_loc.street_address AS property_street_address, -- Assuming 'location' table is joined for property address
    --- zcd.city AS property_city,                     -- Assuming 'location' and 'zipCodeDetails' provide city
    s.name AS property_state,                           -- Assuming 'state' table provides state name
    c.name AS property_country,                         -- Assuming 'country' table provides country name


    -- Payment details (if any)
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date,
    pay.payment_method,
    pay.transaction_id,
    pay.status AS payment_status
FROM
    booking b
INNER JOIN
    Users u ON b.user_id = u.user_id
INNER JOIN
    properties p ON b.property_id = p.property_id
LEFT JOIN -- A booking might not have a payment record yet (e.g., pending or canceled without payment)
    payment pay ON b.booking_id = pay.booking_id
LEFT JOIN -- To get property address details
    location prop_loc ON p.location_id = prop_loc.location_id
LEFT JOIN -- To get zip code, city, and state details related to property location
    zipCodeDetails zcd ON prop_loc.zip_code_id = zcd.zip_code_id
LEFT JOIN -- To get state name
    state s ON zcd.state_id = s.state_id
LEFT JOIN -- To get country name
    country c ON s.country_id = c.country_id
ORDER BY
    b.created_at DESC; -- Example: order by when the booking was created
```
