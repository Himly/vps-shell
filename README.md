# vps-shell
个人收集的一些关于VPS的一键脚本

## 使用方法

### 基本库安装

* **CentOS**
```bash
yum -y updade
yum -y install wget
```

* **Debian/Ubuntu**
```bash
apt-get -y update
apt-get -y install wget
```

## BBR.sh

* **说明：Debian/Ubuntu 开启 TCP BBR 拥塞算法**
* **安装**
```bash
wget --no-check-certificate -qO 'BBR.sh' 'https://raw.githubusercontent.com/Himly/vps-shell/master/BBR.sh' && chmod a+x BBR.sh
```

* **使用说明**
```bash
#普通模式,最后需要按下回车才会重启
bash BBR.sh

#强制模式,全自动(如果中间不报错),不需要按下回车
bash BBR.sh -f

#指定安装内核版本,以4.11.9为例
bash BBR.sh -f v4.11.9
```

* **检测**
```bash
#重启后运行以下命令,结果不为空,则开启BBR成功
lsmod |grep 'bbr'
```

* [**【强制模式】预览**](https://ws1.sinaimg.cn/large/005YWgzely1fiib21ccgsj30hu05aglo.jpg)

## BBR_POWERED.sh

* **说明**：Debian/Ubuntu TCP BBR 改进版/增强版
* **准备**

  使用前,请确认能够开启BBR.

  可参考: [Debian/Ubuntu 开启 TCP BBR 拥塞算法](https://github.com/Himly/vps-shell/blob/master/README.md#bbrsh)
* **安装**
```bash
wget --no-check-certificate -qO 'BBR_POWERED.sh' 'https://raw.githubusercontent.com/Himly/vps-shell/master/BBR_POWERED.sh' && chmod a+x BBR_POWERED.sh && bash BBR_POWERED.sh
#注意:执行此命令会自动重启.
```

* **指定内核版本(以v4.11.9内核版本为例)**
```bash
wget --no-check-certificate -qO 'BBR_POWERED.sh' 'https://raw.githubusercontent.com/Himly/vps-shell/master/BBR_POWERED.sh' && chmod a+x BBR_POWERED.sh && bash BBR_POWERED.sh -f v4.11.9
```

* **说明**

执行过程中会重新编译模.

模块默认为开机自动加载.

模块名称:*tcp_bbr_powered*.

可用 `modprobe tcp_bbr_powered` 命令进行加载模块.

可执行 `lsmod |grep 'bbr_powered'` ，结果不为空,则加载模块成功.

可执行 `sysctl -w net.ipv4.tcp_congestion_control=bbr_powered` 使用此模块.
