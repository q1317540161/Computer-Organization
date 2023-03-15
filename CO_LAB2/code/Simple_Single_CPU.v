//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
	rst_i
	);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
wire [32-1:0] pc_cur, pc_next, pc_next0, pc_next1;
wire [32-1:0] Instruction, RSdata, RTdata, select_data, ALUresult, Extended, Shift;
wire RegDst, RegWrite, Branch, ALUSrc, Zero;
wire [3-1:0] ALUOp;
wire [4-1:0] ALUCtrl;
wire [5-1:0] select_addr;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_next) ,   
	    .pc_out_o(pc_cur) 
	    );
	
Adder Adder1(
        .src1_i(pc_cur),     
	.src2_i(32'd4),     
	.sum_o(pc_next0)    
	);
	
Instr_Memory IM(
        .pc_addr_i(pc_cur),  
	.instr_o(Instruction)    
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(Instruction[20:16]),
        .data1_i(Instruction[15:11]),
        .select_i(RegDst),
        .data_o(select_addr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(Instruction[25:21]) ,  
        .RTaddr_i(Instruction[20:16]) ,  
        .RDaddr_i(select_addr) ,  
        .RDdata_i(ALUresult)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
    .instr_op_i(Instruction[31:26]), 
	.RegWrite_o(RegWrite), 
	.ALU_op_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),   
	.Branch_o(Branch)   
	);

ALU_Ctrl AC(
        .funct_i(Instruction[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(Instruction[15:0]),
        .data_o(Extended)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(Extended),
        .select_i(ALUSrc),
        .data_o(select_data)
        );	
		
ALU ALU(
        .src1_i(RSdata),
	.src2_i(select_data),
	.ctrl_i(ALUCtrl),
	.result_o(ALUresult),
	.zero_o(Zero)
	);
		
Adder Adder2(
        .src1_i(pc_next0),     
	.src2_i(Shift),     
	.sum_o(pc_next1)      
	);
		
Shift_Left_Two_32 Shifter(
        .data_i(Extended),
        .data_o(Shift)
        ); 		

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_next0),
        .data1_i(pc_next1),
        .select_i(Zero & Branch),
        .data_o(pc_next)
        );	
endmodule
		  


