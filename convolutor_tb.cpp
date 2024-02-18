#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "convolutor.h"

#define MAX_SIM_TIME 40
vluint64_t sim_time = 0;


struct test_case_t {
    bool clk;
    bool rst;
    bool start_operation;
    uint16_t addr;
    };

test_case_t test_cases[] = {
    {0, 0, 0, 0},  // RESET STATE
    {1, 1, 1, 0},  // START_OPEARTION
    //{1, 1, 0, 0}, // DISABLE READ ENABLE
};

void set_test_case(convolutor* object, test_case_t* testcase) {
    object->clk             = testcase->clk;
    object->rst             = testcase->rst;
    object->start_operation = testcase->start_operation;
    object->addr            = testcase->addr;
}

void increment_addr(convolutor* object) {
    object->addr         = object->addr + 1;
}



int main(int argc, char** argv, char** env) {
    convolutor *dut = new convolutor;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");


    set_test_case(dut, &test_cases[0]);

    while (sim_time < MAX_SIM_TIME) {
        dut->clk ^= 1;

        if(sim_time == 4) {
            
            set_test_case(dut, &test_cases[1]);
        }
        if(sim_time >= 12 && sim_time % 2 == 0) {
            increment_addr(dut);
        }

        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }


    dut->final();
    m_trace->close();

    delete dut;
    exit(EXIT_SUCCESS);   
}
