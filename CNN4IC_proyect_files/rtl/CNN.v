module CNN #(	parameter IMAGEWIDTH = 784,
					parameter DATAWIDTH_BUS = 8,
					parameter ADDRESS_WIDTH = 16)(
    //////////// OUTPUTS //////////
    output [3:0] CNN_Prediction_DataOutBUS, // El dígito predicho (0-9)
	
    //////////// INPUTS //////////
    input     						   CNN_CLOCK_50,
    input       						CNN_RESET_InHigh,
    input       						CNN_StartIn,
    input [IMAGEWIDTH-1:0] 		CNN_Image_DataInBUS, // Los 784 bits de la imagen 
    input [DATAWIDTH_BUS-1:0] 	CNN_New_WeightInBUS, // Pesos de 8 bits 
    input [ADDRESS_WIDTH-1:0] 	CNN_WeightAdress_InBUS,
    input        						CNN_LoadWeight_InLow
);

//=======================================================
//  REG/WIRE declarations (Control & Routing)
//=======================================================
    
    // Señales de Habilitación (Salen de la Control_Unit)
    wire CNN_Ctrl_Conv0_Enable_cwire;
    wire CNN_Ctrl_Pool0_Enable_cwire;
    wire CNN_Ctrl_Conv1_Enable_cwire;
    wire CNN_Ctrl_Pool1_Enable_cwire;
    wire CNN_Ctrl_FC0_Enable_cwire;
    wire CNN_Ctrl_Max0_Enable_cwire;

    // Señales de Finalización (Entran a la Control_Unit)
    wire CNN_Conv_u0_Done_cwire;
    wire CNN_Pool_u0_Done_cwire;
    wire CNN_Conv_u1_Done_cwire;
    wire CNN_Pool_u1_Done_cwire;
    wire CNN_FC_u0_Done_cwire;
	 
	 // Buses de datos intermedios
    wire [13:0] CNN_Conv_u0_DataOutBUS_routing_cwire; // 14 bits etapa 1
    wire [7:0]  CNN_Requant_u0_DataOutBUS_routing_cwire; // Re-cuantización (8 bits)
    wire [7:0]  CNN_Pool_u0_DataOutBUS_routing_cwire; // Pooling (2x2 Half Resolution)
    wire [21:0] CNN_Conv_u1_DataOutBUS_routing_cwire; // 22 bits etapa 2
    wire [7:0]  CNN_Requant_u1_DataOutBUS_routing_cwire; // Re-cuantización (8 bits)
    wire [7:0]  CNN_Pool_u1_DataOutBUS_routing_cwire; // Pooling (2x2 Half Resolution)
    wire [DATAWIDTH_BUS-1:0] CNN_FC_u0_DataOutBUS_routing_cwire; // Vector de probabilidades

//=======================================================
//  Structural coding: INSTANTIATIONS
//=======================================================
	 
// 1. CAPA CONVOLUCIONAL 1
 Conv #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) Conv_u0 (
		.Conv_Enable(CNN_Ctrl_Conv0_Enable_cwire),
		.Conv_InBUS(CNN_Image_DataInBUS),
		.Conv_OutBUS(CNN_Conv_u0_DataOutBUS_routing_cwire),
		.Conv_Done(CNN_Conv_u0_Done_cwire)
 );

 // 2. RE-CUANTIZACIÓN 1 (Lógica combinacional, no requiere enable)
 Requant #(.DATAIN_WIDTH(14)) Requant_u0 (
		.Requant_InBUS(CNN_Conv_u0_DataOutBUS_routing_cwire),
		.Requant_OutBUS(CNN_Requant_u0_DataOutBUS_routing_cwire)
 );

 // 3. MAX POOLING 1
 Pool Pool_u0 (
		.Pool_Enable(CNN_Ctrl_Pool0_Enable_cwire),
		.Pool_InBUS(CNN_Requant_u0_DataOutBUS_routing_cwire),
		.Pool_OutBUS(CNN_Pool_u0_DataOutBUS_routing_cwire),
		.Pool_Done(CNN_Pool_u0_Done_cwire)
 );

 // 4. CAPA CONVOLUCIONAL 2
 Conv #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) Conv_u1 (
		.Conv_Enable(CNN_Ctrl_Conv1_Enable_cwire),
		.Conv_InBUS(CNN_Pool_u0_DataOutBUS_routing_cwire),
		.Conv_OutBUS(CNN_Conv_u1_DataOutBUS_routing_cwire),
		.Conv_Done(CNN_Conv_u1_Done_cwire)
 );

 // 5. RE-CUANTIZACIÓN 2
 Requant #(.DATAIN_WIDTH(22)) Requant_u1 (
		.Requant_InBUS(CNN_Conv_u1_DataOutBUS_routing_cwire),
		.Requant_OutBUS(CNN_Requant_u1_DataOutBUS_routing_cwire)
 );

 // 6. MAX POOLING 2
 Pool Pool_u1 (
		.Pool_Enable(CNN_Ctrl_Pool1_Enable_cwire),
		.Pool_InBUS(CNN_Requant_u1_DataOutBUS_routing_cwire),
		.Pool_OutBUS(CNN_Pool_u1_DataOutBUS_routing_cwire),
		.Pool_Done(CNN_Pool_u1_Done_cwire)
 );

 // 7. FULLY CONNECTED LAYER
 FC #(.DATAWIDTH_BUS(DATAWIDTH_BUS)) FC_u0 (
		.FC_Enable(CNN_Ctrl_FC0_Enable_cwire),
		.FC_InBUS(CNN_Pool_u1_DataOutBUS_routing_cwire),
		.FC_OutBUS(CNN_FC_u0_DataOutBUS_routing_cwire),
		.FC_Done(CNN_FC_u0_Done_cwire)
 );

 // 8. MAX ACTIVATION (ARGMAX)
 Max_Activation Max_Act_u0 (
		.Max_Enable(CNN_Ctrl_Max0_Enable_cwire),
		.Max_InBUS(CNN_FC_u0_DataOutBUS_routing_cwire),
		.Max_OutBUS(CNN_Prediction_DataOutBUS)
 );

// INSTANCIA DE LA UNIDAD DE CONTROL (FSM)
CNN_Control_Unit CNN_Control_Unit_u0 (
		.CNN_Ctrl_CLOCK_50(CNN_CLOCK_50),
		.CNN_Ctrl_RESET_InHigh(CNN_RESET_InHigh),
		.CNN_Ctrl_Start_InLow(CNN_StartIn), // Asumiendo que CNN_StartIn viene de un botón (InLow)
 		.CNN_Ctrl_Conv0_Done_InHigh(CNN_Conv_u0_Done_cwire),
		.CNN_Ctrl_Pool0_Done_InHigh(CNN_Pool_u0_Done_cwire),
		.CNN_Ctrl_Conv1_Done_InHigh(CNN_Conv_u1_Done_cwire),
		.CNN_Ctrl_Pool1_Done_InHigh(CNN_Pool_u1_Done_cwire),
		.CNN_Ctrl_FC0_Done_InHigh(CNN_FC_u0_Done_cwire),
		// Salidas de habilitación
		.CNN_Ctrl_Conv0_Enable_Out_Data(CNN_Ctrl_Conv0_Enable_cwire),
		.CNN_Ctrl_Pool0_Enable_Out_Data(CNN_Ctrl_Pool0_Enable_cwire),
		.CNN_Ctrl_Conv1_Enable_Out_Data(CNN_Ctrl_Conv1_Enable_cwire),
		.CNN_Ctrl_Pool1_Enable_Out_Data(CNN_Ctrl_Pool1_Enable_cwire),
		.CNN_Ctrl_FC0_Enable_Out_Data(CNN_Ctrl_FC0_Enable_cwire),
		.CNN_Ctrl_Max0_Enable_Out_Data(CNN_Ctrl_Max0_Enable_cwire)
);

endmodule