//109550070
module Hazard_Unit(
    IF_ID_RSAddr_i,
    IF_ID_RTAddr_i,
    ID_EX_RTAddr_i,
    ID_EX_MemRead_i,
    MEM_BranchCheck_i,
    IF_PCWrite_o,
    IF_ID_PipeRegWrite_o,
    IF_ID_Flush_o,
    ID_EX_Flush_o,
    EX_MEM_Flush_o
    );

input [5-1:0] IF_ID_RSAddr_i, IF_ID_RTAddr_i, ID_EX_RTAddr_i;
input         ID_EX_MemRead_i, MEM_BranchCheck_i;
output        IF_PCWrite_o, IF_ID_PipeRegWrite_o,
              IF_ID_Flush_o, ID_EX_Flush_o, EX_MEM_Flush_o;

reg IF_PCWrite_o, IF_ID_PipeRegWrite_o,
    IF_ID_Flush_o, ID_EX_Flush_o, EX_MEM_Flush_o;

always @(*) begin
    //Branch Hazard
    if(MEM_BranchCheck_i) begin
        IF_PCWrite_o <= 1;
        IF_ID_PipeRegWrite_o <= 1;
        IF_ID_Flush_o <= 1;
        ID_EX_Flush_o <= 1;
        EX_MEM_Flush_o <= 1;

//        $display("branch hazard");
//        $display("RS addr: ", IF_ID_RSAddr_i);
//        $display("RT addr: ", IF_ID_RTAddr_i);

    end
    //Load-Use Hazard
    else if(ID_EX_MemRead_i &
       ((ID_EX_RTAddr_i == IF_ID_RSAddr_i) |
        (ID_EX_RTAddr_i == IF_ID_RTAddr_i)))
    begin
        IF_PCWrite_o <= 0;
        IF_ID_PipeRegWrite_o <= 0;
        IF_ID_Flush_o <= 0;
        ID_EX_Flush_o <= 1;
        EX_MEM_Flush_o <= 0;
        
//        $display("load-use  hazard");
//        $display("RS addr: ", IF_ID_RSAddr_i);
//        $display("RT addr: ", IF_ID_RTAddr_i);
//        $display("RD addr: ", ID_EX_RTAddr_i);
    end
    else begin
        IF_PCWrite_o <= 1;
        IF_ID_PipeRegWrite_o <= 1;
        IF_ID_Flush_o <= 0;
        ID_EX_Flush_o <= 0;
        EX_MEM_Flush_o <= 0;
    end
    
end            

endmodule