<!--
 * @Author: error: git config user.name && git config user.email & please set dead value or install git
 * @Date: 2022-07-01 18:31:53
 * @LastEditors: yuzhe zhilinlicn@gmail.com
 * @LastEditTime: 2022-07-02 20:18:35
 * @FilePath: /OS/readme.md
 * @Description: 
-->
# My operating system

From a tutorial: https://www.youtube.com/watch?v=FkrpUaGThTQ&list=PLZQftyCk7_SeZRitx5MjBKzTtvk0pHMtp
CodePulse
## First part 

### To run the docker container and run OS

Use this command in the terminal
````
docker run --rm -it -v $(pwd):/root/env myos-buildenv
qemu-system-x86_64 -cdrom dist/x86_64/kernel.iso
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
- To enter we need a global descrip table
### Printing in C