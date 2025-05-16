-- Common Sample Data (should work for both PostgreSQL and MySQL)

-- 1. Populate country Table
INSERT INTO country (country_id, name, created_at) VALUES
(1, 'United States', '2024-01-01 10:00:00'),
(2, 'Canada', '2024-01-01 10:05:00'),
(3, 'United Kingdom', '2024-01-01 10:10:00');

-- 2. Populate state Table
INSERT INTO state (state_id, country_id, name, created_at) VALUES
(1, 1, 'California', '2024-01-02 11:00:00'),
(2, 1, 'New York', '2024-01-02 11:05:00'),
(3, 2, 'Ontario', '2024-01-02 11:10:00'),
(4, 2, 'Quebec', '2024-01-02 11:15:00'),
(5, 3, 'England', '2024-01-02 11:20:00');

-- 3. Populate zipCodeDetails Table
-- For PostgreSQL, ensure gen_random_uuid() is available or use fixed UUIDs.
-- For MySQL, ensure user_id is CHAR(36) or use UUID() if inserting dynamically.
INSERT INTO zipCodeDetails (zip_code_id, zip_code, city, state_id, created_at) VALUES
('a1b2c3d4-e5f6-7890-1234-567890abcdef', '90210', 'Beverly Hills', 1, '2024-01-03 09:00:00'),
('b2c3d4e5-f6a7-8901-2345-67890abcdef0', '10001', 'New York City', 2, '2024-01-03 09:05:00'),
('c3d4e5f6-a7b8-9012-3456-7890abcdef01', 'M5H 2N2', 'Toronto', 3, '2024-01-03 09:10:00'),
('d4e5f6a7-b8c9-0123-4567-890abcdef012', 'H3A 0G4', 'Montreal', 4, '2024-01-03 09:15:00'),
('e5f6a7b8-c9d0-1234-5678-90abcdef0123', 'SW1A 1AA', 'London', 5, '2024-01-03 09:20:00');

-- 4. Populate Users Table
INSERT INTO Users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
('123e4567-e89b-12d3-a456-426614174000', 'John', 'Doe', 'john.doe@example.com', 'password_hash_john', '555-0100', 'host', '2024-01-10 08:30:00'),
('123e4567-e89b-12d3-a456-426614174001', 'Jane', 'Smith', 'jane.smith@example.com', 'password_hash_jane', '555-0101', 'guest', '2024-01-11 09:15:00'),
('123e4567-e89b-12d3-a456-426614174002', 'Alice', 'Brown', 'alice.brown@example.com', 'password_hash_alice', '555-0102', 'guest', '2024-01-12 10:00:00'),
('123e4567-e89b-12d3-a456-426614174003', 'Bob', 'Green', 'bob.green@example.com', 'password_hash_bob', '555-0103', 'host', '2024-01-13 11:45:00'),
('123e4567-e89b-12d3-a456-426614174004', 'Admin', 'User', 'admin@example.com', 'password_hash_admin', '555-0199', 'admin', '2024-01-09 12:00:00');

-- 5. Populate location Table
INSERT INTO location (location_id, street_address, address_line_2, country_id, state_id, zip_code_id, latitude, longitude, name, created_at, updated_at) VALUES
('loc_uuid_001', '123 Maple Drive', 'Apt 4B', 1, 1, 'a1b2c3d4-e5f6-7890-1234-567890abcdef', 34.0522, -118.2437, 'Sunny Apartment LA', '2024-01-15 14:00:00', '2024-01-15 14:00:00'),
('loc_uuid_002', '456 Oak Avenue', NULL, 1, 2, 'b2c3d4e5-f6a7-8901-2345-67890abcdef0', 40.7128, -74.0060, 'NYC Loft', '2024-01-16 15:00:00', '2024-01-16 15:00:00'),
('loc_uuid_003', '789 Pine Street', 'Suite 100', 2, 3, 'c3d4e5f6-a7b8-9012-3456-7890abcdef01', 43.6532, -79.3832, 'Toronto Condo', '2024-01-17 16:00:00', '2024-01-17 16:00:00'),
('loc_uuid_004', '101 Cherry Lane', NULL, 1, 1, 'a1b2c3d4-e5f6-7890-1234-567890abcdef', 34.0754, -118.3421, 'Beverly Hills Villa', '2024-01-18 10:00:00', '2024-01-18 10:00:00');


-- 6. Populate property Table
INSERT INTO property (property_id, host_id, name, description, location_id, price_per_night, created_at, updated_at) VALUES
('prop_uuid_001', '123e4567-e89b-12d3-a456-426614174000', 'Cozy Beach House', 'A beautiful house near the beach, perfect for a getaway.', 'loc_uuid_001', 150.00, '2024-02-01 10:00:00', '2024-02-01 10:00:00'),
('prop_uuid_002', '123e4567-e89b-12d3-a456-426614174000', 'Urban Studio Apartment', 'Modern studio in the heart of the city.', 'loc_uuid_002', 120.50, '2024-02-05 11:00:00', '2024-02-05 11:00:00'),
('prop_uuid_003', '123e4567-e89b-12d3-a456-426614174003', 'Downtown Lakeside Condo', 'Spacious condo with lake views.', 'loc_uuid_003', 220.75, '2024-02-10 12:00:00', '2024-02-10 12:00:00'),
('prop_uuid_004', '123e4567-e89b-12d3-a456-426614174003', 'Luxury Villa with Pool', 'Exclusive villa with private pool and amenities.', 'loc_uuid_004', 450.00, '2024-02-15 09:30:00', '2024-02-15 09:30:00');

-- 7. Populate booking Table
-- Current date is 2025-05-16
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
('book_uuid_001', 'prop_uuid_001', '123e4567-e89b-12d3-a456-426614174001', '2025-06-01', '2025-06-05', 600.00, 'confirmed', '2025-03-01 14:00:00'),
('book_uuid_002', 'prop_uuid_003', '123e4567-e89b-12d3-a456-426614174002', '2025-07-10', '2025-07-15', 1103.75, 'pending', '2025-04-10 15:30:00'),
('book_uuid_003', 'prop_uuid_004', '123e4567-e89b-12d3-a456-426614174001', '2025-08-01', '2025-08-03', 900.00, 'canceled', '2025-04-15 10:00:00'),
('book_uuid_004', 'prop_uuid_001', '123e4567-e89b-12d3-a456-426614174002', '2024-12-20', '2024-12-23', 450.00, 'confirmed', '2024-11-01 16:00:00'); -- Past booking

-- 8. Populate payment Table
INSERT INTO payment (payment_id, booking_id, amount, transaction_id, payment_date, payment_method) VALUES
('pay_uuid_001', 'book_uuid_001', 600.00, 'txn_123abc', '2025-03-02 10:00:00', 'credit_card'),
('pay_uuid_002', 'book_uuid_004', 450.00, 'txn_456def', '2024-11-02 11:30:00', 'paypal');
-- No payment for pending booking book_uuid_002
-- No payment for canceled booking book_uuid_003, or a refund record could exist in a more complex schema

-- 9. Populate review Table
INSERT INTO review (review_id, property_id, user_id, rating, comment, created_at) VALUES
('rev_uuid_001', 'prop_uuid_001', '123e4567-e89b-12d3-a456-426614174002', 5, 'Absolutely loved the place! Clean, great location, and the host was fantastic.', '2024-12-26 09:00:00'), -- Review for past booking
('rev_uuid_002', 'prop_uuid_002', '123e4567-e89b-12d3-a456-426614174001', 4, 'Great studio, very central. A bit noisy at night but expected for the location.', '2025-01-10 14:20:00');
-- Assuming Jane Smith had a previous unlisted booking for prop_uuid_002 or rules are relaxed for demo.
-- For strictness, only users with completed bookings for a property should review. This might require checking booking table history.

-- 10. Populate message Table
INSERT INTO message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
('msg_uuid_001', '123e4567-e89b-12d3-a456-426614174001', '123e4567-e89b-12d3-a456-426614174000', 'Hi John, looking forward to my stay at Cozy Beach House! Any recommendations for local restaurants?', '2025-02-25 10:00:00'),
('msg_uuid_002', '123e4567-e89b-12d3-a456-426614174000', '123e4567-e89b-12d3-a456-426614174001', 'Hi Jane, glad to hear it! For seafood, "The Salty Pelican" is a must-try. For Italian, "Luigi''s Place" is great. Both are a short walk away.', '2025-02-25 11:30:00'),
('msg_uuid_003', '123e4567-e89b-12d3-a456-426614174002', '123e4567-e89b-12d3-a456-426614174003', 'Hello Bob, I have a question about the amenities at the Downtown Lakeside Condo before I confirm my booking.', '2025-04-09 16:00:00');


-- MySQL: Sample Data with Dynamic UUIDs

-- 3. Populate zipCodeDetails Table
-- SET @zip1_id = UUID();
-- INSERT INTO zipCodeDetails (zip_code_id, zip_code, city, state_id, created_at) VALUES
-- (@zip1_id, '90210', 'Beverly Hills', 1, '2024-01-03 09:00:00');

-- SET @zip2_id = UUID();
-- INSERT INTO zipCodeDetails (zip_code_id, zip_code, city, state_id, created_at) VALUES
-- (@zip2_id, '10001', 'New York City', 2, '2024-01-03 09:05:00');


-- WITH inserted_zip1 AS (
--     INSERT INTO zipCodeDetails (zip_code_id, zip_code, city, state_id, created_at)
--     VALUES (gen_random_uuid(), '90210', 'Beverly Hills', 1, '2024-01-03 09:00:00')
--     RETURNING zip_code_id
-- ), inserted_zip2 AS (
--     INSERT INTO zipCodeDetails (zip_code_id, zip_code, city, state_id, created_at)
--     VALUES (gen_random_uuid(), '10001', 'New York City', 2, '2024-01-03 09:05:00')
--     RETURNING zip_code_id
-- ), inserted_zip3 AS (
--     INSERT INTO zipCodeDetails (zip_code_id, zip_code, city, state_id, created_at)
--     VALUES (gen_random_uuid(), 'M5H 2N2', 'Toronto', 3, '2024-01-03 09:10:00')
--     RETURNING zip_code_id
-- ), inserted_user1 AS (
--     INSERT INTO Users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
--     VALUES (gen_random_uuid(), 'John', 'Hostman', 'john.host@example.com', 'secure_hash_john', '555-0100', 'host', '2024-01-10 08:30:00')
--     RETURNING user_id
-- ), inserted_user2 AS (
--     INSERT INTO Users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
--     VALUES (gen_random_uuid(), 'Jane', 'Guestly', 'jane.guest@example.com', 'secure_hash_jane', '555-0101', 'guest', '2024-01-11 09:15:00')
--     RETURNING user_id
-- ), inserted_user3 AS (
--     INSERT INTO Users (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
--     VALUES (gen_random_uuid(), 'Alice', 'Admina', 'alice.admin@example.com', 'secure_hash_alice', '555-0102', 'admin', '2024-01-12 10:00:00')
--     RETURNING user_id
-- ), inserted_location1 AS (
--     INSERT INTO location (location_id, street_address, address_line_2, country_id, state_id, zip_code_id, latitude, longitude, name, created_at, updated_at)
--     SELECT gen_random_uuid(), '123 Maple Drive', 'Apt 4B', 1, 1, iz1.zip_code_id, 34.0522, -118.2437, 'Sunny Apartment LA', '2024-01-15 14:00:00', '2024-01-15 14:00:00'
--     FROM inserted_zip1 iz1
--     RETURNING location_id
-- ), inserted_location2 AS (
--     INSERT INTO location (location_id, street_address, country_id, state_id, zip_code_id, latitude, longitude, name, created_at, updated_at)
--     SELECT gen_random_uuid(), '789 Pine Street', 2, 3, iz3.zip_code_id, 43.6532, -79.3832, 'Toronto Condo', '2024-01-17 16:00:00', '2024-01-17 16:00:00'
--     FROM inserted_zip3 iz3
--     RETURNING location_id
-- ), inserted_property1 AS (
--     INSERT INTO property (property_id, host_id, name, description, location_id, price_per_night, created_at, updated_at)
--     SELECT gen_random_uuid(), iu1.user_id, 'Cozy Beach House', 'A beautiful house near the beach.', il1.location_id, 150.00, '2024-02-01 10:00:00', '2024-02-01 10:00:00'
--     FROM inserted_user1 iu1, inserted_location1 il1
--     RETURNING property_id
-- ), inserted_property2 AS (
--     INSERT INTO property (property_id, host_id, name, description, location_id, price_per_night, created_at, updated_at)
--     SELECT gen_random_uuid(), iu1.user_id, 'Downtown Lakeside Condo', 'Spacious condo with lake views.', il2.location_id, 220.75, '2024-02-10 12:00:00', '2024-02-10 12:00:00'
--     FROM inserted_user1 iu1, inserted_location2 il2
--     RETURNING property_id
-- ), inserted_booking1 AS (
--     INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
--     SELECT gen_random_uuid(), ip1.property_id, iu2.user_id, '2025-07-01', '2025-07-05', 600.00, 'confirmed', '2025-03-01 14:00:00'
--     FROM inserted_property1 ip1, inserted_user2 iu2
--     RETURNING booking_id, property_id, user_id -- Return user_id and property_id for review
-- ), inserted_payment1 AS (
--     INSERT INTO payment (payment_id, booking_id, amount, transaction_id, payment_date, payment_method)
--     SELECT gen_random_uuid(), ib1.booking_id, 600.00, 'txn_pg_dynamic_123', '2025-03-02 10:00:00', 'credit_card'
--     FROM inserted_booking1 ib1
--     RETURNING payment_id
-- ), inserted_review1 AS (
--     INSERT INTO review (review_id, property_id, user_id, rating, comment, created_at)
--     SELECT gen_random_uuid(), ib1.property_id, ib1.user_id, 5, 'Fantastic stay, very dynamic UUIDs!', '2025-07-06 09:00:00'
--     FROM inserted_booking1 ib1 -- Assuming review is posted after stay
--     RETURNING review_id
-- )
-- -- Insert a message
-- INSERT INTO message (message_id, sender_id, recipient_id, message_body, sent_at)
-- SELECT gen_random_uuid(), iu2.user_id, iu1.user_id, 'Hi John, loved the dynamic booking!', '2025-07-06 10:00:00'
-- FROM inserted_user2 iu2, inserted_user1 iu1;

-- SELECT 'PostgreSQL sample data with dynamic UUIDs inserted.' AS status;
