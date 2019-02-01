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
mkdir src/iPhone3,1/11D257/
mkdir src/iPhone5,2/11B554a/
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

if [ -e "src/iPhone5,2/BB/Mav5-8.02.00.Release.bbfw" ]&&[ -e "src/iPhone5,2/BB/Mav5-8.02.00.Release.plist" ]; then
echo "BBFW (Mav5-8.02.00) already exist"
else
mkdir -p src/iPhone5,2/BB/
bin/partialZipBrowser -g Firmware/Mav5-8.02.00.Release.bbfw http://appldnld.apple.com/ios8.4.1/031-31065-20150812-7518F132-3C8F-11E5-A96A-A11A3A53DB92/iPhone5,2_8.4.1_12H321_Restore.ipsw
bin/partialZipBrowser -g Firmware/Mav5-8.02.00.Release.plist http://appldnld.apple.com/ios8.4.1/031-31065-20150812-7518F132-3C8F-11E5-A96A-A11A3A53DB92/iPhone5,2_8.4.1_12H321_Restore.ipsw
mv -v Mav5-8.02.00.Release.bbfw src/iPhone5,2/BB/
mv -v Mav5-8.02.00.Release.plist src/iPhone5,2/BB/
echo ybHEo3Fv0y/6IYp0X45hxqDY7zM= | base64 --decode > src/iPhone5,2/BB/UniqueBuildID
echo DJiAwPNNOmT4P9RdlHUt3Q2TTHc= | base64 --decode > src/iPhone5,2/BB/APPSDownloadDigest
echo x5Xkaqqkc+l3NFLL6s3kAi5P7Sk= | base64 --decode > src/iPhone5,2/BB/APPSHashTableDigest
echo dFi5J+pSSqOfz31fIvmah2GJO+E= | base64 --decode > src/iPhone5,2/BB/DSP1DownloadDigest
echo HXUnmGmwIHbVLxkT1rHLm5V6iDM= | base64 --decode > src/iPhone5,2/BB/DSP1HashTableDigest
echo qtTu6JED2pyocdNVYT1uWN2Back= | base64 --decode > src/iPhone5,2/BB/DSP2DownloadDigest
echo 2rQ7whhh/WrHPUPMwT5lcsIkYDA= | base64 --decode > src/iPhone5,2/BB/DSP2HashTableDigest
echo MZ1ERfoeFcbe79pFAl/hbWUSYKc= | base64 --decode > src/iPhone5,2/BB/DSP3DownloadDigest
echo sKmLhQcjfaOliydm+iwxucr9DGw= | base64 --decode > src/iPhone5,2/BB/DSP3HashTableDigest
echo 051DfVgeFDI3DC9Hw35HGXCmgkM= | base64 --decode > src/iPhone5,2/BB/RPMDownloadDigest
echo fAAAAEAQAgDAcZDeGqmO8LWlCHcYIPVjFqR87A== | base64 --decode > src/iPhone5,2/BB/RestoreSBL1PartialDigest
echo ZAAAAIC9AQACxiFAOjelZm4NtrrLc8bPJIRQNA== | base64 --decode > src/iPhone5,2/BB/SBL1PartialDigest
echo LycXsLwawICZf2dMjev2yhZs+ic= | base64 --decode > src/iPhone5,2/BB/SBL2DownloadDigest
fi

echo "Done!"
