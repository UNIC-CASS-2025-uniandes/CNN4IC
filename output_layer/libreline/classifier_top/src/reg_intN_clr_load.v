
module reg_intN_clr_load #(
    parameter N = 3
)(
    input  wire           clk,
    input  wire           rst_n,
    input  wire           clr,
    input  wire           load,
    input  wire [N-1:0]   d,
    output reg  [N-1:0]   q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= '0;
        else if (clr) q <= '0;
        else if (load) q <= d;
    end
endmodule
