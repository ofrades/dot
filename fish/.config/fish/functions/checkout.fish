# abbr checkout 'git branch -a | grep -v HEAD |  sed "s/remotes\/origin\///" |string trim | fzf | read -l result; and git checkout "$result"'
function checkout
  git fetch --all \
  | git branch --list \
  | grep -v HEAD \
  | sed "s/remotes\/origin\///" \
  | string trim \
  | fzf \
  | read -l result; and git checkout "$result"
end
