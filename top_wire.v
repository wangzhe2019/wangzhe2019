module top_wire(
	input 	clk,
	input 	rst_n,
	input		learn,
	input		[25:1]random_synapsis,
	input		out_inhi0,
	input		out_inhi1,
	input		out_inhi2,
	input		out_inhi3,
	input		out_inhi4,
	input		out_inhi5,
	input		out_inhi6,
	input		out_inhi7,
	input		out_inhi8,
	input		out_inhi9,
	
	output	inhibition0,
	output	inhibition1,
	output	inhibition2,
	output	inhibition3,
	output	inhibition4,
	output	inhibition5,
	output	inhibition6,
	output	inhibition7,
	output	inhibition8,
	output	inhibition9,
	output	reg [25:1]random_synapsis0,
	output   reg [25:1]random_synapsis1,
	output   reg [25:1]random_synapsis2,
	output   reg [25:1]random_synapsis3,
	output   reg [25:1]random_synapsis4,
	output   reg [25:1]random_synapsis5,
	output   reg [25:1]random_synapsis6,
	output   reg [25:1]random_synapsis7,
	output   reg [25:1]random_synapsis8,
	output   reg [25:1]random_synapsis9
);

reg [3:0]cnt;
//突触的随机性选择
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt <= 4'd0;
	else if(cnt == 4'd10)
		cnt <= 4'd0;
	else
		cnt <= cnt + 4'd1;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		 random_synapsis0 <= 25'd0;
		 random_synapsis1 <= 25'd0;
		 random_synapsis2 <= 25'd0;
		 random_synapsis3 <= 25'd0;
		 random_synapsis4 <= 25'd0;
		 random_synapsis5 <= 25'd0;
		 random_synapsis6 <= 25'd0;
		 random_synapsis7 <= 25'd0;
		 random_synapsis8 <= 25'd0;
		 random_synapsis9 <= 25'd0;
	end
	else if(learn == 1'b0)begin
		case(cnt)
			1:random_synapsis0 <= random_synapsis;
			2:random_synapsis1 <= random_synapsis;
			3:random_synapsis2 <= random_synapsis;
			4:random_synapsis3 <= random_synapsis;
			5:random_synapsis4 <= random_synapsis;
			6:random_synapsis5 <= random_synapsis;
			7:random_synapsis6 <= random_synapsis;
			8:random_synapsis7 <= random_synapsis;
			9:random_synapsis8 <= random_synapsis;
			10:random_synapsis9 <= random_synapsis;
		endcase
	end
end
//横向抑制信号的产生
assign inhibition0 = out_inhi1|out_inhi2|out_inhi3|out_inhi4|out_inhi5|out_inhi6|out_inhi7|out_inhi8|out_inhi9;
assign inhibition1 = out_inhi0|out_inhi2|out_inhi3|out_inhi4|out_inhi5|out_inhi6|out_inhi7|out_inhi8|out_inhi9;
assign inhibition2 = out_inhi1|out_inhi0|out_inhi3|out_inhi4|out_inhi5|out_inhi6|out_inhi7|out_inhi8|out_inhi9;
assign inhibition3 = out_inhi1|out_inhi2|out_inhi0|out_inhi4|out_inhi5|out_inhi6|out_inhi7|out_inhi8|out_inhi9;
assign inhibition4 = out_inhi1|out_inhi2|out_inhi3|out_inhi0|out_inhi5|out_inhi6|out_inhi7|out_inhi8|out_inhi9;
assign inhibition5 = out_inhi1|out_inhi2|out_inhi3|out_inhi4|out_inhi0|out_inhi6|out_inhi7|out_inhi8|out_inhi9;
assign inhibition6 = out_inhi1|out_inhi2|out_inhi3|out_inhi4|out_inhi5|out_inhi0|out_inhi7|out_inhi8|out_inhi9;
assign inhibition7 = out_inhi1|out_inhi2|out_inhi3|out_inhi4|out_inhi5|out_inhi6|out_inhi0|out_inhi8|out_inhi9;
assign inhibition8 = out_inhi1|out_inhi2|out_inhi3|out_inhi4|out_inhi5|out_inhi6|out_inhi7|out_inhi0|out_inhi9;
assign inhibition9 = out_inhi1|out_inhi2|out_inhi3|out_inhi4|out_inhi5|out_inhi6|out_inhi7|out_inhi8|out_inhi0;
endmodule
