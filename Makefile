SHELL := /bin/bash

BASH_FILES   = .bashrc .bash_bindings
VIM_FILES    = .vimrc .vim .gvimrc

# symlink(file,dir)
# Creates a symlink for the specified file in the users's home directory if it
# is not a regular file or squashes an existing symlink.
define symlink
	if [ ! -e "~/$(1)" ]  || [ -h "~/$(1)" ];  then \
		echo "Installed ~/$(1)";                    \
		ln -nfs $(PWD)/$(2)/$(1) ~/$(1);            \
	else                                            \
		echo "~/$(1) exists, skipping.";            \
	fi;
endef

# delink(file)
# Removes configuration symlinks if it determines the file is a symlink and
# links to a file in the make directory.
define delink
	if [ -h ~/$(1) ] && [[ "$(basename $(shell readlink ~/$(1)))" == *$(PWD)* ]];  then \
		echo "Removing ~/$(1)";                                                         \
		rm ~/$(1);                                                                      \
	fi;
endef


# ----------------------
# Default to help.
help: 
	@echo 'Installation:'
	@echo '    make install          # Install all'
	@echo '    make ack              # Install ack config'
	@echo '    make bash             # Install bash config'
	@echo '    make screen           # Install screen config'
	@echo '    make vim              # Install vim config'
	@echo 
	@echo 'Uninstall:'
	@echo '    make uninstall        # Uninstall symlinks without clobbering custom configs.'

# ----------------------
# Installers
install: ack bash screen vim 

ack:
	@$(call symlink,.ackrc,'ackrc')
	@echo 

bash:
	@$(foreach file,$(BASH_FILES),$(call symlink,$(file),'bashrc'))
	@echo 

screen:
	@$(call symlink,.screenrc,'screenrc')
	@echo 

vim: 
	@$(foreach file,$(VIM_FILES),$(call symlink,$(file),'vimrc'))
	@if [ -d ~/.vim/bundle ]; then rm -rf ~/.vim/bundle; fi;
	@mkdir ~/.vim/bundle
	@echo 
	@echo 'Installing vundle for vim.'
	git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
	@echo 
	@echo 'Bundling vim plugins.'
	@vim -c 'BundleInstall' -c 'qa'

	
# ----------------------
# Uninstallers
uninstall: 	
	@$(call delink,.ackrc)
	@$(call delink,.screenrc)
	@$(foreach file,$(VIM_FILES),$(call delink,$(file)))
	@$(foreach file,$(BASH_FILES),$(call delink,$(file)))
	@echo
	@echo 'Done uninstalling rcfiles ...'
