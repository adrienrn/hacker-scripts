#!env bash

cat $1 | grep "CREATE TABLE" | perl -e 'print reverse <>' | awk '{printf "DROP TABLE IF EXISTS %s;\n", $6}';
