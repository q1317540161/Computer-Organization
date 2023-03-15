//109550070
module Forwarding_Unit(
        EX_RSAddr_i,
        EX_RTAddr_i,
        MEM_WriteReg_i,
        MEM_RegWrite_i,
        WB_WriteReg_i,
        WB_RegWrite_i,
        EX_ForwardA_o,
        EX_ForwardB_o
    );

input [5-1:0]  EX_RSAddr_i, EX_RTAddr_i,
               MEM_WriteReg_i, WB_WriteReg_i;
input MEM_RegWrite_i, WB_RegWrite_i;
output [2-1:0] EX_ForwardA_o, EX_ForwardB_o;

reg [2-1:0] EX_ForwardA_o, EX_ForwardB_o;

always@(*) begin
    if(MEM_RegWrite_i & (MEM_WriteReg_i==EX_RSAddr_i)
       & (MEM_WriteReg_i != 5'd0))
       EX_ForwardA_o <= 10;
    else if (WB_RegWrite_i & (WB_WriteReg_i==EX_RSAddr_i)
             & (WB_WriteReg_i != 5'd0))
        EX_ForwardA_o <= 01;
    else EX_ForwardA_o <= 00;

    if(MEM_RegWrite_i & (MEM_WriteReg_i==EX_RTAddr_i)
       & (MEM_WriteReg_i != 5'd0))
       EX_ForwardB_o <= 10;
    else if (WB_RegWrite_i & (WB_WriteReg_i==EX_RTAddr_i)
             & (WB_WriteReg_i != 5'd0))
        EX_ForwardB_o <= 01;
    else EX_ForwardB_o <= 00;
end

endmodule