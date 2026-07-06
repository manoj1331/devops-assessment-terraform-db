# DevOps Assessment: Terraform + Database Reliability

This repository contains a Terraform design for an AWS hotel-booking
platform (Internet -> ALB -> ECS/Fargate -> RDS) plus a fully runnable
local database environment for demonstrating backup, restore, and query
optimization work. Actual AWS deployment is not required; the Terraform
code is meant to be validated with `fmt`, `init`, `validate`, and
`plan` only.

## Repository layout

```
infra/
  modules/
    network/   VPC, subnets, routing, security groups
    ecs/       ALB, ECS cluster/service/task definition
    rds/       RDS subnet group and instance
  envs/
    dev/       dev-sized environment (main.tf, variables.tf, dev.tfvars, backend.tf)
    prod/      prod-sized environment (main.tf, variables.tf, prod.tfvars, backend.tf)
.github/workflows/terraform.yml   optional CI plan workflow
docker-compose.yml                local Postgres database
db/init/                          schema, seed data, and index migrations
scripts/backup.sh                 timestamped pg_dump backup
scripts/restore.sh                restore a backup into a fresh database
```

## Part 1-3: Terraform infrastructure

The `network` module creates a VPC with public and private subnets, an
internet gateway, a NAT gateway, and security groups so that the RDS
instance is only reachable from the ECS security group (never from the
public internet). The `ecs` module creates the ALB, listener, target
group, ECS cluster, task definition, and service running on Fargate in
the private subnets. The `rds` module creates the subnet group and the
database instance itself, with backup retention, deletion protection,
and multi-AZ all driven by variables so dev and prod can differ.

To validate the Terraform code locally for either environment:

```bash
cd infra/envs/dev   # or infra/envs/prod
terraform fmt -check -recursive ../../
terraform init -backend=false
terraform validate
terraform plan -var-file=dev.tfvars -refresh=false
```

`backend.tf` in each environment points at placeholder S3/DynamoDB
values; replace them with your own state backend or delete the block to
use local state. The optional `.github/workflows/terraform.yml` runs
the same fmt/init/validate/plan sequence for both environments on every
pull request that touches `infra/**`, uploads the plan as a build
artifact, and posts it as a PR comment.

## Part 4-5: Local database, seed data, and indexing

Start the local Postgres database with Docker Compose:

```bash
docker compose up -d
```

On first start, Postgres automatically runs the SQL files in
`db/init/` in order: `001_schema.sql` creates the `hotel_bookings` and
`booking_events` tables, `002_seed.sql` inserts 120 hotel bookings
across three organizations, five cities, and four booking statuses
(plus events for roughly 60% of bookings), and `003_indexes.sql` adds
the index described below.

The assessment's target query is:

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

`003_indexes.sql` adds a composite index on `(city, created_at)` with
`org_id`, `status`, and `amount` included as non-key columns. The
leading columns match the `WHERE` clause exactly so Postgres can use an
index range scan instead of scanning the whole table, and the included
columns let the query be satisfied entirely from the index without
extra heap lookups.

To verify: connect with
`docker exec -it hotel_booking_db psql -U app_user -d hotel_booking`
and run `EXPLAIN ANALYZE` on the query above; the plan should show an
`Index Only Scan` on `idx_hotel_bookings_city_created_at`.

## Part 6: Backup and restore

```bash
./scripts/backup.sh
```

Creates a timestamped `pg_dump` under `backups/`. To verify a restore
works from that dump:

```bash
./scripts/restore.sh backups/hotel_booking_<timestamp>.sql
```

This creates a separate `hotel_booking_restore_test` database inside
the same container and loads the dump into it, leaving the original
database untouched. Verify the restore succeeded by comparing row
counts between the two databases:

```bash
docker exec -it hotel_booking_db psql -U app_user -d hotel_booking \
  -c "SELECT COUNT(*) FROM hotel_bookings;"
docker exec -it hotel_booking_db psql -U app_user -d hotel_booking_restore_test \
  -c "SELECT COUNT(*) FROM hotel_bookings;"
```

Both counts should match.

## Submission checklist

- [x] Terraform infrastructure code (`infra/modules`)
- [x] Dev and prod Terraform environment examples (`infra/envs`)
- [x] Docker Compose database setup (`docker-compose.yml`)
- [x] SQL migration files (`db/init/001_schema.sql`, `003_indexes.sql`)
- [x] Seed data script (`db/init/002_seed.sql`)
- [x] Database backup script (`scripts/backup.sh`)
- [x] Database restore script (`scripts/restore.sh`)
- [x] README with setup and verification steps (this file)
