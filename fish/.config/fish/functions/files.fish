function files --wraps='fzf --preview "cat {}"' --description 'alias files fzf --preview "cat {}"'
  fzf --preview "cat {}" $argv; 
end
