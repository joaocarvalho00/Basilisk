# Simple tests for an counter module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def basic_count(dut):
    # generate a clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    # Reset DUT
    dut.rst.value = 0

    # reset the module, wait 2 rising edges until we release reset
    for _ in range(2):
        await RisingEdge(dut.clk)
    dut.rst.value = 1

    # run for 50ns checking count on each rising edge
    for cnt in range(50):
        await RisingEdge(dut.clk)
        if(cnt == 4):
            dut.start_operation.value = 1
            