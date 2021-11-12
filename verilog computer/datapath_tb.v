`define ADD         2'b00
`define SUB         2'b01
`define AND         2'b10
`define NOT         2'b11
`define ALL_ZERO    16'b0000_0000_0000_0000
`define NO_SHIFT    2'b00
`define LS          2'b01
`define RS_MSB_0    2'b10
`define RS_MSB_CP   2'b11

module datapath_tb;
    reg [15:0] sim_datapath_in;
    reg [2:0] sim_writenum, sim_readnum;
    reg [1:0] sim_ALUop, sim_shift;
    reg sim_write, sim_clk, sim_vsel, sim_asel, sim_bsel,
        sim_loada, sim_loadb, sim_loadc, sim_loads;
    wire [15:0] sim_datapath_out;
    wire sim_Z_out;
    reg err;
    
    datapath DUT(.datapath_in(sim_datapath_in), 
                 .writenum(sim_writenum), 
                 .write(sim_write), 
                 .readnum(sim_readnum), 
                 .clk(sim_clk),
                 .ALUop(sim_ALUop), 
                 .vsel(sim_vsel),
                 .asel(sim_asel),
                 .bsel(sim_bsel),
                 .loada(sim_loada),
                 .loadb(sim_loadb),
                 .loadc(sim_loadc),
                 .loads(sim_loads),
                 .shift(sim_shift),
                 .datapath_out(sim_datapath_out),
                 .Z_out(sim_Z_out));    
    
    
    
    task check;
        input [15:0] exp_datapath_out;
        input exp_Z_out;
        begin
            if (exp_datapath_out !== sim_datapath_out) begin
                $display("ERROR: exp_datapath_out = %b, sim_datapath_out = %b",
                    exp_datapath_out, sim_datapath_out);
                err = 1;
            end
            
            if (exp_Z_out !== sim_Z_out) begin
                $display("ERROR: exp_Z_out = %b, sim_Z_out = %b", exp_Z_out, sim_Z_out);
                err = 1;
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
        $display();
        #5 err = 0;                 // t = 5
        
        // MOV R2, #32     
        sim_datapath_in = 32;
        sim_writenum = 2;
        sim_write = 1;                  // cycle 1: write 32 to R2
        sim_readnum = 2;
        sim_ALUop = `AND;
        sim_vsel = 1;
        sim_asel = 0;
        sim_bsel = 0;
        sim_loada = 1;                  // cycle 2: load R2 to a and b
        sim_loadb = 1;
        sim_loadc = 1;                  // cycle 3: load R2 to c
        sim_loads = 1;
        sim_shift = `NO_SHIFT;        
        #30 check(32, 0);               // t = 35: check that R2 = 32
        
        // MOV R3, #42
        sim_datapath_in = 42;
        sim_writenum = 3;
        sim_write = 1;                  // cycle 1: write 42 to R3
        sim_readnum = 3;
        sim_ALUop = `AND;
        sim_vsel = 1;
        sim_asel = 0;
        sim_bsel = 0;
        sim_loada = 1;                  // cycle 2: load R3 to a and b
        sim_loadb = 1;
        sim_loadc = 1;                  // cycle 3: load R3 to c
        sim_loads = 1;
        sim_shift = `NO_SHIFT;
        #30 check(42, 0);               // t = 65: check that R3 = 42
        
        // ADD R5, R2, R3      
        sim_writenum = 5;
        sim_write = 0;
        sim_readnum = 2;
        sim_loada = 1;                  // cycle 1: load R2 to a
        sim_loadb = 0;
        #10 sim_readnum = 3;
        sim_ALUop = `ADD;
        sim_vsel = 0;
        sim_loada = 0;
        sim_loadb = 1;                  // cycle 2: load R3 to b
        sim_loadc = 1;                  // cycle 3: load R3 to c
        #20 sim_write = 1;              // cycle 4: write c to R5
        #10 check(74, 0);               // t = 105: check that R2 + R3 = 74
        sim_readnum = 5;                
        sim_loada = 1;                  // cycle 5: load R5 to a and b
        sim_loadb = 1;
        sim_loadc = 1;                  // cycle 6: load R5 to c
        sim_ALUop = `AND;
        #30 check(74, 0);               // t = 135: check that R5 = 74
        
        // MOV R0, #7
        sim_datapath_in = 7;
        sim_writenum = 0;
        sim_write = 1;                  // cycle 1: write 7 to R0
        sim_readnum = 0;
        sim_ALUop = `AND;
        sim_vsel = 1;
        sim_asel = 0;
        sim_bsel = 0;
        sim_loada = 1;                  // cycle 2: load R0 to a and b
        sim_loadb = 1;
        sim_loadc = 1;                  // cycle 3: load R0 to c
        sim_loads = 1;
        sim_shift = `NO_SHIFT;
        #30 check(7, 0);                // t = 165: check that R0 = 7
        
        // MOV R1, #2
        sim_datapath_in = 2;
        sim_writenum = 1;
        sim_write = 1;                  // cycle 1: write 2 to R1
        sim_readnum = 1;
        sim_ALUop = `AND;
        sim_vsel = 1;
        sim_asel = 0;
        sim_bsel = 0;
        sim_loada = 1;                  // cycle 2: load R3 to a and b
        sim_loadb = 1;
        sim_loadc = 1;                  // cycle 3: load R3 to c
        sim_loads = 1;
        sim_shift = `NO_SHIFT;
        #30 check(2, 0);                // t = 195: check that R2 = 7
        
        // ADD R2, R1, R0, LSL #1
        sim_writenum = 2;
        sim_write = 0;
        sim_readnum = 1;
        sim_loada = 1;                  // cycle 1: load R1 to a
        sim_loadb = 0;
        #10 sim_readnum = 0;
        sim_ALUop = `ADD;
        sim_shift = `LS;
        sim_vsel = 0;
        sim_loada = 0;
        sim_loadb = 1;                  // cycle 2: load R0 to b
        sim_loadc = 1;                  // cycle 3: load R1 + R0<<1 to c
        #20 sim_write = 1;              // cycle 4: write c to R2
        #10 check(16, 0);               // t = 235: check that R1 + R0<<1 = 16
        sim_write = 0;
        sim_readnum = 2;                
        sim_loada = 1;                  // cycle 5: load R2 to a and b
        sim_loadb = 1;
        sim_loadc = 1;
        sim_ALUop = `AND;               // cycle 6: load R2 to c
        sim_shift = `NO_SHIFT;
        #30 check(16, 0);               // t = 265: check that R2 = 16
        
        // read from R2
        sim_write = 0;
        sim_readnum = 2;
        sim_ALUop = `ADD;
        sim_vsel = 1;
        sim_asel = 1;
        sim_bsel = 0;                   // cycle 1: write 32 to R2
        sim_loada = 1;                  // cycle 2: load R2 b
        sim_loadb = 1;
        sim_loadc = 1;                  // cycle 3: load 0 + R2 to c
        sim_loads = 1;
        sim_shift = `NO_SHIFT;        
        #30 check(16, 0);               // t = 295: check that R2 = 16
                           
        
        
        // SUB R4, R5, R2, RS_MSB_0 (74 - 16>>1 = 66)
        sim_writenum = 4;
        sim_write = 0;
        sim_readnum = 5;
        sim_vsel = 0;
        sim_asel = 0;
        sim_bsel = 0; 
        sim_loada = 1;                  // cycle 1: load R5 to a
        sim_loadb = 0;
        #10 sim_readnum = 2;
        sim_ALUop = `SUB;
        sim_shift = `RS_MSB_0;
        sim_loada = 0;
        sim_loadb = 1;                  // cycle 2: load R2 to b
        sim_loadc = 1;                  // cycle 3: load R5 - R2>>1 to c
        #20 sim_write = 1;              // cycle 4: write c to R4
        #10 check(66, 0);               // t = 335: check that R5 - R2>>1 = 66
        sim_write = 0;
        sim_readnum = 4;                
        sim_loada = 1;                  // cycle 5: load R4 to a and b
        sim_loadb = 1;
        sim_loadc = 1;
        sim_ALUop = `AND;               // cycle 6: load R4 to c
        sim_shift = `NO_SHIFT;
        #30 check(66, 0);               // t = 365: check that R4 = 66
        
        // MOV R6, ~7 (16'b1111_1111_1111_1000)
        sim_datapath_in = 7;
        sim_writenum = 6;
        sim_write = 0;
        sim_readnum = 6;
        sim_ALUop = `NOT;
        sim_shift = `NO_SHIFT;
        sim_vsel = 0;
        sim_asel = 1;
        sim_bsel = 1;
        sim_loada = 1; 
        sim_loadb = 1;
        sim_loadc = 1;                  // cycle 1: load ~datapath_in to c
        sim_loads = 1;
        #10 check(16'b1111_1111_1111_1000, 0);      // t = 375: check that c = ~7
        
        // check 0 + 0 = 0
        sim_datapath_in = 0;
        sim_asel = 1;
        sim_bsel = 1;
        sim_ALUop = `ADD;   // immediatly update ALU to 0 + 0
        #10 check(0, 1);    // t = 385: check that status = 1
        
        
        
        #5 $display();
        if (err)
            $display("FAILED DATAPATH TESTS");
        else
            $display("PASSED DATAPATH TESTS");
        $display();
        // $stop();
    end
endmodule