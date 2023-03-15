//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
wire    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter

//Main function
assign ALU_op_o[2:0] = instr_op_i[3:1];

always @(ALU_op_o) begin
	case(instr_op_i)
		//R-format
		6'd0: begin
			RegDst_o <= 1;
			RegWrite_o <= 1;
			Branch_o <= 0;
			ALUSrc_o <= 0;
		end
		//branch
		6'd4: begin
			RegDst_o <= 0;
			RegWrite_o <= 0;
			Branch_o <= 1;
			ALUSrc_o <= 0;
		end
		//addi
		6'd8: begin
			RegDst_o <= 0;
			RegWrite_o <= 1;
			Branch_o <= 0;
			ALUSrc_o <= 1;
		end
		//slti
		6'd10: begin
			RegDst_o <= 0;
			RegWrite_o <= 1;			
			Branch_o <= 0;
			ALUSrc_o <= 1;
		end
	endcase
	//$display("ALU_op_o ", ALU_op_o);
end
endmodule





                    
                    