`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2023 21:45:53
// Design Name: 
// Module Name: simulations
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Register_test( );
    parameter N = 8;
    reg[N-1:0] in;
    reg enable;
    reg[1:0] select;
    reg clock;
    wire [N-1:0] out;
    
    Register #(N)test( in, enable, select, clock, out);
        
    initial begin clock = 0;
        in = 1'b1; select = 2'b01 ;enable = 1; #200; /*Load*/
        in = 1'b1; select = 2'b11 ;enable = 1; #200;/*increment*/
        in = 1'b1; select = 2'b10 ;enable = 1; #200;/*decrement*/
        in = 1'b1; select = 2'b00 ;enable = 1; #200;/*clear*/
        in = 1'b1; select = 2'b01 ;enable = 0; #200;/*retain*/

    end
    
    always begin
        clock = ~ clock; #50;
    end
    
endmodule