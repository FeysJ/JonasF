#! /bin/bash
#
## Usage: ${0} [N] [WORDLIST]
##        ${0} -h|--help
##
## Generate a passphrase, as suggested by http://xkcd.com/936/
##
##   N
##            The number of words the passphrase should consist of
##            Default: 4
##   WORDLIST
##            A text file containing words, one on each line
##            Default: /usr/share/dict/words
##
## OPTIONS
##   -h, --help
##              Print this help message
##
## EXAMPLES
##
##   $ ${0} -h
##   ...
##   $ ${0}
##   unscandalous syagush merest lockout
##   $ ${0} /usr/share/hunspell/nl_BE.dic 3
##   tegengif/Ze Boevink/PN smekken 

#---------- Shell options -----------------------------------------

#  TODO





#---------- Variables ---------------------------------------------

#  TODO
num_words=4
dictionary=/usr/share/dict/words

#---------- Main function -----------------------------------------
main() {
  process_cli_args "${@}"
  generate_passphrase
}

#---------- Helper functions --------------------------------------

# Usage: generate_passphrase
# Generates a passphrase with ${num_words} words from ${word_list}
generate_passphrase() {
   # TODO
  shuf --head-count "${num_words}" "${dictionary}" | fmt --width=2500
}

# Usage: process_cli_args "${@}"
#
# Iterate over command line arguments and process them
process_cli_args() {
  # TODO

  # If the number of arguments is greater than 2: print the usage
  # message and exit with an error code
  if [ "$#" -gt "2" ]; then 
    echo -e "to many parameters were given, max 2, got $#" >&2
    usage
  fi

  # Loop over all arguments
  
  while [ "$#" -gt 0 ]; do
    printf '\e[32mArg: %s\e[0m\n' "${1}"
    
      case "${1}" in
        -h|--help|-?)
            usage
            exit 0
            ;;

        [0-9]*)
            num_words="${1}"
            ;;

        *)
            if [ ! -f "${1}" ] || [ ! -r "${1}" ]; then
                echo "${1} is not a readable file!" >&2
                exit 2
            fi
            dictionary="${1}"
            ;;
      esac
    shift
  done   

    # Use a case statement to determine what to do
    

      # If -h or --help was given, call usage function and exit
      

      # If any other option was given, print an error message and exit
      # with status 1
      

      # In all other cases, we assume N or WORD_LIST was given
      
        # If the argument is a file, we're setting the word_list variable
        
        # If not, we assume it's a number and we set the num_words variable
        
}

# Print usage message on stdout by parsing start of script comments.
# - Search the current script for lines starting with `##`
# - Remove the comment symbols (`##` or `## `)
# ${0} print de naam van het bestand
usage() {
cat << _EOF_
Usage: ${0} [N] [WORDLIST]
       ${0} -h|--help

Generate a passphrase, as suggested by http://xkcd.com/936/

N
           The number of words the passphrase should consist of
           Default: 4
           
WORDLIST
           A text file containing words, one on each line
          Default: /usr/share/dict/words

OPTIONS
   -h, --help
             Print this help message

EXAMPLES

   $ ${0} -h
   ...
   $ ${0}
   unscandalous syagush merest lockout
   $ ${0} /usr/share/hunspell/nl_BE.dic 3
   tegengif/Ze Boevink/PN smekken 
_EOF_
}

# Call the main function
main "${@}"
