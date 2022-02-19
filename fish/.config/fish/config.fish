set -Ux fish_user_paths
# Path

set -U fish_emoji_width 2

# TokyoNight Color Palette
set -l foreground c0caf5
set -l selection 364A82
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7

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

alias -s ls 'exa --color=always --icons --group-directories-first'
alias -s la 'exa --color=always --icons --group-directories-first --all'
alias -s ll 'exa --color=always --icons --group-directories-first --all --long'

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

abbr lambdas 'aws lambda list-functions | fzf'

# Environment Variables
set -ga fish_user_paths /usr/local/go/bin
set -ga fish_user_paths ~/.local/bin
set -ga fish_user_paths ~/.yarn/bin
set -ga fish_user_paths ~/.cargo/bin
set -Ux EDITOR nvim
set -gx AWS_PROFILE default
set -gx AWS_SDK_LOAD_CONFIG 1
set -gx ANSIBLE_VAULT_PASSWORD_FILE ~/Dropbox/warden


set -ga PATH ~/.npm-global/bin:$PATH

starship init fish | source
eval (/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)


set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PATH "$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end
