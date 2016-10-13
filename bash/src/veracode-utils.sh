#!/bin/bash


function veracode_api_invoke {
    local targetUrl="https://analysiscenter.veracode.com/api/5.0/$1.do"
    if [[ "$2" != "" ]]; then
        local data="--data $2"
    fi
    #echo $targetUrl $data
    echo $(curl --silent --compressed -u $API_USERNAME:$API_PASSWORD $targetUrl $data)
}

function veracode_api_invoke_F {
    local targetUrl="https://analysiscenter.veracode.com/api/5.0/$1.do"
    if [[ "$2" != "" ]]; then
        local data="-F $2"
    fi
    #echo $targetUrl $data
    curl --compressed -u $API_USERNAME:$API_PASSWORD $targetUrl $data
 }

function get_value_from_string {
    local data=$1                                                                   # text to search
    local selector=$2                                                               # value to find
    local position=$3                                                               # position to return

    local formated_Data=$(format_xml "$data")                                       # format it so that grep works

    echo $(echo "$formated_Data"  | \
          grep $selector          | \
          awk -F"\"" "{print \$$position}")                                         # feed value of data
                                                                                    # into grep which will pick the lines with $selector                                                                                   # split strings and get value in $ position
}

function format_xml {
    local data="$1"
    local formated_Data=$(echo "$data" | xmllint --format --noent --nonet -)        # use xmllint to format xml content so that grep filter is easier to write
    echo "$formated_Data"
}