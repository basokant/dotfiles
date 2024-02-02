if status is-interactive
    # Commands to run in interactive sessions can go here

    set ZELLIJ_AUTO_ATTACH true

    fish_vi_key_bindings insert

    set fish_cursor_default block blink
    set fish_cursor_insert line blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual block
end

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

# Prompt
starship init fish | source

# Zoxide, a better cd
zoxide init fish | source

# FZF
set -Ux FZF_DEFAULT_OPTS "--height 60% --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/basokant/miniconda3/bin/conda
    eval /Users/basokant/miniconda3/bin/conda "shell.fish" hook $argv | source
end
# <<< conda initialize <<<

# opam configuration
source /Users/basokant/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true
