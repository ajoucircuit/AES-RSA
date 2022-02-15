
module enc_dec_msg#(parameter W=1024)(
	input clk,
	input rst,
	input [W*2-1:0] message, 
	input [W*2-1:0] modulo,
	input [W*2-1:0] key,
	output done,
	output [W*2-1:0] final_message
    );

	localparam CALC = 2'd1;
	localparam FINISHING = 2'd2;
    
	reg [W*2-1:0] message_reg,modulo_reg,key_reg,f_reg;	
	reg [1:0] state;
    
	wire [W*2-1:0] f_prime, f_prime_next;
	wire [W*2-1:0] f_squared, f_next;
	wire [W*2-1:0] dump0, dump1;

	assign f_prime = message_reg * f_reg * f_reg;   
	assign f_squared = f_reg * f_reg;
	assign final_message = f_reg;

	assign done = (state == FINISHING) ? 1'b1:1'b0;

	wire [W*2-1:0] key_next = key_reg << 1;

	reg [10:0] i;
    
	divider dvd0(f_squared,modulo_reg,f_next,dump0);                  	
	defparam dvd0.W = W*2; 
                                                                               	
	divider dvd1 (f_prime,modulo_reg,f_prime_next,dump1);        	
	defparam dvd1.W = W*2;  
    
   
	always @(posedge clk or posedge rst) begin
	i<=i+11'd1;
		if(rst) begin                                                      
			message_reg <= message;
			modulo_reg <= modulo;
			key_reg <= key;   
			f_reg <= 2048'd1;             
			state <= CALC;
			i <= 11'd0;
        	end 	
        	else begin
		case(state)
		CALC: begin
			if (key_reg != 2048'd0 || i != 11'd2048) begin
				f_reg <= f_next;
                    		if (key_reg[W*2-1])
					f_reg <= f_prime_next;
				key_reg <= key_next;
				state <= CALC;
                		end
			
			else  state <= FINISHING;
			end
            
		FINISHING: begin
			end
		
		endcase
		end
	end
endmodule
/*
module enc_dec_msg#(parameter W=32)(
	input clk,
	input rst,
	input [W*2-1:0] message, 
	input [W*2-1:0] modulo,
	input [W*2-1:0] key,
	output done,
	output [W*2-1:0] final_message
    );

	localparam CALC = 2'd1;
	localparam FINISHING = 2'd2;
    
	reg [W*2-1:0] message_reg,modulo_reg,key_reg,f_reg;	
	reg [1:0] state;
    
	wire [W*2-1:0] f_prime, f_prime_next;
	wire [W*2-1:0] f_squared, f_next;
	wire [W*2-1:0] dump0, dump1;

	assign f_prime = message_reg * f_reg * f_reg;   
	assign f_squared = f_reg * f_reg;
	assign final_message = f_reg;

	assign done = (state == FINISHING) ? 1'b1:1'b0;

	wire [W*2-1:0] key_next = key_reg << 1;

	reg [7:0] i;
    
	divider dvd0(f_squared,modulo_reg,f_next,dump0);                  	
	defparam dvd0.W = W*2; 
                                                                               	
	divider dvd1 (f_prime,modulo_reg,f_prime_next,dump1);        	
	defparam dvd1.W = W*2;  
    
   
	always @(posedge clk or posedge rst) begin
	i<=i+8'd1;
		if(rst) begin                                                      
			message_reg <= message;
			modulo_reg <= modulo;
			key_reg <= key;   
			f_reg <= 64'd1;             
			state <= CALC;
			i <= 8'd0;
        	end 	
        	else begin
		case(state)
		CALC: begin
			if (key_reg != 64'd0 || i != 8'd64) begin
				f_reg <= f_next;
                    		if (key_reg[W*2-1])
					f_reg <= f_prime_next;
				key_reg <= key_next;
				state <= CALC;
                		end
			
			else  state <= FINISHING;
			end
            
		FINISHING: begin
			end
		
		endcase
		end
	end
endmodule
*/

