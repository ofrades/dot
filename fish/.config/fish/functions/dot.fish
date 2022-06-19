function dot
    set -l tmpfile (mktemp)
    set searchdir $HOME/dot

    if set -q argv[1]
        find -L $searchdir -maxdepth 4 -type d \
        | fzf --query $argv[1] > $tmpfile
    else
        find -L $searchdir -maxdepth 6 -type f \
        | fzf > $tmpfile
    end

    set -l destdir (cat $tmpfile)
    rm -f $tmpfile

    if test -z "$destdir"
        return 1
    end

    nvim $destdir
end
