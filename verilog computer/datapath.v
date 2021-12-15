`include "constants.v"


module datapath (
        datapath_in, 
        mdata, 
        writenum, 
        write, 
        readnum,
        clk,
        ALUop, 
        vsel, 
        asel, 
        bsel,
        loada, 
        loadb, 
        loadc, 
        loads,
        shift, 
        datapath_out, 
        status_flags,
        PC
    );
    
    // datapath_in = sximm8 from the cpu
    input [15:0] datapath_in, mdata;
    input [2:0] writenum, readnum;
    input write, clk, asel, bsel, loada, loadb,
          loadc, loads;
          
    // extended vsel to 2 bits
    input [1:0] ALUop, shift, vsel;
    output [15:0] datapath_out;
    
    // status_flags was formerlly called "Z_out"
    // zero flag (Z), overflow flag (V), negative flag (N)
    // status_flags = {Z, N, V};
    output reg [2:0] status_flags;
    
    // datapath_out = C
    reg [15:0] regA_out, regB_out, data_in, datapath_out;
    wire [15:0] regfile_out, regAB_in, shifter_out, Ain, Bin, alu_out;
    
    // extended status to 3 bits: {Z, V, N}
    wire [2:0] status_in;
    
    wire [15:0] sximm5;
    input wire [7:0] PC;
    
    assign sximm5 = {{11{datapath_in[4]}}, datapath_in[4:0]};
    
    // Original lab 5 data_in multiplexer:
    // assign data_in = (vsel) ? datapath_in : datapath_out;  

    // Modified vsel multiplexer (lab 6 part 4.1)
    always @(*)
        case(vsel)
            `C: data_in = datapath_out;
            `PC: data_in = {8'b0, PC};
            `SXIMM8: data_in = datapath_in;
            `MDATA: data_in = mdata;
        endcase
    
    // instantiate the regfile
    regfile REGFILE(
        .data_in    (data_in),
        .writenum   (writenum),
        .write      (write),
        .readnum    (readnum),
        .clk        (clk),
        .data_out   (regfile_out)
    );
    
    // intermediate registers A, B, C
    always @(posedge clk) begin
        regA_out <= (loada) ? regfile_out : regA_out;
        regB_out <= (loadb) ? regfile_out : regB_out;
        status_flags <= (loads) ? status_in : status_flags;
        datapath_out <= (loadc) ? alu_out : datapath_out;
    end
    
    // instatiate the shifter
    shifter U1 (
        .in(regB_out),
        .shift(shift), 
        .sout(shifter_out)
    );
    
    // ALU input multiplexers
    assign Ain = (asel) ? 16'b0 : regA_out;
    assign Bin = (bsel) ? sximm5 : shifter_out;
    
    // instatiate the ALU
    ALU U2 (
        .Ain(Ain), 
        .Bin(Bin),
        .ALUop(ALUop),
        .out(alu_out),
        .Z(status_in[2]),
        .N(status_in[1]),
        .V(status_in[0])
    );

endmodule




