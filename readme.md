<!--
 * @Author: error: git config user.name && git config user.email & please set dead value or install git
 * @Date: 2022-07-01 18:31:53
 * @LastEditors: yuzhe zhilinlicn@gmail.com
 * @LastEditTime: 2022-07-02 16:41:50
 * @FilePath: /OS/readme.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# My operating system

## First part 

### To run the docker container

Use this command in the terminal
````
docker run --rm -it -v $(pwd):/root/env myos-buildenv
````

### The header.asm file
We need to add a magical number so the BIOS and bootloader understand that this is an operating system.
Keypoints:
- The OS is not the first thing that starts when you turn on the computer
- Actually it is the bootloader
- The aim of a bootloader is to locate the OS

## Seconde part

### Stack
Crutial to allow us to link with c code
- The stack contains all executing functions and its local variables and the return address to the function that has called it
- As function is called, the stack grows and as function returns, space is freed popping out the function
- Each segment of function is called **stack frame**
  
### Switch to 64 mode
- To switch to the 64bits mode we need to switch the cpu mode to long mode
- before doing it, we need to ensure that the cpu supports it
### Printing in C