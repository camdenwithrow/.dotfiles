# custom_prompt.zsh
function git_branch_name()
{
  branch=$(git symbolic-ref --short HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo '['$branch']'
  fi
}

function git_branch_changes()
{
    changes=$(git status --porcelain 2>/dev/null)
    if [[ $changes == "" ]];
    then
      :
    else
      echo '*'
    fi
}

function exit_code()
{
  echo '%(?.. )'
}

setopt prompt_subst
prompt='%F{red}$(git_branch_changes)%F{green}[%~]%F{cyan}$(git_branch_name)%f$ '
