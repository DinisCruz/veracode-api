#!/usr/bin/env bats
. ./api.sh

@test "Check if API_USERNAME and API_PASSWORD are set" {
  [ "$API_USERNAME" ]
  [ "$API_PASSWORD" ]
}


@test "veracode_appList" {
    run veracode_appList
    echo $output  | grep "<app app_id="

}

@test "veracode_createbuild" {
    export APP_ID=204659
    export VERSION="test scan"
    #veracode_createbuild
    veracode_createbuild
}