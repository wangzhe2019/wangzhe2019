module uart_test1(		
		input		clk,
		input		rst_n,
		input		[7:0]uart_test,
		input		uart_done,
		
		output	reg spike
);
reg	[5:0]cnt0;
reg 	[5:0]cnt1;//脉宽寄存器
reg 	[5:0]cnt_1;//可调频率寄存器
reg	[27:0]cnt2;//移位寄存器
reg	[27:0]cnt3;//频率计数器
reg	[27:0]cnt4;
reg	[5:0]cnt5;
reg	[5:0]cnt6;
reg	[5:0]cnt7;
reg	[27:0]cnt8;

reg	uart_done1;
reg	uart_done2;
wire	done; 
reg   aa;
//reg  bb;
//reg  cc;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		uart_done1 <= 1'b0;
		uart_done2 <= 1'b0;
	end
	else begin
		uart_done1 <= uart_done;
		uart_done2 <= uart_done1;
	end
end
assign done = ((!uart_done1) & uart_done2)?1:0;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt0 <= 6'd0;
	else if(uart_done == 1'b1)
		cnt0 <= uart_test[5:0];
	else
		cnt0 <= cnt0;
end
always@(posedge clk or negedge rst_n)//脉宽计数
begin
	if(!rst_n)
		cnt1 <= 6'd0;
	else if(uart_test[7:6] == 2'b01)
		cnt1 <= cnt0;
	else 
		cnt1 <= cnt1;
end
//控制信号调频
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_1 <= 6'd0;
	else if(uart_test[7:6] == 2'b10)
		cnt_1 <= cnt0;
	else
		cnt_1 <= cnt_1;
end
always@(posedge clk or negedge rst_n)//按键1和按键0控制的频率变换寄存器
begin
	if(!rst_n)
		cnt2 <= 28'd265;
	else if(uart_test[7:6] == 2'b10)begin
		case(cnt_1)
			1:cnt2 <= 28'd10000_0000;//1hz
			2:cnt2 <= 28'd5000_0000;//2hz
			3:cnt2 <= 28'd1000_0000;//10hz
			4:cnt2 <= 28'd500_0000;//20hz
			5:cnt2 <= 28'd100_0000;//100hz
			6:cnt2 <= 28'd50_0000;//200hz
			7:cnt2 <= 28'd10_0000;//1000hz
			8:cnt2 <= 28'd5_0000;//2000hz
			9:cnt2 <= 28'd10000;//10000hz
			10:cnt2 <= 28'd5000;//20000hz
			11:cnt2 <= 28'd1000;//100000hz
			12:cnt2 <= 28'd500;//200000hz
			13:cnt2 <= 28'd400;
			14:cnt2 <= 28'd300;
			15:cnt2 <= 28'd0;
			default:cnt2 <= cnt2;
		endcase
	end
	else
		cnt2 <= cnt2;
end
always@(posedge clk or negedge rst_n)//频率计数
begin
	if(!rst_n)
		cnt3 <= 28'd0;
	else if(cnt3 == cnt2||done == 1'b1) 
		cnt3 <= 28'd0;
	else 
		cnt3 <= cnt3 + 28'd1;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt4 <= 28'd200;
	else if(done == 1'b1)
		cnt4 <= cnt1 + 28'd200;
	else
		cnt4 <= cnt4;
end
//always@(posedge clk or negedge rst_n)
//begin
//	if(!rst_n)
//		bb <= 1'b0;
//	else if(cnt5 > 6'd0)
//		bb <= 1'b1;
//	else 
//		bb <= 1'b0;
//end
//always@(posedge clk or negedge rst_n)
//begin
//	if(!rst_n)
//		cc <= 1'b0;
//	else if((cnt6 > (cnt5-6'd1))||cnt8 < 28'd10_0000)
//		cc <= 1'b1;
//	else 
//		cc <= 1'b0;
//end

//always@(posedge clk or negedge rst_n)
//begin
//	if(!rst_n)
//		spike <= 1'b0;
//	else if((cnt6 > (cnt5-6'd1)&& cnt5 > 6'd0) ||cnt8 < 28'd10_0000)
//		spike <= 1'b0;
//	else if(cnt3 >= 28'd200 && cnt3 <= cnt4)
//		spike <= 1'b1;
//	else
//		spike <= 1'b0;
//end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		spike <= 1'b0;
	else if((cnt6 > (cnt5-6'd1)&&cnt5 > 6'd0)|| aa == 1'b1||uart_done == 1'b1)//cnt8 > 28'd10_0000
		spike <= 1'b0;
	else if(cnt3 >= 28'd200 && cnt3 <= cnt4)
		spike <= 1'b1;
	else
		spike <= 1'b0;
end
//aa = ((cnt6 > (cnt5-6'd1) ||cnt8 < 28'd10_0000)&& cnt5 > 6'd0)?1:0;
//脉冲计数
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt5 <= 6'd0;
	else if(uart_test[7:6] == 2'b11)
		cnt5 <= cnt0;
	else if(uart_test[7:6] == 2'b10)
		cnt5 <= 6'd0;
	else
		cnt5 <= cnt5;
end
always@(posedge clk or negedge rst_n)//对已经产生脉冲进行计数
begin
	if(!rst_n)
		cnt6 <= 6'd0;
	else if(uart_done == 1'b1)
		cnt6 <= 6'd0;
	else if(cnt6 >= cnt5)
		cnt6 <= cnt5;
	else if((cnt7 == (cnt1-6'd1) && cnt1 > 6'd1)||(cnt1 == 6'd0&&spike == 1'b1)||(cnt1 == 6'd1&&cnt7 == 6'd1))
		cnt6 <= cnt6 + 6'b1;
	else
		cnt6 <= cnt6;
end
always@(posedge clk or negedge rst_n)//辅助块，间隔一定时期，稳定脉冲后计数
begin
	if(!rst_n)
		cnt8 <= 28'd0;
	else if(cnt5 == 6'd0||uart_done == 1'b1)//，
		cnt8 <= 28'd0;
	else if(cnt8 >= 28'd10_0000)
		cnt8 <= 28'd10_0000;
	else
		cnt8 <= cnt8 + 28'd1;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		aa <= 1'b0;
	else if(cnt8 < 28'd10_0000&&cnt8 > 28'd0)
		aa <= 1'b1;
	else
		aa <= 1'b0;
end
//always@(posedge clk or negedge rst_n)//辅助块，辅助一组脉冲产生的频率
//begin
//	if(!rst_n)
//		cnt <= 28'd0;
//	else if(cnt == cnt2 || cnt5 == 6'd0)//修改一次，
//		cnt <= 28'd0;
//	else if(cnt6 >= cnt5)
//		cnt <= cnt + 28'd1;
//	else
//		cnt <= cnt;
//end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt7 <= 6'd0;
	else if(spike == 1'b0)
		cnt7 <= 6'd0;
	else if(spike == 1'b1)
		cnt7 <= cnt7 + 6'd1;
	else 
		cnt7 <= cnt7;
end
endmodule 