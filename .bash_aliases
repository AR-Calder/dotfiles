alias wccount="/home/andrew/Documents/programming_society/wccount.py"
alias shebang='echo "#!/usr/bin/env bash"'
alias minecraft="/home/andrew/Games/Minecraft/Minecraft/minecraft-launcher-2.1.1431/minecraft-launcher.sh"

# Doesn't like quotes all that much :/
alias adda='printf "\n alias %s ">> .bash_aliases'

# Colourized text | usage: print_x "text to colour"
alias print_ok  ='printf "\033[92m%s\033[0m"' # green
alias print_info='printf "\033[94m%s\033[0m"' # blue
alias print_warn='printf "\033[93m%s\033[0m"' # yellow
alias print_crit='printf "\033[91m%s\033[0m"' # red

# copy file contents to clipboard | usage: cpcb <file> or echo "thing" | cpb
alias cpcb='xclip -selection clipboard'
# print clipboard contents | usage pcb
alias pcb='xclip -selection primary -o'

# install a python package for the current user | usage: pipin <package>
alias pipin='pip install --user'

# need a _____ - because I usually forget the name of apropos
# e.g. need screenshot, need "port scanner"
alias need='apropos'
# for a similar reason
# e.g. view filename
alias view='xdg-open'

# Screen capture because that ffmpeg command is too damn long
alias screencap="echo 'capturing screen 1, q to quit...' && ffmpeg -loglevel panic -video_size $(xrandr |grep \* | gawk 'NR==1{print $1}') -framerate 30 -hwaccel auto -f x11grab -i :1.0 screencap-$(date +%F-%H-%M-%S).mp4 && mv screencap* ~/Videos/"
