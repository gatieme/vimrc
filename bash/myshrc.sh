#---------------------
#  for use this shell
#  you should write the next code in you shell.rc file
#  for example ~/.bashrc or ~/.zshrc
#
#   if [ -f $HOME/.myshrc.sh ]; then
#      . $HOME/.myshrc.sh
#   fi
#---------------------



if [ "$BASH" ] && [ "$BASH" != "/bin/sh" ]; then
    PS1="\[\033[0;32m\]\A \[\033[0;31m\]\u\[\033[0;34m\]@\[\033[0;35m\]\h\[\033[0;34m\]:\[\033[00;36m\]\W\[\033[0;33m\] $\[\033[0m\]"
#elif [ "$BASH" != "/bin/zsh" ]; then
#    if [ "`id -u`" -eq 0 ]; then
#      PS1='# '
#    else
#      PS1='$ '
#    fi
fi



#---------------------
# modify by gatieme at 2015-10-06 20:47 for colorful `cat`
# Colored up cat!
# You must install Pygments first
# sudo apt-get install python-pygments
# OR wget https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz#md5=238587a1370d62405edabd0794b3ec4a
#---------------------
alias color_cat='pygmentize -O style=monokai -f console256 -g'
alias CAT='pygmentize -O style=monokai -f console256 -g'


#---------------------
#Show compile message with color when show up error/warning/note using gcc/g++/make
#---------------------
alias gcc="color_compile gcc"
alias g++="color_compile g++"
alias make="color_compile make"

alias arm-linux-gcc="color_compile arm-linux-gcc"
alias arm-linux-g++="color_compile arm-linux-g++"



#---------------------
# use trash-cli instread of rm
#---------------------
alias rm="trash-put"



#---------------------
# chinese
#---------------------
#LANG="zh_CN.UTF-8"
#LANGUAGE="zh_CN:zh"
#---------------------
# english
#---------------------
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"


#---------------------
# use the cman as the man_zh_CN
#---------------------
alias cman='man -M /usr/share/man/zh_CN'



#---------------------
# thefunck see for detaild  https://github.com/nvbn/thefuck
#---------------------
eval "$(thefuck --alias)"
#---------------------
# You can use whatever you want as an alias, like for Mondays:
#---------------------
eval "$(thefuck --alias FUCK)"



#---------------------
# java path
#---------------------
JAVA_HOME=/usr/lib/jvm/java-8-oracle
JRE_HOME=$JAVA_HOME/jre
JAVA_BIN=$JAVA_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export JAVA_HOME JRE_HOME PATH CLASSPATH


#---------------------
# arm-linux-gcc
#---------------------
PATH=$PATH:/opt/arm/arm-linux-gcc/4.5.1/bin
export PATH

#export QMAKESPEC=/opt/arm/qt/qt4.8.0-arm/mkspecs/linux-g++

