# Watson's zshrc
# Author: wtsnjp
# Website: https://wtsnjp.com
# Source: https://github.com/wtsnjp/dotfiles

#---------------------------
# Startup
#---------------------------

# load system-wide settings
if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi

# environment variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export RLWRAP_HOME=".rlwrap"

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

# enable completion
autoload -U compinit
compinit -u

# texdoc
() {
  which kpsewhich > /dev/null
  if [ $? = 0 ]; then
    local tlpdb="$(kpsewhich -var-value TEXMFROOT)/tlpkg/texlive.tlpdb"
    if [ -f $tlpdb ]; then
      local cmd="(($(awk '/^name[^.]*$/ {print $2}' $tlpdb)))"
      compctl -k $cmd texdoc
    fi
  fi
}

# pip
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip

# travis (gem)
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

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
which hub >/dev/null 2>&1 && eval "$(hub alias -s)"

# initialize rbenv & pyenv
which rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"
which pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

# use binary from cargo
which cargo >/dev/null 2>&1 && path=(/Users/asakura/.cargo/bin $path)

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

# aliases depending on OS
case ${OSTYPE} in
  # Aliases for macOS
  darwin*)
    # ls: colorful output by default
    alias ls="ls -Gh"
    alias gls="gls --color=auto --human-readable"
    # rm: use rmtrash for safety
    alias rm="rmtrash"
    # launch IPython quickly
    alias ipy="ipython"
    alias ipy3="ipython3"
    # update & upgrade brew
    alias upup="brew update && brew upgrade && brew cleanup"
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

# prefered PATH
path=(/Users/asakura/bin $path)

# delete overlaped paths
typeset -U path cdpath fpath manpath

# prevent lines inserted unintentionally
:<< COMMENTOUT
