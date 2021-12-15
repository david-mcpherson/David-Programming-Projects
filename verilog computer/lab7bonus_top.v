`include "constants.v"

module lab7bonus_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);
    input [3:0] KEY;
    input [9:0] SW;
    input CLOCK_50;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    
    wire [1:0] mem_cmd;
    wire [8:0] mem_addr;
    wire [15:0] read_data, din, dout, ir, datapath_out;
    wire Z, N, V, drive_SW, load_LEDs, led9, led8;
    wire write = (mem_cmd === `MWRITE) & ~mem_addr[8];
    reg [7:0] led_reg;
    wire switch_enable = (mem_cmd===`MREAD & mem_addr===9'h140);
    wire load_LEDR = (mem_cmd === `MWRITE & mem_addr === 9'h100);
    
    // instantiate the cpu
    cpu CPU (
        .clk   (CLOCK_50),
        .reset (~KEY[1]),
        .in    (read_data),
        .out   (datapath_out),
        .Z     (Z),
        .N     (N),
        .V     (V),
        .led9  (led9),
        .led8  (led8),
        .mem_cmd    (mem_cmd),
        .mem_addr   (mem_addr)
    );
    
    // instantiate read-write memory
    RAM #(16, 8) MEM ( 
        .clk            (CLOCK_50),
        .read_address   (mem_addr[7:0]),
        .write_address  (mem_addr[7:0]),
        .write          (write),
        .din            (datapath_out),
        .dout           (dout)
    );
    
    // Connect switch input to read_data thru tri-state inverter
    assign read_data = switch_enable?{8'h00, SW[7:0]}:{16{1'bz}};
    
    // Connect RAM output to read_data thru tri-state inverter
    wire dout_enable = (mem_cmd === `MREAD) & ~mem_addr[8];
    assign read_data = dout_enable ? dout : {16{1'bz}};
    
    // logic for updating the LED display
    always @(posedge ~KEY[0])
        led_reg = load_LEDR ? datapath_out[7:0] : led_reg;
    
    // display status flags on leftmost HEX
    assign HEX5[0] = ~Z;
    assign HEX5[6] = ~N;
    assign HEX5[3] = ~V;

    // Display outputs on the DE1 board
    sseg H0(datapath_out[3:0],   HEX0);
    sseg H1(datapath_out[7:4],   HEX1);
    sseg H2(datapath_out[11:8],  HEX2);
    sseg H3(datapath_out[15:12], HEX3);
    assign HEX4 = 7'b1111111;
    assign {HEX5[2:1], HEX5[5:4]} = 4'b1111; // disabled
    assign LEDR = {led9, led8, led_reg};
endmodule

// Connect datapath_out to the seven-segment display
module sseg(in,segs);
    input [3:0] in;
    output [6:0] segs;
    reg [6:0] segs;

    always @(in)
        case (in)
            `bZERO:     segs = `x0;
            `bONE:      segs = `x1;
            `bTWO:      segs = `x2;
            `bTHREE:    segs = `x3;
            `bFOUR:     segs = `x4;
            `bFIVE:     segs = `x5;
            `bSIX:      segs = `x6;
            `bSEVEN:    segs = `x7;
            `bEIGHT:    segs = `x8;
            `bNINE:     segs = `x9;
            `bTEN:      segs = `xA;
            `bELEVEN:   segs = `xb;
            `bTWELVE:   segs = `xC;
            `bTHIRTEEN: segs = `xd;
            `bFOURTEEN: segs = `xE;
            `bFIFTEEN:  segs = `xF;
            default:    segs = 7'b0111111;  // invalid HEX: "-"
        endcase
endmodule