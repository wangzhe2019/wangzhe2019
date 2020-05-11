module new_cache(
	input		clk,
	input		rst_n,
	input		[3:0]in_cnt,//输入模型
	input		[24:0]random_model,
	input		learn,
	
	output reg output_model1,
	output reg output_model2,
	output reg output_model3,
	output reg output_model4,
	output reg output_model5,
	output reg output_model6,
	output reg output_model7,
	output reg output_model8,
	output reg output_model9,
	output reg output_model10,
	output reg output_model11,
	output reg output_model12,
	output reg output_model13,
	output reg output_model14,
	output reg output_model15,
	output reg output_model16,
	output reg output_model17,
	output reg output_model18,
	output reg output_model19,
	output reg output_model20,
	output reg output_model21,
	output reg output_model22,
	output reg output_model23,
	output reg output_model24,
	output reg output_model25
);
parameter tt = 5;
reg	[3:0]cnt1;
reg	[7:0]cnt2;//写时钟计数
wire	[3:0]cnt3;
reg	[7:0]cnt5;
reg	clk_s;
reg	[24:0]store;
reg	[24:0]infor_cache;

//慢时钟信号的定义
always@(posedge clk or negedge rst_n)//写入时钟控制
begin
	if(!rst_n)
		cnt2 <= 8'd0;
	else if(cnt2 == tt)
		cnt2 <= 8'd0;
	else 
		cnt2 <= cnt2 + 8'd1;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		clk_s <= 1'b0;
	else if(cnt2 == tt)
		clk_s <= ~clk_s;
	else
		clk_s <= clk_s;
end
//模式0-9的存储
always@(posedge learn or negedge rst_n)
begin
	if(!rst_n)
		cnt1 <= 4'd0;
	else if(cnt1 > 4'd10)
		cnt1 <= 4'd11;
	else if(cnt1 <= 4'd11)
		cnt1 <= cnt1 + 4'd1;
	else 
		cnt1 <= cnt1;
end
//输入需要识别的有效数字cnt3时
assign cnt3 = ((cnt1 > 4'd10)|| (in_cnt != 4'd11))?in_cnt:cnt1;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		store <= 25'd0;
	else
		case(cnt3)
			10:store <= 25'b00100_01010_01010_01010_00100;
			1:store <= 25'b00100_01100_00100_00100_01110;
			2:store <= 25'b01100_10010_00100_01000_11111;
			3:store <= 25'b01100_00010_00100_00010_01100;
			4:store <= 25'b00010_00110_01010_11111_00010;
			5:store <= 25'b01110_01000_01100_00010_01100;
			6:store <= 25'b00100_01000_01100_01010_00100;
			7:store <= 25'b11110_00010_00100_01000_01000;
			8:store <= 25'b00100_01010_00100_01010_00100;
			9:store <= 25'b00100_01010_00110_00010_00010;
		endcase
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		infor_cache <= 25'd0;
	else if(learn == 1'b1||in_cnt != 4'd11)
		infor_cache <= store;
	else 
		infor_cache <= random_model;	
end
//发送一幅图的像素点值
always@(posedge clk_s or negedge rst_n)
begin
	if(!rst_n)
		cnt5 <= 8'd0;
	else if(cnt5 == 8'd27)
		cnt5 <= 8'd0;
	else
		cnt5 <= cnt5 + 8'd1;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		output_model1	<=	1'b0;
		output_model2	<=	1'b0;
		output_model3	<=	1'b0;
		output_model4	<=	1'b0;
		output_model5	<=	1'b0;
		output_model6	<=	1'b0;
		output_model7	<=	1'b0;
		output_model8	<=	1'b0;
		output_model9	<=	1'b0;
		output_model10	<=	1'b0;
		output_model11	<=	1'b0;
		output_model12	<=	1'b0;
		output_model13	<=	1'b0;
		output_model14	<=	1'b0;
		output_model15	<=	1'b0;
		output_model16	<=	1'b0;
		output_model17	<=	1'b0;
		output_model18	<=	1'b0;
		output_model19	<=	1'b0;
		output_model20	<=	1'b0;
		output_model21	<=	1'b0;
		output_model22	<=	1'b0;
		output_model23	<=	1'b0;
		output_model24	<=	1'b0;
		output_model25	<=	1'b0;
	end
	else begin
		case(cnt5)
			2:output_model1	<=	infor_cache[0];
			3:begin
				output_model1	<=	1'b0;
				output_model2	<=	infor_cache[1];
			  end
			4:begin
				output_model2	<=	1'b0;
				output_model3	<=	infor_cache[2];
			  end
			5:begin
				output_model3	<=	1'b0;
				output_model4	<=	infor_cache[3];
			  end
			6:begin
				output_model4	<=	1'b0;
				output_model5	<=	infor_cache[4];
			  end
			7:begin
				output_model5	<=	1'b0;
				output_model6	<=	infor_cache[5];
			  end
			8:begin
				output_model6	<=	1'b0;
				output_model7	<=	infor_cache[6];
			  end
			9:begin
				output_model7	<=	1'b0;
				output_model8	<=	infor_cache[7];
			  end
			10:begin
				output_model8	<=	1'b0;
				output_model9	<=	infor_cache[8];
			  end
			11:begin
				output_model9	<=	1'b0;
				output_model10	<=	infor_cache[9];
			  end
			12:begin
				output_model10	<=	1'b0;
				output_model11	<=	infor_cache[10];
			  end
			13:begin
				output_model11	<=	1'b0;
				output_model12	<=	infor_cache[11];
			  end
			14:begin
				output_model12	<=	1'b0;
				output_model13	<=	infor_cache[12];
			  end
			15:begin
				output_model13	<=	1'b0;
				output_model14	<=	infor_cache[13];
			  end
			16:begin
				output_model14	<=	1'b0;
				output_model15	<=	infor_cache[14];
			  end
			17:begin
				output_model15	<=	1'b0;
				output_model16	<=	infor_cache[15];
			  end
			18:begin
				output_model16	<=	1'b0;
				output_model17	<=	infor_cache[16];
			  end
			19:begin
				output_model17	<=	1'b0;
				output_model18	<=	infor_cache[17];
			  end
			20:begin
				output_model18	<=	1'b0;
				output_model19	<=	infor_cache[18];
			  end
		   21:begin
				output_model19	<=	1'b0;
				output_model20	<=	infor_cache[19];
			  end
		   22:begin
				output_model20	<=	1'b0;
				output_model21	<=	infor_cache[20];
			  end
			23:begin
				output_model21	<=	1'b0;
				output_model22	<=	infor_cache[21];
			  end
		   24:begin
				output_model22	<=	1'b0;
				output_model23	<=	infor_cache[22];
			  end
			25:begin
				output_model23	<=	1'b0;
				output_model24	<=	infor_cache[23];
			  end
		   26:begin
				output_model24	<=	1'b0;
				output_model25	<=	infor_cache[24];
			  end
		   27:output_model25	<=	1'b0;
			default:
				begin
					output_model1	<=	1'b0;
					output_model2	<=	1'b0;
					output_model3	<=	1'b0;
					output_model4	<=	1'b0;
					output_model5	<=	1'b0;
					output_model6	<=	1'b0;
					output_model7	<=	1'b0;
					output_model8	<=	1'b0;
					output_model9	<=	1'b0;
					output_model10	<=	1'b0;
					output_model11	<=	1'b0;
					output_model12	<=	1'b0;
					output_model13	<=	1'b0;
					output_model14	<=	1'b0;
					output_model15	<=	1'b0;
					output_model16	<=	1'b0;
					output_model17	<=	1'b0;
					output_model18	<=	1'b0;
					output_model19	<=	1'b0;
					output_model20	<=	1'b0;
					output_model21	<=	1'b0;
					output_model22	<=	1'b0;
					output_model23	<=	1'b0;
					output_model24	<=	1'b0;
					output_model25	<=	1'b0;
				end
		endcase
	end
end
endmodule
