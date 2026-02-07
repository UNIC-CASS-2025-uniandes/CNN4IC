module SPI_Control #(
    parameter IMAGEWIDTH = 784,
    parameter DATAWIDTH_BUS = 8,
    parameter ADDRESS_WIDTH = 16
)(
    //////////// OUTPUTS //////////
    output                          SPI_Control_MISO,
    output reg [DATAWIDTH_BUS-1:0]  SPI_Control_Data_OutBUS,
    output                          SPI_Control_Weight_OutBUS,
    output                          SPI_Control_Addr_OutBUS,
    output                          SPI_Control_Data_Ready,
    output                          SPI_Control_Is_Weight,
    
    //////////// INPUTS //////////
    input                           SPI_Control_CLOCK_50,
    input                           SPI_Control_RESET_InHigh,
    input                           SPI_Control_SPICLOCK_50,
    input                           SPI_Control_SS_N,
    input                           SPI_Control_MOSI
);

always @(posedge SPI_Control_CLOCK_50 or posedge SPI_Control_RESET_InHigh) begin
    if (SPI_Control_RESET_InHigh)
        SPI_Control_Data_OutBUS <= {DATAWIDTH_BUS{1'b0}};
    else
        SPI_Control_Data_OutBUS <= 1'b0;
end

endmodule
