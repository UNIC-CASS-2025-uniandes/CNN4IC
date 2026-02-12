// ============================================================
// 3) Registro signed: int8 con clear y load
//    - clr: fuerza 0
//    - load: carga d
//    Prioridad: clr > load > hold
// ============================================================


module reg_int20_clr_load (
    input  wire               clk,
    input  wire               rst_n,   // reset async activo en 0
    input  wire               clr,     // limpia a 0 (sync)
    input  wire               load,    // carga d (sync)
    input  wire signed [19:0] d,
    output reg  signed [19:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= '0;
        else if (clr)
            q <= '0;
        else if (load)
            q <= d;
    end
endmodule
