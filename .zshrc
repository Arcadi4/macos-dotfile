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

# fastfetch setup
fastfetch() {
    local args=("--processing-timeout" "50")
    if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
        args+=("--logo" "default")
    fi
    command fastfetch "${args[@]}" "$@"
}

# zoxide setup
eval "$(zoxide init zsh)"

# thefuck setup
eval "$(thefuck --alias)"

# omz
export plugins=(rust golang git zsh-syntax-highlighting iterm2 zoxide zsh-interactive-cd zsh-navigation-tools brew github gitignore git-auto-fetch git-commit npm nmap node deno yarn tig mongocli pip pipenv nodenv emoji copyfile copypath safe-paste thefuck themes macos tmux ssh ssh-agent colorize colored-man-pages sudo 1password)
source "$ZSH/oh-my-zsh.sh"

# brew command auto complete, must be done before 'source $ZSH/oh-my-zsh.sh'
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# shell prompt configs (alien)
source "$HOME/alien/alien.zsh"

export ALIEN_SECTIONS_LEFT=(
    exit
    time
    path
    vcs_branch:async
    vcs_status:async
    vcs_dirty:async
    newline
    ssh
    venvs
    prompt
)

export ALIEN_SECTION_TIME_FORMAT=%H:%M:%S
export ALIEN_THEME="gruvbox"

# Command replacements
alias python='python3'
alias pip='pip3'
alias top='htop'
alias cat='bat'
alias df='duf'
alias du='dust'
alias vim='nvim'
alias zsh='exec zsh'
alias clear='clear && fastfetch'

# Quick commands
alias hmcl='nohup java -jar ~/Minecraft/HMCL.jar &>/dev/null & disown'
alias zshrc='code ~/.zshrc'

# Java
alias gradlew='./gradlew'

# Default flags
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias dust='dust -r'
alias markdownlint='markdownlint --disable MD013 --disable MD007'

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
        echo "copied to clipboard: $result"
        echo -n "$result" | pbcopy
    fi
}

# rg preferences
alias rg='rg --hidden --no-ignore'

# functions
function cleanbrew() {
    brew cleanup --prune=all
    brew autoremove
}

function historyx() {
    local cmd
    cmd="$(history | command fzf | xargs | cut -d ' ' -f 2-)"
    [[ -n "$cmd" ]] && print -z -- "$cmd"
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

# for lucy development
alias lucy-d='~/Files/Developer/lucy/dist/lucy-darwin-arm64-debug'
alias lucy-r='~/Files/Developer/lucy/release/lucy-darwin-arm64'

# console-ninja
export PATH=~/.console-ninja/.bin:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# icu4c
export PATH="/opt/homebrew/opt/icu4c@78/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c@78/sbin:$PATH"

# print logo
clear
