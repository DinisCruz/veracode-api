#!/bin/bash


function veracode-api-invoke {
    local targetUrl="https://analysiscenter.veracode.com/api/5.0/$1.do"
    if [[ "$2" != "" ]]; then
        local data="--data $2"
    fi
    #echo $targetUrl $data
    echo $(curl --silent --compressed -u $API_USERNAME:$API_PASSWORD $targetUrl $data)
}

function veracode-api-invoke-F {
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

### Formatting output utils

function format-xml {
    local data="$1"
    local formated_Data=$(echo "$data" | xmllint --format --noent --nonet -)        # use xmllint to format xml content so that grep filter is easier to write
    echo "$formated_Data"
}


function format-veracode-app-create {
    raw_xml=$1
    app_id=$( echo $raw_xml | sed  -n 's/.*app_id="\(.*\)".app_name.*/\1/p' )
    echo $app_id
}

function format-veracode-app-delete {
    local data="$1"
    if [[ $data =~ .*\<error\>.*\</error\>.* ]] ; then
        echo "0 (failed to delete)"
    else
        echo "1 (delete ok)"
    fi
}

function format-veracode-app-list {
    raw_xml=$1
    echo
    echo "App id     App Name                       Policy Updated Date"
    echo -------------------------------------------------------------------
    echo "$(format-xml "$raw_xml")" | grep "<app " | awk -F"\"" '{ printf "%-10s %-30s %-30s \n" , $2,$4,$6 }' ;
    echo
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