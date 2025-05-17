# Checking Index Performance on SQL Queries

## Query

```sql
-- Before Indexing
EXPLAIN ANALYZE
SELECT
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    par.average_rating
FROM
    properties p
INNER JOIN
    (SELECT property_id, AVG(rating) AS average_rating FROM review GROUP BY property_id) par
    ON p.property_id = par.property_id
WHERE
    par.average_rating > 4.0 AND p.name LIKE 'Cozy%' -- Added a filter on p.name
ORDER BY
    par.average_rating DESC, p.property_id;

-- Create Index
CREATE INDEX IF NOT EXISTS idx_property_name ON properties (name);
CREATE INDEX IF NOT EXISTS idx_property_price_per_night ON properties (price_per_night);

-- After Indexing
EXPLAIN ANALYZE
SELECT
    p.property_id,
    p.name AS property_name,
    p.description AS property_description,
    par.average_rating
FROM
    properties p
INNER JOIN
    (SELECT property_id, AVG(rating) AS average_rating FROM review GROUP BY property_id) par
    ON p.property_id = par.property_id
WHERE
    par.average_rating > 4.0 AND p.name LIKE 'Cozy%' -- Added a filter on p.name
ORDER BY
    par.average_rating DESC, p.property_id;

```

## Performance Analysis

**Without Index**

![without index](before_index.jpg)

**With Index**

![with index](after_index.jpg)
