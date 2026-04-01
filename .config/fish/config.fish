function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'
    alias duh 'du -h --max-depth=1'
end

function mkcd
    mkdir -p $argv
    cd $argv
end
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
function dlclean --description "Download URL, strip ?query, save as clean filename"
    set -l url $argv[1]

    if test -z "$url"
        echo "Usage: dlclean <url>"
        return 1
    end

    # Remove everything after '?'
    set -l clean_url (string split -m1 '?' -- $url)[1]

    # Get filename from the cleaned URL path
    set -l filename (path basename -- $clean_url)

    if test -z "$filename"
        set filename download
    end

    # Download and save with clean filename
    curl -L --fail --retry 3 --output "$filename" "$url"
end
zoxide init fish | source
alias cd="z"
alias dlc="dlclean"
