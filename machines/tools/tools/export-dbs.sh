#!/bin/bash

# MySQL Exporter Tool
# > Per-table DB export tool
# 
# Package: net.ikigai.ops.mysql.tools
# Author: Narcis M PAP, Aug 2018

OPTFILE="$(mktemp -q --tmpdir "msyqlsetupi.XXXXXX")"
ROOT_PWD=`cat /run/secrets/db_root`

trap 'rm -f "$OPTFILE"' EXIT
chmod 0600 "$OPTFILE"

cat >"$OPTFILE" <<EOF
[client]
user=root
password="${ROOT_PWD}"
port="${MYSQL_PORT}"
host="db"
EOF

MYSQL_COMMAND="mysql --defaults-extra-file="$OPTFILE" -s"
DATABASES=$(echo "SHOW DATABASES" | $MYSQL_COMMAND | egrep -v '(performance_schema|information_schema|mysql|exports|sys)')

for DATABASE in $DATABASES; do
    mkdir "/output/${DATABASE}"
    echo "Exporting $DATABASE..."

    mysqldump \
        --defaults-extra-file="${OPTFILE}" \
        --add-drop-database --add-drop-table \
        --no-data --databases \
        ${DATABASE} \
        > "/output/${DATABASE}/__create.sql"

    TABLES=$(echo "SHOW TABLES" | $MYSQL_COMMAND $DATABASE)

    for TABLE in $TABLES; do
        echo "|-- Exporting table $TABLE"
        mysqldump \
            --defaults-extra-file="${OPTFILE}" \
            --add-drop-database --add-drop-table \
            --extended-insert \
            ${DATABASE} ${TABLE} \
            | sed 's$VALUES ($VALUES\n($g' \
            | sed 's$),($),\n($g' \
            > "/output/${DATABASE}/${TABLE}.sql"

        perl -i -pe "s/DROP TABLE IF EXISTS \`/USE \`${DATABASE}\`; \n\nDROP TABLE IF EXISTS \`/" "/output/${DATABASE}/${TABLE}.sql"
    done
done

echo "[DONE] Files are now available in /exports"
