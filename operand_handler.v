module source_operand (
    input [31:0] PB,
    input [31:0] HI,
    input [31:0] LO,
    input [31:0] PC,
    input [15:0] imm16,
    input [2:0] SI,
    output reg [31:0] N
    );

    always @(SI,PB,HI,LO,PC,imm16) begin
        case(SI)
            3'b000: N = PB;
            3'b001: N = HI;
            3'b010: N = LO;
            3'b011: N = PC;
            3'b100: begin
                 N = {{16{imm16[15]}}, imm16};
            end
            3'b101: N = {imm16, 16'h0};
            //unused below
            //3'b110: N = 0;
            //3'b111: N = 0;
        endcase
             //$display("S0 = %b | S1 = %b | S2 = %b | N: %b", SI[0], SI[1], SI[2], N); //check result
    end
endmodule