`include "constants.v"

// Module controls the datapath
// requires:
//      s, reset from client
//      opcode, op from Instruction Decoder
// effects:
//      nsel for Instruction Decoder
//      vsel, write, loada, loadb, asel, bsel, ALUop,
//          loadc, loads for datapath
//      w for user
module controlFSM (
        clk, 
        reset, 
        opcode, 
        op, 
        ALUop, 
        loada, 
        loadb,
        loadc, 
        loads, 
        vsel, 
        nsel,
        pcsel,
        asel, 
        bsel, 
        write, 
        load_ir, 
        load_pc, 
        addr_sel, 
        mem_cmd, 
        load_addr, 
        led9, 
        led8,
        cond,
        Z, V, N
    );
                
    input clk, reset, Z, V, N;
    input [2:0] opcode, cond;
    input [1:0] op;
    output reg [1:0] vsel, nsel, ALUop, mem_cmd;
    output reg loada, loadb, loadc, loads, asel, bsel, write,
               load_ir, load_pc, addr_sel, load_addr;
    output reg [1:0] pcsel;
    output wire led9, led8;
    
    reg [5:0] fsm_state;                    // lab 7 board demo code
    assign led9 = 0;                        // (fsm_state === `DECODE | fsm_state === `HALT_ST);
    assign led8 = (fsm_state === `HALT_ST); // | fsm_state === `LDR4);
    
    // next state logic
    always @(posedge clk) begin
        if (reset)
            fsm_state <= `RST;
        else begin
            case(fsm_state)
                `RST: fsm_state <= `IF1;
                `IF1: fsm_state <= `IF2;
                `IF2: fsm_state <= `UPDATE_PC;
                `UPDATE_PC: fsm_state <= `DECODE;         
                `DECODE: begin
                    case({opcode, op})
                        {`DT, `MOV_IMM}: fsm_state <= `WRITE_IMM;
                        {`DT, `MOV_REG}: fsm_state <= `WR0;
                        {`DP, `ADD}: fsm_state <= `ADD0;
                        {`DP, `CMP}: fsm_state <= `CMP0;
                        {`DP, `AND}: fsm_state <= `AND0;
                        {`DP, `MVN}: fsm_state <= `MVN0;
                        `LDR: fsm_state <= `LDR0;
                        `STR: fsm_state <= `STR0;
                        `HALT: fsm_state <= `HALT_ST;
                        `B: fsm_state <= `B1;
                        `BL: fsm_state <= `BL1;
                        `BX: fsm_state <= `BX1;
                        `BLX: fsm_state <= `BLX1;
                        default: fsm_state <= {6{1'bx}};
                    endcase
                end
                `WRITE_IMM: fsm_state <= `IF1;
                `WR0: fsm_state <= `WR1;
                `WR1: fsm_state <= `WR2;
                `WR2: fsm_state <= `IF1;
                `ADD0: fsm_state <= `ADD1;
                `ADD1: fsm_state <= `ADD2;
                `ADD2: fsm_state <= `ADD3;
                `ADD3: fsm_state <= `IF1;
                `CMP0: fsm_state <= `CMP1;
                `CMP1: fsm_state <= `CMP2;
                `CMP2: fsm_state <= `IF1;
                `AND0: fsm_state <= `AND1;
                `AND1: fsm_state <= `AND2;
                `AND2: fsm_state <= `AND3;
                `AND3: fsm_state <= `IF1;
                `MVN0: fsm_state <= `MVN1;
                `MVN1: fsm_state <= `MVN2;
                `MVN2: fsm_state <= `IF1;
                `LDR0: fsm_state <= `LDR1;
                `LDR1: fsm_state <= `LDR2;
                `LDR2: fsm_state <= `LDR3;
                `LDR3: fsm_state <= `LDR4;
                `LDR4: fsm_state <= `IF1;
                `STR0: fsm_state <= `STR1;
                `STR1: fsm_state <= `STR2;
                `STR2: fsm_state <= `STR3;
                `STR3: fsm_state <= `STR4;
                `STR4: fsm_state <= `STR5;
                `STR5: fsm_state <= `IF1;
                `HALT_ST: fsm_state <= `HALT_ST;
                `B1: fsm_state <= `B2;
                `B2:
                    case (cond)
                        3'b000: fsm_state <= `GOTO;
                        3'b001: fsm_state <=  Z           ? `GOTO : `IF1;
                        3'b010: fsm_state <= ~Z           ? `GOTO : `IF1;
                        3'b011: fsm_state <=     (N != V) ? `GOTO : `IF1;
                        3'b100: fsm_state <= (Z | N != V) ? `GOTO : `IF1;
                        default: fsm_state <= {6{1'bx}};
                    endcase
                `GOTO: fsm_state <= `IF1;
                `BL1: fsm_state <= `GOTO;
                `BX1: fsm_state <= `BX2;
                `BX2: fsm_state <= `BX3;
                `BX3: fsm_state <= `IF1;
                `BLX1: fsm_state <= `BX1;
            endcase
        end
    end
    
    // output signals logic: set nsel, ctrl_signals
    always @(fsm_state) begin
        case(fsm_state)
            `RST: begin                 // reset program counter
                pcsel = `RESET_PC;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 1;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `IF1: begin                 // fetch the next instruction
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MREAD;
                addr_sel = 1;
                load_addr = 0;
            end
            `IF2: begin 
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 1;
                load_pc = 0;
                mem_cmd = `MREAD;
                addr_sel = 1;
                load_addr = 0;
            end
            `UPDATE_PC: begin 
                pcsel = `PC_PLUS1;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 1;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `DECODE: begin
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
        
            // MOV Rd, #<imm8> (3 clk cycles)
            `WRITE_IMM: begin       // load sximm8 into Rn
                pcsel = 2'bxx;
                nsel = `Rn;
                vsel = `SXIMM8;
                write = 1;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            // MOV Rd, Rm (5 clk cycles)
            `WR0: begin       // load Rm into B
                pcsel = 2'bxx;
                nsel = `Rm;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `WR1: begin             // load B + 0 into C
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1;
                bsel = 0;
                ALUop = `ADD;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `WR2: begin             // load C into Rd
                pcsel = 2'bxx;
                nsel = `Rd;
                vsel = `C;
                write = 1;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            // ADD Rd, Rn, Rm (6 clk cycles)
            `ADD0: begin       // load Rn into A
                pcsel = 2'bxx;
                nsel = `Rn;
                vsel = 2'bxx;
                write = 0;
                loada = 1;
                loadb = 0;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `ADD1: begin       // load Rm into B
                pcsel = 2'bxx;
                nsel = `Rm;
                vsel = 2'bxx;
                write = 0;
                loada = 0;
                loadb = 1;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `ADD2: begin       // load A + B into C
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 0;
                bsel = 0;
                ALUop = `ADD;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `ADD3: begin       // load C into Rd
                pcsel = 2'bxx;
                nsel = `Rd;
                vsel = `C;
                write = 1;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            // CMP Rn, Rm (5 clk cycles)
            `CMP0: begin       // load Rn into A
                pcsel = 2'bxx;
                nsel = `Rn;
                vsel = 2'bxx;
                write = 0;
                loada = 1'b1;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `CMP1: begin       // load Rm into B
                pcsel = 2'bxx;
                nsel = `Rm;
                vsel = `C;
                write = 0;
                loada = 1'b0;
                loadb = 1'b1;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `CMP2: begin    // ALUout = a - b; update the status bits
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'b0;
                bsel = 1'b0;
                ALUop = `SUB;
                loadc = 0;
                loads = 1;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            // AND Rd, Rn, Rm (6 clk cycles)
            `AND0: begin       // load Rn into A
                pcsel = 2'bxx;
                nsel = `Rn;
                vsel = 2'bxx;
                write = 0;
                loada = 1;
                loadb = 0;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `AND1: begin       // load Rm into B
                pcsel = 2'bxx;
                nsel = `Rm;
                vsel = 2'bxx;
                write = 0;
                loada = 0;
                loadb = 1;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 0;
                load_addr = 0;
            end
            `AND2: begin       // load A & B into C
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 0;
                bsel = 0;
                ALUop = `AND;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `AND3: begin       // load C into Rd
                pcsel = 2'bxx;
                nsel = `Rd;
                vsel = `C;
                write = 1;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            // MVN Rd, Rm (5 clk cycles)
            `MVN0: begin       // load Rm into B
                pcsel = 2'bxx;
                nsel = `Rm;
                vsel = 2'bxx;
                write = 0;
                loada = 0;
                loadb = 1;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `MVN1: begin             // load ~B into C
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1;
                bsel = 0;
                ALUop = `NOT;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `MVN2: begin             // load C into Rd
                pcsel = 2'bxx;
                nsel = `Rd;
                vsel = `C;
                write = 1;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `LDR0: begin            // load Rn into A
                pcsel = 2'bxx;
                nsel = `Rn;
                vsel = 2'bxx;
                write = 0;
                loada = 1;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `LDR1: begin            // load A + sximm5 into C
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 0;
                bsel = 1;
                ALUop = `ADD;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `LDR2: begin            // load C into Data Address
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 1;
            end
            `LDR3: begin            // mem_addr = data_address
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MREAD;
                addr_sel = 0;
                load_addr = 0;
            end
            `LDR4: begin            // save metadata to Rd
                pcsel = 2'bxx;
                nsel = `Rd;
                vsel = `MDATA;
                write = 1;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MREAD;
                addr_sel = 0;
                load_addr = 0;
            end
            
            `STR0: begin            // load Rn into A
                pcsel = 2'bxx;
                nsel = `Rn;
                vsel = 2'bxx;
                write = 0;
                loada = 1;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end            
            `STR1: begin            // load A + sximm5 into C
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 0;
                bsel = 1;
                ALUop = `ADD;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            `STR2: begin            // load C into Data Address
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 1;
            end
            `STR3: begin            // load Rd into B
                pcsel = 2'bxx;
                nsel = `Rd;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 1;
            end
            
// TODO (FIX BUG): currently may be getting shifted. The datapath must output Rd without shifted.

            `STR4: begin            // load 0 + B into C
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1;
                bsel = 0;
                ALUop = `ADD;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 1;
            end
            `STR5: begin            // write C to mem_addr
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MWRITE;
                addr_sel = 0;
                load_addr = 1;
            end
            
            `HALT_ST: begin         // do nothing
                pcsel = 2'bxx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `B1: begin          // The FSM condition is linked to instrucDec's readnum output
                pcsel = 2'bxx;
                nsel = `Rn;     // By setting nsel to Rn, readnum ouputs instruction[10:8]
                vsel = 2'bxx;   // These bits are where the branch condition are located
                write = 0;      // This state should not do anything else.
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `B2: begin          // This step evaluates cond to determine
                pcsel = 2'bxx;  // whether to take the branch or not
                nsel = `Rn;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `GOTO: begin         // Sets the next PC to sximm8
                pcsel = `BRANCH_LBL;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 1;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `BL1: begin         // R7 = PC + 1
                pcsel = 2'bxx;
                nsel = `Rn;     // Rn should be 7
                vsel = `PC;
                write = 1;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `BX1: begin         // Load Rd into B
                pcsel = 2'bxx;
                nsel = `Rd;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `BX2: begin         // Move Rd from B to C
                pcsel = 2'bxx;
                nsel = `Rd;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1;
                asel = 1;
                bsel = 0;
                ALUop = `ADD;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `BX3: begin         // Move Rd from C to PC
                pcsel = `DP_OUT;
                nsel = `Rd;
                vsel = 2'bxx;
                write = 0;
                loada = 1'bx;
                loadb = 1;
                asel = 1;
                bsel = 0;
                ALUop = `ADD;
                loadc = 1;
                loads = 0;
                load_ir = 0;
                load_pc = 1;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            `BLX1: begin         // R7 = PC + 1
                pcsel = 1;
                nsel = `Rn;      // Rn should be 7
                vsel = `PC;
                write = 1;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 0;
                loads = 0;
                load_ir = 0;
                load_pc = 0;
                mem_cmd = `MNONE;
                addr_sel = 1'bx;
                load_addr = 0;
            end
            
            default: begin
                pcsel = 1'bx;
                nsel = 2'bxx;
                vsel = 2'bxx;
                write = 1'bx;
                loada = 1'bx;
                loadb = 1'bx;
                asel = 1'bx;
                bsel = 1'bx;
                ALUop = 2'bxx;
                loadc = 1'bx;
                loads = 1'bx;
                load_ir = 1'bx;
                load_pc = 1'bx;
                mem_cmd = 2'bxx;
                addr_sel = 1'bx;
                load_addr = 1'bx;
            end
        endcase
    end
endmodule