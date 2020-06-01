module ferq_top 
#(
	parameter  CLK_FREQ = 50000000,       //定义系统时钟频率
	parameter  UART_BPS = 115200)         //定义串口波特率
(
	input 	clk,
	input		sys_rst_n,
   input    uart_rxd,         //UART接收端口
   
	output   uart_txd,          //UART发送端口
	output	spike
);
wire       uart_en_w;                 //UART发送使能
wire 		  [7:0]uart_data_w;               //UART发送数据

wire		  pll_l;
wire		  locked;
wire		  rst_n;

assign rst_n = sys_rst_n & locked;
uart_recv #(                          //串口接收模块
    .CLK_FREQ       (CLK_FREQ),       //设置系统时钟频率
    .UART_BPS       (UART_BPS))       //设置串口接收波特率
u0_uart_recv(                 
    .sys_clk        (clk), 
    .sys_rst_n      (sys_rst_n),
    
    .uart_rxd       (uart_rxd),
    .uart_done      (uart_en_w),
    .uart_data      (uart_data_w)
);
    
uart_send #(                          //串口发送模块
    .CLK_FREQ       (CLK_FREQ),       //设置系统时钟频率
    .UART_BPS       (UART_BPS))       //设置串口发送波特率
u0_uart_send(                 
    .sys_clk        (clk),
    .sys_rst_n      (sys_rst_n),
     
    .uart_en        (uart_en_w),
    .uart_din       (uart_data_w),
    .uart_txd       (uart_txd)
);
pll u0_pll(
		.areset			(~sys_rst_n),//锁相环是高电平复位
		.inclk0			(clk),
		.c0				(pll_l),		//锁相环输出频率
		.locked			(locked)	//锁相环输出是否稳定信号(低电平还未稳定)
);
uart_test1 u0_uart_test1(		
	 .clk				  	(pll_l),
	 .rst_n			  	(rst_n),
	 .uart_test      	(uart_data_w),
	 .uart_done		  	(uart_en_w),
			
	 .spike			  	(spike)	
);	 
endmodule 