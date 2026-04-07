function cd --description "Custom cd with zoxide integration and visual feedback"
    set -l old $PWD

    if test (count $argv) -eq 0
        builtin cd ~
        or return
    else if test -d "$argv[1]"
        builtin cd "$argv[1]"
        or return
    else
        z $argv
        or begin
            set_color red
            echo "Error: Directory not found"
            set_color normal
            return 1
        end
    end

    set -l new $PWD
    if test "$old" != "$new"
        # Show arrow and current path
        printf "\U000F17A9 "
        set_color cyan
        echo (string replace -r "^$HOME" "~" $new)
        set_color normal
    end
end
