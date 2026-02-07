module CNN_Control_Unit (
	//////////// OUTPUTS //////////
	output reg		CNN_Ctrl_Conv0_Enable_Out_Data,
	output reg		CNN_Ctrl_Pool0_Enable_Out_Data,
	output reg		CNN_Ctrl_Conv1_Enable_Out_Data,
	output reg		CNN_Ctrl_Pool1_Enable_Out_Data,
	output reg		CNN_Ctrl_FC0_Enable_Out_Data,
	output reg		CNN_Ctrl_Max0_Enable_Out_Data,
	
	//////////// INPUTS //////////
	input			CNN_Ctrl_CLOCK_50,
	input			CNN_Ctrl_RESET_InHigh,
	input			CNN_Ctrl_Start_InLow,
	input			CNN_Ctrl_Conv0_Done_InHigh,
	input			CNN_Ctrl_Pool0_Done_InHigh,
	input			CNN_Ctrl_Conv1_Done_InHigh,
	input			CNN_Ctrl_Pool1_Done_InHigh,
	input			CNN_Ctrl_FC0_Done_InHigh
);	

//=======================================================
//  PARAMETER declarations
//=======================================================
localparam ST_IDLE    = 0;
localparam ST_CONV1   = 1;
localparam ST_POOL1   = 2;
localparam ST_CONV2   = 3;
localparam ST_POOL2   = 4;
localparam ST_FC      = 5;
localparam ST_MAX     = 6;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [3:0] STATE_Register;
reg [3:0] STATE_Signal;

//=======================================================
//  Structural coding
//=======================================================

// NEXT STATE LOGIC : COMBINATIONAL
always @(*)
begin
	case (STATE_Register)
		ST_IDLE: 	if (CNN_Ctrl_Start_InLow == 1'b0) STATE_Signal = ST_CONV1;
					else STATE_Signal = ST_IDLE;
					
		ST_CONV1: 	if (CNN_Ctrl_Conv0_Done_InHigh == 1'b1) STATE_Signal = ST_POOL1;
					else STATE_Signal = ST_CONV1;
					
		ST_POOL1: 	if (CNN_Ctrl_Pool0_Done_InHigh == 1'b1) STATE_Signal = ST_CONV2;
					else STATE_Signal = ST_POOL1;
					
		ST_CONV2: 	if (CNN_Ctrl_Conv1_Done_InHigh == 1'b1) STATE_Signal = ST_POOL2;
					else STATE_Signal = ST_CONV2;
					
		ST_POOL2: 	if (CNN_Ctrl_Pool1_Done_InHigh == 1'b1) STATE_Signal = ST_FC;
					else STATE_Signal = ST_POOL2;
					
		ST_FC: 		if (CNN_Ctrl_FC0_Done_InHigh == 1'b1) STATE_Signal = ST_MAX;
					else STATE_Signal = ST_FC;
					
		ST_MAX: 	STATE_Signal = ST_IDLE;

		default: 	STATE_Signal = ST_IDLE;
	endcase
end

// STATE REGISTER : SEQUENTIAL
always @ (posedge CNN_Ctrl_CLOCK_50 , posedge CNN_Ctrl_RESET_InHigh)
begin
	if (CNN_Ctrl_RESET_InHigh == 1'b1)
		STATE_Register <= ST_IDLE;
	else
		STATE_Register <= STATE_Signal;
end

//=======================================================
//  Outputs
//=======================================================
// OUTPUT LOGIC : COMBINATIONAL
always @ (*)
begin
	// Default values (All disabled)
	CNN_Ctrl_Conv0_Enable_Out_Data = 1'b0;
	CNN_Ctrl_Pool0_Enable_Out_Data = 1'b0;
	CNN_Ctrl_Conv1_Enable_Out_Data = 1'b0;
	CNN_Ctrl_Pool1_Enable_Out_Data = 1'b0;
	CNN_Ctrl_FC0_Enable_Out_Data   = 1'b0;
	CNN_Ctrl_Max0_Enable_Out_Data  = 1'b0;

	case (STATE_Register)
		ST_CONV1: CNN_Ctrl_Conv0_Enable_Out_Data = 1'b1;
		ST_POOL1: CNN_Ctrl_Pool0_Enable_Out_Data = 1'b1;
		ST_CONV2: CNN_Ctrl_Conv1_Enable_Out_Data = 1'b1;
		ST_POOL2: CNN_Ctrl_Pool1_Enable_Out_Data = 1'b1;
		ST_FC:    CNN_Ctrl_FC0_Enable_Out_Data   = 1'b1;
		ST_MAX:   CNN_Ctrl_Max0_Enable_Out_Data  = 1'b1;
		default: ; // All stay at 0
	endcase
end

endmodule