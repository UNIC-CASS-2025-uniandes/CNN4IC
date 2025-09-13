
module SPI #(parameter SPI_DATAWIDTH=8) (
//////////// OUTPUTS //////////
	output SPI_data_OutBUS,

//////////// INPUTS //////////
	input	SPI_data_InBUS
);



//always @(*)
//begin
//	if (SC_RegBACKGTYPE_RESET_InHigh == 1'b1)
//		RegBACKGTYPE_Register <= 0;
//	else
//		RegBACKGTYPE_Register <= RegBACKGTYPE_Signal;
//	end
//end

assign SPI_data_OutBUS = SPI_data_InBUS + 8'b00000001;

endmodule
