module debounce_switch (
    input   i_clk,
    input   i_switch,
    output  o_switch
);
    parameter C_DEBOUNCE_LIMIT = 1_000; // 1000_000
    reg        r_prev_state = 1'b0;
    reg [10:0] r_count = 0;              // 20

    always @(posedge i_clk ) begin
        if ( (i_switch != r_prev_state) && (r_count < C_DEBOUNCE_LIMIT) )
            r_count <= r_count + 1;

        else if (r_count == C_DEBOUNCE_LIMIT) begin
            r_count <= 0;
            r_prev_state <= i_switch;
        end

        else
            r_count <= 0;
    end

    assign o_switch = r_prev_state;

endmodule

module top(clk, data_in, key, dataout, sig_in, sig_out);   //top moudle for dividing input and output

	input clk;
	input sig_in, sig_out;
	input [7:0] data_in;             //8bit input
	input [7:0] key;                 //8bit input

	output reg [15:0] dataout;       //16bit output

	reg [127:0] data_buf, key_buf;
	wire [127:0] dout_buf;
	wire deb_sft, deb_in, deb_out; 	

	integer cnt=4'b0000;      //output signal count(cnt) initial set

	function [15:0] d_out (input [127:0] in);   //d_out function : 128bit input(output data) -> 8bit output
		case(cnt)
		4'b0001: d_out=in[127:112];
		4'b0010: d_out=in[111:96];
		4'b0011: d_out=in[95:80];
		4'b0100: d_out=in[79:64];
		4'b0101: d_out=in[63:48];
		4'b0110: d_out=in[47:32];
		4'b0111: d_out=in[31:16];
		4'b1000: d_out=in[15:0];
		endcase
 	endfunction

debounce_switch dbcr1(clk, sig_in, deb_in);
debounce_switch dbcr2(clk, sig_out, deb_out);

always @(posedge deb_in) begin

	data_buf <= data_buf<<8;
	key_buf <= key_buf<<8;
	data_buf[7:0] <= data_in;
	key_buf[7:0] <= key;

end

always @(posedge deb_out) begin     //if sig_out == 1 -> cnt increase and 16bit data print
	cnt = cnt+4'b0001;
	dataout = d_out(dout_buf);
end

aes_encipher new0(.clk(clk),.datain(data_buf),.key(key_buf),.dataout(dout_buf));  //encryption module instantiation 

endmodule

module aes_encipher(clk,datain,key,dataout);   //encryption module : 128 bit datain -> 128 bit dataout

	input clk;
	input [127:0] datain;
	input [127:0] key;
	output [127:0] dataout;

	reg [127:0]k_in;
	reg [127:0]f_k_in;
	reg [127:0]r_in;
   	reg [127:0]f_r_in;
	reg [3:0] num;

	wire [127:0]k_out;
	wire [127:0]r_out;

	integer i = 0;

	always @(posedge clk) begin
		if(i == 0) begin
			num = 4'b0000;
			r_in = datain^key;
			k_in = key;
			i = i+1;
		end
		else if(i == 36) begin
			i = 0;
			num = 4'b0000;
			f_k_in = k_out;
			f_r_in = r_out;
		end
		else if(i%4 == 0) begin
			num = num + 4'b0001;
			k_in = k_out;
			r_in = r_out;
			i = i+1;
		end
		else begin
			i = i+1;
		end
	end

   rounds r0(.clk(clk),.rcnt(num),.M(r_in),.keyin(k_in),.keyout(k_out),.E(r_out));

   rounndlast r10(.clk(clk),.rcnt(4'b1001),.A(f_r_in),.last_key(f_k_in),.F(dataout));    

endmodule
   




