#!/bin/bash

#wget https://github.com/sphinxsearch/sphinx/archive/2.2.11-release.tar.gz --no-check-certificate
#
##安装sphinx (其实都不用安装这个的)
#rm -fr ./sphinx-2.2.11-release
#tar -zxvf ./2.2.11-release.tar.gz
#cd ./sphinx-2.2.11-release
#./configure --prefix=/usr/local/sphinx/ --with-mysql --enable-id64
#make && make install

#下载coreseek
rm -fr ./coreseek-4.1-beta/
wget -c http://img.phpgay.com//uploads/download/tools/coreseek-4.1-beta.tar.gz
tar -zxvf ./coreseek-4.1-beta.tar.gz

apt-get update
apt-get -y -f install libxml2-dev
apt-get -y -f install libexpat1-dev
apt-get -y -f install expat

#安装mmseg
cd ./coreseek-4.1-beta/mmseg-3.2.14/
./bootstrap    #输出的warning信息可以忽略，如果出现error则需要解决
./configure --prefix=/usr/local/mmseg3
make
make install
cd -

#安装coreseek
cd ./coreseek-4.1-beta/csft-4.1/
sed -i "13s/-Werror //" ./configure.ac
sed -i "61s/AC_PROG_RANLIB/AC_PROG_RANLIB AM_PROG_AR/" ./configure.ac
sed -i "5s/foreign/foreign --add-missing/" ./buildconf.sh #&& automake --foreign \
sed -i "1746s/ExprEval/this->ExprEval/" ./src/sphinxexpr.cpp
sed -i "1777s/ExprEval/this->ExprEval/" ./src/sphinxexpr.cpp
sed -i "1823s/ExprEval/this->ExprEval/" ./src/sphinxexpr.cpp
sh ./buildconf.sh  #输出的warning信息可以忽略，如果出现error则需要解决
sed -i "259s/lexpat/lexpat -liconv/" ./src/Makefile
./configure --prefix=/usr/local/coreseek --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql
sed -i "259s/lexpat/lexpat -liconv/" ./src/Makefile
make
make install
cd -


#mmseg 同义词/复合分词处理
cd /usr/local/mmseg3/etc
/usr/local/mmseg3/bin/mmseg -u unigram.txt
mv thesaurus.txt.uni uni.lib
cd -

#要用python2.x 来执行
python ./coreseek-4.1-beta/mmseg-3.2.14/script/build_thesaurus.py /usr/local/mmseg3/etc/unigram.txt > thesaurus.txt
/usr/local/mmseg3/bin/mmseg -t thesaurus.txt
rm -fr ./thesaurus.txt
mv ./thesaurus.lib /usr/local/mmseg3/etc/




