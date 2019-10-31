#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

OLDDIR=$(pwd)
SRCPATH=$(readlink -f "${0}")
WORKDIR=$(dirname "${SRCPATH}")
cd "${WORKDIR}"

conn_str="${1:-UNDEFINED}"

if [ "${conn_str}" == "UNDEFINED" ]
then
	echo "Usage: ${0} <connection_string>"
	echo "E.g. ${0} 'Server=10.44.59.114,13025;Database=master;User Id=sa;Password=Password123!;'"

	exit 1
fi

./mssqlscripter --connection-string "${conn_str}" --exclude-headers -f './ms_schema_dump_file.sql'

sed -ri "\|/var/opt/mssql/data/master.mdf|s|SIZE = [[:digit:]]+KB||g" 'ms_schema_dump_file.sql'

mv 'ms_schema_dump_file.sql' "${OLDDIR}/ms_dump.sql"

exit "${?}"
