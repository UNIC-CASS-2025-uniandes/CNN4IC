`timescale 1ns/1ps

module spi_cnn_slave (
    input  wire i_SPI_Clk,
    input  wire i_SPI_CS_n,
    input  wire i_SPI_MOSI,
    output wire o_SPI_MISO,
    output reg  o_start_cnn,

    // Salidas físicas de las 28 filas (Pinouts)
    output wire [27:0] o_row00, output wire [27:0] o_row01,
    output wire [27:0] o_row02, output wire [27:0] o_row03,
    output wire [27:0] o_row04, output wire [27:0] o_row05,
    output wire [27:0] o_row06, output wire [27:0] o_row07,
    output wire [27:0] o_row08, output wire [27:0] o_row09,
    output wire [27:0] o_row10, output wire [27:0] o_row11,
    output wire [27:0] o_row12, output wire [27:0] o_row13,
    output wire [27:0] o_row14, output wire [27:0] o_row15,
    output wire [27:0] o_row16, output wire [27:0] o_row17,
    output wire [27:0] o_row18, output wire [27:0] o_row19,
    output wire [27:0] o_row20, output wire [27:0] o_row21,
    output wire [27:0] o_row22, output wire [27:0] o_row23,
    output wire [27:0] o_row24, output wire [27:0] o_row25,
    output wire [27:0] o_row26, output wire [27:0] o_row27
);

    // Memorias internas
    reg [27:0] image_mem [0:27];
    reg [7:0]  weight_mem [0:10];
    
    // Asignación continua de la memoria a los puertos de salida
    assign o_row00 = image_mem[0];  assign o_row01 = image_mem[1];
    assign o_row02 = image_mem[2];  assign o_row03 = image_mem[3];
    assign o_row04 = image_mem[4];  assign o_row05 = image_mem[5];
    assign o_row06 = image_mem[6];  assign o_row07 = image_mem[7];
    assign o_row08 = image_mem[8];  assign o_row09 = image_mem[9];
    assign o_row10 = image_mem[10]; assign o_row11 = image_mem[11];
    assign o_row12 = image_mem[12]; assign o_row13 = image_mem[13];
    assign o_row14 = image_mem[14]; assign o_row15 = image_mem[15];
    assign o_row16 = image_mem[16]; assign o_row17 = image_mem[17];
    assign o_row18 = image_mem[18]; assign o_row19 = image_mem[19];
    assign o_row20 = image_mem[20]; assign o_row21 = image_mem[21];
    assign o_row22 = image_mem[22]; assign o_row23 = image_mem[23];
    assign o_row24 = image_mem[24]; assign o_row25 = image_mem[25];
    assign o_row26 = image_mem[26]; assign o_row27 = image_mem[27];

    // Registros internos de control
    reg [1:0]  cmd;
    reg [9:0]  bit_count; 
    reg [9:0]  data_count; 
    reg [4:0]  row;
    reg [27:0] image_shift;
    reg [7:0]  weight_shift;
    reg [13:0] weight_count;
    reg [3:0]  result = 4'd7;
    reg [2:0]  miso_count;
    reg        miso_active;

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
            bit_count <= bit_count + 1;

            if (bit_count < 2) begin
                cmd[1 - bit_count] <= i_SPI_MOSI;
                data_count <= 0;
            end
            else begin
                data_count <= data_count + 1;

                // LOAD IMAGE (00)
                if (cmd == 2'b00) begin
                    image_shift <= {image_shift[26:0], i_SPI_MOSI};
                    if (data_count == 27) begin
                        image_mem[row] <= {image_shift[26:0], i_SPI_MOSI};
                        row <= row + 1;
                        data_count <= 0; 
                    end
                end

                // LOAD WEIGHTS (01)
                else if (cmd == 2'b01) begin
                    weight_shift <= {weight_shift[6:0], i_SPI_MOSI};
                    if (data_count == 7) begin
                        weight_mem[weight_count] <= {weight_shift[6:0], i_SPI_MOSI};
                        weight_count <= weight_count + 1;
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
                        miso_count <= miso_count + 1;
                end
            end
        end
    end
endmodule