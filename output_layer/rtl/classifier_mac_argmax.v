// ============================================================
// MAC + ArgMax para última capa (sin FSM)
// - new_feat: acumula 1 producto (misma clase)
// - new_class: termina clase -> compara contra max y limpia acumulador
// - rst_n: limpia max_score y max_class (solo con reset)
// - clr_acc_n: clear acumulador activo en LOW (derivado de new_class)
// ============================================================

module classifier_mac_argmax #(
    parameter int CLASS_BITS = 3   // bits para indexar clases (ej: 3 -> hasta 8)
)(
    input  wire               clk,
    input  wire               rst_n,       // reset global activo en 0

    // Datos (un par por evento new_feat)
    input  wire signed [3:0]  x_int4,
    input  wire signed [7:0]  w_int8,

    // Eventos
    input  wire               new_feat,    // 1 ciclo: hay (x,w) nuevo de la MISMA clase
    input  wire               new_class,   // 1 ciclo: se cerró el score de la clase actual

    // ID de la clase cuyo score se acaba de cerrar (válido cuando new_class=1)
    input  wire [CLASS_BITS-1:0] class_id,

    // Salidas útiles
    output wire signed [19:0] acc20,
    output wire signed [19:0] max_score,
    output wire [CLASS_BITS-1:0] max_class
);

    // -------------------------
    // 1) Multiplicador int4*int8 -> int12
    // -------------------------
    wire signed [11:0] prod12;
    assign prod12 = x_int4 * w_int8;

    // -------------------------
    // 2) Sumador: acc20 + prod12 -> sum20
    // (extensión de signo de prod12 a 20 bits)
    // -------------------------
    wire signed [19:0] prod20 = {{8{prod12[11]}}, prod12};
    wire signed [19:0] sum20;

    // acc_q es el estado del acumulador
    reg signed [19:0] acc_q;

    assign sum20 = acc_q + prod20;
    assign acc20 = acc_q;

    // -------------------------
    // 3) Acumulador con clear activo LOW
    // - clear por nueva clase (y opcionalmente por reset)
    // -------------------------
    wire clr_acc_n = ~new_class; // activo LOW cuando new_class=1

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_q <= '0;
        end else if (!clr_acc_n) begin
            // nueva clase: limpiar acumulador
            acc_q <= '0;
        end else if (new_feat) begin
            // acumula 1 vez por feature válido
            acc_q <= sum20;
        end
        // else hold
    end

    // -------------------------
    // 4) Comparador y registros de máximo (solo se limpian con reset)
    // Se actualizan SOLO cuando new_class=1 (fin de clase)
    // -------------------------
    reg signed [19:0] max_q;
    reg [CLASS_BITS-1:0] maxc_q;

    wire gt = (acc_q > max_q);           // compara score final de clase vs max actual
    wire update_max = new_class & gt;    // solo al cerrar una clase

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            max_q  <= '0;
            maxc_q <= '0;
        end else if (update_max) begin
            max_q  <= acc_q;
            maxc_q <= class_id;
        end
        // else hold
    end

    assign max_score = max_q;
    assign max_class = maxc_q;

endmodule
