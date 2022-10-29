# abbr checkout 'git branch -a | grep -v HEAD |  sed "s/remotes\/origin\///" |string trim | fzf | read -l result; and git checkout "$result"'
function checkout
   git branch -a \
  | grep -v HEAD \
  | sed "s/remotes\/origin\///" \
  | string trim \
  | fzf \
  | read -l result; and git checkout "$result"
end
