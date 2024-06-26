set -x LC_ALL en_US.UTF-8

if status is-interactive
    # Commands to run in interactive sessions can go here
end


function fish_greeting
    if status is-interactive
        fortune | cowthink
    end
end


alias config '/usr/bin/git --git-dir=$HOME/Projects/dotfiles --work-tree=$HOME/.config'
fish_add_path /opt/local/bin/ /Applications/MacPorts/EmacsMac.app/Contents/MacOS/bin/
set -Ux LD_LIBRARY_PATH /opt/local/lib/ /opt/local/lib/gcc12/
set -Ux EDITOR "vim"
source /opt/local/share/fzf/shell/key-bindings.fish
status --is-interactive; and jenv init - | source
