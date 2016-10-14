#!/bin/bash

# command line api

function veracode-app-create {
    local appName="$1"
    raw_xml=$(veracode-api-invoke createapp app_name="$appName&business_criticality=Very+High")
    format-veracode-app-create "$raw_xml"
}

function veracode-app-delete {
    local appId="$1"

    raw_xml=$(veracode-api-invoke deleteapp app_id="$appId")
    format-veracode-app-delete "$raw_xml"
}

function veracode-app-id {
    local app_Name=$1
    local data="$(veracode-api-invoke getapplist)"                                               # get data using curl
    get-value-from-string "$data" "$app_Name" 2                             # call get-value-from-string method
}

function veracode-app-id-create-if-required {
    local app_name=$1
    app_id=$(veracode-app-id "$app_name")                                   # try to get the id
    if [[ "$app_id" != "" ]]; then                                          # if we got a value back
        echo "$app_id"                                                      # it means it existed, so we just need to echo its value
    else                                                                    # if not, we need to created it
        veracode-create-app $app_name                                       # note:  veracode-create-app will echo the new app id

    fi
}

function veracode-app-info {
    local appId="$1"
    veracode-api-invoke getappinfo app_id="$appId"
}

function veracode-app-list {
    raw_xml=$(veracode-api-invoke getapplist)
    format-veracode-app-list "$raw_xml"
}


function veracode-app-sandboxes {
    local appId="$1"
    veracode-api-invoke getsandboxlist app_id="$appId"
}


function veracode-app-build {
    local appId="$1"
    local sandboxId="$2"
    local version=`date "+%Y-%m-%d %T"`
    veracode-api-invoke createbuild app_id="$appId"&version="$version"
}

function veracode-app-build-in-sandbox {
    local appId="$1"
    local sandboxId="$2"
    local version=`date "+%Y-%m-%d %T"`
    veracode-api-invoke createbuild app_id="$appId"&version="$version"&sandbox_id="$sandboxId"
}

function veracode-app-build-begin-prescan {
    local appId="$1"
    veracode-api-invoke beginprescan "app_id=$appId&auto_scan=true&scan_all_nonfatal_top_level_modules=true"
}

function veracode-app-build-begin-scan {
    local appId="$1"
    if [[ "$2" != "" ]]; then
        local target="modules=$2"
    else
        local target="scan_all_top_level_modules=true"
    fi

    #local all_modules="scan_all_top_level_modules=true"
    veracode-api-invoke beginscan "app_id=$appId&$target"
}


function veracode-app-build-info {
    local appId="$1"
    veracode-api-invoke getbuildinfo "app_id=$appId"
}

function veracode-app-build-prescan-results {
    local appId="$1"
    veracode-api-invoke getprescanresults "app_id=$appId"
}

function veracode-app-build-upload-file {
    local appId="$1"
    local file="$2"
    veracode-api-invoke-F uploadfile "app_id=$appId -F file=@$file"
}




# similar methods with different signatures (the idea is to make the method name as intuitive as possible)

function veracode-apps       { veracode-app-list     ; }
function veracode-create-app { veracode-app-create $1; }
function veracode-delete-app { veracode-app-delete $1; }
function veracode-list       { veracode-app-list     ; }