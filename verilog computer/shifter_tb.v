`define NO_SHIFT    2'b00
`define LS          2'b01   // left-shift
`define RS_MSB_0    2'b10   // right-shift; msb = 0
`define RS_MSB_CP   2'b11   // right-shift; msb is a copy of in[15]

module shifter_tb;
    reg [15:0] sim_in;
    reg [1:0] sim_shift;
    wire [15:0] sim_out;
    reg err;
    
    shifter DUT(.in(sim_in), 
                .shift(sim_shift),
                .sout(sim_out) );
    
    task check;
        input [15:0] exp;
        begin
            if (exp !== sim_out) begin
                $display("ERROR: exp = %b, sim_out = %b",
                exp, sim_out);
                err = 1'b1;
            end
        end
    endtask
    
    initial begin
        err = 1'b0;
        
        // no shift
        #5 sim_shift = `NO_SHIFT;
        sim_in = 16'b1000_0100_0010_0001;
        #5 check(16'b1000_0100_0010_0001);
        
        // left shift
        #5 sim_shift = `LS;
        #5 check(16'b0000_1000_0100_0010);
        
        // right shift; msb = 0
        #5 sim_shift = `RS_MSB_0;
        #5 check(16'b0100_0010_0001_0000);
        
        // right shift; msb = in[15] = 1
        #5 sim_shift = `RS_MSB_CP;
        #5 check(16'b1100_0010_0001_0000);
        
        // right shift; msb = in[15] = 0
        #5 sim_shift = `RS_MSB_CP;
        sim_in = 16'b0100_0010_0001_0000;
        #5 check(16'b0010_0001_0000_1000);
        
    
        #5 $display("");
        if (err)
            $display("FAILED SHIFTER TESTS");
        else
            $display("PASSED SHIFTER TESTS");
        $display("");
        // $stop;
    end
endmodule