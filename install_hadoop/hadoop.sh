#!/bin/sh
INSTALL_LOG="/tmp/Hadoop_install.log"
export INSTALL_LOG

Hadoop1=192.168.3.72
Hadoop2=192.168.3.73
hadoop3=192.168.3.235

CURRENT_DIR=$(pwd)
RED_COLOE='\E[31m'
GREEN_COLOR='\E[32m'
YELLOW_COLOR='\E[33m'
BLUE_COLOR='\E[34m'

REDB_COLOE='\E[1;31m'
GREENB_COLOR='\E[1;32m'
YELLOWB_COLOR='\E[1;33m'
BLUEB_COLOR='\E[1;34m'

RES='\E[0m'

log_info() {
    echo -e "${GREEN_COLOR}$1${RES}"
}

log_info_wait() {
    echo -en "${GREEN_COLOR}$1${RES}"
}

log_error() {
    echo -e "${REDB_COLOE}$1${RES}"
}

log_success() {
    echo -e "${GREENB_COLOR}$1${RES}"
}

clean_up() {
    rm -rf ${BUILD}
    exit 1
}

die() {
    log_error "$1"
    clean_up
}
check_result() {
    if [ $? -eq 0 ]; then
        log_success " [OK]"
    else
        die " [FAIL]"
    fi
}
# add_hosts
add_hosts()
{
    echo -e "\033[32;49;1m [----------------add hosts begin--------------] \033[39;49;0m"
    echo "`date` add hosts begin--------------" >> ${INSTALL_LOG} 2>&1
    echo ${Hadoop1} hadoop1 >>/etc/hosts	
    check_result
    echo ${Hadoop2} hadoop2 >>/etc/hosts	
    echo ${Hadoop3} hadoop3 >>/etc/hosts	
    scp /etc/hosts hadoop2:/etc/hosts
    check_result
    scp /etc/hosts hadoop3:/etc/hosts
    check_result
    ping  -c  3  hadoop3
    check_result
    echo -e "\033[32;49;1m [-----------------add hosts end---------------] \033[39;49;0m"
    echo "`date` add hosts end--------------" >> ${INSTALL_LOG} 2>&1
}

install_jdk()
{
    echo -e "\033[32;49;1m [----------------install jdk begin--------------] \033[39;49;0m"
    echo "`date`install jdk begin--------------" >> ${INSTALL_LOG} 2>&1
    mkdir -p /opt/java
    cd /opt/java
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u144441-linux-x64.tar.gz"
    tar zxvf jdk-8u144441-linux-x64.tar.gz
    check_result
    echo export JAVA_HOME=/opt/java/jdk1.8.0_141 >>/etc/profile
    echo export CLASSPATH=$:CLASSPATH:$JAVA_HOME/lib/ >>/etc/profile
    echo export PATH=$PATH:$JAVA_HOME/bin >>/etc/profile
    scp  -r /opt/java hadoop2:/opt
    scp /etc/profile hadoop2:/etc/profile
    scp  -r /opt/java hadoop3:/opt
    scp /etc/profile hadoop3:/etc/profile
    rm -f jdk-*.tar.gz
    echo -e "\033[32;49;1m [-----------------install jdk end---------------] \033[39;49;0m"
    echo "`date` install jdk  end--------------" >> ${INSTALL_LOG} 2>&1
}

install_hadoop()
{
    echo -e "\033[32;49;1m [----------------install hadoop begin--------------] \033[39;49;0m"
    echo "`date`install hadoop begin--------------" >> ${INSTALL_LOG} 2>&1
    cd /usr/local/
    wget http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.8.0/hadoop-2.8.0.tar.gz
    check_result
    tar zxvf hadoop-2.8.0.tar.gz
    mkdir -p /root/hadoop/tmp
    mkdir -p /root/hadoop/var
    mkdir -p /root/hadoop/dfs
    mkdir -p /root/hadoop/dfs/name
    mkdir -p /root/hadoop/dfs/data
    scp /root/hadoop hadoop2:/root
    scp /root/hadoop hadoop3:/root
    rm -f hadoop-*.tar.gz
    cd ${CURRENT_DIR}
    yes|cp -r etc /usr/local/hadoop-2.8.0/
    scp -r etc hadoop2:/usr/local/hadoop-2.8.0/
    scp -r etc hadoop3:/usr/local/hadoop-2.8.0/
    echo -e "\033[32;49;1m [-----------------install hadoop end---------------] \033[39;49;0m"
    echo "`date` install hadoop  end--------------" >> ${INSTALL_LOG} 2>&1
}

start_hadoop()
{
    echo -e "\033[32;49;1m [----------------start hadoop begin--------------] \033[39;49;0m"
    echo "`date`start hadoop begin--------------" >> ${INSTALL_LOG} 2>&1
    cd /usr/local/hadoop-2.8.0/bin
    systemctl   stop   firewalld.service
     ./hadoop  namenode  -format >> ${INSTALL_LOG} 2>&1
    cd /usr/local/hadoop-2.8.0/sbin
    ./start-all.sh
    echo -e "\033[32;49;1m [-----------------start hadoop end---------------] \033[39;49;0m"
    echo "`date` start hadoop  end--------------" >> ${INSTALL_LOG} 2>&1

}
install_hadoop()
{
    add_hosts
    install_jdk
    install_hadoop
    start_hadoop
}
install_haoop
