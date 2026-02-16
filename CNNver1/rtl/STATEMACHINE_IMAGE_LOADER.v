//=======================================================
//  MODULE Definition
//=======================================================
module SC_STATEMACHINE_IMAGE_LOADER (
    //////////// OUTPUTS //////////
    output reg o_load00, output reg o_load01,
    output reg o_load02, output reg o_load03,
    output reg o_load04, output reg o_load05,
    output reg o_load06, output reg o_load07,
    //////////// INPUTS //////////
    input i_CLOCK,
    input i_RESET,
    input [1:0] i_CMD,
    input [6:0] i_DATA_COUNT,
    input [3:0] i_ROW
);

//=======================================================
//  PARAMETER declarations
//=======================================================
localparam STATE_IDLE      = 0;
localparam STATE_LOAD_ROW  = 1;
localparam STATE_WAIT_NEXT = 2;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [2:0] STATE_Register;
reg [2:0] STATE_Signal;

//=======================================================
//  Structural coding
//=======================================================

// NEXT STATE LOGIC
always @(*) begin
    case (STATE_Register)
        STATE_IDLE: 
            // Si comando es LOAD IMAGE y estamos en el último bit del byte
            if (i_CMD == 2'b00 && i_DATA_COUNT == 7) STATE_Signal = STATE_LOAD_ROW;
            else STATE_Signal = STATE_IDLE;
            
        STATE_LOAD_ROW: 
            STATE_Signal = STATE_WAIT_NEXT;
            
        STATE_WAIT_NEXT:
            // Esperamos a que el contador de datos reinicie para volver a IDLE
            if (i_DATA_COUNT == 0) STATE_Signal = STATE_IDLE;
            else STATE_Signal = STATE_WAIT_NEXT;
            
        default: STATE_Signal = STATE_IDLE;
    endcase
end

// STATE REGISTER
always @(posedge i_CLOCK or posedge i_RESET) begin
    if (i_RESET == 1'b1)
        STATE_Register <= STATE_IDLE;
    else
        STATE_Register <= STATE_Signal;
end

//=======================================================
//  Outputs (LOGICA ACTIVA BAJA)
//=======================================================
always @(*) begin
    // Valores por defecto: 1 (Inactivo)
    o_load00 = 1'b1; o_load01 = 1'b1; o_load02 = 1'b1; o_load03 = 1'b1;
    o_load04 = 1'b1; o_load05 = 1'b1; o_load06 = 1'b1; o_load07 = 1'b1;

    case (STATE_Register)
        STATE_LOAD_ROW: begin
            case (i_ROW)
                4'd0: o_load00 = 1'b0; // Activa carga de fila 0
                4'd1: o_load01 = 1'b0;
                4'd2: o_load02 = 1'b0;
                4'd3: o_load03 = 1'b0;
                4'd4: o_load04 = 1'b0;
                4'd5: o_load05 = 1'b0;
                4'd6: o_load06 = 1'b0;
                4'd7: o_load07 = 1'b0;
					 default: ;
            endcase
        end
        default: ; // Se mantienen en 1
    endcase
end

endmodule