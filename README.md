初始一台服务器 
==============  

# install 
    yum install -y epel-release
   	yum install -y git
	yum install -y sudo
	yum install -y zsh
	yum install -y lrzsz
	yum install -y strace
	yum install -y htop
	yum install -y ack
	yum install -y dos2unix
	yum install -y screen
	yum install -y cscope
	yum install -y boost
	yum install -y python-setuptools python python-devel
	easy_install pip && pip install virtualenv
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

# install redis
	yum install -y redis
	service redis start

# install mariadb
	yum install -y mariadb-server mariadb-devel mariadb-libs
	service mariadb start

# install nginx
	yum install -y nginx
  	service nginx start
  	systemctl enable nginx

# install flask

# install ssh key 
	A --> B
	A:
		ssh-keygen
		ssh-copy-id root@112.74.206.48
	B:
		/etc/ssh/sshd_config
		RSAAuthentication yes
　　    PubkeyAuthentication yes
　　    AuthorizedKeysFile .ssh/authorized_keys
	
		service sshd restart
		cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
		chmod 700 ~/.ssh
        chmod 600 ~/.ssh/authorized_keys

# install vim
    yum erase vim-enhanced vim-common vim-minimal vim-filesystem -y

	####### lua #######
	yum install -y lua-devel ncurses-devel
	wget http://luajit.org/download/LuaJIT-2.0.4.tar.gz
	tar -xzvf LuaJIT-2.0.4.tar.gz
	cd LuaJIT-2.0.4
	make; make install
	ln -s /usr/local/lib/libluajit-5.1.so.2.0.4 /lib/libluajit-5.1.so.2
	cd ~;rm -rf LuaJIT-2.0.4*

	####### python ######
	wget https://www.python.org/ftp/python/3.4.1/Python-3.4.1.tgz
	tar zxvf Python-3.4.1.tgz
	cd Python-3.4.1
	sudo ./configure --prefix=/usr/local/python3
	sudo make; sudo make install
	ln -s /usr/local/python3/bin/python3 /usr/bin/python3
	cd ~;rm -rf Python-3.4.1*


	yum install -y ruby-devel python-devel
    git clone https://github.com/vim/vim.git
    cd vim
    ./configure --prefix=/usr --with-features=huge --with-luajit --enable-luainterp=yes --enable-fail-if-missing --disable-selinux --enable-pythoninterp --with-python-config-dir=/usr/bin/python2.7-config --enable-cscope --enable-multibyte
    make VIMRUNTIMEDIR=/usr/share/vim/vim74
    make install
    cd ~;rm -rf vim

    curl https://j.mp/spf13-vim3 -L > spf13-vim.sh && sh spf13-vim.sh    
    source ~/.zshrc

