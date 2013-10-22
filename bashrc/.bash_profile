# Include our bashrc if we're running BASH
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Add user's private bin to the $PATH
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Homebrew
# if [ -f $(brew --prefix)/etc/bash_completion ]; then
#     . $(brew --prefix)/etc/bash_completion
# fi

# Homebrew packages
# -----------------

# Grep
# alias grep='ggrep'

# Postgres
# export PGDATA=/usr/local/var/postgres
# alias pg_ctl="pg_ctl -m fast -l /usr/local/var/postgres/server.log"

# Python
# ------
# Forces pip to validate a virtualenv is set before installing
# export PIP_REQUIRE_VIRTUALENV=true

# ctags
# alias ruby_tags="ctags -f ./tags -R --langmap='ruby:+.rake.builder.rjs' --languages=-javascript --extra=+f --exclude=.git --exclude=log `ruby -rrubygems -e 'p Gem.path.collect {|p| ["gems", File.join("bundler","gems")].collect {|d| File.join(p, d)} }.join(" ")' | sed 's/"//g'` $PWD"

# rbenv
# eval "$(rbenv init -)"
