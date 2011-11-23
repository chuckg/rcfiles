### Basics

Collection of configuration files for:

* ack
* bash
* screen
* vim 7.2+

--

### Pre-requisites

* make
* git
* vim compiled with ruby support

--

### Install

Clone:
    
    git clone https://github.com/chuckg/rcfiles.git

Install:  

    make install

If you just want to install one configuration type, you can run:

    make vim        # installs vim only
    make ack        # installs ack only

This will write symlinks to your home directory pointing to the respective
configurations.  It will squash existing symlinks with the same name, but will
skip over any "regular" configuration files you have living there.

Additionally, it'll pull down and install all the vim plugins.  Checkout the
documentation on vundle for more information on keeping the plugins up to date:
':help Vundle'

Uninstalling de-symlinks everything the install did:

    make uninstall

For a list of full options:
    
    make help       # displays help

