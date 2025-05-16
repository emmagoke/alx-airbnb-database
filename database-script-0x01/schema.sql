-- MySQL
-- consider BINARY(16) with UUID_TO_BIN and BIN_TO_UUID
-- functions in MySQL 8.0+ for better performance and storage.

-- Table: Users
CREATE TABLE Users (
    user_id CHAR(36) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50),
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Index on user_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_users_email ON Users (email); -- Already covered by UNIQUE but good for explicit queries

-- Table: country
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: state
CREATE TABLE state (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    UNIQUE KEY idx_state_country_name (country_id, name)
);

-- Table: zipCodeDetails
CREATE TABLE zipCodeDetails (
    zip_code_id CHAR(36) PRIMARY KEY,
    zip_code VARCHAR(20) NOT NULL UNIQUE,
    city VARCHAR(255) NOT NULL,
    state_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (state_id) REFERENCES state(state_id)
);

-- Index on zip_code_id is automatically created by PRIMARY KEY constraint
-- Index on zip_code is created by UNIQUE constraint
CREATE INDEX idx_zipcodedetails_city_state_id ON zipCodeDetails (city, state_id);

-- Table: location
CREATE TABLE location (
    location_id CHAR(36) PRIMARY KEY,
    street_address VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255),
    country_id INT,
    state_id INT,
    zip_code_id CHAR(36) NOT NULL,
    latitude DECIMAL(10, 6),
    longitude DECIMAL(10, 6),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    FOREIGN KEY (state_id) REFERENCES state(state_id),
    FOREIGN KEY (zip_code_id) REFERENCES zipCodeDetails(zip_code_id)
);

-- Index on location_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_location_zip_code_id ON location (zip_code_id);
CREATE INDEX idx_location_country_id ON location (country_id);
CREATE INDEX idx_location_state_id ON location (state_id);

-- Table: property
CREATE TABLE property (
    property_id CHAR(36) PRIMARY KEY,
    host_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location_id CHAR(36) NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES Users(user_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

-- Index on property_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_property_host_id ON property (host_id);
CREATE INDEX idx_property_location_id ON property (location_id);

-- Table: booking
CREATE TABLE booking (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES property(property_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
);

-- Index on booking_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_booking_property_id ON booking (property_id);
CREATE INDEX idx_booking_user_id ON booking (user_id);
CREATE INDEX idx_booking_status ON booking (status);

-- Table: payment
CREATE TABLE payment (
    payment_id CHAR(36) PRIMARY KEY,
    booking_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_id VARCHAR(255) UNIQUE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

-- Index on payment_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_payment_booking_id ON payment (booking_id);
-- Index on transaction_id is created by UNIQUE constraint

-- Table: review
CREATE TABLE review (
    review_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    rating INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES property(property_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT chk_rating CHECK (rating >= 1 AND rating <= 5)
);

-- Index on review_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_review_property_id ON review (property_id);
CREATE INDEX idx_review_user_id ON review (user_id);
CREATE INDEX idx_review_rating ON review (rating);

-- Table: message
CREATE TABLE message (
    message_id CHAR(36) PRIMARY KEY,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (recipient_id) REFERENCES Users(user_id),
    CONSTRAINT chk_sender_recipient CHECK (sender_id <> recipient_id)
);

-- Index on message_id is automatically created by PRIMARY KEY constraint
CREATE INDEX idx_message_sender_id ON message (sender_id);
CREATE INDEX idx_message_recipient_id ON message (recipient_id);
