/*
module generator#(parameter W=32)(
	input clk,
	input rst,
	input [W-1:0] p,
	input [W-1:0] q,
	output [W*2-1:0] e,
	output [W*2-1:0] d,
	output done
    );
   	reg [W*2-1:0] phi_reg,a,b,t,t_prev;
  	reg [W-1:0] e_reg;
 	   
    	wire [W*2-1:0] phi,Q,b_next,t_next;
    	wire [W-1:0] e_update;

	divider div0(a,b,b_next,Q);
	defparam div0.W = W*2;

	assign phi = (p-1)*(q-1);
	assign t_next = t_prev - Q * t;
	assign e_update = e_reg + 2;

    	assign e = e_reg;
    	assign d = t_prev;

  	reg [2:0] state;

  	localparam FINDING = 3'd1;
	localparam CHECKING = 3'd2;
	localparam FINISHING = 3'd3;

    	assign done = (state == FINISHING) ? 1'b1 : 1'b0;

	always @(posedge clk or negedge rst) begin
		if(~rst) begin
         		phi_reg <= phi;
     			a <= phi;
      			b <= 3;
			e_reg <=3;
      	      		t <= 1;
			t_prev <= 0;
			state = FINDING;
		end 
		else begin
              case(state)
		FINDING: begin
			if(b != 64'd0) begin
				a <= b;
                        	b <= b_next;
                        	t <= t_next;
                        	t_prev <= t;
                        	state <= FINDING;
                    	end
                    	else state <= CHECKING;
			end
		CHECKING: begin
			if(a == 64'd1 && t_prev[W*2-1] == 1'b0) 
				state = FINISHING;
			else begin
				a <= phi_reg;
 				b <= e_update;
				e_reg <= e_update;
				t <= 1;
				t_prev = 0;
				state <= FINDING;
                   	end
			end
                FINISHING: begin
			end
		endcase 
		end
	end

endmodule
*/
module generator#(parameter W=1024)(
	input clk,
	input rst,
	input [W-1:0] p,
	input [W-1:0] q,
	output [W*2-1:0] e,
	output [W*2-1:0] d,
	output done
    );
   	reg [W*2-1:0] phi_reg,a,b,t,t_prev;
  	reg [W-1:0] e_reg;
 	   
    	wire [W*2-1:0] phi,Q,b_next,t_next;
    	wire [W-1:0] e_update;

	divider div0(a,b,b_next,Q);
	defparam div0.W = W*2;

	assign phi = (p-1)*(q-1);
	assign t_next = t_prev - Q * t;
	assign e_update = e_reg + 2;

    	assign e = e_reg;
    	assign d = t_prev;

  	reg [2:0] state;

  	localparam FINDING = 3'd1;
	localparam CHECKING = 3'd2;
	localparam FINISHING = 3'd3;

    	assign done = (state == FINISHING) ? 1'b1 : 1'b0;

	always @(posedge clk or negedge rst) begin
		if(~rst) begin
         		phi_reg <= phi;
     			a <= phi;
      			b <= 3;
			e_reg <=3;
      	      		t <= 1;
			t_prev <= 0;
			state = FINDING;
		end 
		else begin
              case(state)
		FINDING: begin
			if(b != 2048'd0) begin
				a <= b;
                        	b <= b_next;
                        	t <= t_next;
                        	t_prev <= t;
                        	state <= FINDING;
                    	end
                    	else state <= CHECKING;
			end
		CHECKING: begin
			if(a == 2048'd1 && t_prev[W*2-1] == 1'b0) 
				state = FINISHING;
			else begin
				a <= phi_reg;
 				b <= e_update;
				e_reg <= e_update;
				t <= 1;
				t_prev = 0;
				state <= FINDING;
                   	end
			end
                FINISHING: begin
			end
		endcase 
		end
	end

endmodule
