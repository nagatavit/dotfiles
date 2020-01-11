alias emacs='emacs -nw'

alias fc='fc -e vim'

alias unzip_fold='for f in *.zip; do unzip -d "${f%*.zip}" "$f"; done'

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
