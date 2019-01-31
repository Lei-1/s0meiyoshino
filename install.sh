#!/bin/bash

## if [ -e "odysseus" ]; then
## echo "Odysseus already exist"
## else
## wget https://dayt0n.github.io/odysseus/odysseus-0.999.zip
## unzip -d ./ odysseus-0.999.zip
## mv -v odysseus-0.999.0 odysseus
## rm odysseus-0.999.zip
## rm -r __MACOSX

## ipsw, idevicerestore, xpwntool from "https://www.dropbox.com/s/oakjm4dgmuutsuf/odysseusOTA-v2.4.zip"
## idevicerestore_old by Odysseus
mkdir shsh

if [ -e "iloader" ]; then
echo "iloader already exist"
else
git clone https://github.com/dora2-iOS/iloader.git
mkdir -p ./src/iPhone3,1/11D257/
mkdir -p ./src/iPhone5,2/11B554a/
cp -a iloader/iPhone3,1/11D257/ramdiskH_beta4.dmg ./src/iPhone3,1/11D257/ramdiskH.dmg
cp -a iloader/iPhone5,2/11B554a/ramdiskH_beta4.dmg ./src/iPhone5,2/11B554a/ramdiskH.dmg
fi

if [ -e "ipwndfu" ]; then
echo "ipwndfu already exist"
else
git clone https://github.com/axi0mX/ipwndfu.git
fi

if [ -e "iBoot32Patcher" ]; then
echo "iBoot32Patcher already exist"
else
git clone https://github.com/NyanSatan/iBoot32Patcher.git
cd iBoot32Patcher
clang iBoot32Patcher.c finders.c functions.c patchers.c -Wno-multichar -I. -o ../bin/iBoot32Patcher
fi

if [ -e "bin/partialZipBrowser" ]; then
echo "partialZipBrowser already exist"
else
wget https://github.com/tihmstar/partialZipBrowser/releases/download/v1.0/partialZipBrowser.zip
unzip -d bin/ partialZipBrowser.zip
rm -v partialZipBrowser.zip
fi

if [ -e "src/iPhone5,2/BB/Mav5-8.02.00.Release.bbfw" ]; then
echo "BBFW (Mav5-8.02.00) already exist"
else
echo "eta son!"
fi

echo "Done!"
