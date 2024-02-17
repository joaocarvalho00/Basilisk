package data_types_pkg;
	typedef enum logic [1:0] {
		IDLE,
		READ,
		CONV
	} CTRL_STATE_t;
	

`include "src/defines.sv"
endpackage