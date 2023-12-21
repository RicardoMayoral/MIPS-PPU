//`timescale 1ns / 1ns
//`include "src/operand-handler.v"

 module testbench;
    reg [31:0] PB;
    reg [31:0] HI;
    reg [31:0] LO;
    reg [31:0] PC;
    reg [15:0] imm16;
    reg [2:0] SI;
    wire [31:0] N;
 
     source_operand uut (
         .PB(PB),
         .HI(HI),
         .LO(LO),
         .PC(PC),
         .imm16(imm16),
         .SI(SI),
         .N(N)
     );
 
     initial begin
        //set unique number input values
        PB = 32'b01000011100101001010110100010011;
        HI = 32'b10101001001011111100111111011111;
        LO = 32'b01110001010001000100010010100111;
        PC = 32'b00000111101000011011101011100111;
        imm16 = 16'b1110110001000100;

        SI = 3'b000; //initial SI Value: 000

        repeat (7) #1 SI = SI + 3'b001;
        #1
        imm16 = 16'b0110110001000100;
        SI[2] = 1;
        SI[1] = 0;
        SI[0] = 0;
        
     end

     initial begin //display
        $monitor("%b | %b | %b | %b", SI[2],SI[1],SI[0], N);
    end

endmodule