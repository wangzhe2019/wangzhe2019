`timescale 1ns/1ns
module system_top_tb;
parameter T = 20;
parameter t = 336;
reg	clk;
reg	rst_n;
reg	learn;
reg	[3:0]in_cnt;
reg	[24:0]random_model;
reg	[25:1]random_synapsis;

wire	[9:0]spike;
initial begin
	clk = 1'b0;
	forever begin
		#(T/2) clk = ~clk;
	end
end
initial begin
	random_synapsis = 25'd0;
	forever begin
		#(T/2) random_synapsis = {$random}%(25'h1ffffff);
	end
	
end
initial begin
	rst_n = 1'b0;
	#(T*2) rst_n = 1'b1;
end
initial begin
		in_cnt = 4'd11;
		learn = 1'b0;
		random_model = 25'd0;
		random_synapsis = 25'd0;
		#(T*2)
		repeat(2) begin
			rand_syn;
			#(T*t*2);
		end
		repeat(10) begin
			learn_to;
		end
		in_cnt = 4'd1;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd2;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd3;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd4;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd5;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd6;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd7;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd8;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd9;
		rand_syn;
		#(T*t*2);
		in_cnt = 4'd10;
		rand_syn;
		#(T*t*2);
		
end
task rand_syn;
	begin
		random_model = {$random}%(25'h1ffffff);
	end
endtask
task learn_to;//学习任务
	begin
		learn = 1;
		rand_syn;
		#(T*t*2);
		learn = 0;
		rand_syn;
		#(T*t*2);
	end
endtask
system_top u0_system_top(
	.clk					(clk),
	.rst_n				(rst_n),
	.learn				(learn),
	.in_cnt				(in_cnt),//输入模型
	.random_model		(random_model),
	.random_synapsis	(random_synapsis),
	
	.spike				(spike)
);
endmodule
