module PE(
    parameter ROW=0,//行坐标
    parameter COL=0,//列坐标
    input clk,
    input rst_n,
    input start,
    input in_valid,
    input [7:0] in_a,
    input [7:0] in_b,
    output reg [7:0] out_a,
    output reg [7:0] out_b,
    output reg [15:0] result,
    output reg result_valid,
);
    parameter t_clk=20;
//1.累加乘,输出延迟
    always @(posedge clk or negedge ret_n) begin
        if(!rst_n)
            result<=0;
        else if(start)
            if(in_valid)begin 
                result<=result+in_a*in_b;
                out_a<=#t_clk in_a;
                out_b<=#t_clk in_b;
            end
    end

//2.result_valid的设置---边沿检测器---将in_valid先延时一个周期，再检测
//2.1设置脉冲
    reg pulse;
    reg out_in_valid
    always @(posedge clk or negedge ret_n) begin
        if(in_valid)begin
            out_in_valid<=#t_clk in_valid;
            assign pulse=in_valid &~ out_in_valid;
        end
    end
//2.2对脉冲进行延时
    always @(posedge clk or negedge ret_n) begin
        if(!rst_n)
            result_valid<=0;
        else if(start)
            if(in_valid)begin 
                result_valid<=#(ROW+ROL+4)*t_clk pulse;
            end
    end
endmodule