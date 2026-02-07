module Register #(parameter DATAWIDTH_BUS = 8)(
	input Register_DataInBUS,
	input Register_CLOCK,
	input Register_Reset_InHigh,
	input Register_Load_InLow,
	
	output Register_DataOutBUS
);

    // Arreglo de memoria
    reg [DATAWIDTH_BUS-1:0] Datos;

    // Escritura Sincrónica
    always @(posedge Register_CLOCK) begin
		 if (Register_Reset_InHigh == 1'b1) begin
			  Datos <= 8'b00000000;
		 end 
		 else if (Register_Load_InLow == 1'b0) begin
			  Datos <= Register_DataInBUS;
		 end
	end

    // Lectura Asincrónica (para acceso rápido durante el cálculo)
    assign Register_DataOutBUS = Datos;

endmodule