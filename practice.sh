#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
project=lu212-student
c() { docker compose -p "$project" "$@"; }
query() { c exec -T source psql -U practice -d records -v ON_ERROR_STOP=1 -c "$1"; }
case "${1:-help}" in
 setup)
  if [ -e secrets/password.txt ]; then echo 'STOP: existing credential source; inspect before reuse'; exit 1; fi
  mkdir -p secrets backups; chmod 700 secrets backups
  printf '%s\n' 'DUMMY_ONLY_LU212' > secrets/password.txt; chmod 600 secrets/password.txt
  ;;
 start) c config --quiet; c up -d --wait source ;;
 read) query 'TABLE entries ORDER BY id;' ;;
 add) query "INSERT INTO entries VALUES (2, 'event-registration-owned-record');" ;;
 identity) c ps -q source ;;
 replace) c up -d --wait --force-recreate --no-deps source ;;
 backup)
  mkdir -p backups
  if [ -e backups/records.dump ] || [ -e backups/records.partial ]; then echo 'STOP: preserve existing backup'; exit 1; fi
  if c exec -T source pg_dump -U practice -d records -Fc > backups/records.partial; then
   test -s backups/records.partial
   mv backups/records.partial backups/records.dump
   chmod 600 backups/records.dump
   echo 'PASS: dump exited0 and nonempty archive saved'
  else echo 'FAIL: dump failed; partial file is NOT a backup'; exit 1; fi
  ;;
 target)
  c --profile recovery up -d --wait restore
  c exec -T restore psql -U practice -d recovered -v ON_ERROR_STOP=1 -c "SELECT current_database(); SELECT count(*) AS public_tables FROM pg_tables WHERE schemaname='public';"
  c ps -q restore
  ;;
 restore)
  test "${2:-}" = 'MENTOR_CONFIRMED_DISPOSABLE' || { echo 'STOP: mentor confirmation required'; exit 1; }
  test -s backups/records.dump
  tables=$(c exec -T restore psql -U practice -d recovered -Atqc "SELECT count(*) FROM pg_tables WHERE schemaname='public'")
  test "$tables" = 0 || { echo 'STOP: target is not empty'; exit 1; }
  c exec -T restore pg_restore -U practice -d recovered --exit-on-error --single-transaction < backups/records.dump
  echo 'PASS: restore exited0'
  ;;
 verify)
  c exec -T restore psql -U practice -d recovered -v ON_ERROR_STOP=1 -c 'TABLE entries ORDER BY id;'
  query 'TABLE entries ORDER BY id;'
  ;;
 down) c --profile recovery down ;;
 *) echo 'setup start read add identity replace backup target restore verify down';;
esac
