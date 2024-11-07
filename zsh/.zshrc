# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

# End of lines added by compinstall
fpath+=${ZDOTDIR:-~}/.zsh_functions

# Add Homebrew completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
# file for interactive shells

# This .zshrc is based on Kali Linux's .zshrc, though it's been modified in significant ways.

setopt autocd               # change directory just by typing its name
#setopt correct             # auto correct mistakes
setopt interactivecomments  # allow comments in interactive mode
setopt magicequalsubst      # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch            # hide error message if there is no match for the pattern
setopt notify               # report the status of background jobs immediately
setopt numericglobsort      # sort filenames numerically when it makes sense
setopt promptsubst          # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
export PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                      # emacs key bindings
bindkey ' ' magic-space                         # do history expansion on space
bindkey '^[[3;5~' kill-word                     # ctrl + Supr
bindkey '^H' backward-kill-word                 # ctrl + del
bindkey '^[[3~' delete-char                     # delete
bindkey '^[[1;5C' forward-word                  # ctrl + ->
bindkey '^[[1;5D' backward-word                 # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history  # page up
bindkey '^[[6~' end-of-buffer-or-history        # page down
bindkey '^[[H' beginning-of-line                # home
bindkey '^[[F' end-of-line                      # end
bindkey '^[[Z' undo                             # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion
zstyle ':completion:*' completer _extensions _complete _approximate
#zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Enable zsh's git prompt features through vcs_info
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' ✎'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:*' formats '%b%u%c'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Add patters to the regex to avoid storing them in history
function zshaddhistory() {
	emulate -L zsh
	if ! [[ "$1" =~ "(^ |^ychalresp|\bgpg\b|--password)" ]]; then
		print -sr -- "${1%%$'\n'}"
		fc -p
	else
		return 1
	fi
}

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

case "$TERM" in
	xterm-color|*-256color) color_prompt=yes ;;
	xterm-kitty|alacritty)  color_prompt=yes ;;
esac

# Find if we have color prompt
# Uncomment to force color prompt
#force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
	else
	color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	# Fallback prompt
	PROMPT="[%n@%m %1~]%# "

	# Choose a prompt style between: fedora ubuntu kali vscode powerline custom
	prompt_style=custom

	# Configure the prompt, include a special prompt for vscode.
	# The vscode prompt is advanced like the others, but small and easy to
	# render. This helps when you're in vscode's tiny, gpu accelerated terminal
	[ -n "$VSCODE_GIT_IPC_HANDLE" -o -n "$INSIDE_GNOME_BUILDER" ] && prompt_style=vscode
	case ${(L)prompt_style} in
		fedora)
			PROMPT=$'[%n@%m %1~%(1j. ⚙.)${vcs_info_msg_0_}]%# '
			zstyle ':vcs_info:*' formats ' - %b%u%c'
		;;
		ubuntu)
			PROMPT=$'%B%F{%(#.red.green)}%n@%m%f%b:%(1j. ⚙.)${vcs_info_msg_0_} %B%F{%(#.yellow.blue)}%(4~.%-1~/…/%2~.%3~)%f%b%# '
			zstyle ':vcs_info:*' formats ' %F{yellow}%b%f%u%c'
		;;
		########## MODIFY BELOW FOR CUSTOM PROMPT ##########
		custom)
			if [[ ${SSH_TTY} ]] ; then
				PROMPT=$'%B%F{%(#.red.magenta)}%n %F{%(#.red.green)}{%m}%(1j. ⚙.)${vcs_info_msg_0_} %B%F{%(#.yellow.cyan)}%(4~.%-1~/…/%2~.%3~)%f%b $ '
			else
				PROMPT=$'%B%F{%(#.red.magenta)}%n%(1j. ⚙.)${vcs_info_msg_0_} %B%F{%(#.yellow.cyan)}%(4~.%-1~/…/%2~.%3~)%f%b $ '
			fi
			zstyle ':vcs_info:*' formats ' %F{green}(%b)%u%c%f'
		;;
		kali)
			PROMPT=$'%F{%(#.red.blue)}╭──(%B%F{%(#.red.cyan)}%n%(#.🕱.@)%m%f%b%F{%(#.red.blue)})-[%B%F{%(#.yellow.green)}%(4~.%-1~/…/%2~.%3~)%f%b%F{%(#.red.blue)}]%(1j. %F{grey}⚙%f.)%F{%(#.red.blue)}${vcs_info_msg_0_}\n%F{%(#.red.blue)}╰─%#%f '
			zstyle ':vcs_info:*' formats ' - %F{yellow}%b%f%u%c'
		;;
		vscode)
			PROMPT=$'%F{%(#.red.blue)}(%B%F{%(#.yellow.cyan)}%1~%F{%(#.red.blue)}%b)%(1j. %F{grey}⚙.) ${vcs_info_msg_0_} %(#.%F{red}.%F{blue})$%f '
			zstyle ':vcs_info:*' formats ' %F{green}%b%u%c%f'
		;;
		powerline)
			function powerline_precmd() {
				PS1="$(powerline-shell --shell zsh $?)"
			}
			[ ! "$precmd_functions" =~ 'powerline_precmd' ] && \
				precmd_functions+=(powerline_precmd)
		;;
	esac
	# Use the right prompt to display if we're running inside a toolbox container
	if [ "$HOSTNAME" = "toolbox" ]; then
		RPROMPT=$'%(?.. %F{red}%? ✘%f) %F{magenta}⬢%f'
	else
		RPROMPT=$'%(?.. %F{red}%? ✘%f)'
	fi

	# enable syntax-highlighting
	if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh -a "$color_prompt" = yes ]; then
	. /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
	ZSH_HIGHLIGHT_STYLES[default]=none
	ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
	ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
	ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[path]=underline
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
	ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
	ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[command-substitution]=none
	ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[process-substitution]=none
	ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[assign]=none
	ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
	ZSH_HIGHLIGHT_STYLES[named-fd]=none
	ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
	ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
	ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
	ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
	fi

else
	PROMPT="[%n@%m %1~]%# "
	RPROMPT=$'%(?.. %F{red}%? x%f)'
fi

unset color_prompt force_color_prompt

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

COLORING=' --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

export LESS_TERMCAP_mb=$'\E[1;31m'   # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'   # begin bold
export LESS_TERMCAP_me=$'\E[0m'      # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'  # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'      # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'   # begin underline
export LESS_TERMCAP_ue=$'\E[0m'      # reset underline

# Take advantage of $LS_COLORS for completion as well
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ls aliases
if [ "$OSTYPE" != linux-gnu ]; then  # Is this the macOS system?
    alias ls=gls
fi

setup_ls_aliases(){
  local ls_cmd=ls
  
  if [ "$OSTYPE" != linux-gnu ]; then  # Is this the macOS system?
      ls_cmd=gls
      export COLORING=" --color=auto"
  fi

  alias ls="$ls_cmd$COLORING -BhF --group-directories-first"
  alias l="$ls_cmd$COLORING -lBhF --group-directories-first"
  alias la="$ls_cmd$COLORING -ABhF --group-directories-first"
  alias lz="$ls_cmd$COLORING -lBhFZ --group-directories-first"
  alias ll="$ls_cmd$COLORING -lABhF --group-directories-first"
  alias lla="$ls_cmd$COLORING -lahF --group-directories-first"
  alias llz="$ls_cmd$COLORING -lahFZ --group-directories-first"
}

setup_ls_aliases


# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
	. /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	# change suggestion color
	if [ $TERM == "linux" ]; then
		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#111'
	else
		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#999"
	fi
fi

# Create a directory and cd into it
new() {
	mkdir "$1" && cd "$1"
}

# Put all your aliases and configs in files under the ~/.zshrc.d folder
[ -d ~/.zshrc.d ] && \
	for i in $(ls ~/.zshrc.d); do
		. ~/.zshrc.d/$i
	done || :


# Load Angular CLI autocompletion.
source <(ng completion script)

# Use neovim instead of vim
# alias vim="nvim"
alias vim='NVIM_APPNAME="nvim-kickstart" nvim'
alias nvim-original='nvim'

alias p=pnpm

export EDITOR=nvim
# export MANPAGER='nvim +Man!'
export PAGER=nvimpager

# Python aliases
alias python=python3
alias pip=pip3

# For poetry (pipenv alternative)
export PATH="$HOME/.local/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Have fzf use ripgrep (rg) instead of grep
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files'
    export FZF_DEFAULT_OPTS='-m'
fi

# Go CLI Setup
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# nvim on linux
PATH="$PATH:/opt/nvim-linux64/bin"

function smartcd() {
    directory=$(fd --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv | fzf)

    if [ -n "$directory" ]; then
        cd $directory
    fi
}

if type fd &> /dev/null && type fzf &> /dev/null; then
    alias f=smartcd
fi

if type lazygit &> /dev/null ; then
    alias lg=lazygit
fi

if git root &> /dev/null ; then
    function cd_to_git_root() {
        directory=$(git root)

        if [ -n "$directory" ]; then
            cd $directory
        fi
    }

    alias cdg=cd_to_git_root
fi

# Zoxide setup
eval "$(zoxide init zsh)"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
