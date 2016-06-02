### 1. yum与rpm的比较

```
yum: client for yum server
rpm: rpm manager in local machine 
```


### 2. 如何增加一个new yum repository 

* 通过rpm命令
```
# RPMforge is one of such repository. You can easily configure RPMforge repository for RHEL5 just by running following single RPM command:
rpm -Uhv http://apt.sw.be/packages/rpmforge-release/rpmforge-release-0.3.6-1.el5.rf.i386.rpm
```
* 手动添加或者更改yum repo配置文件

### 3. 常用命令说明

* yum clean all

  该命令作用是清除yum所有已下载的包文件，和清除yum缓存。
  
  yum（或图形化的软件包管理器）会在安装或升级软件时将下载到的软件包存盘（软件包和header存储在cache中，而不会自动删除），并且不随安装操作的完成而删除（以后执行软件包的重装等操作会较快），但硬盘空间有限，这时就需要将这些软件包删除掉，当然，你也可以指定删除一部分。
  
  如果我们空间不足时，觉得它们占用了磁盘空间，可以使用yum clean指令进行清除，更精确 的用法是：
    ```
    1. yum clean headers 清除header;
    2. yum clean packages 清除下载的rpm包;
    3. yum clean all 一股脑儿端,全清除;
    ```

* yum repolist enabled 列出enabled 的yum repo.

