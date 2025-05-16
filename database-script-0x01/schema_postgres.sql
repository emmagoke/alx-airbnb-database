-- Create ENUM types for PostgreSQL
CREATE TYPE users_role AS ENUM ('guest', 'host', 'admin');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');
CREATE TYPE payment_method AS ENUM ('credit_card', 'paypal', 'stripe');

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Table: Users
CREATE TABLE Users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50),
    role users_role NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- Index on user_id is automatically created by PRIMARY KEY constraint

-- Table: country
CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: state
CREATE TABLE state (
    state_id SERIAL PRIMARY KEY,
    country_id INTEGER NOT NULL REFERENCES country(country_id),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (country_id, name)
);

-- Table: zipCodeDetails
CREATE TABLE zipCodeDetails (
    zip_code_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    zip_code VARCHAR(20) NOT NULL UNIQUE,
    city VARCHAR(255) NOT NULL,
    state_id INTEGER NOT NULL REFERENCES state(state_id),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_zipcodedetails_city_state_id ON zipCodeDetails (city, state_id);
-- Index on zip_code_id is automatically created by PRIMARY KEY constraint
-- Index on zip_code is created by UNIQUE constraint

-- Table: location
CREATE TABLE location (
    location_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    street_address VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255),
    country_id INTEGER REFERENCES country(country_id),
    state_id INTEGER REFERENCES state(state_id),
    zip_code_id UUID NOT NULL REFERENCES zipCodeDetails(zip_code_id),
    latitude DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_location_zip_code_id ON location (zip_code_id);
-- Index on location_id is automatically created by PRIMARY KEY constraint

-- Trigger for updated_at on location table
CREATE TRIGGER set_location_updated_at
BEFORE UPDATE ON location
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Table: property
CREATE TABLE property (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID NOT NULL REFERENCES Users(user_id),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location_id UUID NOT NULL REFERENCES location(location_id),
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index on property_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_property_host_id ON property (host_id);
CREATE INDEX idx_property_location_id ON property (location_id);

-- Trigger for updated_at on property table
CREATE TRIGGER set_property_updated_at
BEFORE UPDATE ON property
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Table: booking
CREATE TABLE booking (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES property(property_id),
    user_id UUID NOT NULL REFERENCES Users(user_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status booking_status NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
);

-- Index on booking_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_booking_property_id ON booking (property_id);
CREATE INDEX idx_booking_user_id ON booking (user_id);
CREATE INDEX idx_booking_status ON booking (status);

-- Table: payment
CREATE TABLE payment (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES booking(booking_id),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_id VARCHAR(255) UNIQUE,
    payment_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    payment_method payment_method NOT NULL
);

-- Index on payment_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_payment_booking_id ON payment (booking_id);
-- Index on transaction_id is created by UNIQUE constraint

-- Table: review
CREATE TABLE review (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES property(property_id),
    user_id UUID NOT NULL REFERENCES Users(user_id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index on review_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_review_property_id ON review (property_id);
CREATE INDEX idx_review_user_id ON review (user_id);
CREATE INDEX idx_review_rating ON review (rating);

-- Table: message
CREATE TABLE message (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES Users(user_id),
    recipient_id UUID NOT NULL REFERENCES Users(user_id),
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_sender_recipient CHECK (sender_id <> recipient_id)
);

-- Index on message_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_message_sender_id ON message (sender_id);
CREATE INDEX idx_message_recipient_id ON message (recipient_id);
