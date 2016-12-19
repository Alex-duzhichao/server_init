初始一台服务器 
==============  

# install 
    yum -y install epel-release
   	yum install -y git
	yum install -y sudo
	yum install -y zsh
	yum install -y lrzsz
	yum install -y strace
	yum install -y htop
	yum install -y ack
	yum install -y dos2unix
	yum groupinstall -y "Development Tools"


#clone git
	cd ~;git clone https://github.com/Alex-duzhichao/server_init.git


# install oh-my-zsh
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
	sed -i 's/^plugins=(.*)/plugins=(git history colored-man-pages)/g' ~/.zshrc
	sed -i 's/^# ENABLE_CORRECTION="true"/ENABLE_CORRECTION="true"/' ~/.zshrc
	echo "source ~/server_init/zsh_alias" >> ~/.zshrc
	dos2unix server_init/zsh_alias
	source ~/.zshrc





find ~/server -name "*.sh" | xargs chmod +x 


# pull git source 
	git clone https://github.com/Alex-duzhichao/server.git;find ~/server -name "*.sh" | xargs chmod +x ;

# install oh-my-zsh 
	sh ~/server/shell/install_zsh.sh

# install vim
	sh ~/server/shell/install_vim.sh

# install zookeeper
	sh ~/server/shell/install_zookeeper.sh

#install redis
	sh ~/server/shell/install_redis.sh