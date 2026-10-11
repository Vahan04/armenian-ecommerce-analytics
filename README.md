# Armenian E-commerce Analytics

A PostgreSQL portfolio project for analyzing an Armenian online shop.
The sample business sells books, electronics, home goods, and local products
in AMD.

## What this project demonstrates

- Relational database design and foreign keys
- PostgreSQL constraints, indexes, views, and window functions
- Revenue, customer, inventory, delivery, and payment analytics
- Armenian customer locations and AMD currency
- Reproducible seed data and useful business reports

## Database structure

```text
customers ──< orders ──< order_items >── products >── categories
                         │
                         ├── payments
                         └── deliveries
```

## Run with PostgreSQL

Create a database, then run the schema and seed files:

```bash
createdb armenian_shop
psql -d armenian_shop -f sql/01_schema.sql
psql -d armenian_shop -f sql/02_seed.sql
```

Run all analytics:

```bash
psql -d armenian_shop -f sql/03_views.sql
psql -d armenian_shop -f queries/business_report.sql
```

Or use Docker Compose:

```bash
docker compose up -d
docker exec -i armenian-ecommerce-db \
  psql -U shop_user -d armenian_shop < sql/01_schema.sql
docker exec -i armenian-ecommerce-db \
  psql -U shop_user -d armenian_shop < sql/02_seed.sql
docker exec -i armenian-ecommerce-db \
  psql -U shop_user -d armenian_shop < sql/03_views.sql
docker exec -i armenian-ecommerce-db \
  psql -U shop_user -d armenian_shop < queries/business_report.sql
```

## Reports

- Monthly revenue and order count
- Best-selling products
- Customer lifetime value
- Repeat customers
- Low-stock products
- Revenue by Armenian city
- Payment and delivery status
- Running monthly revenue using a window function

## Project files

```text
armenian-ecommerce-analytics/
├── README.md
├── docker-compose.yml
├── sql/
│   ├── 01_schema.sql
│   ├── 02_seed.sql
│   └── 03_views.sql
├── queries/
│   └── business_report.sql
└── tests/
    └── data_quality.sql
```
