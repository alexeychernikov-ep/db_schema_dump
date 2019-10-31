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
	echo "E.g. ${0} postgresql://postgres:postgres@r3-exposed-ws14:13160/postgres"

	exit 1
fi

./pg_dump -s "${conn_str}" -f './pg_schema_dump_file.sql'

sed -ri "s/^(-- Dumped by pg_dump version )(([[:digit:]]+.)*[[:digit:]]+)$/\19.6.15/g" 'pg_schema_dump_file.sql'

mv 'pg_schema_dump_file.sql' "${OLDDIR}/pg_dump.sql"

exit "${?}"
