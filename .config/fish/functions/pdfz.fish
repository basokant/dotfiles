function pdfz
    if test -z "$(rg --files | rg -i '\.pdf$')"
        echo "No PDF Files in current working directory"
        return
    end

    set file (rg --files | rg -i '\.pdf$' | fzf --preview-window=50%,top --preview 'pdftotext -f 1 -l 2 {} -')
    if test -n "$file"
        zathura "$file"
    end
end
