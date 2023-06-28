#! /bin/bash
#
## Usage: ./backup.sh [OPTIONS] [DIR]
##
## DIR
##              The directory to back up
##              Default: the current user's home directory
##
## OPTIONS
##
##  -h, --help
##              Print this help message and exit
##
##  -d, --destination DIR
##              Set the target directory to store the backup file
##              Default:  /tmp

#---------- Shell options ------------------------------------------------------
# TODO

#---------- Variables ----------------------------------------------------------

# Time stamp for the backup file
timestamp=$(date +'%F%H%M' | tr -d "-")

# Path of the directory to back up
source=~

# Directory where to store the backup file
destination=/tmp

#---------- Main function ------------------------------------------------------
main() {
  process_cli_args "${@}"
  
  echo "Backup from ${source} to ${destination}"

  check_source_dir
  check_destination_dir

  do_backup
}

#---------- Helper functions ---------------------------------------------------

# Usage: process_cli_args "${@}"
process_cli_args() {
  : # TODO: remove after implementing this function
  # Use a while loop to process all positional parameters
  while [ ${#} -gt 0 ]; do 

    # Put the first parameter in a variable with a more descriptive name
    param="${1}"
    printf  'arg: %s\n'  "${param}"  
    
    # Use case statement to determine what to do with the currently first
    # positional parameter
    case "${param}" in
      # If -h or --help was given, call the usage function and exit
      -h|--h|?)
        usage
        exit 1
        ;;
      
      # If -d or --destination was given, set the variable destination to
      # the next positional parameter.
      -d|--destination)
        destination="${param}"
        ;;
      
      # If any other option (starting with -) was given, print an error message
      # and exit with an error status
      -*)
        echo "Error: wrong parameter"
        exit 2
        ;;

      # In all other cases, we assume the directory to back up was given.
      *)
        source="${param}"
        ;;

    esac


  shift
  done     
}

# Usage: do_backup
#  Perform the actual backup
do_backup() {
  local source_dirname backup_file
  # Get the directory name from the source directory path name
  # e.g. /home/osboxes -> osboxes, /home/osboxes/Downloads/ -> Downloads
  # Remark that this should work whether there is a trailing `/` or not!
  source_dirname=$(basename "${source}")
  
  


  # Name of the backup file
  backup_file="${source_dirname}-${timestamp}.tar"
  echo "naam van gemaakte file is ${backup_file}"
  # Create the bzipped tar-archive on the specified destination
  tar -cvf "${destination}/${backup_file}" "home/jonas/test/"

}

# Usage: check_source_dir
#   Check if the source directory exists (and is a directory). Exit with error
#   status if not.
check_source_dir() {
  if [ ! -d "${source}" ]; then
    echo "Source directory not found!"
    exit 2
  fi
}

# Usage: check_destination_dir
#   Dito for the destination directory
check_destination_dir() {
  if [ ! -d "${destination}" ]; then
    echo "Destination directory not found!"
    exit 2
  fi

  
}

# Print usage message on stdout by parsing start of script comments.
# - Search the current script for lines starting with `##`
# - Remove the comment symbols (`##` or `## `)
usage() {
  
  cat <<_EOF_
  Usage: ./backup.sh [OPTIONS] [DIR]

  DIR
              The directory to back up
              Default: the current user's home directory

 OPTIONS

  -h, --help  
              Print this help message and exit

  -d, --destination DIR
              Set the target directory to store the backup file
              Default:  /tmp

_EOF_


}

main "${@}"