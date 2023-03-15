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
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_cur, pc_select, pc_next, pc_next00, pc_next01, pc_next10;
wire [32-1:0] Instruction, RSData, RTData, select_ALUSrc, ALUResult;
wire [32-1:0] Extended, Shift, select_WriteData, MemData;
wire [5-1:0]  select_WriteAddr;
wire [3-1:0]  ALUOp;
wire [2-1:0]  RegDst;
wire          RegWrite, Branch, ALUSrc, Zero, Jump, MemRead, MemWrite, MemtoReg, PctoReg;
wire [4-1:0]  ALUCtrl;
wire          JrCtrl;

//Create componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_select),   
	    .pc_out_o(pc_cur) 
	    );

MUX_2to1 #(.size(32)) Mux_PcSrc2(
        .data0_i(pc_next),
        .data1_i(RSData),
        .select_i(JrCtrl),
        .data_o(pc_select)
        );
//always @(pc_select) begin
//    $display("pc_next= ", pc_next);
//    $display("pc_jr= ", RSData);
//    $display("pc_select= ", pc_select);
//end
	
Adder Adder_pc_next00(
    .src1_i(pc_cur),     
	.src2_i(32'd4),     
	.sum_o(pc_next00)    
	);

assign pc_next10 = {pc_cur[31:28], Instruction[25:0], 2'b00};
	
Instr_Memory IM(
        .pc_addr_i(pc_cur),  
	.instr_o(Instruction)    
	);

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data00_i(Instruction[20:16]),
        .data01_i(Instruction[15:11]),
        .data10_i(5'd31),
        .select1_i(RegDst[0]),
        .select2_i(RegDst[1]),
        .data_o(select_WriteAddr)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(Instruction[25:21]),  
        .RTaddr_i(Instruction[20:16]),  
        .RDaddr_i(select_WriteAddr),  
        .RDdata_i(select_WriteData), 
        .RegWrite_i(RegWrite & ~JrCtrl),
        .RSdata_o(RSData),  
        .RTdata_o(RTData)   
        );
	
Decoder Decoder(
    .instr_op_i(Instruction[31:26]), 
	.RegWrite_o(RegWrite), 
	.ALU_op_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),   
	.Branch_o(Branch),  
    .Jump_o(Jump),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.MemtoReg_o(MemtoReg),
	.PctoReg_o(PctoReg)
	);

ALU_Ctrl AC(
        .funct_i(Instruction[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl),
        .JrCtrl_o(JrCtrl)
        );
	
Sign_Extend SE(
        .data_i(Instruction[15:0]),
        .data_o(Extended)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTData),
        .data1_i(Extended),
        .select_i(ALUSrc),
        .data_o(select_ALUSrc)
        );	
		
ALU ALU(
    .src1_i(RSData),
	.src2_i(select_ALUSrc),
	.ctrl_i(ALUCtrl),
	.result_o(ALUResult),
	.zero_o(Zero)
	);
	
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALUResult),
	.data_i(RTData),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(MemData)
	);
	
Adder Adder_pc_next01(
        .src1_i(pc_next00),     
	.src2_i(Shift),     
	.sum_o(pc_next01)      
	);
		
Shift_Left_Two_32 Shifter_branch(
        .data_i(Extended),
        .data_o(Shift)
        ); 		
		
MUX_3to1 #(.size(32)) Mux_PcSrc1(
        .data00_i(pc_next00),
        .data01_i(pc_next01),
        .data10_i(pc_next10),
        .select1_i(Branch&Zero),
        .select2_i(Jump),
        .data_o(pc_next)
        );

MUX_3to1 #(.size(32)) Mux_Data_Write_Reg(
        .data00_i(ALUResult),
        .data01_i(MemData),
        .data10_i(pc_next00),
        .select1_i(MemtoReg),
        .select2_i(PctoReg),
        .data_o(select_WriteData)
        );	

endmodule
		  


