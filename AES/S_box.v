module mul_GF2_2(A,B,C);	//GF(2^2)

	input [1:0] A, B;
	output [1:0] C;

	assign C = { ((A[1]^A[0])&(B[1]^B[0]))^(A[0]&B[0]) , (A[1]&B[1])^(A[0]&B[0]) };

endmodule

module mul_GF2_4(A,B,C);	//GF(2^2^2)

	input [3:0] A, B;
	output [3:0] C;

	wire [1:0] b1, b2, c1, c2, c3, d1, d2, d3;

	assign b1 = A[3:2] ^ A[1:0];
	assign b2 = B[3:2] ^ B[1:0];

	mul_GF2_2 mul0(A[3:2], B[3:2], c1);
	mul_GF2_2 mul1(b1, b2, c2);
	mul_GF2_2 mul2(A[1:0], B[1:0], c3);

	assign d1 = {(c1[1]^c1[0]),c1[1]}  ;
	assign d2 = c2 ^ c3;
	assign d3 = d1 ^ c3;

	assign C = { d2, d3 };

endmodule

module x_invrs(A, B);		//4bit inverse transform
	input [3:0]A;
	output reg [3:0]B;

	always @(A) 
		case(A)
		4'b0000 : B = 4'b0000;
		4'b0001 : B = 4'b0001;
		4'b0010 : B = 4'b0011;
		4'b0011 : B = 4'b0010;
		4'b0100 : B = 4'b1111;
		4'b0101 : B = 4'b1100;
		4'b0110 : B = 4'b1001;
		4'b0111 : B = 4'b1011;
		4'b1000 : B = 4'b1010;
		4'b1001 : B = 4'b0110;
		4'b1010 : B = 4'b1000;
		4'b1011 : B = 4'b0111;
		4'b1100 : B = 4'b0101;
		4'b1101 : B = 4'b1110;
		4'b1110 : B = 4'b1101;
		4'b1111 : B = 4'b0100;
		default : B = 4'b0000;
		endcase
endmodule


module mul_invrs(A,C);		//8bit inverse transform

	input [7:0]A;
	output [7:0]C;

	wire [3:0] a1, a2, b1, b2, b3, c1, c2, d1, d2;

	assign a1 = A[7:4];
	assign a2 = A[3:0];
	
	assign b1 = { (a1[2] ^ a1[1] ^ a1[0]) , (a1[3] ^ a1[0]) , a1[3] , (a1[3] ^ a1[2]) };
	assign b2 = a1 ^ a2;

	mul_GF2_4 mul0(b2, a2, b3);

	assign c1 = b1 ^ b3;

	x_invrs inv(c1, c2);

	mul_GF2_4 mul1(a1, c2, d1); 
	mul_GF2_4 mul2(c2, b2, d2);

	assign C = { d1, d2 };

endmodule

module transf(A, B);		//field extension transform

	input [7:0]A;
	output [7:0]B;

	reg del[0:7][0:7];

always @(A) begin

	del[0][0]=1'b1; del[0][1]=1'b1; del[0][2]=1'b0; del[0][3]=1'b0; del[0][4]=1'b0; del[0][5]=1'b0; del[0][6]=1'b1; del[0][7]=1'b0;
	del[1][0]=1'b0; del[1][1]=1'b1; del[1][2]=1'b0; del[1][3]=1'b0; del[1][4]=1'b1; del[1][5]=1'b0; del[1][6]=1'b1; del[1][7]=1'b0;
	del[2][0]=1'b0; del[2][1]=1'b1; del[2][2]=1'b1; del[2][3]=1'b1; del[2][4]=1'b1; del[2][5]=1'b0; del[2][6]=1'b0; del[2][7]=1'b1;
	del[3][0]=1'b0; del[3][1]=1'b1; del[3][2]=1'b1; del[3][3]=1'b0; del[3][4]=1'b0; del[3][5]=1'b0; del[3][6]=1'b1; del[3][7]=1'b1;
	del[4][0]=1'b0; del[4][1]=1'b1; del[4][2]=1'b1; del[4][3]=1'b1; del[4][4]=1'b0; del[4][5]=1'b1; del[4][6]=1'b0; del[4][7]=1'b1;
	del[5][0]=1'b0; del[5][1]=1'b0; del[5][2]=1'b1; del[5][3]=1'b1; del[5][4]=1'b0; del[5][5]=1'b1; del[5][6]=1'b0; del[5][7]=1'b1;
	del[6][0]=1'b0; del[6][1]=1'b1; del[6][2]=1'b1; del[6][3]=1'b1; del[6][4]=1'b1; del[6][5]=1'b0; del[6][6]=1'b1; del[6][7]=1'b1;
	del[7][0]=1'b0; del[7][1]=1'b0; del[7][2]=1'b0; del[7][3]=1'b0; del[7][4]=1'b0; del[7][5]=1'b1; del[7][6]=1'b0; del[7][7]=1'b1;

end

	assign B[0]=(del[0][0]& A[0])^(del[0][1]&A[1])^(del[0][2]&A[2])^(del[0][3]&A[3])^(del[0][4]&A[4])^(del[0][5]&A[5])^(del[0][6]&A[6])^(del[0][7]&A[7]);
	assign B[1]=(del[1][0]& A[0])^(del[1][1]&A[1])^(del[1][2]&A[2])^(del[1][3]&A[3])^(del[1][4]&A[4])^(del[1][5]&A[5])^(del[1][6]&A[6])^(del[1][7]&A[7]); 
	assign B[2]=(del[2][0]& A[0])^(del[2][1]&A[1])^(del[2][2]&A[2])^(del[2][3]&A[3])^(del[2][4]&A[4])^(del[2][5]&A[5])^(del[2][6]&A[6])^(del[2][7]&A[7]);
	assign B[3]=(del[3][0]& A[0])^(del[3][1]&A[1])^(del[3][2]&A[2])^(del[3][3]&A[3])^(del[3][4]&A[4])^(del[3][5]&A[5])^(del[3][6]&A[6])^(del[3][7]&A[7]);
	assign B[4]=(del[4][0]& A[0])^(del[4][1]&A[1])^(del[4][2]&A[2])^(del[4][3]&A[3])^(del[4][4]&A[4])^(del[4][5]&A[5])^(del[4][6]&A[6])^(del[4][7]&A[7]);
	assign B[5]=(del[5][0]& A[0])^(del[5][1]&A[1])^(del[5][2]&A[2])^(del[5][3]&A[3])^(del[5][4]&A[4])^(del[5][5]&A[5])^(del[5][6]&A[6])^(del[5][7]&A[7]);
	assign B[6]=(del[6][0]& A[0])^(del[6][1]&A[1])^(del[6][2]&A[2])^(del[6][3]&A[3])^(del[6][4]&A[4])^(del[6][5]&A[5])^(del[6][6]&A[6])^(del[6][7]&A[7]);
	assign B[7]=(del[7][0]& A[0])^(del[7][1]&A[1])^(del[7][2]&A[2])^(del[7][3]&A[3])^(del[7][4]&A[4])^(del[7][5]&A[5])^(del[7][6]&A[6])^(del[7][7]&A[7]);

endmodule

module invrs_transf (A, B);	//inverse field extension transform

	input [7:0]A;
	output [7:0]B;

	reg delin[0:7][0:7];

always @(A) begin

	delin[0][0]=1'b1; delin[0][1]=1'b0; delin[0][2]=1'b1; delin[0][3]=1'b0; delin[0][4]=1'b1; delin[0][5]=1'b1; delin[0][6]=1'b1; delin[0][7]=1'b0;
	delin[1][0]=1'b0; delin[1][1]=1'b0; delin[1][2]=1'b0; delin[1][3]=1'b0; delin[1][4]=1'b1; delin[1][5]=1'b1; delin[1][6]=1'b0; delin[1][7]=1'b0;
	delin[2][0]=1'b0; delin[2][1]=1'b1; delin[2][2]=1'b1; delin[2][3]=1'b1; delin[2][4]=1'b1; delin[2][5]=1'b0; delin[2][6]=1'b0; delin[2][7]=1'b1;
	delin[3][0]=1'b0; delin[3][1]=1'b1; delin[3][2]=1'b1; delin[3][3]=1'b1; delin[3][4]=1'b1; delin[3][5]=1'b1; delin[3][6]=1'b0; delin[3][7]=1'b0;
	delin[4][0]=1'b0; delin[4][1]=1'b1; delin[4][2]=1'b1; delin[4][3]=1'b0; delin[4][4]=1'b1; delin[4][5]=1'b1; delin[4][6]=1'b1; delin[4][7]=1'b0;
	delin[5][0]=1'b0; delin[5][1]=1'b1; delin[5][2]=1'b0; delin[5][3]=1'b0; delin[5][4]=1'b0; delin[5][5]=1'b1; delin[5][6]=1'b1; delin[5][7]=1'b0;
	delin[6][0]=1'b0; delin[6][1]=1'b0; delin[6][2]=1'b1; delin[6][3]=1'b0; delin[6][4]=1'b0; delin[6][5]=1'b0; delin[6][6]=1'b1; delin[6][7]=1'b0;
	delin[7][0]=1'b0; delin[7][1]=1'b1; delin[7][2]=1'b0; delin[7][3]=1'b0; delin[7][4]=1'b0; delin[7][5]=1'b1; delin[7][6]=1'b1; delin[7][7]=1'b1;


end

	assign B[0]=(delin[0][0]& A[0])^(delin[0][1]&A[1])^(delin[0][2]&A[2])^(delin[0][3]&A[3])^(delin[0][4]&A[4])^(delin[0][5]&A[5])^(delin[0][6]&A[6])^(delin[0][7]&A[7]);
	assign B[1]=(delin[1][0]& A[0])^(delin[1][1]&A[1])^(delin[1][2]&A[2])^(delin[1][3]&A[3])^(delin[1][4]&A[4])^(delin[1][5]&A[5])^(delin[1][6]&A[6])^(delin[1][7]&A[7]); 
	assign B[2]=(delin[2][0]& A[0])^(delin[2][1]&A[1])^(delin[2][2]&A[2])^(delin[2][3]&A[3])^(delin[2][4]&A[4])^(delin[2][5]&A[5])^(delin[2][6]&A[6])^(delin[2][7]&A[7]);
	assign B[3]=(delin[3][0]& A[0])^(delin[3][1]&A[1])^(delin[3][2]&A[2])^(delin[3][3]&A[3])^(delin[3][4]&A[4])^(delin[3][5]&A[5])^(delin[3][6]&A[6])^(delin[3][7]&A[7]);
	assign B[4]=(delin[4][0]& A[0])^(delin[4][1]&A[1])^(delin[4][2]&A[2])^(delin[4][3]&A[3])^(delin[4][4]&A[4])^(delin[4][5]&A[5])^(delin[4][6]&A[6])^(delin[4][7]&A[7]);
	assign B[5]=(delin[5][0]& A[0])^(delin[5][1]&A[1])^(delin[5][2]&A[2])^(delin[5][3]&A[3])^(delin[5][4]&A[4])^(delin[5][5]&A[5])^(delin[5][6]&A[6])^(delin[5][7]&A[7]);
	assign B[6]=(delin[6][0]& A[0])^(delin[6][1]&A[1])^(delin[6][2]&A[2])^(delin[6][3]&A[3])^(delin[6][4]&A[4])^(delin[6][5]&A[5])^(delin[6][6]&A[6])^(delin[6][7]&A[7]);
	assign B[7]=(delin[7][0]& A[0])^(delin[7][1]&A[1])^(delin[7][2]&A[2])^(delin[7][3]&A[3])^(delin[7][4]&A[4])^(delin[7][5]&A[5])^(delin[7][6]&A[6])^(delin[7][7]&A[7]);

endmodule

module affin_transf (A, B);	//affin transform

	input [7:0]A;
	output [7:0]B;

	wire [7:0]C;

	reg aff[0:7][0:7];

always @(A) begin

	aff[0][0]=1'b1; aff[0][1]=1'b1; aff[0][2]=1'b1; aff[0][3]=1'b1; aff[0][4]=1'b1; aff[0][5]=1'b0; aff[0][6]=1'b0; aff[0][7]=1'b0;
	aff[1][0]=1'b0; aff[1][1]=1'b1; aff[1][2]=1'b1; aff[1][3]=1'b1; aff[1][4]=1'b1; aff[1][5]=1'b1; aff[1][6]=1'b0; aff[1][7]=1'b0;
	aff[2][0]=1'b0; aff[2][1]=1'b0; aff[2][2]=1'b1; aff[2][3]=1'b1; aff[2][4]=1'b1; aff[2][5]=1'b1; aff[2][6]=1'b1; aff[2][7]=1'b0;
	aff[3][0]=1'b0; aff[3][1]=1'b0; aff[3][2]=1'b0; aff[3][3]=1'b1; aff[3][4]=1'b1; aff[3][5]=1'b1; aff[3][6]=1'b1; aff[3][7]=1'b1;
	aff[4][0]=1'b1; aff[4][1]=1'b0; aff[4][2]=1'b0; aff[4][3]=1'b0; aff[4][4]=1'b1; aff[4][5]=1'b1; aff[4][6]=1'b1; aff[4][7]=1'b1;
	aff[5][0]=1'b1; aff[5][1]=1'b1; aff[5][2]=1'b0; aff[5][3]=1'b0; aff[5][4]=1'b0; aff[5][5]=1'b1; aff[5][6]=1'b1; aff[5][7]=1'b1;
	aff[6][0]=1'b1; aff[6][1]=1'b1; aff[6][2]=1'b1; aff[6][3]=1'b0; aff[6][4]=1'b0; aff[6][5]=1'b0; aff[6][6]=1'b1; aff[6][7]=1'b1;
	aff[7][0]=1'b1; aff[7][1]=1'b1; aff[7][2]=1'b1; aff[7][3]=1'b1; aff[7][4]=1'b0; aff[7][5]=1'b0; aff[7][6]=1'b0; aff[7][7]=1'b1;

end

	assign C[7]=(aff[0][0]& A[7])^(aff[0][1]&A[6])^(aff[0][2]&A[5])^(aff[0][3]&A[4])^(aff[0][4]&A[3])^(aff[0][5]&A[2])^(aff[0][6]&A[1])^(aff[0][7]&A[0]);
	assign C[6]=(aff[1][0]& A[7])^(aff[1][1]&A[6])^(aff[1][2]&A[5])^(aff[1][3]&A[4])^(aff[1][4]&A[3])^(aff[1][5]&A[2])^(aff[1][6]&A[1])^(aff[1][7]&A[0]); 
	assign C[5]=(aff[2][0]& A[7])^(aff[2][1]&A[6])^(aff[2][2]&A[5])^(aff[2][3]&A[4])^(aff[2][4]&A[3])^(aff[2][5]&A[2])^(aff[2][6]&A[1])^(aff[2][7]&A[0]);
	assign C[4]=(aff[3][0]& A[7])^(aff[3][1]&A[6])^(aff[3][2]&A[5])^(aff[3][3]&A[4])^(aff[3][4]&A[3])^(aff[3][5]&A[2])^(aff[3][6]&A[1])^(aff[3][7]&A[0]);
	assign C[3]=(aff[4][0]& A[7])^(aff[4][1]&A[6])^(aff[4][2]&A[5])^(aff[4][3]&A[4])^(aff[4][4]&A[3])^(aff[4][5]&A[2])^(aff[4][6]&A[1])^(aff[4][7]&A[0]);
	assign C[2]=(aff[5][0]& A[7])^(aff[5][1]&A[6])^(aff[5][2]&A[5])^(aff[5][3]&A[4])^(aff[5][4]&A[3])^(aff[5][5]&A[2])^(aff[5][6]&A[1])^(aff[5][7]&A[0]);
	assign C[1]=(aff[6][0]& A[7])^(aff[6][1]&A[6])^(aff[6][2]&A[5])^(aff[6][3]&A[4])^(aff[6][4]&A[3])^(aff[6][5]&A[2])^(aff[6][6]&A[1])^(aff[6][7]&A[0]);
	assign C[0]=(aff[7][0]& A[7])^(aff[7][1]&A[6])^(aff[7][2]&A[5])^(aff[7][3]&A[4])^(aff[7][4]&A[3])^(aff[7][5]&A[2])^(aff[7][6]&A[1])^(aff[7][7]&A[0]);

	assign B[7]=C[7]^1'b0;
	assign B[6]=C[6]^1'b1;
	assign B[5]=C[5]^1'b1;
	assign B[4]=C[4]^1'b0;
	assign B[3]=C[3]^1'b0;
	assign B[2]=C[2]^1'b0;
	assign B[1]=C[1]^1'b1;
	assign B[0]=C[0]^1'b1;

endmodule

module invrs_affin_transf (A, B);     //inverse affin transform

	input [7:0]A;
	output [7:0]B;

	wire [7:0]C;
	
	reg inaff[0:7][0:7];

always @(A) begin

	inaff[0][0]=1'b0; inaff[0][1]=1'b1; inaff[0][2]=1'b0; inaff[0][3]=1'b1; inaff[0][4]=1'b0; inaff[0][5]=1'b0; inaff[0][6]=1'b1; inaff[0][7]=1'b0;
	inaff[1][0]=1'b0; inaff[1][1]=1'b0; inaff[1][2]=1'b1; inaff[1][3]=1'b0; inaff[1][4]=1'b1; inaff[1][5]=1'b0; inaff[1][6]=1'b0; inaff[1][7]=1'b1;
	inaff[2][0]=1'b1; inaff[2][1]=1'b0; inaff[2][2]=1'b0; inaff[2][3]=1'b1; inaff[2][4]=1'b0; inaff[2][5]=1'b1; inaff[2][6]=1'b0; inaff[2][7]=1'b0;
	inaff[3][0]=1'b0; inaff[3][1]=1'b1; inaff[3][2]=1'b0; inaff[3][3]=1'b0; inaff[3][4]=1'b1; inaff[3][5]=1'b0; inaff[3][6]=1'b1; inaff[3][7]=1'b0;
	inaff[4][0]=1'b0; inaff[4][1]=1'b0; inaff[4][2]=1'b1; inaff[4][3]=1'b0; inaff[4][4]=1'b0; inaff[4][5]=1'b1; inaff[4][6]=1'b0; inaff[4][7]=1'b1;
	inaff[5][0]=1'b1; inaff[5][1]=1'b0; inaff[5][2]=1'b0; inaff[5][3]=1'b1; inaff[5][4]=1'b0; inaff[5][5]=1'b0; inaff[5][6]=1'b1; inaff[5][7]=1'b0;
	inaff[6][0]=1'b0; inaff[6][1]=1'b1; inaff[6][2]=1'b0; inaff[6][3]=1'b0; inaff[6][4]=1'b1; inaff[6][5]=1'b0; inaff[6][6]=1'b0; inaff[6][7]=1'b1;
	inaff[7][0]=1'b1; inaff[7][1]=1'b0; inaff[7][2]=1'b1; inaff[7][3]=1'b0; inaff[7][4]=1'b0; inaff[7][5]=1'b1; inaff[7][6]=1'b0; inaff[7][7]=1'b0;

end

	assign C[7]=(inaff[0][0]& A[7])^(inaff[0][1]&A[6])^(inaff[0][2]&A[5])^(inaff[0][3]&A[4])^(inaff[0][4]&A[3])^(inaff[0][5]&A[2])^(inaff[0][6]&A[1])^(inaff[0][7]&A[0]);
	assign C[6]=(inaff[1][0]& A[7])^(inaff[1][1]&A[6])^(inaff[1][2]&A[5])^(inaff[1][3]&A[4])^(inaff[1][4]&A[3])^(inaff[1][5]&A[2])^(inaff[1][6]&A[1])^(inaff[1][7]&A[0]); 
	assign C[5]=(inaff[2][0]& A[7])^(inaff[2][1]&A[6])^(inaff[2][2]&A[5])^(inaff[2][3]&A[4])^(inaff[2][4]&A[3])^(inaff[2][5]&A[2])^(inaff[2][6]&A[1])^(inaff[2][7]&A[0]);
	assign C[4]=(inaff[3][0]& A[7])^(inaff[3][1]&A[6])^(inaff[3][2]&A[5])^(inaff[3][3]&A[4])^(inaff[3][4]&A[3])^(inaff[3][5]&A[2])^(inaff[3][6]&A[1])^(inaff[3][7]&A[0]);
	assign C[3]=(inaff[4][0]& A[7])^(inaff[4][1]&A[6])^(inaff[4][2]&A[5])^(inaff[4][3]&A[4])^(inaff[4][4]&A[3])^(inaff[4][5]&A[2])^(inaff[4][6]&A[1])^(inaff[4][7]&A[0]);
	assign C[2]=(inaff[5][0]& A[7])^(inaff[5][1]&A[6])^(inaff[5][2]&A[5])^(inaff[5][3]&A[4])^(inaff[5][4]&A[3])^(inaff[5][5]&A[2])^(inaff[5][6]&A[1])^(inaff[5][7]&A[0]);
	assign C[1]=(inaff[6][0]& A[7])^(inaff[6][1]&A[6])^(inaff[6][2]&A[5])^(inaff[6][3]&A[4])^(inaff[6][4]&A[3])^(inaff[6][5]&A[2])^(inaff[6][6]&A[1])^(inaff[6][7]&A[0]);
	assign C[0]=(inaff[7][0]& A[7])^(inaff[7][1]&A[6])^(inaff[7][2]&A[5])^(inaff[7][3]&A[4])^(inaff[7][4]&A[3])^(inaff[7][5]&A[2])^(inaff[7][6]&A[1])^(inaff[7][7]&A[0]);

	assign B[7]=C[7]^1'b0;
	assign B[6]=C[6]^1'b0;
	assign B[5]=C[5]^1'b0;
	assign B[4]=C[4]^1'b0;
	assign B[3]=C[3]^1'b0;
	assign B[2]=C[2]^1'b1;
	assign B[1]=C[1]^1'b0;
	assign B[0]=C[0]^1'b1;

endmodule

module sbox (A, B);		//32bit sbox -> 8 character, 1 row

	input [31:0]A;
	output [31:0]B;

	wire [31:0]C;
	wire [31:0]D;
	wire [31:0]E;

transf trans0(.A(A[31:24]),.B(C[31:24]));		//field extension transform
mul_invrs s_box0(.A(C[31:24]),.C(D[31:24]));		//8bit inverse transform
invrs_transf intrans0(.A(D[31:24]),.B(E[31:24]));	//inverse field extension transform
affin_transf affin0(.A(E[31:24]),.B(B[31:24]));		//affin transform

transf trans1(.A(A[23:16]),.B(C[23:16])); 
mul_invrs s_box1(.A(C[23:16]),.C(D[23:16]));
invrs_transf intrans1(.A(D[23:16]),.B(E[23:16]));
affin_transf affin1(.A(E[23:16]),.B(B[23:16]));

transf trans2(.A(A[15:8]),.B(C[15:8])); 
mul_invrs s_box2(.A(C[15:8]),.C(D[15:8]));
invrs_transf intrans2(.A(D[15:8]),.B(E[15:8]));
affin_transf affin2(.A(E[15:8]),.B(B[15:8]));

transf trans3(.A(A[7:0]),.B(C[7:0])); 
mul_invrs s_box3(.A(C[7:0]),.C(D[7:0]));
invrs_transf intrans3(.A(D[7:0]),.B(E[7:0]));
affin_transf affin3(.A(E[7:0]),.B(B[7:0]));

endmodule

module invrs_sbox (A, B);	//32bit inverse sbox for deciper

	input [31:0]A;
	output [31:0]B;

	wire [31:0]C;
	wire [31:0]D;
	wire [31:0]E;

invrs_affin_transf inaffin4(.A(A[31:24]),.B(C[31:24]));	//inverse affin transform
transf trans4(.A(C[31:24]),.B(D[31:24]));		//field extension transform
mul_invrs s_box4(.A(D[31:24]),.C(E[31:24]));		//8bit inverse transform
invrs_transf intrans4(.A(E[31:24]),.B(B[31:24]));	//inverse field extension transform

invrs_affin_transf inaffin5(.A(A[23:16]),.B(C[23:16]));
transf trans5(.A(C[23:16]),.B(D[23:16]));
mul_invrs s_box5(.A(D[23:16]),.C(E[23:16]));
invrs_transf intrans5(.A(E[23:16]),.B(B[23:16]));

invrs_affin_transf inaffin6(.A(A[15:8]),.B(C[15:8]));
transf trans6(.A(C[15:8]),.B(D[15:8]));
mul_invrs s_box6(.A(D[15:8]),.C(E[15:8]));
invrs_transf intrans6(.A(E[15:8]),.B(B[15:8]));

invrs_affin_transf inaffin7(.A(A[7:0]),.B(C[7:0]));
transf trans7(.A(C[7:0]),.B(D[7:0]));
mul_invrs s_box7(.A(D[7:0]),.C(E[7:0]));
invrs_transf intrans7(.A(E[7:0]),.B(B[7:0]));

endmodule

/*
module sbox(A,B);

  input [31:0]A;
  output [31:0]B;

  wire [7:0] sbox [0:255];

  assign B[31:24] = sbox[A[31:24]];
  assign B[23:16] = sbox[A[23:16]];
  assign B[15:08] = sbox[A[15:08]];
  assign B[7:0] = sbox[A[7:0]];

  assign sbox[8'h00] = 8'h63;
  assign sbox[8'h01] = 8'h7c;
  assign sbox[8'h02] = 8'h77;
  assign sbox[8'h03] = 8'h7b;
  assign sbox[8'h04] = 8'hf2;
  assign sbox[8'h05] = 8'h6b;
  assign sbox[8'h06] = 8'h6f;
  assign sbox[8'h07] = 8'hc5;
  assign sbox[8'h08] = 8'h30;
  assign sbox[8'h09] = 8'h01;
  assign sbox[8'h0a] = 8'h67;
  assign sbox[8'h0b] = 8'h2b;
  assign sbox[8'h0c] = 8'hfe;
  assign sbox[8'h0d] = 8'hd7;
  assign sbox[8'h0e] = 8'hab;
  assign sbox[8'h0f] = 8'h76;
  assign sbox[8'h10] = 8'hca;
  assign sbox[8'h11] = 8'h82;
  assign sbox[8'h12] = 8'hc9;
  assign sbox[8'h13] = 8'h7d;
  assign sbox[8'h14] = 8'hfa;
  assign sbox[8'h15] = 8'h59;
  assign sbox[8'h16] = 8'h47;
  assign sbox[8'h17] = 8'hf0;
  assign sbox[8'h18] = 8'had;
  assign sbox[8'h19] = 8'hd4;
  assign sbox[8'h1a] = 8'ha2;
  assign sbox[8'h1b] = 8'haf;
  assign sbox[8'h1c] = 8'h9c;
  assign sbox[8'h1d] = 8'ha4;
  assign sbox[8'h1e] = 8'h72;
  assign sbox[8'h1f] = 8'hc0;
  assign sbox[8'h20] = 8'hb7;
  assign sbox[8'h21] = 8'hfd;
  assign sbox[8'h22] = 8'h93;
  assign sbox[8'h23] = 8'h26;
  assign sbox[8'h24] = 8'h36;
  assign sbox[8'h25] = 8'h3f;
  assign sbox[8'h26] = 8'hf7;
  assign sbox[8'h27] = 8'hcc;
  assign sbox[8'h28] = 8'h34;
  assign sbox[8'h29] = 8'ha5;
  assign sbox[8'h2a] = 8'he5;
  assign sbox[8'h2b] = 8'hf1;
  assign sbox[8'h2c] = 8'h71;
  assign sbox[8'h2d] = 8'hd8;
  assign sbox[8'h2e] = 8'h31;
  assign sbox[8'h2f] = 8'h15;
  assign sbox[8'h30] = 8'h04;
  assign sbox[8'h31] = 8'hc7;
  assign sbox[8'h32] = 8'h23;
  assign sbox[8'h33] = 8'hc3;
  assign sbox[8'h34] = 8'h18;
  assign sbox[8'h35] = 8'h96;
  assign sbox[8'h36] = 8'h05;
  assign sbox[8'h37] = 8'h9a;
  assign sbox[8'h38] = 8'h07;
  assign sbox[8'h39] = 8'h12;
  assign sbox[8'h3a] = 8'h80;
  assign sbox[8'h3b] = 8'he2;
  assign sbox[8'h3c] = 8'heb;
  assign sbox[8'h3d] = 8'h27;
  assign sbox[8'h3e] = 8'hb2;
  assign sbox[8'h3f] = 8'h75;
  assign sbox[8'h40] = 8'h09;
  assign sbox[8'h41] = 8'h83;
  assign sbox[8'h42] = 8'h2c;
  assign sbox[8'h43] = 8'h1a;
  assign sbox[8'h44] = 8'h1b;
  assign sbox[8'h45] = 8'h6e;
  assign sbox[8'h46] = 8'h5a;
  assign sbox[8'h47] = 8'ha0;
  assign sbox[8'h48] = 8'h52;
  assign sbox[8'h49] = 8'h3b;
  assign sbox[8'h4a] = 8'hd6;
  assign sbox[8'h4b] = 8'hb3;
  assign sbox[8'h4c] = 8'h29;
  assign sbox[8'h4d] = 8'he3;
  assign sbox[8'h4e] = 8'h2f;
  assign sbox[8'h4f] = 8'h84;
  assign sbox[8'h50] = 8'h53;
  assign sbox[8'h51] = 8'hd1;
  assign sbox[8'h52] = 8'h00;
  assign sbox[8'h53] = 8'hed;
  assign sbox[8'h54] = 8'h20;
  assign sbox[8'h55] = 8'hfc;
  assign sbox[8'h56] = 8'hb1;
  assign sbox[8'h57] = 8'h5b;
  assign sbox[8'h58] = 8'h6a;
  assign sbox[8'h59] = 8'hcb;
  assign sbox[8'h5a] = 8'hbe;
  assign sbox[8'h5b] = 8'h39;
  assign sbox[8'h5c] = 8'h4a;
  assign sbox[8'h5d] = 8'h4c;
  assign sbox[8'h5e] = 8'h58;
  assign sbox[8'h5f] = 8'hcf;
  assign sbox[8'h60] = 8'hd0;
  assign sbox[8'h61] = 8'hef;
  assign sbox[8'h62] = 8'haa;
  assign sbox[8'h63] = 8'hfb;
  assign sbox[8'h64] = 8'h43;
  assign sbox[8'h65] = 8'h4d;
  assign sbox[8'h66] = 8'h33;
  assign sbox[8'h67] = 8'h85;
  assign sbox[8'h68] = 8'h45;
  assign sbox[8'h69] = 8'hf9;
  assign sbox[8'h6a] = 8'h02;
  assign sbox[8'h6b] = 8'h7f;
  assign sbox[8'h6c] = 8'h50;
  assign sbox[8'h6d] = 8'h3c;
  assign sbox[8'h6e] = 8'h9f;
  assign sbox[8'h6f] = 8'ha8;
  assign sbox[8'h70] = 8'h51;
  assign sbox[8'h71] = 8'ha3;
  assign sbox[8'h72] = 8'h40;
  assign sbox[8'h73] = 8'h8f;
  assign sbox[8'h74] = 8'h92;
  assign sbox[8'h75] = 8'h9d;
  assign sbox[8'h76] = 8'h38;
  assign sbox[8'h77] = 8'hf5;
  assign sbox[8'h78] = 8'hbc;
  assign sbox[8'h79] = 8'hb6;
  assign sbox[8'h7a] = 8'hda;
  assign sbox[8'h7b] = 8'h21;
  assign sbox[8'h7c] = 8'h10;
  assign sbox[8'h7d] = 8'hff;
  assign sbox[8'h7e] = 8'hf3;
  assign sbox[8'h7f] = 8'hd2;
  assign sbox[8'h80] = 8'hcd;
  assign sbox[8'h81] = 8'h0c;
  assign sbox[8'h82] = 8'h13;
  assign sbox[8'h83] = 8'hec;
  assign sbox[8'h84] = 8'h5f;
  assign sbox[8'h85] = 8'h97;
  assign sbox[8'h86] = 8'h44;
  assign sbox[8'h87] = 8'h17;
  assign sbox[8'h88] = 8'hc4;
  assign sbox[8'h89] = 8'ha7;
  assign sbox[8'h8a] = 8'h7e;
  assign sbox[8'h8b] = 8'h3d;
  assign sbox[8'h8c] = 8'h64;
  assign sbox[8'h8d] = 8'h5d;
  assign sbox[8'h8e] = 8'h19;
  assign sbox[8'h8f] = 8'h73;
  assign sbox[8'h90] = 8'h60;
  assign sbox[8'h91] = 8'h81;
  assign sbox[8'h92] = 8'h4f;
  assign sbox[8'h93] = 8'hdc;
  assign sbox[8'h94] = 8'h22;
  assign sbox[8'h95] = 8'h2a;
  assign sbox[8'h96] = 8'h90;
  assign sbox[8'h97] = 8'h88;
  assign sbox[8'h98] = 8'h46;
  assign sbox[8'h99] = 8'hee;
  assign sbox[8'h9a] = 8'hb8;
  assign sbox[8'h9b] = 8'h14;
  assign sbox[8'h9c] = 8'hde;
  assign sbox[8'h9d] = 8'h5e;
  assign sbox[8'h9e] = 8'h0b;
  assign sbox[8'h9f] = 8'hdb;
  assign sbox[8'ha0] = 8'he0;
  assign sbox[8'ha1] = 8'h32;
  assign sbox[8'ha2] = 8'h3a;
  assign sbox[8'ha3] = 8'h0a;
  assign sbox[8'ha4] = 8'h49;
  assign sbox[8'ha5] = 8'h06;
  assign sbox[8'ha6] = 8'h24;
  assign sbox[8'ha7] = 8'h5c;
  assign sbox[8'ha8] = 8'hc2;
  assign sbox[8'ha9] = 8'hd3;
  assign sbox[8'haa] = 8'hac;
  assign sbox[8'hab] = 8'h62;
  assign sbox[8'hac] = 8'h91;
  assign sbox[8'had] = 8'h95;
  assign sbox[8'hae] = 8'he4;
  assign sbox[8'haf] = 8'h79;
  assign sbox[8'hb0] = 8'he7;
  assign sbox[8'hb1] = 8'hc8;
  assign sbox[8'hb2] = 8'h37;
  assign sbox[8'hb3] = 8'h6d;
  assign sbox[8'hb4] = 8'h8d;
  assign sbox[8'hb5] = 8'hd5;
  assign sbox[8'hb6] = 8'h4e;
  assign sbox[8'hb7] = 8'ha9;
  assign sbox[8'hb8] = 8'h6c;
  assign sbox[8'hb9] = 8'h56;
  assign sbox[8'hba] = 8'hf4;
  assign sbox[8'hbb] = 8'hea;
  assign sbox[8'hbc] = 8'h65;
  assign sbox[8'hbd] = 8'h7a;
  assign sbox[8'hbe] = 8'hae;
  assign sbox[8'hbf] = 8'h08;
  assign sbox[8'hc0] = 8'hba;
  assign sbox[8'hc1] = 8'h78;
  assign sbox[8'hc2] = 8'h25;
  assign sbox[8'hc3] = 8'h2e;
  assign sbox[8'hc4] = 8'h1c;
  assign sbox[8'hc5] = 8'ha6;
  assign sbox[8'hc6] = 8'hb4;
  assign sbox[8'hc7] = 8'hc6;
  assign sbox[8'hc8] = 8'he8;
  assign sbox[8'hc9] = 8'hdd;
  assign sbox[8'hca] = 8'h74;
  assign sbox[8'hcb] = 8'h1f;
  assign sbox[8'hcc] = 8'h4b;
  assign sbox[8'hcd] = 8'hbd;
  assign sbox[8'hce] = 8'h8b;
  assign sbox[8'hcf] = 8'h8a;
  assign sbox[8'hd0] = 8'h70;
  assign sbox[8'hd1] = 8'h3e;
  assign sbox[8'hd2] = 8'hb5;
  assign sbox[8'hd3] = 8'h66;
  assign sbox[8'hd4] = 8'h48;
  assign sbox[8'hd5] = 8'h03;
  assign sbox[8'hd6] = 8'hf6;
  assign sbox[8'hd7] = 8'h0e;
  assign sbox[8'hd8] = 8'h61;
  assign sbox[8'hd9] = 8'h35;
  assign sbox[8'hda] = 8'h57;
  assign sbox[8'hdb] = 8'hb9;
  assign sbox[8'hdc] = 8'h86;
  assign sbox[8'hdd] = 8'hc1;
  assign sbox[8'hde] = 8'h1d;
  assign sbox[8'hdf] = 8'h9e;
  assign sbox[8'he0] = 8'he1;
  assign sbox[8'he1] = 8'hf8;
  assign sbox[8'he2] = 8'h98;
  assign sbox[8'he3] = 8'h11;
  assign sbox[8'he4] = 8'h69;
  assign sbox[8'he5] = 8'hd9;
  assign sbox[8'he6] = 8'h8e;
  assign sbox[8'he7] = 8'h94;
  assign sbox[8'he8] = 8'h9b;
  assign sbox[8'he9] = 8'h1e;
  assign sbox[8'hea] = 8'h87;
  assign sbox[8'heb] = 8'he9;
  assign sbox[8'hec] = 8'hce;
  assign sbox[8'hed] = 8'h55;
  assign sbox[8'hee] = 8'h28;
  assign sbox[8'hef] = 8'hdf;
  assign sbox[8'hf0] = 8'h8c;
  assign sbox[8'hf1] = 8'ha1;
  assign sbox[8'hf2] = 8'h89;
  assign sbox[8'hf3] = 8'h0d;
  assign sbox[8'hf4] = 8'hbf;
  assign sbox[8'hf5] = 8'he6;
  assign sbox[8'hf6] = 8'h42;
  assign sbox[8'hf7] = 8'h68;
  assign sbox[8'hf8] = 8'h41;
  assign sbox[8'hf9] = 8'h99;
  assign sbox[8'hfa] = 8'h2d;
  assign sbox[8'hfb] = 8'h0f;
  assign sbox[8'hfc] = 8'hb0;
  assign sbox[8'hfd] = 8'h54;
  assign sbox[8'hfe] = 8'hbb;
  assign sbox[8'hff] = 8'h16;

endmodule 
*/