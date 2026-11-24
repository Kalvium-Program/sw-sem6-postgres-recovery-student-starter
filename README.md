# Campus Events: backup and restore practice

A small PostgreSQL database for campus event registrations. You will back it up, lose a record by accident, and get it back.

## Start

```bash
cp .env.example .env
docker compose up -d --wait
docker compose exec -T db psql -U app -d events -c "TABLE registrations;"
```

You should see three registrations. The database files live in the `events_data` volume.

## Files

| File | What it is |
| --- | --- |
| `compose.yaml` | One PostgreSQL 16 service called `db` with a named volume |
| `seed/01-registrations.sql` | Creates the table and three rows the first time the volume is empty |
| `scripts/accident.sql` | A teammate's "cleanup" script that deletes a real registration |
| `backups/` | Put your backup files here. Git ignores them. |

## Stop

```bash
docker compose down
```

This keeps the volume and your data. Do not add `-v`.
