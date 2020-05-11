module synapsis(
	input 	clk,
	input 	rst_n,
	input		learn,
	input		pre,   					//突触前脉冲
	input    random_weight,  		//突触随机信号
	input		post_in,					//突触后脉冲
	
	output	weight_up,
	output	weight_down
);

reg  		[5:0]current_state; 
reg  		[5:0]next_state; 
reg		post_in1;
reg		post_in2;
reg		up;
reg		down;
reg		[7:0]cnt;
localparam
		S0 = 6'b000001, //初始化状态，突触现处于没有起作用的状态（突触在这一阶段随机化）
		S1 = 6'b000010, //模式输入状态，通过竞争进入下一个存储模式的状态
		S2 = 6'b000100, //输出神经元先被激活，这一突触已经存储为0
		S3 = 6'b001000, //输出神经元先被激活，这一突触已经存储为1
		S4 = 6'b010000, //判断条件为1时，突触权重输出0，保证其他模型的其他突触的竞争学习
		S5 = 6'b100000;

assign weight_up = (pre == 1'b1)?up:1'b0;
assign weight_down = (pre == 1'b1)?down:1'b0;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		post_in1 <= 1'b0;
		post_in2 <= 1'b0;
	end
	else begin
		post_in1 <= post_in;
		post_in2 <= post_in1;
	end
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt <= 8'd0;
	else if(cnt >= 8'd2)
		cnt <= 8'd2;
	else if(post_in == 1'b1)
		cnt <= cnt + 1'b1;
	else
		cnt <= 8'd0;
end
//定义一个三段式状态机，判断突触处于哪个阶段
always@(posedge clk or negedge rst_n)//第一段：同步时序描述状态转移
begin                  
	if(!rst_n)
		  current_state <= S0;
	else
		  current_state <= next_state;
end

always@(*)//第二段：组合逻辑判断状态转移条件
begin
	next_state = S0;
	case(current_state)
		S0:begin //在没有输入突触的前神经元脉冲，而输入后神经元脉冲，设定此时存储的模型为0值模型
			if(post_in2 == 1'b1 && learn == 1)
				next_state = S2;
			else if(pre == 1'b1)
				next_state = S1;
			else
				next_state = S0;
		end
		S1:begin
			if(post_in2 == 1'b1 && learn == 1)
				next_state = S3;
			else if(learn == 1'b0)
				next_state = S0;
			else
				next_state = S1;
		end
		S2:begin
			if(learn == 1&&cnt == 8'd2)//标志位的判断，如果标志位为高的时候证明有新的模式需要学习，否则保持
				next_state = S4;
			else
				next_state = S2;
		end
		S3:begin
			if(learn == 1&&cnt == 8'd2)//标志位的判断，如果标志位为高的时候证明有新的模式需要学习，否则保持
				next_state = S5;
			else
				next_state = S3;
		end
		S4:begin
			if(learn == 0)
				next_state = S2;
			else
				next_state = S4;
		end
		S5:begin
			if(learn == 0)
				next_state = S3;
			else
				next_state = S5;
		end
		default:next_state = S0;
	endcase
end
always@(posedge clk or negedge rst_n)////时序电路描述状态输出
begin
	if(!rst_n)begin
		up <= 1'b0;
		down <= 1'b0;
	end
	else begin
		case(current_state)
			S0:up <= random_weight;
			S1:up <= random_weight;
			S2:begin
				up <= 1'b0;
				down <= 1'b1;
			end
			S3:begin
				up <= 1'b1;
				down <= 1'b0;
			end
			S4:begin
				down <= 1'b0;
				up <= 1'b0;
			end
			S5:begin
				down <= 1'b0;
				up <= 1'b0;
			end
		endcase
	end
end
endmodule
