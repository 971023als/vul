#!/bin/bash

BASHRC=.bashrc
BASHLOGOUT=.bash_logout

cat << EOF >> $HOME/.bashrc
 
set -o vi
alias vi='/usr/bin/vim'
export EDITOR=/usr/bin/vim
export PATH=\$PATH:/root/scripts

EOF


cat << EOF >> $HOME/$BASHLOGOUT

history -c

EOF