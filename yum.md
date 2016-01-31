### 1. yum与RPM的比较

```
yum和rpm都可以用来安装rpm包，但是rpm不能处理安装包时的依赖问题。而yum可以解决这个问题。
可以说，yum是rpm的加强版
```


### 2. 如何增加一个new yum repository 

* 通过rpm命令
```
# RPMforge is one of such repository. You can easily configure RPMforge repository for RHEL5 just by running following single RPM command:
rpm -Uhv http://apt.sw.be/packages/rpmforge-release/rpmforge-release-0.3.6-1.el5.rf.i386.rpm
```
* 手动添加或者更改yum repo配置文件
