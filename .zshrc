# Homebrew setup
eval $(/opt/homebrew/bin/brew shellenv)

# omz plugins
plugins=(rust golang git zsh-syntax-highlighting iterm2 zoxide zsh-interactive-cd zsh-navigation-tools brew github gitignore git-auto-fetch git-commit npm nmap node deno yarn tig mongocli pip pipenv nodenv emoji copyfile copypath safe-paste thefuck themes macos tmux ssh ssh-agent colorize colored-man-pages sudo 1password)

# omz setup
source $ZSH/oh-my-zsh.sh

# fastfetch
fastfetch() {
    local args=("--processing-timeout" "50")
    if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
        args+=("--logo" "default")
    fi
    command fastfetch "${args[@]}" "$@"
}

# Zoxide setup
eval "$(zoxide init zsh)"

# thefuck setup
eval $(thefuck --alias)

# brew command auto complete, must be done before 'source $ZSH/oh-my-zsh.sh'
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# shell prompt configs (alien)
source ~/alien/alien.zsh

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
alias hmcl='java -jar ~/Minecraft/HMCL.jar'
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
FZF_DEFAULT_OPTS="--height 60% --layout=reverse --preview='
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
    *)
        command fzf
        return 0
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
