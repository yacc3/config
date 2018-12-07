#!/bin/zsh

# - tds型zip包按目录合并到texmf-dist下
# - 普通zip包（一般是很老的包,直接放home/tex/latex下也行


sudo tlmgr option repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet/
sudo tlmgr update --self

# sudo chmod -R 757 /usr/local/texlive/2017basic/tlpkg

# latexmk ctex collection-fontsrecommended environ trimspaces zhnumber
packages=(
    latexmk
    collection-fontsrecommended
    ctex         
    environ      
    trimspaces    
    zhnumber    
    subfigure   
    subfigure    
    cjk           
    abstract
    soul
    europasscv
    enumitem
    totpages
    csquotes
    biblatex-chicago
    biblatex
    multirow
    layouts
    yhmath
    greek-fontenc
    babel-greek
    cbfonts
    fontawesome

    logreq
    xstring
    inconsolata
    etaremune
    titlesec
    preprint
    sectsty
    changepage
    bold-extra
    roboto
    fontaxes
    mweights
    relsize
    textpos
    biber
    bibtex8
    preview
    standalone
    circuitikz
    chemfig
    arev
    lastpage
    xcharter
    framed
    titling
    totcount
    wrapfig
    luatex85
    docmute
    comment
)

for it in "${packages[@]}"; 
do
    echo "installing $it"
    sudo tlmgr install $it
done
sudo tlmgr update --all

sudo chmod 777 /Library/TeX/Root/texmf.cnf
echo "OSFONTDIR = .//;/System/Library/Fonts//;/Library/Fonts//;~/Library/Fonts//;/Volumes/Doc/Fonts//;/Applications/Microsoft\ Word.app/Contents/Resources/DFonts//" >> /Library/TeX/Root/texmf.cnf
sudo chmod 644 /Library/TeX/Root/texmf.cnf

# brew cask install font-liberation-sans

# brew install ghostscript

# 搜索
# sudo tlmgr search --global --file ${WhateverYouNeed}.sty
# sudo tlmgr install ${WhateverYouNeed}

# FandolSong FandolHei FandolKai FandolFang

# 刷新数据库
# sudo mktexlsr
# sudo updmap -sys
# sudo texhash
