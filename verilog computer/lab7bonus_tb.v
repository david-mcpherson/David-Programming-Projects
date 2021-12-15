module lab7bonus_tb;
    reg [3:0] KEY;
    reg [9:0] SW;
    wire [9:0] LEDR; 
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    reg err;
    reg CLOCK_50;

    lab7bonus_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);

    initial forever begin
    CLOCK_50 = 0; #5;
    CLOCK_50 = 1; #5;
    end

    initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
    if (
        DUT.MEM.mem[0] !== 16'b1101000000001010 
    ) begin err = 1; $display("FAILED: data.txt must be set to tb.txt"); $stop; end

    #10; // wait until next falling edge of clock
    KEY[1] = 1'b1; // reset de-asserted, PC still undefined if as in Figure 4

    #10; // waiting for RST state to cause reset of PC
    if (DUT.CPU.PC !== 9'h0) begin err = 1; $display("FAILED: PC did not reset to 0."); $stop; end

    // If your simlation never gets past the the line below, check if your CMP instruction is working
    @(posedge LEDR[8]); // set LEDR[8] to one when executing HALT

    // NOTE: your program counter register output should be called PC and be inside a module with instance name CPU
    if (DUT.CPU.PC !== 9'h0a) begin err = 1; $display("FAILED: PC at HALT is incorrect."); $stop; end
    
    if (DUT.CPU.DP.REGFILE.R2 !== 16'h000f) begin err = 1; $display("FAILED: R2 should be 0xf"); $stop; end
    if (DUT.CPU.DP.REGFILE.R3 !== 16'h0011) begin err = 1; $display("FAILED: R3 should be 0x11"); $stop; end
    if (DUT.CPU.DP.REGFILE.R4 !== 16'h002a) begin err = 1; $display("FAILED: R4 should be 0x2a"); $stop; end
    
    if (DUT.CPU.DP.REGFILE.R1 !== 16'd3) begin err = 1; $display("FAILED: R1 should be 3"); $stop; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h0b) begin err = 1; $display("FAILED: R0 should point to N[1]"); $stop; end
    
    if (DUT.MEM.mem[8'h0c] !== 16'd3)  begin err = 1; $display("FAILED: mem[0x0c] should be 3"); $stop; end
    if (DUT.MEM.mem[8'h0a] !== 16'd3)  begin err = 1; $display("FAILED: mem[0x0a] should be 3"); $stop; end
    
    if (~err) $display("\nPASSED LAB7_BONUS TESTS");
    $stop;
    end
endmodule
