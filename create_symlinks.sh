#!/bin/sh

if [ $OSTYPE == 'darwin10.0' ];
then
    if [ -f /opt/local/bin/gfind ];
    then
        gnufind=/opt/local/bin/gfind
    fi;
else 
    if [ -n `find --version | head -n 1 | grep GNU` ];
    then
        gnufind=find
    fi;
fi;

if [ -z $gnufind ];
then
    echo 'Silly rabbit, must have GNU find installed.'
fi;

for f in `$gnufind . -type d -name "*rc" -printf "%f\n"` 
do
    for rc in `$gnufind ./$f/ -name ".*" -printf "%f\n" | grep -v "\.sw[a-z]"`
    do
        sympath=$PWD/$f/$rc
        homepath=$HOME/$rc
        if [ -f $homepath ] || [ -d $homepath ]; 
        then
            echo "$rc already exists in HOME, skipping."
            continue
        fi;
        `ln -s $sympath $homepath`
        echo "Created symlink for $rc at $homepath"
    done
done
