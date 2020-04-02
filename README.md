module out_neuron(
	input 	clk,
	input		rst_n,
	input		learn,
	input		inhibition,//横向抑制信号
	
	output	spike,
	output	reg out_inhibition,
	
	output reg  b_pready,
	input b_psel,
	input b_penable,
	input [8:0]in_weight
);
reg  [8:0]weight;
wire [8:0]deal_weight;
reg [9:0]sum_weight;
reg [9:0]out_weight;
reg [7:0]cnt1;
reg [7:0]cnt2;
reg [7:0]cnt4;
//reg [7:0]cnt3;
reg [11:0]symbol;
//reg [7:0]M;

assign deal_weight = (weight >= 9'd256)?(~weight + 9'd1):weight;
//对膜电位信号累加求和处理
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sum_weight <= 10'd400;
	else if(inhibition == 1'b1)//抑制信号对输出脉冲频率的处理（重要信号）
		sum_weight <= sum_weight - 10'd25;
	else if(sum_weight < 10'd300 || cnt2 == 8'd207)
		sum_weight <= 10'd400;
	//1、起到保护作用，防止膜电位一直抑制下去；
	//2、学习阶段
	//3、测试阶段，定时将膜电位归为初始膜电位，防止此时的膜电位对后续膜电位的影响
	else if(weight >= 9'd0 && weight < 9'd256)
		sum_weight <= sum_weight + weight;
	else if(weight >= 9'd256)
		sum_weight <= sum_weight - deal_weight;
	else
		sum_weight <= sum_weight;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt2 <= 8'd0;
	else if(cnt2 < 8'd207 && learn == 1'b0)
		cnt2 <= cnt2 + 8'd1;
	else 
		cnt2 <= 8'd0;
end
//对输出脉冲的处理
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		symbol <= 12'd0;
	else
		symbol <= (12'd800 - sum_weight)>>5;	
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt1 <= 8'd0;
	else if(cnt1 < symbol)
		cnt1 <= cnt1 + 8'd1;
	else 
		cnt1 <= 8'd0;
end
assign spike = (cnt1 == 8'd2)?1:0;
//膜电位的衰减过程处理
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out_weight <= 10'd0;
	else if(weight != 9'd0)
		out_weight <= sum_weight;
	else if(sum_weight > 10'd450 || sum_weight < 10'd300)
		out_weight <= 10'd400;
	else
		out_weight <= out_weight;
end
//对输出抑制信号的处理(依据输出膜电位)
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out_inhibition = 1'b0;
	else if(out_weight > 10'd450 && learn == 1'b1)
		out_inhibition = 1'b1;
	else 
		out_inhibition = 1'b0;
end
//总线控制
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		weight <= 9'd0;
	else if(b_pready == 1'b1)
		weight <= in_weight;
	else 
		weight <= 9'd0;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		b_pready <= 1'b0;
	else if(cnt4 == 8'd10)
		b_pready <= 1'b1;
	else
		b_pready <= 1'b0;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt4 <= 8'd0;
	else if(b_psel == 1'b1 && b_penable == 1'b0)
		cnt4 <= 8'd0;
	else
		cnt4 <= cnt4 + 1'b1;
end
endmodule
