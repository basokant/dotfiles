function sf -d 'Search for a (grand)child File to go to within your current working directory.'
    set -l chosen_file (
      fd --type f | fzf --preview-window=50%,top --preview 'bat --style=numbers --color=always --line-range :500 {}'
    )
    nvim $chosen_file
end
