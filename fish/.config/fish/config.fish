set -Ux fish_user_paths
set -ga fish_user_paths ~/.local/bin
set -ga fish_user_paths ~/.yarn/bin

set fish_greeting

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
abbr g 'lazygit'
abbr files 'nvim (fzf --preview "cat {}")'
abbr ch 'checkout'

# tmux
abbr -a -g tls 'tmux list-sessions'
abbr -a -g td 'tmux detach'
abbr -a -g ta 'tmux attach-session -t'
abbr -a -g tn 'tmux new-session -s'
abbr -a -g tksv 'tmux kill-server'
abbr -a -g tkss 'tmux kill-session -t'

# neovim
abbr v 'nvim'
abbr tree 'broot'

abbr mv 'mv -iv'
abbr cp 'cp -riv'
abbr mkdir 'mkdir -vp'

abbr weather "curl -s wttr.in/Oliveira+de+Frades | grep -v Follow"

# Environment Variables
set -Ux EDITOR nvim
set -gx AWS_PROFILE default
set -gx AWS_SDK_LOAD_CONFIG 1
set -gx ANSIBLE_VAULT_PASSWORD_FILE ~/Dropbox/warden
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx FZF_DEFAULT_OPTS '--height 25% --layout=reverse'

set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH "$PYENV_ROOT/bin:$PATH"
set -Ux BUN_INSTALL "/home/ofrades/.bun"
set -px --path PATH "/home/ofrades/.bun/bin"
set -ga PATH ~/.npm-global/bin:$PATH

switch (uname)
    case Linux
      eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    case Darwin
      echo Hi Macos!
end

pyenv init - | source
starship init fish | source


