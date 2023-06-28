#!/usr/bin/env bash
#
# Script name -- purpose
# remove files in a safe way
# Author: Jonas F

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # dont' hide errors within pipes
#
# Functions
#

usage() {
cat << _EOF_
Usage: ${0} 
Add arguments to be removed.
The removed files are places in the directory ~/.trash
_EOF_
}

#
# Variables
#
trash=~/.trash #trunk directory

#
# Command line parsing
#

if [ "$#" -lt "1" ]; then
    echo "Expected 1 argument, got $#" >&2
    usage
    exit 2
fi

#
# Script proper
#

#              check if trash directory exists
if [ -d "${trash}" ]; then
    echo "Trash directory already exists"
else
    mkdir ~/.trash
    echo "Trash directory doesn't exist, it is now created"
    exit 1
fi

for arg in "${@}"; do #loop trough all arguments
    if [ ! -f "${arg}" ]; then # if no file, skip
      echo " "${arg}" is not a file! Skipping..."
    else
      mv -v "${arg}" "${trash}"/"${arg}".gz #rename and move to trash dir
    fi
done
