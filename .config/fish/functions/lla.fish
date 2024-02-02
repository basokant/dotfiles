function lla --wraps='ll -a' --description 'alias lla exa -la --icons'
    command exa -la --icons $argv
end
