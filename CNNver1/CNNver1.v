
module CNNver1 (
//////////// OUTPUTS //////////
	output CNNver1_MISO,
	
//////////// INPUTS ///////////
	input CNNver1_SPICLOCK_50,
	input CNNver1_SS_N,
	input CNNver1_MOSI
);
//////////// PARAMETERS //////////
parameter DATAWIDTH_BUS = 8;

//////////// WIRE //////////
wire [7:0]  SPI_2_CNN_Start_routing_cwire;
wire [7:0]  SPI_2_row00_DataOutBUS_routing_cwire;
wire [7:0]  SPI_2_row01_DataOutBUS_routing_cwire;
wire [7:0]  SPI_2_row02_DataOutBUS_routing_cwire;
wire [7:0]  SPI_2_row03_DataOutBUS_routing_cwire;
wire [7:0]  SPI_2_row04_DataOutBUS_routing_cwire;
wire [7:0]  SPI_2_row05_DataOutBUS_routing_cwire;
wire [7:0]  SPI_2_row06_DataOutBUS_routing_cwire;
wire [7:0]  SPI_2_row07_DataOutBUS_routing_cwire;

wire [7:0]	Register_u0_DataOutBUS_routing_cwire;
wire [7:0]	Register_u1_DataOutBUS_routing_cwire;
wire [7:0]	Register_u2_DataOutBUS_routing_cwire;
wire [7:0]	Register_u3_DataOutBUS_routing_cwire;
wire [7:0]	Register_u4_DataOutBUS_routing_cwire;
wire [7:0]	Register_u5_DataOutBUS_routing_cwire;
wire [7:0]	Register_u6_DataOutBUS_routing_cwire;
wire [7:0]	Register_u7_DataOutBUS_routing_cwire;

//WIRES PENDIENTES DE CORRECTO USO//
wire CNNver1_Load_InLow;
wire CNNver1_Reset_InHigh;


// 1. Unidad de Interfaz Serial (SPI + Control)
spi_cnn_slave_8 #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) spi_cnn_slave_8_u0 (
	.i_SPI_Clk(CNNver1_SPICLOCK_50),
	.i_SPI_CS_n(CNNver1_SS_N),
	.i_SPI_MOSI(CNNver1_MOSI),
	.o_SPI_MISO(CNNver1_MISO),
	.o_start_cnn(SPI_2_CNN_Start_routing_cwire),
	.o_row00 (SPI_2_row00_DataOutBUS_routing_cwire),
	.o_row01 (SPI_2_row01_DataOutBUS_routing_cwire),
	.o_row02 (SPI_2_row02_DataOutBUS_routing_cwire),
	.o_row03 (SPI_2_row03_DataOutBUS_routing_cwire),
	.o_row04 (SPI_2_row04_DataOutBUS_routing_cwire),
	.o_row05 (SPI_2_row05_DataOutBUS_routing_cwire),
	.o_row06 (SPI_2_row06_DataOutBUS_routing_cwire),
	.o_row07 (SPI_2_row07_DataOutBUS_routing_cwire)
);

Register #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) register_u0 (
	.Register_DataInBUS(SPI_2_row00_DataOutBUS_routing_cwire),
	.Register_CLOCK (CNNver1_SPICLOCK_50),
	.Register_Reset_InHigh (CNNver1_Reset_InHigh),
	.Register_Load_InLow (CNNver1_Load_InLow),
	.Register_DataOutBUS (Register_u0_DataOutBUS_routing_cwire)
);

Register #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) register_u1 (
	.Register_DataInBUS(SPI_2_row01_DataOutBUS_routing_cwire),
	.Register_CLOCK (CNNver1_SPICLOCK_50),
	.Register_Reset_InHigh (CNNver1_Reset_InHigh),
	.Register_Load_InLow (CNNver1_Load_InLow),
	.Register_DataOutBUS (Register_u1_DataOutBUS_routing_cwire)
);

Register #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) register_u2 (
	.Register_DataInBUS(SPI_2_row02_DataOutBUS_routing_cwire),
	.Register_CLOCK (CNNver1_SPICLOCK_50),
	.Register_Reset_InHigh (CNNver1_Reset_InHigh),
	.Register_Load_InLow (CNNver1_Load_InLow),
	.Register_DataOutBUS (Register_u2_DataOutBUS_routing_cwire)
);

Register #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) register_u3 (
	.Register_DataInBUS(SPI_2_row03_DataOutBUS_routing_cwire),
	.Register_CLOCK (CNNver1_SPICLOCK_50),
	.Register_Reset_InHigh (CNNver1_Reset_InHigh),
	.Register_Load_InLow (CNNver1_Load_InLow),
	.Register_DataOutBUS (Register_u3_DataOutBUS_routing_cwire)
);

Register #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) register_u4 (
	.Register_DataInBUS(SPI_2_row04_DataOutBUS_routing_cwire),
	.Register_CLOCK (CNNver1_SPICLOCK_50),
	.Register_Reset_InHigh (CNNver1_Reset_InHigh),
	.Register_Load_InLow (CNNver1_Load_InLow),
	.Register_DataOutBUS (Register_u4_DataOutBUS_routing_cwire)
);

Register #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) register_u5 (
	.Register_DataInBUS(SPI_2_row05_DataOutBUS_routing_cwire),
	.Register_CLOCK (CNNver1_SPICLOCK_50),
	.Register_Reset_InHigh (CNNver1_Reset_InHigh),
	.Register_Load_InLow (CNNver1_Load_InLow),
	.Register_DataOutBUS (Register_u5_DataOutBUS_routing_cwire)
);

Register #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) register_u6 (
	.Register_DataInBUS(SPI_2_row06_DataOutBUS_routing_cwire),
	.Register_CLOCK (CNNver1_SPICLOCK_50),
	.Register_Reset_InHigh (CNNver1_Reset_InHigh),
	.Register_Load_InLow (CNNver1_Load_InLow),
	.Register_DataOutBUS (Register_u6_DataOutBUS_routing_cwire)
);

Register #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) register_u7 (
	.Register_DataInBUS(SPI_2_row07_DataOutBUS_routing_cwire),
	.Register_CLOCK (CNNver1_SPICLOCK_50),
	.Register_Reset_InHigh (CNNver1_Reset_InHigh),
	.Register_Load_InLow (CNNver1_Load_InLow),
	.Register_DataOutBUS (Register_u7_DataOutBUS_routing_cwire)
);


/*
// 2. Núcleo CNN (Convolutional Neural Network)
CNN #(.IMAGEWIDTH(IMAGEWIDTH), .DATAWIDTH_BUS(DATAWIDTH_BUS), .ADDRESS_WIDTH(ADDRESS_WIDTH)) CNN_u0 (
	.CNN_CLOCK_50(CNNver1_CLOCK_50),
	.CNN_RESET_InHigh(CNNver1_RESET_InHigh),
	.CNN_StartIn(Data_Ready && !Is_Weight),
	.CNN_Image_DataInBUS(Image_BUS),
	.CNN_New_WeightInBUS(Weight_BUS),
	.CNN_WeightAdress_InBUS(Adress_BUS),
	.CNN_LoadWeight_InLow(Data_Ready && Is_Weight),
	.CNN_Prediction_DataOutBUS(CNNver1_Data_OutBUS) //predicted digit
);
*/

endmodule
