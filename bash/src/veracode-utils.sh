#!/bin/bash

function veracode-api-invoke-v4 { veracode-api-invoke 4.0 $1 $2 ; }
function veracode-api-invoke-v5 { veracode-api-invoke 5.0 $1 $2 ;}

function veracode-api-invoke {
    local targetUrl="https://analysiscenter.veracode.com/api/$1/$2.do"
    if [[ "$3" != "" ]]; then
        local data="--data $3"
    fi
    #echo $targetUrl $data
    echo $(curl --silent --compressed -u $API_USERNAME:$API_PASSWORD $targetUrl $data)
}

function veracode-api-invoke-v5-F {
    local targetUrl="https://analysiscenter.veracode.com/api/5.0/$1.do"
    if [[ "$2" != "" ]]; then
        local data="-F $2"
    fi
    #echo $targetUrl $data
    curl --compressed -u $API_USERNAME:$API_PASSWORD $targetUrl $data
 }

function get-value-from-string {
    local data=$1                                                                   # text to search
    local selector="\"$2\""                                                         # value to find
    local position=$3                                                               # position to return

    local formated_Data=$(format-xml "$data")                                       # format it so that grep works

    #echo "$formated_Data"
    #echo "$selector"
    echo $(echo "$formated_Data"  | \
          grep "$selector"        | \
          awk -F"\"" "{print \$$position}")                                         # feed value of data
                                                                                    # into grep which will pick the lines with $selector                                                                                   # split strings and get value in $ position
}


### bash utils

function create_folder {
    local folder=$1
    if [ ! -d "$folder" ]; then
          mkdir $folder
    fi
}

function delete_file {
    local file=$1
    if [ ! -f "$file" ]; then
          rm $file
    fi
}

function goto_folder {
    local folder=$1
    if [ ! -d "$folder" ]; then
          mkdir $folder
    fi
    cd    $folder
}