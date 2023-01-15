set -x LC_ALL pt_BR.UTF-8
set -x LC_CTYPE pt_BR.UTF-8

fish_add_path --path /usr/local/sbin \
    ~/.nodebrew/current/bin \
    ~/.jenv/bin



if status is-interactive
   set -x XDG_CONFIG_HOME "$HOME/.config"
   set -x HOMEBREW_NO_ENV_HINTS 1
   jenv init - | source
end

function ec
    if test \(-n $SSH_CLIENT\) -o \(-n $SSH_TTY\)
        emacsclient -a "" -t $argv
    else
        emacsclient -a "" -c $argv
    end   
end
