module testbench;
     reg [31:0] a, b;
     reg [3:0] opcode;
     wire [31:0] y;
     wire [1:0] flags;
 
     alu alu_inst (
         .a(a),
         .b(b),
         .opcode(opcode),
         .y(y),
         .flags(flags)
     );
 
     initial begin
         //set values
         a = 32'd2;
         b = 32'b10001100000000000000000000001100;
         opcode = 4'b0000; 
         #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b0001; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b0010; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b0011; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b0100; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b0101; 
         #1
                 $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b0110; 
         #1
                 $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b0111; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b1000; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b1001; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b1010; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b1011; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
         opcode = 4'b1100; 
        #1
                  $display("Opcode: %b | a: %d, %b  | b: %d, %b | Result: %d, %b | Flag Z:  %b | Flag N: %b" , opcode, a, a, b, b, y, y, flags[0], flags[1]);
       
     end
 endmodule
