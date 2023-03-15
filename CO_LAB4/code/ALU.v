//109550070
//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg             zero_o;

//Parameter

//Main function
always @(ctrl_i or src1_i or src2_i) begin
	case(ctrl_i)
	    4'b0000: result_o = src1_i & src2_i;
	    4'b0001: result_o = src1_i | src2_i;
		4'b0010: result_o = src1_i + src2_i;
		4'b0011: result_o = src1_i * src2_i;
		4'b0110: result_o = src1_i - src2_i;
		4'b0111:
		begin
			if(src1_i < src2_i) result_o = 1;
			else result_o = 0;
		end
		default: result_o = 0;
	endcase
	if(result_o==0) zero_o = 1;
	else zero_o = 0;
//	$display("ctrl: ", ctrl_i, " sr1: ", src1_i, " src2: ", src2_i, " result: ", result_o);
end

endmodule





                    
                    