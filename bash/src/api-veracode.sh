#!/bin/bash

# command line api

function veracode-app-builds {
    raw_xml=$(veracode-api-invoke-v4 getappbuilds)

    format-veracode-app-builds "$raw_xml"
}

function veracode-app-create {
    local appName="$1"
    raw_xml=$(veracode-api-invoke-v5 createapp app_name="$appName&business_criticality=Very+High")
    format-veracode-app-create "$raw_xml"
}

function veracode-app-delete {
    local id_or_name="$1"

    local raw_xml=$(veracode-api-invoke-v5 deleteapp app_id="$id_or_name")                               # try do delete as if $id_or_name is an id

    if [[ $raw_xml =~ .*\<error\>No.app_id.parameter.specified\</error\>.* ]] ; then            # if we get an <error>No app_id parameter specified</error> error message
        local app_id=$(veracode-app-id "$id_or_name")                                                 # try to resolve the name to an id
        raw_xml=$(veracode-api-invoke-v5 deleteapp app_id="$app_id")                               # try to delete is with the resolved id
    fi
    format-veracode-app-delete "$raw_xml"


}

function veracode-app-id {
    local app_Name=$1
    local data="$(veracode-api-invoke-v5 getapplist)"                                               # get data using curl
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
    veracode-api-invoke-v5 getappinfo app_id="$appId"
}

function veracode-app-list {
    raw_xml=$(veracode-api-invoke-v5 getapplist)
    format-veracode-app-list "$raw_xml"
}


function veracode-app-sandboxes {
    local appId="$1"
    veracode-api-invoke-v5 getsandboxlist app_id="$appId"
}


function veracode-app-build {
    local appId="$1"
    local sandboxId="$2"
    local version=`date "+%Y-%m-%d %T"`
    veracode-api-invoke-v5 createbuild app_id="$appId"&version="$version"
}

function veracode-app-build-in-sandbox {
    local appId="$1"
    local sandboxId="$2"
    local version=`date "+%Y-%m-%d %T"`
    veracode-api-invoke-v5 createbuild app_id="$appId"&version="$version"&sandbox_id="$sandboxId"
}

function veracode-app-build-begin-prescan {
    local appId="$1"
    raw_xml=$(veracode-api-invoke-v5 beginprescan "app_id=$appId&auto_scan=true&scan_all_nonfatal_top_level_modules=true")
    #raw_xml=$(veracode-api-invoke-v5 getbuildinfo "app_id=$appId")
    format-veracode-app-build-info "$raw_xml"
}

function veracode-app-build-begin-scan {
    local appId="$1"
    if [[ "$2" != "" ]]; then
        local target="modules=$2"
    else
        local target="scan_all_top_level_modules=true"
    fi

    #local all_modules="scan_all_top_level_modules=true"
    veracode-api-invoke-v5 beginscan "app_id=$appId&$target"
}

function veracode-app-build-delete {
    local appId="$1"
    veracode-api-invoke-v5 deletebuild "app_id=$appId"
}

function veracode-download-pdf {
    local app_name="$1"

    local app_id=$(veracode-app-id "$app_name")
    local build_info=$(veracode-api-invoke-v5 getbuildinfo "app_id=$app_id")
    local build_id=$(format-veracode-app-build-id "$build_info")
    local target_folder="./reports/${app_name}"
    local target_file="$target_folder/$build_id.pdf"
    echo "Downloading report for app $app_Name with id $app_Id with build id $build_id , to location $target_file"

    mkdir -p "$target_folder"
    veracode-api-download "2.0" "detailedreportpdf" "build_id=$build_id" "$target_file"
}


function veracode-app-build-info {
    local appId="$1"
    raw_xml=$(veracode-api-invoke-v5 getbuildinfo "app_id=$appId")
    format-veracode-app-build-info "$raw_xml"
}

function veracode-app-build-files {
    local appId="$1"
    raw_xml=$(veracode-api-invoke-v5 getfilelist "app_id=$appId")
    veracode-format-file-list "$raw_xml"
}

function veracode-app-build-prescan-results {
    local appId="$1"
    veracode-api-invoke-v5 getprescanresults "app_id=$appId"
}

function veracode-app-upload-file {
    local appId="$1"
    local file="$2"
    raw_xml=$(veracode-api-invoke-v5-F uploadfile "app_id=$appId -F file=@$file")
    veracode-format-file-list "$raw_xml"
}




# similar methods with different signatures (the idea is to make the method name as intuitive as possible)

function veracode-apps         { veracode-app-builds          ; }
function veracode-create-app   { veracode-app-create        $1; }
function veracode-delete-app   { veracode-app-delete        $1; }
function veracode-delete-build { veracode-app-build-delete  $1; }
function veracode-list         { veracode-app-list            ; }