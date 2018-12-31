<h2>s0meiyoshino v2.0 b4</h2>
It is a downgrade and untethered jailbreak tool to iOS 4.3.5, iOS 5.1.1, iOS 6 and iOS 7 that exploited the boot chain of iOS 7.1.2 using @xerub's De Rebus Antiquis.<br/>
Operation confirmed with OS X 10.10.5 and MacOS 10.13.5</br>
Please secure about 10 GB of free space.<br/>
<br/>
*Support for untethered downgrade to 5.1.1-7.1.1 (without shsh)<br/>
<br/>
*Support for untethered downgrade to iOS 4.3.5<br/>
*"BETA" Support for untethered downgrade to iOS 4.3.3<br/>
**iOS 4 has injected boot-args to disable CS.<br/>
<br/>
*Support for untethered jailbreak to iOS 7.0-7.1.1<br/>
**Apple File Connection v2 is not included in iOS 7.1.x Jailbreak. <br/>
<br/>
(1) Download IPSW<br/>
<a href="https://ipsw.me">ipsw download (https://ipsw.me)</a><br/>
Prepare firmware you want to downgrade and "iPhone3,1_7.1.2_11D257_Restore.ipsw" and put it in s0meiyoshino.<br/>

(1) Install packages<br/>
./install.sh<br/>

(2) make ipsw<br/>
./make_ipsw.sh<br/>
Firmware will be created.<br/>
Since choices are displayed, please select as necessary.<br/>

(3) Restore iPhone 4<br/>
First, put in device DFU mode.<br/>
Then, execute the following.<br/>
./restore.sh<br/>

<h3>How to delete exploit</h3><br/>
This method adds "boot-partition=2" to the nvram variable.<br/>
Even if you restore it with OFW in iTunes, it will be in recovery mode as it is.<br/>

It can be deleted in the following way.<br/>
(1) Jailbreak<br/>
(2) exec command "nvram -d boot-partition"<br/>
(3) reboot and restore<br/>

If you have already restored and you are in Recovery Mode<br/>
(1) Booting SSH ramdisk<br/>
(2) exec command "nvram -d boot-partition"<br/>
(3) reboot and restore<br/>
or<br/>
(1) Downgrade (Untethered or Tethered) iOS 6<br/>
(2) Jailbreak and tethered boot by redsn0w<br/>
(3) exec command "nvram -d boot-partition"<br/>
(4) reboot and restore<br/>
<br/>
<h3>How to jailbreak iOS 4.3.5</h3><br/>
(1) Tethered Jailbreak by redsn0w.<br/>
(2) Tethered Boot by redsn0w.<br/>
(3) Replace kernelcache with pwnedkc of redsn0w.<br/>
(4) Reboot!<br/>
<br/>
<h3>Credit</h3>
@xerub for <a href="https://xerub.github.io/ios/iboot/2018/05/10/de-rebus-antiquis.html">De Rebus Antiquis</a><br/>
@danzatt for <a href="https://github.com/danzatt/ios-dualboot">ios-dualboot(hfs_resize etc.)</a><br/>
Roderick W. Smith - for gptfdisk<br/>
@iH8sn0w for <a href="https://github.com/iH8sn0w/iBoot32Patcher">iBoot32Patcher</a><br/>
@tihmstar for <a href="https://github.com/tihmstar/iBoot32Patcher">Improvement of iBoot32Patcher</a><br/>
@nyan_satan for <a href="https://github.com/NyanSatan/iBoot32Patcher">Improvement of iBoot32Patcher</a> and <a href="https://github.com/NyanSatan/TwistedMind2">TwistedMind2</a><br/>
@ShadowLee19 for iBoot patch<br/>
@JonathanSeals for many tips<br/>
@Benfxmth for many tips<br/>
@winocm for opensn0w jailbreak patch<br/>
@daytonhasty for <a href="https://dayt0n.com/articles/Odysseus/">Odysseus</a><br/>
@libimobiledev for idevicerestore<br/>
@planetbeing for xpwn<br/>
@axi0mX for <a href="https://github.com/axi0mX/ipwndfu">ipwndfu</a><br/>
@posixninja and @pod2g for SHAtter exploit<br/>
<br/>