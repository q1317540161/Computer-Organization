//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o,
          JrCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
output             JrCtrl_o;
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg                JrCtrl_o;
//Parameter

//Select exact operation
wire r_format;

assign r_format = ~ALUOp_i[2] & ~ALUOp_i[1] & ~ALUOp_i[0];

always @(ALUOp_i or funct_i) begin
    ALUCtrl_o[3] <= 0;
    ALUCtrl_o[2] <= (r_format & funct_i[1]) | ALUOp_i[1] | ALUOp_i[0];
    ALUCtrl_o[1] <= (r_format & ~funct_i[2]) | ALUOp_i[2] | ALUOp_i[1];
    ALUCtrl_o[0] <= (r_format & (funct_i[3] | funct_i[0])) | ALUOp_i[0];
    JrCtrl_o <= r_format & ~funct_i[5] & funct_i[3];
//    $display("ALUOp= ", ALUOp_i);
//    $display("func= ", funct_i);
//    $display("ALUCtrl_o= ", ALUCtrl_o);
end

endmodule     





                    
                    