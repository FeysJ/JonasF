#!/bin/bash
if [ "${#}" -eq "0" ];
 then
 kolom=1
else
 kolom=$1
fi

if [ "${kolom}" -lt "1" -o "${kolom}" -gt "7" ];
 then
  echo "Please enter a number between 1 and 7 (included)"
  exit 1
fi

regex='[a-z]'

if [[ "${kolom}" =~ ${regex} ]];
 then
  echo "Please enter a number between 1 and 7"
  exit 1
fi


column -t -s: /etc/passwd | sort -k${kolom}
