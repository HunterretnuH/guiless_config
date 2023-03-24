#!/bin/bash
# vim:foldmethod=marker


# {{{ Description:
# This script is made to be able to quickly setup work environement
# on a device to which I will be connecting via ssh with no GUI.
# It's actions are limited to files in /home/$USER directory and 
# shouldn't affect the rest of the system in any way.
#
# Requires: git, curl, [python], [vim], [tmux]
# }}}
#{{{ Variables
BIN_DIR_PATH=/home/$USER/MyPrograms/bin
PATH=$PATH:$BIN_DIR_PATH
#}}}
#{{{ Copy configs
cp -fr .custom_config /home/$USER/
#}}}
#{{{ Bash - .bashrc
if ! grep -q "SOURCE CUSTOM CONFIG " /home/$USER/.bashrc; then
    echo -e "\n####### SOURCE CUSTOM CONFIG #######\nsource /home/$USER/.custom_config/.bashrc\n##############" >> /home/$USER/.bashrc
fi
#}}}
#{{{ Readline: - .inputrc
if ! grep -q "SOURCE CUSTOM CONFIG " /home/$USER/.inputrc; then
    echo -e "\n####### SOURCE CUSTOM CONFIG #######\n\$include /home/$USER/.custom_config/.inputrc\n##############" >> /home/$USER/.inputrc
fi
#}}}
#{{{ File editor: VIM - .vimrc
if ! grep -q "SOURCE CUSTOM CONFIG " /home/$USER/.vimrc; then
    echo -e "\n\"####### SOURCE CUSTOM CONFIG #######\nsource /home/$USER/.custom_config/.vimrc\n\"##############" >> /home/$USER/.vimrc
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    mkdir ~/Wiki
fi
#}}}
#{{{ Terminal multiplexer: TMUX - .tmux.conf
if ! grep -q "SOURCE CUSTOM CONFIG " /home/$USER/.tmux.conf; then
    echo -e "\n####### SOURCE CUSTOM CONFIG #######\nsource-file /home/$USER/.custom_config/.tmux.conf\n##############" >> /home/$USER/.tmux.conf
fi
cp -fr .tmux /home/$USER/
git clone https://github.com/sunaku/tmux-navigate /home/$USER/.tmux/plugins/tmux-navigate
git clone https://github.com/sainnhe/tmux-fzf /home/$USER/.tmux/plugins/tmux-fzf
#}}}
#{{{ File manager: RANGER - ranger.conf
    git clone https://github.com/ranger/ranger /home/$USER/MyPrograms/ranger
    mkdir $BIN_DIR_PATH
    ln -s /home/$USER/MyPrograms/ranger/ranger.py $BIN_DIR_PATH/ranger
#}}}
#{{{ Powerline: PURELINE
git clone https://github.com/chris-marsh/pureline /home/$USER/MyPrograms/pureline
cd /home/$USER/MyPrograms/pureline
git reset --hard 5f227e4f42f1f3183dae02e65faf214323778179
cd ~
#}}}
#{{{ Fuzzy Finder: FZF
git clone https://github.com/junegunn/fzf /home/$USER/MyPrograms/fzf
cd /home/$USER/MyPrograms/fzf
./install --bin
cd /home/$USER/
ln -s /home/$USER/MyPrograms/fzf/bin/fzf $BIN_DIR_PATH/fzf
#}}}

