module Top_con_rsa#(parameter W=1024)(clk,rst,m_rst,p,q,enc_dec,key,rsa_d_o,done);
	input clk;
	input rst;
	input m_rst;
	input [W-1:0] p,q;
	input enc_dec; //1-enc / 0-dec
	input [W-1:0] key;
	output [W*2-1:0] rsa_d_o;
	output done;

	wire [W-1:0] rsa_d_in;

assign rsa_d_in = key;

Top_rsa#(W) aesrsa4(clk,rst,m_rst,p,q,enc_dec,rsa_d_in,rsa_d_o,done);

endmodule

module Top_rsa#(parameter W=1024)(
	input clk,
	input rst,
	input m_rst,
	input [W-1:0] p,q, 
	input enc_dec,
	input [W-1:0] data_in,
	output [W*2-1:0] data_out,
	output done
    );
	reg [W*2-1:0] key_reg,data_reg,n_reg;
    
	wire gen_done;
	wire [W*2-1:0] e,d,n,key;

	assign key = enc_dec?e:d;
	assign n = p*q;
	
	always @(posedge clk)begin
		key_reg <= key;
		n_reg <= n;
		data_reg <= data_in;
	end
    
	generator#(W) gen(clk,rst,p,q,e,d,gen_done);
	enc_dec_msg#(W) edm(clk,m_rst,data_reg,n_reg,key_reg,done,data_out);
    
endmodule
/*
module Top_rsa#(parameter W=32)(
	input clk,
	input rst,
	input m_rst,
	input [W-1:0] p,q, 
	input enc_dec,
	input [W-1:0] data_in,
	output [W*2-1:0] data_out,
	output done
    );
	reg [W*2-1:0] key_reg,data_reg,n_reg;
    
	wire gen_done;
	wire [W*2-1:0] e,d,n,key;

	assign key = enc_dec?e:d;
	assign n = p*q;
	
	always @(posedge clk)begin
		key_reg <= key;
		n_reg <= n;
		data_reg <= data_in;
	end
    
	generator#(W) gen(clk,rst,p,q,e,d,gen_done);
	enc_dec_msg#(W) edm(clk,m_rst,data_reg,n_reg,key_reg,done,data_out);
    
endmodule
*/
