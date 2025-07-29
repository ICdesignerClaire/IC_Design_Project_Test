module seq_detector(
    input clk,
    input rst_n,
    input din,
    output reg dout
);

//最小时间单位计数器
reg [21:0]cnt;
parameter MCNT=2_500_000;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)//低有效
        cnt<=0;
    else if(cnt==MCNT-1)
        cnt<=0;
    else
        cnt<=cnt+1'd1;
end

//不同的状态定义
reg [4:0] current_state,next_state;
parameter IDLE=5'b00001;
parameter S1=5'b00010;
parameter S11=5'b00100;
parameter S110=5'b01000;
parameter S1101=5'b10000;

//状态转移
always @(*) begin
    case (current_state)
        IDLE: next_state = (din) ? S1 : IDLE;
        S1: next_state = (din) ? IDLE : S11;
        S11: next_state = (din) ? S110 : IDLE;
        S110: next_state = (din) ? S1101 : IDLE;
        S1101: next_state = (din) ? S1 : IDLE;
    endcase
end

//时序更新
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        current_state<=IDLE;
    else if(cnt==MCNT-1)
        current_state<=next_state;//当已知当前状态时，下一时刻的状态由前述代码也已知，所以赋值是进行轮换进下一个状态
end

//输出检测，由于morre机，所以检测当前状态来输出
always @(*) begin
    if(current_state==S1101&&cnt==MCNT-1)
        dout<=1;
    else
        dout<=0;
end
endmodule