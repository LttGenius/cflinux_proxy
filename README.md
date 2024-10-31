### Install
下载**clashinstall.sh**到用户目录下，输入** bash /path/to/clashinstall.sh **执行shell脚本进行安装和初始化

---

### clashinstall.sh使用方法
clashinstall.sh [--undowm | --unbash | --dir "your path"]

- clashinstall.sh 将clash下载到默认目录 "~/tools/clash"，并向.bashrc写入clashof命令
- clashinstall.sh --undown 不进行下载
- clashinstall.sh --unbash 不向.bashrc文件写入clashof命令
- clashinstall.sh --dir "your path" 将clash下载到目录"your path"下

---

### clashof
clashof 用于启用/关闭 Clash及代理
-  clashof: 如此此时终端没有开启代理，则开启代理；否则关闭代理
-  clashof on: 启用 Clash及代理
-  clashof off: 关闭 Clash及代理
-  clashof status: 查看 Clash及代理状态
-  clashof help: 查看帮助
-  clashof proxy on: 启用代理
-  clashof proxy off: 关闭代理
-  clashof clash on: 启用 Clash
-  clashof clash off: 关闭 Clash

---

### 配置clash
- 执行Install
- 导出机场的配置文件，包括*config.yaml*，*Country.mmdb*和*cache.db*
- 将文件放到服务器~/.config/clash文件夹下

导出方法（以MacOS为例）
- 从目录~/.config/clash中即可看到以上三个文件