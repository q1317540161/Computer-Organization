//109550070
`timescale 1ns/1ps

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

wire    [32-1:0] result_arr;
wire    [32-1:0] cout_arr;
wire             set;

alu_top A0( .src1(src1[0]),
            .src2(src2[0]),
            .less(set),
            .A_invert(ALU_control[3]),
            .B_invert(ALU_control[2]), 
            .cin(ALU_control[1]&ALU_control[2]),  
            .operation(ALU_control[1:0]), 
            .result(result_arr[0]), 
            .cout(cout_arr[0]));  

genvar i;
for(i=1; i<=31; i = i+1)
    begin
    alu_top A1( .src1(src1[i]),
                .src2(src2[i]),
                .less(0),
                .A_invert(ALU_control[3]),
                .B_invert(ALU_control[2]), 
                .cin(cout_arr[i-1]),  
                .operation(ALU_control[1:0]), 
                .result(result_arr[i]), 
                .cout(cout_arr[i]));  
    end

assign set = (~src1[31] & ~src2[31] & ~cout_arr[30]) | (src1[31] & ~src2[31]) | (src1[31] & src2[31] & ~cout_arr[30]);

always@( posedge clk or negedge rst_n ) 
begin
	if(rst_n) begin
	  cout = 0;
	  overflow = 0;
	  zero = 0;
      if(ALU_control[1:0]==2'b10)
        begin
        cout = cout_arr[31];
        overflow = (~src1[31] & src2[31] & cout) | (src1[31] & ~src2[31] & ~cout);
        end
      result = result_arr;
      if(result == 0)
        begin
        zero = 1;
        end
	end
end

endmodule
