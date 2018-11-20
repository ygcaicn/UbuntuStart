#!/usr/bin/env bash
# Color
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

echo -e  "${yellow}"
echo "#######################################################################"
echo "#                          Start to configurate!                      #"
echo "#                                 V 1.0.0                             #"
echo "#                                              by Jachin.             #"
echo "#######################################################################"
echo -e  "${plain}"





# 需要sudo来执行
dir=`pwd`
if [ ! -d "${dir}/downloads" ]; then
  mkdir ${dir}/downloads
fi
downdir="${dir}/downloads"

get_pid(){
  ps aux | grep -v grep | grep \${1} | awk '{print \$2}'
}


function rootness {
[[ $EUID -ne 0 ]] && echo -e  "[${red}Error 255${plain}] This script must be run as root!\n${green}Maybe you want \"sudo ./setup.sh\"${plain}" && exit 1
echo -e "[${yellow}root access!${plain}]"
}
pre_install(){
    echo -e "${green}install wget...${plain}"
    type wget &> /dev/null
    [[ $? -eq 0 ]] && apt-get update && apt-get install -y wget
}
add_repo(){
echo -e "${green}add repo googleChrome at /etc/apt/sources.list.d/google-chrome.list...${plain}"
cat<<EOF > /etc/apt/sources.list.d/google-chrome.list
deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main
deb [arch=amd64] https://repo.fdzh.org/chrome/deb/ stable main
EOF
wget -q  -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

#vscode
echo -e "${green}add repo vscode at /etc/apt/sources.list.d/vscode.list...${plain}"
cat<<EOF > /etc/apt/sources.list.d/vscode.list
deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main
EOF
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
}

function change_mirror {
  echo -e "${green}change_mirror...${plain}"
  t=$(date +%y%m%d+%H%M%S)
  cp /etc/apt/sources.list /etc/apt/sources.list.${t}
  sed -e --follow-symlinks 's/http:\/\/us.archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
  sed -e --follow-symlinks 's/http:\/\/cn.archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
}

function apt_conf {
echo -e "${green}apt update...${plain}"
apt-get clean
apt-get autoclean
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
}

function flash_conf {
  echo -e "${green}install flash...${plain}"
  apt-get -y install flashplugin-nonfree
  update-flashplugin-nonfree --install
}

function install_something {
  echo -e "${green}install some basics software...${plain}"
  apt-get install wget vim git fcitx-sunpinyin tweak chrome-gnome-shell google-chrome-stable guake net-tools fcitx fcitx-ui-qimpanel fcitx-config-common fcitx-googlepinyin  rar unzip unrar  libgconf2-4 software-properties-common apt-transport-https -y

  #guake auto start
cat<<EOF > $HOME/.config/autostart/guake.desktop
  [Desktop Entry]
  Type=Application
  Exec=/usr/bin/guake
  Hidden=false
  NoDisplay=false
  X-GNOME-Autostart-enabled=true
  Name[en_US]=Guake
  Name=Guake
  Comment[en_US]=
  Comment=
EOF
}

function remove_something {
  echo -e "${green}remove_something...${plain}"
  apt-get remove fcitx-ui-classic -y
  apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku landscape-client-ui-install libreoffice-common -y
}
add_alias(){
echo -e "${green}add_alias...${plain}"
cat ${dir}/conf/.bash_aliases > ${HOME}/.bash_aliases
}
_install_Docker(){
  echo -e "${green}Install Docker...${plain}"
  apt-get remove -y docker docker-engine docker.io
  apt-get update
  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

#add-apt-repository \
#    "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
#    $(lsb_release -cs) \
#    stable"

   apt-get update
   apt-get install docker-ce -y

  if [ ! -d "/etc/docker" ]; then
    mkdir -p /etc/docker
  fi

  \cp -fr ${dir}/conf/daemon[etc_docker_daemon].json /etc/docker/daemon.json
   systemctl enable docker
   systemctl start docker
   groupadd docker
   usermod -aG docker $USER
}

install_Tim(){
_install_Docker
echo -e "${green}Install TIM...${plain}"
if [ ! -d "${HOME}/opt" ]; then
  mkdir ${HOME}/opt
fi
home=$(echo ${HOME} | sed -e 's/\//\\\//g')
ee="s/\$HOME/${home}/g"
sed -e $ee ${dir}/conf/TIM.desktop > ${HOME}/.local/share/applications/TIM.desktop
cat ${dir}/conf/qq.sh > ${HOME}/opt/qq.sh
chmod +x ${HOME}/opt/qq.sh
cp ${HOME}/conf/tim.png ${HOME}/.local/share/icons/Papirus/scalable/apps/tim.png
}
install_Third(){

  # vscode
  echo -e "${green}install vscode...${plain}"
  apt install code

  # FoxitReader
  echo -e "${green}install FoxitReader...${plain}"
  foxitsoftwareLink="http://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/linux/2.x/2.4/en_us/FoxitReader.enu.setup.2.4.4.0911.x64.run.tar.gz"
  foxitsoftwareName="foxit.tar.gz"
  #wget -O ${downdir}/${foxitsoftwareName} -c ${foxitsoftwareLink}
  axel -n 100 --output=${downdir}/${foxitsoftwareName} ${foxitsoftwareLink}
  pushd ${downdir}/
  tar -zxvf ${foxitsoftwareName}
  popd
  foxitt_run=`ls ${downdir}/${foxitsoftwareName}/FoxitReader*.run`
  mv foxitt_run ${downdir}/${foxitsoftwareName}/FoxitReader.run
  ${downdir}/${foxitsoftwareName}/FoxitReader.run

  # WPS
  echo -e "${green}install WPS...${plain}"
  wpsLink="http://kdl.cc.ksosoft.com/wps-community/download/6757/wps-office_10.1.0.6757_amd64.deb"
  wpsName="wps.deb"
  #wget -O ${downdir}/${wpsName} -c ${wpsLink}
  axel -n 100 --output=${downdir}/${wpsName} ${wpsLink}
  dpkg -i ${downdir}/${wpsName}

  # Proxyee
  echo -e "${green}install Proxyee...${plain}"
  ProxyeeLink="https://github.com/proxyee-down-org/proxyee-down/releases/download/3.4/proxyee-down-main.jar"
  ProxyeeName="proxyee-down-main.jar"
  #wget -O ${downdir}/${ProxyeeName} -c ${ProxyeeLink}
  axel -n 100 --output=${downdir}/${ProxyeeName} ${ProxyeeLink}
  mkdir $HOME/opt/proxyee
  cp ${downdir}/${ProxyeeName} $HOME/opt/proxyee/
  chmod +x $HOME/opt/proxyee/${ProxyeeName}

  apt-get install openjdk-8-jre openjfx -y

  # CLion
  echo -e "${green}install CLion...${plain}"
  clionLink="https://download.jetbrains.8686c.com/cpp/CLion-2018.2.6.tar.gz"
  clionName="clion.tar.gz"
  #wget -O ${downdir}/${clionName} -c ${clionLink}
  axel -n 100 --output=${downdir}/${clionName} ${clionLink}
  cp ${downdir}/${clionName} ${HOME}/opt/
  pushd ${HOME}/opt/
  tar -zxvf ${clionName}
  cli=`ls | grep clion`
  chmod +x ${HOME}/opt/${cli}/bin/clion.sh
  ${HOME}/opt/${cli}/bin/clion.sh &
  popd
  rm -rf ${HOME}/opt/${clionName}

  #pycharmPro
  echo -e "${green}install pycharmPro...${plain}"
  pycharmLink="https://download.jetbrains.8686c.com/python/pycharm-professional-2018.2.5.tar.gz"
  pycharmName="pycharmPro.tar.gz"
  #wget -O ${downdir}/${pycharmName} -c ${pycharmLink}
  axel -n 100 --output=${downdir}/${pycharmName} ${pycharmLink}
  cp ${downdir}/${pycharmName} ${HOME}/opt/
  pushd ${HOME}/opt/
  tar -zxvf ${pycharmName}
  pyc=`ls | grep pycharm`
  chmod +x ${HOME}/opt/${cli}/bin/pycharm.sh
  ${HOME}/opt/${cli}/bin/pycharm.sh &
  popd
  rm -rf ${HOME}/opt/${pycharmName}


  chown -R $USER:$USER $HOME/opt/
}

install_Fonts(){
  echo -e "${green}install Fonts...${plain}"
  mkfontscale
  mkfontdir
  fc-cache -fv
}

install_all(){
  add_repo
  change_mirror
  apt_conf
  flash_conf
  install_something
  remove_something
  install_Tim
  add_alias
  install_Third
  install_Fonts

# 变量不替换
grep get_pid ${HOME}/.bashrc &> /dev/null
[[ $? -eq 1 ]] &&
cat<<"EOF" >> ${HOME}/.bashrc
get_pid(){
  ps aux | grep -v grep | grep ${1} | awk '{print $2}'
}
dkill_qq(){
  docker container ls -al | awk 'NR!=1 && $2 ~ /qq/ {print $1}' | xargs  docker container stop
}
EOF


# 变量替换
grep start_qq ${HOME}/.bashrc &> /dev/null
[[ $? -eq 1 ]] &&
cat<<EOF >> ${HOME}/.bashrc
start_qq(){
    docker container run -d --name qq --rm \
    --device /dev/snd \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v $HOME/TencentFiles:/TencentFiles \
    -v $HOME:/home\
    -e DISPLAY=unix$DISPLAY \
    -e XMODIFIERS=@im=fcitx \
    -e QT_IM_MODULE=fcitx \
    -e GTK_IM_MODULE=fcitx \
    -e AUDIO_GID=`getent group audio | cut -d: -f3` \
    -e VIDEO_GID=`getent group video | cut -d: -f3` \
    -e GID=`id -g` \
    -e UID=`id -u` \
    bestwu/qq:office
}
EOF

}

rootness
pre_install
install_all

echo -e  "${yellow}"
echo "#######################################################################"
echo "#               FINISH, Have enjoy it!!!!!!!!!                        #"
echo "#######################################################################"
echo -e  "${plain}"
