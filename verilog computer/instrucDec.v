`include "constants.v"

// Module decodes an instruction using purely combinational logic.
// Requires: 
//      instruction bus from Instruction Register
//      nsel from controlFSM
// Effects:
//      opcode, op for controlFSM
//      ALUop, readnum, writenum for datapath
module instructionDecoder(instruction, nsel, opcode, op, 
        sximm5, sximm8, shift, writenum, readnum);
    input [15:0] instruction;
    input [1:0] nsel;
    output reg [2:0] opcode, readnum, writenum;
    output reg [1:0] op, shift;
    output reg [15:0] sximm5, sximm8;
    
    // combinational logic block for decoding an instruction
    always @(instruction) begin
        opcode  =   instruction[15:13];
        op      =   instruction[12:11];
        sximm5  =   {{11{instruction[4]}}, instruction[4:0]};
        sximm8  =   {{8{instruction[7]}}, instruction[7:0]};
        shift   =   (opcode == `DP | opcode == `DT) ? instruction[4:3] : `NO_SHIFT;
    end
    
    // multiplexer chooses which register to write/read from
    always @(*) begin
        case(nsel)
            `Rn: writenum = instruction[10:8];
            `Rd: writenum = instruction[7:5];
            `Rm: writenum = instruction[2:0];
            default: writenum = {3'bxxx};
        endcase    
        readnum = writenum;
    end
endmodule