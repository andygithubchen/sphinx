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

#安装mmseg
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

#mmseg 同义词/复合分词处理
cd /usr/local/mmseg3/etc
/usr/local/mmseg3/bin/mmseg -u unigram.txt
mv thesaurus.txt.uni uni.lib
cd -

python ./coreseek-3.2.14/mmseg-3.2.14/script/build_thesaurus.py /usr/local/mmseg3.2/etc/unigram.txt > thesaurus.txt
/usr/local/mmseg3.2/bin/mmseg -t thesaurus.txt
rm -fr ./thesaurus.txt
mv ./thesaurus.lib /usr/local/mmseg3.2/etc/




