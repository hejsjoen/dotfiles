if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch --config examples/8
end
# ~/.config/fish/config.fish
#
export CHROME_EXECUTABLE="/usr/bin/chromium"
source ~/.alias
zoxide init fish | source
starship init fish | source
fzf --fish | source
