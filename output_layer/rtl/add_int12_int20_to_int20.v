// ============================================================
// 2) Sumador signed: int12 + int20 -> int20
// ============================================================


module add_int12_int20_to_int20 (
    input  wire signed [11:0] in12, // int12
    input  wire signed [19:0] in20,  // int20
    output wire signed [19:0] out20  // int20
);
    wire signed [19:0] in12_ext;

    // Extensión de signo de 12 a 20 bits
    assign in12_ext = {{8{in12[11]}}, in12};

    // Suma; se mantiene en 20 bits (overflow se trunca naturalmente)
    assign out20 = in20 + in12_ext;
endmodule