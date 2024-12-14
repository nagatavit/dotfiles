# alias emacs='emacs -nw'

alias fc='fc -e vim'

alias unzip_fold='for f in *.zip; do unzip -d "${f%*.zip}" "$f"; done'

alias config='/usr/bin/git --git-dir=$HOME/.git/ --work-tree=$HOME'

alias r='ranger'

alias e='emacsclient -c'

alias no='grep -viP'

alias scratch="vim $(mktemp)"

to-clipboard() {
    xclip -sel c
    echo "copied to clipboard"
}

ppgrep() {
    pgrep "$@" | xargs --no-run-if-empty ps fp;
}
