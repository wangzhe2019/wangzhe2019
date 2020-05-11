module out_neuron(
	input 	clk,
	input		rst_n,
	input		learn,
	input		inhibition,//横向抑制信号
	input		[24:0]weight_up,
	input		[24:0]weight_down,
	
	output	reg spike,
	output	reg out_inhi,
	output	post
);
reg		out_post;
reg  		[5:0]weight;
reg 		[11:0]sum_weight;
reg 		[11:0]out_weight;
reg 		[7:0]cnt1;
reg 		[11:0]cnt2;
reg 		[9:0]symbol;
reg		learn1;//边沿检测辅助信号
reg		learn_edge;
wire		post_one;

assign post = (out_post == 1'b1)?out_post:1'b0;
//权重的缓存
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		weight <= 6'd1;
	else if(out_post == 1'b1 && weight < 6'd31)
		weight <= weight + weight;
end 
//对膜电位信号累加求和处理
always@(posedge clk or negedge rst_n)//learn使能端边沿检测
begin
	if(!rst_n)
		learn1 <= 1'b0;
	else
		learn1 <= learn;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		learn_edge <= 1'b0;
	else if(learn1 == 1'b1 && learn == 1'b0)
		learn_edge <= 1'b1;
	else
		learn_edge <= 1'b0;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		sum_weight <= 12'd400;
	else if(inhibition == 1'b1 && out_inhi == 1'b1)
		sum_weight <= sum_weight - 12'd5;
	else if(inhibition == 1'b1)//抑制信号对输出脉冲频率的处理（重要信号）
		sum_weight <= sum_weight - 12'd75;
	else if(sum_weight < 12'd80 || cnt2 == 12'd671 || learn_edge == 1'b1)
		sum_weight <= 12'd400;
	else if(cnt2 < 12'd671 && cnt2 > 12'd331 && learn == 1'b0)
		sum_weight <= sum_weight;
	else if(weight_up > 25'd0)
		sum_weight <= sum_weight + weight;
	else if(weight_down > 25'd0 && weight > 1'b1)
		sum_weight <= sum_weight - weight;
	else
		sum_weight <= sum_weight;
end
//1、起到保护作用，防止膜电位一直抑制下去；
//2、学习阶段，检测到learn使能端下降沿的变化时将膜电位归为初始化膜电位，防止对后续膜电位的影响
//3、测试阶段，定时将膜电位归为初始膜电位，防止此时的膜电位对后续膜电位的影响
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt2 <= 12'd0;
	else if(cnt2 == 12'd671)
		cnt2 <= 12'd0;
	else 
		cnt2 <= cnt2 + 12'd1;
end
//对输出脉冲的处理
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		symbol <= 10'd0;
	else if(sum_weight > 12'd752)
		symbol <= 10'd3;
	else
		symbol <= (10'd800 - sum_weight)>>4;	
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
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		spike <= 1'b0;
	else if(cnt1 == 8'd2) 
		spike <= 1'b1;
	else 
		spike <= 1'b0;
end
//输出膜电位的过程
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out_weight <= 12'd0;
	else if(weight_down > 25'd0 || weight_up > 25'd0)
		out_weight <= sum_weight;
	else
		out_weight <= 12'd400;
end
//先起到抑制作用
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out_inhi <= 1'b0;
	else if((out_weight == 12'd410&&learn == 1'b1)||out_weight == 12'd720||out_weight >= 12'd816)
		out_inhi <= 1'b1;
	else
		out_inhi <= 1'b0;
end
//后发送突触后脉冲(依据输出膜电位)
assign post_one = ((out_weight >= 12'd411&& out_weight < 'd440)&&cnt2 > 12'd331)?1:0;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out_post <= 1'b0;
	else if((post_one == 1'b1||((cnt2 == 12'd670||cnt2 == 12'd669)&&weight>6'd1))&&learn == 1'b1)
		out_post <= 1'b1;
	else 
		out_post <= 1'b0;
end
endmodule
