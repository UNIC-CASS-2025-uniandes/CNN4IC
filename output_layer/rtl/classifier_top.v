
module classifier_top (
  input  wire clk,
  input  wire rst_n,
  input  wire signed [3:0]  x_int4,
  input  wire signed [7:0]  w_int8,
  input  wire new_feat,
  input  wire new_class,
  input  wire [2:0] class_id,
  output wire signed [19:0] acc20,
  output wire signed [19:0] max_score,
  output wire [2:0] max_class
);
  classifier_mac_argmax #(.CLASS_BITS(3)) u (
    .clk, .rst_n, .x_int4, .w_int8, .new_feat, .new_class, .class_id,
    .acc20, .max_score, .max_class
  );
endmodule
