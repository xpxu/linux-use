### 1. Active Internet connections & Active UNIX domain sockets

**KEYWORD : UDS(UNIX DOMAIN SOCKETS)**

#### [查看](http://www.jb51.net/LINUXjishu/152405.html)
```
[root@localhost ~]# netstat
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address Foreign Address State
tcp 0 268 192.168.120.204:ssh 10.2.0.68:62420 ESTABLISHED
udp 0 0 192.168.120.204:4371 10.58.119.119:domain ESTABLISHED
Active UNIX domain sockets (w/o servers)
Proto RefCnt Flags Type State I-Node Path
unix 2 [ ] DGRAM 1491 @/org/kernel/udev/udevd
unix 4 [ ] DGRAM 7337 /dev/log
unix 2 [ ] DGRAM 708823
unix 2 [ ] DGRAM 7539
unix 3 [ ] STREAM CONNECTED 7287
unix 3 [ ] STREAM CONNECTED 7286
[root@localhost ~]#
```

#### 含义

 > 从整体上看，netstat的输出结果可以分为两个部分：
 
 > 一个是Active Internet connections，称为有源TCP连接，其中"Recv-Q"和"Send-Q"指的是接收队列和发送队列。这些数字一般都应该是0。如果不是则表示软件包正在队列中堆积。这种情况只能在非常少的情况见到。
 
 > 另一个是Active UNIX domain sockets，称为有源Unix域套接口(和网络套接字一样，但是只能用于本机通信，性能可以提高一倍)。

#### 异同

 > 一种是网络socket编程，一种是Unix Domain socket编程。

 > 虽然网络socket也可用于同一台主机的进程间通讯（通过loopback地址127.0.0.1），但是UNIX Domain Socket用于IPC更有效率,不需要经过网络协议栈，不需要打包拆包、计算校验和、维护序号和应答等，只是将应用层数据从一个进程拷贝到另一个进程。这是因为，IPC机制本质上是可靠的通讯，而网络协议是为不可靠的通讯设计的。UNIX Domain Socket也提供面向流和面向数据包两种API接口，类似于TCP和UDP，但是面向消息的UNIX Domain Socket也是可靠的，消息既不会丢失也不会顺序错乱。
 
 > UNIX Domain Socket是全双工的，API接口语义丰富，相比其它IPC机制有明显的优越性，目前已成为使用最泛的IPC机制，比如X Window服务器和GUI程序之间就是通过UNIX Domain Socket通讯的。

 > 使用UNIX Domain Socket的过程和网络socket十分相似，也要先调用socket()创建一个socket文件描述符，address family指定为AF_UNIX，type可以选择SOCK_DGRAM或SOCK_STREAM，protocol参数仍然指定为0即可。

 > UNIX Domain Socket与网络socket编程最明显的不同在于地址格式不同，用结构体sockaddr_un表示，网络编程的socket地址是IP地址加端口号，而UNIX Domain Socket的地址是一个socket类型的文件在文件系统中的路径，这个socket文件由bind()调用创建，如果调用bind()时该文件已存在，则bind()错误返回。

