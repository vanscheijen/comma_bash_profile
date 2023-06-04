# Aliases to comma functions
alias cssh=',cssh'
alias ssh=',ssh'

# Comma aliases (some might become functions)
alias ,common='comm -12'
alias ,diskusage='du -sm $(for i in /*; do grep -q "^[^ ]* $i " /proc/mounts || echo $i; done) | sort -n'
alias ,git-commit-all='git commit -a'
alias ,git-diff-last='git diff HEAD^ HEAD'
alias ,git-history='git log --graph --decorate --abbrev-commit --date=short --pretty=format:"%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %C(red)%s %C(bold red){{%an}}%C(reset) %C(blue)%d%C(reset)"'
alias ,git-pull-origin-master='git pull origin master'
alias ,git-push-origin-head='git push -u origin `git symbolic-ref --short HEAD`'
alias ,git-reset-hard='git reset --hard @{u}'
alias ,git-reset-to-previous-version='git reset --soft HEAD~1'
alias ,git-rebase-interactive='git rebase -i'
alias ,git-restore='git checkout HEAD --'
alias ,git-squash='git rebase -i origin/master'
alias ,git-submodule-update-init-recursive='git submodule update --init --recursive'
alias ,git-submodule-update-remote-merge='git submodule update --remote --merge'
alias ,git-undo-commit='git reset --soft HEAD^'
alias ,ld_library_path_cwd='LD_LIBRARY_PATH=.'
alias ,ls_bind_mounts='findmnt | grep "\["'
alias ,pwgen='echo $(tr -dc A-Za-z0-9 < /dev/urandom | head -c$(tput cols))'
alias ,reset="echo -e '\033c'; stty sane"
alias ,rot13="tr 'A-Za-z0-9' 'N-ZA-Mn-za-m5-90-4'"
alias ,rot47="tr '!-~' 'P-~!-O'"
alias ,unhide="cat -t"
alias ,showcrons='find /var/spool/cron/ /etc/cron.d/ /etc/cron.hourly/ /etc/cron.daily/ /etc/cron.weekly/ /etc/cron.monthly/ /etc/crontab -type f -exec cat {} \;'
alias ,whatismyip='ip r | grep ^default; dig +short myip.opendns.com @resolver1.opendns.com'

# BEGIN EXCLUDE
alias ,edit_profile='vim "$COMMA_PROFILEDIR"'
alias ,moonphase='curl "https://wttr.in/Moon"'
alias ,weather='curl "https://wttr.in/${COMMA_PROFILELOCATION}"; curl "https://wttr.in/${COMMA_PROFILELOCATION}?format=v2"'
# END EXCLUDE
