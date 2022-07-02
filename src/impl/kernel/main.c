/*
 * @Author: yuzhe zhilinlicn@gmail.com
 * @Date: 2022-07-02 18:26:45
 * @LastEditors: yuzhe zhilinlicn@gmail.com
 * @LastEditTime: 2022-07-02 20:11:26
 * @FilePath: /OS/src/impl/kernel/main.c
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */

#include"print.h"

void kernel_main() {
    print_clear();
    print_set_color(PRINT_COLOR_YELLOW, PRINT_COLOR_BLACK);
    print_str("Welcome to 64bit OS!");
}