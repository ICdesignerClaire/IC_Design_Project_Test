module double_ram #(
    parameter DEPTH = 16,
    parameter WIDTH = 8,
    parameter ADDR_WIDTH = 4
) (
    //
    input clk_a,
    input clk_b,
    input rst_n,

    //
    input cs_a,
    input cs_b,
    input wr_en,
    input rd_en,
    //
    input [WIDTH-1 : 0] wr_data,
    input [ADDR_WIDTH-1:0] wr_addr,
    input [ADDR_WIDTH-1:0] rd_addr,

    output reg [WIDTH-1 : 0] rd_data
);
    
//reg and wire
reg [WIDTH-1 : 0] mem [0 : DEPTH-1];


//
integer i;
always@(posedge clk_a or negedge rst_n)begin
    if(!rst_n)begin
        for(i=0;i<DEPTH;i=i+1)
            mem[i] <= 'b0 ;    
    end
    else if (cs_a &  wr_en) begin
        mem[wr_addr] <= wr_data;  
    end

end


always@(posedge clk_b or negedge rst_n)begin
    if(!rst_n)begin
        rd_data <= 'b0;
        for(i=0;i<DEPTH;i=i+1)
            mem[i] <= 'b0   ;
    end
    else if (cs_b &  rd_en) begin
        rd_data <= mem[rd_addr];  
    end
    else
        rd_data <= rd_data;

end



endmodule
