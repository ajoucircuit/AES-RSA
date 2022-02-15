module control_aes
(
	input clk,
	input rst,
	input [127:0] d_in,
	input [127:0] key,
	input enc_dec,
	output reg[127:0] d_out
);

	reg [127:0] e_d_in; //enc
	reg [127:0] d_d_in; //dec

	wire [127:0] e_d_out; //enc
	wire [127:0] d_d_out; //dec

always @(posedge clk or negedge rst) begin
	if(~rst) begin
		e_d_in <= 128'b0;
		d_d_in <= 128'b0;
	end
	else if(enc_dec) begin
		e_d_in <= d_in;
		d_out <= e_d_out;
	end
	else begin
		d_d_in <= d_in;
		d_out <= d_d_out;
	end
		
end

aes_encipher caes0(clk,e_d_in,key,e_d_out);
aes_decipher caes1(clk,d_d_in,key,d_d_out);

endmodule
