function mux
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

    if not set -q TMUX
      tmux new -A -s "$destdir" -c "$destdir"
    else
      TMUX= tmux new -d -s "$destdir" -c "$destdir"
      tmux switch-client -t "$destdir"
    end

#    if test -z "Session.vim"
#        vi
#    else if test -z "README.md"
#        vi README.md
#    else
#        vi
#    end

end
