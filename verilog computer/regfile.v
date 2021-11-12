module regfile(data_in, 
                writenum, 
                write,
                readnum,
                clk,
                data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output reg [15:0] data_out;
    
    reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    
    always @(posedge clk)
        case (writenum)
            3'b000: R0 = (write) ? data_in : R0;
            3'b001: R1 = (write) ? data_in : R1;
            3'b010: R2 = (write) ? data_in : R2;
            3'b011: R3 = (write) ? data_in : R3;
            3'b100: R4 = (write) ? data_in : R4;
            3'b101: R5 = (write) ? data_in : R5;
            3'b110: R6 = (write) ? data_in : R6;
            3'b111: R7 = (write) ? data_in : R7;
        endcase
        
    
    always @(*)
        case(readnum)
            3'b000: data_out = R0;
            3'b001: data_out = R1; 
            3'b010: data_out = R2;
            3'b011: data_out = R3;
            3'b100: data_out = R4;
            3'b101: data_out = R5;
            3'b110: data_out = R6;
            3'b111: data_out = R7;
        endcase
endmodule