// Lab 6: FSM controller for simple RISC machine
// Author: David McPherson
// Email: davidm04@ece.ubc.ca

`include "constants.v"

// Instantiates the following modules:
//      datapath, instructionDecoder, controlFSM
module cpu (
        clk,
        reset, 
        in, 
        out, 
        N, V, Z, 
        led9, led8, 
        mem_cmd, mem_addr
    );
    
    input clk, reset;
    input [15:0] in;
    output [15:0] out;
    output [8:0] mem_addr;
    output [1:0] mem_cmd;
    output N, V, Z, led9, led8;
    
    // instruction variables
    reg [15:0] instruction;
    wire [15:0] sximm5, sximm8;
    wire [2:0] writenum, readnum, status_flags, opcode, Rn,Rd,Rm;
    wire [1:0] vsel, nsel, shift, ALUop, op, pcsel;
    wire loada, loadb, asel, bsel, loadc, loads;
    
    // NEW: Lab 7 pc variables
    wire load_ir, load_pc, addr_sel, load_addr, halt, led8;
    
    assign led8 = halt;
    reg [8:0] PC, next_PC, data_address;
    
    // PC select multiplexer
    always @* begin
        case (pcsel)
            `PC_PLUS1:      next_PC = PC + 1;
            `RESET_PC:      next_PC = 9'b0;
            `BRANCH_LBL:    next_PC = PC + sximm8;
            `DP_OUT:        next_PC = out[8:0];
        endcase
    end
    
    // Instruction/PC/Data Address Registers
    always @(posedge clk) begin
        instruction <= load_ir ? in : instruction;
        PC <= load_pc ? next_PC : PC;
        data_address <= load_addr ? out[8:0] : data_address;
    end

    // Address select multiplexer
    assign mem_addr = addr_sel ? PC : data_address;
    
    // instantiate the datapath
    datapath DP (
        .datapath_in    (sximm8), 
        .mdata          (in),
        .writenum       (writenum), 
        .write          (write), 
        .readnum        (readnum),
        .clk            (clk),
        .ALUop          (ALUop), 
        .vsel           (vsel), 
        .asel           (asel), 
        .bsel           (bsel), 
        .loada          (loada), 
        .loadb          (loadb), 
        .loadc          (loadc), 
        .loads          (loads),
        .shift          (shift),
        .datapath_out   (out), 
        .status_flags   ({Z, N, V}),
        .PC             (PC[7:0])
    );
    
    // instantiate the instruction decoder
    instructionDecoder instrucDec (
        .instruction    (instruction),
        .sximm5         (sximm5),
        .sximm8         (sximm8),
        .nsel           (nsel),
        .opcode         (opcode),
        .op             (op),
        .shift          (shift),
        .readnum        (readnum),
        .writenum       (writenum)
    );
    
    // instantiate the control finite state machine
    controlFSM FSM (
        .clk        (clk),
        .reset      (reset),
        .opcode     (opcode),
        .op         (op),
        .vsel       (vsel),
        .write      (write),
        .nsel       (nsel),
        .loada      (loada),
        .loadb      (loadb),
        .asel       (asel),
        .bsel       (bsel),
        .ALUop      (ALUop),
        .loadc      (loadc),
        .loads      (loads),
        .load_ir    (load_ir),
        .load_pc    (load_pc),
        .addr_sel   (addr_sel),
        .mem_cmd    (mem_cmd),
        .load_addr  (load_addr),
        .led9       (led9),
        .led8       (halt),
        .cond       (readnum),
        .Z          (Z),
        .N          (N),
        .V          (V),
        .pcsel      (pcsel)
    );    
endmodule

