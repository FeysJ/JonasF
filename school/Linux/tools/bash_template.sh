!/usr/bin/env bash
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

#
# Variables
#

#
# Command line parsing
#

if [ "$#" -ne "1" ]; then
    echo "Expected 1 argument, got $#" >&2
    usage
    exit 2
fi

#
# Script proper
#
