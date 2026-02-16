// ============================================================
// 1) Multiplicador signed: int4 * int8 -> int12
// ============================================================

module mul_int4_int8_to_int12 (
    input  wire signed [3:0]  a,   // int4
    input  wire signed [7:0]  b,   // int8
    output wire signed [11:0] y    // int12
);
    // 4+8 = 12 bits exactos para el producto en 2's complement
    assign y = a * b;
endmodule