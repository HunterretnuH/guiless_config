# vim: foldmethod=marker

PATH=$PATH:~/Scripts:~/MyPrograms/bin
EDITOR='vim'
YANK_COMMAND=copy
export LS_COLORS=$LS_COLORS:'di=1;34' # Set colors for ls and ranger
#export PAGER='less -s'
bind "\eC-H":backward-kill-word

#{{{ ALIASES
## General
alias v=$EDITOR
alias ls='ls --color --group-directories-first'
alias l='ls -lh'
alias ll='l -a'
alias e='exit'
alias r='. ranger'
alias copy='tmux loadb -'
alias paste='tmux saveb -'



## Git
alias gb='git branch'
alias gc='git checkout'
alias gcp='git cherry-pick'
alias gf='git fetch'
alias gl='git log'
alias gp='git pull'
alias gP='git push'
alias grh='git reset --hard'
alias gs='git status'
alias gsu='git submodule update'

## Serial Terminal (Tio, Socat)
SOCKET='<not_set>'
alias tioc='tio -etS unix:/home/$USER/Tmp/tiocosket $SOCKET'
alias socatc='socat READLINE unix:/tmp/tiosocket'

#}}}
#{{{ Cleaning Repository (m_clean_repository)
function m_clean_repo
{
    git reset --hard --recurse-submodule -q &&
    git submodule sync --recursive &&
    git submodule update --init --force --recursive &&
    git clean -ffdx &&
    git submodule foreach --recursive git clean -ffxd
}
#}}}
#{{{ VI-Mode Clipboard
# Macros to enable yanking, killing and putting to and from the system clipboard in vi-mode. Only supports yanking and killing the whole line.
yank_line_to_clipboard () {
  echo $READLINE_LINE | $YANK_COMMAND
}

kill_line_to_clipboard () {
  yank_line_to_clipboard
  READLINE_LINE=""
}
bind -m vi-command -x '"YY": yank_line_to_clipboard'
bind -m vi-command -x '"DD": kill_line_to_clipboard'
#}}}
#{{{ Fuzzy Finder (Fzf)
set -o vi #required for correct bindings to be loaded for fzf (even though it will be set later by my .inputrc)
#
# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/$USER/MyPrograms/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/$USER/MyPrograms/fzf/shell/key-bindings.bash"
#
#}}}
#{{{ Terminal Command Prompt (Pureline)
if [ "$TERM" != "linux" ]; then
    source ~/MyPrograms/pureline/pureline ~/.custom_config/.pureline.conf
fi
#}}}

