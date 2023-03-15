//109550070
`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] pc_cur, pc_next, pc_next0;
wire [32-1:0] Instruction;

//control signal
wire IF_PCWrite, IF_ID_Flush, IF_ID_PipeRegWrite;

/**** ID stage ****/
wire [32-1:0] ID_pc_next0, ID_Instr;
wire [32-1:0] ID_RSData, ID_RTData, ID_Extended;

//control signal
wire	ID_RegWrite, ID_MemtoReg,
        ID_Branch, ID_MemRead, ID_MemWrite,
        ID_ALUSrc, ID_RegDst;
wire [3-1:0] ID_ALUOp;
wire [2-1:0] ID_BranchInstr;
wire ID_EX_Flush;

/**** EX stage ****/
wire [32-1:0] EX_pc_next0, EX_pc_next1,
              EX_RSData, EX_RTData, EX_Extended,
              EX_Shifted, EX_ALUSrc1, EX_ALUSrc2,
              EX_ALUSrc2_tem,  EX_ALUResult;
wire [5-1:0]  EX_RSAddr, EX_RTAddr,
              EX_WriteReg, EX_WriteReg0, EX_WriteReg1;


//control signal
wire    EX_Zero, EX_Greater;
wire	EX_RegWrite, EX_MemtoReg,
        EX_Branch, EX_MemRead, EX_MemWrite,
        EX_ALUSrc, EX_RegDst;
wire [3-1:0] EX_ALUOp;
wire [4-1:0] EX_ALUCtrl;
wire [2-1:0] EX_BranchInstr,
             EX_ForwardA, EX_ForwardB;
wire EX_MEM_Flush;


/**** MEM stage ****/
wire [32-1:0] MEM_pc_next1;
wire [32-1:0] MEM_ALUResult, MEM_RTData, MEM_MEMData;
wire [5-1:0]  MEM_WriteReg;

//control signal
wire    MEM_Zero, MEM_Greater, MEM_BranchCheck;
wire	MEM_RegWrite, MEM_MemtoReg,
        MEM_Branch, MEM_MemRead, MEM_MemWrite;
wire [2-1:0] MEM_BranchInstr;

/**** WB stage ****/
wire [32-1:0] WB_MEMData, WB_ALUResult, WB_Data;
wire [5-1:0] WB_WriteReg;

//control signal
wire	WB_RegWrite, WB_MemtoReg;

/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
        .data0_i(pc_next0),
        .data1_i(MEM_pc_next1),
        .select_i(MEM_BranchCheck),
        .data_o(pc_next)
);

ProgramCounter PC(
        .clk_i(clk_i),      
	.rst_i (rst_i),
        .write_i(IF_PCWrite),     
	.pc_in_i(pc_next),   
	.pc_out_o(pc_cur) 
	);

Instruction_Memory IM(
        .addr_i(pc_cur),  
	.instr_o(Instruction)
);
			
Adder Add_pc_next0(
        .src1_i(pc_cur),
        .src2_i(32'd4),
        .sum_o(pc_next0)
);
		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .flush_i(IF_ID_Flush),
        .write_i(IF_ID_PipeRegWrite),
        .data_i({pc_next0, Instruction}),
        .data_o({ID_pc_next0, ID_Instr})
);

//Instantiate the components in ID stage
Hazard_Unit HZ(
        .IF_ID_RSAddr_i(ID_Instr[25:21]),
        .IF_ID_RTAddr_i(ID_Instr[20:16]),
        .ID_EX_RTAddr_i(EX_WriteReg0),
        .ID_EX_MemRead_i(EX_MemRead),
        .MEM_BranchCheck_i(MEM_BranchCheck),
        .IF_PCWrite_o(IF_PCWrite),
        .IF_ID_PipeRegWrite_o(IF_ID_PipeRegWrite),
        .IF_ID_Flush_o(IF_ID_Flush),
        .ID_EX_Flush_o(ID_EX_Flush),
        .EX_MEM_Flush_o(EX_MEM_Flush)
);

Reg_File RF(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .RSaddr_i(ID_Instr[25:21]),
        .RTaddr_i(ID_Instr[20:16]),
        .RDaddr_i(WB_WriteReg),
        .RDdata_i(WB_Data),
        .RegWrite_i(WB_RegWrite),
        .RSdata_o(ID_RSData),
        .RTdata_o(ID_RTData)
);

Decoder Control(
        .instr_op_i(ID_Instr[31:26]),
	    .RegWrite_o(ID_RegWrite),
	    .ALU_op_o(ID_ALUOp),
	    .ALUSrc_o(ID_ALUSrc),
	    .RegDst_o(ID_RegDst),
	    .Branch_o(ID_Branch),
            .BranchInstr_o(ID_BranchInstr),
	    .MemRead_o(ID_MemRead),
	    .MemWrite_o(ID_MemWrite),
	    .MemtoReg_o(ID_MemtoReg)
);

Sign_Extend Sign_Extend(
        .data_i(ID_Instr[15:0]),
        .data_o(ID_Extended)
);	

Pipe_Reg #(.size(160)) ID_EX(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .flush_i(ID_EX_Flush),
        .write_i(1'b1),
        .data_i({ID_RegWrite, ID_MemtoReg,
                 ID_Branch, ID_BranchInstr, ID_MemRead, ID_MemWrite,
                 ID_ALUOp, ID_RegDst, ID_ALUSrc,
                 ID_pc_next0, ID_Instr[25:21], ID_Instr[20:16], ID_RSData, ID_RTData,
                 ID_Extended, ID_Instr[20:16], ID_Instr[15:11]}),
        .data_o({EX_RegWrite, EX_MemtoReg,
                 EX_Branch, EX_BranchInstr, EX_MemRead, EX_MemWrite,
                 EX_ALUOp, EX_RegDst, EX_ALUSrc,
                 EX_pc_next0, EX_RSAddr, EX_RTAddr, EX_RSData, EX_RTData,
                 EX_Extended, EX_WriteReg0, EX_WriteReg1})
);

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
        .data_i(EX_Extended),
        .data_o(EX_Shifted)
);

ALU ALU(
        .src1_i(EX_ALUSrc1),
	.src2_i(EX_ALUSrc2),
	.ctrl_i(EX_ALUCtrl),
	.result_o(EX_ALUResult),
	.zero_o(EX_Zero),
    .greater_o(EX_Greater)
);
		
ALU_Ctrl ALU_Control(
        .funct_i(EX_Extended[5:0]),
        .ALUOp_i(EX_ALUOp),
        .ALUCtrl_o(EX_ALUCtrl)
);

Forwarding_Unit FW(
        .EX_RSAddr_i(EX_RSAddr),
        .EX_RTAddr_i(EX_RTAddr),
        .MEM_WriteReg_i(MEM_WriteReg),
        .MEM_RegWrite_i(MEM_RegWrite),
        .WB_WriteReg_i(WB_WriteReg),
        .WB_RegWrite_i(WB_RegWrite),
        .EX_ForwardA_o(EX_ForwardA),
        .EX_ForwardB_o(EX_ForwardB)
);

MUX_3to1 #(.size(32)) Mux1(
        .data00_i(EX_RSData),
        .data01_i(WB_Data),
        .data10_i(MEM_ALUResult),
        .select_i(EX_ForwardA),
        .data_o(EX_ALUSrc1)
);

MUX_3to1 #(.size(32)) Mux2(
        .data00_i(EX_RTData),
        .data01_i(WB_Data),
        .data10_i(MEM_ALUResult),
        .select_i(EX_ForwardB),
        .data_o(EX_ALUSrc2_tem)
);

MUX_2to1 #(.size(32)) Mux3(
        .data0_i(EX_ALUSrc2_tem),
        .data1_i(EX_Extended),
        .select_i(EX_ALUSrc),
        .data_o(EX_ALUSrc2)
);
		
MUX_2to1 #(.size(5)) Mux4(
        .data0_i(EX_WriteReg0),
        .data1_i(EX_WriteReg1),
        .select_i(EX_RegDst),
        .data_o(EX_WriteReg)
);

Adder Add_pc_branch(
        .src1_i(EX_pc_next0),
        .src2_i(EX_Shifted),
        .sum_o(EX_pc_next1)
);

Pipe_Reg #(.size(110)) EX_MEM(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .flush_i(EX_MEM_Flush),
        .write_i(1'b1),
        .data_i({EX_RegWrite, EX_MemtoReg,
                 EX_Branch, EX_BranchInstr, EX_MemRead, EX_MemWrite,
                 EX_pc_next1, EX_Zero, EX_Greater, EX_ALUResult,
                 EX_ALUSrc2_tem, EX_WriteReg}),
        .data_o({MEM_RegWrite, MEM_MemtoReg,
                 MEM_Branch, MEM_BranchInstr, MEM_MemRead, MEM_MemWrite,
                 MEM_pc_next1, MEM_Zero, MEM_Greater, MEM_ALUResult,
                 MEM_RTData, MEM_WriteReg})
);

//Instantiate the components in MEM stage
MUX_4to1 Branch(
        .data00_i(MEM_Branch & (MEM_Greater | MEM_Zero)),
        .data01_i(MEM_Branch & MEM_Zero),
        .data10_i(MEM_Branch & ~MEM_Zero),
        .data11_i(MEM_Branch & MEM_Greater),
        .select_i(MEM_BranchInstr),
        .data_o(MEM_BranchCheck)
);

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(MEM_ALUResult),
        .data_i(MEM_RTData),
        .MemRead_i(MEM_MemRead),
        .MemWrite_i(MEM_MemWrite),
        .data_o(MEM_MEMData)
);

Pipe_Reg #(.size(72)) MEM_WB(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .flush_i(1'b0),
        .write_i(1'b1),
        .data_i({MEM_RegWrite, MEM_MemtoReg,
                 MEM_MEMData, MEM_ALUResult, MEM_WriteReg}),
        .data_o({WB_RegWrite, WB_MemtoReg,
                 WB_MEMData, WB_ALUResult, WB_WriteReg})
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux5(
        .data0_i(WB_ALUResult),
        .data1_i(WB_MEMData),
        .select_i(WB_MemtoReg),
        .data_o(WB_Data)
);

/****************************************
signal assignment
****************************************/

endmodule

