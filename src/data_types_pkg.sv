package data_types_pkg;
	typedef enum logic [1:0] {
		IDLE,
		LOAD_WEIGHTS,
		LOAD_IMG,
		CONV,
		XXX = 'x
	} CTRL_STATE_t;
	
endpackage