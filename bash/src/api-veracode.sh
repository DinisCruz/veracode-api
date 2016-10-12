#!/bin/bash

# command line api

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

function veracode_app_list {
    veracode_api_invoke getapplist
}

function veracode_app_info {
    local appId="$1"
    veracode_api_invoke getappinfo app_id="$appId"

}


function veracode_app_sandboxes {
    local appId="$1"
    veracode_api_invoke getsandboxlist app_id="$appId"
}


function veracode_app_build {
    local appId="$1"
    local sandboxId="$2"
    local version=`date "+%Y-%m-%d %T"`
    veracode_api_invoke createbuild app_id="$appId"&version="$version"
}

function veracode_app_build_in_sandbox {
    local appId="$1"
    local sandboxId="$2"
    local version=`date "+%Y-%m-%d %T"`
    veracode_api_invoke createbuild app_id="$appId"&version="$version"&sandbox_id="$sandboxId"
}

function veracode_app_build_begin_prescan {
    local appId="$1"
    veracode_api_invoke beginprescan "app_id=$appId&auto_scan=true&scan_all_nonfatal_top_level_modules=true"
}

function veracode_app_build_begin_scan {
    local appId="$1"
    if [[ "$2" != "" ]]; then
        local target="modules=$2"
    else
        local target="scan_all_top_level_modules=true"
    fi

    #local all_modules="scan_all_top_level_modules=true"
    veracode_api_invoke beginscan "app_id=$appId&$target"
}


function veracode_app_build_info {
    local appId="$1"
    veracode_api_invoke getbuildinfo "app_id=$appId"
}

function veracode_app_build_prescan_results {
    local appId="$1"
    veracode_api_invoke getprescanresults "app_id=$appId"
}

function veracode_app_build_upload_file {
    local appId="$1"
    local file="$2"
    veracode_api_invoke_F uploadfile "app_id=$appId -F file=@$file"
}

function veracode_create_app {
    local appName="$1"
    veracode_api_invoke createapp app_name="$appName&business_criticality=Very+High"

}