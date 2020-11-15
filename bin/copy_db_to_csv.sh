#!/usr/bin/env bash

SCHEMA="public"
DB="recipe_manager"

psql -Atc "select tablename from pg_tables where schemaname='$SCHEMA'" $DB |\
  while read TBL; do
    psql -c "COPY $SCHEMA.$TBL TO STDOUT WITH CSV" $DB > $TBL.csv
  done
