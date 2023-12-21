module alu (
    input [31:0] a,
    input [31:0] b,
    input [3:0] opcode,
    output reg [31:0] y,
    output reg [1:0] flags //Z,N
);

//reg[32:0] carry; //not necessary

always @(opcode, a, b) begin
    case (opcode)
        4'b0000: begin
            y = a + b; //PLUS
            if (y==0) flags[0]=1;
            else flags[0]=0;
            flags[1]=y[31];
        end
        4'b0001: begin
            y = a - b; //MINUS
            if (y==0) flags[0]=1;
            else flags[0]=0;
            flags[1]=y[31];
            
        end
        4'b0010: y = a & b; //AND

        4'b0011: y = a | b; //OR

        4'b0100: y = a ^ b; //XOR

        4'b0101: y = ~(a | b); //NOR

        4'b0110: y = b << a; //shift logic left

        4'b0111: y = b >> a; //shift logic right

        4'b1000: y = $signed(b) >>> a[4:0]; //shift arithmetic right

        4'b1001: begin
            if (a < b) y = 1; //if statement
            else y = 0;
            if (y==0) flags[0]=1;
            else flags[0]=0;
            flags[1]=y[31];
        end
        4'b1010: begin
            y = a; //A
            if (y==0) flags[0]=1;
            else flags[0]=0;
            flags[1]=y[31];
        end
        4'b1011: begin
            y = b; //B
            if (y==0) flags[0]=1;
            else flags[0]=0;
            flags[1]=y[31];
        end
        4'b1100: y = b + 8; //add 8 to B

        //unused inputs listed below
        //4'b1101: y = a + b;
        //4'b1110: y = a + b;

        //4'b1111: y = a + b;
    endcase

 // $display("opcode: %b, a: %b, b: %b, y: %b", opcode, a, b ,y);

    end
endmodule