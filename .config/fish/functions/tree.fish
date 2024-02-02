function tree --wraps='exa --tree --icons' --description 'alias tree exa --tree --icons'
    exa --tree --icons -I '.git|node_modules|target' $argv
end
