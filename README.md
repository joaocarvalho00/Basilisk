////////////////////////////
// Neural Network on FPGA //
////////////////////////////

Description:
	
	This project revolves on trying to implement a neural network (NN) capable of doing image classification on an FPGA.

	To do this it will be required building the NN model in hardware, have a memory component (RAM) that is able to supply the pre-trained weights, and test images to the network and a control module that handles the different steps involved in the process.

		1. Build hardware model of neural network, RAM, and control module and independently verify each module, preferably using Verilator-type tools.

		2. Verify the entire design. I think it will be helpful to have a python model that runs the same network on the same data so we can match it against the outputs of the hardware.