#
# Variables
#
export PAGER=less
export EDITOR=vim
export PATH=:~/.bin/:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/gnu/bin:/usr/share/:$PATH:
export MANPATH=:$MANPATH

# If you need to customize this, toss it in .bash_profile.
if [ -z $HOME ];
then
    if [ $OSTYPE == 'darwin10.0' ];
    then
        export HOME=/Users/$USER
    else
        export HOME=/home/$USER
    fi;
fi;


# current change list 'c'
# alias p4c="
#     echo \"P4CLIENT: \$P4CLIENT\";
#     p4 changes -m1 |
#         awk '{print \"Latest: \" \$2, \$3, \$4}';
#     p4 changes -m1 @\$P4CLIENT;
#     "
# 
# # Get the list of my clients
# alias p4cl="p4 clients | grep $USER"
# 
# # Get a list of files that are not on the client.
# alias p4f="
#     find . -type f | 
#         egrep -v \"sw.|bp\/|sp\/\" |
#         xargs -IXXX p4 have 'XXX' > /dev/null
#     "

#
# Prompt
#

# ROOT prompt:
# export PS1="\[\e[33;41;1m\]\u\[\e[31;40;1m\]:\[\e[37;1m\]\w\[\e[0m\]> "

#export PS1="\[\e]2;\u@\H \w\a\e[32;1m\]>\[\e[0m\] "
#export PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\H> \[\e[0m\]"
# export PS1="[\h\[\e[34m\]:\[\e[0m\]\W] \u# "
#PS1="${TITLEBAR}(\[\033[1;30m\]\$(date +%H:%M) \h:\w\[\033[0m\]) "

if [ "$UID" = 0 ]; 
then 
    if [ $OSTYPE == 'darwin1.4' ]; 
    then
        export PS1="\[\e[33;41;1m\]ROOT\[\e[0m\e[31;40m\]g3\[\e[37;1m\]\w\[\e[0m\]> "
    else
        export PS1="\[\e[33;41;1m\]\u\[\e[0m\e[31;40m\]\h\[\e[37m\]\w\[\e[0m\]> "
    fi;
fi;

if [ "$UID" != 0 ]; 
then
    # export PS1="\@\[\e[34m\]\h\[\e[37;40m\]\w\[\e[0m\]» "
    export PS1="\[\e[37;1m\]\$(date +%H:%M)\[\e[32;1m\]\H \[\e[31;1m\w\e[0m\]> "

fi;

#
# Input mode
#
set -o vi
source ~/.bash_bindings

#
# Completion
#
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#
# Alias
#

# env specific aliases
if [ -f "$HOME/.aliases" ]; then
	. $HOME/.aliases
fi 

if [ $OSTYPE == 'darwin10.0' ];
then
    alias ls='ls -FG'
    alias l='ls -lhG'
    alias ll='ls -lahG'
    # Stripping colour when removing the totals, probably the color codes shunted alongside the first line of data where the total is listed.
    # function l(){ ls -lh -G $*| egrep "^d"; ls -lh -G $* 2>&-| egrep -v "^d|total "; }
    # function ll(){ ls -alh -G $*| egrep "^d"; ls -lah -G $* 2>&-| egrep -v "^d|total "; }
else
    alias ls='ls -F --color=auto'
    function l(){ ls -lh --color=always $*| egrep "^d"; ls -lh --color=always $* 2>&-| egrep -v "^d|total "; }
    function ll(){ ls -alh --color=always $*| egrep "^d"; ls -lah --color=always $* 2>&-| egrep -v "^d|total "; }
fi;

if [ "$VIMSH" ];
then
    unalias ls
    export PS1="\@ \h \w# "
fi;

alias vi=vim
alias make='time make'
alias lr='ls -Rha'
alias ..="cd .."
alias ...="cd ../.."
alias xe='xemacs'
alias e='emacs'
alias rmt='rm *~'
alias rmh='"#"*"#"'

alias g='egrep'
alias fif='find . -name "*" | xargs grep'
alias f='find . -type f | grep'
# alias hg='history|g'

alias xg='xterm -bg black -fg green -fn fixed -sb -sl 8000 &'
alias xb='xterm -si -sk -bg black -fg gray -fn fixed -sb -sl 10000 &'
alias xG='xterm -bg gray -fn fixed -sb -sl 20000 &'
alias xB='xterm -bg blue -fg white -fn fixed -sb -sl 8000 &'


alias s='source ~/.bash_profile'
alias b='vim ~/.bashrc' 
alias v='vim ~/.vimrc' 

alias j='jobs'

case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=''
    ;;
esac


# Functions
function stoppedjobs { jobs -s | wc -l | awk '{print $1}'; }
function Is { gunzip $1 | tar xvf -; }

function hgdiff() {
    vimdiff -c 'map q :qa!<CR>' <(hg cat "$1") "$1";
}

function gitdiff() {
  git diff --no-ext-diff -w "$@" | vim -R -
}
