# =============================================================================
# Zinit Installation
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit if not installed
if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{33}Installing zinit...%f"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# =============================================================================
# Plugins (loaded with turbo mode for speed)
# =============================================================================

# Essential plugins with turbo loading
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# Oh-My-Zsh snippets (just the useful bits, not the whole framework)
zinit wait lucid for \
    OMZL::git.zsh \
    OMZL::history.zsh \
    OMZL::completion.zsh \
    OMZP::git \
    OMZP::sudo \
    OMZP::command-not-found

# fzf integration for history search
zinit wait lucid for \
    junegunn/fzf

# =============================================================================
# Zsh Options
# =============================================================================

# Auto-cd: type directory name to cd into it
setopt AUTO_CD

# Extended globbing
setopt EXTENDED_GLOB

# No beep
setopt NO_BEEP

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# Completion settings
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt MENU_COMPLETE
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# Case-insensitive globbing (for auto-cd and file matching)
setopt NO_CASE_GLOB
setopt NO_CASE_MATCH

# =============================================================================
# Key Bindings
# =============================================================================

# Vi-style bindings
bindkey -v
export KEYTIMEOUT=1

# Better history search with up/down arrows
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Ctrl+R for fzf history search (if fzf available)
if command -v fzf &> /dev/null; then
    source <(fzf --zsh 2>/dev/null) || true
fi

# =============================================================================
# Aliases
# =============================================================================

# Replace ls with exa
alias ls='eza --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -al --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.='eza -ald --color=always --group-directories-first --icons .*'

# Lazydocker
alias lzd='lazydocker'

# Kitty - single instance with new OS window per launch
alias kitty='kitty --single-instance -o new_os_window=yes'

# Replace cat with bat
alias cat='bat --style=header,snip,changes'

# Yay/paru fallback
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Common use
alias grubup="sudo update-grub"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias rmpkg="sudo pacman -Rdd"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Colorized output
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='ugrep --color=auto'
alias fgrep='ugrep -F --color=auto'
alias egrep='ugrep -E --color=auto'
alias ip='ip -color'

# System info
alias hw='hwinfo --short'
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias gitpkg='pacman -Q | grep -i "-git" | wc -l'

# Mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Helpful aliases
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'
alias helpme='cht.sh --shell'
alias pacdiff='sudo -H DIFFPROG=meld pacdiff'

# Cleanup
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Logs
alias jctl="journalctl -p 3 -xb"

# Recent packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Claude
alias claudia='claude --dangerously-skip-permissions'

# =============================================================================
# Environment Variables
# =============================================================================

export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
export VISUAL=nvim

# fnm (Node version manager)
FNM_PATH="/home/cocaine/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env)"
fi

# =============================================================================
# Starship Prompt
# =============================================================================

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# =============================================================================
# Direnv (auto-load .env files in ~/Projects)
# =============================================================================

if command -v direnv &> /dev/null; then
    export DIRENV_LOG_FORMAT=
    eval "$(direnv hook zsh)"
    envinit() {
    echo "use_dotenv" > .envrc
    [[ -f .gitignore ]] && ! grep -q "^\.envrc$" .gitignore && echo ".envrc" >> .gitignore
    direnv allow
}
fi

# Flash Glove80 firmware (auto-detects device)
flashglovefirmware() {
    local dev=$(lsblk -o NAME,LABEL -r | grep -i 'GLV80' | awk '{print $1}')
    if [[ -z "$dev" ]]; then
        echo "Glove80 not found. Put it in bootloader mode first (Magic+B)"
        return 1
    fi
    echo "Found Glove80 at /dev/$dev"
    sudo mkdir -p /mnt/glove80
    sudo mount /dev/$dev /mnt/glove80
    sudo cp /home/cocaine/Downloads/cocaines.uf2 /mnt/glove80
    echo "Firmware flashed!"
}

# skill-manager
export PATH="$HOME/.claude/bin:$PATH"
