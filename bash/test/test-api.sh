#!/usr/bin/env bats
. ./api.sh

@test "load API ok and call git version" {
  result="$(git_version)"
  echo $result | grep 'git version'
}

@test "git clone or pull" {
  TARGET_REPO=https://github.com/DinisCruz/veracode-api.git
  TARGET_FOLDER=repos/veracode-api
  git_clone_or_pull $TARGET_REPO $TARGET_FOLDER

  run ls $TARGET_FOLDER                # confirm folder exists
  [ "$status" = 0 ]

  ls $TARGET_FOLDER | grep README.md  # confirm expected file is in there

}
