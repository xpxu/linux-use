NOTES
====


##### 1. /bin/sh -c *cmd* *parameter*

含义：从-c 后读入命令，用sh来执行。
示例： /bin/sh -c cat /etc/log.conf

##### 2. stick bit
stciky一般只用在目录上，用在文件上起不到什么作用。
总结如下：如果某个目录设置了sticky bit（是在other用户的权限上设置的，设置后可执行位从x变成了t），那么用户在该目录下可以创建文件（当然前提是用户具有写权限和可执行权限，如果具有可执行权限，设置sticky bit后是t；如果没有可执行权限的话，设置sticky bit后是T），而且可以删除自己创建的文件，但是，不能删除其他用户创建的文件，这样就起到了一种保护作用了。

#### 3. 文件的三种标志（setuid/setgid/sticky)
* setuid

>chmod u+s temp -- 为temp文件加上setuid标志. (setuid,设置uid，只对文件有效)

作用： 设置使文件在执行阶段具有文件所有者的权限. 典型的文件是 /usr/bin/passwd. 如果一般用户执行该文件, 则在执行过程中, 该文件可以获得root权限, 从而可以更改用户的密码.

* setgid

>chmod g+s tempdir -- 为tempdir目录加上setgid标志 (setgid，设置gid，只对目录有效)

作用： 该权限只对目录有效. 目录被设置该位后, 任何用户在此目录下创建的文件都具有和该目录所属的组相同的组.

* sticky

>chmod o+t temp -- 为temp目录加上sticky标志 (sticky，设置oid，一般只用于目录)

作用： 见 [stick bit](##### 2. stick bit)
