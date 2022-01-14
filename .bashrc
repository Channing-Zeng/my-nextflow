# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\e[1m\e[32m\u@\h\e[0m\e[0m:\e[1m\e[34m\w\e[0m\e[1;33m\$(git_branch)\e[0m\$" 

export PATH=/home/ec2-user/miniconda/bin/:$PATH
