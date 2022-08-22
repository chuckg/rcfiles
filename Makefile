SHELL := /bin/bash

BASH_FILES  = .bashrc .bash_bindings
VIM_FILES   = .vimrc .vim .gvimrc .ideavimrc
GIT_FILES   = .gitconfig .gitignore

# symlink(file,dir)
# Creates a symlink for the specified file in the users's home directory if it
# is not a regular file or squashes an existing symlink.
define symlink
    if [ ! -e ~/$(1) ]  || [ -h ~/$(1) ];  then     \
        ln -nfs $(PWD)/$(2)/$(1) ~/$(1);            \
        echo "Symlinked ~/$(1)";                    \
    else                                            \
        echo "~/$(1) exists, skipping";             \
    fi;
endef

# delink(file)
# Removes configuration symlinks if it determines the file is a symlink and
# links to a file in the make directory.
define delink
    if [ -h ~/$(1) ] && [[ "$(basename $(shell readlink ~/$(1)))" == *$(PWD)* ]];  then \
        rm ~/$(1);                                                                      \
        echo "Removed symlink ~/$(1)";                                                  \
    fi;
endef

# install(file,dir)
# Copies the specified file to the users's home directory if it does not exist
define install_config
    if [ ! -e ~/$(1) ];  then               \
        cp $(PWD)/$(2)/$(1) ~/$(1);         \
        echo "Installed ~/$(1)";            \
    else                                    \
        echo "~/$(1) exists, skipping";     \
    fi;
endef

# ----------------------
# Default to help.
help: 
	@echo 'Installation:'
	@echo '    make install          # Install/symlink core configs'
	@echo 
	@echo 'Core:'
	@echo '    make ack              # Symlink ack config'
	@echo '    make bash             # Symlink bash config'
	@echo '    make screen           # Symlink screen config'
	@echo '    make slate            # Symlink slate config'
	@echo '    make vim              # Symlink vim config'
	@echo
	@echo 'Misc:'
	@echo '    make git              # Install git config'
	@echo '    make profile          # Install profile'
	@echo '    make psql             # Symlink psql config'
	@echo '    make rdebug           # Symlink ruby-debug config'
	@echo
	@echo 'Uninstall:'
	@echo '    make uninstall        # Removes symlinks, ignoring custom or installed configs'
	@echo 

# ----------------------
# Installers
install: ack bash screen slate vim 

ack:
	@$(call symlink,.ackrc,'ackrc')
	@echo 

bash:
	@$(foreach file,$(BASH_FILES),$(call symlink,$(file),'bashrc'))
	@echo 

screen:
	@$(call symlink,.screenrc,'screenrc')
	@echo 

slate:
	@$(call symlink,.slate,'slaterc')
	@echo 

vim: 
	@$(foreach file,$(VIM_FILES),$(call symlink,$(file),'vimrc'))
	@if [ -d ~/.vim/bundle ]; then rm -rf ~/.vim/bundle; fi;
	@mkdir ~/.vim/bundle
	@echo 
	@echo 'Installing Vundle for vim.'
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	@echo 
	@echo 'Bundling vim plugins.'
	@vim -c ':PluginInstall' -c 'qa'

# MISC

git:
	@$(foreach file,$(GIT_FILES),$(call install_config,$(file),'misc/git'))
	@echo

profile:
	@$(call install_config,.bash_profile,'bashrc')
	@echo

psql:
	@$(call symlink,.psqlrc,'misc/psql')
	@echo

rdebug:
	@$(call symlink,.rdebugrc,'misc/rdebug')
	@echo


# ----------------------
# Uninstallers
uninstall:  
	@$(call delink,.ackrc)
	@$(call delink,.screenrc)
	@$(foreach file,$(VIM_FILES),$(call delink,$(file)))
	@$(foreach file,$(BASH_FILES),$(call delink,$(file)))
	@$(call delink,.rdebugrc)
	@echo
	@echo 'Done uninstalling rcfiles ...'
