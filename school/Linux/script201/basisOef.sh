#!/usr/bin/env bash
#
# Script name -- purpose
#
# Author: 

set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable

#
# Functions
#

usage() {
cat << _EOF_
Usage: ${0} 
_EOF_
}

controlNum() {
num="$1"
if [ "${num}" -lt "1" -o "${num}" -gt "100" ]; then
  echo "getal moet tussen 1 en 100 liggen"
  exit 2
fi
}


#
# Variables
#




#
# Command line parsing
#


#
# Script proper
#
echo -n "Enter a number: "
read n1
controlNum $n1

echo -n "Enter another number: "
read n2
controlNum $n2

let sum="${n1} + ${n2}"
let multp="${n1}*${n2}"

echo -e "Sum\t: ${n1} + ${n2} = ${sum}"
echo -e "Product\t: ${n1} * ${n2} = ${multp}" 

if [ "${sum}" -eq "${multp}" ]; then {
   echo "congratz, sum and product are equal!"
}
fi
