
module CNN4IC (
//////////// OUTPUTS //////////
	output CNN4IC_data_OutBUS, //predicted digit
	output CNN4IC_MISO,
	
//////////// INPUTS //////////
	input	CNN4IC_CLOCK_50,
	input	CNN4IC_RESET_InHigh,
	//Image
	input CNN4IC_SPICLOCK_50,
	input CNN4IC_SS_N,
	input CNN4IC_MOSI
);
//////////// PARAMETERS //////////
parameter IMAGEWIDTH = 784;
parameter DATAWIDTH_BUS = 8;
parameter ADDRESS_WIDTH = 16;
/*
parameter PRESCALER_DATAWIDTH = 23;
*/
wire [IMAGEWIDTH-1:0] Image_BUS;
wire [DATAWIDTH_BUS-1:0] Weight_BUS;
wire [ADDRESS_WIDTH-1:0] Adress_BUS;
wire Data_Ready;
wire Is_Weight;

// 1. Unidad de Interfaz Serial (SPI + Control)
SPI_Control #(.IMAGEWIDTH(IMAGEWIDTH), .DATAWIDTH_BUS(DATAWIDTH_BUS), .ADDRESS_WIDTH(ADDRESS_WIDTH)) SPI_Control_u0 (
	.SPI_Control_CLOCK_50(CNN4IC_CLOCK_50),
	.SPI_Control_RESET_InHigh(CNN4IC_RESET_InHigh),
	.SPI_Control_SPICLOCK_50(CNN4IC_SPICLOCK_50),
	.SPI_Control_SS_N(CNN4IC_SS_N),
	.SPI_Control_MOSI(CNN4IC_MOSI),
	.SPI_Control_MISO(CNN4IC_MISO),
	.SPI_Control_Data_OutBUS(Image_BUS),
	.SPI_Control_Weight_OutBUS(Weight_BUS),
	.SPI_Control_Addr_OutBUS(Adress_BUS),
	.SPI_Control_Data_Ready(Data_Ready),
	.SPI_Control_Is_Weight(Is_Weight)
);

// 2. Núcleo CNN (Convolutional Neural Network)
CNN #(.IMAGEWIDTH(IMAGEWIDTH), .DATAWIDTH_BUS(DATAWIDTH_BUS), .ADDRESS_WIDTH(ADDRESS_WIDTH)) CNN_u0 (
	.CNN_CLOCK_50(CNN4IC_CLOCK_50),
	.CNN_RESET_InHigh(CNN4IC_RESET_InHigh),
	.CNN_StartIn(Data_Ready && !Is_Weight),
	.CNN_Image_DataInBUS(Image_BUS),
	.CNN_New_WeightInBUS(Weight_BUS),
	.CNN_WeightAdress_InBUS(Adress_BUS),
	.CNN_LoadWeight_InLow(Data_Ready && Is_Weight),
	.CNN_Prediction_DataOutBUS(CNN4IC_Data_OutBUS) //predicted digit
);

endmodule
