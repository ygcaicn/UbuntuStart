alias sourcea='source ~/.bashrc'
m_basedir='/media/jachin/Software'
#cd
alias pydir='cd ${m_basedir}/python'
alias soft='cd ${m_basedir}'
alias gitdir='cd ${m_basedir}/Github'
alias app='cd /home/jachin/app'

#python3 -m venv
alias pyvenv='python3 -m venv'
alias pyenv='pydir && source ./ENV/bin/activate'

#atom
alias atoma='atom -a'

#blog
alias blogdir='cd ${m_basedir}/Github/blog-hexo'
alias blog='pushd ${m_basedir}/Github/blog-hexo && atom -a ./  && popd'
alias blogd='pushd ${m_basedir}/Github/blog-hexo && hexo d -g  && popd'
alias blogs='pushd ${m_basedir}/Github/blog-hexo && hexo generate && hexo server -s && popd'
alias blogclean='pushd ${m_basedir}/Github/blog-hexo && hexo clean  && popd'

#aria
alias aria2='aria2c --conf-path=/etc/aria2c/aria2.conf'

#nautilus
alias nau='nautilus ./'

alias sys='gnome-system-monitor &'

#vpn
alias vpn='systemctl start v2ray'
alias vps='ssh root@167.99.63.28'
alias setproxy='export ALL_PROXY=socks5://127.0.0.1:1080'
alias unsetproxy='unset ALL_PROXY'
alias myip='curl -i http://ip.cn'

alias vpsc='ssh jachin@47.104.239.112'
alias reload_app='ssh jachin@47.104.239.112 "touch /home/nginx/myapp/reload"'
alias source_activate='source activate'
alias source_deactivate='source deactivate'

#apt upgrade
alias apt-upgrade='sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y autoremove'
