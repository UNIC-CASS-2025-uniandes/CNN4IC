//`timescale 1ns/1ps

module spi_cnn_slave_8 #(parameter DATAWIDTH_BUS = 8)(
    input  wire i_SPI_Clk,
    input  wire i_SPI_CS_n,
    input  wire i_SPI_MOSI,
    output wire o_SPI_MISO,
    output reg  o_start_cnn,

    // Salidas físicas de las 8 filas
    output wire [7:0] o_row00, output wire [7:0] o_row01,
    output wire [7:0] o_row02, output wire [7:0] o_row03,
    output wire [7:0] o_row04, output wire [7:0] o_row05,
    output wire [7:0] o_row06, output wire [7:0] o_row07,
    output wire o_load00, output wire o_load01,
    output wire o_load02, output wire o_load03,
    output wire o_load04, output wire o_load05,
    output wire o_load06, output wire o_load07
);

    // Memorias internas
    reg [7:0] image_mem [0:7];
    reg [7:0] weight_mem [0:7]; 
    
    // Asignación continua
    assign o_row00 = image_mem[0];  assign o_row01 = image_mem[1];
    assign o_row02 = image_mem[2];  assign o_row03 = image_mem[3];
    assign o_row04 = image_mem[4];  assign o_row05 = image_mem[5];
    assign o_row06 = image_mem[6];  assign o_row07 = image_mem[7];

    // Registros internos de control
    reg [1:0] cmd;
    reg [6:0] bit_count;  
    reg [6:0] data_count; 
    reg [3:0] row;        
    reg [7:0] image_shift;
    reg [7:0] weight_shift;
    reg [6:0] weight_count;
    reg [3:0] result = 4'd7;
    reg [2:0] miso_count;
    reg       miso_active;

    // Instancia de la Máquina de Estados según el estilo solicitado
    SC_STATEMACHINE_IMAGE_LOADER loader_image_sm (
        .i_CLOCK(i_SPI_Clk),
        .i_RESET(i_SPI_CS_n), // Reset cuando el CS es alto
        .i_CMD(cmd),
        .i_DATA_COUNT(data_count),
        .i_ROW(row),
        .o_load00(o_load00), .o_load01(o_load01),
        .o_load02(o_load02), .o_load03(o_load03),
        .o_load04(o_load04), .o_load05(o_load05),
        .o_load06(o_load06), .o_load07(o_load07)
    );

    assign o_SPI_MISO = (miso_active) ? result[3 - miso_count] : 1'bZ;

    always @(posedge i_SPI_Clk or posedge i_SPI_CS_n) begin
        if (i_SPI_CS_n) begin
            bit_count    <= 0;
            data_count   <= 0;
            row          <= 0;
            weight_count <= 0;
            miso_count   <= 0;
            miso_active  <= 0;
            o_start_cnn  <= 0;
            cmd          <= 2'b00;
        end
        else begin
            bit_count <= bit_count + 7'd1;

            if (bit_count < 2) begin
                cmd[1 - bit_count] <= i_SPI_MOSI;
                data_count <= 0;
            end
            else begin
                data_count <= data_count + 7'd1;
					 // LOAD IMAGE (00)
                if (cmd == 2'b00) begin
                    image_shift <= {image_shift[6:0], i_SPI_MOSI};
                    if (data_count == 7) begin
                        image_mem[row] <= {image_shift[6:0], i_SPI_MOSI};
                        row <= row + 4'd1;
                        data_count <= 0; 
                    end
                end
					 // LOAD WEIGHTS (01)
                else if (cmd == 2'b01) begin
                    weight_shift <= {weight_shift[6:0], i_SPI_MOSI};
                    if (data_count == 7) begin
                        weight_mem[weight_count] <= {weight_shift[6:0], i_SPI_MOSI};
                        weight_count <= weight_count + 7'd1;
                        data_count <= 0;
                    end
                end
					 // START CNN (10)
                else if (cmd == 2'b10) begin
                    o_start_cnn <= 1;
                end
					 // READ RESULT (11)
                else if (cmd == 2'b11) begin
                    miso_active <= 1;
                    if (miso_count < 4)
                        miso_count <= miso_count + 3'd1;
                end
            end
        end
    end
endmodule