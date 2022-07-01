<!--
 * @Author: error: git config user.name && git config user.email & please set dead value or install git
 * @Date: 2022-07-01 18:31:53
 * @LastEditors: error: git config user.name && git config user.email & please set dead value or install git
 * @LastEditTime: 2022-07-01 18:44:02
 * @FilePath: /OS/readme.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# My operating system

## To run the docker container

Use this command in the terminal
````
docker run --rm -it -v $(pwd):/root/env myos-buildenv
````

## The header.asm file
We need to add a magical number so the BIOS and bootloader understand that this is an operating system.
Keypoints:
- The OS is not the first thing that starts when you turn on the computer
- Actually it is the bootloader
- The aim of a bootloader is to locate the OS