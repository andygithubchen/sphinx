*sphinx的一些整理和相关资料的收集*
---
### 1. 文件说明
<pre>
.
├── csft.conf     | 对里面的英文注释做了翻译和整理
├── install.sh    | sphinx和coreseek的自动安装脚本
├── README.md
├── sphinxapi.php | sphinx php客户端，用这个就不需要安装PHP的sphinx扩展了
└── t.php         | 测试文件
</pre>


### 2. sphinx 配置文件 csft.conf 的结构
```shell
source 源名称1{
  #添加数据源，这里会设置一些连接数据库的参数比如数据库的IP、用户名、密码等
  #设置sql_query、设置sql_query_pre、设置sql_query_range等后面会结合例子做详细介绍
}
source 源名称2 : 源名称1 {
  #源也可以继承
}

#---------------------------------------
index 索引名称1{
  Source=源名称1
  #设置全文索引
}
index 索引名称2 : 索引名称1 {
  #索引也可以继承
}

#---------------------------------------
indexer{
  #设置Indexer程序配置选项，如内存限制等
}

searchd{
  #设置Searchd守护进程本身的一些参数
}
```


### 3. 其他
1. sphinx服务管理
<pre>
/usr/local/coreseek/bin/searchd        # 启动服务
/usr/local/coreseek/bin/searchd --stop # 关闭服务
</pre>


2. 安装完后用命令行测试
<pre>
cd testpack
cat var/test/test.xml  #此时应该正确显示中文
/usr/local/mmseg3/bin/mmseg -d /usr/local/mmseg3/etc var/test/test.xml
/usr/local/coreseek/bin/indexer -c etc/csft.conf --all
/usr/local/coreseek/bin/search -c etc/csft.conf 网络搜索
</pre>

3. 如果出这样的错：
<pre>
/usr/local/coreseek/bin/indexer: error while loading shared libraries:
libmysqlclient.so.20: cannot open shared object file: No such file or directory
就这样：<b>ln -s /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib/</b> (ubuntu)
</pre>

4. 关于增量索引
<pre>
生成增量索引
/usr/local/coreseek/bin/indexer -c /usr/local/coreseek/etc/csft.conf index_new(增量索引)
<br>增量索引和主索引的合并
/usr/local/coreseek/bin/indexer -c /usr/local/coreseek/etc/csft.conf --merge index_master(主索引) index_new(增量索引) --rotate
<br>可以参考的设计思路：https://gist.github.com/ftfniqpl/f96991759ec259a445d4d45cfe716847
</pre>

5. 生成索引
<pre>
生成所有索引
/usr/local/coreseek/bin/indexer -c /usr/local/coreseek/etc/csft.conf --all
/usr/local/coreseek/bin/indexer -c /usr/local/coreseek/etc/csft.conf --all --rotate (若此时searchd守护进程已经启动，那么需要加上—rotate参数)
<br>生成单个索引index_new
/usr/local/coreseek/bin/indexer -c /usr/local/coreseek/etc/csft.conf index_new
</pre>

6. 最强coreseek文档：
<pre>
http://github.tiankonguse.com/doc/sphinx/coreseek_4.0-sphinx_1.11-beta.html
</pre>

7. sphinxclient 类文档：
<pre>
http://php.net/manual/en/class.sphinxclient.php
</pre>

8. mmseg 同义词/复合分词处理
<pre>
http://oohcode.com/2014/07/05/coreseek-manual/
</pre>

9. 注意事项
<pre>
#支持中文时要加上这些，charset_dictpath看自己mmseg实际路径
charset_dictpath = /usr/local/mmseg/etc
charset_type     = zh_cn.utf-8
</pre>

