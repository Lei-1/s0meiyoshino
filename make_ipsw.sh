#!/bin/bash

echo "**** s0meiyoshino v3.1 make_ipsw.sh ****"

if [ $# -lt 3 ]; then
    echo "./make_ipsw.sh <device model> <downgrade-iOS> <base-iOS> [args]"
    echo ""
    echo "[OPTION]"
    echo "--verbose                 : Inject Boot-args \"-v\""
    echo "--cs-disable              : Inject Boot-args \"cs_enforcement_disable=1\""
    echo "--cs-disable-verbose      : Inject Boot-args \"cs_enforcement_disable=1 -v\""
    echo ""
    echo "example: ./make_ipsw.sh iPhone5,2 6.1.4 7.0.4 --verbose"
    exit
fi

if [ $# == 4 ]; then
    if [ $4 != "--verbose" ] && [ $4 != "--cs-disable" ] && [ $4 != "--cs-disable-verbose" ]; then
        echo "[ERROR] Invalid argument"
        exit
    fi
    if [ $4 = "--cs-disable" ]&&[ $4 = "--cs-disable-verbose" ]; then
        echo "You need to get PE_i_can_has_debuger=1."
    fi
fi

#### Set support device information ####
if [ $1 = "iPhone3,1" ]; then
    if [ $3 != "7.1.2" ]; then
        echo "[ERROR] Please use \"7.1.2\" for base iOS"
        exit
    fi
    Identifier="iPhone3,1"
    InternalName="n90ap"
    SoC="s5l8930x"
    Image="2x~iphone-30pin"
    BaseFWVer="7.1.2"
    BaseFWBuild="11D257"
    Size="2x"
fi

if [ $1 = "iPhone5,2" ]; then
    if [ $3 = "7.0" ] || [ $3 = "7.0.2" ] || [ $3 = "7.0.3" ] || [ $3 = "7.0.4" ] || [ $3 = "7.0.6" ]; then
        Identifier="iPhone5,2"
        InternalName="n42ap"
        SoC="s5l8950x"
        Image="1136~iphone-lightning"
        Size="1136"
        if [ $3 = "7.0" ]; then
            BaseFWVer="7.0"
            BaseFWBuild="11A465"
        fi
        if [ $3 = "7.0.2" ]; then
            BaseFWVer="7.0.2"
            BaseFWBuild="11A501"
        fi
        if [ $3 = "7.0.3" ]; then
            BaseFWVer="7.0.3"
            BaseFWBuild="11B511"
        fi
        if [ $3 = "7.0.4" ]; then
            BaseFWVer="7.0.4"
            BaseFWBuild="11B554a"
        fi
        if [ $3 = "7.0.6" ]; then
            BaseFWVer="7.0.6"
            BaseFWBuild="11B651"
        fi
    else
        echo "[ERROR] This base-iOS is NOT supported!"
    fi
fi

if [ $1 != "iPhone3,1" ] && [ $1 != "iPhone5,2" ]; then
    echo "[ERROR] This device is NOT supported!!"
    exit
fi

#### Find base firmware ####
if [ -e ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw" ]; then
    echo ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw OK"
else
    echo ""$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw does not exist"
exit
fi

#### Set macOS version ####
OSXVer=`sw_vers -productVersion | awk -F. '{print $2}'`
DD=0
iOSLIST="0"

#### iPhone 4 ####
if [ $Identifier = "iPhone3,1" ]; then
    if [ $2 = "4.3.3" ]; then
        #### iOS 4.3.3 ####
        ## iBoot-1072.61~2
        iOSLIST="4"
        iOS4Switch="433"
        iOSVersion="4.3.3_8J2"
        iOSBuild="8J2"
        RestoreRamdisk="038-1449-003.dmg"
        iBoot_Key="c2ead1d3b228a05b665c91b4b1ab54b570a81dffaf06eaf1736767bcb86e50de"
        iBoot_IV="bb3fc29dd226fac56086790060d5c744"
        LLB_Key="63083d71e1039bca175ac4958bcb502f655f59a56c7008d516328389a3abae4f"
        LLB_IV="598c1dc81a30e794814d884d4baca4a9"
        DD=1
    fi

    if [ $2 = "4.3.5" ]; then
        #### iOS 4.3.5 ####
        ## iBoot-1072.61~6
        iOSLIST="4"
        iOS4Switch="435"
        iOSVersion="4.3.5_8L1"
        iOSBuild="8L1"
        RestoreRamdisk="038-2265-002.dmg"
        iBoot_Key="b4e300c54a9dd2e648ead50794e9bf2205a489c310a1c70a9fae687368229468"
        iBoot_IV="986032eecd861c37ca2a86b6496a3c0d"
        DD=1
    fi

    if [ $2 = "5.1.1" ]; then
        #### iOS 5.1.1 ####
        ## iBoot-1219.62.15~2
        iOSLIST="6"
        iOSVersion="5.1.1_9B206"
        iOSBuild="9B206"
        RestoreRamdisk="038-4361-021.dmg"
        iBoot_Key="e8e26976984e83f967b16bdb3a65a3ec45003cdf2aaf8d541104c26797484138"
        iBoot_IV="b1846de299191186ce3bbb22432eca12"
        Boot_Partition_Patch="000081a: 00200020"
        DD=1
    fi

    if [ $2 = "6.0" ]; then
        #### iOS 6.0 ####
        ## iBoot-1537.4.18~2
        iOSLIST="6"
        Boot_Partition_Patch="0000a6c: 00200020"
        iOSVersion="6.0_10A403"
        iOSBuild="10A403"
        RestoreRamdisk="038-6451-001.dmg"
        iBoot_Key="838270f668a05a60ff352d8549c06d2f21c3e4f7617c72a78d82c92a3ad3a045"
        iBoot_IV="7891928b9dd0dd919778743a2c8ec6b3"
        DD=1
    fi

    if [ $2 = "6.0.1" ]; then
        #### iOS 6.0.1 ####
        ## iBoot-1537.4.21~3
        iOSLIST="6"
        Boot_Partition_Patch="0000a6c: 00200020"
        iOSVersion="6.0.1_10A523"
        iOSBuild="10A523"
        RestoreRamdisk="038-7924-011.dmg"
        iBoot_Key="8d539232c0e906a9f60caa462f189530f745c4abd81a742b4d1ec1cb8b9ca6c3"
        iBoot_IV="44ffe675d6f31167369787a17725d06c"
        DD=1
    fi

    if [ $2 = "6.1" ]; then
        #### iOS 6.1 ####
        ## iBoot-1537.9.55~4
        iOSLIST="6"
        Boot_Partition_Patch="0000a6c: 00200020"
        iOSVersion="6.1_10B144"
        iOSBuild="10B144"
        RestoreRamdisk="048-0804-001.dmg"
        iBoot_Key="891ed50315763dac51434daeb8543b5975a555fb8388cc578d0f421f833da04d"
        iBoot_IV="4d76b7e25893839cfca478b44ddef3dd"
        DD=1
    fi

    if [ $2 = "6.1.2" ]; then
        #### iOS 6.1.2 ####
        ## iBoot-1537.9.55~4
        iOSLIST="6"
        Boot_Partition_Patch="0000a6c: 00200020"
        iOSVersion="6.1.2_10B146"
        iOSBuild="10B146"
        RestoreRamdisk="048-1037-002.dmg"
        iBoot_Key="cbcd007712618cb6ab3be147f0317e22e7cceadb344e99ea1a076ef235c2c534"
        iBoot_IV="c939629e3473fdb67deae0c45582506d"
        DD=1
    fi

    if [ $2 = "6.1.3" ]; then
        #### iOS 6.1.3 ####
        ## iBoot-1537.9.55~11
        iOSLIST="6"
        Boot_Partition_Patch="0000a6c: 00200020"
        iOSVersion="6.1.3_10B329"
        iOSBuild="10B329"
        RestoreRamdisk="048-2441-007.dmg"
        iBoot_Key="3dbe8be17af793b043eed7af865f0b843936659550ad692db96865c00171959f"
        iBoot_IV="b559a2c7dae9b95643c6610b4cf26dbd"
        DD=1
    fi

    if [ $2 = "7.0" ]; then
        #### iOS 7.0 ####
        ## iBoot-1940.1.75~20
        iOSLIST="7"
        Boot_Partition_Patch="0000a54: 00200020"
        iOSVersion="7.0_11A465"
        iOSBuild="11A465"
        RestoreRamdisk="038-3373-256.dmg"
        iBoot_Key="e1fef31c8aabcdca2a3887ba21c0e2113c41a5617380657ab6a487993b39f9a8"
        iBoot_IV="5bf099d9db5cf1009329e527a378c8be"
        DD=1
    fi

    if [ $2 = "7.0.2" ]; then
        #### iOS 7.0.2 ####
        ## iBoot-1940.1.75~93
        iOSLIST="7"
        Boot_Partition_Patch="0000a54: 00200020"
        iOSVersion="7.0.2_11A501"
        iOSBuild="11A501"
        RestoreRamdisk="048-9414-002.dmg"
        iBoot_Key="5cd910c268813cb4008e5b33e01f761c0794ed1437737b4d386727d17fac79d1"
        iBoot_IV="65db9a4e4f64bb79a55d76d98ce1457b"
        DD=1
    fi

    if [ $2 = "7.0.3" ]; then
        #### iOS 7.0.3 ####
        ## iBoot-1940.3.5~1
        iOSLIST="7"
        Boot_Partition_Patch="0000a54: 00200020"
        iOSVersion="7.0.3_11B511"
        iOSBuild="11B511"
        RestoreRamdisk="058-0322-002.dmg"
        iBoot_Key="bd56f0886e21f233f519d4db20fd044b9208882a6fb791553a75eb4e0c45bbc5"
        iBoot_IV="7cb97df787dcc6367816b03492b225f9"
        DD=1
    fi

    if [ $2 = "7.0.4" ]; then
        #### iOS 7.0.4 ####
        ## iBoot-1940.3.5~1
        iOSLIST="7"
        Boot_Partition_Patch="0000a54: 00200020"
        iOSVersion="7.0.4_11B554a"
        iOSBuild="11B554a"
        RestoreRamdisk="058-1056-002.dmg"
        iBoot_Key="2a6940252b5cb19b86efb9005cdd5fd713290e573dc760f5a3e05df9e868bb89"
        iBoot_IV="67087ac7f28c77cdf9110356f476540b"
        DD=1
    fi

    if [ $2 = "7.0.6" ]; then
        #### iOS 7.0.6 ####
        ## iBoot-1940.3.5~1
        iOSLIST="7"
        Boot_Partition_Patch="0000a54: 00200020"
        iOSVersion="7.0.6_11B651"
        iOSBuild="11B651"
        RestoreRamdisk="058-2320-001.dmg"
        iBoot_Key="d7b5bb9b90f19493449ab17fda63afdb16069ad5b65026bb11b4db223fdd4be1"
        iBoot_IV="12af3a975f0346e89d3a34e73b4e0ae1"
        DD=1
    fi

    if [ $2 = "7.1" ]; then
        #### iOS 7.1 ####
        ## iBoot-1940.10.58~115
        iOSLIST="7"
        Boot_Partition_Patch="0000a54: 00200020"
        iOSVersion="7.1_11D169"
        iOSBuild="11D169"
        RestoreRamdisk="058-4107-003.dmg"
        iBoot_Key="b68612f21e377bd1f685e9031be159a724e931eff162db245c63b7b692cefa7e"
        iBoot_IV="9fe5b6785126c8fc5787582df9efcf94"
        DD=1
    fi

    if [ $2 = "7.1.1" ]; then
        #### iOS 7.1.1 ####
        ## iBoot-1940.10.58~122
        iOSLIST="7"
        Boot_Partition_Patch="0000a54: 00200020"
        iOSVersion="7.1.1_11D201"
        iOSBuild="11D201"
        RestoreRamdisk="058-00093-002.dmg"
        iBoot_Key="c6fbf428e0105ab22b2abaefd20ca22c2084e200f74e8a3b08298a54f8bfe28f"
        iBoot_IV="b110991061d76f74c1fc05ddd7cff540"
        DD=1
    fi

fi

if [ $iOSLIST = "4" ]; then
    #### make scab ####
    echo "Please connect the target device to USB."
    read -p "<enter>: "
    echo "getting shsh..."
    ECID="$((./bin/idevicerestore -t "$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw) | sed -n -e 's/^.*Found ECID //p')"
    if [ -e "shsh/"$ECID"-iPhone3,1-7.1.2.shsh" ]; then
        zcat< shsh/"$ECID"-iPhone3,1-7.1.2.shsh > shsh/"$ECID"-iPhone3,1-7.1.2.plist
        plutil -extract 'APTicket' xml1 shsh/"$ECID"-iPhone3,1-7.1.2.plist -o 'shsh/apticket.plist'
        cat shsh/apticket.plist | sed -ne '/<data>/,/<\/data>/p' | sed -e "s/<data>//" | sed  "s/<\/data>//" | awk '{printf "%s",$0}' | base64 --decode > shsh/apticket.der
        bin/xpwntool shsh/apticket.der src/"$ECID"-apticket.img3 -t src/iPhone3,1/scab_template.img3

        rm shsh/apticket.der
        rm shsh/apticket.plist
        rm shsh/"$ECID"-iPhone3,1-7.1.2.plist
        if [ ! -e "src/"$ECID"-apticket.img3" ]; then
            echo "failed get shsh"
            exit
        fi

    fi
fi

#### iPhone 5 (Global) ####
if [ $Identifier = "iPhone5,2" ]; then
    if [ $2 = "6.1.4" ]; then
        #### iOS 6.1.4 ####
        ## iBoot-1537.9.55~11
        iOSLIST="6"
        Boot_Partition_Patch="0000a94: 00200020"
        Boot_Ramdisk_Patch="0000b66: 00200020"
        iOSVersion="6.1.4_10B350"
        iOSBuild="10B350"
        RestoreRamdisk="048-2930-001.dmg"
        iBoot_Key="f0943a042103e899250e62043ce8a7d24a446eac77366fcdc12cd21a28828af9"
        iBoot_IV="c13c3705190682c2d4253ecea7910c56"
        DD=1
    fi

    if [ $2 = "7.1.2" ]; then
        #### iOS 6.1.4 ####
        ## iBoot-1537.9.55~11
        iOSLIST="7"
        Boot_Partition_Patch="0000a7c: 00200020"
        Boot_Ramdisk_Patch="0000b24: 00200020"
        iOSVersion="7.1.2_11D257"
        iOSBuild="11D257"
        RestoreRamdisk="058-4276-009.dmg"
        iBoot_Key="b23dbe781086f6000cba372e5e8ae01c3f61c032ab1fb6729129707e3ccb9463"
        iBoot_IV="422b9c5e642ff797dc38b9910f084826"
        DD=1
fi
fi

if [ $DD == 0 ]; then
echo "[ERROR] This downgrade-iOS is NOT supported!"
exit
fi


### look ipsw??
if [ -e ""$Identifier"_"$iOSVersion"_Restore.ipsw" ]; then
    echo ""$Identifier"_"$iOSVersion"_Restore.ipsw OK"
else
    echo ""$Identifier"_"$iOSVersion"_Restore.ipsw does not exist"
    exit
fi

if [ -d "tmp_ipsw" ]; then
    rm -r tmp_ipsw
fi

echo ""

mkdir tmp_ipsw
cd tmp_ipsw

#### Decrypt iBoot ####
unzip -j ../"$Identifier"_"$iOSVersion"_Restore.ipsw "Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3"
../bin/xpwntool iBoot."$InternalName".RELEASE.img3 iBoot."$InternalName".dec.img3 -k $iBoot_Key -iv $iBoot_IV -decrypt
../bin/xpwntool iBoot."$InternalName".dec.img3 iBoot."$InternalName".dec
echo ""

if [ "$iOSLIST" = "4" ]; then
    #### iOS4Switch = 433 ####
    if [ "$iOS4Switch" = "433" ]; then
        #### Patching LLB4 ####
        unzip -j ../"$Identifier"_"$iOSVersion"_Restore.ipsw "Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3"
        ../bin/xpwntool LLB."$InternalName".RELEASE.img3 LLB."$InternalName".dec.img3 -k $LLB_Key -iv $LLB_IV -decrypt
        ../bin/xpwntool LLB."$InternalName".dec.img3 LLB."$InternalName".dec
        bspatch LLB."$InternalName".dec PwnedLLB."$InternalName".dec ../FirmwareBundles/Down_"$Identifier"_"$iOSVersion".bundle/LLB."$InternalName".RELEASE.patch
        ../bin/xpwntool PwnedLLB."$InternalName".dec iBoot -t LLB."$InternalName".dec.img3
        echo "0000010: 63656269" | xxd -r - iBoot
        echo "0000020: 63656269" | xxd -r - iBoot
        tar -cvf bootloader.tar iBoot
        #### Patching iBoot4 ####
        bspatch iBoot."$InternalName".dec PwnediBoot."$InternalName".dec ../FirmwareBundles/Down_"$Identifier"_"$iOSVersion".bundle/iBoot."$InternalName".RELEASE.patch
        ../bin/xpwntool PwnediBoot."$InternalName".dec iBoot4 -t iBoot."$InternalName".dec.img3
        echo "0000010: 346F6269" | xxd -r - iBoot4
        echo "0000020: 346F6269" | xxd -r - iBoot4
    fi
    #### iOS4Switch = 435 ####
    if [ "$iOS4Switch" = "435" ]; then
        #### Patching iBoot4 ####
        bspatch iBoot."$InternalName".dec PwnediBoot."$InternalName".dec ../FirmwareBundles/Down_"$Identifier"_"$iOSVersion".bundle/iBoot."$InternalName".RELEASE.patch
        ../bin/xpwntool PwnediBoot."$InternalName".dec iBoot -t iBoot."$InternalName".dec.img3
        echo "0000010: 63656269" | xxd -r - iBoot
        echo "0000020: 63656269" | xxd -r - iBoot
        tar -cvf bootloader.tar iBoot
    fi

fi

if [ "$iOSLIST" != "4" ]; then
    #### Patching iBoot5/6/7 ####
    if [ $# -lt 4 ]; then
        ../bin/iBoot32Patcher iBoot."$InternalName".dec PwnediBoot."$InternalName".dec -r -d
    fi

    if [ $# == 4 ]; then
        if [ $4 = "--verbose" ]; then
            ../bin/iBoot32Patcher iBoot."$InternalName".dec PwnediBoot."$InternalName".dec -r -d -b "-v"
        fi
        if [ $4 = "--cs-disable" ]; then
            ../bin/iBoot32Patcher iBoot."$InternalName".dec PwnediBoot."$InternalName".dec -r -d -b "cs_enforcement_disable=1"
        fi
        if [ $4 = "--cs-disable-verbose" ]; then
            ../bin/iBoot32Patcher iBoot."$InternalName".dec PwnediBoot."$InternalName".dec -r -d -b "cs_enforcement_disable=1 -v"
        fi
    fi

    echo "$Boot_Partition_Patch" | xxd -r - PwnediBoot."$InternalName".dec
    if [ $Identifier = "iPhone5,2" ]; then
        echo "$Boot_Ramdisk_Patch" | xxd -r - PwnediBoot."$InternalName".dec
        if [ $iOSLIST = "6" ]; then
            ../bin/iBoot32Patcher PwnediBoot."$InternalName".dec PwnediBoot2."$InternalName".dec -r
            rm PwnediBoot."$InternalName".dec
            mv PwnediBoot2."$InternalName".dec PwnediBoot."$InternalName".dec
        fi
    fi

    ../bin/xpwntool PwnediBoot."$InternalName".dec PwnediBoot."$InternalName".img3 -t iBoot."$InternalName".dec.img3
    echo "0000010: 63656269" | xxd -r - PwnediBoot."$InternalName".img3
    echo "0000020: 63656269" | xxd -r - PwnediBoot."$InternalName".img3
    mv -v PwnediBoot."$InternalName".img3 iBEC
    tar -cvf bootloader.tar iBEC
fi

cd ../
#### Make custom ipsw by odysseus ####
if [ "$iOSLIST" = "4" ] && [ $Identifier = "iPhone3,1" ]; then
    ./bin/ipsw "$Identifier"_"$iOSVersion"_Restore.ipsw tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw -memory
fi
if [ "$iOSLIST" != "4" ] && [ $Identifier = "iPhone3,1" ]; then
    ./bin/ipsw "$Identifier"_"$iOSVersion"_Restore.ipsw tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw -memory tmp_ipsw/bootloader.tar
fi

if [ $Identifier = "iPhone5,2" ]; then
    ./bin/ipsw "$Identifier"_"$iOSVersion"_Restore.ipsw tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw -bbupdate -memory tmp_ipsw/bootloader.tar
fi

#### Confirm existence of firmware ####
if [ -e "tmp_ipsw/"$Identifier"_"$iOSVersion"_Odysseus.ipsw" ]; then
    echo "success"
else
    echo "[ERROR] failed make ipsw"
    exit
fi

#### Make CFW ####
cd tmp_ipsw

mkdir BaseFWBuild
unzip -j ../"$Identifier"_"$BaseFWVer"_"$BaseFWBuild"_Restore.ipsw "Firmware/all_flash/all_flash."$InternalName".production/*" -d BaseFWBuild

mkdir $iOSBuild
unzip -d $iOSBuild "$Identifier"_"$iOSVersion"_Odysseus.ipsw

if [ "$iOSLIST" = "4" ]; then
    if [ "$iOS4Switch" = "433" ]; then
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest

        echo "0000010: 34676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo-640x960."$SoC".img3
        echo "0000020: 34676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo-640x960."$SoC".img3

        mv -v ../src/"$ECID"-apticket.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/apticket.img3
        cp -a -v ../src/iPhone3,1/manifest433 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest

        if [ "$OSXVer" -gt "10" ]; then
            mv -v $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/apticket.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoT-640x960."$SoC".img3
            cp -a -v ../src/iPhone3,1/manifest433x $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest
        fi

        cp -a -v ../src/iPhone3,1/433.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoX-640x960."$SoC".img3
        echo "0000010: 58676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoX-640x960."$SoC".img3
        echo "0000020: 58676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoX-640x960."$SoC".img3

        mv -v iBoot4 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot4."$InternalName".RELEASE.img3

        mv -v BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo7-640x960."$SoC".img3
        mv -v BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0-640x960."$SoC".img3
        mv -v BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1-640x960."$SoC".img3
        mv -v BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull-640x960."$SoC".img3
        mv -v BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0-640x960."$SoC".img3
        mv -v BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1-640x960."$SoC".img3
        mv -v BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin-640x960."$SoC".img3
        mv -v BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
        mv -v BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
        mv -v BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode-640x960."$SoC".img3
    fi

    if [ "$iOS4Switch" = "435" ]; then
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode-640x960."$SoC".img3
        rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest

        echo "0000010: 34676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo-640x960."$SoC".img3
        echo "0000020: 34676F6C" | xxd -r - $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo-640x960."$SoC".img3

        mv -v ../src/"$ECID"-apticket.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/apticket.img3
        cp -a -v ../src/iPhone3,1/manifest4 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest

        if [ "$OSXVer" -gt "10" ]; then
            mv -v $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/apticket.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogoT-640x960."$SoC".img3
            cp -a -v ../src/iPhone3,1/manifest4x $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/manifest
        fi

        mv -v BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo7-640x960."$SoC".img3
        mv -v BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0-640x960."$SoC".img3
        mv -v BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1-640x960."$SoC".img3
        mv -v BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull-640x960."$SoC".img3
        mv -v BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0-640x960."$SoC".img3
        mv -v BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1-640x960."$SoC".img3
        mv -v BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin-640x960."$SoC".img3
        mv -v BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
        mv -v BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
        mv -v BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode-640x960."$SoC".img3
    fi

fi

if [ "$iOSLIST" = "6" ]; then
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin@2x."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode@"$Size"~iphone."$SoC".img3

    mv -v BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo@2x."$SoC".img3
    mv -v BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0@2x."$SoC".img3
    mv -v BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1@2x."$SoC".img3
    mv -v BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull@2x."$SoC".img3
    mv -v BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0@2x."$SoC".img3
    mv -v BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1@2x."$SoC".img3
    mv -v BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin@2x."$SoC".img3
    mv -v BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
    mv -v BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
    mv -v BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode@"$Size"~iphone."$SoC".img3
fi

if [ "$iOSLIST" = "7" ]; then
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/applelogo@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging0@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterycharging1@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batteryfull@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow0@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/batterylow1@2x~iphone."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/glyphplugin@"$Image"."$SoC".img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/iBoot."$InternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/LLB."$InternalName".RELEASE.img3
    rm $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/recoverymode@"$Image"."$SoC".img3
    mv -v BaseFWBuild/applelogo@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batterycharging0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batterycharging1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batteryfull@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batterylow0@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/batterylow1@2x~iphone."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/glyphplugin@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/iBoot."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/LLB."$InternalName".RELEASE.img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
    mv -v BaseFWBuild/recoverymode@"$Image"."$SoC".img3 $iOSBuild/Firmware/all_flash/all_flash."$InternalName".production/
fi

if [ $Identifier = "iPhone5,2" ]; then
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:UniqueBuildID ../src/iPhone5,2/BB/UniqueBuildID" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:APPS-DownloadDigest ../src/iPhone5,2/BB/APPSDownloadDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:APPS-HashTableDigest ../src/iPhone5,2/BB/APPSHashTableDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP1-DownloadDigest ../src/iPhone5,2/BB/DSP1DownloadDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP1-HashTableDigest ../src/iPhone5,2/BB/DSP1HashTableDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP2-DownloadDigest ../src/iPhone5,2/BB/DSP2DownloadDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP2-HashTableDigest ../src/iPhone5,2/BB/DSP2HashTableDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP3-DownloadDigest ../src/iPhone5,2/BB/DSP3DownloadDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:DSP3-HashTableDigest ../src/iPhone5,2/BB/DSP3HashTableDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:RPM-DownloadDigest ../src/iPhone5,2/BB/RPMDownloadDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:RestoreSBL1-PartialDigest ../src/iPhone5,2/BB/RestoreSBL1PartialDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:SBL1-PartialDigest ../src/iPhone5,2/BB/SBL1PartialDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "Import BuildIdentities:0:Manifest:BasebandFirmware:SBL2-DownloadDigest ../src/iPhone5,2/BB/SBL2DownloadDigest" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "set BuildIdentities:0:Manifest:BasebandFirmware:RestoreSBL1-Version "-1559152312"" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "set BuildIdentities:0:Manifest:BasebandFirmware:SBL1-Version "-1560200888"" $iOSBuild/BuildManifest.plist
/usr/libexec/PlistBuddy -c "set BuildIdentities:0:Manifest:BasebandFirmware:Info:Path "Firmware/Mav5-8.02.00.Release.bbfw"" $iOSBuild/BuildManifest.plist

cp -a -v ../src/iPhone5,2/BB/Mav5-8.02.00.Release.bbfw $iOSBuild/Firmware
cp -a -v ../src/iPhone5,2/BB/Mav5-8.02.00.Release.plist $iOSBuild/Firmware
fi

#BuildIdentities:0:UniqueBuildID    ybHEo3Fv0y/6IYp0X45hxqDY7zM=

#BuildIdentities:0:Manifest:BasebandFirmware:
#APPS-DownloadDigest                DJiAwPNNOmT4P9RdlHUt3Q2TTHc=
#APPS-HashTableDigest               x5Xkaqqkc+l3NFLL6s3kAi5P7Sk=
#DSP1-DownloadDigest                dFi5J+pSSqOfz31fIvmah2GJO+E=
#DSP1-HashTableDigest               HXUnmGmwIHbVLxkT1rHLm5V6iDM=
#DSP2-DownloadDigest                qtTu6JED2pyocdNVYT1uWN2Back=
#DSP2-HashTableDigest               2rQ7whhh/WrHPUPMwT5lcsIkYDA=
#DSP3-DownloadDigest                MZ1ERfoeFcbe79pFAl/hbWUSYKc=
#DSP3-HashTableDigest               sKmLhQcjfaOliydm+iwxucr9DGw=
#RPM-DownloadDigest                 051DfVgeFDI3DC9Hw35HGXCmgkM=
#RestoreSBL1-PartialDigest          fAAAAEAQAgDAcZDeGqmO8LWlCHcYIPVjFqR87A==
#RestoreSBL1-Version                -1559152312
#SBL1-PartialDigest                 ZAAAAIC9AQACxiFAOjelZm4NtrrLc8bPJIRQNA==
#SBL1-Version                       -1560200888
#SBL2-DownloadDigest                LycXsLwawICZf2dMjev2yhZs+ic=
#Info:Path                          Firmware/Mav5-8.02.00.Release.bbfw


#### make ramdisk ####
../bin/xpwntool $iOSBuild/$RestoreRamdisk $iOSBuild/ramdisk.dmg
if [ -e ""$iOSBuild"/ramdisk.dmg" ]; then
    echo "OK"
else
    echo "[ERROR] failed mount restore ramdisk"
    exit
fi

hdiutil resize $iOSBuild/ramdisk.dmg -size 40m

hdiutil attach -mountpoint ramdisk/ $iOSBuild/ramdisk.dmg

sleep 1s

if [ "$iOSLIST" = "4" ]; then
    mv -v ramdisk/sbin/reboot ramdisk/sbin/._

    if [ "$iOS4Switch" = "433" ]; then
        tar -xvf ../src/iPhone3,1/bin433.tar -C ramdisk/ --preserve-permissions
    fi
    if [ "$iOS4Switch" = "435" ]; then
        tar -xvf ../src/iPhone3,1/bin4.tar -C ramdisk/ --preserve-permissions
    fi
    tar -xvf bootloader.tar -C ramdisk/ --preserve-permissions
fi

if [ "$iOSLIST" != "4" ]&&[ $Identifier = "iPhone3,1" ]; then
    tar -xvf ../src/iPhone3,1/bin.tar -C ramdisk/ --preserve-permissions
    mv -v ramdisk/sbin/reboot ramdisk/sbin/reboot_
    cp -a -v ../src/iPhone3,1/partition.sh ramdisk/sbin/reboot
    cp -a -v ../src/iPhone3,1/11D257/ramdiskH.dmg ramdisk/
    chmod 755 ramdisk/sbin/reboot
fi

if [ $Identifier = "iPhone5,2" ]; then
    tar -xvf ../src/iPhone5,2/bin.tar -C ramdisk/ --preserve-permissions
    mv -v ramdisk/sbin/reboot ramdisk/sbin/reboot_
    cp -a -v ../src/iPhone5,2/partition.sh ramdisk/sbin/reboot
    cp -a -v ../src/iPhone5,2/11B554a/ramdiskH.dmg ramdisk/
chmod 755 ramdisk/sbin/reboot
fi

if [ "$iOSLIST" = "7" ]; then
    mv -v ramdisk/usr/share/progressui/applelogo@2x.tga ramdisk/usr/share/progressui/applelogo_orig.tga
    bspatch ramdisk/usr/share/progressui/applelogo_orig.tga ramdisk/usr/share/progressui/applelogo@2x.tga ../patch/applelogo7.patch
else
    mv -v ramdisk/usr/share/progressui/images-2x/applelogo.png ramdisk/usr/share/progressui/images-2x/applelogo_orig.png
    bspatch ramdisk/usr/share/progressui/images-2x/applelogo_orig.png ramdisk/usr/share/progressui/images-2x/applelogo.png ../patch/applelogo.patch
fi

sleep 1s

hdiutil detach ramdisk/
sleep 1s

mv $iOSBuild/$RestoreRamdisk $iOSBuild/t.dmg
../bin/xpwntool $iOSBuild/ramdisk.dmg $iOSBuild/$RestoreRamdisk -t $iOSBuild/t.dmg
rm $iOSBuild/ramdisk.dmg
rm $iOSBuild/t.dmg

rm -r BaseFWBuild

#### zipping ipsw ####
cd $iOSBuild
zip ../../"$Identifier"_"$iOSVersion"_Custom.ipsw -r0 *

#### clean up ####
cd ../../
rm -r tmp_ipsw

#### Done ####
echo "Done!"
