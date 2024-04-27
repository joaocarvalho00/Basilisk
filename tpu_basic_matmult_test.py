import numpy as np
import cocotb
import random
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock
from cocotb.utils import get_sim_time
from helper_functions import *

@cocotb.test()
async def tpu_basic_matmult_test(dut):

    N = 2

    dut.clk.value = 0
    dut.rst.value = 0
    dut.data.value = 0
    dut.start.value = 0
    
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start(start_high=False))

    await RisingEdge(dut.clk)

    dut.rst.value = 1
    weights = feed_rnd_weights_in(dut, N)

    for i in range(2):
        await RisingEdge(dut.clk)

    dut.load_weights.value = 0

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    dut.start.value = 1

    for i in range(5):
        data = feed_rnd_data_in(dut, N)

        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)

        dut.data.value = 0

        for i in range(2*N+1):
            await RisingEdge(dut.clk)

        
        out = decode_out_binary_representation(dut.out.value)

        if(i != 0):
            await RisingEdge(dut.clk)
            await RisingEdge(dut.clk)

        assert np.array_equal(weights @ data, out)

        
        

        

