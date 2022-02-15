
module divider#(parameter W = 1024)(
	input [W-1:0] a,
	input [W-1:0] b,
	output [W-1:0] r,
	output [W-1:0] q
    );

	reg [W-1:0] A,B;
	reg [W-1:0] temp;   

	integer i;

	assign r = temp,q = A;
  
	always@ (a or b) begin
		A = a;
		B = b;
		temp = 0;
		for(i=0;i < W;i=i+1) begin 
			temp = {temp[W-2:0],A[W-1]};
			A = A<<1;
			temp = temp - B;
		if(temp[W-1] == 1)begin
			A[0] = 1'b0;
			temp = temp + B;   
			end
		else
			A[0] = 1'b1;
      		end
         
	end    
endmodule

/*

module divider#(parameter W = 32)(
	input [W-1:0] a,
	input [W-1:0] b,
	output [W-1:0] r,
	output [W-1:0] q
    );

	reg [W-1:0] A,B;
	reg [W-1:0] temp;   

	integer i;

	assign r = temp,q = A;
  
	always@ (a or b) begin
		A = a;
		B = b;
		temp = 0;
		for(i=0;i < W;i=i+1) begin 
			temp = {temp[W-2:0],A[W-1]};
			A = A<<1;
			temp = temp - B;
		if(temp[W-1] == 1)begin
			A[0] = 1'b0;
			temp = temp + B;   
			end
		else
			A[0] = 1'b1;
      		end
         
	end    
endmodule
*/