# MySQL Exporter Tool
# > Tool Selection
# 
# Package: net.ikigai.ops.mysql.tools
# Author: Narcis M PAP, Aug 2018

PS3='net.ikigai.ops.mysql.tools Tool Selection: '
options=("Shell" "Backup" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Shell")
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

            cat "$OPTFILE"
            mysql --defaults-extra-file="${OPTFILE}"
            ;;
        "Backup")
            /bin/bash /tools/export-dbs.sh
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

