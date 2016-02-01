##ifconfig
作用： 来获取网络接口配置信息并对此进行修改

### 1. slc09wqk实验(dev-vm)
* 命令返回的结果
  ```
  docker0   Link encap:Ethernet  HWaddr 56:84:7A:FE:97:99
            inet addr:172.17.42.1  Bcast:0.0.0.0  Mask:255.255.0.0
            inet6 addr: fe80::5484:7aff:fefe:9799/64 Scope:Link
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:147363 errors:0 dropped:0 overruns:0 frame:0
            TX packets:331118 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:23695322 (22.5 MiB)  TX bytes:242639743 (231.3 MiB)
  
  eth0      Link encap:Ethernet  HWaddr 00:21:F6:07:F6:15
            inet addr:10.245.251.161  Bcast:10.245.255.255  Mask:255.255.248.0
            inet6 addr: 2606:b400:2010:6863:221:f6ff:fe07:f615/64 Scope:Global
            inet6 addr: fe80::221:f6ff:fe07:f615/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:158780055 errors:0 dropped:1632009 overruns:0 frame:0
            TX packets:2186698 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000
            RX bytes:135870098855 (126.5 GiB)  TX bytes:961850033 (917.2 MiB)
  
  lo        Link encap:Local Loopback
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:14462 errors:0 dropped:0 overruns:0 frame:0
            TX packets:14462 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:1345881 (1.2 MiB)  TX bytes:1345881 (1.2 MiB)
  
  ```
  
* 结果分析说明
  
  ```
  linux网络设备实例/接口： docker0/eth0/lo。其中docker0是docker创建的网络设实例，eth0是物理网卡的一个网络设备实例，lo是表示主机的回坏地址。

  第一行：连接类型：Ethernet（以太网）HWaddr（硬件mac地址）

  第二行：网卡的IP地址、子网、掩码

  第三行：UP（代表网卡开启状态）RUNNING（代表网卡的网线被接上）MULTICAST（支持组播）MTU:1500（最大传输单元）：1500字节

  第四、五行：接收、发送数据包情况统计

  第七行：接收、发送数据字节数统计信息。
  ```
  
  
### 2. denab855实验(virtual-cluster)
* 命令返回的结果
  ```
  bond0     Link encap:Ethernet  HWaddr 00:10:E0:8A:D5:72
            inet addr:10.89.56.20  Bcast:10.89.59.255  Mask:255.255.252.0
            inet6 addr: fe80::210:e0ff:fe8a:d572/64 Scope:Link
            UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1
            RX packets:135468140 errors:0 dropped:194 overruns:0 frame:0
            TX packets:686495 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:13135427746 (12.2 GiB)  TX bytes:55668233 (53.0 MiB)

  cvif00    Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:32
            RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

  cvif00-emu Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            inet6 addr: fe80::fcff:ffff:feff:ffff/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:20758995 errors:0 dropped:0 overruns:0 frame:0
            TX packets:21862009 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:500
            RX bytes:1919738386 (1.7 GiB)  TX bytes:1971772408 (1.8 GiB)

  cvif01    Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:32
            RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

  cvif01-emu Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            inet6 addr: fe80::fcff:ffff:feff:ffff/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:19980658 errors:0 dropped:0 overruns:0 frame:0
            TX packets:22170308 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:500
            RX bytes:1906884030 (1.7 GiB)  TX bytes:2101726724 (1.9 GiB)

  cvif02    Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:32
            RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
            
  cvif02-emu Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            inet6 addr: fe80::fcff:ffff:feff:ffff/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:18081575 errors:0 dropped:0 overruns:0 frame:0
            TX packets:20093939 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:500
            RX bytes:1685240862 (1.5 GiB)  TX bytes:1811082717 (1.6 GiB)

  docker0   Link encap:Ethernet  HWaddr 56:84:7A:FE:97:99
            inet addr:172.17.42.1  Bcast:0.0.0.0  Mask:255.255.0.0
            inet6 addr: fe80::5484:7aff:fefe:9799/64 Scope:Link
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:146114 errors:0 dropped:0 overruns:0 frame:0
            TX packets:335204 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:7700172 (7.3 MiB)  TX bytes:498582041 (475.4 MiB)

  eth0      Link encap:Ethernet  HWaddr 00:10:E0:8A:D5:72
            UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
            RX packets:135468140 errors:0 dropped:0 overruns:0 frame:0
            TX packets:686495 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000
            RX bytes:13135427746 (12.2 GiB)  TX bytes:55668233 (53.0 MiB)

  lo        Link encap:Local Loopback
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:22855 errors:0 dropped:0 overruns:0 frame:0
            TX packets:22855 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:6940820 (6.6 MiB)  TX bytes:6940820 (6.6 MiB)

  vif10.0   Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            inet6 addr: fe80::fcff:ffff:feff:ffff/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:35064122 errors:0 dropped:0 overruns:0 frame:0
            TX packets:40807714 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:32
            RX bytes:10521153454 (9.7 GiB)  TX bytes:3591295907 (3.3 GiB)

  vif10.0-emu Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            inet6 addr: fe80::fcff:ffff:feff:ffff/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:5830732 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:500
            RX bytes:0 (0.0 b)  TX bytes:249869375 (238.2 MiB)

  xenbr0-admin Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
            inet addr:10.0.0.1  Bcast:0.0.0.0  Mask:255.255.255.0
            inet6 addr: fe80::44d4:27ff:fe97:7287/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:5802847 errors:0 dropped:0 overruns:0 frame:0
            TX packets:36394 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:167975915 (160.1 MiB)  TX bytes:1798174 (1.7 MiB)

  xenbr0-guest Link encap:Ethernet  HWaddr C6:06:FC:9D:AE:1F
            inet addr:10.1.0.1  Bcast:0.0.0.0  Mask:255.255.255.0
            inet6 addr: fe80::c406:fcff:fe9d:ae1f/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
            RX packets:0 errors:0 dropped:0 overruns:0 frame:0
            TX packets:6 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:0 (0.0 b)  TX bytes:468 (468.0 b)

  
  ```
  
  * 结果分析说明
  ```
  该机器返回了包括lo在内的14个网络接口/设备实例。
  ```
