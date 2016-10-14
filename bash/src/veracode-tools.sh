#!/usr/bin/env bash


function veracode-scan-file {
    local target_file=$1
    local project_name=$(basename $target_file)
    local app_id=$(veracode-app-id-create-if-required "$project_name")

    echo "Scanning file $target_file, into project called $project_name with app_id $app_id"

    #app_id=$(veracode-app-id $project_name)
    #echo "current app-id $app_id"
    #veracode-delete-app $app_id
    #local app_id=$(veracode-app-id-create-if-required "$project_name")

    veracode-app-upload-file $app_id $target_file
    veracode-app-build-begin-prescan $app_id
    veracode-app-build-info $app_id
    #veracode-apps

}