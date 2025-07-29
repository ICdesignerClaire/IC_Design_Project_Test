module systolic_array(
    input clk,
    input rst_n,
    input start,
    input in_valid,
    input [7:0]a_in0, a_in1, a_in2, a_in3,
    input [7:0]b_in0, b_in1, b_in2, b_in3,
    output [15:0] c_out[0:3][0:3],
    output reg done
);
//对于a_in的输入延迟不用管，这部分是input_ctrl的职能

//逆化pe_final模块,仅以pe00为例
wire pe_done[0:3][0:3];
pe_final
#(  parameter ROW=0,//行坐标
parameter COL=0)//列坐标//这样不容易报错
pe_finalinst0
(
. clk(clk),
. rst_n(rst_n),
. start(start),
. in_valid(in_valid),
. in_a(in_a0),
. in_b(in_b0),
//. out_a(),//这里没有什么用处，直接隐掉
//. out_b(),
. result(c_out[0][0]),
. result_valid(pe_done[0][0])//可以用于判断最终的done是否实现，但是需要一个矩阵用于赋值
); 

//对于pe00可实现，那么继续就是利用for循环实现所有的pe_ij
genvar i,j;
generate
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1)begin
            pe_final
            #(  parameter ROW=i,//行坐标
            parameter COL=j)//列坐标//这样不容易报错
            pe_finalinst0
            (
            . clk(clk),
            . rst_n(rst_n),
            . start(start),
            . in_valid(in_valid),
            . in_a(in_ai),
            . in_b(in_bj),
            //. out_a(),//这里没有什么用处，直接隐掉
            //. out_b(),
            . result(c_out[i][j]),
            . result_valid(pe_done[i][j])//可以用于判断最终的done是否实现，但是需要一个矩阵用于赋值
            );  
        end
    end
endgenerate

//处理完pe_done矩阵之后，对done数值进行提取
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        done<=0;
    else if(start)begin
        if(in_valid)
            done<=pe_done[3][3]; 
    end
end

endmodule