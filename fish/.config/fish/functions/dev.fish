function dev
    if set -q argv[1]
        set searchdir $argv[1]
    else
        set searchdir $HOME/dev
    end

    set -l tmpfile (mktemp)
    find -L $searchdir -maxdepth 4 -type d \
    | fzf > $tmpfile
    set -l destdir (cat $tmpfile)
    rm -f $tmpfile

    if test -z "$destdir"
        return 1
    end

    cd $destdir

    if test -z "Session.vim"
        vi
    else if test -z "README.md"
        vi README.md
    else
        vi
    end

end
