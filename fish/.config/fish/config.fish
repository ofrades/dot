set -Ux fish_user_paths
set -ga fish_user_paths ~/.local/bin
set -ga fish_user_paths ~/.yarn/bin
set -ga fish_user_paths ~/.yarn/bin
set fish_greeting
fish_vi_key_bindings

# git
abbr clone 'git clone git@github.com:'
abbr status 'git status'
abbr add 'git add -p'
abbr add-all 'git add .'
abbr fetch-all 'git fetch -a'
abbr commit 'git commit'
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
abbr g lazygit
abbr f 'nvim (fzf --preview "cat {}")'
abbr ch checkout

alias python="/home/linuxbrew/.linuxbrew/bin/python3.9"

# tmux
abbr -a -g ta 'tmux attach-session -t'
abbr -a -g tksv 'tmux kill-server'
abbr -a -g tkss 'tmux kill-session -t'

# neovim
abbr vi nvim

abbr mv 'mv -iv'
abbr cp 'cp -riv'
abbr mkdir 'mkdir -vp'

set -Ux EDITOR nvim
set -gx ANSIBLE_VAULT_PASSWORD_FILE ~/Dropbox/wardeg
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx FZF_DEFAULT_OPTS '--height 25% --layout=reverse'
set -gx PATH "$HOME/.cargo/bin" $PATH
set -gx AWS_PROFILE default
source "$HOME/.config/fish/env.fish"

eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)


oh-my-posh init fish | source
# starship init fish | source
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

alias assume="source /usr/local/bin/assume.fish"
