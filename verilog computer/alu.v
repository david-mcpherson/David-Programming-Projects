`define ADD 2'b00
`define SUB 2'b01
`define AND 2'b10
`define NOT 2'b11
`define ALL_ZERO 16'b0000_0000_0000_0000

module ALU(Ain, Bin, ALUop, out, Z);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output [15:0] out;
    output Z;
    reg [15:0] out;
    reg Z;
    
    always @(*)
        case (ALUop)
            `ADD: out = Ain + Bin;
            `SUB: out = Ain - Bin;
            `AND: out = Ain & Bin;
            `NOT: out = ~Bin;
            default: out = {16{1'bx}};
        endcase
    
    always @(out)
        Z = (out == `ALL_ZERO) ? 1'b1 : 1'b0;
endmodule