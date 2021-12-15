`include "../constants.v"

// This module tests the figure 8 example from the lab 7 handout.
// "data.txt" must contain the compiled "fig8.txt" program.
module lab7_top_tb;
    reg [9:0] sim_SW;
    wire [9:0] sim_LEDR;
    wire [6:0] sim_HEX0, sim_HEX1, sim_HEX2,
               sim_HEX3, sim_HEX4, sim_HEX5;
    reg err, sim_rst, sim_clk;
    
    lab7_top dut (
        .KEY ({2'b11, ~sim_rst, ~sim_clk}),
        .SW  (sim_SW),
        .LEDR(sim_LEDR),
        .HEX5(sim_HEX5),
        .HEX4(sim_HEX4),
        .HEX3(sim_HEX3),
        .HEX2(sim_HEX2),
        .HEX1(sim_HEX1),
        .HEX0(sim_HEX0)
    );
    
    task check_display;
        input [27:0] exp;
        begin
            if (exp !== {sim_HEX3, sim_HEX2, sim_HEX1, sim_HEX0}) begin
                $display("ERROR: exp_hex = %b, sim_hex = %b",
                        exp, {sim_HEX3, sim_HEX2, sim_HEX1, sim_HEX0} );  
                err = 1;
            end
        end
    endtask
    
    task check_flags;
        input [2:0] exp_flags;
        begin
           if (exp_flags !== {~sim_HEX5[0], ~sim_HEX5[6],
                              ~sim_HEX5[3]}) begin
                $display("ERROR: exp_flags = %b; sim_flags = %b",
                        {exp_flags[2], exp_flags[1], exp_flags[0]},
                        {~sim_HEX5[0],~sim_HEX5[6],~sim_HEX5[3]});
                err = 1;
            end
        end
    endtask
    
    // Wait for the PC to change. Then check if it's correct.
    task check_PC;
        input [8:0] exp;
        begin
            @(posedge dut.CPU.PC or negedge dut.CPU.PC);        
            if (dut.CPU.PC !== exp) begin
                $display("ERROR: exp_PC = %b; sim_PC = %b",
                         exp, dut.CPU.PC);
                err = 1;
            end
        end
    endtask
    
    // Check that REGFILE.Rn is correct.
    task check_regfile;
        input [3:0] Rn;
        input [15:0] exp;
        begin
            case (Rn)
                3'd0:
                    if (exp !== dut.CPU.DP.REGFILE.R0) begin
                        $display("ERROR: exp_R%d = %b; R0 = %b",
                                 Rn, exp, dut.CPU.DP.REGFILE.R0);
                        err = 1;
                    end
                3'd1:
                    if (exp !== dut.CPU.DP.REGFILE.R1) begin
                        $display("ERROR: exp_R%d = %b; R1 = %b",
                                 Rn, exp, dut.CPU.DP.REGFILE.R1);
                        err = 1;
                    end
                3'd2:
                    if (exp !== dut.CPU.DP.REGFILE.R2) begin
                        $display("ERROR: exp_R%d = %b; R2 = %b",
                                 Rn, exp, dut.CPU.DP.REGFILE.R2);
                        err = 1;
                    end
                3'd3:
                    if (exp !== dut.CPU.DP.REGFILE.R3) begin
                        $display("ERROR: exp_R%d = %b; R3 = %b",
                                 Rn, exp, dut.CPU.DP.REGFILE.R3);
                        err = 1;
                    end
                3'd4:
                    if (exp !== dut.CPU.DP.REGFILE.R4) begin
                        $display("ERROR: exp_R%d = %b; R4 = %b",
                                 Rn, exp, dut.CPU.DP.REGFILE.R4);
                        err = 1;
                    end
                3'd5:
                    if (exp !== dut.CPU.DP.REGFILE.R5) begin
                        $display("ERROR: exp_R%d = %b; R5 = %b",
                                 Rn, exp, dut.CPU.DP.REGFILE.R5);
                        err = 1;
                    end
                3'd6:
                    if (exp !== dut.CPU.DP.REGFILE.R6) begin
                        $display("ERROR: exp_R%d = %b; R6 = %b",
                                 Rn, exp, dut.CPU.DP.REGFILE.R6);
                        err = 1;
                    end
                3'd7:
                    if (exp !== dut.CPU.DP.REGFILE.R7) begin
                        $display("ERROR: exp_R%d = %b; R7 = %b",
                                 Rn, exp, dut.CPU.DP.REGFILE.R7);
                        err = 1;
                    end
            endcase
        end
    endtask
    
    task check_LEDR;
        input [9:0] exp;
        begin
            if (exp !== sim_LEDR) begin
                $display("ERROR: exp_LEDR = %b; sim_LEDR = %b",exp,sim_LEDR);
                err = 1;
            end
        end
    endtask
    
    
    // clk has rising edges at t = 10, 20, 30...
    initial forever begin
        #5 sim_clk = 0;
        #5 sim_clk = 1;
    end
    
    initial begin
        err = 0;
        sim_rst = 1;
        #15 sim_rst = 0;        // t = 15
        check_PC(0);            // t = 20
        check_PC(1);
        
/*   <--- ADD/REMOVE SLASH AT START OF LINE TO TOGGLE STAGES_1
    // STAGE_1 TEST (test1.txt)
        // @00 mov r1, #1              // r1 = 1
        check_PC(2);
        check_regfile(1, 1);
        
        // @01 and r1, r1, r1          // output = 0x0001
        check_PC(3);
        check_display({`x0, `x0, `x0, `x1});
        
        // @02 mvn r2, r1, lsr#1       // output = 0xffff
        check_PC(4);
        check_regfile(2, 16'hffff);
        check_display({`xF, `xF, `xF, `xF});
        
        // @03 cmp r2, r2              // {Z, N, V} = {1, 0, 0}
        check_PC(5);
        if (sim_HEX5 !== 7'b1111110) begin
            $display("ERROR: flags should be {1, 0, 0}"); err = 1;
        end
        
        // @04 mov r4, r1, lsl#1       // output = 0x0002
        check_PC(6);
        check_regfile(4, 2);
        
        // @05 add r3, r2, r4          // -1 + 2 = 0x0001
        check_PC(7);
        check_regfile(3, 1);
        check_display({`x0, `x0, `x0, `x1});
        
        // @06 halt
        check_display({`x0, `x0, `x0, `x1});
        #100 if (dut.CPU.PC !== 7) begin
            $display("ERROR: PC should not have updated"); err = 1;
        end

        
/*/
//*   <--- ADD/REMOVE SLASH AT START OF LINE TO TOGGLE STAGES_2
    // STAGE_2 TEST (fig6.txt)
        // @00 mov r0, X (r0 points to label X @05)
        check_PC(2);
        check_regfile(0, 5);
        
        // @01 ldr r1, [r0]
        check_PC(3);
            // Check intermediate display value of "0x0005"
        check_display({`x0, `x0, `x0, `x5});
        
        // @02 mov r2, Y (r2 points to label Y @06)
        check_PC(4);
        check_regfile(2, 6);
        
        // @03 str r2, Y
            // check intermediate display value of "0x0006"
        #35 check_display({`x0, `x0, `x0, `x6});
        check_PC(5);
            // check display output 0xABCD
        check_display({`xA, `xb, `xC, `xd});
        
/*/
/*   <--- ADD/REMOVE SLASH AT START OF LINE TO TOGGLE STAGES_3
    // STAGE_3 TEST (fig8.txt)
        // @00: mov r0, SW_BASE (r0 points to label SW_BASE (line 8))
         // t = 50
        check_LEDR(10'b10_xxxx_xxxx);
        check_PC(2);            // t = 100
        check_regfile(0, 8);
        #15 check_LEDR(10'b00_xxxx_xxxx);
        
        // @01: ldr r0, [r0] (0x0140)
            // Check intermediate display value of "0x0008"
        #35 check_display({`x0, `x0, `x0, `x8});
        check_PC(3);            // t = 190
        check_regfile(0, 9'h140);
        
        // @02: ldr r2, [r0] (mem_addr = 0x140  ==>  r2 = read_data = SW[7:0])
            // Check intermediate display value of "0x0140"
        #40 check_display({`x0, `x1, `x4, `x0});  // t = 230
            // check led8 activates when awaiting switch input
        #15 check_LEDR(10'b01_xxxx_xxxx);                   // t = 25
        sim_SW = 8'h2f;
        check_PC(4);            // t = 280
        check_regfile(2, 8'h2f);
        
        // @03: mov r3, r2, lsl#1
        check_PC(5);            // t = 350
        check_regfile(3, 8'h5e);
        
        // @04: mov r1, LEDR_BASE (r1 points to label LEDR_BASE (line 9)
        check_PC(6);            // t = 400
        check_regfile(1, 9);
        
        // @05: ldr r1, [r1] (0x0100)
            // Check intermediate display value of "0x0009"
        #35 check_display({`x0, `x0, `x0, `x9});
        check_PC(7);            // t = 490
        check_regfile(1, 9'h100);
        
        // @06: str r3, [r1] (mem_addr = 0x100  ==>  LEDR = r3)
            // Check intermediate display value of "0x0100"
        #40 check_display({`x0, `x1, `x0, `x0});  // t = 530
        check_PC(8);            // t = 590
            // check that the LED display gets updated correctly
        check_LEDR({2'b10, `bFIVE, `bFOURTEEN});
        
        // @07: halt    (LEDR[9:8] = 2'b11)
        #45 check_LEDR({2'b11, `bFIVE, `bFOURTEEN});
//*/

        // print pass/fail
        #35 $display();
        if (err)
            $display("FAILED LAB_7_TOP TESTS");
        else
            $display("PASSED LAB_7_TOP TESTS");
        $display();        
        $stop;
    end

endmodule