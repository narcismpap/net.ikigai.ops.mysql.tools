# MySQL Exporter Tool
# > Example Helper
# 
# Package: net.ikigai.ops.mysql.tools
# Author: Narcis M PAP, Aug 2018

export VASQL_PORT=3306
export VASQL_SOURCE=/SQL_DIR
export VASQL_OUTPUT=/OUTPUT_DIR
export VASQL_MYSQL=/SQL_RUN_DIR

docker-compose -f docker-compose.yml $1
