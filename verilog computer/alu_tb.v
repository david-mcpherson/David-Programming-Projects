`define ADD 2'b00
`define SUB 2'b01
`define AND 2'b10
`define NOT 2'b11
`define ALL_ZERO 16'b0000_0000_0000_0000

module ALU_tb;
    reg [15:0] sim_A, sim_B;
    reg [1:0] sim_op;
    wire [15:0] sim_out;
    wire sim_Z;
    reg err;
    
    ALU DUT(.Ain(sim_A), 
                .Bin(sim_B),
                .ALUop(sim_op),
                .out(sim_out),
                .Z(sim_Z) );
    
    task check;
        input reg [15:0] expected;
        input reg exp_Z;
        begin
            if (expected !== sim_out) begin
                err = 1'b1;
                $display("ERROR: expected = %b; sim_out = %b",
                        expected, sim_out);
            end
            if (exp_Z !== sim_Z) begin
                err = 1'b1;
                $display("ERROR: exp_Z = %b, sim_Z = %b",
                        exp_Z, sim_Z);
            end
        end
    endtask
    
    initial begin
        err = 1'b0;
        
        // check 1 + 1 = 2
        #5 sim_op = `ADD;
        sim_A = 16'b0000_0000_0000_0001;
        sim_B = 16'b0000_0000_0000_0001;        
        #5 check(16'b0000_0000_0000_0010, 1'b0);      // t = 10
        
        // check 2 - 1 = 1
        #5 sim_op = `SUB;
        sim_A = 16'b0000_0000_0000_0010;
        #5 check(16'b0000_0000_0000_0001, 1'b0);      // t = 20
        
        // check 0101 & 0110 = 0100
        #5 sim_op = `AND;
        sim_A = 16'b0000_0000_0000_0101;
        sim_B = 16'b0000_0000_0000_0110;
        #5 check(16'b0000_0000_0000_0100, 1'b0);     // t = 30
        
        // check ~0110 = 1001
        #5 sim_op = `NOT;
        #5 check(16'b1111_1111_1111_1001, 1'b0);     // t = 40
        
        // check 1001 - 1001 = `ALL_ZERO and sim_Z = 1
        #5 sim_op = `SUB;
        sim_A = sim_B;
        #5 check(`ALL_ZERO, 1'b1);                  // t = 50
        
        // check 1 - 2 = -1
        #5 sim_A = 16'b0000_0000_0000_0001;
        sim_B = 16'b0000_0000_0000_0010;
        #5 check(16'b1111_1111_1111_1111, 1'b0);    // t = 60
        
        // check -3 + 7 = 4
        #5 sim_op = `ADD;
        sim_A = 16'b1111_1111_1111_1101;
        sim_B = 16'b0000_0000_0000_0111;
        #5 check(16'b0000_0000_0000_0100, 1'b0);    // t = 70
        
        
        #5 $display();
        if (err)
            $display("FAILED ALU TESTS");
        else
            $display("PASSED ALU TESTS");
        $display();
        // $stop;
    end
endmodule