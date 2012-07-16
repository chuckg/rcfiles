#
# Variables
#
export PAGER=less
export EDITOR=vim
export PATH=:~/.bin:/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/sbin:/usr/sbin:/usr/share:$PATH:
export MANPATH=:$MANPATH

# 
# BASH settings
#
export HISTCONTROL=ignoredup

# If you need to customize this, toss it in .bash_profile.
if [ -z $HOME ]; then
    if [[ $OSTYPE == *darwin* ]]; then
        export HOME=/Users/$USER
    else
        export HOME=/home/$USER
    fi;
fi;

#
# Prompt
#
function prompt {
    local show_user=$1
    local GIT_INFO='$(__git_ps1 " (%s)")'
    
    local GREEN="\033[32m"
    local RED="\033[31m"
    local YELLOW="\033[33m"
    local CYAN="\033[36m"
    local END_COLOR="\033[m"

    if [ $show_user = true ]; then
        local p="\$(date +%H:%M)\[$CYAN\]\u \[$GREEN\]\H \[$RED\]\W\[$YELLOW\]$GIT_INFO\[$END_COLOR\]> "
    else
        local p="\$(date +%H:%M)\[$GREEN\]\H \[$RED\]\W\[$YELLOW\]$GIT_INFO\[$END_COLOR\]> "
    fi;

    # If you want to set the term title, set the PROMPT_TITLE variable in your
    # .bash_profile.
    if [ -n "$PROMPT_TITLE" ]; then
        PS1="\[\033]0;$PROMPT_TITLE\a\]$p"
    else
        PS1="$p"
    fi;
    PS2='continue-> '
    PS4='$0.$LINENO+ '

    MYSQL_PS1="\u@\h [\d]: "
}



#
# modes
#
# interactive mode (ie: a shell is available)
# more details: http://tldp.org/LDP/abs/html/intandnonint.html
if [ ! -z "$PS1" ]; then
    # vim input mode
    source "$HOME/.bash_bindings"

    # Set PROMPT_SHOWUID in .bash_profile, it forces the prompt to include the
    # username. Especially useful for those "oh fuck I'm on production" scenarios.
    if [ "$PROMPT_SHOWUID" = true ]; then
        prompt true
    elif [ "$UID" = 0 ]; then
        prompt true
    else 
        prompt false 
    fi;
fi;

#
# Completion
#
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

#
# Alias
#

# env specific aliases
if [ -f "$HOME/.aliases" ]; then
	. $HOME/.aliases
fi 

if [[ $OSTYPE == *darwin* ]]; then
    alias ls='ls -FG'
    alias l='ls -lhG'
    alias ll='ls -lahG'
    # Stripping colour when removing the totals, probably the color codes shunted alongside the first line of data where the total is listed.
    # function l(){ ls -lh -G $*| egrep "^d"; ls -lh -G $* 2>&-| egrep -v "^d|total "; }
    # function ll(){ ls -alh -G $*| egrep "^d"; ls -lah -G $* 2>&-| egrep -v "^d|total "; }
else
    alias ls='ls -F --color=auto'
    alias l='ls -lhG'
    alias ll='ls -lahG'
    # function l(){ ls -lh --color=always $*| egrep "^d"; ls -lh --color=always $* 2>&-| egrep -v "^d|total "; }
    # function ll(){ ls -alh --color=always $*| egrep "^d"; ls -lah --color=always $* 2>&-| egrep -v "^d|total "; }
fi;

if [ "$VIMSH" ]; then
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

# Functions
function stoppedjobs { jobs -s | wc -l | awk '{print $1}'; }
function Is { gunzip $1 | tar xvf -; }

function hgdiff() {
    vimdiff -c 'map q :qa!<CR>' <(hg cat "$1") "$1";
}

function gitdiff() {
  git diff --no-ext-diff -w "$@" | vim -R -
}
