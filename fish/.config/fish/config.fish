set -Ux fish_user_paths
# Path

set -U fish_emoji_width 2

# disable greeting
set fish_greeting
# vim
# fish_vi_key_bindings

# git
abbr clone 'git clone git@github.com:'
abbr status 'git status'
abbr add 'git add -p'
abbr add-all 'git add .'
abbr fetch-all 'git fetch -a'
abbr commit 'git commit -m'
abbr amend 'git commit --amend --no-edit'
abbr commit-chunk 'git commit -p'
abbr pull 'git pull'
abbr rebase-main 'git pull --rebase origin main'
abbr rebase-master 'git pull --rebase origin master'
abbr push 'git push'
abbr push-force 'git push --force'
abbr undo-commit 'git reset --soft HEAD~1'
abbr discard-changes 'git restore .'
abbr revert-changes 'git reset --hard'
abbr log-diff 'git log -p'
abbr local-changes 'git diff HEAD'
abbr diff-previous-changes 'git diff HEAD~1'
abbr rebase 'git rebase'
abbr continue 'git rebase --continue'
abbr g 'lazygit'
abbr files 'nvim (fzf --preview "cat {}")'
abbr checkout 'git branch -a | grep -v HEAD |  sed "s/remotes\/origin\///" |string trim | fzf | read -l result; and git checkout "$result"'
abbr gedit 'flatpak run org.gnome.gedit'

abbr -s ls 'exa --color=always --icons --group-directories-first'
abbr -s la 'exa --color=always --icons --group-directories-first --all'
abbr -s ll 'exa --color=always --icons --group-directories-first --all --long'

abbr weather "curl -s wttr.in/Oliveira+de+Frades | grep -v Follow"

abbr create "toolbox create"
abbr enter "toolbox enter"
abbr remove "toolbox rm"
abbr list "toolbox list"

# neovim
abbr v 'nvim'
abbr cat 'bat'
abbr tree 'broot'

abbr mv 'mv -iv'
abbr cp 'cp -riv'
abbr mkdir 'mkdir -vp'


# tmux
abbr -a -g tls 'tmux list-sessions'
abbr -a -g td 'tmux detach'
abbr -a -g ta 'tmux attach-session -t'
abbr -a -g tn 'tmux new-session -s'
abbr -a -g tksv 'tmux kill-server'
abbr -a -g tkss 'tmux kill-session -t'

abbr -a -g mx tmuxinator
abbr -a -g mxs 'tmuxinator start'
abbr -a -g mxe 'tmuxinator edit'
abbr -a -g mxn 'tmuxinator new'
abbr -a -g mxc 'tmuxinator copy'

# Environment Variables
set -ga fish_user_paths /usr/local/go/bin
set -ga fish_user_paths ~/.local/bin
set -ga fish_user_paths ~/.yarn/bin
set -ga fish_user_paths ~/.cargo/bin
set -Ux EDITOR nvim
set -gx AWS_PROFILE default
set -gx AWS_SDK_LOAD_CONFIG 1
set -gx ANSIBLE_VAULT_PASSWORD_FILE ~/Dropbox/warden
set -gx TERMINAL foot

set -gx FZF_DEFAULT_OPTS '--height 50% --layout=reverse'

set -ga PATH ~/.npm-global/bin:$PATH

starship init fish | source
switch (uname)
    case Linux
      eval (/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    case Darwin
      echo Hi Macos!
end


set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH "$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end

