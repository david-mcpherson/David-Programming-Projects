// instruction operations
`define ADD         2'b00
`define CMP         2'b01
`define AND         2'b10
`define MVN         2'b11

// mem_cmd cases
`define MNONE       2'd0
`define MREAD       2'd1
`define MWRITE      2'd2

// ALU operations
`define SUB         2'b01
`define AND         2'b10
`define NOT         2'b11

// opcodes
`define DT          3'b110
`define DP          3'b101
`define LDR         5'b011_00
`define STR         5'b100_00
`define HALT        5'b111_00
`define B           5'b001_00
`define BL          5'b010_11
`define BX          5'b010_00
`define BLX         5'b010_10

// shifter operations
`define ALL_ZERO    16'b0000_0000_0000_0000
`define NO_SHIFT    2'b00
`define LSL         2'b01
`define LSR         2'b10
`define ASR         2'b11

// pc_sel cases
`define PC_PLUS1    2'd0
`define RESET_PC    2'd1
`define BRANCH_LBL  2'd2
`define DP_OUT      2'd3

// nsel cases
`define Rn          2'b00
`define Rd          2'b01
`define Rm          2'b10

// vsel cases
`define C           2'b00
`define PC          2'b01
`define SXIMM8      2'b10
`define MDATA       2'b11

// move instructions
`define MOV_IMM     2'b10
`define MOV_REG     2'b00

// registers
`define R0          3'd0
`define R1          3'd1
`define R2          3'd2
`define R3          3'd3
`define R4          3'd4
`define R5          3'd5
`define R6          3'd6
`define R7          3'd7

// binary numbers
`define bZERO       4'b0000
`define bONE        4'b0001
`define bTWO        4'b0010
`define bTHREE      4'b0011
`define bFOUR       4'b0100
`define bFIVE       4'b0101
`define bSIX        4'b0110
`define bSEVEN      4'b0111
`define bEIGHT      4'b1000
`define bNINE       4'b1001
`define bTEN        4'b1010
`define bELEVEN     4'b1011
`define bTWELVE     4'b1100
`define bTHIRTEEN   4'b1101
`define bFOURTEEN   4'b1110
`define bFIFTEEN    4'b1111

// sseg display numbers
`define x0          7'b1000000
`define x1          7'b1111001
`define x2          7'b0100100
`define x3          7'b0110000
`define x4          7'b0011001
`define x5          7'b0010010
`define x6          7'b0000010
`define x7          7'b1111000
`define x8          7'b0000000
`define x9          7'b0010000
`define xA          7'b0001000
`define xb          7'b0000011
`define xC          7'b1000110
`define xd          7'b0100001
`define xE          7'b0000110
`define xF          7'b0001110

// FSM states
`define RST         6'd0
`define IF1         6'd1
`define IF2         6'd2
`define UPDATE_PC   6'd3
`define DECODE      6'd4
`define WRITE_IMM   6'd5
`define WR0         6'd6
`define WR1         6'd7
`define WR2         6'd8
`define WR3         6'd9
`define ADD0        6'd10
`define ADD1        6'd11
`define ADD2        6'd12
`define ADD3        6'd13
`define CMP0        6'd14
`define CMP1        6'd15
`define CMP2        6'd16
`define AND0        6'd17
`define AND1        6'd18
`define AND2        6'd19
`define AND3        6'd20
`define MVN0        6'd21
`define MVN1        6'd22
`define MVN2        6'd23
`define MVN3        6'd24
`define LDR0        6'd25
`define LDR1        6'd26
`define LDR2        6'd27
`define LDR3        6'd28
`define LDR4        6'd29
`define STR0        6'd30
`define STR1        6'd31
`define STR2        6'd32
`define STR3        6'd33
`define STR4        6'd34
`define STR5        6'd35
`define HALT_ST     6'd36
`define B1          6'd37
`define B2          6'd38
`define GOTO        6'd39
`define BL1         6'd40
`define BX1         6'd41
`define BX2         6'd42
`define BX3         6'd43
`define BLX1        6'd44
