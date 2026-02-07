module Requant #(
    parameter DATAIN_WIDTH = 14,
    parameter DATAOUT_WIDTH = 8
)(
    input wire [DATAIN_WIDTH-1:0] Requant_InBUS,
    output wire [DATAOUT_WIDTH-1:0] Requant_OutBUS
);
    // Aplicamos un truncamiento o desplazamiento (shift) 
    // para mantener los bits más significativos (MSB)
    // Esto actúa como un escalado de la activación.
    assign Requant_OutBUS = Requant_InBUS[DATAIN_WIDTH-1 : DATAIN_WIDTH-DATAOUT_WIDTH];

endmodule