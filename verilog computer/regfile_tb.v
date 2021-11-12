module regfile_tb;
    reg [15:0] sim_data_in;
    wire [15:0] sim_data_out;
    reg sim_write, sim_clk, err;
    reg [2:0] sim_writenum, sim_readnum;
    
    regfile DUT(.data_in(sim_data_in), // original instance name: dut
                .writenum(sim_writenum),
                .write(sim_write),
                .readnum(sim_readnum),
                .clk(sim_clk),
                .data_out(sim_data_out) );
    
    task check_regfile;
        input reg [15:0] expected_data_out;
        begin
            if (expected_data_out !== sim_data_out) begin
                err = 1'b1;
                $display("ERROR: expected_data_out = %b; sim_data_out = %b",
                        expected_data_out, sim_data_out);
            end
        end
    endtask
    
    // sim_clk has posedges at t = 10, 20, 30, 40...
    initial begin
        #5 sim_clk = 1'b0;
        forever begin
            #5 sim_clk = 1'b1;
            #5 sim_clk = 1'b0;
        end
    end
    
    initial begin
        err = 1'b0;
        
        /* NOTE: sim_readnum is updated before sim_writenum is
        registered, so the waveviewer may show all x's after
        sim_readnum is updated and before clk's next posedge */
        
        // MOV R0, #0
        sim_data_in = 16'b0000_0000_0000_0000;
        sim_write = 1'b1;
        sim_writenum = 3'b000;
        sim_readnum = 3'b000;
        #15 check_regfile(16'b0000_0000_0000_0000);     // t = 15
        
        // MOV R1, #7
        sim_data_in = 16'b0000_0000_0000_0111;
        sim_writenum = 3'b001;
        sim_readnum = 3'b001;
        #10 check_regfile(16'b0000_0000_0000_0111);     // t = 25
        
        // MOV R2, 0xF000
        sim_data_in = 16'b1111_0000_0000_0000;
        sim_writenum = 3'b010;
        sim_readnum = 3'b010;
        #10 check_regfile(16'b1111_0000_0000_0000);     // t = 35
        
        // check that R1 is still 7
        sim_writenum = 3'b001;
        sim_readnum = 3'b001;
        sim_write = 1'b0;
        #10 check_regfile(16'b0000_0000_0000_0111);     // t = 45
        
        
        // check that R0 doesn't change when write == 0
        sim_data_in = 16'b0000_0000_0000_0111;
        sim_writenum = 3'b000;
        sim_readnum = 3'b000;
        #10 check_regfile(16'b0000_0000_0000_0000);     // t = 55
        
        
        // MOV R7, 0x7777
        sim_data_in = 16'b0111_0111_0111_0111;
        sim_writenum = 3'b111;
        sim_readnum = 3'b111;
        sim_write = 1'b1;
        #10 check_regfile(16'b0111_0111_0111_0111);     // t = 65
        
        // MOV R1, 0x1111
        sim_data_in = 16'b0001_0001_0001_0001;
        sim_writenum = 3'b001;
        sim_readnum = 3'b001;
        #10 check_regfile(16'b0001_0001_0001_0001);     // t = 75
        
        
        
        // ADD TESTS HERE
        
        $display();
        if (err)
            $display("FAILED REGFILE TESTS");
        else
            $display("PASSED REGFILE TESTS");
        $display();
        // $stop;
    end
endmodule