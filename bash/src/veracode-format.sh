#!/usr/bin/env bash

### Format helpers

function attribute-value {
    local data=$1
    local element_name=$2
    local attribute_name=$3
    echo "$data" | grep "<$element_name " | sed -n "s/.*$attribute_name=\"\([^\"]*\).*/\1/p"
}

function format-dash-line {
    local size=$1
    local dash_line=$(echo $(printf "%0.s-" $(eval echo "{1..$size}")))
    echo "|$dash_line|"

}

function format-xml {
    local data="$1"
    local formated_Data=$(echo "$data" | xmllint --format --noent --nonet -)        # use xmllint to format xml content so that grep filter is easier to write
    echo "$formated_Data"
}

### Formatting output utils



function format-application-build {
    data=$1

    app_name=$(attribute-value "$data" "application" "app_name")
    app_id=$(attribute-value "$data" "application" "app_id")
    modified_date=$(attribute-value "$data" "application" "modified_date" | sed 's/T.*//')
    rules_status=$(attribute-value "$data" "build" "rules_status")
    build_id=$(attribute-value "$data" "build" "build_id")
    analysis_type=$(attribute-value "$data" "analysis_unit" "analysis_type")
    published_date=$(attribute-value "$data" "analysis_unit" "published_date" | sed 's/T.*//')
    status=$(attribute-value "$data" "analysis_unit" "status")

    echo "$(printf "| %-30s | %-15s | %-15s | %-15s | %-15s | %-15s | %-15s | %-15s |\n"  \
                   "$app_name" "$app_id" "$build_id" "$modified_date" "$rules_status" "$analysis_type" "$published_date" "$status")"
    #echo $data
}

function format-veracode-app-build-id {
    raw_xml=$1
    local formatted_xml=$(format-xml "$raw_xml")
    build_id=$(attribute-value "$formatted_xml" "buildinfo" "build_id")
    echo "$build_id"
}

function format-veracode-app-build-info {
    raw_xml=$1
    local formatted_xml=$(format-xml "$raw_xml")

    app_id=$(attribute-value "$formatted_xml" "buildinfo" "app_id")
    build_id=$(attribute-value "$formatted_xml" "buildinfo" "build_id")
    rules_status=$(attribute-value "$formatted_xml" "build" "rules_status")
    analysis_type=$(attribute-value "$formatted_xml" "analysis_unit" "analysis_type")
    status=$(attribute-value "$formatted_xml" "analysis_unit" "status")

    echo
    echo "Veracode build info for app $app_id"
    echo "|-----------------------------------------------------------------------|"
    echo "$(printf "| %-10s | %-15s | %-15s | %-20s |\n"  "Build Id" "Rules status" "Analysis Type" "Status")"
    echo "|-----------------------------------------------------------------------|"
    echo "$(printf "| %-10s | %-15s | %-15s | %-20s |\n"  "$build_id" "$rules_status" "$analysis_type" "$status")"
    echo "|-----------------------------------------------------------------------|"
    echo
}

function format-veracode-app-builds {
    local raw_xml=$1
    formated_xml=$(format-xml "$raw_xml")

    number_of_apps=$(echo "$formated_xml" | grep "<application " | wc -l)

    echo
    echo "Veracode builds (for all apps)"
    format-dash-line 158
    echo "$(printf "| %-30s | %-15s | %-15s | %-15s | %-15s | %-15s | %-15s | %-15s |\n"  \
                   "app_name" "app_id" "build_id" "modified_date" "rules_status" "analysis_type" "published_date" "status")"
    format-dash-line 158

    for i in `seq 1 $number_of_apps`;
    do
        local application_xml=$(echo "$formated_xml" | echo "$(xpath "//application[$i]" 2>/dev/null)")
        format-application-build "$application_xml"
    done
    format-dash-line 158
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
    echo "App id     App Name                       Last Scan"
    echo -------------------------------------------------------------------
    echo "$(format-xml "$raw_xml")" | grep "<app " | awk -F"\"" '{ printf "%-10s %-30s %-30s \n" , $2,$4,$6 }' ;
    echo
}

function veracode-format-file-list {
    local raw_xml=$1
    local formatted_xml=$(format-xml "$raw_xml")

    build_id=$(echo "$formatted_xml" | grep "<filelist " | sed  -n 's/.*build_id="\(.*\)">*/\1/p' )
    app_id=$(echo "$formatted_xml"   | grep "<filelist " | sed -n 's/.*app_id="\([^"]*\).*/\1/p'  )
    echo
    echo "   Veracode file list for build $build_id in app $app_id       "
    echo -------------------------------------------------------------------
    echo "File Id         Name                           Status"
    echo -------------------------------------------------------------------
    echo "$(format-xml "$raw_xml")" | grep "<file " | awk -F"\"" '{ printf "%-15s %-30s %-30s \n" , $2,$4,$6 }' ;

}

