# 1 backup.sh 特点：
1. 支持 MySQL/MariaDB/Percona 的数据库全量备份或选择备份；
2. 支持指定目录或文件的备份；
3. 支持加密备份文件（需安装 openssl 命令，可选）；
4. 支持上传至 Google Drive（需先安装 rclone 并配置，可选）；
5. 支持在删除指定天数本地旧的备份文件的同时，也删除 Google Drive 上的同名文件（可选）。

**2023 年 9 月 8 日更新：**
- 修复 `openssl` 的加密、解密命令

---

# 2 使用教程
1. 下载该脚本并赋予执行权限
```bash
wget --no-check-certificate https://raw.githubusercontent.com/Himly/vps-shell/master/website/backup.sh
chmod +x backup.sh
```

2. 修改并配置脚本
```bash
nano ./backup.sh
```

**关于变量名的一些说明：**

> - `ENCRYPTFLG` （加密FLG，true 为加密，false 为不加密，默认是加密）
> - `BACKUPPASS` （加密密码，重要，务必要修改）
> - `LOCALDIR` （备份目录，可自己指定）
> - `TEMPDIR` （备份目录的临时目录，可自己指定）
> - `LOGFILE`（脚本运行产生的日志文件路径）
> - `MYSQL_ROOT_PASSWORD` （MySQL/MariaDB/Percona 的 root 用户密码）
> - `MYSQL_DATABASE_NAME` （指定 MySQL/MariaDB/Percona 的数据库名，留空则是备份所有数据库）
> 
> ```mysql
> // MYSQL_DATABASE_NAME 是一个数组变量，可以指定多个。举例如下：
> 
> MYSQL_DATABASE_NAME[0]="phpmyadmin"
> MYSQL_DATABASE_NAME[1]="test"
> ```
> 
> - `BACKUP` （需要备份的指定目录或文件列表，留空就是不备份目录或文件）
> ```bash
> # BACKUP 是一个数组变量，可以指定多个。举例如下：
> 
> BACKUP[0]="/data/www/default/test.tgz"
> BACKUP[1]="/data/www/default/test/"
> BACKUP[2]="/data/www/default/test2/"
> ```
>
> - `LOCALAGEDAILIES` （指定多少天之后删除本地旧的备份文件，默认为 7 天）
> - `DELETE_REMOTE_FILE_FLG` （删除 Google Drive 或 FTP 上备份文件的 FLG，true 为删除，false 为不删除）
> - `RCLONE_NAME` （设置 rclone config 时设定的 remote 名称，务必要指定）
> - `RCLONE_FOLDER` （指定备份时设定的 remote 的目录名称，该目录名在 Google Drive 不存在时则会自行创建。默认为空，也就是根目录）
> - `RCLONE_FLG` （上传本地备份文件至 Google Drive 的 FLG，true 为上传，false 为不上传）
>
> - `FTP_FLG` （上传文件至 FTP 服务器的 FLG，true 为上传，false 为不上传）
> - `FTP_HOST` （连接的 FTP 域名或 IP 地址）
> - `FTP_USER` （连接的 FTP 的用户名）
> - `FTP_PASS` （连接的 FTP 的用户的密码）
> - `FTP_DIR` （连接的 FTP 的远程目录，比如： public_html）

---

**一些注意事项的说明：**

- 1）脚本需要用 root 用户来执行；
- 2）脚本需要用到 openssl 来加密，请事先安装好；
- 3）脚本默认备份所有的数据库（全量备份）；
- 4）备份文件的解密命令如下：
```bash
openssl aes-256-cbc -d -salt -pbkdf2 -in [encrypted backup] -out decrypted_backup.tgz -pass pass:[backup password] -md sha256
```

- 5）备份文件解密后，解压命令如下：
```bash
tar -zxPf [DECRYPTION BACKUP FILE]
```

**解释一下参数 `-P`：**

**tar** 压缩文件默认都是相对路径的。加个 `-P` 是为了 **tar** 能以绝对路径压缩文件。因此，解压的时候也要带个 `-P` 参数。

---

# 3 配置 rclone 命令
rclone 是一个命令行工具，用于 Google Drive 的上传下载等操作。官网网站：[传送门](https://rclone.org/)

你可以用以下的命令来安装 rclone，以 RedHat 系举例，记得要先安装 `unzip` 命令。
```bash
yum -y install unzip && wget -qO- https://rclone.org/install.sh | bash
```

然后，运行以下命令开始配置：
```bash
rclone config
```

参考[这篇文章](https://web.archive.org/web/20230521040557/https://www.qcmoke.site/tools/rclone.html)，当设置到 Use auto config? 是否使用自动配置，选 `n` 不自动配置，然后根据提示用浏览器打开 rclone 给出的 URL，点击接受（Accept），然后将浏览器上显示出来的字符串粘贴回命令行里，完成授权，然后退出即可。参考文章里有挂载的操作，记得这里不需要挂载 Google Drive。

---

# 4 运行脚本开始备份
```bash
./backup.sh
```

脚本默认会显示备份进度，并在最后统计出所需时间。
如果你想将脚本加入到 cron 自动运行的话，就不需要前台显示备份进度，只写日志就可以了。
这个时候你需要稍微改一下脚本中的 log 函数。
```bash
log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S")" "$1"
    echo -e "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> ${LOGFILE}
}
```

改为：
```bash
log() {
    echo -e "$(date "+%Y-%m-%d %H:%M:%S")" "$1" >> ${LOGFILE}
}
```

【Crontab 教程待填坑】

关于如何使用 cron 自动备份，网上有一堆教程，这里以 `CentOS 7` 来举例说明。

修改文件 `/etc/crontab`，内容如下：
```config
SHELL=/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
MAILTO=root
HOME=/root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
30  1  *  *  * root bash /root/backup.sh
```

以上表示，每天凌晨 1 点 30 分，以 root 用户执行一次 backup.sh 脚本。

**【注意】：**

一定要修改其中的 `PATH` 和 `HOME` 变量的值。
尤其是 `HOME` 变量，rclone 命令能否正确执行，是要依赖于其配置文件的。用 `root` 用户配置的话，其配置文件夹应该是 `/root/.config/rclone` ，所以要更改 `HOME` 的值。

转载自：[秋水逸冰](https://teddysun.com) » [一键备份脚本backup.sh](https://teddysun.com/469.html)

