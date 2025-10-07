function sp -d 'Search for a Project to open. Projects are within ~/workspace.'
    set -l cwd (pwd)

    set -l workspace_directory ~/workspace
    cd $workspace_directory

    set -l chosen_project (
        begin
            fd --type d --max-depth 1;
            fd . tmp/ --type d --max-depth 1;
        end | fzf --preview='head -n 50 | tree {}' --no-height
    )

    cd $cwd
    if [ "$chosen_project" ]
        set -l chosen_project_directory (string join '/' $workspace_directory $chosen_project)
        cd $chosen_project_directory
    end
end
