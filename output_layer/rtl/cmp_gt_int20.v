
module cmp_gt_int20 (
    input  wire signed [19:0] a,
    input  wire signed [19:0] b,
    output wire               gt
);
    assign gt = (a > b);
endmodule
