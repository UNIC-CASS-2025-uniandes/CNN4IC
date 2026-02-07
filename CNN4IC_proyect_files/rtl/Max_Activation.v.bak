module Pool (
    input wire Pool_Enable,
    input wire [7:0] Pool_InBUS,
    output reg [7:0] Pool_OutBUS,
    output reg Pool_Done
);
    // Lógica simplificada de comparación
    // reg [7:0] max_val;
    
    always @(*) begin
        if (Pool_Enable) begin
            // Comparar 4 píxeles adyacentes (2x2)
            // Pool_OutBUS = (A > B) ? A : B ...
            Pool_Done = 1'b1;
        end else begin
            Pool_Done = 1'b0;
        end
    end
endmodule