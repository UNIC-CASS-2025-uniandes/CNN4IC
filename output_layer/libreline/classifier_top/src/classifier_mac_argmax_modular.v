`timescale 1ns/1ps

module classifier_mac_argmax_modular #(
    parameter int CLASS_BITS = 3
)(
    input  wire               clk,
    input  wire               rst_n,

    // Datos por ciclo (válidos cuando new_feat=1)
    input  wire signed [3:0]  x_int4,
    input  wire signed [7:0]  w_int8,

    // Eventos
    input  wire               new_feat,   // acumula 1 vez
    input  wire               new_class,  // terminó clase: compara/actualiza max y limpia acumulador

    // ID de clase (válido cuando new_class=1)
    input  wire [CLASS_BITS-1:0] class_id,

    // Salidas útiles
    output wire signed [19:0] acc20,
    output wire signed [19:0] max_score,
    output wire [CLASS_BITS-1:0] max_class
);

    // -------------------------
    // Wires internos
    // -------------------------
    wire signed [11:0] prod12;
    wire signed [19:0] acc_fb;
    wire signed [19:0] sum20;

    wire signed [19:0] max_score_q;
    wire               gt;
    wire               update_max;

    // -------------------------
    // 1) Multiplicador: int4 * int8 -> int12
    // -------------------------
    mul_int4_int8_to_int12 u_mul (
        .a (x_int4),
        .b (w_int8),
        .y (prod12)
    );

    // -------------------------
    // 2) Sumador: int12 + int20 -> int20
    //    (in12 = prod12, in20 = acc_fb)
    // -------------------------
    add_int12_int20_to_int20 u_add (
        .in12 (prod12),
        .in20 (acc_fb),
        .out20(sum20)
    );

    // -------------------------
    // 3) Acumulador (reg_int20_clr_load)
    //    - load cuando new_feat=1
    //    - clear cuando new_class=1 (sync)
    // -------------------------
    reg_int20_clr_load u_acc (
        .clk  (clk),
        .rst_n(rst_n),
        .clr  (new_class),  // clear sync activo HIGH
        .load (new_feat & ~new_class),
        .d    (sum20),
        .q    (acc_fb)
    );

    assign acc20 = acc_fb;

    // -------------------------
    // 4) Comparador: acc_fb > max_score_q
    // -------------------------
    cmp_gt_int20 u_cmp (
        .a  (acc_fb),
        .b  (max_score_q),
        .gt (gt)
    );

    // Solo actualizamos max al final de cada clase
    assign update_max = new_class & gt;

    // -------------------------
    // 5) Registro max_score (usa el mismo reg_int20_clr_load)
    //    - clr SOLO por reset (clr amarrado a 0)
    //    - load solo cuando update_max=1
    // -------------------------
    reg_int20_clr_load u_max_score (
        .clk  (clk),
        .rst_n(rst_n),
        .clr  (1'b0),        // SOLO reset borra el max_score
        .load (update_max),
        .d    (acc_fb),
        .q    (max_score_q)
    );

    assign max_score = max_score_q;

    // -------------------------
    // 6) Registro max_class (reg genérico N bits)
    //    - clr SOLO por reset (clr amarrado a 0)
    //    - load cuando update_max=1
    // -------------------------
    reg_intN_clr_load #(
        .N(CLASS_BITS)
    ) u_max_class (
        .clk  (clk),
        .rst_n(rst_n),
        .clr  (1'b0),         // SOLO reset borra el max_class
        .load (update_max),
        .d    (class_id),
        .q    (max_class)
    );

endmodule
