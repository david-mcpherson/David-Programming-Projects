`define ADD         2'b00
`define SUB         2'b01
`define AND         2'b10
`define NOT         2'b11
`define ALL_ZERO    16'b0000_0000_0000_0000
`define NO_SHIFT    2'b00
`define LS          2'b01
`define RS_MSB_0    2'b10
`define RS_MSB_CP   2'b11

// the 10 datapath parts are labeled with comments
module datapath(datapath_in, writenum, write, readnum, clk,
        ALUop, vsel, asel, bsel, loada, loadb, loadc, loads,
        shift, datapath_out, Z_out);
        
    input [15:0] datapath_in;
    input [2:0] writenum, readnum;
    input write, clk, vsel, asel, bsel, loada, loadb,
          loadc, loads;
    input [1:0] ALUop, shift;
    output [15:0] datapath_out;
    output Z_out;
    
    reg [15:0] regA_out, regB_out, datapath_out;
    reg Z_out;
    wire [15:0] regfile_out, data_in, regAB_in, shifter_out, Ain, Bin, alu_out;
    wire status_in;
    
    // part 9
    assign data_in = (vsel) ? datapath_in : datapath_out;
    
    
    // part 1
    regfile REGFILE(.data_in(data_in),
                    .writenum(writenum),
                    .write(write),
                    .readnum(readnum),
                    .clk(clk),
                    .data_out(regfile_out));
    
    // parts 3, 4, 10 and 5
    always @(posedge clk) begin
        regA_out <= (loada) ? regfile_out : regA_out;
        regB_out <= (loadb) ? regfile_out : regB_out;
        Z_out <= (loads) ? status_in : Z_out;
        datapath_out <= (loadc) ? alu_out : datapath_out;
    end
    
    // part 8
    shifter U1(.in(regB_out),
               .shift(shift), 
               .sout(shifter_out));
    
    // parts 6 and 7
    assign Ain = (asel) ? 16'b0 : regA_out;
    assign Bin = (bsel) ? {11'b0, datapath_in[4:0]} : shifter_out;
    
    // part 2
    ALU U2(.Ain(Ain), 
           .Bin(Bin),
           .ALUop(ALUop),
           .out(alu_out),
           .Z(status_in));
           

endmodule




