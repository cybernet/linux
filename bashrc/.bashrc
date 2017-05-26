# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias f2b='fail2ban-client status sshd'
alias rr='service php-fpm stop && service nginx stop && service mysqld stop'
alias f2blist='ipset list fail2ban-sshd'
alias cbe='echo "made by cybernet2u" '

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
