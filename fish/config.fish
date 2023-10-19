set -x LC_ALL en_US.UTF-8

if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias config '/usr/bin/git --git-dir=$HOME/Projects/dotfiles --work-tree=$HOME/.config'
fish_add_path /opt/local/bin/ /Applications/MacPorts/EmacsMac.app/Contents/MacOS/bin/
set -Ux LD_LIBRARY_PATH /opt/local/lib/ /opt/local/lib/gcc12/
set -Ux EDITOR "emacsclient -t"
source /opt/local/share/fzf/shell/key-bindings.fish
