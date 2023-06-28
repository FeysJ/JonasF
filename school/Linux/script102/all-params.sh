#!/bin/bash

if [ "${#}" == "0" ];
 then
  echo "Geen argumenten opgegeven!"
  exit 1 #afsluiten met exit status 1 => fout opgelopen
fi

while ((${#})) #loop trough all  parameters
 do
  echo ${1}   #print first parameter
  shift       #remove first parameter
done

