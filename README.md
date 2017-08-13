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

## BBR

* **说明：Debian/Ubuntu开启TCP BBR拥塞算法**
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

* [**【强制模式】预览**] (https://ws1.sinaimg.cn/large/005YWgzely1fiib21ccgsj30hu05aglo.jpg)
