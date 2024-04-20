import cocotb
import random
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from cocotb.types import LogicArray
from cocotb.clock import Clock


@cocotb.test()
async def processing_element_test(dut):

    dut.clk.value = 0
    dut.rst.value = 0

    clock = Clock(dut.clk, 10, units="ns")

    cocotb.start_soon(clock.start(start_high=False))

    await RisingEdge(dut.clk)
    for i in range(10):
        count = i
        if(i==1):
            dut.rst.value = 1
        if(i==2):
            dut.load_weights.value = 1
        else:
            dut.load_weights.value = 0
        if(i==5):
            dut.valid.value = 1
        else:
            dut.valid.value = 0
        dut.data_in.value = count
        dut.weights_in.value = count
        await RisingEdge(dut.clk)

