function dev-neovim
    set -l tmpfile (mktemp)
    set searchdir $HOME/.local/share/nvim/lazy/

    if set -q argv[1]
        find -L $searchdir -maxdepth 4 -type d \
            | fzf --query $argv[1] >$tmpfile
    else
        find -L $searchdir -maxdepth 4 -type d \
            | fzf >$tmpfile
    end

    set -l destdir (cat $tmpfile)
    rm -f $tmpfile

    if test -z "$destdir"
        return 1
    end

    cd $destdir

    echo "🦸 jump to $destdir"
end
