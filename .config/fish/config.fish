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
fish_add_path $GOPATH/bin

# pnpm
set -gx PNPM_HOME "/Users/basokant/Library/pnpm"
fish_add_path "$PNPM_HOME/bin"

# uv
fish_add_path "/Users/basokant/.local/bin"
