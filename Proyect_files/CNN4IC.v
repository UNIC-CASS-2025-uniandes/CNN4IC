
module CNN4IC (
//////////// OUTPUTS //////////
	output CNN4IC_data_OutBUS,

//////////// INPUTS //////////
	input	CNN4IC_CLOCK_50,
	input	CNN4IC_RESET_InHigh,
	input	CNN4IC_data_InBUS
);

 parameter DATAWIDTH_BUS = 8;
 parameter PRESCALER_DATAWIDTH = 23;

wire 	[DATAWIDTH_BUS-1:0] CNN4IC_SPI_OutBUS_cwire;

SPI #(.SPI_DATAWIDTH(DATAWIDTH_BUS)) SPI_u0 (
	.SPI_data_InBUS (CNN4IC_data_InBUS),
	.SPI_data_OutBUS (CNN4IC_SPI_OutBUS_cwire)
);

assign CNN4IC_data_OutBUS = CNN4IC_SPI_OutBUS_cwire;

endmodule
