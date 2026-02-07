module Conv #(
    parameter DATAWIDTH_BUS = 8,
    parameter KERNEL_SIZE = 5,
    parameter IMAGE_SIZE = 28
)(
    input wire Conv_Enable,
    input wire [783:0] Conv_InBUS, // Para Conv0 (Imagen completa)
    output reg [13:0] Conv_OutBUS, // 14 bits para etapa 1
    output reg Conv_Done
);
    // Para simplificar el diseño en hardware, se suelen usar sumadores paralelos
    // En una implementación real, aquí instanciarías los Multiplicadores-Acumuladores (MAC)
    
    always @(*) begin
        if (Conv_Enable) begin
            // Lógica de convolución:
            // 1. Multiplicar ventana 5x5 por Kernel
            // 2. Sumar resultados + Bias
            Conv_Done = 1'b1; // Señalizar fin tras completar el mapa
        end else begin
            Conv_Done = 1'b0;
        end
    end
endmodule