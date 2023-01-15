function fish_greeting
    type --quiet cowsay
    set -l cs $status
    type --quiet fortune
    set -l ff $status
    if test $cs -eq 0 -a $ff -eq 0
        set -l cols (tput cols)
        fortune | cowsay -W $(math $cols - 10)
        echo \n
    else
        echo "Come to the darkside, my son. There is no fortune out there, the cow says."
    end
end
