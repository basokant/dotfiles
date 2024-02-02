function sd -d 'Search for a child Directory to go to within your current working directory.'
    set -l chosen_directory (fd --type d | fzf)
    cd $chosen_directory
end
