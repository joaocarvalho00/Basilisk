from cocotb.binary import BinaryRepresentation, BinaryValue
from cocotb.triggers import RisingEdge
import numpy as np

def feed_rnd_weights_in(dut, n):
    # This function creates and inputs a random weight matrix
    # with size (n, n) to the tpu
    # Returns:
    #   weights_in matrix : this will be used for verification purposes


    # Create random weight matrix size (n, n)
    # and string vector to store binary representation
    weights_in = np.random.randint(5, size = n*n)

    weights_in_str = ""
    print(f'Weights matrix = \n{weights_in.reshape((2, 2))}')

    # Fill string vector with binary representation of each
    # random int from the random weight matrix
    for i in range(n*n):
        weights_in_str += f'{weights_in[i]:08b}'

    print(f'weights_in_str = {weights_in_str}\n')

    # Set the load_weights flag to high to enable loading
    # of the weights in the TPU and use the "BinaryValue" 
    # representation to transform the string vector in 
    # a data type compatible with cocotb.
    dut.load_weights.value = 1
    dut.weights.value = BinaryValue(weights_in_str, n*n*8, bigEndian = False, binaryRepresentation=BinaryRepresentation.UNSIGNED)
    
    return weights_in.reshape((n, n))

def feed_rnd_data_in(dut, n):
    # This function creates and inputs a random data matrix
    # with size (n, n) to the tpu
    # Returns:
    #   data_in matrix : this will be used for verification purposes


    # Create random data matrix size (n, n)
    # and string vector to store binary representation
    data_in = np.random.randint(5, size = n*n)
    data_in_str = ""
    
    print(f'data matrix = \n{data_in.reshape((2, 2))}\n')

    # Transpose data_in matrix because TPU reads one row 
    # every clock cycle but we want to send 1 column at a time
    # Data is only transposed to accomodate the HW inner working,
    # the actual matrix is still data_in.
    data_in_T = np.transpose(data_in.reshape((2, 2))).reshape(n*n)
    #print(f'data matrix transposed = \n{data_in_T.reshape((n, n))}\n')


    # Fill string vector with binary representation of each
    # random int from the random data matrix
    for i in range(n*n):
        data_in_str += f'{data_in_T[i]:08b}'

    print(f'data_in_str = {data_in_str}\n')

    # Set the load_weights flag to high to enable loading
    # of the weights in the TPU and use the "BinaryValue" 
    # representation to transform the string vector in 
    # a data type compatible with cocotb.
    dut.data.value = BinaryValue(data_in_str, n*n*8, bigEndian = False, binaryRepresentation=BinaryRepresentation.UNSIGNED)

    return data_in.reshape((n, n))

def decode_out_binary_representation(out):
    # This function decodes the BinaryValue datatype
    # into a numpy array to be used in assertions.
    
    out_matrix = []
    out_matrix = np.array([out[i:i+7].integer for i in range(0, len(out), 8)]).reshape((2, 2))

    print(f'out_matrix = \n{out_matrix}\n')

    return out_matrix
