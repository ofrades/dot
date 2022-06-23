set -Ux fish_user_paths
# Path

set -U fish_emoji_width 2

# disable greeting
set fish_greeting
# vim
# fish_vi_key_bindings

set -l foreground cdcecf
set -l selection 2b3b51
set -l comment 738091
set -l red c94f6d
set -l orange f4a261
set -l yellow dbc074
set -l green 81b29a
set -l purple 9d79d6
set -l cyan 63cdcf
set -l pink d67ad2

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

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
abbr gedit 'flatpak run org.gnome.gedit'
abbr ch 'checkout'

abbr weather "curl -s wttr.in/Oliveira+de+Frades | grep -v Follow"

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
      eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    case Darwin
      echo Hi Macos!
end

set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH "$PYENV_ROOT/bin:$PATH"

pyenv init - | source

