#!/bin/bash

wget https://github.com/sphinxsearch/sphinx/archive/2.2.11-release.tar.gz --no-check-certificate

#安装sphinx
rm -fr ./sphinx-2.2.11-release
tar -zxvf ./2.2.11-release.tar.gz
cd ./sphinx-2.2.11-release
./configure --prefix=/usr/local/sphinx/ --with-mysql --enable-id64
make && make install

#下载coreseek
rm -fr ./coreseek-3.2.14/
wget http://pppboy.com/wp-content/uploads/2016/02/coreseek-3.2.14.tar.gz
tar -zxvf ./coreseek-3.2.14.tar.gz

apt-get update
apt-get -f install libxml2-dev
apt-get -f install libexpat1-dev
apt-get -f install expat

##安装mmseg
cd ./coreseek-3.2.14/mmseg-3.2.14/
./bootstrap    #输出的warning信息可以忽略，如果出现error则需要解决
./configure --prefix=/usr/local/mmseg3
make && make install
cd -

#安装coreseek
cd ./coreseek-3.2.14/csft-3.2.14/
sed -i "1080s/ExprEval/this->ExprEval/" ./src/sphinxexpr.cpp
sed -i "1013s/ExprEval/this->ExprEval/" ./src/sphinxexpr.cpp
sed -i "1047s/ExprEval/this->ExprEval/" ./src/sphinxexpr.cpp
./buildconf.sh  #输出的warning信息可以忽略，如果出现error则需要解决
./configure --prefix=/usr/local/coreseek --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql
make && make install
cd -




##测试
#cd testpack
#cat var/test/test.xml  #此时应该正确显示中文
#/usr/local/mmseg3/bin/mmseg -d /usr/local/mmseg3/etc var/test/test.xml
#/usr/local/coreseek/bin/indexer -c etc/csft.conf --all
#/usr/local/coreseek/bin/search -c etc/csft.conf 网络搜索

# 如果出这样的错：
#/usr/local/coreseek/bin/indexer: error while loading shared libraries: libmysqlclient.so.20: cannot open shared object file: No such file or directory
#就这样：ln -s /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib/




#/usr/local/coreseek/bin/indexer -c /usr/local/coreseek/etc/csft.conf --all  #生成索引（所有的）
#/usr/local/coreseek/bin/indexer -c /usr/local/coreseek/etc/csft.conf bt     #生成索引（只是生成bt这个源的）

##服务(给PHP客户端用的）
#/usr/local/coreseek/bin/searchd        # 启动服务
#/usr/local/coreseek/bin/searchd --stop # 关闭服务


#增量索引?
