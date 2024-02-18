package data_types_pkg;
	typedef enum logic [1:0] {
		IDLE,
		LOAD_WEIGHTS,
		LOAD_IMG,
		CONV
	} CTRL_STATE_t;
	

`include "src/defines.sv"
endpackage