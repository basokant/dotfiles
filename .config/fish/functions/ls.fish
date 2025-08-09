function ls --wraps=exa --wraps='eza -al --color=always --group-directories-first' --wraps='eza --color=always --group-directories-first' --description 'alias ls eza --color=always --group-directories-first'
    eza --color=always --group-directories-first $argv
end
