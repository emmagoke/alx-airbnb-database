-- Create Index
CREATE INDEX IF NOT EXISTS idx_property_name ON properties (name);
CREATE INDEX IF NOT EXISTS idx_property_price_per_night ON properties (price_per_night);