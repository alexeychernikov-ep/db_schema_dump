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
	echo "E.g. ${0} jdbc:h2:~/Projects/Corda/network/local_network/PartyF/persistence"

	exit 1
fi

java -cp h2*.jar 'org.h2.tools.RunScript' -url "${conn_str}" -user 'sa' -script 'h2_schema_dump_statement.sql'
sed -ri "/^--/d; s/[[:space:]]+$//g; /^;$/d; s/(SALT|HASH) '[[:alnum:]]+'//g; s/START WITH [[:digit:]]+;//g" 'h2_schema_dump_file.sql' 

mv 'h2_schema_dump_file.sql' "${OLDDIR}/h2_dump.sql"

exit "${?}"
