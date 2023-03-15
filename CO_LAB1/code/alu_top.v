//109550070 
`timescale 1ns/1ps

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [1:0] operation;

output        result;
output        cout;

reg           result, cout;

wire src1_temp, src2_temp;

xor(src1_temp, src1, A_invert);
xor(src2_temp, src2, B_invert);

always@(*)
begin
    if(operation==2'b00)
        begin
        result <= src1_temp & src2_temp;
        cout <= 0;
        end
    else if(operation == 2'b01)
        begin
        result <= src1_temp | src2_temp;
        cout <= 0;
        end
    else if(operation == 2'b10)
        begin
        result <= src1_temp ^ src2_temp ^ cin;
        cout <= (src1_temp & src2_temp) | (cin & src1_temp) | (cin & src2_temp);
        end
    else 
        begin
        result <= less;
        cout <= (src1_temp & src2_temp) | (cin & src1_temp) | (cin & src2_temp);
        end
end

endmodule
