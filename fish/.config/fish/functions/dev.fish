function dev -d 'fzf source to cd to directory under $HOME/dev'
    set -l dir "$HOME/dev"

    find -L "$dir" -mindepth 2 -maxdepth 2 -type d \
        | string replace "$dir/" "" \
        | fzf \
        | read newDir

    if test -n "$newDir"
        commandline "cd $dir/$newDir"
        commandline -f execute
    end
end
