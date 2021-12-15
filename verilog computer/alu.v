// ALU operations
`define ADD 2'b00
`define SUB 2'b01
`define AND 2'b10
`define NOT 2'b11

module ALU(Ain, Bin, ALUop, out, Z, N, V);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg Z, N, V;
    
    always @(*)
        case (ALUop)
            `ADD: out = Ain + Bin;
            `SUB: out = Ain - Bin;
            `AND: out = Ain & Bin;
            `NOT: out = ~Bin;
            default: out = {16{1'bx}};
        endcase
    
    always @(*) begin
        Z = ~|out;
        N = out[15];
        V = (ALUop[1]^1'b1) & (Ain[15]^out[15]) & ((ALUop[0] ? ~Bin[15] : Bin[15])^out[15]);
    end
endmodule