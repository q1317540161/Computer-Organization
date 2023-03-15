//Subject:     CO project 3 - MUX 221
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/17
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module MUX_3to1(
               data00_i,
               data01_i,
               data10_i,
               select1_i,
               select2_i,
               data_o
               );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data00_i;          
input   [size-1:0] data01_i;
input   [size-1:0] data10_i;
input              select1_i;
input              select2_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function

always @(*) begin
    case({select2_i, select1_i})
        2'b00: data_o <= data00_i;
        2'b01: data_o <= data01_i;
        2'b10: data_o <= data10_i;
    endcase

end

endmodule      
          
          