# Aliases to comma functions
alias cssh=',cssh'
alias ssh=',ssh'

# Comma aliases (some might become functions)
alias ,common='comm -12'
alias ,diskusage='du -sm $(for i in /*; do grep -q "^[^ ]* $i " /proc/mounts || echo $i; done) | sort -n'
alias ,git-commit-all='git commit -a'
alias ,git-diff-last='git diff HEAD^ HEAD'
alias ,git-history='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias ,git-pull-origin-master='git pull origin master'
alias ,git-reset-hard='git reset --hard @{u}'
alias ,git-restore='git checkout HEAD --'
alias ,git-squash='git rebase -i origin/master'
alias ,git-submodule-update-init-recursive='git submodule update --init --recursive'
alias ,git-submodule-update-remote-merge='git submodule update --remote --merge'
alias ,git-undo-commit='git reset --soft HEAD^'
alias ,ld_library_path_cwd='LD_LIBRARY_PATH=.'
alias ,ls_bind_mounts='findmnt | grep "\["'
alias ,pwgen='echo $(tr -dc A-Za-z0-9 < /dev/urandom | head -c$(tput cols))'
alias ,rot13='tr 'A-Za-z0-9' 'N-ZA-Mn-za-m5-90-4''
alias ,showcrons='find /var/spool/cron/ /etc/cron.d/ /etc/cron.hourly/ /etc/cron.daily/ /etc/cron.weekly/ /etc/cron.monthly/ /etc/crontab -type f -exec cat {} \;'
alias ,whatismyip='dig +short myip.opendns.com @resolver1.opendns.com'

# BEGIN EXCLUDE
alias ,edit_profile='vim "$COMMA_PROFILEDIR"'
alias ,moonphase='/usr/bin/curl https://wttr.in/?format=%m; echo'
alias ,weather='/usr/bin/curl https://wttr.in'
# END EXCLUDE
