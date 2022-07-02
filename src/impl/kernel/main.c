/*
 * @Author: yuzhe zhilinlicn@gmail.com
 * @Date: 2022-07-02 18:26:45
 * @LastEditors: yuzhe zhilinlicn@gmail.com
 * @LastEditTime: 2022-07-02 20:18:45
 * @FilePath: /OS/src/impl/kernel/main.c
 * @Description: 
 */

#include"print.h"

void kernel_main() {
    print_clear();
    print_set_color(PRINT_COLOR_YELLOW, PRINT_COLOR_BLACK);
    print_str("Welcome to 64bit OS!");
}