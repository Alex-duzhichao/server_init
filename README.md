初始一台服务器 
==============  

# install 
    yum install -y epel-release
   	yum install -y git
	yum install -y sudo
	yum install -y zsh
	yum install -y tree
	yum install -y lrzsz
	yum install -y strace
	yum install -y htop
	yum install -y ack
	yum install -y dos2unix
	yum install -y screen
	yum install -y cscope
	yum install -y boost boost-devel
	yum install -y valgrind
	#yum install -y cmake;mv /usr/bin/cmake /usr/bin/cmake28
	yum install -y cmake3;sudo ln -s /usr/bin/cmake3 /usr/bin/cmake
	yum install -y iotop
	yum install -y nc
	yum install -y python-setuptools python python-devel
	easy_install pip && pip install virtualenv
	pip install redis
	yum install -y java java-devel
	yum groupinstall -y "Development Tools"
	sysctl -w kernel.core_pattern=core.%e.%p.%t
	ulimit -c unlimited
	echo "ulimit -S -c unlimited > /dev/null 2>&1" >> /etc/profile



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

        tail -f /var/log/secure

# mkswap 
	dd if=/dev/zero of=/swap-file bs=1M count=4096
	swapon /swap-file
	swapon -s
	cat "UUID=eabee907-f4b0-4bbd-a316-57c8b7e812e4 swap                    swap    defaults        0 0" >> /etc/fstab

#install go
	cd /usr/local/
	wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
	tar -zxvf go1.6.2.linux-amd64.tar.gz 
	rm go1.6.2.linux-amd64.tar.gz 
	mkdir /usr/local/go/goPath
	echo "export GOROOT=/usr/local/go" >> /etc/profile
	echo "export GOPATH=/usr/local/go/goPath" >> /etc/profile
	echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> /etc/profile
	source /etc/profile && tail -n 3 /etc/profile
	go version
	go get -u github.com/tools/godep && which godep

# install zookeeper 3.4.9
	cd /data
	wget http://mirrors.hust.edu.cn/apache/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
	tar -zxvf zookeeper-3.4.9.tar.gz
	rm zookeeper-3.4.9.tar.gz 
	cd /data/zookeeper-3.4.9
	cp -fp /data/zookeeper-3.4.9/conf/zoo_sample.cfg /data/zookeeper-3.4.9/conf/zoo.cfg
	bin/zkServer.sh start
	bin/zkServer.sh status

# install codis2.0
	go get -u github.com/tools/godep && which godep
	mkdir -p $GOPATH/src/github.com/CodisLabs
	cd $_ && git clone https://github.com/CodisLabs/codis.git -b release2.0
	cd $GOPATH/src/github.com/CodisLabs/codis ; make ; ls bin/

	sed -i 's/zk=192.168.0.123:2181/zk=127.0.0.1:2181/' /usr/local/go/goPath/src/github.com/CodisLabs/codis/config.ini
	sed -i 's/dashboard_addr=192.168.0.123:18087/dashboard_addr=0.0.0.0:18087/' /usr/local/go/goPath/src/github.com/CodisLabs/codis/config.ini

	nohup bin/codis-config dashboard &> config_nohup.log & 
	bin/codis-config slot init

	mkdir /usr/local/go/goPath/src/github.com/CodisLabs/codis/codis_dir
	cp -fp ~/server_init/create_codis_conf.sh /usr/local/go/goPath/src/github.com/CodisLabs/codis/codis_dir
	cp -fp ~/server_init/start_codis.sh /usr/local/go/goPath/src/github.com/CodisLabs/codis/codis_dir
	cp -fp ~/server_init/stop_codis.sh /usr/local/go/goPath/src/github.com/CodisLabs/codis/codis_dir
	chmod +x /usr/local/go/goPath/src/github.com/CodisLabs/codis/codis_dir/*.sh

	cd /usr/local/go/goPath/src/github.com/CodisLabs/codis
	bin/codis-config server add 1 127.0.0.1:7000 master
	bin/codis-config server add 2 127.0.0.1:7001 master
	bin/codis-config slot range-set 0 511 1 online
	bin/codis-config slot range-set 512 1023 2 online

	
	nohup bin/codis-proxy -L proxy.log  --cpu=1 --addr=0.0.0.0:7000 --http-addr=0.0.0.0:11000 &> proxy_nohup.log &

# install jenkins
	sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum install -y jenkins
    service jenkins start

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

