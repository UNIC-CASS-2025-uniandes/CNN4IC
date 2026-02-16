module Register #(parameter DATAWIDTH_BUS = 8)(
    input  wire [DATAWIDTH_BUS-1:0] Register_DataInBUS, // <--- Agregar esto
    input  wire Register_CLOCK,
    input  wire Register_Reset_InHigh,
    input  wire Register_Load_InLow,
    
    output wire [DATAWIDTH_BUS-1:0] Register_DataOutBUS // <--- Agregar esto
);

    reg [DATAWIDTH_BUS-1:0] Datos;

    always @(posedge Register_CLOCK) begin
         if (Register_Reset_InHigh == 1'b1) begin
              Datos <= {DATAWIDTH_BUS{1'b0}};
         end  
         else if (Register_Load_InLow == 1'b0) begin
              Datos <= Register_DataInBUS;
         end
    end

    assign Register_DataOutBUS = Datos;
endmodule