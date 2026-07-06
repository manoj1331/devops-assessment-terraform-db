-- Seeds 120 hotel bookings spanning 3 organizations, 5 cities, and 4
-- booking statuses, plus booking_events for roughly 60% of bookings.
INSERT INTO hotel_bookings (org_id, hotel_id, city, checkin_date, checkout_date, amount, status, created_at)
SELECT
  (ARRAY[
    'a1111111-1111-1111-1111-111111111111',
    'a2222222-2222-2222-2222-222222222222',
    'a3333333-3333-3333-3333-333333333333'
  ]::uuid[])[1 + floor(random() * 3)::int] AS org_id,
  'hotel-' || (1 + floor(random() * 20)::int) AS hotel_id,
  (ARRAY['delhi', 'mumbai', 'bengaluru', 'chennai', 'pune'])[1 + floor(random() * 5)::int] AS city,
  gen.checkin_date,
  gen.checkin_date + (1 + floor(random() * 5)::int) AS checkout_date,
  round((random() * 20000 + 1000)::numeric, 2) AS amount,
  (ARRAY['confirmed', 'cancelled', 'completed', 'pending'])[1 + floor(random() * 4)::int] AS status,
  now() - (floor(random() * 60) || ' days')::interval AS created_at
FROM generate_series(1, 120) AS s
CROSS JOIN LATERAL (
  SELECT (CURRENT_DATE - (floor(random() * 90))::int) AS checkin_date
) AS gen;

-- Add one or more events for roughly 60% of the bookings just inserted.
INSERT INTO booking_events (booking_id, event_type, payload, created_at)
SELECT
  id,
  (ARRAY['created', 'payment_received', 'checked_in', 'checked_out', 'cancelled'])[1 + floor(random() * 5)::int],
  jsonb_build_object('source', 'seed-script', 'note', 'auto-generated event'),
  created_at + (floor(random() * 3) || ' hours')::interval
FROM hotel_bookings
WHERE random() < 0.6;
