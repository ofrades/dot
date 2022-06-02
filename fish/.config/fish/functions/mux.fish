function mux
    set searchdir $HOME/dev
    set -l tmpfile (mktemp)

    if set -q argv[1]
      find -L $searchdir -maxdepth 4 -type d \
      | fzf --query $argv[1] > $tmpfile
    else
      find -L $searchdir -maxdepth 4 -type d \
      | fzf > $tmpfile
    end

    set -l destdir (cat $tmpfile)
    rm -f $tmpfile

    if test -z "$destdir"
        return 1
    end

    set -l name (basename $destdir)

    if not set -q TMUX
      tmux new -A -s "$name" -c "$destdir"
    else
      TMUX= tmux new -d -s "$name" -c "$destdir"
      tmux switch-client -t "$name"
    end
end
