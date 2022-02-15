module round_key(rcnt,key,keyout,clk);		//round key module, key generator : key -> keyout
    
	input clk;
	input [3:0] rcnt;
	input [127:0]key;
	output [127:0]keyout;
   
	wire [31:0] w0,w1,w2,w3,tem;
	wire [127:0]tem0,tem1;

	reg [127:0] mem;

	always @(posedge clk) begin		//input key 1clk delay  key -> mem
		mem <= key;
	end

	function [127:0] rearrng(input [127:0] matrix);	//re arrange function
	begin

	rearrng[127:120] = matrix[127:120];
	rearrng[119:112] = matrix[95:88];
	rearrng[111:104] = matrix[63:56];
	rearrng[103:96] = matrix[31:24];
	rearrng[95:88] = matrix[119:112];
	rearrng[87:80] = matrix[87:80];
	rearrng[79:72] = matrix[55:48];
	rearrng[71:64] = matrix[23:16];
	rearrng[63:56] = matrix[111:104];
	rearrng[55:48] = matrix[79:72];
	rearrng[47:40] = matrix[47:40];
	rearrng[39:32] = matrix[15:8];
	rearrng[31:24] = matrix[103:96];
	rearrng[23:16] = matrix[71:64];
	rearrng[15:8] = matrix[39:32];
	rearrng[7:0] = matrix[7:0];

	end
	endfunction

	assign tem0 = rearrng(mem);	//input key rearrange  mem -> tem0
              
	assign w0 = tem0[127:96];	//column w0
	assign w1 = tem0[95:64];	//column w1
	assign w2 = tem0[63:32];	//column w2
	assign w3 = tem0[31:0];		//column w3
             
	assign tem1[127:96]= w0 ^ tem ^ rcon(rcnt);			//w0 xor tem(w3 rot word -> subbyte) xor rcon : next round key w0_n
	assign tem1[95:64] = w0 ^ tem ^ rcon(rcnt)^ w1;			//w0_1 xor w1 : next roundkey w1_n
	assign tem1[63:32] = w0 ^ tem ^ rcon(rcnt)^ w1 ^ w2;		//w1_n xor w2 : next roundkey w2_n
	assign tem1[31:0]  = w0 ^ tem ^ rcon(rcnt)^ w1 ^ w2 ^ w3;	//w2_n xor w3 : next roundkey w3_n
									//tem1 : w0_n, w1_n, w2_n, w3_n
	sbox a1(.A({w3[23:0],w3[31:24]}),.B(tem[31:0]));		//w3 rot word -> subbyte : tem

	assign keyout = rearrng(tem1);   //next roundkey tem1 rearrange
       
	function [31:0]	rcon;	//rcon function
	input	[3:0]	rcnt;	//round count
		case(rcnt)	
		4'b0000: rcon=32'h01_00_00_00;
		4'b0001: rcon=32'h02_00_00_00;
		4'b0010: rcon=32'h04_00_00_00;
		4'b0011: rcon=32'h08_00_00_00;
		4'b0100: rcon=32'h10_00_00_00;
		4'b0101: rcon=32'h20_00_00_00;
		4'b0110: rcon=32'h40_00_00_00;
		4'b0111: rcon=32'h80_00_00_00;
		4'b1000: rcon=32'h1b_00_00_00;
		4'b1001: rcon=32'h36_00_00_00;
		default: rcon=32'h00_00_00_00;
		endcase

	endfunction

endmodule

module mix_col(A,B,clk);	//mix column + mix column cal : A->B

	input clk;
	input [127:0]A;
	output [127:0]B;

	wire [127:0]tem0;

	reg [127:0]tem1;

	function [127:0] rearrng(input [127:0] matrix);	//re arrange function
	begin

	rearrng[127:120] = matrix[127:120];
	rearrng[119:112] = matrix[95:88];
	rearrng[111:104] = matrix[63:56];
	rearrng[103:96] = matrix[31:24];
	rearrng[95:88] = matrix[119:112];
	rearrng[87:80] = matrix[87:80];
	rearrng[79:72] = matrix[55:48];
	rearrng[71:64] = matrix[23:16];
	rearrng[63:56] = matrix[111:104];
	rearrng[55:48] = matrix[79:72];
	rearrng[47:40] = matrix[47:40];
	rearrng[39:32] = matrix[15:8];
	rearrng[31:24] = matrix[103:96];
	rearrng[23:16] = matrix[71:64];
	rearrng[15:8] = matrix[39:32];
	rearrng[7:0] = matrix[7:0];

	end
	endfunction

	assign tem0 = rearrng(A);	//input A rearrange -> tem0

	function [7 : 0] gm2(input [7 : 0] op);
	begin
		gm2 = {op[6 : 0], 1'b0} ^ (8'h1b & {8{op[7]}});	//If MSB=1, xor 8'b00011011  / If MSB=0, xor 8'b00000000
	end
	endfunction	// gm2

	function [7 : 0] gm3(input [7 : 0] op);
	begin
		gm3 = gm2(op) ^ op;	//2+1
	end
	endfunction	// gm3

	function [31 : 0] mixw(input [31 : 0] w);
		reg [7 : 0] b0, b1, b2, b3;
		reg [7 : 0] mb0, mb1, mb2, mb3;
	begin
		b0 = w[31 : 24]; //8bit b0
		b1 = w[23 : 16]; //8bit b1
		b2 = w[15 : 08]; //8bit b2
		b3 = w[07 : 00]; //8bit b3

		mb0 = gm2(b0) ^ gm3(b1) ^ b2      ^ b3;		//first row cal
		mb1 = b0      ^ gm2(b1) ^ gm3(b2) ^ b3;		//secound row cal
		mb2 = b0      ^ b1      ^ gm2(b2) ^ gm3(b3);	//third row cal
		mb3 = gm3(b0) ^ b1      ^ b2      ^ gm2(b3);	//fourth row cal

		mixw = {mb0, mb1, mb2, mb3};	//Bit Concatenation
	end
	endfunction	// mixw

	function [127 : 0] mixcolumns(input [127 : 0] data);   //128bit mix column
		reg [31 : 0] w0, w1, w2, w3;
		reg [31 : 0] ws0, ws1, ws2, ws3;
	begin
		w0 = data[127 : 096]; //32bit w0
		w1 = data[095 : 064]; //32bit w1
		w2 = data[063 : 032]; //32bit w2
		w3 = data[031 : 000]; //32bit w3

		ws0 = mixw(w0); //w0 calculation
		ws1 = mixw(w1); //w1 calculation
		ws2 = mixw(w2); //w2 calculation
		ws3 = mixw(w3); //w3 calculation

		mixcolumns = {ws0, ws1, ws2, ws3};	//Bit Concatenation
	end
	endfunction	// mixcolumns
       
	always @(posedge clk) begin
		tem1 <= mixcolumns(tem0);	//1clk delay and mixcolumn start : tem0 -> tem1
	end

	assign B = rearrng(tem1);	//tem1 rearrange -> output B

endmodule

module subbytes (A,B,clk);	//subbyte : A->B

	input clk;
	input [127:0]A;
	output [127:0]B;

	reg [127:0] C;

	always @(posedge clk) begin
 		C <= A;		//1clk delay : A->C
	end

sbox subb0(C[127:96], B[127:96]);	//sbox module instantiation : C->B
sbox subb1(C[95:64], B[95:64]);
sbox subb2(C[63:32], B[63:32]);
sbox subb3(C[31:0], B[31:0]);

endmodule

module shftrows(A,B,clk);	//shift row : A->B

	input clk;
	input [127:0]A;
	output reg [127:0]B;

	always @(posedge clk) begin	//1clk delay 

	B[127:96] <= A[127:96];   
	B[95:64] <= {A[87:64],A[95:88]};	// <-1
	B[63:32] <= {A[47:32],A[63:48]};	// <-2
	B[31:0] <= {A[7:0],A[31:8]};		// <-3

	end

endmodule

module rounds(clk,rcnt,M,keyin,keyout,E);	//round module

	input clk;
	input [3:0]rcnt;
	input [127:0]M;
	input [127:0]keyin;
	output [127:0]keyout;
	output [127:0]E;

	wire [127:0] A,B,C;

round_key r0(rcnt,keyin,keyout,clk);	//roundkey instantiation : keyin -> keyout
subbytes r1(M,A,clk);			//subbyte instantiation : M -> A
shftrows r2(A,B,clk);			//shift row instantiation : A -> B
mix_col r3(B,C,clk);			//mix column instantiation : B -> C
assign E= keyout^C;			//add round key : C xor keyout -> E

endmodule

module rounndlast(clk,rcnt,A,last_key,F);	//last round module

	input clk;
	input [3:0]rcnt;
	input [127:0]A;
	input [127:0]last_key;
	output [127:0]F;

	wire [127:0] B,C,E;

round_key t0(rcnt,last_key,E,clk);	//roundkey instantiation : last_key -> E
subbytes t1(A,B,clk);			//subbyte instantiation : A -> B
shftrows t2(B,C,clk);			//shiftrow instantiation : B -> C
assign F= E^C;				//add round key : E xor C -> F

endmodule