`timescale 1ns/1ns

module tb_control_rsa#(parameter W =1024)();

    reg clk=0;
    reg rst=1;
    reg m_rst=0;
    reg [W-1:0] p,q; 
    reg enc_dec;
    reg [W-1:0] key;
    wire [W*2-1:0] data_out;
    wire done;

Top_con_rsa#(W) rsa1(clk,rst,m_rst,p,q,enc_dec,key, data_out,done);

always #5 clk = ~ clk;

initial begin

//p=1024'd524287;q=1024'd131071;
p=1024'd1180591620717411303449;
q=1024'd36893488147419103363;
enc_dec=0;
//key=1024'h2b28_ab09_7eae_f7cf_15d2_154f_16a6_883c;
key=1024'd34569356711213290561763029925585711168973;


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