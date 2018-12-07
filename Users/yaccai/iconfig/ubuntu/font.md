# 设置字体

## 安装字体
在 /usr/share/fonts/ 中创建一个文件夹，比如myFonts，把字体复制进去，运行：
```bash
chmod 755 -R /usr/share/fonts/myFonts
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
```


## 安装 app
sudo apt install zsh git curl 


## 配置zsh
修改默认shell：```chsh -s /bin/zsh```
查看当前shell：```echo $SHELL```
安装oh-my-zsh: ```wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh```
