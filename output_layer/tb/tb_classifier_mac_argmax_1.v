`timescale 1ns/1ps

module tb_classifier_mac_argmax_1;

  // ----------------------------
  // Parámetros del DUT
  // ----------------------------
  localparam int CLASS_BITS = 3;

  // ----------------------------
  // Señales DUT
  // ----------------------------
  reg  clk;
  reg  rst_n;

  reg  signed [3:0]  x_int4;
  reg  signed [7:0]  w_int8;
  reg                new_feat;
  reg                new_class;
  reg  [CLASS_BITS-1:0] class_id;

  wire signed [19:0] acc20;
  wire signed [19:0] max_score;
  wire [CLASS_BITS-1:0] max_class;

  // ----------------------------
  // Instancia DUT
  // ----------------------------
  classifier_mac_argmax_modular #(
    .CLASS_BITS(CLASS_BITS)
  ) dut (
    .clk      (clk),
    .rst_n    (rst_n),
    .x_int4   (x_int4),
    .w_int8   (w_int8),
    .new_feat (new_feat),
    .new_class(new_class),
    .class_id (class_id),
    .acc20    (acc20),
    .max_score(max_score),
    .max_class(max_class)
  );

  // ----------------------------
  // Clock 100MHz (10ns)
  // ----------------------------
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // ----------------------------
  // Task: aplicar un "ciclo" del stream
  //   - setea señales
  //   - espera flanco positivo
  // ----------------------------
  task drive_cycle(
    input reg feat,
    input reg cls,
    input signed [3:0] x,
    input signed [7:0] w,
    input [CLASS_BITS-1:0] cid
  );
  begin
    new_feat  = feat;
    new_class = cls;
    x_int4    = x;
    w_int8    = w;
    class_id  = cid;

    @(posedge clk);
    #1; // pequeño delay para leer señales estables post-flanco
  end
  endtask

  // ----------------------------
  // Test
  // ----------------------------
  integer expected;

  initial begin
    // VCD para GTKWave
    $dumpfile("tb_classifier.vcd");
    $dumpvars(0, tb_classifier_mac_argmax_1);

    // init
    x_int4    = '0;
    w_int8    = '0;
    new_feat  = 1'b0;
    new_class = 1'b0;
    class_id  = '0;

    expected = 0;

    // reset
    rst_n = 1'b0;
    repeat (2) @(posedge clk);
    rst_n = 1'b1;
    @(posedge clk);

    // ------------------------------------------------------------
    // Stream (15 ciclos) EXACTO como el que imprimiste
    // ------------------------------------------------------------

    // Clase 0 (4 feats)
    drive_cycle(1, 0,  4'sd5,   8'sd36,  3'd0);
    drive_cycle(1, 0,  4'sd3,   8'sd69,  3'd0);
    drive_cycle(1, 0,  4'sd1,  -8'sd127, 3'd0);
    drive_cycle(1, 0,  4'sd0,  -8'sd39,  3'd0);
    // end class 0
    drive_cycle(0, 1,  4'sd0,   8'sd0,   3'd0);

    // Clase 1
    drive_cycle(1, 0,  4'sd5,   8'sd21,  3'd1);
    drive_cycle(1, 0,  4'sd3,  -8'sd13,  3'd1);
    drive_cycle(1, 0,  4'sd1,  -8'sd5,   3'd1);
    drive_cycle(1, 0,  4'sd0,  -8'sd46,  3'd1);
    // end class 1
    drive_cycle(0, 1,  4'sd0,   8'sd0,   3'd1);

    // Clase 2
    drive_cycle(1, 0,  4'sd5,  -8'sd68,  3'd2);
    drive_cycle(1, 0,  4'sd3,  -8'sd48,  3'd2);
    drive_cycle(1, 0,  4'sd1,   8'sd88,  3'd2);
    drive_cycle(1, 0,  4'sd0,   8'sd81,  3'd2);
    // end class 2 (última)
    drive_cycle(0, 1,  4'sd0,   8'sd0,   3'd2);

    // baja flags
    new_feat  = 1'b0;
    new_class = 1'b0;

    // Espera un poco para observar
    @(posedge clk);
    #1;

    // Check final
    $display("FINAL: max_class=%0d, max_score=%0d", max_class, max_score);

    if (max_class !== expected[CLASS_BITS-1:0]) begin
      $display("FAIL: expected max_class=%0d, got %0d", expected, max_class);
      $fatal;
    end else begin
      $display("PASS: expected max_class=%0d matches got %0d", expected, max_class);
    end

    $finish;
  end

endmodule
