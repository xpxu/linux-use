关于跨平台(写sh脚本）

1. shell 脚本的function跨平台兼容

sh 脚本 的function通用用法：（linux,solaris,hp,aix）

check_java(){

}


不能通用的用法：

function check_java(){

}


2. awk，nawk，gawk等的跨平台兼容。

awk命令：老命令，所有平台（hp，aix，solaris，linux）都有。
但是在solaris平台上，该命令功能有限，要用nawk来代替。
nawk： hp平台和linux平台上没有。
gawk：只有linux平台上有。

解决办法:
1. solaris 平台上使用nawk。
2. 其他平台使用awk命令。


3. echo -n 命令的兼容：echo之后不转行。
if [ `uname -s` = "Linux" ];then
    _echo="echo -e"
else
    _echo="echo"
fi
$_echo "Enter a number: \c"


4. export环境变量时分成两行来写。
CLASSPATH=./console_install.jar:$CLASSPATH
export CLASSPATH

5. 判断文件存在
solaris 没有 -e。只能用-f。

6. 关于输入密码隐藏
$_echo "Enter Password: \c"
stty -echo
read password
stty echo
