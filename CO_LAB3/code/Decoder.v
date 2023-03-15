//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o,
	PctoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output		   Jump_o;
output		   MemRead_o;
output		   MemWrite_o;
output		   MemtoReg_o;
output		   PctoReg_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [2-1:0] RegDst_o;
reg            Branch_o;
reg		   	   Jump_o;
reg			   MemRead_o;
reg		  	   MemWrite_o;
reg		  	   MemtoReg_o;
reg			   PctoReg_o;

//Parameter

//Main function

always@(instr_op_i) begin
	case(instr_op_i)
		//R-format
		6'd0: begin
			ALU_op_o <= 3'b000;
			RegDst_o <= 2'b01;
			RegWrite_o <= 1;
			Branch_o <= 0;
			ALUSrc_o <= 0;
			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			PctoReg_o <= 0;
		end
		//jump
		6'd2: begin
			//ALU_op_o don't care
			ALU_op_o <= 3'b001;
			RegDst_o <= 2'b00;
			RegWrite_o <= 0;
			Branch_o <= 0;
			ALUSrc_o <= 0;
			Jump_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			PctoReg_o <= 0;
		end
		//jal
		6'd3: begin
			//ALU_op_o don't care
			ALU_op_o <= 3'b001;
			RegDst_o <= 2'b10;
			RegWrite_o <= 1;
			Branch_o <= 0;
			ALUSrc_o <= 0;
			Jump_o <= 1;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			PctoReg_o <= 1;
		end
		//branch
		6'd4: begin
			ALU_op_o <= 3'b010;
			RegDst_o <= 2'b00;
			RegWrite_o <= 0;
			Branch_o <= 1;
			ALUSrc_o <= 0;
			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			PctoReg_o <= 0;
		end
		//addi
		6'd8: begin
			ALU_op_o <= 3'b100;
			RegDst_o <= 2'b00;
			RegWrite_o <= 1;
			Branch_o <= 0;
			ALUSrc_o <= 1;
			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			PctoReg_o <= 0;
		end
		//slti
		6'd10: begin
			ALU_op_o <= 3'b101;
			RegDst_o <= 2'b00;
			RegWrite_o <= 1;			
			Branch_o <= 0;
			ALUSrc_o <= 1;
			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 0;
			MemtoReg_o <= 0;
			PctoReg_o <= 0;
		end
		//lw
		6'd35: begin
			ALU_op_o <= 3'b100;
			RegDst_o <= 2'b00;
			RegWrite_o <= 1;			
			Branch_o <= 0;
			ALUSrc_o <= 1;
			Jump_o <= 0;
			MemRead_o <= 1;
			MemWrite_o <= 0;
			MemtoReg_o <= 1;
			PctoReg_o <= 0;
		end
		//sw
		6'd43: begin
			ALU_op_o <= 3'b100;
			RegDst_o <= 2'b00;
			RegWrite_o <= 0;			
			Branch_o <= 0;
			ALUSrc_o <= 1;
			Jump_o <= 0;
			MemRead_o <= 0;
			MemWrite_o <= 1;
			MemtoReg_o <= 0;
			PctoReg_o <= 0;
		end
	endcase
//	$display("ALUOp in Decoder= ",ALU_op_o);
end

endmodule





                    
                    