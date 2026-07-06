-- Optimizes:
--   SELECT org_id, status, COUNT(*), SUM(amount)
--   FROM hotel_bookings
--   WHERE city = 'delhi'
--     AND created_at >= NOW() - INTERVAL '30 days'
--   GROUP BY org_id, status;
--
-- The WHERE clause filters on (city, created_at), so a composite index on
-- those two columns lets Postgres use an index range scan instead of a full
-- table scan. org_id, status, and amount are included as non-key columns so
-- the query can be satisfied entirely from the index (index-only scan)
-- without a separate heap fetch for every matching row.
CREATE INDEX IF NOT EXISTS idx_hotel_bookings_city_created_at
  ON hotel_bookings (city, created_at)
  INCLUDE (org_id, status, amount);
