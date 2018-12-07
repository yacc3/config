#!/bin/zsh
# coding:utf-8


cleanHome() {
    echo "clean Home"
    find ~/Library/{Caches,Logs} -type f -delete
    find ~/Library/Containers -iname "Cache*" -type d -exec rm -rf {} +
    find ~/Library/Containers -iname "*.qlvis"        -exec rm -rf {} +
    find ~/Library/Application\ Support -iname "Cache*" -type d -exec rm -rf {} +
    find ~                              -iname ".DS_Store" -delete
    find ~/Library/Application\ Support -iname "*.torrent" -delete
    rm -rf ~/Library/Application\ Support/Sublime\ Text\ 3/Backup
    rm -rf ~/Library/Application\ Support/Code/{Cache,CacheData,CachedExtensions}
    rm -rf ~/Library/Application\ Support/Code/User/workspaceStorage
    rm -rf ~/Library/Developer/CoreSimulator/Devices
    rm -rf ~/Library/Developer/Xcode/{iOS\ Device\ Logs,DocumentationCache,DerivedData}

    rm -rf ~/{.eclipse,.vimbackup,.vimswap,.vimundo,.vimviews,.data,.cscope,.subversion,.swt,.wns,.yjp,.oracle_jre_usage,.DS_Store,.zsh-update,.zsh_history,.vnc,.wget-hsts,.3T,.android,.cache,.devdocs,.docker,.ServiceHub,.IdentityService,.CFUserTextEncoding,.mailcap,.mongorc.js,.mysql_history,.python_history,.node_repl_history,.vim,.dbshell,.mime.types,.templateengine}

    chromd=/Applications/Google\ Chrome.app/Contents/Versions
    [[ `ls "$chromd" | gwc -l` -gt 1 ]] && rm -rf "$chromd"/`ls "$chromd" | head -n1`
    rm -rf /Applications/Thunder.app/Contents/Bundles/XLPlayer.app
    rm -rf ~/Library/Application\ Support/Thunder/Package
    osascript -e 'tell app "Finder" to empty' &>/dev/null
    /usr/local/bin/gem cleanup
}

cleanSystem() {
    echo "clean System"
    sudo rm -rf /{'$RECYCLE.BIN',.DS_Store,.fseventsd,.Spotlight-V100,.DocumentRevisions-V100,.PKInstallSandboxManager-SystemSoftware,System\ Volume\ Information,.vol,.Trashes,.TemporaryItems,installer.failurerequests,.file,macOS_SDK,vm,.HFS+\ Private\ Directory\ Data$'\r'}

    sudo rm -rf /Library/TeX/Root/texmf-dist/{doc,source}
    sudo rm -rf /Library/{QuickLook,SystemMigration,Updates,Internet\ Plug-Ins}
    sudo rm -rf /Library/LaunchAgents/com.oracle.java.Java-Updater.plist

    sudo rm -rf /usr/share/tokenizer/ja
    sudo rm -rf /usr/share/tokenizer/ko
    sudo find   /usr/local/Caskroom -name "*.app" -d 3 -exec rm -rf {} +
    sudo find   /usr/local/Caskroom -name "*.pkg" -d 3 -exec rm -rf {} +

    sudo find /System/Library/Caches /Library/Caches -type f -delete
    sudo find /private/var/log       /Library/Logs   -type f -delete
    sudo pmset -a sleep 0
    sudo pmset -a disksleep 0
    sudo pmset -a hibernatemode 0
    sudo purge
}

cleanSystemDeep() {
    sudo rm -rf /System/Library/Extensions/AppleIntelHD4000*
    sudo rm -rf /System/Library/Extensions/AppleIntelHD3000*
    sudo rm -rf /System/Library/Extensions/AMD*
    sudo rm -rf /System/Library/Extensions/ATI*
    sudo rm -rf /System/Library/Extensions/GeForce*
    sudo rm -rf /System/Library/Extensions/AppleIntelKBL*
    sudo rm -rf /System/Library/Extensions/AppleIntelSKL*

    sudo rm -rf /private/var/db/dyld/*
    sudo rm -rf /private/var/db/diagnostics/*
}

cleanOffice() {
    ~/iconfig/exe/cleanOffice.sh
}

cleanXcode() {
    echo "clean Xcode"
    xc=/Applications/Xcode.app/Contents
    xct="$xc"/Developer/Toolchains/XcodeDefault.xctoolchain
    xcp="$xc"/Developer/Platforms
    sudo find "$xcp" ! -iname "macosx*" -type d -d 1 -exec rm -rf {} +
    sudo rm -rf "$xc"/Resources/Packages/MobileDevice.pkg
    sudo rm -rf "$xct"/usr/lib/swift/appletvos
    sudo rm -rf "$xct"/usr/lib/swift/appletvsimulator
    sudo rm -rf "$xct"/usr/lib/swift/watchsimulator
    sudo rm -rf "$xct"/usr/lib/swift/watchos
    sudo rm -rf "$xct"/usr/lib/swift/iphoneos
    sudo rm -rf "$xct"/usr/lib/swift/iphonesimulator
}

cleanWindows() {
    echo "clean  "
    sudo rm -rfv /Volumes/Windows/MSOCache/All\ Users
    # sudo rm -rfv /Volumes/Windows/Program\ Files/Microsoft\ Office/Office16/ADDINS/Microsoft\ Power\ Query\ for\ Excel\ Integrated/bin/{hi,th,el,bg,ru,uk,kk,ar,he,vi,ja,hu,de,fr,pl,ro,ko,es,it,ca,nl,lv,pt,pt-PT,pt-pt,lt,sk,tr,pt-BR,cs,gl,da,fi,ms,eu,sv,no,hr,sl,sr-Latn,sr-latn,sr-Latn-CS,id,zh-HANT,sr-Cyrl,sr-cyrl,et,zh-CHT}
    # sudo rm -rfv /Volumes/Windows/Program\ Files/Microsoft\ Office/Office16/ADDINS/PowerPivot\ Excel\ Add-in/{hi,th,el,bg,ru,uk,kk,ar,he,vi,ja,hu,de,fr,pl,ro,ko,es,it,ca,nl,lv,pt,pt-PT,pt-pt,lt,sk,tr,pt-BR,cs,gl,da,fi,ms,eu,sv,no,hr,sl,sr-Latn,sr-latn,sr-Latn-CS,id,zh-HANT,sr-Cyrl,sr-cyrl,et,zh-CHT}
    # sudo rm -rfv /Volumes/Windows/Program\ Files/Microsoft\ Office/Office16/ADDINS/Power\ View\ Excel\ Add-in/{hi,th,el,bg,ru,uk,kk,ar,he,vi,ja,hu,de,fr,pl,ro,ko,es,it,ca,nl,lv,pt,pt-PT,pt-pt,lt,sk,tr,pt-BR,cs,gl,da,fi,ms,eu,sv,no,hr,sl,sr-Latn,sr-latn,sr-Latn-CS,id,zh-HANT,sr-Cyrl,sr-cyrl,et,zh-CHT}
    # sudo rm -rfv /Volumes/Windows/Program\ Files/Microsoft\ Office/Office16/ADDINS/Power\ Map\ Excel\ Add-in/{hi,th,el,bg,ru,uk,kk,ar,he,vi,ja,hu,de,fr,pl,ro,ko,es,it,ca,nl,lv,pt,pt-PT,pt-pt,lt,sk,tr,pt-BR,cs,gl,da,fi,ms,eu,sv,no,hr,sl,sr-Latn,sr-latn,sr-Latn-CS,id,zh-HANT,sr-Cyrl,sr-cyrl,et,zh-CHT} 
    # 以上有可能导致 右键新建 office文件的图标消失，创建的office文件也没有了图标，但不影响使用
    sudo rm -rfv /Volumes/Windows/Program\ Files/WindowsApps/Deleted

    sudo rm -rfv /Volumes/Windows/Program\ Files/WindowsApps/Microsoft.Microsoft3DViewer*
    sudo rm -rfv /Volumes/Windows/Program\ Files/WindowsApps/Microsoft.XboxApp*
    sudo rm -rfv /Volumes/Windows/Program\ Files/WindowsApps/Microsoft.MSPaint*
    sudo rm -rfv /Volumes/Windows/Windows/Installer/\$PatchCache\$/Managed
    sudo rm -rfv /Volumes/Windows/Windows/InfusedApps
    sudo rm -rfv /Volumes/Windows/Windows/System32/DriverStore/FileRepository

    sudo rm -rfv /Volumes/Windows/ProgramData/Intel/Package\ Cache
    sudo rm -rfv /Volumes/Windows/Users/yaccai/AppData/Local/Microsoft/OneDrive
}

cleanDisk () {
    find /Volumes/Store -name "._*"        -type f -print -exec rm -rf {} \;
    find /Volumes/Store/.Trashes ~/.Trash  -type f -print -exec rm -rf {} \;
    find /Volumes/Doc/Torrent -d 1 -name "*_moved" -print -exec rm -rf {} \; 
}


if [[ $# -eq 0 ]]; then
    echo "subcommand:"
    cat "$0" | awk  "/\"[a-zA-Z\_\-\+]+\" \)/{print $1}" | sed "s/\"//g; s/)//g"
    # echo "           Home"
    # echo "           System"
    # echo "           Office"
    # echo "           Xcode"
    # echo "           Windows"
    # echo "           Disk"
    # echo "           TMshot"
    exit
fi

case "$1" in
    "Home" )
        cleanHome
        ;;
    "System" )
        cleanSystem
        ;;
    "Office" )
        cleanOffice
        ;;
    "Xcode" )
        cleanXcode
        ;;
    "Windows" )
        cleanWindows
        ;;
    "Disk" )
        cleanDisk
        ;;
    "TMshot" )
        tmutil thinlocalsnapshots / 9999999999999999
        # tmutil listlocalsnapshotdates /Volumes/Mac | sed "1d" | while read it; do
        #     tmutil deletelocalsnapshots "$it"
        # done
        ;;
    * )
        echo "no such pattern"
        ;;
esac
