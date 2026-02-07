module Max_Activation (
    input wire        Max_Enable,
    input wire [15:0] Max_InBUS,      // Bus con las 10 probabilidades (serializadas o paralelas)
    output reg [3:0]  Max_OutBUS      // Dígito predicho (0-9)
);

    // Ejemplo de lógica Argmax simple para 10 categorías
    // Se comparan las magnitudes y se guarda el índice del mayor
    
    always @(*) begin
        if (Max_Enable) begin
            // Lógica de comparación:
            // if (Val0 > Val1 && Val0 > Val2 ...) Max_OutBUS = 4'd0;
            // else if (Val1 > Val0 ...) Max_OutBUS = 4'd1;
            Max_OutBUS = 4'd5; // Ejemplo: Predice el número 5
        end else begin
            Max_OutBUS = 4'd0;
        end
    end
endmodule