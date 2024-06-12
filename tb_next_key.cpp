#include <stdlib.h>
#include <iostream>
#include <unistd.h>
#include <string>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vnext_key.h"

#define MAXSIMTIME 100

int main() {
    Vnext_key *top = new Vnext_key;
    VerilatedVcdC *tfp = new VerilatedVcdC;

    Verilated::traceEverOn(true);
    top->trace(tfp, 99);
    tfp->open("wave_forms/next_key.vcd");

    int * key_int = new int[8];

    key_int[0] = 0x603deb10;
    key_int[1] = 0x15ca71be;
    key_int[2] = 0x2b73aef0;
    key_int[3] = 0x857d7781;
    key_int[4] = 0x1f352c07;
    key_int[5] = 0x3b6108d7;
    key_int[6] = 0x2d9810a3;
    key_int[7] = 0x0914dff4;


    int i = 0;
    for (; i <= 10; i++) {
        top->clk = !top->clk;
        top->eval();
        tfp->dump(10*i);
    }

    for (int j = 0; j < 8; j++) {
        top->key[j] = key_int[j];
    }


    for (; i < MAXSIMTIME; i++) {
        top->clk = !top->clk;
        top->eval();
        tfp->dump(10*i);
    }

    tfp->close();
    delete top;
    exit(0);
}
