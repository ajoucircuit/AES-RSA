`timescale 1ns/1ns

module tb_Top_aes_rsa#(parameter W=1024)();
	reg clk=0;
	reg rst=1;
	reg m_rst=0;
	reg [W-1:0] p,q;
	reg enc_dec;
	reg [127:0] aes_d_in;
	reg [W-1:0] key;
	wire [W*2-1:0] enc_key;
	wire [127:0] d_out;
	wire done;

Top_aes_rsa#(W) tbtar0(clk,rst,m_rst,p,q,enc_dec,aes_d_in,key,enc_key,d_out,done);

always #5 clk = ~ clk;

initial begin
p=1024'd1180591620717411303449;
q=1024'd36893488147419103363;

enc_dec=1;
aes_d_in=128'h3288_31e0_435a_3137_f630_9807_a88d_a234;
//aes_d_in=128'h3902_dc19_25dc_116a_8409_850b_1dfb_9732;
key=1024'h2b28_ab09_7eae_f7cf_15d2_154f_16a6_883c;
//key=1024'd34569356711213290561763029925585711168973;
#10 
rst = 0;
#10
rst = 1;
#500
m_rst = 1;
#10
m_rst = 0;

end

endmodule


