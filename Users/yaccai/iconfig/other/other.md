# 设置分区类型

`sudo asr adjust -target /dev/disk0s3 -settype “Apple_HFS”`

# 修改映像大小，先缩小文件系统，再减小映像体积，待优化

`diskutil resizeVolume disk2s1 30G # px.sparsebundle挂载后 disk2s1`
然后在磁盘工具，选apple稀疏*，选分区，删除空出来的空间
`hdiutil resize -size 30g /Volumes/Doc/Doc/px.sparsebundle`

```bash
/usr/local/bin/expect<<END
    set timeout 15
    spawn hdiutil create -size 5G -volname px -fs HFS+  -type SPARSEBUNDLE -encryption AES-128 -agentpass /Users/yaccai/px.sparsebundle
    expect "password:"
    send "977\r"
    expect "password:"
    send "977\r"
    expect eof
END
```

# 分割磁盘，调整大小

diskutil resizeVolume  disk0s2 90G JHFS+ W 0

# 长选项参数

```bash
temp=`/usr/local/opt/gnu-getopt/bin/getopt -o ab:c:: --long a-long,b-long:,c-long:: -n 'example.bash' -- "$@"`  
[ $? != 0 ] && exit 1
eval set -- "$temp"  

while true ; do  
    case "$1" in  
        -a|--a-long) echo "option a" ;                    shift ;;  
        -b|--b-long) echo "option b, --> $2" ;            shift 2 ;;  
        -c|--c-long) 
            case "$2" in  
                    "") echo "option c, no argument" ;    shift 2 ;;  
                     *) echo "option c, --> $2" ;         shift 2 ;;  
            esac ;;  
        --) shift ; break ;;  
        *) echo "internal error!" ; exit 1 ;;  
    esac  
done

for arg do  
   echo "$arg" ;  
done
```
# 短选项参数
```bash
while getopts "RLS:C:" arg #选项后面的冒号表示该选项需要参数 参数存在$OPTARG中
do
    case $arg in
        R) recur=true;;
        L) slink=true;;
        S) sfolder=$OPTARG;;
        C) cfolder=$OPTARG;;
        ?) exit 101;;
    esac
done
```

# find xargs
```bash
echo "nameXnameXnameXname" | xargs -dX -n2
cat arg.txt | xargs -I {} ./sk.sh -p {} -l # 将每个传入的参数 用{}指代，方便后面使用

hashf="/tmp/`basename "$1"`"
:>"$hashf"
find "$1"  -depth \
            -type f \
            ! -name ".DS_Store" \
            ! -name ".gitignore" \
            ! -name ".localized" \
            ! -path "*/.git/*" \
            ! -path "*/.vscode/*" \
            ! -path "*/.svn/*" \
            -print0 | xargs -0 -n1000 md5 -q >> "$hashf"

cat "$hashf" | md5
```

# 删除重复低版本homebrew
```bash
HDIR=/Volumes/Doc/Homebrew
pre=""
find "$HDIR" -type f -maxdepth 1 -mindepth 1 | sort | while read -r it; do

    [[ "${it%-*}" == "${pre%-*}" ]] && rm -v "$it"
    pre=$it
done

pre=""
find "$HDIR/Cask" -type f -maxdepth 1 -mindepth 1 | sort | while read -r it; do
    [[ "${it%--*}" == "${pre%--*}" ]] && rm -v "$it"
    pre=$it
done
```

# 重启 关机等界面是英文混杂状况
sudo "/System/Library/CoreServices/Language Chooser.app/Contents/MacOS/Language Chooser"


# arp
sudo arp -s 192.168.1.8 38:c9:86:43:2d:7d

#截屏
screencapture ~/$(/bin/date +'%Y-%m-%d-%H-%M-%S').jpg

# awk 
awk '/root/,/mysql/' test 将显示root第一次出现到mysql第一次出现之间的所有行。

# 网络
修改mac地址,重启后失效
sudo ifconfig en0 lladdr d0:67:e5:2e:07:f1

修改路由表,同时使用有线网卡和无线网卡
netstat -nr 查看路由表
sudo route delete 0.0.0.0 删除默认路由
sudo route add -net 0.0.0.0 192.168.1.1 默认使用192.168.1.1网关
sudo route add 10.200.0.0 10.200.22.254 有线网卡使用该网关
sudo route add 10.0.1.0/24 10.200.22.254 其它网段指定网关

# 去掉文件属性中的@

xattr -c <file>

# 均衡  

sudo route  add -net 119.129.117.120 -netmask 255.0.0.0 192.168.1.1 -ifscope en0
route add -host 192.168.30.122 -iface -link xl0:0:12:3f:2:3:4?????


# 内外网

结构 
      192.168.1.1
      /         \
  MBA-en3 ... TP-linkroute           # 192.168.1.X 网段
                  ...   \
                      ZET-route      # 192.168.12.X 网段
                      ...   \
                            MBA-en0  # 192.168.5.X 网段

sudo route -n add -net 192.168.12.0/24 192.168.5.1 
这样就可以在浏览器上进入TP-linkroute 的主页

# update sublime c++ package

jthree Aa8-8

# 停止spotlight

sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

# 查找指定像素大小的照片

```bash
findiPhone6SsreenShot () {
    mkdir -p ~/Downloads/img
    i=0
    find /Volumes/Doc/Picture/2018 /Volumes/Doc/Picture/2017 /Volumes/Doc/Picture/2016 -name "*.png" | while read it; do
        pix=`/usr/local/bin/identify "$it" | cut -d ' ' -f3`
        if [[ "$pix" == "750x1334" ]]; then
            cp "$it" ~/Downloads/img/"${i}_${it##*/}"
            printf "copy  %3d    %s\n" "$((++i))" "${it##*/}" 
        fi
    done
}
```

# 更新sublime包

```bash
updateSublimePakage () {
    sublpkg=/Applications/Sublime\ Text.app/Contents/MacOS/Packages
    pkgname="$1.sublime-package"
    if [[ -e ~/iconfig/other/sublime/$pkgname && -e "$sublpkg/$pkgname" ]]; then
        cd ~/iconfig/other/sublime/$pkgname
        cp "$sublpkg/$pkgname" /tmp
        zip -u "$sublpkg/$pkgname"  Snippets/*.sublime-snippet
    else
        echo "\$parament --> pakagename without .sublime-package"
    fi
}
```

# 挂载硬盘

mount -t exfat /dev/disk3s2 /Volumes/Store
diskutil umount /Volumes/Store
<!-- 9?Lj7WT,{2*!].@d -->