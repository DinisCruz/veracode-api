# Emails the reports

function git_clone {
  git clone $1 $2
}

function git_clone_or_pull {
  if ! [[ -d "$2" ]]; then
    git clone $1 $2
  else
    git pull $2
  fi
}
function git_pull
{
  cd $1
  git pull $2
  cd ..
}
function git_version {
  git version
}
