import cocotb
import random
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from cocotb.types import LogicArray
from cocotb.clock import Clock


@cocotb.test()
async def processing_element_test(dut):
    
    # test that P_output will follow M_input
    assert LogicArray(dut.P_output.value) == LogicArray("X")
    # Set initial input value to prevent it from floating
    dut.M_input.value = 0

    clock = Clock(dut.clk, 10, units="ns")

    cocotb.start_soon(clock.start(start_high=False))

    await RisingEdge(dut.clk)
    expected_val = 0
    for i in range(10):
        val = random.randint(0, 1)
        dut.M_input.value = val
        await RisingEdge(dut.clk)
        assert dut.P_output.value == expected_val, f"output q was incorrect on the {i}th cycle"
        expected_val = val

    await RisingEdge(dut.clk)
    assert dut.P_output.value == expected_val, f"output q was incorrect on the last cycle"


