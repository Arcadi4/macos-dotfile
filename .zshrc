# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
export ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
export ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Homebrew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# brew command auto complete, must be done before `source "$ZSH/oh-my-zsh.sh"`
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# zsh history
export HISTSIZE=999999999
export SAVEHIST=999999999
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS

# omz
export plugins=(rust golang git fast-syntax-highlighting iterm2 zoxide zsh-interactive-cd zsh-navigation-tools brew github gitignore git-auto-fetch git-commit npm nmap node deno yarn tig mongocli pip pipenv nodenv emoji copyfile copypath safe-paste thefuck themes macos tmux ssh ssh-agent colorize colored-man-pages sudo 1password)
source "$ZSH/oh-my-zsh.sh"

# shell completions
eval "$(pnpm completion zsh)"
eval "$(bun completions zsh)"
eval "$(lucy completion zsh)"
eval "$(opencode completion)"

# command helpers
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"

# Command replacements
alias cat='bat'
alias clear='clear && fastfetch'
alias df='duf'
alias du='dust'
alias pip='pip3'
alias python='python3'
alias top='htop'
alias vim='nvim'
alias zsh='exec zsh'
alias oc='opencode'

# Quick commands
alias hmcl='nohup java -jar ~/Minecraft/HMCL.jar &>/dev/null & disown'
alias zshrc='code ~/.zshrc'
alias lzg='lazygit'

# Java
alias gradlew='./gradlew'

# Default flags
alias cp='cp -iv'
alias dust='dust -r'
alias markdownlint='markdownlint-cli2'
alias mv='mv -iv'
alias rm='rm -iv'

# fzf configs
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --preview='
    if [[ -f '{}' ]]; then
        bat --color always --decorations always --wrap auto {}
    elif [[ -d '{}' ]]; then
        ls -lAhG {}
    else
        echo {}
    fi
'"
export FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore"
function fzf {
    # Pass through to real fzf unless using custom flags
    if [[ "$1" != "--search" && "$1" != "--hist" && "$1" != "--exec" ]]; then
        command fzf "$@"
        return $?
    fi

    local result

    if [[ "$1" == "--search" ]] && [[ -z "$2" ]]; then
        echo "usage: fzf --search <pattern>" >&2
        return 1
    fi

    case "$1" in
    --search)
        result="$(rg "$2" --files-with-matches --hidden --no-ignore | command fzf)"
        ;;
    --hist)
        historyx
        return 0
        ;;
    --exec)
        result="$(eval "$2" | command fzf)"
        ;;
    esac

    # copy to clipboard
    if [[ -n "$result" ]]; then
        printf "copied: %s" "$result"
        printf "%s" "$result" | pbcopy
    fi
}

# only allow installing global npm packages with pnpm, block npm and yarn
# source "$HOME/.block-global-npm.zsh"

# functions
fastfetch() {
    local args=("--processing-timeout" "50")
    if [[ "$TERM_PROGRAM" != "iTerm.app" && "$TERM_PROGRAM" != "ghostty" ]]; then
        args+=("--logo" "default")
    fi
    command fastfetch "${args[@]}" "$@"
}

function cleanbrew() {
    brew cleanup --prune=all
    brew autoremove
}

historyx() {
    local cmd
    cmd="$(history | command fzf | awk '{$1=""; print $0}' | sed 's/^ *//')"
    if [[ -n "$cmd" ]]; then
        print -z -- "$cmd"
    fi
}

function loop() {
    if [[ -z "$1" ]]; then
        echo "usage: loop <command> [interval_secs]" >&2
        return 1
    fi

    local cmd="$1"
    local interval="${2:-1}"

    watch -n "$interval" "$SHELL" -c "$cmd"
}

# launch opencode with oh-my-openagent plugin
# `~/.config/opencode/opencode.json` should NOT already contain oh-my-openagent.
omo() {
    local config_file="$HOME/.config/opencode/opencode.json"
    local updated_json

    updated_json=$(jq '
    .plugin = (
      (.plugin // [])
      | if any(.[]; test("^oh-my-openagent(@.*)?$")) then
          .
        else
          . + ["oh-my-openagent"]
        end
    )
  ' "$config_file")

    OPENCODE_CONFIG_CONTENT="$updated_json" opencode "$@"
}

# python version
PATH+="$(brew --prefix python@3.12)/libexec/bin"

# secrets
source "$HOME/.env.zsh"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# icu4c
export PATH="/opt/homebrew/opt/icu4c@78/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c@78/sbin:$PATH"

# dotnet
export DOTNET_ROOT=/opt/homebrew/Cellar/dotnet/10.0.105/libexec

# local bin
export PATH="$PATH:$HOME/.local/bin"

# screensaver (ghostty only)
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TMOUT=600 # 10 minutes
    TRAPALRM() {
        ghostty +boo
    }
fi

# prompt
eval "$(starship init zsh)"

# print logo
clear

# bun completions
[ -s "/Users/skylar/.bun/_bun" ] && source "/Users/skylar/.bun/_bun"

# pnpm
export PNPM_HOME="/Users/skylar/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME/bin:"*) ;;
*) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/skylar/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
