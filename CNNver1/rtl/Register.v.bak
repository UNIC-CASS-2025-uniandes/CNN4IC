module Weight_Registers #(
    parameter DATAWIDTH_BUS = 8,
    parameter ADDRESS_WIDTH = 16,
    parameter NUM_WEIGHTS = 10422 // Maximo
)(
    input wire Weight_Clock_In_Data,
    input wire Weight_Reset_InHigh,
    
    // Interfaz de carga (desde SPI)
    input wire [ADDRESS_WIDTH-1:0] Weight_Addr_In_DataBUS,
    input wire [DATAWIDTH_BUS-1:0] Weight_Data_In_DataBUS,
    input wire                     Weight_Load_InLow,
    
    // Interfaz de lectura (hacia CNN)
    input wire [ADDRESS_WIDTH-1:0] Weight_ReadAddr_In_DataBUS,
    output wire [DATAWIDTH_BUS-1:0] Weight_ReadData_Out_DataBUS
);

    // Arreglo de memoria (Banco de registros)
    reg [DATAWIDTH_BUS-1:0] mem [0:NUM_WEIGHTS-1];

    // Escritura Sincrónica
    always @(posedge Weight_Clock_In_Data) begin
        if (Weight_Load_InLow == 1'b0) begin
            mem[Weight_Addr_In_DataBUS] <= Weight_Data_In_DataBUS;
        end
    end

    // Lectura Asincrónica (para acceso rápido durante el cálculo)
    assign Weight_ReadData_Out_DataBUS = mem[Weight_ReadAddr_In_DataBUS];

endmodule