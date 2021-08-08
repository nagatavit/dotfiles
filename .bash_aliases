# alias emacs='emacs -nw'

alias fc='fc -e vim'

alias unzip_fold='for f in *.zip; do unzip -d "${f%*.zip}" "$f"; done'

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias r='ranger'

alias e='emacsclient -c'

alias no='grep -viP'

alias scratch="vim $(mktemp)"
