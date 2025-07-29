module PE_new
#(  parameter ROW=0,//行坐标
    parameter COL=0)//列坐标//这样不容易报错
 (
    input clk,
    input rst_n,
    input start,
    input in_valid,
    input [7:0] in_a,
    input [7:0] in_b,
    output reg [7:0] out_a,
    output reg [7:0] out_b,
    output reg [15:0] result,
    output reg result_valid
); 

//1.实现in_a及in_b的延迟1clk输出
//设置寄存器reg out_a,out_b,理论上可以直接延缓一个clk
//但是，在设计testbench时需要在in_valid后进行一定延时输入，错位会影响result的结果
//所以直接在中间再添加一个reg寄存器，可无需延时输入，直接延时1clk
reg [7:0] a,b;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
        begin
            out_a<=0;
            out_b<=0;
            a<=0;
            b<=0;
        end
        else if(start)
            if(in_valid)begin 
                a<=in_a;
                b<=in_b;
                out_a<=a;
                out_b<=b;            
            end
    end

//2.累加乘
//（1）即时计算
    reg [15:0]accumlator;
   always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
        begin
            accumulator<=0;
        end
        else if(start)
            if(in_valid)begin 
                accumulator<=accumulator+in_a*in_b;           
            end
    end
       

//3.延时处理result_valid
//（1）延时计数器
    reg [3:0]delay_cnt;//如果以最后一个模块为准，PE_16计算完成应该是第10个周期，那么输出result_valid应该是第11个周期
    always @(posedge clk or negedge rest_n) begin
        if(!rst_n)
        begin
            delay_cnt<=0;
        end
        else if(start)
            if(in_valid)begin 
                delay_cnt<=delay_cnt+1'd1;          
            end        
    end
//(2)在对应延时时间锁存结果
        always @(posedge clk or negedge rest_n) begin
        if(!rst_n)
        begin
            result<=0;
            result_valid<=0;
        end
        else if(start)
            if(in_valid)begin 
                if(delay_cnt==ROW+COL+4)begin
                    result<=accumulator;
                    result_valid<=1;
                end
            end        
    end
endmodule