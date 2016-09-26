#!/bin/bash

# Emails the reports

function svn_checkout {
  svn checkout $1 $2
}

# This will checkout if the repo doesn't exist, or update it if it exists
function svn_checkout_or_update {
  if ! [[ -d "$2" ]]; then
    echo "> Checking $1 into folder $2"
    svn checkout  $1 $2
  else
    local current_Folder=`pwd`
    echo current_Folder is $current_Folder
    cd $2
    echo "> Updating $1 located at folder $2"
    svn update
    cd $current_Folder
  fi
}

function svn_version {
  svn --version
}
