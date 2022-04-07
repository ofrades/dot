function vi
  if count $argv > /dev/null;
    env nvim $argv
  else if test -f Session.vim;
    env nvim -S
  else
    env nvim -c Obsession
  end
end
