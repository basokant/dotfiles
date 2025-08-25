if status is-interactive
    # Commands to run in interactive sessions can go here
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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/basokant/miniconda3/bin/conda
    eval /Users/basokant/miniconda3/bin/conda "shell.fish" hook $argv | source
end
# <<< conda initialize <<<

alias love="/Applications/love.app/Contents/MacOS/love"
