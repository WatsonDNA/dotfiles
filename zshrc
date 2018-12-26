# Watson's zshrc
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

#---------------------------
# Startup
#---------------------------

# load system-wide settings
[ -x /usr/libexec/path_helper ] && eval "$(/usr/libexec/path_helper -s)"

# make sure to put /usr/local to PATH
path=(/usr/local/bin /usr/local/sbin $path)

# environment variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#---------------------------
# Utility
#---------------------------

# the toggle function
function __enable_utils() {
  # initialize
  local utils=(__util_function)
  function __util_function() { utils=($utils $1) }

  ## __is_cmd_exist <command>
  # if <command> exists, return true
  __util_function __is_cmd_exist
  function __is_cmd_exist() { which $1 >/dev/null 2>&1 }

  ## __add_path <path>
  # add <path> if the dir exists
  __util_function __add_path
  function __add_path() { [ -d $1 ] && path=($1 $path) }

  ## __shortcut <alias> <command>
  # make a shortcut <alias> if the <command> exist
  __util_function __shortcut
  function __shortcut() { __is_cmd_exist $2 && alias $1="$2" }

  ## __relax
  # do nothing for a moment
  __util_function __relax
  function __relax() { sleep 0.1 }

  ## __eval_cmd <command> [<arg> ...]
  # eval <command> with a message
  function __eval_cmd() { echo "* $*" && eval "$*" }

  ## __disable_utils
  # disable the utilities
  __util_function __disable_utils
  eval "__disable_utils() { for fn in $utils; do unfunction \$fn; done }"
}

# enable utilities for this script
__enable_utils

#---------------------------
# Zplug
#---------------------------

# install
if [ ! -d ~/.zplug ]; then
  curl -sL --proto-redir -all,https\
    https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# initialize
source ~/.zplug/init.zsh > /dev/null 2>&1

# list of plugins
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# load plugins
zplug load

# install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo
    zplug install
  fi
fi

#---------------------------
# Completion
#---------------------------

# load local completion functions
fpath=(~/.zsh/completions $fpath)

# travis (gem)
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# enable completion
autoload -U compinit
compinit -u

# do not suggest current dir
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' ignore-parents parent pwd ..

#---------------------------
# Prompt settings
#---------------------------

() {
  local pcdir=$'\n'%F{yello}%~%f$'\n'
  local pname="Watson-$MACHINE"
  export PROMPT="$pcdir$pname$ "
  export PROMPT2="[$pname]> "
}

#---------------------------
# History settings
#---------------------------

# dir and its size
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ignore duplication command history list
setopt hist_ignore_dups

# share command history data
setopt share_history

# extend history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#---------------------------
# Confortable settings
#---------------------------

# run cd with path
setopt auto_cd

# remember move history (show list with "cd -[Tab]")
setopt auto_pushd

# correct command
setopt correct

# show alternate list compact
setopt list_packed 

# exec R-lang with r
disable r

#---------------------------
# Optional settings
#---------------------------

# enable hub
__is_cmd_exist hub && eval "$(hub alias -s)"

# initialize rbenv & pyenv
__add_path "$HOME/.rbenv/bin"
__add_path "$HOME/.pyenv/bin"
__is_cmd_exist rbenv && eval "$(rbenv init -)"
__is_cmd_exist pyenv && eval "$(pyenv init -)"

# use binary from cargo
__add_path "$HOME/.cargo/bin"

# save readline histories to ~/.rlwrap
__is_cmd_exist rlwrap && export RLWRAP_HOME="$HOME/.rlwrap"

# load my plugins
() {
  func_src=($HOME/.zsh/functions/*.zsh)
  for fs in $func_src; do
    [ -f $fs ] && source $fs
  done
}

#---------------------------
# Aliases
#---------------------------

# ask before delete files
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# execute with sudo
alias please='sudo $(fc -ln -1)'

# shortcuts
__shortcut ipy ipython
__shortcut ipy3 ipython3

# aliases depending on OS
case ${OSTYPE} in
  # Aliases for macOS
  darwin*)
    # ls: colorful output by default
    alias ls="ls -Gh"
    alias gls="gls --color=auto --human-readable"
    # rm: use rmtrash for safety
    alias rm="rmtrash"
    # turn on/off network connection with wifi command
    alias wifi="networksetup -setairportpower en0";;
  # aliases for Linux
  linux*)
    # ls: colorful output by default
    alias ls="ls --color=auto --human-readable";;
esac

#---------------------------
# Finalize
#---------------------------

# preferred PATH
path=($HOME/bin /usr/local/texlive/2018/bin/x86_64-darwin $path)

# delete overlapped paths
typeset -U path cdpath fpath manpath

# cleanup utility functions
__disable_utils

# prevent lines inserted unintentionally
:<< COMMENTOUT
