

module top_dec(clk, data_in, key, dataout, sig_sft, sig_in, sig_out);   //top_dec moudle for dividing input and output

input clk;
input sig_sft, sig_in, sig_out;
input [7:0] data_in;             //8bit input
input [7:0] key;                 //8bit input

output reg [15:0] dataout;       //16bit output

reg [127:0] data_buf, key_buf;
wire [127:0] dout_buf;

integer cnt=4'b0000;      //output signal count(cnt) initial set

task in_shft;
    output [127:0]O;
    input [127:0]I;
    begin
        O=I<<8;
    end
endtask


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

always @( sig_sft or sig_in or sig_out) begin  //always start
 
 if(sig_in == 1) begin       //if sig_in == 1 -> 8bit data and key input
  data_buf[7:0] <= data_in;
  key_buf[7:0] <= key;
 end 

 if(sig_sft == 1) begin     //if sig_sft == 1 -> shift data in buffer
  in_shft(data_buf,data_buf);
  in_shft(key_buf,key_buf);
 end


if(sig_out == 1) begin     //if sig_out == 1 -> cnt increase and 16bit data print
  cnt = cnt+1;
  dataout = d_out(dout_buf);
end
  
end

aes_decipher new1(.clk(clk),.datain(data_buf),.key(key_buf),.dataout(dout_buf));  //decryption module instantiation

endmodule

module aes_decipher(clk,datain,key,dataout);   //decyrption module : 128 bit datain -> 128 bit dataout

	input clk;
	input [127:0] datain;
	input [127:0] key;
	output[127:0] dataout;

	wire [127:0] r0_out;
	wire [127:0] r1_out,r2_out,r3_out,r4_out,r5_out,r6_out,r7_out,r8_out,r9_out;
    
	wire [127:0] keyout1,keyout2,keyout3,keyout4,keyout5,keyout6,keyout7,keyout8,keyout9,keyout10;
	
	round_key rk1(.rcnt(4'b0000),.key(key),.keyout(keyout1),.clk(clk));       //first roundkey start
	round_key rk2(.rcnt(4'b0001),.key(keyout1),.keyout(keyout2),.clk(clk));
	round_key rk3(.rcnt(4'b0010),.key(keyout2),.keyout(keyout3),.clk(clk));
	round_key rk4(.rcnt(4'b0011),.key(keyout3),.keyout(keyout4),.clk(clk));
	round_key rk5(.rcnt(4'b0100),.key(keyout4),.keyout(keyout5),.clk(clk));
	round_key rk6(.rcnt(4'b0101),.key(keyout5),.keyout(keyout6),.clk(clk));
	round_key rk7(.rcnt(4'b0110),.key(keyout6),.keyout(keyout7),.clk(clk));
	round_key rk8(.rcnt(4'b0111),.key(keyout7),.keyout(keyout8),.clk(clk));
	round_key rk9(.rcnt(4'b1000),.key(keyout8),.keyout(keyout9),.clk(clk));
	round_key rk10(.rcnt(4'b1001),.key(keyout9),.keyout(keyout10),.clk(clk));  //last roundkey start
 
	assign r0_out = datain^keyout10;   //add roundkey : chiper datain xor last key
	 
	roundsi ri1(.clk(clk),.M(r0_out),.keyin(keyout9),.E(r1_out));      //first round start
	roundsi ri2(.clk(clk),.M(r1_out),.keyin(keyout8),.E(r2_out));
	roundsi ri3(.clk(clk),.M(r2_out),.keyin(keyout7),.E(r3_out));
	roundsi ri4(.clk(clk),.M(r3_out),.keyin(keyout6),.E(r4_out));
	roundsi ri5(.clk(clk),.M(r4_out),.keyin(keyout5),.E(r5_out));
	roundsi ri6(.clk(clk),.M(r5_out),.keyin(keyout4),.E(r6_out));
	roundsi ri7(.clk(clk),.M(r6_out),.keyin(keyout3),.E(r7_out));
	roundsi ri8(.clk(clk),.M(r7_out),.keyin(keyout2),.E(r8_out));
	roundsi ri9(.clk(clk),.M(r8_out),.keyin(keyout1),.E(r9_out));
	rounndlasti ri10(.clk(clk),.A(r9_out),.last_key(key),.F(dataout));  //last round start
 
endmodule
