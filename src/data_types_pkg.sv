package data_types_pkg;
	typedef enum logic [1:0] {
		IDLE,
		LOAD_WEIGHTS,
		LOAD_IMG,
		CONV,
		XXX = 'x
	} CTRL_STATE_t;

	typedef enum logic {
		SEL_IMG,
		SEL_WEIGHTS
	} img_weights_sel_t;

	typedef enum logic {
		IDLE,
		SETUP,
		WRITE,
		READ
	} APB_STATE_t;
	
endpackage