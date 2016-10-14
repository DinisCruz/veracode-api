#!/bin/bash

# Emails the reports

function git-clone {
  git clone $1 $2
}

# This will clone if the repo doesn't exist, or pull it if it exists
function git-clone-or-pull {
  if ! [[ -d "$2" ]]; then
    echo "> Cloning $1 into folder $2"
    git clone $1 $2
  else
    local current_Folder=`pwd`
    echo current_Folder is $current_Folder
    cd $2
    echo "> Pulling $1 located at folder $2"
    git pull
    cd $current_Folder
  fi
}

function git-version {
  git version
}
