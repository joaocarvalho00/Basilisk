import cocotb
import random
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from cocotb.types import LogicArray
from cocotb.types.range import Range
from cocotb.clock import Clock


@cocotb.test()
async def tpu_test(dut):

    #data_in = LogicArray("0000", Range("3", "downto", "0").integer)

    dut.clk.value = 0
    dut.rst.value = 0
    dut.data.value = 0
    dut.start.value = 0
    
    clock = Clock(dut.clk, 10, units="ns")
    count_i = 0
    cocotb.start_soon(clock.start(start_high=False))

    await RisingEdge(dut.clk)
    for i in range(50):
        if(i>=1 and i<=3):
            dut.rst.value = 1
            dut.load_weights.value = 1
            dut.weights.value = 67305985
        else:
            dut.load_weights.value = 0
            dut.weights.value = 0
        if(i>3):
            if(i == 4):
                dut.start.value = 1
                dut.data.value = 513
            if(i == 5):
                dut.data.value = 1027
            if(i>5):
                dut.data.value = 0
            # else:
            #     count_i += 1
            #     count = count_i * 514
            #     dut.data.value = count
        print(f'DATA_IN = {dut.data.value}')
        await RisingEdge(dut.clk)

