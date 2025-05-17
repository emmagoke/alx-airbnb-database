-- partitioning.sql
-- Implements range partitioning on the Booking table based on the start_date column.

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'booking_status') THEN
        CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');
    END IF;
END$$;


CREATE TABLE booking (
    booking_id UUID DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    num_guests INTEGER NOT NULL,
    status booking_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dates CHECK (end_date >= start_date),
    CONSTRAINT chk_num_guests CHECK (num_guests > 0),
    
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- Partition for bookings starting in 2023
CREATE TABLE booking_y2023 PARTITION OF booking
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for bookings starting in 2024
CREATE TABLE booking_y2024 PARTITION OF booking
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for bookings starting in 2025
CREATE TABLE booking_y2025 PARTITION OF booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');


-- Indexes on foreign key columns are crucial.
CREATE INDEX IF NOT EXISTS idx_booking_partitioned_user_id ON booking (user_id);
CREATE INDEX IF NOT EXISTS idx_booking_partitioned_property_id ON booking (property_id);
CREATE INDEX IF NOT EXISTS idx_booking_partitioned_status ON booking (status);

CREATE INDEX IF NOT EXISTS idx_booking_partitioned_start_date ON booking (start_date);
CREATE INDEX IF NOT EXISTS idx_booking_partitioned_created_at ON booking (created_at DESC);


ALTER TABLE booking
    ADD CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    ADD CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES property(property_id);


CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_booking_updated_at_partitioned
BEFORE UPDATE ON booking
FOR EACH ROW
EXECUTE FUNCTION trigger_set_timestamp();

-- Performance Test Query
EXPLAIN ANALYZE
SELECT * FROM bookings 
WHERE start_date BETWEEN '2025-01-01' AND '2025-05-17';
