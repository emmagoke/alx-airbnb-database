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