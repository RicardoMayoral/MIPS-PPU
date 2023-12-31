/**************************************************************
* Module Name: control_unit_mux
***************************************************************
* Description:
*     This module represents a control unit multiplexer. It selects and outputs control signals based on the input select signal (S) and the input data (cu_in_mux).
* 
* Ports:
*     - ID_ALU_OP_out (output reg [3:0]): 4-bit output for ALU operation.
*     - ID_jmpl_instr_out (output reg): Output for jump-link (jmpl) instruction.
*     - ID_call_instr_out (output reg): Output for call instruction.
*     - ID_branch_instr_out (output reg): Output for branch instruction.
*     - ID_load_instr_out (output reg): Output for load instruction.
*     - ID_register_file_Enable_out (output reg): Output for register file enable.
*     - ID_data_mem_SE (output reg): Output for data memory store-enable.
*     - ID_data_mem_RW (output reg): Output for data memory read-write.
*     - ID_data_mem_Enable (output reg): Output for data memory enable.
*     - ID_data_mem_Size (output reg [1:0]): 2-bit output for data memory size.
*     - I31_out (output reg): Output for I31 signal.
*     - I30_out (output reg): Output for I30 signal.
*     - I24_out (output reg): Output for I24 signal.
*     - I13_out (output reg): Output for I13 signal.
*     - ID_ALU_OP_instr (output reg [3:0]): 4-bit output for ALU operation instruction.
*     - CC_Enable (output reg): Output for condition code (CC) enable.
* 
*     - S (input): Select signal.
*     - cu_in_mux (input [18:0]): Input data for control unit multiplexer.
* 
* Usage:
*     1. Instantiate the module in your Verilog design.
*     2. Connect the select signal (S) and the input data (cu_in_mux) appropriately.
*     3. The control signals will be available on the corresponding output ports.
* 
* Notes:
*     - The control signals are selected based on the value of the select signal (S) and the input data (cu_in_mux).
*     - When S is high (1'b1), all output signals are set to 0.
*     - Ensure that the width of the input data (cu_in_mux) is compatible with the module's interface.
* bra
*/
module control_unit_mux(
    output reg ID_branch_instr_out,            // 3
    output reg [18:0] CU_SIGNALS,          // 15,16,17,18

    input S,
    input [19:0] cu_in_mux
    );

    always  @(S, cu_in_mux) begin
        if (S == 1'b0) begin
            ID_branch_instr_out         <= cu_in_mux[19];
            CU_SIGNALS                  <= cu_in_mux[18:0];
        end else begin
            ID_branch_instr_out         <= 1'b0;
            CU_SIGNALS                  <= 19'b0;
        end
    end
endmodule

/**************************************************************
 * Module Name: control_unit
 **************************************************************
 * The control_unit module is responsible for generating control signals based on the input instruction.
 * It takes a 32-bit instruction as input and produces various control signals as outputs.
 * The module decodes the instruction opcode and opcode extension to determine the type of instruction
 * and sets the corresponding control signals accordingly.
 * The control signals include flags for different types of instructions such as jmpl, call, branch, load,
 * register file enable, memory operation type, memory size, ALU operation, condition code enable, and various
 * instruction-specific flags.
 * The control signals are used to control the operation of other modules in the processor pipeline.
 *
 * Inputs:
 * - instr: A 32-bit instruction to be decoded (input)
 * - clk: Clock signal (input)
 * - clr: Clear signal (input)
 *
 * Outputs:
 * - instr_signals: A 19-bit vector of control signals (output)
 *   - instr_signals[0]: ID_jmpl_instr - Signal indicating if the instruction is a jmpl instruction
 *   - instr_signals[1]: ID_call_instr - Signal indicating if the instruction is a call instruction
 *   - instr_signals[2]: ID_load_instr - Signal indicating if the instruction is a load instruction
 *   - instr_signals[3]: ID_register_file_Enable - Signal indicating if the register file should be enabled
 *   - instr_signals[4]: ID_data_mem_SE - Signal indicating if the memory operation is sign-extended
 *   - instr_signals[5]: ID_data_mem_RW - Signal indicating if the memory operation is a read or write
 *   - instr_signals[6]: ID_data_mem_Enable - Signal indicating if the memory should be enabled
 *   - instr_signals[8:7]: ID_data_mem_Size - Signal indicating the size of memory operation
 *   - instr_signals[9]: CC_Enable - Signal indicating if the condition codes should be enabled
 *   - instr_signals[10]: I31 - Bit 31 of the instruction
 *   - instr_signals[11]: I30 - Bit 30 of the instruction
 *   - instr_signals[12]: I24 - Bit 24 of the instruction
 *   - instr_signals[13]: I13 - Bit 13 of the instruction
 *   - instr_signals[17:14]: ID_ALU_OP_instr - Signal indicating the ALU operation for the instruction
 *   - instr_signals[18]: ID_branch_instr - Signal indicating if the instruction is a branch instruction
 *
 * Implementation:
 * - The module starts by checking if the clear signal is active and initializes all control signals to 0.
 * - Next, it checks the opcode of the instruction and determines the type of instruction based on the opcode.
 * - If the opcode is a branch instruction, the corresponding control signals are set.
 * - If the opcode is a load instruction, the corresponding control signals are set.
 * - If the opcode is a sethi instruction, the corresponding control signals are set.
 * - If the opcode is a format 2 instruction, the opcode extension is checked to determine the specific instruction type.
 * - For jmpl instructions, the control signals are set accordingly.
 * - For save and restore instructions, the control signals are set accordingly.
 * - For arithmetic instructions, the opcode extension is further checked to determine the ALU operation and condition code flags.
 * - Finally, the control signals are assigned to the output instr_signals.
 *
 * Note:
 * - This module assumes a specific instruction set architecture (SPARC) and may not be applicable to other architectures.
 * - The module implementation shown here is a simplified example
 *   and may need to be customized or extended to support additional instructions or architectures.
 * - The control signals generated by this module are used to control the operation of other modules in the processor pipeline,
 *   such as the register file, ALU, and memory units.
 * - The control signals determine the data paths and control flow within the processor based on the current instruction.
 * - The control signals are crucial for executing instructions correctly and efficiently, ensuring proper synchronization,
 *   and maintaining the pipeline stages.
 * - It is important to ensure that the control signals are generated accurately to match the behavior specified by the instruction set architecture.
 * - Changes or modifications to the instruction set architecture or the addition of new instructions may require updating
 *   the control unit module to handle the new instructions and generate the appropriate control signals.
 * - This control unit module is just one component of a complete processor design and should be integrated into a larger design
 *   that includes other modules such as instruction fetch, decode, execute, and memory units to create a functional processor.
 *
 * Usage:
 * - Instantiate the control_unit module in your processor design and connect the inputs and outputs as required.
 * - Connect the 'instr' input to the 32-bit instruction that needs to be decoded.
 * - Connect the 'clk' input to the clock signal of your design.
 * - Connect the 'clr' input to the clear signal of your design to initialize the control signals.
 * - Use the 'instr_signals' output to control the operation of other modules based on the decoded instruction.
 * - Ensure that the control signals are propagated correctly through the pipeline stages of your processor design.
 * - Verify the functionality and correctness of the control unit module using simulation and testing.
 * - Modify and customize the control unit module as needed to support the specific instruction set architecture and processor design requirements.
 *
 * Example:
 * // Instantiate the control_unit module
 * control_unit cu (
 *   .instr(instr),
 *   .clk(clk),
 *   .clr(clr),
 *   .instr_signals(instr_signals)
 * );
 *
 * // Connect the control signals to other modules in the processor design
 * module_name module_inst (
 *   .clk(clk),
 *   .instr_signals(instr_signals),
 *   // Other module inputs and outputs
 * );
 *
 * // Ensure correct propagation of control signals through the pipeline stages
 * // and synchronization with the clock signal in the processor design.
 *
 * // Simulate and test the control unit module functionality using testbenches and test cases.
 *
 * Design Considerations:
 * - The control_unit module assumes a single-cycle execution model, where each instruction is executed in a single clock cycle.
 *   If your processor design follows a different execution model, you may need to modify the control unit accordingly.
 * - This control unit module focuses on generating control signals for the execution of instructions and does not handle pipeline hazards,
 *   branch prediction, or other advanced techniques. Additional modules and logic may be required to handle such features.
 * - It is important to ensure that the control signals are synchronized with the clock signal to avoid timing issues and ensure proper operation.
 * - The control unit module relies on the instruction set architecture (ISA) specifications to determine the control signal assignments.
 *   Ensure that the ISA documentation is referenced correctly and that the control unit module accurately reflects the ISA requirements.
 * - Care should be taken to handle exceptional cases, such as unsupported instructions or illegal instruction combinations,
 *   to prevent unintended behavior and maintain the correctness and stability of the processor.
 * - Consider implementing error detection and correction mechanisms to handle faults and ensure reliable operation of the control unit.
 * - To support a wider range of instructions or a different instruction set architecture, the control unit module may need to be expanded
 *   with additional control signals and logic to accommodate the new instructions and their associated operations.
 * - It is recommended to thoroughly test the control unit module with various instruction sequences and corner cases to ensure its correctness,
 *   functionality, and compatibility with the processor design.
 * - Documentation and comments within the module should be kept up to date to provide clarity and aid in understanding and maintaining the code.
 * - Maintain good coding practices such as using meaningful signal and variable names, organizing the code in a modular and readable manner,
 *   and adhering to coding style guidelines to improve maintainability and readability of the control unit module.
 * - Collaborate and communicate with other members of the design team to ensure consistent understanding and implementation of the control signals
 *   throughout the processor design and to address any potential conflicts or issues that may arise during the integration process.
 *
 * Limitations:
 * - The control unit module provided here is a simplified implementation and may not cover all possible instructions or complex control scenarios.
 *   It serves as a starting point and should be customized and extended based on the specific requirements of the processor design.
 * - The control unit module assumes a specific instruction set architecture (ISA) and may not be compatible with other architectures without modifications.
 *   Ensure that the ISA specifications are carefully considered and accurately reflected in the control unit implementation.
 * - This control unit module does not include support for privileged instructions or operating system-specific functionality.
 *   If your processor design requires handling privileged instructions, additional logic and control signals may need to be added.
 * - It is important to consider the performance and efficiency of the control unit implementation, as it directly affects the overall processor performance.
 *   Complex control logic or excessive signal dependencies can introduce delays and reduce the maximum achievable clock frequency.
 *   Careful optimization and consideration of critical paths may be necessary to meet performance targets.
*/
module control_unit(
    input wire[31:0] instr,
    input clk, clr, // clock and clear
    output wire [19:0] instr_signals
);
    reg ID_jmpl_instr;              // 1
    reg ID_call_instr;              // 2
    reg ID_load_instr;              // 3
    reg ID_store_instr;             // 4
    reg ID_register_file_Enable;    // 5
    reg ID_data_mem_SE;             // 6
    reg ID_data_mem_RW;             // 7
    reg ID_data_mem_Enable;         // 8
    reg [1:0] ID_data_mem_Size;     // 9,10
    reg CC_Enable;                  // 11
    reg I31;                        // 12
    reg I30;                        // 13
    reg I24;                        // 14
    reg I13;                        // 15
    reg [3:0] ID_ALU_OP_instr;      // 16,17,18,19
    reg ID_branch_instr;            // 20

    reg [2:0] is_sethi;
    reg [5:0] op3;

    reg a;

    // the two most significant bits that specifies the instruction format
    reg [1:0] instr_op;

    always @(posedge clk, negedge clr, instr) begin
        if (instr == 32'b0 | instr === 32'bx) begin
            ID_jmpl_instr                   <= 1'b0;
            ID_call_instr                   <= 1'b0;
            ID_branch_instr                 <= 1'b0;
            ID_load_instr                   <= 1'b0;
            ID_store_instr                  <= 1'b0;
            ID_register_file_Enable         <= 1'b0;
            ID_data_mem_SE                  <= 1'b0;
            ID_data_mem_RW                  <= 1'b0;
            ID_data_mem_Enable              <= 1'b0;
            ID_data_mem_Size                <= 2'b0;
            ID_ALU_OP_instr                 <= 4'b0;
            CC_Enable                       <= 1'b0;
            I31                             <= 1'b0;
            I30                             <= 1'b0;
            I24                             <= 1'b0;
            I13                             <= 1'b0;
        end else begin
            I31                             <= instr[31];
            I30                             <= instr[30];
            I24                             <= instr[24];
            I13                             <= instr[13];
            instr_op                         = instr[31:30];
            case (instr_op)
            2'b00: begin // SETHI or Branch Instructions
                ID_jmpl_instr               <= 1'b0;
                ID_call_instr               <= 1'b0;
                ID_load_instr               <= 1'b0; 
                CC_Enable                   <= 1'b0;
                // Verify if this is correct :-)
                ID_store_instr              <= 1'b0;
                // Ask the professor for these
                ID_data_mem_SE              <= 1'b0;
                ID_data_mem_RW              <= 1'b0;
                ID_data_mem_Enable          <= 1'b0;
                ID_data_mem_Size            <= 2'b0;
                is_sethi = instr[24:22];
                if (is_sethi == 3'b100) begin
                    // We specify the ALU to simply forward B.
                    // The source operand2 handler will deal with the
                    // Sethi instruction
                    ID_ALU_OP_instr             <= 4'b1110;
                    ID_branch_instr             <= 1'b0;
                    ID_register_file_Enable     <= 1'b1;
                end
                else if (is_sethi == 3'b010) begin // So this is actually a branch instruction
                    ID_branch_instr             <= 1'b1;
                    ID_register_file_Enable     <= 1'b0;
                    ID_ALU_OP_instr             <= 4'b0000;
                end
            end
            2'b01: begin // Call Instruction
                ID_jmpl_instr                   <= 1'b0;
                ID_call_instr                   <= 1'b1;
                ID_branch_instr                 <= 1'b0;
                ID_load_instr                   <= 1'b0;
                ID_register_file_Enable         <= 1'b1;
                ID_data_mem_SE                  <= 1'b0;
                ID_data_mem_RW                  <= 1'b0;
                ID_data_mem_Enable              <= 1'b0;
                ID_data_mem_Size                <= 2'b00;
                ID_ALU_OP_instr                 <= 4'b0000;
                CC_Enable                       <= 1'b0;

                // Verify This later :-)
                ID_store_instr              <= 1'b0;
            end
            2'b10, 2'b11: begin
                op3 = instr[24:19]; // the opcode instruction that tells what to do
                if (instr_op == 2'b11) begin
                    // Load/Store Instruction
                    ID_jmpl_instr               <= 1'b0;
                    ID_call_instr               <= 1'b0;

                    ID_branch_instr             <= 1'b0;
                    CC_Enable                   <= 1'b0;
                    ID_ALU_OP_instr             <= 4'b0000;
                    ID_data_mem_Enable          <= 1'b1;
                    case (op3)
                        6'b001001, 6'b001010, 6'b000000, 6'b000001, 6'b000010: 
                        begin
                            // Load Mode
                            // Load	sign byte | Load sign halfword | Load word | Load unsigned byte | Load unsigned halfword
                            // Turn on Load Instruction
                            // Enable Memory
                            // Trigger Memory to Read mode
                            ID_load_instr                   <= 1'b1;
                            // Ask
                            ID_store_instr                  <= 1'b0;
                            ID_data_mem_RW                  <= 1'b0;
                            ID_register_file_Enable         <= 1'b1;
                            if (op3 == 6'b001001) begin// Load signed byte
                                ID_data_mem_SE              <= 1'b1;
                                ID_data_mem_Size            <= 2'b00;
                            end else if (op3 == 6'b001010) begin // Load signed halfword
                                ID_data_mem_SE              <= 1'b1;
                                ID_data_mem_Size            <= 2'b01;       
                            end else if (op3 == 6'b000000) begin // Load word
                                ID_data_mem_SE              <= 1'b0;
                                ID_data_mem_Size            <= 2'b10;                            
                            end else if (op3 == 6'b000001) begin // Load unsigned byte
                                ID_data_mem_SE              <= 1'b0;
                                ID_data_mem_Size            <= 2'b00;
                            end else begin // 6'b000010 Load unsigned halfword
                                ID_data_mem_SE              <= 1'b0;
                                ID_data_mem_Size            <= 2'b01;
                                end
                            end
                            6'b000101, 6'b000110, 6'b000100:
                            begin
                                // Store Mode (mem is set to write mode)
                                ID_load_instr               <= 1'b0;
                                // Ask
                                ID_store_instr              <= 1'b1;

                                ID_data_mem_RW              <= 1'b1;
                                ID_register_file_Enable     <= 1'b0;
                                if (op3 == 6'b000101) begin // Store byte
                                    // ID_data_mem_SE        <= 1'b0;
                                    ID_data_mem_Size         <= 2'b00;
                                end else if (op3 == 6'b000110) begin //  Store Halfword
                                    // ID_data_mem_SE        <= 1'b0;
                                    ID_data_mem_Size         <= 2'b01;
                                end else  begin // 6'b000100 Store Word
                                    // ID_data_mem_SE        <= 1'b0;
                                    ID_data_mem_Size         <= 2'b10;
                                end 
                            end
                        endcase
                    end else if (instr_op == 2'b10) begin
                        // Read/Write/Trap/Save/Restore/Jmpl/Arithmetic
                        // Why the fuck Sparc had to squeeze so many possible instructions on this one block, like... bruh
                        ID_call_instr                        <= 1'b0;
                        ID_branch_instr                      <= 1'b0;
                        case (op3)
                            // Jmpl
                            6'b111000: begin
                                ID_jmpl_instr               <= 1'b1;
                                ID_load_instr               <= 1'b0;
                                // Ask
                                ID_store_instr              <= 1'b0;

                                ID_data_mem_SE              <= 1'b0;
                                ID_data_mem_RW              <= 1'b0;
                                ID_register_file_Enable     <= 1'b0;
                                ID_ALU_OP_instr             <= 4'b0000;
                                ID_data_mem_Enable          <= 1'b0;
                                ID_data_mem_Size            <= 2'b00;    
                                CC_Enable                   <= 1'b0;
                            end
                            // Save and Restore Instruction Format
                            6'b111100, 6'b111101: begin
                                ID_jmpl_instr               <= 1'b0;
                                ID_load_instr               <= 1'b0;
                                // Ask
                                ID_store_instr              <= 1'b0;

                                ID_register_file_Enable     <= 1'b1;
                                ID_ALU_OP_instr             <= 4'b0000;
                                CC_Enable                   <= 1'b0;
                                ID_data_mem_SE              <= 1'b0;
                                ID_data_mem_RW              <= 1'b0;
                                ID_data_mem_Enable          <= 1'b1;
                                ID_data_mem_Size            <= 2'b10;
                            end
                            // Arithmetic
                            default: begin
                                // For cases where the signal modifies condition codes
                                case (op3)
                                    6'b000000: begin // add
                                        ID_ALU_OP_instr             <= 4'b0000;
                                        CC_Enable                   <= 1'b0;
                                        ID_register_file_Enable     <= 1'b1;
                                        ID_data_mem_RW              <= 1'b0;
                                        ID_data_mem_Enable          <= 1'b0;
                                    end
                                    6'b010000: begin // addcc
                                        ID_ALU_OP_instr <= 4'b0000;
                                        CC_Enable       <= 1'b1;
                                        ID_register_file_Enable     <= 1'b1;
                                        ID_data_mem_RW              <= 1'b0;
                                        ID_data_mem_Enable          <= 1'b0;
                                    end
                                    6'b001000: begin // addx
                                        ID_ALU_OP_instr <= 4'b0001;
                                        CC_Enable       <= 1'b0;
                                        ID_register_file_Enable     <= 1'b1;
                                        ID_data_mem_RW              <= 1'b0;
                                        ID_data_mem_Enable          <= 1'b0;
                                    end
                                    6'b011000: begin // addxcc
                                        ID_ALU_OP_instr <= 4'b0001;
                                        CC_Enable       <= 1'b1;
                                        ID_register_file_Enable     <= 1'b1;
                                        ID_data_mem_RW              <= 1'b0;
                                        ID_data_mem_Enable          <= 1'b0;
                                    end
                                    6'b000100: begin // sub
                                        ID_ALU_OP_instr <= 4'b0010;
                                        CC_Enable       <= 1'b0;
                                        ID_register_file_Enable     <= 1'b1;
                                        ID_data_mem_RW              <= 1'b0;
                                        ID_data_mem_Enable          <= 1'b0;
                                    end
                                    6'b010100: begin // subcc
                                        ID_ALU_OP_instr <= 4'b0010;
                                        CC_Enable       <= 1'b1;
                                        ID_register_file_Enable     <= 1'b1;
                                        ID_data_mem_RW              <= 1'b0;
                                        ID_data_mem_Enable          <= 1'b0;
                                    end
                                    6'b001100: begin // subx
                                        ID_ALU_OP_instr <= 4'b0011;
                                        CC_Enable       <= 1'b0;
                                        ID_register_file_Enable     <= 1'b1;
                                        ID_data_mem_RW              <= 1'b0;
                                        ID_data_mem_Enable          <= 1'b0;
                                    end
                                    6'b000001: begin // and
                                        ID_ALU_OP_instr <= 4'b0100;
                                        CC_Enable       <= 1'b0;
                                    end
                                    6'b010001: begin // andcc
                                        ID_ALU_OP_instr <= 4'b0100;
                                        CC_Enable       <= 1'b1;
                                    end
                                    6'b000101: begin // andn (and not)
                                        ID_ALU_OP_instr <= 4'b1000;
                                        CC_Enable       <= 1'b0;
                                    end
                                    6'b010101: begin // andncc
                                        ID_ALU_OP_instr <= 4'b1000;
                                        CC_Enable       <= 1'b1;
                                    end
                                    6'b000010: begin // or
                                        ID_ALU_OP_instr <= 4'b0101;
                                        CC_Enable       <= 1'b0;
                                    end
                                    6'b010010: begin // orcc
                                        ID_ALU_OP_instr <= 4'b0101;
                                        CC_Enable       <= 1'b1;
                                    end
                                    6'b000110: begin // orn (or not)
                                        ID_ALU_OP_instr <= 4'b1001;
                                        CC_Enable       <= 1'b0;
                                    end
                                    6'b010110: begin // orncc
                                        ID_ALU_OP_instr <= 4'b1001;
                                        CC_Enable       <= 1'b1;
                                    end
                                    6'b000011: begin // xor
                                        ID_ALU_OP_instr <= 4'b0110;
                                        CC_Enable       <= 1'b0;
                                    end
                                    6'b010011: begin // xorcc
                                        ID_ALU_OP_instr = 4'b0110;
                                        CC_Enable       = 1'b1;
                                    end
                                    6'b000111: begin // xorn (xnor)
                                        ID_ALU_OP_instr <= 4'b0111;
                                        CC_Enable       <= 1'b0;
                                    end
                                    6'b010111: begin // xorncc
                                        ID_ALU_OP_instr <= 4'b0111;
                                        CC_Enable       <= 1'b1;
                                    end
                                    6'b100101: begin // sll (shift left logical)
                                        ID_ALU_OP_instr <= 4'b1010;
                                        CC_Enable       <= 1'b0;
                                    end
                                    6'b100110: begin // srl shift right logical
                                        ID_ALU_OP_instr <= 4'b1011;
                                        CC_Enable       <= 1'b0;
                                    end
                                    6'b100111: begin // sra shift right arithmetic
                                        ID_ALU_OP_instr <= 4'b1100;
                                        CC_Enable       <= 1'b0;
                                    end
                                endcase
                                // include the rest of the flags here
                                ID_jmpl_instr               <= 1'b0;
                                ID_call_instr               <= 1'b0;
                                ID_branch_instr             <= 1'b0;
                                ID_load_instr               <= 1'b0;
                                // Ask
                                ID_store_instr              <= 1'b0;

                                ID_data_mem_SE              <= 1'b0;
                                // ID_data_mem_RW              <= 1'b1;
                                // ID_data_mem_Enable          <= 1'b1;
                                ID_data_mem_Size            <= 2'b0;
                            end
                        endcase
                    end
                end
            endcase      
        end
    end
    assign instr_signals[0]      = ID_jmpl_instr;
    assign instr_signals[1]      = ID_call_instr;
    assign instr_signals[2]      = ID_load_instr;
    assign instr_signals[3]      = ID_store_instr;
    assign instr_signals[4]      = ID_register_file_Enable;

    assign instr_signals[5]      = ID_data_mem_SE;
    assign instr_signals[6]      = ID_data_mem_RW;
    assign instr_signals[7]      = ID_data_mem_Enable;
    assign instr_signals[9:8]    = ID_data_mem_Size;

    assign instr_signals[10]      = CC_Enable;

    assign instr_signals[11]     = I13;
    assign instr_signals[12]     = I24;
    assign instr_signals[13]     = I30;
    assign instr_signals[14]     = I31;

    assign instr_signals[18:15]  = ID_ALU_OP_instr;
    assign instr_signals[19]     = ID_branch_instr;
endmodule