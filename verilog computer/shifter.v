`define NO_SHIFT    2'b00
`define LS          2'b01   // left-shift
`define RS_MSB_0    2'b10   // right-shift; msb = 0
`define RS_MSB_CP   2'b11   // right-shift; msb is a copy of in[15]

module shifter(in, shift, sout);
    input [15:0] in;
    input [1:0] shift;
    output [15:0] sout;
    reg [15:0] sout;
    
    always @(*)
        case (shift)
            `NO_SHIFT: sout = in;
            `LS: sout = {in[14:0], 1'b0};
            `RS_MSB_0: sout = {1'b0, in[15:1]};
            `RS_MSB_CP: sout = {in[15], in[15:1]};
        endcase    
endmodule