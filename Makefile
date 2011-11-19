BASH_FILES   = .bashrc .bash_bindings
VIM_FILES    = .vimrc .vim .gvimrc

# symlink(file,dir)
# Creates a symlink for the specified file in the users's home directory if it
# is not a regular file or squashes an existing symlink.
define symlink
	if [ ! -e "~/$(1)" ]  || [ -h "~/$(1)" ];  then \
		echo "Installed ~/$(1)";                    \
		ln -fs $(PWD)/$(2)/$(1) ~/$(1);             \
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

bash: $(BASH_FILES)

$(BASH_FILES):
	@$(call symlink,$@,"bashrc")

screen:
	@$(call symlink,.screenrc,'screenrc')

vim: $(VIM_FILES) 

$(VIM_FILES): 
	@$(call symlink,$@,'vimrc')

# ----------------------
# Uninstallers
uninstall: 	
	@echo 'Uninstalling'
	$(call delink,.ackrc)
	$(call delink,.screenrc)
	$(foreach file,$(VIM_FILES),$(call delink,$(file)))
	$(foreach file,$(BASH_FILES),$(call delink,$(file)))
