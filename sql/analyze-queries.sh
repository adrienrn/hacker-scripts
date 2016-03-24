#!env bash

cat $1 | grep 'FROM (oc_t_' | sort | uniq -c
