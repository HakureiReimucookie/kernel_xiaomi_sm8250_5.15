yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
echo -e ""
echo -e "$gre ====================================\n\n Kernel building program !\n\n ===================================="
Start=$(date +"%s")
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE="/home/lee/gcc-11.x-aarch64-linux-gnu-master/bin/aarch64-linux-gnu-"
#export CROSS_COMPILE_ARM32="/home/lee/gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin/arm-none-eabi-"
echo -e "$yellow Running make clean before compiling ? \n$white"
echo -n "Enter your choice, 1 or 2 :"
read clean
echo -e "$white"
if [ $clean == 1 ]; then
echo -e "$yellow Remake Now ! \n$white"
make O=out mrproper
elif [ $clean == 2 ]; then
echo -e "$yellow Just Running ! \n$white"
fi
make O=out CLANG_TRIPLE=aarch64-linux-gnu- alioth_defconfig
export KBUILD_BUILD_HOST="core"
export KBUILD_BUILD_USER="lee"
make O=out -j12
time=$(date +"%d-%m-%y-%T")
End=$(date +"%s")
Diff=$(($End - $Start))
cp ./out/arch/arm64/boot/Image.gz-dtb ./build/Image.gz-dtb
cp ./out/arch/arm64/boot/dtbo.img ./build/dtbo.img
cp ./out/arch/arm64/boot/dts/vendor/qcom/kona-v2.1.dtb ./build/dtb
zimage=./out/arch/arm64/boot/Image.gz-dtb
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd ./build
rm *.zip > /dev/null 2>&1
echo -e "$yellow\n Build succesful, generating flashable zip now \n $white"
zip -r +Alioth-MIUI-R-$time.zip * > /dev/null
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$yellow $KERNEL_DIR/build/+Alioth-MIUI-R.zip \n$white"
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds, variant($qc) >> \n $white"
fi
