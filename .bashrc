[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$HOME/.cargo/env"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/Users/basokant/.juliaup/bin:*)
        ;;

    *)
        export PATH=/Users/basokant/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
