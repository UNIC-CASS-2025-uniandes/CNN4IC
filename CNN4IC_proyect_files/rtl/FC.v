module FC #(
    parameter DATAWIDTH_BUS = 8
)(
    input wire FC_Enable,
    input wire [7:0] FC_InBUS,       // Datos provenientes de Pool2
    output reg [15:0] FC_OutBUS,     // Resultado de la suma ponderada
    output reg FC_Done
);
    // En hardware, el FC suele ser un acumulador serial:
    // Resultado = Suma(Entrada_i * Peso_i) + Bias
    
    always @(*) begin
        if (FC_Enable) begin
            // Aquí se implementa el producto punto (Dot Product)
            // Se itera sobre los pesos de la capa densa
            FC_Done = 1'b1; 
        end else begin
            FC_Done = 1'b0;
        end
    end
endmodule